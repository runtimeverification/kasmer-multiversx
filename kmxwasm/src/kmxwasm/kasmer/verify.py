from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from pyk.utils import BugReport

from ..property import RunClaim

if TYPE_CHECKING:
    from .utils import KasmerxProject


def kasmerx_verify(
    project: KasmerxProject,
    test: str,
    *,
    step: int | None = None,
    iterations: int | None = None,
    restart: bool | None = None,
    booster: bool | None = None,
    bug_report: BugReport | None = None,
) -> None:
    claim_file = project.test_dir / f'generated_claims/{test}-spec.json'

    if not claim_file.exists():
        raise ValueError(f'Claim file does not exist: {claim_file}')

    # Default values
    step = 10000 if step is None else step
    iterations = 10000 if iterations is None else iterations
    restart = bool(restart)
    booster = bool(booster)

    action = RunClaim(
        claim_path=claim_file,
        is_k=False,
        restart=restart,
        booster=booster,
        remove=[],
        run_node_id=None,
        depth=step,
        iterations=iterations,
        kcfg_path=Path(f'.property/{test}'),
        bug_report=bug_report,
    )
    action.run()
