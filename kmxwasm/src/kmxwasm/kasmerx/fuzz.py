from __future__ import annotations

import logging
from typing import TYPE_CHECKING

from .utils import KasmerSetup

if TYPE_CHECKING:
    from typing import Final

    from .utils import KasmerxProject


logger: Final = logging.getLogger(__name__)


def kasmerx_fuzz(project: KasmerxProject) -> None:
    from kmultiversx import kasmer

    krun, test_endpoints, sym_conf, init_subst = KasmerSetup.load_from_project(project)

    logger.info('Fuzzing')
    kasmer.run_concrete(krun, test_endpoints, sym_conf, init_subst, verbose=True)
