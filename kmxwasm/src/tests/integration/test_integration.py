from pathlib import Path

import pytest

from pyk.kast.inner import KApply
from pyk.prelude.utils import token

from kmxwasm.build import HASKELL, kbuild_semantics
from kmxwasm.property_testing.paths import KBUILD_DIR, KBUILD_ML_PATH, ROOT
from kmxwasm.tools import Tools
from kmxwasm.json import load_json_kclaim
from kmxwasm.property_testing.wasm_krun_initializer import WasmKrunInitializer
from kmxwasm.property_testing.running import Success, run_claim

TEST_DATA = (Path(__file__).parent / 'data').resolve(strict=True)
INPUT_FILES = [TEST_DATA / 'test_call_add_less-spec.json']

@pytest.fixture(scope='module')
def tools() -> Tools:
    return  kbuild_semantics(
                output_dir=KBUILD_DIR, config_file=KBUILD_ML_PATH, target=HASKELL, booster=False
            )

@pytest.mark.parametrize('test_file', INPUT_FILES, ids=[str(test_file.relative_to(TEST_DATA)) for test_file in INPUT_FILES])
def test_success(test_file:Path, tools:Tools) -> None:
    claim = load_json_kclaim(test_file)
    # Fix the claim, it's not clear why these cells are being
    # removed when generating claims.
    claim = claim.let(body=KApply('<generatedTop>', [claim.body, KApply('<generatedCounter>', [token(0)])]))

    result = run_claim(
        tools,
        WasmKrunInitializer(tools),
        claim=claim,
        restart_kcfg=None,
        depth=1000,
        run_id = None,
    )

    assert isinstance(result, Success), [result]

