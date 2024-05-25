from __future__ import annotations

import logging
from pathlib import Path
from typing import TYPE_CHECKING

from pyk.kdist import kdist
from pyk.ktool.krun import KRun
from pyk.utils import run_process

if TYPE_CHECKING:
    from collections.abc import Iterable
    from typing import Final

    from .utils import KasmerxProject


logger: Final = logging.getLogger(__name__)


def kasmerx_build(project: KasmerxProject) -> None:
    sc_meta(project.test_dir)
    for contract_dir in project.contract_dirs:
        sc_meta(contract_dir)
    gen_claims(project.test_dir, project.contract_dirs)


def sc_meta(path: Path) -> None:
    logger.info(f'Compiling: {path}')
    run_process(['sc-meta', 'all', 'build', '--path', str(path), '--wasm-symbols', '--no-wasm-opt'])


def gen_claims(test_dir: Path, contract_dirs: Iterable[Path]) -> None:
    from kmultiversx import kasmer

    definition_dir = kdist.get('mx-semantics.llvm-kasmer')
    krun = KRun(definition_dir)

    test_wasm = kasmer.load_wasm(kasmer.find_test_wasm_path(str(test_dir)))
    contract_wasms = kasmer.load_contract_wasms(
        kasmer.find_test_wasm_path(str(contract_dir)) for contract_dir in contract_dirs
    )
    sym_conf, init_subst = kasmer.deploy_test(krun, test_wasm, contract_wasms)
    test_endpoints = kasmer.get_test_endpoints(str(test_dir))

    output_dir = test_dir / 'generated_claims'

    logger.info(f'Generating claims: {output_dir}')
    kasmer.generate_claims(krun, test_endpoints, sym_conf, init_subst, output_dir)
