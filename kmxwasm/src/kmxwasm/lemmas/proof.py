from typing import Iterable

from pyk.kast.inner import KApply

from .expression import KInner, KVariable, proofOperationList


def runProof(proof: KInner) -> KApply:  # noqa: N802
    return KApply('runProof', proof)


def runProofStep(step: KInner) -> KApply:  # noqa: N802
    return KApply('runProofStep', step)


proofNop = KApply('proofNop')  # noqa: N816
proofEnd = KApply('proofEnd')  # noqa: N816


def proofVar(v: KVariable) -> KApply:  # noqa: N802
    return KApply('proofVar', v)


def proofSplit(  # noqa: N802
    condition: KInner, when_true: Iterable[KInner] = (), when_false: Iterable[KInner] = ()
) -> KApply:
    return KApply('proofSplit', condition, proofOperationList(when_true), proofOperationList(when_false))


def destructList(list: KInner, with_element: KInner, when_empty: KInner) -> KApply:  # noqa: N802
    return KApply('destructList', list, with_element, when_empty)


def basicListInduction(value: KInner) -> KApply:  # noqa: N802
    return KApply('basicListInduction', value)
