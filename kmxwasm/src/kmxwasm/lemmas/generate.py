#!/usr/bin/env python3

import sys
from pathlib import Path

from pyk.kast.att import KAtt
from pyk.prelude.collections import LIST
from pyk.prelude.kbool import BOOL, FALSE, TRUE, andBool, notBool, orBool
from pyk.prelude.kint import INT, eqInt, gtInt, leInt, ltInt
from pyk.prelude.ml import mlEquals

from ..build import LEMMA_PROOFS, semantics
from .expression import (
    addInt,
    divIntTotal,
    geInt,
    maxInt,
    modAddMultiple,
    modInt,
    modIntTotal,
    moduloBetween0AndM,
    mulInt,
    numberAsDivModulo,
    numberAsDivModuloHelper,
    numberAsTDivModulo,
    numberAsTDivModuloHelper,
    numberIsNumberMulDiv,
    poundBool,
    sizeList,
    subInt,
    tDivIntTotal,
    tModIntTotal,
    tModuloBetween0AndM,
    v,
    var,
)
from .lemmas import (
    CONCRETE,
    PRESERVES_DEFINEDNESS,
    SMT_LEMMA,
    HelperLemma,
    Lemma,
    LemmaProof,
    make_helper_lemmas_module,
    make_proven_lemmas_module,
)
from .proof import basicListInduction, proofSplit, proofVar

K_DIR = Path(__file__).parents[1] / 'kdist/mxwasm-semantics'
LEMMAS_DIR = K_DIR / 'lemmas'
PROOFS_DIR = LEMMAS_DIR / 'proofs'

HELPER_LEMMAS_FILE = PROOFS_DIR / 'helper-lemmas.k'
LEMMAS_FILE = LEMMAS_DIR / 'proven-mx-lemmas.md'

B = var('B', BOOL)
L = var('L', LIST)
M = var('M', INT)
T = var('T', INT)
X = var('X', INT)
Y = var('Y', INT)
Z = var('Z', INT)

HELPER_LEMMAS = [
    HelperLemma(
        proof=tModuloBetween0AndM(X, M),
        requires=ltInt(v(0), M),
        ensures=andBool([leInt(v(0), tModIntTotal(X, M)), ltInt(tModIntTotal(X, M), M)]),
    ),
    HelperLemma(
        proof=tModuloBetween0AndM(X, M),
        requires=ltInt(M, v(0)),
        ensures=andBool([leInt(tModIntTotal(X, M), v(0)), ltInt(M, tModIntTotal(X, M))]),
    ),
    HelperLemma(
        proof=moduloBetween0AndM(X, M),
        requires=ltInt(v(0), M),
        ensures=andBool([leInt(v(0), modIntTotal(X, M)), ltInt(modIntTotal(X, M), M)]),
    ),
    HelperLemma(
        proof=moduloBetween0AndM(X, M),
        requires=ltInt(M, v(0)),
        ensures=andBool([leInt(v(0), modIntTotal(X, M)), ltInt(modIntTotal(X, M), subInt(v(0), M))]),
    ),
    HelperLemma(
        proof=numberAsTDivModulo(X, M),
        requires=ltInt(v(0), M),
        ensures=eqInt(X, addInt(mulInt(tDivIntTotal(X, M), M), tModIntTotal(X, M))),
    ),
    HelperLemma(
        proof=numberAsTDivModulo(X, M),
        requires=ltInt(M, v(0)),
        ensures=eqInt(X, addInt(mulInt(tDivIntTotal(X, M), M), tModIntTotal(X, M))),
    ),
    HelperLemma(
        proof=numberAsTDivModuloHelper(X, M, Y, Z),
        requires=andBool(
            [
                ltInt(v(0), M),
                eqInt(X, addInt(mulInt(Y, M), Z)),
                eqInt(Y, tDivIntTotal(subInt(X, Z), M)),
                eqInt(tModIntTotal(X, M), tModIntTotal(Z, M)),
            ]
        ),
        ensures=eqInt(X, addInt(mulInt(tDivIntTotal(X, M), M), tModIntTotal(X, M))),
    ),
    HelperLemma(
        proof=numberAsTDivModuloHelper(X, M, Y, Z),
        requires=andBool(
            [
                ltInt(M, v(0)),
                eqInt(X, addInt(mulInt(Y, M), Z)),
                eqInt(Y, tDivIntTotal(subInt(X, Z), M)),
                eqInt(tModIntTotal(X, M), tModIntTotal(Z, M)),
            ]
        ),
        ensures=eqInt(X, addInt(mulInt(tDivIntTotal(X, M), M), tModIntTotal(X, M))),
    ),
    HelperLemma(
        proof=numberAsDivModulo(X, M),
        requires=ltInt(v(0), M),
        ensures=eqInt(X, addInt(mulInt(divIntTotal(X, M), M), modIntTotal(X, M))),
    ),
    HelperLemma(
        proof=numberAsDivModulo(X, M),
        requires=ltInt(M, v(0)),
        ensures=eqInt(X, addInt(mulInt(divIntTotal(X, M), M), modIntTotal(X, M))),
    ),
    HelperLemma(
        proof=numberIsNumberMulDiv(X, M),
        requires=andBool([notBool(eqInt(v(0), M))]),
        ensures=eqInt(X, divIntTotal(mulInt(X, M), M)),
    ),
    HelperLemma(
        proof=modAddMultiple(X, Y, M),
        requires=andBool([notBool(eqInt(v(0), M))]),
        ensures=eqInt(modIntTotal(X, M), modIntTotal(addInt(mulInt(Y, M), X), M)),
    ),
    HelperLemma(
        proof=numberAsDivModuloHelper(X, M, Y, Z),
        requires=andBool(
            [
                ltInt(v(0), M),
                eqInt(X, addInt(mulInt(Y, M), Z)),
                eqInt(Y, divIntTotal(subInt(X, Z), M)),
                eqInt(modIntTotal(X, M), modIntTotal(Z, M)),
            ]
        ),
        ensures=eqInt(X, addInt(mulInt(divIntTotal(X, M), M), modIntTotal(X, M))),
    ),
    HelperLemma(
        proof=numberAsDivModuloHelper(X, M, Y, Z),
        requires=andBool(
            [
                ltInt(M, v(0)),
                eqInt(X, addInt(mulInt(Y, M), Z)),
                eqInt(Y, divIntTotal(subInt(X, Z), M)),
                eqInt(modIntTotal(X, M), modIntTotal(Z, M)),
            ]
        ),
        ensures=eqInt(X, addInt(mulInt(divIntTotal(X, M), M), modIntTotal(X, M))),
    ),
]


LEMMAS = [
    LemmaProof(
        name='pound-bool',
        proof=[proofSplit(B)],
        lemmas=[
            Lemma(leInt(v(0), poundBool(B)), TRUE, att=KAtt([SMT_LEMMA(None)])),
            Lemma(leInt(poundBool(B), v(1)), TRUE, att=KAtt([SMT_LEMMA(None)])),
            Lemma(ltInt(poundBool(B), v(1)), notBool(B)),
            Lemma(mlEquals(v(0), poundBool(B)), mlEquals(FALSE, B)),
            Lemma(mlEquals(v(1), poundBool(B)), mlEquals(TRUE, B)),
        ],
    ),
    LemmaProof(
        name='list-size',
        proof=[basicListInduction(L)],
        lemmas=[
            Lemma(geInt(sizeList(L), v(0)), TRUE, att=KAtt([SMT_LEMMA(None)])),
        ],
    ),
    LemmaProof(
        name='max-inequalities',
        proof=[
            proofVar(X),
            proofSplit(
                leInt(Y, Z),
                when_true=[proofSplit(ltInt(X, Z), when_false=[proofSplit(ltInt(Z, X))])],
                when_false=[proofSplit(ltInt(Y, Z), when_false=[proofSplit(ltInt(Y, X))])],
            ),
        ],
        lemmas=[
            Lemma(leInt(X, maxInt(Y, Z)), TRUE, requires=orBool([leInt(X, Y), leInt(X, Z)])),
            Lemma(ltInt(X, maxInt(Y, Z)), TRUE, requires=orBool([ltInt(X, Y), ltInt(X, Z)])),
            Lemma(geInt(X, maxInt(Y, Z)), TRUE, requires=andBool([geInt(X, Y), geInt(X, Z)])),
            Lemma(gtInt(X, maxInt(Y, Z)), TRUE, requires=andBool([gtInt(X, Y), gtInt(X, Z)])),
            Lemma(geInt(maxInt(Y, Z), X), TRUE, requires=orBool([leInt(X, Y), leInt(X, Z)])),
            Lemma(gtInt(maxInt(Y, Z), X), TRUE, requires=orBool([ltInt(X, Y), ltInt(X, Z)])),
            Lemma(leInt(maxInt(Y, Z), X), TRUE, requires=andBool([geInt(X, Y), geInt(X, Z)])),
            Lemma(ltInt(maxInt(Y, Z), X), TRUE, requires=andBool([gtInt(X, Y), gtInt(X, Z)])),
        ],
    ),
    LemmaProof(
        name='int-inequalities-simple',
        proof=[
            proofVar(X),
            proofVar(Y),
            proofVar(Y),  # duplicate in order to remove kompile unused var warnings
            proofVar(Z),
            proofVar(Z),  # duplicate in order to remove kompile unused var warnings
        ],
        lemmas=[
            Lemma(gtInt(X, Y), ltInt(Y, X)),
            Lemma(geInt(X, Y), leInt(Y, X)),
            Lemma(ltInt(X, X), FALSE),
            Lemma(leInt(X, X), TRUE),
            Lemma(leInt(addInt(X, Y), X), leInt(Y, v(0))),
            Lemma(leInt(addInt(Y, X), X), leInt(Y, v(0))),
            Lemma(ltInt(addInt(X, Y), X), ltInt(Y, v(0))),
            Lemma(ltInt(addInt(Y, X), X), ltInt(Y, v(0))),
            Lemma(leInt(X, addInt(X, Y)), leInt(v(0), Y)),
            Lemma(leInt(X, addInt(Y, X)), leInt(v(0), Y)),
            Lemma(ltInt(X, addInt(X, Y)), ltInt(v(0), Y)),
            Lemma(ltInt(X, addInt(Y, X)), ltInt(v(0), Y)),
            Lemma(notBool(leInt(X, Y)), ltInt(Y, X)),
            Lemma(notBool(ltInt(X, Y)), leInt(Y, X)),
            Lemma(leInt(addInt(X, Y), Z), leInt(X, subInt(Z, Y)), att=KAtt([CONCRETE('Y, Z')])),
            Lemma(ltInt(addInt(X, Y), Z), ltInt(X, subInt(Z, Y)), att=KAtt([CONCRETE('Y, Z')])),
            Lemma(leInt(X, addInt(Y, Z)), leInt(subInt(X, Z), Y), att=KAtt([CONCRETE('X, Z')])),
            Lemma(ltInt(X, addInt(Y, Z)), ltInt(subInt(X, Z), Y), att=KAtt([CONCRETE('X, Z')])),
            Lemma(leInt(subInt(X, Y), Z), leInt(X, addInt(Y, Z)), att=KAtt([CONCRETE('Y, Z')])),
            Lemma(ltInt(subInt(X, Y), Z), ltInt(X, addInt(Y, Z)), att=KAtt([CONCRETE('Y, Z')])),
            Lemma(leInt(subInt(X, Y), Z), leInt(subInt(X, Z), Y), att=KAtt([CONCRETE('X, Z')])),
            Lemma(ltInt(subInt(X, Y), Z), ltInt(subInt(X, Z), Y), att=KAtt([CONCRETE('X, Z')])),
            Lemma(leInt(X, subInt(Y, Z)), leInt(addInt(X, Z), Y), att=KAtt([CONCRETE('X, Z')])),
            Lemma(ltInt(X, subInt(Y, Z)), ltInt(addInt(X, Z), Y), att=KAtt([CONCRETE('X, Z')])),
            Lemma(leInt(X, subInt(Y, Z)), leInt(Z, subInt(Y, X)), att=KAtt([CONCRETE('X, Y')])),
            Lemma(ltInt(X, subInt(Y, Z)), ltInt(Z, subInt(Y, X)), att=KAtt([CONCRETE('X, Y')])),
        ],
    ),
    LemmaProof(
        name='mod-int-total',
        proof=[proofVar(X), proofVar(Y), proofVar(Z), proofVar(T), proofVar(M)],
        lemmas=[
            Lemma(
                modIntTotal(addInt(addInt(modIntTotal(X, Y), Z), T), Y),
                modIntTotal(addInt(addInt(X, Z), T), Y),
            ),
            Lemma(
                modIntTotal(subInt(addInt(modIntTotal(X, Y), Z), T), Y),
                modIntTotal(subInt(addInt(X, Z), T), Y),
            ),
            Lemma(
                modIntTotal(addInt(modIntTotal(X, Y), Z), Y),
                modIntTotal(addInt(X, Z), Y),
            ),
            Lemma(
                modIntTotal(addInt(X, modIntTotal(Z, Y)), Y),
                modIntTotal(addInt(X, Z), Y),
            ),
            Lemma(ltInt(modIntTotal(X, Y), Y), TRUE, requires=gtInt(Y, v(0)), att=KAtt([SMT_LEMMA(None)])),
            Lemma(
                leInt(v(0), modIntTotal(X, Y)),
                TRUE,
                requires=gtInt(Y, v(0)),
                att=KAtt([SMT_LEMMA(None)]),
            ),
            Lemma(
                modIntTotal(addInt(X, Y), Z),
                modIntTotal(addInt(X, modInt(Y, Z)), Z),
                requires=andBool([notBool(eqInt(Z, v(0))), geInt(Y, Z)]),
                att=KAtt([CONCRETE('Y,Z'), PRESERVES_DEFINEDNESS]),
            ),
            Lemma(
                mlEquals(modIntTotal(addInt(X, Y), M), modIntTotal(addInt(X, Z), M)),
                mlEquals(modIntTotal(Y, M), modIntTotal(Z, M)),
            ),
            Lemma(
                modIntTotal(X, Y),
                X,
                requires=andBool([leInt(v(0), X), ltInt(X, Y)]),
            ),
        ],
    ),
]


def cleanup(s: str) -> str:
    old_s = ''
    while old_s != s:
        old_s = s
        s = s.replace(' \n', '\n')

    # This hack is needed because of https://github.com/runtimeverification/k-private-issues/issues/3
    s = s.replace('} ', '}:Bool ')
    return s


def main(args: list[str]) -> None:
    LEMMAS_FILE.write_text('```k\nmodule PROVEN-MX-LEMMAS\nendmodule\n```\n')
    HELPER_LEMMAS_FILE.write_text('module HELPER-LEMMAS\nendmodule\n')

    tools = semantics(target=LEMMA_PROOFS, booster=False, llvm=False, bug_report=None)

    for lemma in LEMMAS:
        definition = lemma.make_definition()
        printed = tools.printer.pretty_print(definition)
        proof_path = PROOFS_DIR / f'{lemma.name.lower()}.k'
        proof_path.write_text(cleanup(printed + '\n'))

    lemmas_module = make_proven_lemmas_module(LEMMAS, tools.printer.definition)
    printed_lemmas = tools.printer.pretty_print(lemmas_module)
    LEMMAS_FILE.write_text('```k\n' + cleanup(printed_lemmas) + '\n```\n')

    helper_module = make_helper_lemmas_module(HELPER_LEMMAS)
    printed_helper = tools.printer.pretty_print(helper_module)
    helper_module_trusted = make_helper_lemmas_module(HELPER_LEMMAS, trusted=True)
    printed_helper_trusted = tools.printer.pretty_print(helper_module_trusted)
    HELPER_LEMMAS_FILE.write_text(f'{cleanup(printed_helper)}\n\n{cleanup(printed_helper_trusted)}\n')

    tools = semantics(target=LEMMA_PROOFS, booster=False, llvm=False, bug_report=None)
    tools.printer


if __name__ == '__main__':
    main(sys.argv[1:])
