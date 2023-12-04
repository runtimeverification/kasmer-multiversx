import pytest
from filelock import FileLock
from pytest import TempPathFactory

from ..build import HASKELL, LEMMA_PROOFS, kbuild_semantics
from ..property_testing.paths import KBUILD_ML_PATH
from ..tools import Tools


@pytest.fixture(scope='session')
def tools(tmp_path_factory: TempPathFactory, worker_id: str) -> Tools:
    if worker_id == 'master':
        root_tmp_dir = tmp_path_factory.getbasetemp()
    else:
        root_tmp_dir = tmp_path_factory.getbasetemp().parent

    build_path = root_tmp_dir / 'kbuild'
    with FileLock(str(build_path) + '.lock'):
        tools = kbuild_semantics(
            output_dir=build_path, config_file=KBUILD_ML_PATH, target=HASKELL, llvm=True, booster=True, bug_report=None
        )
        return tools


@pytest.fixture(scope='session')
def lemma_proofs_tools(tmp_path_factory: TempPathFactory, worker_id: str) -> Tools:
    if worker_id == 'master':
        root_tmp_dir = tmp_path_factory.getbasetemp()
    else:
        root_tmp_dir = tmp_path_factory.getbasetemp().parent

    build_path = root_tmp_dir / 'kbuild'
    with FileLock(str(build_path) + '.lock'):
        tools = kbuild_semantics(
            output_dir=build_path,
            config_file=KBUILD_ML_PATH,
            target=LEMMA_PROOFS,
            llvm=False,
            booster=False,
            bug_report=None,
        )
        return tools
