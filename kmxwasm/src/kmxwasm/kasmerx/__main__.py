from __future__ import annotations

import logging
from argparse import ArgumentParser
from dataclasses import dataclass
from pathlib import Path
from typing import TYPE_CHECKING

from pyk.utils import check_dir_path

from .build import kasmerx_build
from .fuzz import kasmerx_fuzz
from .utils import load_project
from .verify import kasmerx_verify

if TYPE_CHECKING:
    from collections.abc import Sequence
    from typing import Final


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
    kasmerx_verify(project, opts.test)


# ----------------------
# Command line arguments
# ----------------------


def _parse_args(args: Sequence[str]) -> KasmerxOpts:
    ns = _arg_parser().parse_args(args)

    project_dir = Path(ns.directory)

    return {
        'build': BuildOpts(project_dir=project_dir),
        'fuzz': FuzzOpts(project_dir=project_dir),
        'verify': VerifyOpts(project_dir=project_dir, test=ns.test),
    }[ns.command]


def _arg_parser() -> ArgumentParser:
    parser = ArgumentParser(prog='kasmerx')
    parser.add_argument('-C', '--directory', default='.', help='path to test contract (default: CWD)')

    command_parser = parser.add_subparsers(dest='command', required=True)

    command_parser.add_parser('build', help='build main and test contracts, and generate claims')
    command_parser.add_parser('fuzz', help='fuzz test contract')

    verify_parser = command_parser.add_parser('verify', help='verify test contract')
    verify_parser.add_argument('test', metavar='TEST', help='name of test function')

    return parser


if __name__ == '__main__':
    main()
