from pyk.kast.inner import KApply, KInner
from pyk.prelude.utils import token

GENERATED_TOP_CELL_NAME = '<generatedTop>'
ZERO = token(0)


def wrap_with_generated_top_if_needed(term: KInner, counter: KInner = ZERO) -> KInner:
    if isinstance(term, KApply) and term.label.name == GENERATED_TOP_CELL_NAME:
        return term
    return wrap_with_generated_top(term, counter)


def wrap_with_generated_top(term: KInner, counter: KInner = ZERO) -> KInner:
    return KApply(GENERATED_TOP_CELL_NAME, term, KApply('<generatedCounter>', counter))
