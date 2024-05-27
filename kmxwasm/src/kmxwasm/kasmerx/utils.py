from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import TYPE_CHECKING

from pyk.utils import abs_or_rel_to, check_dir_path, check_file_path

if TYPE_CHECKING:
    from collections.abc import Iterable


@dataclass
class KasmerxProject:
    test_dir: Path
    contract_dirs: tuple[Path, ...]

    def __init__(self, *, test_dir: Path, contract_dirs: Iterable[Path]):
        check_dir_path(test_dir)
        for contract_dir in contract_dirs:
            check_dir_path(contract_dir)

        self.test_dir = test_dir.resolve()
        self.contract_dirs = tuple(contract_dir.resolve() for contract_dir in contract_dirs)


def load_project(project_dir: Path) -> KasmerxProject:
    check_dir_path(project_dir)
    project_file = project_dir / 'kasmerx.json'
    check_file_path(project_file)

    with project_file.open() as f:
        project_data = json.load(f)

    contract_dirs = [
        abs_or_rel_to(Path(contract_path), base=project_dir) for contract_path in project_data['contract_paths']
    ]

    return KasmerxProject(
        test_dir=project_dir,
        contract_dirs=contract_dirs,
    )
