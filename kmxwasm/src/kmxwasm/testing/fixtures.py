import pytest
from filelock import FileLock
from pyk.kbuild.kbuild import KBuild
from pyk.kbuild.project import Project
from pytest import TempPathFactory

from ..build import HASKELL, LEMMA_PROOFS, LEMMA_TESTS, kbuild_semantics, kompile
from ..property_testing.paths import KBUILD_DIR, KBUILD_ML_PATH
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
def kompiled() -> tuple[KBuild, Project]:
    with FileLock(str(KBUILD_DIR / 'kbuild') + '.lock'):
        return kompile(
            output_dir=KBUILD_DIR,
            config_file=KBUILD_ML_PATH,
            target=HASKELL,
            llvm=True,
            booster=True,
        )


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


@pytest.fixture(scope='session')
def lemma_tests_tools(tmp_path_factory: TempPathFactory, worker_id: str) -> Tools:
    if worker_id == 'master':
        root_tmp_dir = tmp_path_factory.getbasetemp()
    else:
        root_tmp_dir = tmp_path_factory.getbasetemp().parent

    build_path = root_tmp_dir / 'kbuild'
    with FileLock(str(build_path) + '.lock'):
        tools = kbuild_semantics(
            output_dir=build_path,
            config_file=KBUILD_ML_PATH,
            target=LEMMA_TESTS,
            llvm=False,
            booster=False,
            bug_report=None,
        )
        return tools
