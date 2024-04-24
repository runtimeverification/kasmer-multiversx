from pathlib import Path

import pytest
from pyk.cterm import CTerm
from pyk.prelude.ml import mlOr

from kmxwasm.testing.fixtures import Tools

CURRENT_DIR = Path(__file__).parent

LEMMA_UNITTEST_DIR = CURRENT_DIR / 'unit_tests'
UNITTEST_FILES = tuple(LEMMA_UNITTEST_DIR.rglob('*.k'))
UNIT_TEST_DATA = tuple(((str(input_path.relative_to(CURRENT_DIR)), input_path)) for input_path in UNITTEST_FILES)

LEMMA_REGRESSION_DIR = CURRENT_DIR / 'regression_tests'
REGRESSION_FILES = tuple(LEMMA_REGRESSION_DIR.rglob('*.k'))
REGRESSION_TEST_DATA = tuple(
    ((str(input_path.relative_to(CURRENT_DIR)), input_path)) for input_path in REGRESSION_FILES
)


@pytest.mark.parametrize(('test_id', 'test_file'), UNIT_TEST_DATA, ids=[test_id for test_id, _ in UNIT_TEST_DATA])
def test_unit(test_id: str, test_file: Path, lemma_tests_tools: Tools) -> None:
    result = lemma_tests_tools.kprove.prove(test_file)
    result_or = mlOr([res.kast for res in result])
    if not CTerm._is_top(result_or):
        print(lemma_tests_tools.printer.pretty_print(result_or))
    assert CTerm._is_top(result_or)


@pytest.mark.parametrize(
    ('test_id', 'test_file'), REGRESSION_TEST_DATA, ids=[test_id for test_id, _ in REGRESSION_TEST_DATA]
)
def test_regression(test_id: str, test_file: Path, lemma_tests_tools: Tools) -> None:
    result = lemma_tests_tools.kprove.prove(test_file)
    result_or = mlOr([res.kast for res in result])
    if not CTerm._is_top(result_or):
        print(lemma_tests_tools.printer.pretty_print(result_or))
    assert CTerm._is_top(result_or)
