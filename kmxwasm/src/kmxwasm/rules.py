from typing import List, Tuple

from pyk.kast.inner import KApply, KInner, KSort, KVariable
from pyk.kast.manip import ml_pred_to_bool
from pyk.kast.outer import KAtt, KRule
from pyk.kcfg import KCFG
from pyk.kcfg.kcfg import NodeIdLike
from pyk.prelude.kbool import TRUE, andBool

from .kast import (
    fix_configuration_map_items_cterm,
    get_inner,
    has_questionmark_variables,
    make_rewrite,
    replace_single_term,
    replace_term_with_seq_variable,
)

RULE_TOP_CELL = '<generatedTop>'


class RuleCreator:
    def __init__(self, priority: int) -> None:
        self.__rules: List[KRule] = []
        self.__priority = priority

    def add_rule(self, lhs_id: NodeIdLike, rhs_id: NodeIdLike, kcfg: KCFG) -> None:
        lhs_cterm = kcfg.node(lhs_id).cterm
        rhs_cterm = kcfg.node(rhs_id).cterm

        lhs_cterm = fix_configuration_map_items_cterm(lhs_cterm)
        rhs_cterm = fix_configuration_map_items_cterm(rhs_cterm)

        lhs = lhs_cterm.config
        # TODO: This is WRONG, should find a better way to solve the speed issue.
        lhs = replace_single_term(lhs, '<funcs>', KVariable('MyFuncs', KSort('FuncsCell')))
        lhs = replace_term_with_seq_variable(lhs, '<funcAddrs>', 'MyFuncAddrs', KSort('FuncAddrsCell'))
        lhs = KApply(RULE_TOP_CELL, [lhs, KVariable('MyGeneratedCounter')])

        rhs = rhs_cterm.config
        # TODO: This is WRONG, should find a better way to solve the speed issue.
        rhs = replace_single_term(rhs, '<funcs>', KVariable('MyFuncs', KSort('FuncsCell')))
        rhs = replace_term_with_seq_variable(rhs, '<funcAddrs>', 'MyFuncAddrs', KSort('FuncAddrsCell'))
        rhs = KApply(RULE_TOP_CELL, [rhs, KVariable('MyGeneratedCounter')])

        self.__rules.append(
            make_final_rule_new(
                lhs, lhs_cterm.constraints, rhs, rhs_cterm.constraints, self.__priority, len(self.__rules)
            )
        )

    def add_raw_rule(self, rule: KRule) -> None:
        print('add_raw_rule: ', default_atts)
        self.__rules.append(rule.let(att=default_atts(self.__priority, len(self.__rules))))

    def summarize_rules(self) -> List[KRule]:
        return self.__rules


def default_atts(priority: int, rule_index: int) -> KAtt:
    att_dict = {'priority': str(priority), 'label': f'summaryrule{rule_index}'}
    return KAtt(atts=att_dict)


def make_final_rule_new(
    lhs: KInner,
    lhs_constraints: Tuple[KInner, ...],
    rhs: KInner,
    rhs_constraints: Tuple[KInner, ...],
    priority: int,
    rule_index: int,
) -> KRule:
    (rewrite, requires, ensures) = build_rewrite_requires_new(lhs, lhs_constraints, rhs, rhs_constraints)

    return KRule(body=rewrite, requires=requires, ensures=ensures, att=default_atts(priority, rule_index))


def build_rewrite_requires_new(
    lhs: KInner, lhs_constraints: Tuple[KInner, ...], rhs: KInner, rhs_constraints: Tuple[KInner, ...]
) -> Tuple[KInner, KInner, KInner]:
    rewrite = make_rewrite(lhs, rhs)
    rewrite = get_inner(rewrite, 0, RULE_TOP_CELL)
    requires = [c for c in lhs_constraints if c != TRUE]
    ensures = []
    for c in rhs_constraints:
        if c != TRUE and c not in lhs_constraints:
            if has_questionmark_variables(c):
                ensures.append(c)
            else:
                requires.append(c)
    requires_constraint = andBool([ml_pred_to_bool(c, unsafe=True) for c in requires])
    ensures_constraint = andBool([ml_pred_to_bool(c, unsafe=True) for c in ensures])
    return (rewrite, requires_constraint, ensures_constraint)
