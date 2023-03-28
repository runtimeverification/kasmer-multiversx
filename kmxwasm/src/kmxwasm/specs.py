from pathlib import Path
from typing import List, Tuple

from pyk.kast.outer import KRule
from pyk.ktool.kprove import KProve
from pyk.prelude.ml import is_top

from .kast import get_inner
from .lazy_explorer import LazyExplorer
from .rules import RuleCreator
from .wasm_cell import TOP_CELL


class Specs:
    def __init__(self, specs: List[Tuple[Path, List[str]]]) -> None:
        self.__unprocessed_specs = specs

    def add_rules(self, processed_functions: List[str], rules: RuleCreator, explorer: LazyExplorer) -> None:
        remaining = []
        for spec_path, spec_dependencies in self.__unprocessed_specs:
            has_deps = Specs.__has_dependencies(
                spec_dependencies=spec_dependencies, processed_functions=processed_functions
            )
            if not has_deps:
                remaining.append((spec_path, spec_dependencies))
                continue
            Specs.__prove(spec_path, explorer.get_kprove())
            Specs.__add_rules(spec_path, rules, explorer.get_kprove())
        self.__unprocessed_specs = remaining

    @staticmethod
    def __has_dependencies(spec_dependencies: List[str], processed_functions: List[str]) -> bool:
        for dep in spec_dependencies:
            if not dep in processed_functions:
                return False
        return True

    @staticmethod
    def __prove(spec_path: Path, kprove: KProve) -> None:
        print(f'Proving {spec_path}', flush=True)
        final_state = kprove.prove(spec_path)
        if not is_top(final_state):
            raise ValueError(f'Failed to prove {spec_path}.')
        print('Proving done', flush=True)

    @staticmethod
    def __add_rules(spec_path: Path, rules: RuleCreator, kprove: KProve) -> None:
        claims = kprove.get_claims(spec_path)
        for c in claims:
            body = get_inner(c.body, 0, TOP_CELL)
            rule = KRule(body=body, requires=c.requires, ensures=c.ensures)
            rules.add_raw_rule(rule)


def find_specs(path: Path) -> Specs:
    specs: List[Tuple[Path, List[str]]] = []
    if not path.exists():
        return Specs([])
    for spec in path.glob('*.k'):
        if not spec.is_file():
            continue
        name = spec.name
        assert name.endswith('.k')
        deps_path = spec.parent / f'{name[:-2]}.deps'
        assert deps_path.exists()
        assert deps_path.is_file()
        deps = []
        with deps_path.open() as f:
            for line in f:
                for dep in line.strip().split(','):
                    if dep:
                        deps.append(dep)
        specs.append((spec, deps))

    return Specs(specs)
