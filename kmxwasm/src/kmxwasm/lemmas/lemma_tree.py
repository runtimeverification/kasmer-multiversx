from abc import ABC, abstractmethod
from dataclasses import dataclass
from pathlib import Path

from pyk.kast.att import Atts, KAtt
from pyk.kast.inner import KApply, KInner, KRewrite, KVariable, Subst, var_occurrences
from pyk.kast.manip import count_vars, free_vars
from pyk.kast.outer import KDefinition, KRule
from pyk.ktool.kprint import KPrint
from pyk.prelude.kbool import andBool, notBool
from pyk.prelude.kint import eqInt, leInt, ltInt
from pyk.prelude.ml import mlAnd
from pyk.prelude.utils import token

from ..ast.collections import simple_list
from ..ast.domains import addInt, concatBytes, int2BytesLen, int2BytesNoLen, lengthBytes, subInt, substrBytes
from ..build import HASKELL, semantics


def get_unique_var(vars: dict[str, list[KVariable]], name: str) -> KVariable:
    if not name in vars:
        raise ValueError(f'{name:!r} not in {vars}')
    all_vars = vars[name]
    if 0 == len(all_vars):
        raise ValueError(f'Zero variables for {name:!r}')
    # if 1 < len(all_vars):
    #     raise ValueError(f'Too many values for {name}: {all_vars}')
    return all_vars[0]


def var_dict_contains_variable(vars: dict[str, list[KVariable]], var: KVariable) -> bool:
    if not var.name in vars:
        return False
    existing = get_unique_var(vars, var.name)
    if var.sort and not existing == var:
        raise ValueError(f'Conflicting vars: {existing} and {var}')
    return True


def term_contains_variable(term: KInner, var: KVariable) -> bool:
    return var_dict_contains_variable(var_occurrences(term), var)


def check_term_contains_all_variables_from(containing: KInner, contained: KInner) -> None:
    contained_vars = var_occurrences(contained)
    containing_vars = var_occurrences(containing)
    for var_name in contained_vars.keys():
        var = get_unique_var(contained_vars, var_name)
        if not var_dict_contains_variable(containing_vars, var):
            raise ValueError(f'{var} in {contained} but not in {containing}')


def check_disinct_variables(containing: KInner, contained: KInner) -> None:
    contained_vars = var_occurrences(contained)
    containing_vars = var_occurrences(containing)
    for var_name in contained_vars.keys():
        var = get_unique_var(contained_vars, var_name)
        if var_dict_contains_variable(containing_vars, var):
            raise ValueError(f'{var} both in {contained} and {containing}')


def check_term_contains_variable(term: KInner, var: KVariable) -> None:
    if not term_contains_variable(term, var):
        raise ValueError(f'Variable {var.name} not in {term}')


@dataclass
class SplitRule:
    lhs: KInner
    rhs: KInner
    requires: list[KInner]
    concrete: list[KVariable]
    priority: int = -1
    enabled: bool = True
    disabled_explanation: str = ''

    def append_to(self, lines: list[str], printer: KPrint) -> None:
        rule = self.make_rule(printer.definition)
        rule_str = printer.pretty_print(rule)
        rule_lines = rule_str.splitlines()
        if not self.enabled:
            min_len = len(rule_lines[0])
            pairs = [(line, line.lstrip()) for line in rule_lines]
            for l, ls in pairs:
                prefix_len = len(l) - len(ls)
                if prefix_len < min_len:
                    min_len = prefix_len
            comment = (' ' * min_len) + '// '
            rule_lines = [comment + ls for (_, ls) in pairs]
            if self.disabled_explanation:
                rule_lines.insert(0, comment + self.disabled_explanation)
        lines += rule_lines

    def make_rule(self, kast_defn: KDefinition) -> KRule:
        # TODO: consider using or refactoring pyx.cterm.build_rule
        requires = andBool(self.requires)
        lhs_vars = free_vars(self.lhs)
        rhs_vars = free_vars(self.rhs)
        var_occurrences = count_vars(mlAnd([KRewrite(self.lhs, self.rhs), requires]))
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

        attributes = [Atts.SIMPLIFICATION('')]
        if self.concrete:
            attributes.append(Atts.CONCRETE(','.join([v.name for v in self.concrete])))
        if self.priority > 0:
            attributes.append(Atts.PRIORITY(str(self.priority)))

        return KRule(body=KRewrite(lhs, rhs), requires=requires, att=KAtt(attributes))


class SplitTree(ABC):
    @abstractmethod
    def generate(self, base_formula: KInner, requires: list[KInner], concrete: list[KVariable]) -> list[SplitRule]: ...


@dataclass
class VariableConcretizeSplitTree(SplitTree):
    variable: KVariable
    concretizations: list[tuple[KInner, SplitTree]]
    owise: SplitTree | None

    def generate(self, base_formula: KInner, requires: list[KInner], concrete: list[KVariable]) -> list[SplitRule]:
        check_term_contains_variable(base_formula, self.variable)
        retv = []
        for concretization, tree in self.concretizations:
            check_disinct_variables(base_formula, concretization)
            subst = Subst({self.variable.name: concretization})
            new_base_formula = subst.apply(base_formula)
            print('(')
            print(' ', subst)
            print('  ****')
            print(' ', base_formula)
            print('  ****')
            print(' ', new_base_formula)
            new_requires = [subst.apply(r) for r in requires]
            retv += tree.generate(new_base_formula, new_requires, concrete)
            print(')')
            print()
        return retv


@dataclass
class RequiresSplitTree(SplitTree):
    condition: KInner
    when_true: SplitTree
    when_false: SplitTree

    def generate(self, base_formula: KInner, requires: list[KInner], concrete: list[KVariable]) -> list[SplitRule]:
        check_term_contains_all_variables_from(base_formula, self.condition)
        return self.when_true.generate(base_formula, requires + [self.condition], concrete) + self.when_false.generate(
            base_formula, requires + [notBool(self.condition)], concrete
        )


@dataclass
class ConcreteSplitTree(SplitTree):
    variable: KVariable
    when_concrete: SplitTree
    when_ignored: SplitTree

    def generate(self, base_formula: KInner, requires: list[KInner], concrete: list[KVariable]) -> list[SplitRule]:
        return self.when_concrete.generate(
            base_formula, requires, concrete + [self.variable]
        ) + self.when_ignored.generate(base_formula, requires, concrete)


@dataclass
class ResultSplitTree(SplitTree):
    result: KInner
    priority: int = -1

    def generate(self, base_formula: KInner, requires: list[KInner], concrete: list[KVariable]) -> list[SplitRule]:
        check_term_contains_all_variables_from(base_formula, self.result)
        return [
            SplitRule(
                lhs=base_formula,
                requires=requires,
                rhs=self.result,
                concrete=concrete,
                priority=self.priority,
                enabled=True,
            )
        ]


@dataclass
class NotHandledSplitTree(SplitTree):
    def generate(self, base_formula: KInner, requires: list[KInner], concrete: list[KVariable]) -> list[SplitRule]:
        return [
            SplitRule(
                lhs=base_formula,
                requires=requires,
                rhs=KVariable('NotHandled'),
                concrete=concrete,
                priority=-1,
                enabled=False,
            )
        ]


@dataclass
class JoinSplitTree(SplitTree):
    trees: list[SplitTree]

    def generate(self, base_formula: KInner, requires: list[KInner], concrete: list[KVariable]) -> list[SplitRule]:
        return [
            rule
            for tree in self.trees
            for rule in tree.generate(base_formula=base_formula, requires=requires, concrete=concrete)
        ]


def lemma_tree(base_formula: KInner, split_tree: SplitTree) -> list[SplitRule]:
    return split_tree.generate(base_formula=base_formula, requires=[], concrete=[])


def bytesConcat(first: KInner, second: KInner) -> KApply:  # noqa: N802
    return KApply('_+Bytes__BYTES-HOOKED_Bytes_Bytes_Bytes', first, second)


def sparse_bytes_concat(first: KInner, second: KInner) -> KApply:
    return KApply('concatSparseBytes', first, second)


def sparse_bytes_merge(first: KInner, second: KInner) -> KApply:
    return KApply('mergeSparseBytes', first, second)


def sparse_bytes_update(function: KInner, sb: KInner, start: KInner, width: KInner) -> KApply:
    return KApply('updateSparseBytes', function, sb, start, width)


def list_sparse_bytes(elements: list[KInner]) -> KInner:
    return simple_list(
        concat_label='___SPARSE-BYTES_SparseBytes_SBItemChunk_SparseBytes',
        empty_label='.List{"___SPARSE-BYTES_SparseBytes_SBItemChunk_SparseBytes"}_SparseBytes',
        items=elements,
    )


def split_sparse_bytes(
    var: KVariable,
    empty: SplitTree,
    element_list: tuple[KVariable, KVariable, SplitTree],
    concat: tuple[KVariable, KVariable, SplitTree],
    merge: tuple[KVariable, KVariable, SplitTree],
    update: tuple[KVariable, KVariable, KVariable, KVariable, SplitTree],
) -> SplitTree:
    return VariableConcretizeSplitTree(
        variable=var,
        concretizations=[
            (list_sparse_bytes([]), empty),
            (list_sparse_bytes([element_list[0], element_list[1]]), element_list[2]),
            (sparse_bytes_concat(concat[0], concat[1]), concat[2]),
            (sparse_bytes_merge(merge[0], merge[1]), merge[2]),
            (sparse_bytes_update(update[0], update[1], update[2], update[3]), update[4]),
        ],
        owise=not_implemented(),
    )


def split_sparse_bytes_item(
    item: KVariable,
    when_empty: tuple[KVariable, SplitTree],
    when_bytes: tuple[KVariable, SplitTree],
) -> SplitTree:
    return VariableConcretizeSplitTree(
        variable=item,
        concretizations=[
            (empty_sb_item(when_empty[0]), when_empty[1]),
            (bytes_sb_item(when_bytes[0]), when_bytes[1]),
        ],
        owise=not_implemented(),
    )


def split_bytes(
    var: KVariable,
    concrete: tuple[KVariable, SplitTree],
    concat: tuple[KVariable, KVariable, SplitTree],
    int2byteslen: tuple[KVariable, KVariable, KVariable, SplitTree],
    int2bytesnolen: tuple[KVariable, KVariable, KVariable, SplitTree],
) -> SplitTree:
    return VariableConcretizeSplitTree(
        variable=var,
        concretizations=[
            (concrete[0], split_concrete(concrete[0], when_concrete=concrete[1])),
            (bytesConcat(concat[0], concat[1]), concat[2]),
            (int2BytesLen(int2byteslen[0], int2byteslen[1], int2byteslen[2]), int2byteslen[3]),
            (int2BytesNoLen(int2bytesnolen[0], int2bytesnolen[1], int2bytesnolen[2]), int2bytesnolen[3]),
        ],
        owise=not_implemented(),
    )


def split_bool(condition: KInner, when_true: SplitTree, when_false: SplitTree) -> SplitTree:
    return RequiresSplitTree(condition=condition, when_true=when_true, when_false=when_false)


def split_maybe_true(condition: KInner, when_true: SplitTree, default: SplitTree) -> SplitTree:
    return JoinSplitTree(
        [
            RequiresSplitTree(
                condition=condition,
                when_true=when_true,
                when_false=not_implemented('The condition may not have a false value'),
            ),
            default,
        ]
    )


def split_int_comparison(
    values: tuple[KInner, KInner], when_less: SplitTree, when_eq: SplitTree, when_greater: SplitTree
) -> SplitTree:
    return split_bool(
        condition=ltInt(values[0], values[1]),
        when_true=when_less,
        when_false=split_bool(condition=eqInt(values[0], values[1]), when_true=when_eq, when_false=when_greater),
    )


def split_int_vs_0(value: KInner, when_less: SplitTree, when_eq: SplitTree, when_greater: SplitTree) -> SplitTree:
    return split_int_comparison((value, token(0)), when_less=when_less, when_eq=when_eq, when_greater=when_greater)


def result(rhs: KInner, priority: int = -1) -> SplitTree:
    return ResultSplitTree(result=rhs, priority=priority)


def not_implemented(explanation: str = '') -> SplitTree:
    return NotHandledSplitTree()


NOT_IMPLEMENTED = not_implemented()


def split_concrete(
    variable: KVariable, when_concrete: SplitTree, when_ignored: SplitTree = NOT_IMPLEMENTED
) -> SplitTree:
    return ConcreteSplitTree(variable=variable, when_concrete=when_concrete, when_ignored=when_ignored)


def chunk(sbitem: KInner) -> KApply:
    return KApply('SBChunk(_)_SPARSE-BYTES_SBItemChunk_SBItem', sbitem)


def empty_sb_item(size: KInner) -> KApply:
    return KApply('SBItem:empty', size)


def bytes_sb_item(value: KInner) -> KApply:
    return KApply('SBItem:bytes', value)


def empty_chunk(size: KInner) -> KApply:
    return chunk(empty_sb_item(size))


def bytes_chunk(value: KInner) -> KApply:
    return chunk(bytes_sb_item(value))


def function_commutes_at_start(f: KInner) -> KApply:
    return KApply('functionCommutesAtStart', f)


def sizeSparseBytesItem(item: KInner) -> KApply:  # noqa: N802
    return KApply('SBItem:size', item)


def sizeSparseBytes(sparse_bytes: KInner) -> KApply:  # noqa: N802
    return KApply('SparseBytes:size', sparse_bytes)


def concatSparseBytes(first: KInner, second: KInner) -> KApply:  # noqa: N802
    return KApply('concatSparseBytes', first, second)


def splitSparseBytes(split_point: KInner, prefix: KInner, suffix: KInner) -> KApply:  # noqa: N802
    return KApply('splitSparseBytes', suffix, prefix, split_point)


def canSplitSparseBytesSimple(function: KInner, sparse_bytes: KInner, position: KInner) -> KApply:  # noqa: N802
    return KApply('canSplitSparseBytesSimple', function, sparse_bytes, position)


def canSplitSparseBytesUpdate(  # noqa: N802
    function: KInner, sparse_bytes: KInner, position: KInner, update_start: KInner, update_width: KInner
) -> KApply:
    return KApply('canSplitSparseBytes', function, sparse_bytes, position, update_start, update_width)


def splitSparseBytesUpdateTail(  # noqa: N802
    function: KInner, sparse_bytes: KInner, start: KInner, width: KInner, position: KInner
) -> KApply:
    return KApply('splitSparseBytesUpdateTail', function, sparse_bytes, start, width, position)


def splitSparseBytesHeadUpdate(  # noqa: N802
    function: KInner, sparse_bytes: KInner, start: KInner, width: KInner, position: KInner
) -> KApply:
    return KApply('splitSparseBytesHeadUpdate', function, sparse_bytes, start, width, position)


def print_lemmas(lemmas: list[SplitRule], module_name: str, file_name: Path, printer: KPrint) -> None:
    lines: list[str] = []
    for lemma in lemmas:
        lemma.append_to(lines, printer)
        lines.append('')
    file_name.write_text('\n'.join(lines))


def update_rules() -> list[SplitRule]:
    update_base_term = sparse_bytes_update(
        function=KVariable('F'), sb=KVariable('SB'), start=KVariable('Start'), width=KVariable('Width')
    )
    update_tree = split_int_vs_0(
        value=KVariable('Start'),
        when_less=not_implemented(),
        when_greater=split_maybe_true(
            condition=canSplitSparseBytesSimple(
                function=KVariable('F'), sparse_bytes=KVariable('SB'), position=KVariable('Start')
            ),
            default=split_int_comparison(
                values=(addInt(KVariable('Start'), KVariable('Width')), sizeSparseBytes(KVariable('SB'))),
                when_less=split_maybe_true(
                    condition=canSplitSparseBytesSimple(
                        function=KVariable('F'),
                        sparse_bytes=KVariable('SB'),
                        position=addInt(KVariable('Start'), KVariable('Width')),
                    ),
                    default=not_implemented(),
                    when_true=result(
                        splitSparseBytesUpdateTail(
                            function=KVariable('F'),
                            sparse_bytes=KVariable('SB'),
                            start=KVariable('Start'),
                            width=KVariable('Width'),
                            position=addInt(KVariable('Start'), KVariable('Width')),
                        )
                    ),
                ),
                when_eq=not_implemented(),
                when_greater=not_implemented(),
            ),
            when_true=result(
                splitSparseBytesHeadUpdate(
                    sparse_bytes=KVariable('SB'),
                    function=KVariable('F'),
                    start=KVariable('Start'),
                    width=KVariable('Width'),
                    position=KVariable('Start'),
                )
            ),
        ),
        when_eq=split_int_comparison(
            values=(KVariable('Width'), sizeSparseBytes(KVariable('SB'))),
            when_less=split_maybe_true(
                condition=canSplitSparseBytesSimple(
                    function=KVariable('F'), sparse_bytes=KVariable('SB'), position=KVariable('Width')
                ),
                default=not_implemented(),
                when_true=result(
                    splitSparseBytesUpdateTail(
                        sparse_bytes=KVariable('SB'),
                        function=KVariable('F'),
                        start=token(0),
                        width=KVariable('Width'),
                        position=KVariable('Width'),
                    )
                ),
            ),
            when_eq=not_implemented('Should be handled by function-specific rules'),
            when_greater=not_implemented('Should be handled by function-specific rules'),
        ),
    )
    return lemma_tree(base_formula=update_base_term, split_tree=update_tree)


def split_rules() -> list[SplitRule]:
    position_var = KVariable('Position')
    prefix_var = KVariable('Prefix')
    suffix_var = KVariable('Suffix')
    split_sb_base_term = splitSparseBytes(split_point=position_var, prefix=prefix_var, suffix=suffix_var)
    sbi_var = KVariable('SBItem')
    sbhead_var = KVariable('SBHead')
    sbtail_var = KVariable('SBTail')
    empty_size_var = KVariable('EmptySize')
    bytes_var = KVariable('A')
    bytes_b_var = KVariable('B')
    bytes_c_var = KVariable('C')
    bytes_d_var = KVariable('D')
    bytes_e_var = KVariable('E')
    update_f_var = KVariable('UpdateF')
    update_sb_var = KVariable('UpdateSB')
    update_start_var = KVariable('UpdateStart')
    update_width_var = KVariable('UpdateWidth')
    size_var = KVariable('IntSize')
    value_var = KVariable('IntValue')
    endianess_var = KVariable('Endianess')
    signedness_var = KVariable('Signedness')
    dummy_1_var = KVariable('_1')
    dummy_2_var = KVariable('_2')

    def split_sb_merge_tree(sbi: KVariable, sbtail: KVariable, position: KVariable) -> SplitTree:
        print(sbi)
        return split_bool(
            condition=ltInt(position, sizeSparseBytesItem(sbi)),
            when_true=split_sparse_bytes_item(
                item=sbi,
                when_empty=(
                    empty_size_var,
                    result(
                        splitSparseBytes(
                            split_point=token(0),
                            prefix=concatSparseBytes(prefix_var, empty_chunk(position)),
                            suffix=concatSparseBytes(empty_chunk(subInt(empty_size_var, position)), sbtail),
                        )
                    ),
                ),
                when_bytes=(
                    bytes_var,
                    split_bytes(
                        var=bytes_var,
                        concrete=(
                            bytes_b_var,
                            split_concrete(
                                variable=position,
                                when_concrete=result(
                                    splitSparseBytes(
                                        split_point=token(0),
                                        prefix=concatSparseBytes(
                                            prefix_var, bytes_chunk(substrBytes(bytes_b_var, token(0), position))
                                        ),
                                        suffix=concatSparseBytes(
                                            bytes_chunk(substrBytes(bytes_b_var, position, lengthBytes(bytes_b_var))),
                                            sbtail,
                                        ),
                                    )
                                ),
                            ),
                        ),
                        concat=(
                            bytes_b_var,
                            bytes_c_var,
                            split_bool(
                                condition=ltInt(position, lengthBytes(bytes_b_var)),
                                when_true=split_bytes(
                                    var=bytes_b_var,
                                    concrete=(
                                        bytes_d_var,
                                        split_concrete(
                                            variable=position,
                                            when_concrete=result(
                                                splitSparseBytes(
                                                    split_point=token(0),
                                                    prefix=concatSparseBytes(
                                                        prefix_var,
                                                        bytes_chunk(substrBytes(bytes_d_var, token(0), position_var)),
                                                    ),
                                                    suffix=concatSparseBytes(
                                                        bytes_chunk(
                                                            concatBytes(
                                                                substrBytes(
                                                                    bytes_d_var, position, lengthBytes(bytes_d_var)
                                                                ),
                                                                bytes_c_var,
                                                            )
                                                        ),
                                                        sbtail,
                                                    ),
                                                )
                                            ),
                                        ),
                                    ),
                                    concat=(
                                        bytes_d_var,
                                        bytes_e_var,
                                        not_implemented(
                                            'Should wait for the bytes associativity lemma to remove this case.'
                                        ),
                                    ),
                                    int2byteslen=(
                                        size_var,
                                        value_var,
                                        endianess_var,
                                        not_implemented(
                                            'This is doable, but usually needing this split implies an error.'
                                        ),
                                    ),
                                    int2bytesnolen=(
                                        value_var,
                                        endianess_var,
                                        signedness_var,
                                        not_implemented(
                                            'This is doable, but usually needing this split implies an error.'
                                        ),
                                    ),
                                ),
                                when_false=result(
                                    splitSparseBytes(
                                        split_point=token(0),
                                        prefix=concatSparseBytes(prefix_var, bytes_chunk(bytes_b_var)),
                                        suffix=concatSparseBytes(bytes_chunk(bytes_c_var), sbtail),
                                    )
                                ),
                            ),
                        ),
                        int2byteslen=(
                            size_var,
                            value_var,
                            endianess_var,
                            not_implemented('This is doable, but usually needing this split implies an error.'),
                        ),
                        int2bytesnolen=(
                            value_var,
                            endianess_var,
                            signedness_var,
                            not_implemented('This is doable, but usually needing this split implies an error.'),
                        ),
                    ),
                ),
            ),
            when_false=result(
                splitSparseBytes(
                    split_point=subInt(position_var, sizeSparseBytesItem(sbi)),
                    prefix=concatSparseBytes(prefix_var, sbi),
                    suffix=sbtail,
                )
            ),
        )

    split_sb_tree = split_bool(
        condition=leInt(position_var, token(0)),
        when_true=not_implemented('Nothing to do.'),
        when_false=split_bool(
            condition=ltInt(position_var, sizeSparseBytes(suffix_var)),
            when_true=split_sparse_bytes(
                var=suffix_var,
                empty=not_implemented('Nothing to do.'),
                element_list=(
                    sbi_var,
                    sbtail_var,
                    split_sb_merge_tree(sbi=sbi_var, sbtail=sbtail_var, position=position_var),
                ),
                concat=(
                    sbhead_var,
                    sbtail_var,
                    split_bool(
                        condition=ltInt(position_var, sizeSparseBytes(sbhead_var)),
                        when_true=split_sparse_bytes(
                            var=sbhead_var,
                            empty=not_implemented('Waiting for concat to simplify this.'),
                            element_list=(
                                dummy_1_var,
                                dummy_2_var,
                                not_implemented('Waiting for concat to simplify this.'),
                            ),
                            concat=(dummy_1_var, dummy_2_var, not_implemented('Waiting for concat to simplify this.')),
                            merge=(dummy_1_var, dummy_2_var, not_implemented('Waiting for concat to simplify this.')),
                            update=(
                                update_f_var,
                                update_sb_var,
                                update_start_var,
                                update_width_var,
                                split_maybe_true(
                                    condition=canSplitSparseBytesUpdate(
                                        function=update_f_var,
                                        sparse_bytes=update_sb_var,
                                        position=position_var,
                                        update_start=update_start_var,
                                        update_width=update_width_var,
                                    ),
                                    default=not_implemented(),
                                    when_true=result(
                                        splitSparseBytes(
                                            split_point=position_var,
                                            prefix=prefix_var,
                                            suffix=concatSparseBytes(
                                                splitSparseBytesUpdateTail(
                                                    sparse_bytes=update_sb_var,
                                                    function=update_f_var,
                                                    start=update_start_var,
                                                    width=update_width_var,
                                                    position=position_var,
                                                ),
                                                sbtail_var,
                                            ),
                                        )
                                    ),
                                ),
                            ),
                        ),
                        when_false=result(
                            splitSparseBytes(
                                split_point=subInt(position_var, sizeSparseBytes(sbhead_var)),
                                prefix=concatSparseBytes(prefix_var, sbhead_var),
                                suffix=sbtail_var,
                            )
                        ),
                    ),
                ),
                merge=(sbi_var, sbtail_var, split_sb_merge_tree(sbi=sbi_var, sbtail=sbtail_var, position=position_var)),
                update=(
                    update_f_var,
                    update_sb_var,
                    update_start_var,
                    update_width_var,
                    split_maybe_true(
                        condition=canSplitSparseBytesUpdate(
                            function=update_f_var,
                            sparse_bytes=update_sb_var,
                            position=position_var,
                            update_start=update_start_var,
                            update_width=update_width_var,
                        ),
                        default=not_implemented(),
                        when_true=result(
                            splitSparseBytes(
                                split_point=position_var,
                                prefix=prefix_var,
                                suffix=splitSparseBytesUpdateTail(
                                    sparse_bytes=update_sb_var,
                                    function=update_f_var,
                                    start=update_start_var,
                                    width=update_width_var,
                                    position=position_var,
                                ),
                            )
                        ),
                    ),
                ),
            ),
            when_false=result(
                splitSparseBytes(
                    split_point=subInt(position_var, sizeSparseBytes(suffix_var)),
                    prefix=concatSparseBytes(prefix_var, suffix_var),
                    suffix=list_sparse_bytes([]),
                )
            ),
        ),
    )

    return split_sb_tree.generate(base_formula=split_sb_base_term, requires=[], concrete=[])


def main() -> None:
    tools = semantics(HASKELL, booster=False, llvm=False, bug_report=None)
    print_lemmas(
        lemmas=update_rules(),
        module_name='UPDATE-SPARSE-BYTES-LEMMAS',
        file_name=Path('/mnt/data/runtime-verification/elrond-wasm-2/kmxwasm/tmp/update-lemmas.md'),
        printer=tools.printer,
    )
    print_lemmas(
        lemmas=split_rules(),
        module_name='SPLIT-SPARSE-BYTES-LEMMAS',
        file_name=Path('/mnt/data/runtime-verification/elrond-wasm-2/kmxwasm/tmp/split-lemmas.md'),
        printer=tools.printer,
    )


if __name__ == '__main__':
    main()
