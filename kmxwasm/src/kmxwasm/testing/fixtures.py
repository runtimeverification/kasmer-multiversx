import pytest
from pyk.utils import BugReport

from kmxwasm.build import semantics
from kmxwasm.tools import Tools


@pytest.fixture
def tools(bug_report: BugReport) -> Tools:
    return semantics(target='haskell', booster=True, llvm=True, bug_report=bug_report)


@pytest.fixture
def lemma_proofs_tools(bug_report: BugReport) -> Tools:
    return semantics(target='lemma-proofs', booster=False, llvm=False, bug_report=bug_report)


@pytest.fixture
def lemma_tests_tools(bug_report: BugReport) -> Tools:
    return semantics(target='lemma-tests', booster=False, llvm=False, bug_report=bug_report)
