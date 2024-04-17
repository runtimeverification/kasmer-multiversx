import pytest
from filelock import FileLock
from pyk.utils import BugReport
from pytest import FixtureRequest, Parser, TempPathFactory

from ..build import HASKELL, LEMMA_PROOFS, LEMMA_TESTS, Kompiled, kbuild_semantics
from ..property_testing.paths import KBUILD_DIR, KBUILD_ML_PATH
from ..tools import Tools


def pytest_addoption(parser: Parser) -> None:
    parser.addoption('--use-kbuild-dir', action='store_true', default=False)


@pytest.fixture(scope='session')
def kompiled(request: FixtureRequest, tmp_path_factory: TempPathFactory, worker_id: str) -> Kompiled:
    if request.config.getoption('--use-kbuild-dir'):
        build_path = KBUILD_DIR
    else:
        if worker_id == 'master':
            root_tmp_dir = tmp_path_factory.getbasetemp()
        else:
            root_tmp_dir = tmp_path_factory.getbasetemp().parent
        build_path = root_tmp_dir / 'kbuild'

    with FileLock(str(build_path) + '.lock'):
        return Kompiled(output_dir=build_path, config_file=KBUILD_ML_PATH, target=HASKELL, llvm=True, booster=True)


@pytest.fixture
def tools(kompiled: Kompiled, bug_report: BugReport) -> Tools:
    return kompiled.make_tools(bug_report)


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
