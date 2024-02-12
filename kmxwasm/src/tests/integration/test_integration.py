import sys
from pathlib import Path

import pytest

from kmxwasm.ast.configuration import wrap_with_generated_top_if_needed
from kmxwasm.json import load_json_kclaim
from kmxwasm.property_testing.running import Success, run_claim
from kmxwasm.property_testing.wasm_krun_initializer import WasmKrunInitializer
from kmxwasm.testing.fixtures import Tools

sys.setrecursionlimit(1500000000)


TEST_DATA = (Path(__file__).parent / 'data').resolve(strict=True)
INPUT_FILES = [TEST_DATA / 'test_call_add_less-spec.json', TEST_DATA / 'test_fund-spec-1k.json']


@pytest.mark.parametrize(
    'test_file', INPUT_FILES, ids=[str(test_file.relative_to(TEST_DATA)) for test_file in INPUT_FILES]
)
def test_success(test_file: Path, tools: Tools) -> None:
    claim = load_json_kclaim(test_file)
    # Fix the claim, it's not clear why these cells are being
    # removed when generating claims.
    claim = claim.let(body=wrap_with_generated_top_if_needed(claim.body))

    result = run_claim(
        tools,
        WasmKrunInitializer(tools),
        claim=claim,
        restart_kcfg=None,
        depth=1000,
        run_id=None,
    )

    assert isinstance(result, Success), [result]
