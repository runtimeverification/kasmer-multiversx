from pyk.kast.inner import KApply, KInner, KSequence

from ..ast.elrond import commands_cell_contents, instrs_cell_contents, k_cell_contents


def quick_ksequence_implication_check(antecedent: KSequence, consequent: KSequence) -> bool:
    if antecedent.arity == 0:
        if consequent.arity == 0:
            return True
        if isinstance(consequent.items[0], KApply):
            return False
        return True
    if consequent.arity == 0:
        if isinstance(antecedent.items[0], KApply):
            return False
        return True
    firsta = antecedent.items[0]
    firstc = consequent.items[0]
    if not isinstance(firsta, KApply):
        return True
    if not isinstance(firstc, KApply):
        return True
    return firsta.label.name == firstc.label.name


def quick_implication_check(antecedent: KInner, consequent: KInner) -> bool:
    if not quick_ksequence_implication_check(k_cell_contents(antecedent), k_cell_contents(consequent)):
        return False
    if not quick_ksequence_implication_check(commands_cell_contents(antecedent), commands_cell_contents(consequent)):
        return False
    if not quick_ksequence_implication_check(instrs_cell_contents(antecedent), instrs_cell_contents(consequent)):
        return False
    return True
