from pathlib import Path

import pytest

from pyk.cterm import CTerm
from pyk.prelude.ml import mlOr

from kmxwasm.testing.fixtures import Tools

K_SRC_DIR = Path(__file__).parent.parent.parent.parent / 'k-src'
LEMMA_PROOFS_DIR = K_SRC_DIR / 'lemmas' / 'tests'
PROVE_FILES = tuple(LEMMA_PROOFS_DIR.rglob('*.k'))
PROVE_TEST_DATA = tuple(((str(input_path.relative_to(K_SRC_DIR)), input_path)) for input_path in PROVE_FILES)


@pytest.mark.parametrize(('test_id', 'test_file'), PROVE_TEST_DATA, ids=[test_id for test_id, _ in PROVE_TEST_DATA])
def test_success(test_id: str, test_file: Path, lemma_tests_tools: Tools) -> None:
    result = lemma_tests_tools.kprove.prove(test_file)
    assert CTerm._is_top(mlOr([res.kast for res in result]))
