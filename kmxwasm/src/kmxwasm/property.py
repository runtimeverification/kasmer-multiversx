#!/usr/bin/env python3

import argparse
import sys
from dataclasses import dataclass
from pathlib import Path

from pyk.kast.inner import KApply
from pyk.kcfg import KCFG
from pyk.kcfg.show import KCFGShow
from pyk.kore.rpc import KoreClientError
from pyk.prelude.utils import token

from .build import HASKELL, LLVM, kbuild_semantics
from .json import load_json_kcfg, load_json_kclaim, write_kcfg_json
from .paths import KBUILD_DIR, KBUILD_ML_PATH, ROOT
from .printers import print_node
from .running import RunException, Stuck, Success, run_claim, split_edge
from .wasm_krun_initializer import WasmKrunInitializer

sys.setrecursionlimit(4000)


def usage_error() -> None:
    print('Usage:')
    print(
        '  python3 -m src.kmxwasm.property [--restart [--remove <node-id-csv>] [--run <node-id>]] [--step <number>] [-k] --claim <claim-file>'
    )
    print('  python3 -m src.kmxwasm.property --tree')
    print('  python3 -m src.kmxwasm.property --bisect-after <id>')
    print('  python3 -m src.kmxwasm.property --show-node <id>')
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
    remove: list[int]
    run_node_id: int | None
    depth: int
    kcfg_path: Path

    def run(self) -> None:
        with (
            kbuild_semantics(output_dir=KBUILD_DIR, config_file=KBUILD_ML_PATH, target=HASKELL) as tools,
            kbuild_semantics(output_dir=KBUILD_DIR, config_file=KBUILD_ML_PATH, target=LLVM) as llvm_tools,
        ):
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
                claim = claim.let(body=KApply('<generatedTop>', [claim.body, KApply('<generatedCounter>', [token(0)])]))

            kcfg: KCFG | None = None
            if self.restart:
                kcfg = load_json_kcfg(self.kcfg_path)
                for node_id in self.remove:
                    kcfg.remove_node(node_id)
            result = run_claim(
                tools,
                WasmKrunInitializer(llvm_tools),
                claim=claim,
                restart_kcfg=kcfg,
                run_id=self.run_node_id,
                depth=self.depth,
            )
            write_kcfg_json(result.kcfg, self.kcfg_path)

            if isinstance(result, Stuck):
                stuck_node = result.kcfg.get_node(result.stuck_node_id)
                target_node = result.kcfg.get_node(result.final_node_id)
                if stuck_node is None:
                    print(f'Stuck node not found: {result.stuck_node_id}')
                else:
                    print('Stuck node:')
                    print_node(tools, stuck_node)
                if target_node is None:
                    print(f'Target node not found: {result.final_node_id}')
                else:
                    print('Target node:')
                    print_node(tools, target_node)
                if stuck_node is not None and target_node is not None:
                    (success, reason) = tools.explorer.implication_failure_reason(stuck_node.cterm, target_node.cterm)
                    assert not success
                    print(reason)
                print('Failed')
                show = KCFGShow(tools.printer)
                for line in show.pretty(result.kcfg):
                    print(line)
                sys.exit(-1)
            if isinstance(result, Success):
                print('Success')
                return
            if isinstance(result, RunException):
                print('Exception')
                show = KCFGShow(tools.printer)
                for line in show.pretty(result.kcfg):
                    print(line)
                print('Last node:')
                print('Printing: ', result.last_processed_node)
                if result.last_processed_node != -1:
                    node = result.kcfg.get_node(result.last_processed_node)
                    if node is None:
                        print(f'Node not found: {result.last_processed_node}')
                    else:
                        print_node(tools, node)
                else:
                    print('No node to print.')
                if isinstance(result.exception, KoreClientError):
                    print('code=', result.exception.code)
                    print('message=', result.exception.message)
                    print('data=', result.exception.data)
                raise result.exception
            raise NotImplementedError(f'Unknown run_claim result: {type(result)}')


@dataclass(frozen=True)
class BisectAfter(Action):
    node_id: int
    kcfg_path: Path

    def run(self) -> None:
        with kbuild_semantics(output_dir=KBUILD_DIR, config_file=KBUILD_ML_PATH, target=HASKELL) as tools:
            kcfg = load_json_kcfg(self.kcfg_path)

            result = split_edge(tools, kcfg, start_node_id=self.node_id)
            write_kcfg_json(result.kcfg, self.kcfg_path)

            if isinstance(result, Success):
                print('Success')
                return
            if isinstance(result, RunException):
                print('Exception')
                show = KCFGShow(tools.printer)
                for line in show.pretty(result.kcfg):
                    print(line)
                print('Last node:')
                print('Printing: ', result.last_processed_node)
                if result.last_processed_node != -1:
                    node = result.kcfg.get_node(result.last_processed_node)
                    if node is None:
                        print(f'Node not found: {result.last_processed_node}')
                    else:
                        print_node(tools, node)
                else:
                    print('No node to print.')
                if isinstance(result.exception, KoreClientError):
                    print('code=', result.exception.code)
                    print('message=', result.exception.message)
                    print('data=', result.exception.data)
                raise result.exception
            raise NotImplementedError(f'Unknown run_claim result: {type(result)}')


@dataclass(frozen=True)
class ShowNode(Action):
    node_id: int
    kcfg_path: Path

    def run(self) -> None:
        with kbuild_semantics(output_dir=KBUILD_DIR, config_file=KBUILD_ML_PATH, target=HASKELL) as tools:
            kcfg = load_json_kcfg(self.kcfg_path)
            print('Printing: ', self.node_id)
            node = kcfg.get_node(self.node_id)
            if node:
                print_node(tools, node)
            else:
                print('No node to print.')


@dataclass(frozen=True)
class Tree(Action):
    kcfg_path: Path

    def run(self) -> None:
        with kbuild_semantics(output_dir=KBUILD_DIR, config_file=KBUILD_ML_PATH, target=HASKELL) as tools:
            kcfg = load_json_kcfg(self.kcfg_path)
            show = KCFGShow(tools.printer)
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
        '--bisect-after',
        dest='bisect_after',
        type=int,
        required=False,
        default=None,
        help='CSV of node after which the edge should be split.',
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
    args = parser.parse_args()
    if args.show_node is not None:
        return ShowNode(args.show_node, Path(args.kcfg))
    if args.tree:
        return Tree(Path(args.kcfg))
    if args.bisect_after:
        return BisectAfter(args.bisect_after, Path(args.kcfg))

    if args.claimfile is None:
        usage_error()
        sys.exit(-1)
    claim_path = Path(args.claimfile)
    if not claim_path.exists():
        print(f'Input file ({claim_path}) does not exist.')
        sys.exit(-1)

    to_remove = []
    if args.remove_nodes:
        to_remove = [int(n_id) for n_id in args.remove_nodes.split(',')]

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
        kcfg_path=Path(args.kcfg),
    )


def main(args: list[str]) -> None:
    action = read_flags()
    action.run()


if __name__ == '__main__':
    main(sys.argv[1:])
