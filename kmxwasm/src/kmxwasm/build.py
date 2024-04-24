from pyk.kdist import kdist
from pyk.utils import BugReport

from .tools import Tools

HASKELL = 'haskell'
LLVM = 'llvm'
LLVM_LIBRARY = 'llvm-library'
LEMMA_PROOFS = 'lemma-proofs'
LEMMA_TESTS = 'lemma-tests'


def semantics(target: str, booster: bool, llvm: bool, bug_report: BugReport | None) -> Tools:
    return Tools(
        definition_dir=kdist.get(f'mxwasm-semantics.{target}'),
        llvm_definition_dir=kdist.get('mxwasm-semantics.llvm') if llvm else None,
        llvm_library_definition_dir=kdist.get('mxwasm-semantics.llvm-library') if booster else None,
        booster=booster,
        bug_report=bug_report,
    )
