import time
from dataclasses import dataclass

from pyk.kast.outer import KClaim
from pyk.kcfg import KCFG
from pyk.kcfg.exploration import KCFGExploration
from pyk.kcfg.kcfg import NodeIdLike
from pyk.kore.rpc import LogEntry

from .ast.elrond import command_is_new_wasm_instance
from .printers import print_node
from .tools import Tools
from .wasm_krun_initializer import WasmKrunInitializer


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


def run_claim(
    tools: Tools,
    wasm_initializer: WasmKrunInitializer,
    claim: KClaim,
    restart_kcfg: KCFG | None,
    run_id: int | None,
    depth: int,
) -> RunClaimResult:
    last_processed_node: NodeIdLike = -1
    init_node_id: NodeIdLike = -1
    target_node_id: NodeIdLike = -1
    if restart_kcfg:
        kcfg = restart_kcfg
        roots = kcfg.root
        assert len(roots) in [1, 2]
        if len(roots) == 1:
            init_node_id = roots[0].id
            # TODO: Is this the right way to get the destination node?
            # Should I take the covered node, or a covered's node destination?
            covers = kcfg.covered
            assert len(covers) == 1
            target_node_id = covers[0].id
        else:
            if roots[0] < roots[1]:
                init_node_id = roots[0].id
                target_node_id = roots[1].id
            else:
                init_node_id = roots[1].id
                target_node_id = roots[0].id
    else:
        (kcfg, init_node_id, target_node_id) = KCFG.from_claim(tools.printer.definition, claim)

    kcfg_exploration = KCFGExploration(kcfg)

    try:
        processed: set[NodeIdLike] = {target_node_id}
        non_final: set[NodeIdLike] = {target_node_id}
        to_process: list[KCFG.Node] = expandable_leaves(kcfg, target_node_id)
        if run_id is not None:
            to_process = [kcfg.node(run_id)]
        final_node = kcfg.node(target_node_id)
        print('Start: ', init_node_id, 'End: ', target_node_id)
        last_time = time.time()
        while to_process:
            # print([node.id for node in to_process])
            while to_process:
                node = to_process.pop()
                processed.add(node.id)
                last_processed_node = node.id
                current_time = time.time()
                print('Processing', node.id, 'previous = ', current_time - last_time, 'sec', flush=True)
                last_time = current_time

                assert len(list(kcfg.edges(source_id=node.id))) == 0
                assert len(list(kcfg.covers(source_id=node.id))) == 0
                assert len(list(kcfg.splits(source_id=node.id))) == 0
                assert len(list(kcfg.successors(node.id))) == 0

                logs: dict[int, tuple[LogEntry, ...]] = {}
                try:
                    if command_is_new_wasm_instance(node.cterm.config):
                        print('is new wasm')
                        wasm_initializer.initialize(kcfg=kcfg, start_node=node)
                    else:
                        tools.explorer.extend(
                            kcfg_exploration=kcfg_exploration,
                            node=node,
                            logs=logs,
                            execute_depth=depth,
                            cut_point_rules=['ELROND-CONFIG.newWasmInstance'],
                        )
                    for node in kcfg.leaves:
                        if node.id not in non_final:
                            non_final.add(node.id)
                            csubst = tools.explorer.cterm_implies(node.cterm, final_node.cterm)
                            if csubst:
                                kcfg.create_cover(node.id, final_node.id, csubst)
                except ValueError:
                    if not kcfg.stuck:
                        raise
                    for node in kcfg.stuck:
                        return Stuck(kcfg, stuck_node_id=node.id, final_node_id=final_node.id)
            to_process = expandable_leaves(kcfg, target_node_id)

        return Success(kcfg)
    except BaseException as e:
        return RunException(kcfg, e, last_processed_node)


def split_edge(tools: Tools, restart_kcfg: KCFG, start_node_id: int) -> RunClaimResult:
    target_node_id: NodeIdLike = -1

    kcfg = restart_kcfg
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
    final_node = kcfg.node(target_node_id)

    kcfg_exploration = KCFGExploration(kcfg)

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

        logs: dict[int, tuple[LogEntry, ...]] = {}

        tools.explorer.extend(kcfg_exploration=kcfg_exploration, node=start, logs=logs, execute_depth=half_depth)
        middle_node: KCFG.Node | None = None
        for node in kcfg.leaves:
            if node.id in to_ignore:
                continue
            assert not middle_node
            middle_node = node

            csubst = tools.explorer.cterm_implies(node.cterm, final_node.cterm)
            assert not csubst, [csubst, node.id, final_node.id, to_ignore]
        assert middle_node

        middle_time = time.time()
        print(f'{start.id} -> {middle_node.id}: {middle_time-start_time} sec')

        tools.explorer.extend(
            kcfg_exploration=kcfg_exploration, node=middle_node, logs=logs, execute_depth=total_depth - half_depth
        )
        result_node: KCFG.Node | None = None
        for node in kcfg.leaves:
            if node.id in to_ignore:
                continue
            assert not result_node
            result_node = node

        assert result_node

        csubst = tools.explorer.cterm_implies(result_node.cterm, destination.cterm)
        if not csubst:
            print('*' * 30, 'Antecedent', '*' * 30)
            print_node(tools, result_node)
            print('*' * 30, 'Consequent', '*' * 30)
            print_node(tools, destination)
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
    except BaseException as e:
        return RunException(kcfg, e, start_node_id)


def expandable_leaves(kcfg: KCFG, target_node_id: NodeIdLike) -> list[KCFG.Node]:
    return [node for node in kcfg.leaves if not node.id == target_node_id]
    # [node for node in kcfg.leaves if not node.id in processed]
