#!/usr/bin/env python3

import argparse
import sys
from dataclasses import dataclass
from pathlib import Path

import pyk.cli.args
from pyk.cterm import CTerm
from pyk.kast.inner import KApply, KInner, KSequence, KVariable
from pyk.kcfg import KCFG
from pyk.kcfg.show import KCFGShow
from pyk.kore.rpc import KoreClientError
from pyk.prelude.utils import token
from pyk.utils import BugReport

from .ast.configuration import wrap_with_generated_top_if_needed
from .ast.mx import (
    instrs_cell_contents,
    replace_instrs_cell,
    set_all_code_cell_content,
    set_call_stack_cell_content,
    set_interim_states_cell_content,
)
from .build import HASKELL, kbuild_semantics
from .json import load_json_kcfg, load_json_kclaim, write_kcfg_json
from .property_testing.paths import KBUILD_DIR, KBUILD_ML_PATH, ROOT
from .property_testing.printers import print_node
from .property_testing.running import RunException, Stuck, Success, profile_step, run_claim, split_edge
from .property_testing.wasm_krun_initializer import WasmKrunInitializer
from .timing import Timer

sys.setrecursionlimit(16000)


def usage_error() -> None:
    print('Usage:')
    print(
        '  python3 -m src.kmxwasm.property [--restart [--remove <node-id-csv>] [--run <node-id>]] [--step <number>] [-k] --claim <claim-file>'
    )
    print('  python3 -m src.kmxwasm.property --tree')
    print('  python3 -m src.kmxwasm.property --bisect-after <id>')
    print('  python3 -m src.kmxwasm.property --show-node <id>')
    print('  python3 -m src.kmxwasm.property --profile <node-id> [--remove <node-id-csv>] [--step <number>]')
    sys.exit(-1)


class Action:
    pass

    def run(self) -> None:
        raise NotImplementedError(f'run not implemented for {type(self)}.')


@dataclass(frozen=True)
class RunClaim(Action):
    claim_path: Path
    is_k: bool
    restart: bool
    booster: bool
    remove: list[int]
    run_node_id: int | None
    depth: int
    iterations: int
    kcfg_path: Path
    bug_report: BugReport | None

    def run(self) -> None:
        with kbuild_semantics(
            output_dir=KBUILD_DIR,
            config_file=KBUILD_ML_PATH,
            target=HASKELL,
            llvm=True,
            booster=self.booster,
            bug_report=self.bug_report,
        ) as tools:
            t = Timer('Loading the claim')
            if self.is_k:
                claims = tools.kprove.get_claims(self.claim_path)
                if len(claims) != 1:
                    print(f'Expected exactly one claim in {self.claim_path}, found {len(claims)}.')
                    sys.exit(-1)
                claim = claims[0]
            else:
                claim = load_json_kclaim(self.claim_path)
                # Fix the claim, it's not clear why these cells are being
                # removed when generating claims.
                claim = claim.let(body=wrap_with_generated_top_if_needed(claim.body))
            t.measure()

            kcfg: KCFG | None = None
            if self.restart:
                t = Timer('Loading kcfg')
                kcfg = load_json_kcfg(self.kcfg_path)
                to_remove = self.remove
                while to_remove:
                    current_id = to_remove.pop()
                    next_edges = [edge.target.id for edge in kcfg.edges(source_id=current_id)]
                    next_edges += [node.id for split in kcfg.splits(source_id=current_id) for node in split.targets]
                    next_edges += [node.id for split in kcfg.ndbranches(source_id=current_id) for node in split.targets]
                    for next_id in next_edges:
                        if len(kcfg.predecessors(target_id=next_id)) <= 1:
                            to_remove.append(next_id)
                    kcfg.remove_node(current_id)
                t.measure()
            result = run_claim(
                tools,
                WasmKrunInitializer(tools),
                claim=claim,
                restart_kcfg=kcfg,
                run_id=self.run_node_id,
                depth=self.depth,
                iterations=self.iterations,
            )
            write_kcfg_json(result.kcfg, self.kcfg_path)

            if isinstance(result, Stuck):
                stuck_node = result.kcfg.get_node(result.stuck_node_id)
                target_node = result.kcfg.get_node(result.final_node_id)
                if stuck_node is None:
                    print(f'Stuck node not found: {result.stuck_node_id}')
                else:
                    print('Stuck node:')
                    print_node(tools.printer, stuck_node)
                if target_node is None:
                    print(f'Target node not found: {result.final_node_id}')
                else:
                    print('Target node:')
                    print_node(tools.printer, target_node)
                if stuck_node is not None and target_node is not None:
                    (success, reason) = tools.explorer.implication_failure_reason(stuck_node.cterm, target_node.cterm)
                    assert not success
                    print(reason)
                print('Failed')
                show = KCFGShow(tools.printer, tools.node_printer)
                for line in show.pretty(result.kcfg):
                    print(line)
                sys.exit(-1)
            if isinstance(result, Success):
                print('Success')
                return
            if isinstance(result, RunException):
                print('Exception')
                show = KCFGShow(tools.printer, tools.node_printer)
                for line in show.pretty(result.kcfg):
                    print(line)
                print('Last node:')
                print('Printing: ', result.last_processed_node)
                if result.last_processed_node != -1:
                    node = result.kcfg.get_node(result.last_processed_node)
                    if node is None:
                        print(f'Node not found: {result.last_processed_node}')
                    else:
                        print_node(tools.printer, node)
                else:
                    print('No node to print.')
                if isinstance(result.exception, KoreClientError):
                    print(result.exception)
                raise result.exception
            raise NotImplementedError(f'Unknown run_claim result: {type(result)}')


@dataclass(frozen=True)
class SimplifyBefore(Action):
    before_node_id: int
    kcfg_path: Path

    def run(self) -> None:
        t = Timer('Loading kcfg')
        kcfg = load_json_kcfg(self.kcfg_path)
        node_ids = [n.id for n in kcfg.nodes if n.id < self.before_node_id]
        for node_id in node_ids:
            if len(list(kcfg.covers(source_id=node_id))) != 0:
                continue
            if len(list(kcfg.covers(target_id=node_id))) != 0:
                continue
            if len(list(kcfg.splits(source_id=node_id))) != 0:
                continue
            if len(list(kcfg.splits(target_id=node_id))) != 0:
                continue
            if len(list(kcfg.ndbranches(source_id=node_id))) != 0:
                continue
            if len(list(kcfg.ndbranches(target_id=node_id))) != 0:
                continue
            outgoing = list(kcfg.edges(source_id=node_id))
            incoming = list(kcfg.edges(target_id=node_id))
            if len(incoming) == 0:
                continue
            if len(outgoing) == 0:
                continue
            assert len(incoming) == 1
            assert len(outgoing) == 1
            assert len(list(kcfg.successors(node_id))) == 1

            parent = incoming[0].source
            child = outgoing[0].target
            steps = incoming[0].depth + outgoing[0].depth

            kcfg.remove_node(node_id)
            kcfg.create_edge(source_id=parent.id, target_id=child.id, depth=steps)
        t.measure()
        t = Timer('Writing kcfg')
        write_kcfg_json(kcfg, self.kcfg_path)
        t.measure()


@dataclass(frozen=True)
class BisectAfter(Action):
    node_id: int
    kcfg_path: Path
    booster: bool
    bug_report: BugReport | None

    def run(self) -> None:
        with kbuild_semantics(
            output_dir=KBUILD_DIR,
            config_file=KBUILD_ML_PATH,
            target=HASKELL,
            llvm=True,
            booster=self.booster,
            bug_report=self.bug_report,
        ) as tools:
            t = Timer('Loading kcfg')
            kcfg = load_json_kcfg(self.kcfg_path)
            t.measure()

            result = split_edge(tools, kcfg, start_node_id=self.node_id)
            write_kcfg_json(result.kcfg, self.kcfg_path)

            if isinstance(result, Success):
                print('Success')
                return
            if isinstance(result, RunException):
                print('Exception')
                show = KCFGShow(tools.printer, tools.node_printer)
                for line in show.pretty(result.kcfg):
                    print(line)
                print('Last node:')
                print('Printing: ', result.last_processed_node)
                if result.last_processed_node != -1:
                    node = result.kcfg.get_node(result.last_processed_node)
                    if node is None:
                        print(f'Node not found: {result.last_processed_node}')
                    else:
                        print_node(tools.printer, node)
                else:
                    print('No node to print.')
                if isinstance(result.exception, KoreClientError):
                    print(result.exception)
                raise result.exception
            raise NotImplementedError(f'Unknown run_claim result: {type(result)}')


@dataclass(frozen=True)
class InstructionProfile:
    name: str
    steps: int
    to_run: KInner
    setup_steps: int = 0
    setup: KInner = KSequence([])


PROFILE_INSTRUCTIONS = [
    InstructionProfile(
        name='aLocal.tee',
        steps=1,
        to_run=KApply('aLocal.tee', token(0)),
        setup_steps=3,
        setup=KSequence(
            [
                KApply('aIConst', [KApply('i32'), token(1)]),
                KApply(
                    'init_local___WASM_Instr_Int_Val',
                    [token(0), KApply('<_>__WASM-DATA-COMMON_IVal_IValType_Int', [KApply('i32'), token(1)])],
                ),
            ]
        ),
    ),
    InstructionProfile(
        name='aIConst',
        steps=2,
        to_run=KApply('aIConst', [KApply('i32'), token(1)]),
    ),  # ITYPE:IValType . const VAL => #chop (< ITYPE > VAL) => valstack
    InstructionProfile(
        name='push.i32',
        steps=1,
        to_run=KApply('<_>__WASM-DATA-COMMON_IVal_IValType_Int', [KApply('i32'), token(2)]),
    ),
    InstructionProfile(
        name='store',
        steps=2 + 2 + 4,  # TODO: Test only the "store" "{" Int Int Number Int "}" form.
        to_run=KSequence(
            KApply('aIConst', [KApply('i32'), token(1)]),  # Index for storing
            KApply('aIConst', [KApply('i32'), token(1)]),  # Value to store
            KApply('aStore', [KApply('i32'), KApply('storeOpStore8'), token(10)]),  # Offset
        ),
    ),  # uses two stack entries
    InstructionProfile(
        name='aLocal.get',
        steps=1,
        to_run=KApply('aLocal.get', token(0)),
        setup_steps=3,
        setup=KSequence(
            [
                KApply('aIConst', [KApply('i32'), token(1)]),
                KApply(
                    'init_local___WASM_Instr_Int_Val',
                    [token(0), KApply('<_>__WASM-DATA-COMMON_IVal_IValType_Int', [KApply('i32'), token(1)])],
                ),
            ]
        ),
    ),
    InstructionProfile(
        name='aLocal.set',
        steps=2 + 1,
        to_run=KSequence([KApply('aIConst', [KApply('i32'), token(1)]), KApply('aLocal.set', token(0))]),
        setup_steps=3,
        setup=KSequence(
            [
                KApply('aIConst', [KApply('i32'), token(1)]),
                KApply(
                    'init_local___WASM_Instr_Int_Val',
                    [token(0), KApply('<_>__WASM-DATA-COMMON_IVal_IValType_Int', [KApply('i32'), token(1)])],
                ),
            ]
        ),
    ),
    InstructionProfile(
        name='aLoad',
        steps=2 + 6,
        to_run=KSequence(
            KApply('aIConst', [KApply('i32'), token(1)]),  # Index for storing
            KApply('aLoad', [KApply('i32'), KApply('loadOpLoad8_u'), token(10)]),  # Offset
        ),
    ),  # uses two stack entries
    InstructionProfile(
        name='aGlobal.set',
        steps=2 + 1,
        to_run=KSequence(
            KApply('aIConst', [KApply('i32'), token(1)]),  # Index for storing
            KApply('aGlobal.set', [token(0)]),
        ),
    ),  # uses two stack entries
]
# TODO: Also profile the instructions below.
# ~> i32 . add
# ~> #br ( 1 )
# ~> label [ .ValTypes ] { .EmptyStmts } .ValStack
# ~> i32 . xor
# ~> #call ( 168 )
# ~> return


@dataclass(frozen=True)
class Profile(Action):
    node_id: int
    remove: list[int]
    depth: int
    kcfg_path: Path
    booster: bool
    bug_report: BugReport | None
    instruction_name: str

    def run(self) -> None:
        steps = 1
        instruction_kitem: KInner = KApply('aNop')
        setup: KInner = KSequence([])
        setup_steps = 0
        for profile in PROFILE_INSTRUCTIONS:
            if profile.name == self.instruction_name:
                (steps, instruction_kitem, setup_steps, setup) = (
                    profile.steps,
                    profile.to_run,
                    profile.setup_steps,
                    profile.setup,
                )
                break
        with kbuild_semantics(
            output_dir=KBUILD_DIR,
            config_file=KBUILD_ML_PATH,
            target=HASKELL,
            llvm=True,
            booster=self.booster,
            bug_report=self.bug_report,
        ) as tools:
            t = Timer('Loading kcfg')
            kcfg = load_json_kcfg(self.kcfg_path)
            t.measure()

            t = Timer('Removing nodes')
            for node_id in self.remove:
                kcfg.remove_node(node_id)
            t.measure()

            t = Timer('Removing edges')
            for edge in list(kcfg.edges(source_id=self.node_id)):
                kcfg.remove_edge(source_id=edge.source.id, target_id=edge.target.id)
            t.measure()

            t = Timer('Prepare profile node')
            node = kcfg.get_node(self.node_id)
            assert node
            instrs = KSequence([setup, KSequence([instruction_kitem] * self.depth)])
            new_config = replace_instrs_cell(node.cterm.config, instrs)
            new_config = set_call_stack_cell_content(new_config, KVariable('CallStackVar'))
            new_config = set_interim_states_cell_content(new_config, KVariable('InterimStatesVar'))
            new_config = set_all_code_cell_content(new_config, lambda x: KVariable(f'AccountsVar{x}'))
            # new_config = set_accounts_cell_content(new_config, KVariable('AccountsVar'))
            kcfg.replace_node(node.id, cterm=CTerm(new_config, node.cterm.constraints))
            t.measure()

            t = Timer('Optmize kcfg')
            t.measure()

            existing = {node.id for node in kcfg.nodes}

            steps_needed = self.depth * steps + setup_steps
            result = profile_step(
                tools,
                restart_kcfg=kcfg,
                node_id=self.node_id,
                depth=steps_needed,
                groups=self.depth,
            )

            if isinstance(result, Success):
                new = {node.id for node in kcfg.nodes if not node.id in existing}
                if len(new) != 1:
                    result = RunException(
                        kcfg=kcfg,
                        exception=Exception(f'Invalid number of new nodes: {len(new)}'),
                        last_processed_node=self.node_id,
                    )
                else:
                    new_id = list(new)[0]
                    new_node = kcfg.node(new_id)
                    maybe_instrs = instrs_cell_contents(new_node.cterm.config)
                    if maybe_instrs is None:
                        result = RunException(
                            kcfg=kcfg, exception=Exception('Instrs not found.'), last_processed_node=new_id
                        )
                    elif 0 != len(maybe_instrs):
                        result = RunException(
                            kcfg=kcfg, exception=Exception('Unprocessed instrs.'), last_processed_node=new_id
                        )
                    else:
                        edge = kcfg.edges(target_id=new_id)[0]
                        if steps_needed != edge.depth:
                            result = RunException(
                                kcfg=kcfg,
                                exception=Exception(
                                    f'Did not execute the expected number of steps: {[steps_needed , edge.depth]}.'
                                ),
                                last_processed_node=new_id,
                            )

            if isinstance(result, Success):
                print('Success')
                return
            if isinstance(result, RunException):
                print('Exception')
                show = KCFGShow(tools.printer, tools.node_printer)
                for line in show.pretty(result.kcfg):
                    print(line)
                print('Last node:')
                print('Printing: ', result.last_processed_node)
                if result.last_processed_node != -1:
                    node = result.kcfg.get_node(result.last_processed_node)
                    if node is None:
                        print(f'Node not found: {result.last_processed_node}')
                    else:
                        print_node(tools.printer, node)
                else:
                    print('No node to print.')
                if isinstance(result.exception, KoreClientError):
                    print(result.exception)
                raise result.exception
            raise NotImplementedError(f'Unknown run_claim result: {type(result)}')


@dataclass(frozen=True)
class ShowNode(Action):
    node_id: int
    kcfg_path: Path
    booster: bool

    def run(self) -> None:
        with kbuild_semantics(
            output_dir=KBUILD_DIR,
            config_file=KBUILD_ML_PATH,
            target=HASKELL,
            llvm=True,
            booster=self.booster,
            bug_report=None,
        ) as tools:
            t = Timer('Loading kcfg')
            kcfg = load_json_kcfg(self.kcfg_path)
            t.measure()
            print('Printing: ', self.node_id)
            node = kcfg.get_node(self.node_id)
            if node:
                print_node(tools.printer, node)
            else:
                print('No node to print.')


@dataclass(frozen=True)
class Tree(Action):
    kcfg_path: Path
    booster: bool

    def run(self) -> None:
        with kbuild_semantics(
            output_dir=KBUILD_DIR,
            config_file=KBUILD_ML_PATH,
            target=HASKELL,
            llvm=True,
            booster=self.booster,
            bug_report=None,
        ) as tools:
            t = Timer('Loading kcfg')
            kcfg = load_json_kcfg(self.kcfg_path)
            t.measure()
            show = KCFGShow(tools.printer, tools.node_printer)
            for line in show.pretty(kcfg):
                print(line)


def read_flags() -> Action:
    parser = argparse.ArgumentParser(description='Symbolic testing for MultiversX contracts')
    parser.add_argument(
        '--restart',
        dest='restart',
        action='store_true',
        required=False,
        help='Restart the backend with the results of the previous run',
    )
    parser.add_argument(
        '--show-node',
        dest='show_node',
        type=int,
        required=False,
        help='Display a node from the last saved configuration.',
    )
    parser.add_argument(
        '--tree',
        dest='tree',
        action='store_true',
        help='Display a tree of the last saved configuration.',
    )
    parser.add_argument(
        '--simplify-before',
        dest='simplify_before',
        type=int,
        help='Remove nodes lower than the given one while preserving the run tree structure.',
    )
    parser.add_argument(
        '--remove',
        dest='remove_nodes',
        type=str,
        required=False,
        default='',
        help='CSV of nodes to remove.',
    )
    parser.add_argument(
        '--step',
        dest='step',
        type=int,
        required=False,
        default=10000,
        help='How many steps to run at a time.',
    )
    parser.add_argument(
        '--iterations',
        dest='iterations',
        type=int,
        required=False,
        default=10000,
        help='How many batches of --step steps to run.',
    )
    parser.add_argument(
        '--bisect-after',
        dest='bisect_after',
        type=int,
        required=False,
        default=None,
        help='CSV of node after which the edge should be split.',
    )
    parser.add_argument(
        '--profile',
        dest='profile',
        type=int,
        required=False,
        help='Run a single sequence of steps starting at the given node.',
    )
    parser.add_argument(
        '--run',
        dest='run_node',
        type=int,
        required=False,
        default=-1,
        help='Node id from which to start.',
    )
    parser.add_argument(
        '-k',
        dest='is_k',
        action='store_true',
        default=False,
        help='Whether the claim file uses K or JSON.',
    )
    parser.add_argument(
        '--claimfile',
        required=False,
        help='File containing the claim to verify.',
    )
    parser.add_argument(
        '--kcfg',
        required=False,
        default=str(ROOT / '.property' / 'kcfg.json'),
        help='File in which to save the intermediate computing results.',
    )
    parser.add_argument(
        '--booster',
        action='store_true',
        required=False,
        help='Use the booster backend',
    )
    parser.add_argument(
        '--profile-instruction',
        dest='profile_instruction',
        required=False,
        default='nop',
        help='Which instruction to profile.',
    )
    parser.add_argument(
        '--bug-report',
        type=pyk.cli.args.bug_report_arg,
        help='Generate bug report with given name',
    )
    args = parser.parse_args()
    if args.show_node is not None:
        return ShowNode(args.show_node, Path(args.kcfg), booster=args.booster)
    if args.tree:
        return Tree(Path(args.kcfg), booster=args.booster)
    if args.bisect_after:
        return BisectAfter(args.bisect_after, Path(args.kcfg), booster=args.booster, bug_report=args.bug_report)
    if args.simplify_before:
        return SimplifyBefore(args.simplify_before, Path(args.kcfg))

    to_remove = []
    if args.remove_nodes:
        to_remove = [int(n_id) for n_id in args.remove_nodes.split(',')]

    if args.profile:
        return Profile(
            args.profile,
            remove=to_remove,
            depth=args.step,
            kcfg_path=Path(args.kcfg),
            booster=args.booster,
            bug_report=args.bug_report,
            instruction_name=args.profile_instruction,
        )

    if args.claimfile is None:
        usage_error()
        sys.exit(-1)
    claim_path = Path(args.claimfile)
    if not claim_path.exists():
        print(f'Input file ({claim_path}) does not exist.')
        sys.exit(-1)

    run: int | None = None
    if args.run_node != -1:
        run = args.run_node
    return RunClaim(
        claim_path=claim_path,
        is_k=args.is_k,
        restart=args.restart,
        remove=to_remove,
        run_node_id=run,
        depth=args.step,
        iterations=args.iterations,
        kcfg_path=Path(args.kcfg),
        booster=args.booster,
        bug_report=args.bug_report,
    )


def main(args: list[str]) -> None:
    action = read_flags()
    action.run()


if __name__ == '__main__':
    main(sys.argv[1:])
