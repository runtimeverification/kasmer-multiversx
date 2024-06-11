from __future__ import annotations

import logging
from argparse import ArgumentParser
from dataclasses import dataclass
from pathlib import Path
from typing import TYPE_CHECKING

import pyk
from pyk.utils import check_dir_path

from .build import kasmerx_build
from .fuzz import kasmerx_fuzz
from .utils import load_project
from .verify import kasmerx_verify

if TYPE_CHECKING:
    from collections.abc import Sequence
    from typing import Final

    from pyk.utils import BugReport


logger: Final = logging.getLogger(__name__)


@dataclass
class KasmerxOpts:
    project_dir: Path

    def __init__(self, *, project_dir: Path):
        check_dir_path(project_dir)
        self.project_dir = project_dir.resolve()


class BuildOpts(KasmerxOpts): ...


class FuzzOpts(KasmerxOpts): ...


@dataclass
class VerifyOpts(KasmerxOpts):
    test: str
    step: int | None
    iterations: int | None
    restart: bool | None
    booster: bool | None
    bug_report: BugReport | None


def main() -> None:
    import sys

    kasmerx(sys.argv[1:])


def kasmerx(args: Sequence[str]) -> None:
    logging.basicConfig(level=logging.INFO)

    opts = _parse_args(args)
    match opts:
        case BuildOpts():
            return _kasmerx_build(opts)
        case FuzzOpts():
            return _kasmerx_fuzz(opts)
        case VerifyOpts():
            return _kasmerx_verify(opts)
        case _:
            raise AssertionError()


# --------
# Commands
# --------


def _kasmerx_build(opts: BuildOpts) -> None:
    project = load_project(opts.project_dir)
    kasmerx_build(project)


def _kasmerx_fuzz(opts: FuzzOpts) -> None:
    project = load_project(opts.project_dir)
    kasmerx_fuzz(project)


def _kasmerx_verify(opts: VerifyOpts) -> None:
    project = load_project(opts.project_dir)
    kasmerx_verify(
        project=project,
        test=opts.test,
        step=opts.step,
        iterations=opts.iterations,
        restart=opts.restart,
        booster=opts.booster,
        bug_report=opts.bug_report,
    )


# ----------------------
# Command line arguments
# ----------------------


def _parse_args(args: Sequence[str]) -> KasmerxOpts:
    ns = _arg_parser().parse_args(args)

    project_dir = Path(ns.directory)

    match ns.command:
        case 'build':
            return BuildOpts(project_dir=project_dir)
        case 'fuzz':
            return FuzzOpts(project_dir=project_dir)
        case 'verify':
            return VerifyOpts(
                project_dir=project_dir,
                test=ns.test,
                step=ns.step,
                iterations=ns.iterations,
                restart=ns.restart,
                booster=ns.booster,
                bug_report=ns.bug_report,
            )
        case _:
            raise AssertionError()


def _arg_parser() -> ArgumentParser:
    parser = ArgumentParser(prog='kasmer')
    parser.add_argument('-C', '--directory', default='.', help='path to test contract (default: CWD)')

    command_parser = parser.add_subparsers(dest='command', required=True)

    command_parser.add_parser('build', help='build main and test contracts, and generate claims')
    command_parser.add_parser('fuzz', help='fuzz test contract')

    verify_parser = command_parser.add_parser('verify', help='verify test contract')
    verify_parser.add_argument('test', metavar='TEST', help='name of test function')
    verify_parser.add_argument(
        '--restart',
        action='store_true',
        default=None,
        help='restart the backend with the results of the previous run',
    )
    verify_parser.add_argument(
        '--step',
        type=int,
        help='number of steps to run at a time',
    )
    verify_parser.add_argument(
        '--iterations',
        type=int,
        help='number of batches of --step steps to run',
    )
    verify_parser.add_argument(
        '--booster',
        action='store_true',
        default=None,
        help='use the booster backend',
    )
    verify_parser.add_argument(
        '--bug-report',
        type=pyk.cli.args.bug_report_arg,
        help='generate bug report with given name',
    )

    return parser


if __name__ == '__main__':
    main()
