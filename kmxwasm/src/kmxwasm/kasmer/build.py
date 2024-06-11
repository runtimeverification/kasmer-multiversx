from __future__ import annotations

import logging
from pathlib import Path
from typing import TYPE_CHECKING

from pyk.utils import run_process

from .utils import KasmerSetup

if TYPE_CHECKING:
    from typing import Final

    from .utils import KasmerxProject


logger: Final = logging.getLogger(__name__)


def kasmerx_build(project: KasmerxProject) -> None:
    sc_meta(project.test_dir)
    for contract_dir in project.contract_dirs:
        sc_meta(contract_dir)
    gen_claims(project)


def sc_meta(path: Path) -> None:
    logger.info(f'Compiling: {path}')
    run_process(['sc-meta', 'all', 'build', '--path', str(path), '--wasm-symbols', '--no-wasm-opt'])


def gen_claims(project: KasmerxProject) -> None:
    from kmultiversx import kasmer

    krun, test_endpoints, sym_conf, init_subst = KasmerSetup.load_from_project(project)
    output_dir = project.test_dir / 'generated_claims'

    logger.info(f'Generating claims: {output_dir}')
    kasmer.generate_claims(krun, test_endpoints, sym_conf, init_subst, output_dir)
