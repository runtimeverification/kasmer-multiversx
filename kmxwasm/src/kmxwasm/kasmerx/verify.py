from pathlib import Path

from ..property import RunClaim
from .utils import KasmerxProject


def kasmerx_verify(project: KasmerxProject, test: str) -> None:
    claim_file = project.test_dir / f'generated_claims/{test}-spec.json'

    if not claim_file.exists():
        raise ValueError(f'Claim file does not exist: {claim_file}')

    action = RunClaim(
        claim_path=claim_file,
        is_k=False,
        restart=False,
        booster=True,
        remove=[],
        run_node_id=None,
        depth=10000,
        iterations=10000,
        kcfg_path=Path(f'.property/{test}'),
        bug_report=None,
    )
    action.run()
