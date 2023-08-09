#!/usr/bin/env python3

import sys

from pyk.prelude.collections import LIST
from pyk.prelude.kbool import BOOL, FALSE, TRUE, andBool, notBool, orBool
from pyk.prelude.kint import INT, eqInt, gtInt, leInt, ltInt
from pyk.prelude.ml import mlEquals

from ..build import LEMMA_PROOFS, kbuild_semantics
from ..paths import KBUILD_DIR, KBUILD_ML_PATH, ROOT
from .expression import (
    addInt,
    divIntTotal,
    geInt,
    maxInt,
    modInt,
    modIntTotal,
    moduloBetween0AndM,
    mulInt,
    numberAsDivModulo,
    numberAsDivModuloHelper,
    numberAsTDivModulo,
    numberAsTDivModuloHelper,
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
    HelperLemma,
    Lemma,
    LemmaProof,
    concrete,
    make_helper_lemmas_module,
    make_proven_lemmas_module,
    smt_lemma,
)
from .proof import basicListInduction, proofSplit, proofVar

LEMMAS_DIR = ROOT / 'kmxwasm' / 'k-src' / 'lemmas'
PROOFS_DIR = LEMMAS_DIR / 'proofs'

HELPER_LEMMAS_FILE = PROOFS_DIR / 'helper-lemmas.md'
LEMMAS_FILE = LEMMAS_DIR / 'proven-elrond-lemmas.md'

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
            Lemma(leInt(v(0), poundBool(B)), TRUE, attributes=[smt_lemma]),
            Lemma(leInt(poundBool(B), v(1)), TRUE, attributes=[smt_lemma]),
            Lemma(ltInt(poundBool(B), v(1)), notBool(B)),
            Lemma(mlEquals(v(0), poundBool(B)), mlEquals(FALSE, B)),
            Lemma(mlEquals(v(1), poundBool(B)), mlEquals(TRUE, B)),
        ],
    ),
    LemmaProof(
        name='list-size',
        proof=[basicListInduction(L)],
        lemmas=[
            Lemma(geInt(sizeList(L), v(0)), TRUE, attributes=[smt_lemma]),
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
            Lemma(ltInt(modIntTotal(X, Y), Y), TRUE, requires=gtInt(Y, v(0)), attributes=[smt_lemma]),
            Lemma(
                leInt(v(0), modIntTotal(X, Y)),
                TRUE,
                requires=gtInt(Y, v(0)),
                attributes=[smt_lemma],
            ),
            Lemma(
                modIntTotal(addInt(X, Y), Z),
                modIntTotal(addInt(X, modInt(Y, Z)), Z),
                requires=andBool([notBool(eqInt(Z, v(0))), geInt(Y, Z)]),
                attributes=[concrete(Y, Z)],
            ),
            Lemma(
                mlEquals(modIntTotal(addInt(X, Y), M), modIntTotal(addInt(X, Z), M)),
                mlEquals(modIntTotal(Y, M), modIntTotal(Z, M)),
            ),
            Lemma(
                modIntTotal(X, Y),
                X,
                requires=andBool([leInt(v(0), X), ltInt(X, Y)]),
                attributes=[],
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
    # with kbuild_semantics(KBUILD_DIR, config_file=KBUILD_ML_PATH) as tools:
    #     tools.printer
    #     return

    LEMMAS_FILE.write_text('```k\nmodule PROVEN-ELROND-LEMMAS\nendmodule\n```\n')
    HELPER_LEMMAS_FILE.write_text('```k\nmodule HELPER-LEMMAS\nendmodule\n```\n')

    with kbuild_semantics(KBUILD_DIR, config_file=KBUILD_ML_PATH, target=LEMMA_PROOFS) as tools:
        for lemma in LEMMAS:
            definition = lemma.make_definition()
            printed = tools.printer.pretty_print(definition)
            proof_path = PROOFS_DIR / f'{lemma.name.lower()}.k'
            proof_path.write_text(cleanup(printed))

        lemmas_module = make_proven_lemmas_module(LEMMAS, tools.printer.definition)
        printed_lemmas = tools.printer.pretty_print(lemmas_module)
        LEMMAS_FILE.write_text('```k\n' + cleanup(printed_lemmas) + '\n```\n')

        helper_module = make_helper_lemmas_module(HELPER_LEMMAS)
        printed_helper = tools.printer.pretty_print(helper_module)
        HELPER_LEMMAS_FILE.write_text('```k\n' + cleanup(printed_helper) + '\n```\n')

    with kbuild_semantics(KBUILD_DIR, config_file=KBUILD_ML_PATH, target=LEMMA_PROOFS) as tools:
        tools.printer


if __name__ == '__main__':
    main(sys.argv[1:])
