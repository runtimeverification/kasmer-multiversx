from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import TYPE_CHECKING, NamedTuple, Optional

from pyk.ktool.krun import KRun
from pyk.utils import abs_or_rel_to, check_dir_path, check_file_path

if TYPE_CHECKING:
    from collections.abc import Iterable

    from pyk.kast import KInner


@dataclass
class ContractTarget:
    directory: Path
    name: Optional[str]

    def wasm_path(self) -> Path:
        if self.name is not None:
            path = self.directory / 'output' / (self.name + '.wasm')
            check_file_path(path)
            return path

        wasm_paths = list(self.directory.glob('./output/*.wasm'))
        assert len(wasm_paths) == 1, f'Expected exactly one *.wasm file in {self.directory}/output'

        return Path(wasm_paths[0])


@dataclass
class KasmerProject:
    test_dir: Path
    contracts: tuple[ContractTarget, ...]

    def __init__(self, *, test_dir: Path, contracts: Iterable[ContractTarget]):
        check_dir_path(test_dir)
        for c in contracts:
            check_dir_path(c.directory)

        self.test_dir = test_dir.resolve()
        self.contracts = tuple(ContractTarget(c.directory.resolve(), c.name) for c in contracts)

    @property
    def contract_dirs(self) -> tuple[Path, ...]:
        return tuple(c.directory for c in self.contracts)

    def contract_paths(self) -> tuple[Path, ...]:
        return tuple(t.wasm_path() for t in self.contracts)


def read_contract_target(project_dir: Path, contract: dict | str) -> list[ContractTarget]:
    if isinstance(contract, str):
        path = Path(contract)
        if path.suffix == '.wasm':
            assert path.parent.name == 'output'
            directory = path.parent.parent
            name = path.stem
        else:
            directory = path
            name = None
    elif isinstance(contract, dict):
        directory = Path(contract['path'])
        name = contract.get('name', None)
    else:
        raise ValueError(f'Expected dictionary or string: {contract}')

    directory = abs_or_rel_to(directory, base=project_dir)
    return ContractTarget(directory=directory, name=name)


def load_project(project_dir: Path) -> KasmerProject:
    check_dir_path(project_dir)
    project_file = project_dir / 'kasmer.json'
    check_file_path(project_file)

    with project_file.open() as f:
        project_data = json.load(f)

    contracts = [read_contract_target(project_dir, c) for c in project_data['contracts']]
    return KasmerProject(
        test_dir=project_dir,
        contracts=contracts,
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

        test_contract = ContractTarget(project.test_dir, None)
        test_wasm = kasmer.load_wasm(test_contract.wasm_path())
        test_endpoints = dict(kasmer.get_test_endpoints(project.test_dir))

        contract_wasms = kasmer.load_contract_wasms(project.contract_paths())

        sym_conf, init_subst = kasmer.deploy_test(krun, test_wasm, contract_wasms)

        return KasmerSetup(krun, test_endpoints, sym_conf, init_subst)
