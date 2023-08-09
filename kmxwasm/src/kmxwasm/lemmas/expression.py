from typing import Iterable

from pyk.kast.inner import KApply, KInner, KSequence, KSort, KToken, KVariable
from pyk.prelude.kint import intToken

from ..ast.collections import simple_list

ML_LABELS = {
    '#Not',
    '#And',
    '#Or',
    '#Implies',
    '#Iff',
    '#Exists',
    '#Forall',
    '#Top',
    '#Bottom',
    '#Ceil',
    '#Floor',
    '#Equals',
    '#In',
}


def var(name: str, sort: KSort) -> KVariable:
    return KVariable(name, sort)


def v(value: int) -> KToken:
    return intToken(value)


# TODO: Move to pyk.


def addInt(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('_+Int_', i1, i2)


def mulInt(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('_*Int_', i1, i2)


def subInt(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('_-Int_', i1, i2)


def divInt(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('_/Int_', i1, i2)


def modInt(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('_modInt_', i1, i2)


def geInt(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('_>=Int_', i1, i2)


def sizeList(l: KInner) -> KApply:  # noqa: N802
    return KApply('size(_)_LIST_Int_List', l)  # TODO: make sizeList in K a symbol.


def maxInt(l: KInner, r: KInner) -> KApply:  # noqa: N802
    return KApply('maxInt(_,_)_INT-COMMON_Int_Int_Int', l, r)  # TODO: make maxInt in K a symbol.


# DO NOT MOVE TO PYK


def tDivIntTotal(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('_/IntTotal_', i1, i2)


def tModIntTotal(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('_%IntTotal_', i1, i2)


def modIntTotal(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('modIntTotal', i1, i2)


def divIntTotal(i1: KInner, i2: KInner) -> KApply:  # noqa: N802
    return KApply('divIntTotal', i1, i2)


def poundBool(b: KInner) -> KApply:  # noqa: N802
    return KApply('boolToInt', b)


def moduloBetween0AndM(number: KInner, m: KInner) -> KApply:  # noqa: N802
    return KApply('moduloBetween0AndM', number, m)


def tModuloBetween0AndM(number: KInner, m: KInner) -> KApply:  # noqa: N802
    return KApply('tModuloBetween0AndM', number, m)


def numberAsDivModulo(number: KInner, m: KInner) -> KApply:  # noqa: N802
    return KApply('numberAsDivModulo', number, m)


def numberAsDivModuloHelper(  # noqa: N802
    number: KInner, m: KInner, current_div: KInner, current_mod: KInner
) -> KApply:
    return KApply('numberAsDivModuloHelper', number, m, current_div, current_mod)


def numberAsTDivModulo(number: KInner, m: KInner) -> KApply:  # noqa: N802
    return KApply('numberAsTDivModulo', number, m)


def numberAsTDivModuloHelper(  # noqa: N802
    number: KInner, m: KInner, current_div: KInner, current_mod: KInner
) -> KApply:
    return KApply('numberAsTDivModuloHelper', number, m, current_div, current_mod)


def is_ml(term: KInner) -> bool:
    return isinstance(term, KApply) and (term.label.name in ML_LABELS)


def k_cell(contents: KSequence) -> KApply:
    return KApply('<k>', contents)


def commands_cell(contents: KSequence) -> KApply:
    return KApply('<commands>', contents)


def instrs_cell(contents: KSequence) -> KApply:
    return KApply('<instrs>', contents)


def mandos_cell(*args: KInner) -> KApply:
    return KApply('<mandos>', *args)


def proofOperationList(proof: Iterable[KInner]) -> KInner:  # noqa: N802
    return simple_list(
        concat_label='proofOperationList', empty_label='.List{"proofOperationList"}_BytesStack', items=proof
    )
