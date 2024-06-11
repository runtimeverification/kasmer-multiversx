from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import TYPE_CHECKING, NamedTuple

from pyk.ktool.krun import KRun
from pyk.utils import abs_or_rel_to, check_dir_path, check_file_path

if TYPE_CHECKING:
    from collections.abc import Iterable

    from pyk.kast import KInner


@dataclass
class KasmerProject:
    test_dir: Path
    contract_dirs: tuple[Path, ...]
    contract_paths: tuple[Path, ...]

    def __init__(self, *, test_dir: Path, contract_dirs: Iterable[Path], contract_paths: Iterable[Path]):
        check_dir_path(test_dir)
        for contract_dir in contract_dirs:
            check_dir_path(contract_dir)

        self.test_dir = test_dir.resolve()
        self.contract_dirs = tuple(contract_dir.resolve() for contract_dir in contract_dirs)
        self.contract_paths = tuple(contract_path.resolve() for contract_path in contract_paths)


def load_project(project_dir: Path) -> KasmerProject:
    check_dir_path(project_dir)
    project_file = project_dir / 'kasmer.json'
    check_file_path(project_file)

    with project_file.open() as f:
        project_data = json.load(f)

    contract_paths = []
    contract_dirs = []
    for contract_path_ in project_data['contract_paths']:
        contract_path = abs_or_rel_to(Path(contract_path_), base=project_dir)
        assert contract_path.suffix == '.wasm'
        assert contract_path.parent.name == 'output'

        contract_paths.append(contract_path)
        contract_dirs.append(contract_path.parent.parent)

    return KasmerProject(
        test_dir=project_dir,
        contract_dirs=contract_dirs,
        contract_paths=contract_paths,
    )


class KasmerSetup(NamedTuple):
    krun: KRun
    test_endpoints: dict[str, tuple[str, ...]]
    sym_conf: KInner
    init_subst: dict[str, KInner]

    @staticmethod
    def load_from_project(project: KasmerProject) -> KasmerSetup:
        from kmultiversx import kasmer
        from pyk.kdist import kdist

        definition_dir = kdist.get('mx-semantics.llvm-kasmer')
        krun = KRun(definition_dir)

        test_dir = str(project.test_dir)
        test_wasm = kasmer.load_wasm(kasmer.find_test_wasm_path(test_dir))
        test_endpoints = dict(kasmer.get_test_endpoints(test_dir))

        contract_paths = [str(contract_path) for contract_path in project.contract_paths]
        contract_wasms = kasmer.load_contract_wasms(contract_paths)

        sym_conf, init_subst = kasmer.deploy_test(krun, test_wasm, contract_wasms)

        return KasmerSetup(krun, test_endpoints, sym_conf, init_subst)
