import time
from collections.abc import Callable
from dataclasses import dataclass
from pathlib import Path

from pyk.kast.inner import KInner
from pyk.kast.outer import KClaim
from pyk.kcfg import KCFG
from pyk.kcfg.kcfg import NodeIdLike
from pyk.kore.rpc import LogEntry
from pyk.prelude.collections import LIST

from ..ast.mx import (
    ACCOUNTS_PATH,
    CALL_STACK_PATH,
    CODE,
    INTERIM_STATES_PATH,
    cfg_changes_call_stack,
    cfg_changes_interim_states,
    cfg_touches_code,
    command_is_new_wasm_instance,
    get_first_command_name,
    get_first_instr,
    get_first_instr_name,
    get_first_k_name,
    get_hostcall_name,
)
from ..timing import Timer
from ..tools import Tools
from .cell_abstracter import CellAbstracter, multi_cell_abstracter, single_cell_abstracter
from .implication import quick_implication_check
from .printers import print_node
from .wasm_krun_initializer import WasmKrunInitializer

CUT_POINT_RULES = [
    # This runs with the LLVM backend
    'ELROND-CONFIG.newWasmInstance',
]

CALL_STACK_CUT_POINT_RULES = [
    # These change the call stack
    'ELROND-NODE.pushCallState',
    'ELROND-NODE.popCallState',
    'ELROND-NODE.dropCallState',
    'KASMER.endFoundryImmediately',
]

INTERIM_STATES_CUT_POINT_RULES = [
    # These use interimStates
    'ELROND-NODE.pushWorldState',
    'ELROND-NODE.popWorldState',
    'ELROND-NODE.dropWorldState',
    'KASMER.endFoundryImmediately',
]

CODE_CUT_POINT_RULES = [
    # These use the <code> cell
    'ELROND-CONFIG.setAccountFields',
    'ELROND-CONFIG.setAccountCode',
    'ELROND-CONFIG.callContract',
    'ELROND-CONFIG.callContract-not-contract',
    'MANDOS.checkAccountCodeAux-no-code',
    'MANDOS.checkAccountCodeAux-code',
    'BASEOPS.checkIsSmartContract-code',
    'BASEOPS.checkIsSmartContract-no-code',
    # Additional <code> cell use through generic <account> and <accounts> use.
    'ELROND-CONFIG.createAccount-new',
    'ELROND-NODE.pushWorldState',
    'ELROND-NODE.popWorldState',
]


def abstracters(
    target_node_id: NodeIdLike,
) -> list[tuple[CellAbstracter, list[str], Callable[[str | None, str | None, str | None], bool]]]:
    return [
        (
            single_cell_abstracter(
                cell_path=CALL_STACK_PATH,
                variable_root='AbstractCallStack',
                variable_sort=LIST,
                destination=target_node_id,
            ),
            CALL_STACK_CUT_POINT_RULES,
            cfg_changes_call_stack,
        ),
        (
            single_cell_abstracter(
                cell_path=INTERIM_STATES_PATH,
                variable_root='AbstractInterimStates',
                variable_sort=LIST,
                destination=target_node_id,
            ),
            INTERIM_STATES_CUT_POINT_RULES,
            cfg_changes_interim_states,
        ),
        (
            multi_cell_abstracter(
                parent_path=ACCOUNTS_PATH,
                cell_name='<code>',
                variable_root='AbstractCode',
                variable_sort=CODE,
                destination=target_node_id,
            ),
            CODE_CUT_POINT_RULES,
            cfg_touches_code,
        ),
    ]


@dataclass(frozen=True)
class RunClaimResult:
    kcfg: KCFG


@dataclass(frozen=True)
class Stuck(RunClaimResult):
    stuck_node_id: NodeIdLike
    final_node_id: NodeIdLike


@dataclass(frozen=True)
class Success(RunClaimResult):
    pass


@dataclass(frozen=True)
class RunException(RunClaimResult):
    exception: BaseException
    last_processed_node: NodeIdLike


def abstract(abstracters: list[CellAbstracter], kcfg: KCFG, node_id: NodeIdLike) -> None:
    for a in abstracters:
        a.abstract_node(kcfg, node_id)


def concretize(abstracters: list[CellAbstracter], kcfg: KCFG, with_variable: set[NodeIdLike]) -> None:
    for a in reversed(abstracters):
        a.concretize_kcfg(kcfg, with_variable)


def touches_abstract_content(
    identifiers: list[Callable[[str | None, str | None, str | None], bool]], root: KInner
) -> bool:
    command = get_first_command_name(root)
    instr = get_first_instr_name(root)
    k = get_first_k_name(root)
    for identifier in identifiers:
        if identifier(k, command, instr):
            return True
    return False


def run_claim(
    tools: Tools,
    wasm_initializer: WasmKrunInitializer,
    claim: KClaim,
    restart_kcfg: KCFG | None,
    kcfg_path: Path | None,
    run_id: int | None,
    depth: int,
    iterations: int,
) -> RunClaimResult:
    last_processed_node: NodeIdLike = -1
    init_node_id: NodeIdLike = -1
    target_node_id: NodeIdLike = -1
    if restart_kcfg:
        kcfg = restart_kcfg
        (final_node, target_node_id) = find_final_node(kcfg)
        for node in kcfg.nodes:
            if node.id != target_node_id and not kcfg.predecessors(node.id):
                if init_node_id == -1:
                    init_node_id = node.id
                else:
                    raise ValueError(f'Cannot figure out the init node {init_node_id} vs {node.id}')
    else:
        (kcfg, init_node_id, target_node_id) = KCFG.from_claim(tools.printer.definition, claim, cfg_dir=kcfg_path)
        final_node = kcfg.node(target_node_id)

    init_node = kcfg.get_node(init_node_id)
    assert init_node

    a = abstracters(target_node_id)
    all_abstracters = [abstracter for abstracter, _, _ in a]
    all_cut_points = [cut_point for _, cps, _ in a for cut_point in cps] + CUT_POINT_RULES
    all_abstract_identifiers = [identifier for _, _, identifier in a]

    try:
        processed: set[NodeIdLike] = {target_node_id}
        non_final: set[NodeIdLike] = {target_node_id}
        to_process: list[KCFG.Node] = expandable_leaves(kcfg, target_node_id)
        for n in to_process:
            non_final.add(n.id)
        if run_id is not None:
            to_process = [kcfg.node(run_id)]

        print('Start: ', init_node_id, 'End: ', target_node_id)
        current_iteration = 0
        last_time = time.time()
        while to_process and current_iteration < iterations:
            next_current_leaves: set[NodeIdLike] = set()
            while to_process and current_iteration < iterations:
                current_iteration += 1
                node = to_process.pop(0)
                processed.add(node.id)
                current_time = time.time()
                if last_processed_node != -1:
                    print('Node', last_processed_node, 'took', current_time - last_time, 'sec.')
                print('Processing', node.id, flush=True)
                last_processed_node = node.id
                last_time = current_time

                assert len(list(kcfg.edges(source_id=node.id))) == 0
                assert len(list(kcfg.covers(source_id=node.id))) == 0
                assert len(list(kcfg.splits(source_id=node.id))) == 0
                assert len(list(kcfg.successors(node.id))) == 0

                try:
                    if command_is_new_wasm_instance(node.cterm.config):
                        print('is new wasm')
                        t = Timer('  Initialize wasm')
                        wasm_initializer.initialize(kcfg=kcfg, start_node=node, first_node=init_node)
                        t.measure()
                    elif touches_abstract_content(all_abstract_identifiers, node.cterm.config):
                        print('changes abstracted cell')
                        t = Timer('  Run call stack change')
                        extend_result = tools.explorer.extend_cterm(node.cterm, node_id=node.id, execute_depth=1)
                        kcfg.extend(extend_result, node, {})
                        t.measure()
                    else:
                        t = Timer('  Abstract')
                        abstract(all_abstracters, kcfg, node.id)
                        t.measure()

                        try:
                            t = Timer('  Extend')
                            node = kcfg.node(node.id)
                            processing: list[str] = []
                            instr = get_first_instr(node.cterm.config)
                            if instr is not None:
                                processing = ['<instrs>', instr.label.name]
                                call_name = get_hostcall_name(instr)
                                if call_name is not None:
                                    processing.append(call_name)
                            print(f'  First: {processing}', flush=True)
                            extend_result = tools.explorer.extend_cterm(
                                node.cterm, node_id=node.id, cut_point_rules=all_cut_points, execute_depth=depth
                            )
                            kcfg.extend(extend_result, node, {})
                            t.measure()
                        finally:
                            t = Timer('  Concretize')
                            leaves = set(new_leaves(kcfg, non_final, final_node.id))
                            leaves.add(node.id)
                            t.measure()
                            concretize(all_abstracters, kcfg, leaves)
                            t.measure()
                    current_leaves = new_leaves(kcfg, non_final, final_node.id)
                    print('Result: ', current_leaves)
                    for node_id in current_leaves:
                        next_current_leaves.add(node_id)
                    t = Timer('  Check final')
                    for node_id in current_leaves:
                        non_final.add(node_id)
                        node = kcfg.node(node_id)
                        if quick_implication_check(node.cterm.config, final_node.cterm.config):
                            implies_result = tools.explorer.cterm_symbolic.implies(node.cterm, final_node.cterm)
                            if implies_result.csubst:
                                kcfg.create_cover(node.id, final_node.id, implies_result.csubst)
                    t.measure()
                except ValueError:
                    if not kcfg.stuck:
                        raise

                for node in kcfg.stuck:
                    return Stuck(kcfg, stuck_node_id=node.id, final_node_id=final_node.id)
            if run_id is not None:
                to_process += [kcfg.node(node_id) for node_id in next_current_leaves]
            else:
                to_process = expandable_leaves(kcfg, target_node_id)

        if last_processed_node != -1:
            print('Node', last_processed_node, 'took', time.time() - current_time, 'sec.')
        return Success(kcfg)
    except BaseException as e:  # noqa: B036
        if last_processed_node != -1:
            print('Node', last_processed_node, 'took', time.time() - current_time, 'sec.')
        return RunException(kcfg, e, last_processed_node)


def new_leaves(kcfg: KCFG, existing: set[NodeIdLike], final: NodeIdLike) -> list[NodeIdLike]:
    return [node.id for node in kcfg.leaves if node.id not in existing and node.id != final]


def split_edge(tools: Tools, restart_kcfg: KCFG, start_node_id: int) -> RunClaimResult:
    kcfg = restart_kcfg
    (final_node, _) = find_final_node(kcfg)

    try:
        # preecompute the explorer to make time measurements more reliable.
        assert tools.explorer

        to_ignore: set[NodeIdLike] = {node.id for node in kcfg.leaves}

        start = kcfg.node(start_node_id)

        edges = kcfg.edges(source_id=start_node_id)
        assert len(edges) == 1
        assert len(list(kcfg.covers(source_id=start_node_id))) == 0
        assert len(list(kcfg.splits(source_id=start_node_id))) == 0
        assert len(list(kcfg.successors(start_node_id))) == 1

        destination = edges[0].target
        total_depth = edges[0].depth
        assert total_depth > 1
        half_depth = total_depth // 2

        kcfg.remove_edge(source_id=start_node_id, target_id=destination.id)

        start_time = time.time()

        extend_result = tools.explorer.extend_cterm(start.cterm, node_id=start.id, execute_depth=half_depth)
        kcfg.extend(extend_result, start, {})
        middle_node: KCFG.Node | None = None
        for node in kcfg.leaves:
            if node.id in to_ignore:
                continue
            assert not middle_node
            middle_node = node

            csubst = tools.explorer.cterm_symbolic.implies(node.cterm, final_node.cterm)
            assert not csubst, [csubst, node.id, final_node.id, to_ignore]
        assert middle_node

        middle_time = time.time()
        print(f'{start.id} -> {middle_node.id}: {middle_time-start_time} sec')

        extend_result = tools.explorer.extend_cterm(
            middle_node.cterm, node_id=middle_node.id, execute_depth=total_depth - half_depth
        )
        kcfg.extend(extend_result, middle_node, {})
        result_node: KCFG.Node | None = None
        for node in kcfg.leaves:
            if node.id in to_ignore:
                continue
            assert not result_node
            result_node = node

        assert result_node

        csubst = tools.explorer.cterm_symbolic.implies(result_node.cterm, destination.cterm)
        if not csubst:
            print('*' * 30, 'Antecedent', '*' * 30)
            print_node(tools.printer, result_node)
            print('*' * 30, 'Consequent', '*' * 30)
            print_node(tools.printer, destination)
            (success, reason) = tools.explorer.implication_failure_reason(
                antecedent=result_node.cterm, consequent=destination.cterm
            )
            raise ValueError(f'Implies failure, {[success, reason]}')
        assert csubst is not None

        replaced_edge = kcfg.edge(source_id=middle_node.id, target_id=result_node.id)
        assert replaced_edge

        kcfg.remove_node(result_node.id)
        kcfg.create_edge(middle_node.id, destination.id, depth=replaced_edge.depth)

        final_time = time.time()
        print(f'{middle_node.id} -> {destination.id}: {final_time-middle_time} sec')

        return Success(kcfg)
    except BaseException as e:  # noqa: B036
        return RunException(kcfg, e, start_node_id)


def profile_step(tools: Tools, restart_kcfg: KCFG, node_id: int, depth: int, groups: int) -> RunClaimResult:
    kcfg = restart_kcfg

    try:
        # precompute the explorer to make time measurements more reliable.
        timer = Timer('Initializing the explorer')
        assert tools.explorer
        timer.measure()

        start = kcfg.node(node_id)
        edges = kcfg.edges(source_id=node_id)
        assert len(edges) == 0
        logs: dict[int, tuple[LogEntry, ...]] = {}

        timer = Timer('Warming up the explorer')
        extend_result = tools.explorer.extend_cterm(start.cterm, node_id=start.id, execute_depth=1)
        kcfg.extend(extend_result, start, logs)
        edges = kcfg.edges(source_id=node_id)
        assert len(edges) == 1
        kcfg.remove_node(edges[0].target.id)
        edges = kcfg.edges(source_id=node_id)
        assert len(edges) == 0
        timer.measure()

        timer = Timer(f'Running {depth} steps.')
        extend_result = tools.explorer.extend_cterm(start.cterm, node_id=start.id, execute_depth=depth)
        kcfg.extend(extend_result, start, {})
        time = timer.measure()

        print(f'Average time per group: {time / groups}')
        print(f'Average time per step: {time / depth}')

        # TODO: Check that the explorer consumed all instructions and finished successfully.

        return Success(kcfg)
    except BaseException as e:  # noqa: B036
        return RunException(kcfg, e, node_id)


def find_final_node(kcfg: KCFG) -> tuple[KCFG.Node, NodeIdLike]:
    target_node_id: NodeIdLike = -1
    roots = kcfg.root
    assert len(roots) in [1, 2]
    if len(roots) == 1:
        # TODO: Is this the right way to get the destination node?
        # Should I take the covered node, or a covered's node destination?
        covers = kcfg.covered
        covering: NodeIdLike | None = None
        for covered in covers:
            for cover in kcfg.covers(source_id=covered.id):
                if covering is None:
                    covering = cover.target.id
                else:
                    assert covering == cover.target.id
        assert covering is not None
        # assert len(covers) == 1, [cover.id for cover in covers]
        target_node_id = covering
    else:
        if roots[0] < roots[1]:
            target_node_id = roots[1].id
        else:
            target_node_id = roots[0].id
    return (kcfg.node(target_node_id), target_node_id)


def expandable_leaves(kcfg: KCFG, target_node_id: NodeIdLike) -> list[KCFG.Node]:
    stuck = {node.id for node in kcfg.stuck}
    return [node for node in kcfg.leaves if not node.id == target_node_id and not node.id in stuck]
    # [node for node in kcfg.leaves if not node.id in processed]
