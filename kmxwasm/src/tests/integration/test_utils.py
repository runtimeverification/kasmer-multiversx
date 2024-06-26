from pathlib import Path

import pytest

from kmxwasm.kasmer.utils import load_project

ROOT = (Path(__file__).parents[4]).resolve(strict=True)
TEST_CONTRACTS_DIR = ROOT / 'tests' / 'contracts'

PROJECT_DIRS = [i for i in TEST_CONTRACTS_DIR.iterdir() if i.is_dir()]


@pytest.mark.parametrize('project_dir', PROJECT_DIRS, ids=str)
def test_load_project(project_dir: Path) -> None:

    load_project(project_dir)
