from dataclasses import dataclass

from pyk.kast.att import _ANY, _NONE, EMPTY_ATT, AttKey, Atts, KAtt
from pyk.kast.inner import KInner, KRewrite, KSequence, KVariable, Subst
from pyk.kast.manip import count_vars, free_vars
from pyk.kast.outer import KClaim, KDefinition, KFlatModule, KImport, KRequire, KRule
from pyk.prelude.k import DOTS
from pyk.prelude.kbool import TRUE
from pyk.prelude.ml import mlAnd, mlEquals

from .expression import commands_cell, instrs_cell, is_ml, k_cell, mandos_cell, proofOperationList
from .proof import proofEnd, runProof, runProofStep

HELPER_MODULE = 'HELPER-LEMMAS'
HELPER_MODULE_TRUSTED = 'HELPER-LEMMAS-TRUSTED'


@dataclass(frozen=True)
class Attribute:
    name: str
    value: str = ''

    def add_to_dict(self, d: dict[str, str]) -> None:
        d[self.name] = self.value


SMT_LEMMA = AttKey('smt-lemma', type=_NONE)
CONCRETE = AttKey('concrete', type=_ANY)


@dataclass(frozen=True)
class Lemma:
    lhs: KInner
    rhs: KInner
    requires: KInner = TRUE
    att: KAtt = EMPTY_ATT

    def make_claim(self, proof: KInner) -> KClaim:
        assert is_ml(self.lhs) == is_ml(self.rhs)
        ens = mlEquals(self.lhs, self.rhs)
        rewrite = mandos_cell(
            k_cell(KSequence(KRewrite(runProof(proof), proofEnd), DOTS)),
            commands_cell(KSequence()),
            instrs_cell(KSequence()),
            DOTS,
        )
        return KClaim(body=rewrite, requires=self.requires, ensures=ens)

    def make_rule(self, kast_defn: KDefinition) -> KRule:
        # TODO: consider using or refactoring pyx.cterm.build_rule
        lhs_vars = free_vars(self.lhs)
        rhs_vars = free_vars(self.rhs)
        var_occurrences = count_vars(mlAnd([KRewrite(self.lhs, self.rhs), self.requires]))
        v_subst: dict[str, KVariable] = {}
        for v in var_occurrences:
            new_v = v
            if var_occurrences[v] == 1:
                new_v = '_' + new_v
            if v in rhs_vars and v not in lhs_vars:
                new_v = '?' + new_v
            if new_v != v:
                v_subst[v] = KVariable(new_v)  # noqa: B909

        lhs = Subst(v_subst)(self.lhs)
        rhs = self.rhs  # apply_existential_substitutions(Subst(v_subst)(self.rhs))

        lhs = kast_defn.sort_vars(lhs)
        rhs = kast_defn.sort_vars(rhs)

        return KRule(body=KRewrite(lhs, rhs), requires=self.requires, att=self.att.update([Atts.SIMPLIFICATION('')]))


@dataclass(frozen=True)
class LemmaProof:
    name: str
    proof: list[KInner]
    lemmas: list[Lemma]

    def make_claim_module(self) -> KFlatModule:
        proof = proofOperationList(self.proof)
        claims = [l.make_claim(proof) for l in self.lemmas]
        imports = [
            KImport(name='MX-WASM-LEMMA-PROOFS', public=False),
            KImport(name=HELPER_MODULE_TRUSTED, public=False),
        ]
        return KFlatModule(name=self.name.upper(), sentences=claims, imports=imports)

    def make_definition(self) -> KDefinition:
        return KDefinition(
            main_module_name=self.name.upper(),
            all_modules=[self.make_claim_module()],
            requires=[KRequire('helper-lemmas.k')],
        )

    def make_rules(self, kast_defn: KDefinition) -> list[KRule]:
        return [l.make_rule(kast_defn) for l in self.lemmas]


def make_proven_lemmas_module(lemma_proofs: list[LemmaProof], kast_defn: KDefinition) -> KFlatModule:
    rules = [r for lemma in lemma_proofs for r in lemma.make_rules(kast_defn)]
    imports = [
        KImport(name='BOOL', public=False),
        KImport(name='CEILS', public=False),
        KImport(name='ELROND', public=False),
        KImport(name='INT', public=False),
        KImport(name='LIST', public=False),
    ]
    return KFlatModule(name='PROVEN-MX-LEMMAS', sentences=rules, imports=imports)


@dataclass(frozen=True)
class HelperLemma:
    proof: KInner
    requires: KInner = TRUE
    ensures: KInner = TRUE

    def make_claim(self) -> KClaim:
        rewrite = mandos_cell(
            k_cell(KSequence(KRewrite(runProofStep(self.proof), proofEnd), DOTS)),
            commands_cell(KSequence()),
            instrs_cell(KSequence()),
            DOTS,
        )
        return KClaim(body=rewrite, requires=self.requires, ensures=self.ensures)


def make_helper_lemmas_module(lemmas: list[HelperLemma], trusted: bool = False) -> KFlatModule:
    def make_trusted(c: KClaim) -> KClaim:
        return c.let_att(c.att.update([Atts.TRUSTED(None)]))

    claims = [l.make_claim() for l in lemmas]
    if trusted:
        claims = [make_trusted(c) for c in claims]
    imports = [
        KImport(name='MX-WASM-LEMMA-PROOFS', public=False),
    ]
    name = HELPER_MODULE
    if trusted:
        name = HELPER_MODULE_TRUSTED
    return KFlatModule(name=name, sentences=claims, imports=imports)
