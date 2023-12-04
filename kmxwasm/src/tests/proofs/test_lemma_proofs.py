from pathlib import Path

import pytest

from kmxwasm.testing.fixtures import Tools


def is_known_broken(path: Path) -> bool:
    return path.name in ['mod-int-total.k', 'helper-lemmas.k']


K_SRC_DIR = Path(__file__).parent.parent.parent.parent / 'k-src'
LEMMA_PROOFS_DIR = K_SRC_DIR / 'lemmas' / 'proofs'
PROVE_FILES = tuple(LEMMA_PROOFS_DIR.rglob('*.k'))
PROVE_TEST_DATA = tuple(
    ((str(input_path.relative_to(K_SRC_DIR)), input_path))
    for input_path in PROVE_FILES
    if not is_known_broken(input_path)
)


@pytest.mark.parametrize(('test_id', 'test_file'), PROVE_TEST_DATA, ids=[test_id for test_id, _ in PROVE_TEST_DATA])
def test_success(test_id: str, test_file: Path, lemma_proofs_tools: Tools) -> None:
    lemma_proofs_tools.kprove.prove(test_file)
