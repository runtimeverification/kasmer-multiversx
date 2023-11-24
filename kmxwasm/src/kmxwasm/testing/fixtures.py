import pytest
from pytest import TempPathFactory

from ..build import HASKELL, kbuild_semantics
from ..property_testing.paths import KBUILD_ML_PATH
from ..tools import Tools


@pytest.fixture(scope='session')
def tools(tmp_path_factory: TempPathFactory) -> Tools:
    build_path = tmp_path_factory.mktemp('kbuild')
    tools = kbuild_semantics(
        output_dir=build_path, config_file=KBUILD_ML_PATH, target=HASKELL, booster=True, bug_report=None
    )
    return tools
