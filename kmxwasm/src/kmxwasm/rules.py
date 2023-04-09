from typing import Dict, List, Tuple

from pyk.kast.inner import KApply, KInner, KRewrite, KToken, KVariable, bottom_up
from pyk.kast.manip import ml_pred_to_bool
from pyk.kast.outer import KAtt, KDefinition, KProduction, KRule, KSentence, KTerminal
from pyk.kcfg import KCFG
from pyk.prelude.bytes import BYTES, bytesToken
from pyk.prelude.kbool import TRUE, andBool
from pyk.prelude.kint import INT
from pyk.prelude.ml import mlAnd

from .kast import (
    DOT_BYTES,
    SET_BYTES_RANGE,
    bytes_to_string,
    find_term,
    get_inner,
    has_questionmark_variables,
    make_rewrite,
    replace_term,
    underscore_for_unused_vars,
)


class RuleCreator:
    def __init__(self, definition: KDefinition, macro_cells: Dict[str, str], priority: int) -> None:
        self.__macros: Dict[str, Tuple[str, KInner]] = {}
        self.__macro_rules: List[KSentence] = []
        self.__rules: List[KRule] = []
        self.__definition = definition
        self.__macro_cells = macro_cells
        self.__priority = priority

    def add_rule(self, lhs_id: str, rhs_id: str, kcfg: KCFG) -> None:
        lhs_cterm = kcfg.node(lhs_id).cterm
        rhs_cterm = kcfg.node(rhs_id).cterm
        if not self.__macro_rules:
            self.__initialize_macros(lhs_cterm.config)

        lhs = self.__replace_macros(lhs_cterm.config)
        # TODO: This is WRONG, should find a better way to solve the speed issue.
        lhs = replace_term(lhs, '<funcs>', KVariable('MyFuncs'))
        lhs = replace_term(lhs, '<funcAddrs>', KVariable('MyFuncAddrs'))
        # lhs = replace_term(lhs, '<funcIds>', KVariable('MyFuncIds'))

        rhs = self.__replace_macros(rhs_cterm.config)
        # TODO: This is WRONG, should find a better way to solve the speed issue.
        rhs = replace_term(rhs, '<funcs>', KVariable('MyFuncs'))
        rhs = replace_term(rhs, '<funcAddrs>', KVariable('MyFuncAddrs'))
        # rhs = replace_term(rhs, '<funcIds>', KVariable('MyFuncIds'))
        self.__rules.append(
            make_final_rule_new(lhs, lhs_cterm.constraints, rhs, rhs_cterm.constraints, self.__priority)
        )

    def add_raw_rule(self, rule: KRule) -> None:
        self.__rules.append(rule.let(att=default_atts(self.__priority)))

    def __initialize_macros(self, config: KInner) -> None:
        for cell, macro_name in self.__macro_cells.items():
            child = find_term(config, cell)
            assert child is not None
            self.__macros[cell] = (macro_name, child)
            self.__add_macro_rules(macro_name, child)

    def __replace_macros(self, config: KInner) -> KInner:
        for cell, macro_name in self.__macro_cells.items():
            _macro_name, macro_value = self.__macros[cell]
            child = find_term(config, cell)
            assert child == macro_value
            config = replace_term(config, cell, KApply(macro_name))
        return config

    def __add_macro_rules(self, name: str, term: KInner) -> None:
        assert isinstance(term, KApply)
        self.__macro_rules.append(
            KProduction(
                sort=self.__definition.return_sort(term.label),
                items=[KTerminal(name), KTerminal('('), KTerminal(')')],
                att=KAtt({'macro': ''}),
            )
        )
        self.__macro_rules.append(KRule(body=KRewrite(KApply(name), term)))

    def macro_rules(self) -> List[KSentence]:
        return self.__macro_rules

    def summarize_rules(self) -> List[KRule]:
        return self.__rules


def default_atts(priority: int) -> KAtt:
    att_dict = {'priority': str(priority)}
    return KAtt(atts=att_dict)


def make_final_rule_new(
    lhs: KInner,
    lhs_constraints: Tuple[KInner, ...],
    rhs: KInner,
    rhs_constraints: Tuple[KInner, ...],
    priority: int,
) -> KRule:
    (rewrite, requires_constraint, ensures_constraint) = build_rewrite_requires_new(
        lhs, lhs_constraints, rhs, rhs_constraints
    )
    rewrite = underscore_for_unused_vars(rewrite, mlAnd([requires_constraint, ensures_constraint]))

    return KRule(body=rewrite, requires=requires_constraint, ensures=ensures_constraint, att=default_atts(priority))


def build_rewrite_requires_new(
    lhs: KInner, lhs_constraints: Tuple[KInner, ...], rhs: KInner, rhs_constraints: Tuple[KInner, ...]
) -> Tuple[KInner, KInner, KInner]:
    lhs_config = unpack_bytes(lhs)
    rhs_config = unpack_bytes(rhs)
    rewrite = make_rewrite(lhs_config, rhs_config)
    rewrite = get_inner(rewrite, 0, '<elrond-wasm>')
    requires = [c for c in lhs_constraints if c != TRUE]
    ensures = []
    for c in rhs_constraints:
        if c != TRUE and c not in lhs_constraints:
            if not has_questionmark_variables(c):
                requires.append(c)
            else:
                ensures.append(c)
    requires_constraint = andBool([ml_pred_to_bool(c) for c in requires])
    ensures_constraint = andBool([ml_pred_to_bool(c) for c in ensures])
    return (rewrite, requires_constraint, ensures_constraint)


# TODO: This is probably no longer needed and should be removed.
def unpack_bytes_callback(term: KInner) -> KInner:
    if isinstance(term, KApply):
        if term.label.name == SET_BYTES_RANGE:
            return compute_bytes(term)
    return term


# TODO: This is probably no longer needed and should be removed.
def unpack_bytes(term: KInner) -> KInner:
    term = bottom_up(unpack_bytes_callback, term)
    return term


# TODO: This is probably no longer needed and should be removed.
def compute_bytes(term: KInner) -> KToken:
    if isinstance(term, KToken):
        assert term.sort == BYTES, term
        return term
    assert isinstance(term, KApply)
    if term.label.name == DOT_BYTES:
        return bytesToken('')
    assert term.label.name == SET_BYTES_RANGE, term
    assert len(term.args) == 3, term
    (inner, start, token) = term.args

    inner = compute_bytes(inner)
    assert inner.sort == BYTES, inner
    inner_str = bytes_to_string(inner.token)

    assert isinstance(start, KToken), start
    assert start.sort == INT
    start_int = int(start.token)

    assert isinstance(token, KToken), token
    assert token.sort == BYTES, token
    token_str = bytes_to_string(token.token)

    if len(inner_str) < start_int + len(token_str):
        inner_str += '\x00' * (start_int + len(token_str) - len(inner_str))
    inner_str = inner_str[:start_int] + token_str + inner_str[start_int + len(token_str) :]

    return bytesToken(inner_str)
