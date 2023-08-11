import operator
from typing import Callable, Dict, Iterable, List, Optional, Tuple, TypeVar

from pyk.cterm import CTerm
from pyk.kast.inner import (
    KApply,
    KAs,
    KInner,
    KLabel,
    KRewrite,
    KSequence,
    KSort,
    KToken,
    KVariable,
    bottom_up,
    top_down,
)
from pyk.kast.manip import push_down_rewrites

V = TypeVar('V')

SET_BYTES_RANGE = '#setBytesRange(_,_,_)_WASM-DATA-COMMON_Bytes_Bytes_Int_Bytes'
DOT_BYTES = '.Bytes_BYTES-HOOKED_Bytes'


def replace_child_with_generator(term: KInner, parent_name: str, replacement_fn: Callable[[], KInner]) -> KInner:
    def replace_child_callback(term: KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if not term.label.name == parent_name:
            return term
        assert term.arity == 1, term
        replacement = replacement_fn()
        return term.let(args=[replacement])

    return top_down(replace_child_callback, term)


def replace_child_with_seq_variable(term: KInner, parent_name: str, variable_name: str, sort: KSort) -> KInner:
    index = 0

    def replacement_fn() -> KInner:
        nonlocal index
        result = KVariable(f'{variable_name}{index}', sort)
        index += 1
        return result

    retv = replace_child_with_generator(term, parent_name, replacement_fn)
    assert index, [parent_name, variable_name]
    return retv


def replace_child(term: KInner, parent_name: str, replacement: KInner) -> KInner:
    replaced = False

    def replacement_fn() -> KInner:
        nonlocal replaced

        assert not replaced, [parent_name, replacement]
        replaced = True
        return replacement

    retv = replace_child_with_generator(term, parent_name, replacement_fn)
    assert replaced, [parent_name]
    return retv


def replace_single_term(term: KInner, name: str, replacement: KInner) -> KInner:
    replaced = False

    def replace_term_callback(term: KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if not term.label.name == name:
            return term
        nonlocal replaced
        assert not replaced, [name, replacement]
        replaced = True
        return replacement

    retv = top_down(replace_term_callback, term)
    assert replaced, [name]
    return retv


def replace_term_with_seq_variable(term: KInner, name: str, variable_name: str, sort: KSort) -> KInner:
    index = 0

    def replace_term_callback(term: KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if not term.label.name == name:
            return term
        nonlocal index
        replacement = KVariable(f'{variable_name}{index}', sort)
        index += 1
        return replacement

    retv = top_down(replace_term_callback, term)
    assert index, [name, variable_name]
    return retv


def replace_variable(term: KInner, name: str, replacement: KInner) -> KInner:
    def replace_callback(term: KInner) -> KInner:
        if not isinstance(term, KVariable):
            return term
        if not term.name == name:
            return term
        return replacement

    return top_down(replace_callback, term)


def get_inner(term: KInner, idx: int, label: Optional[str]) -> KInner:
    assert isinstance(term, KApply), term
    assert idx < term.arity, [term, idx]
    retv = term.args[idx]
    if label is not None:
        assert isinstance(retv, KApply), retv
        assert retv.label.name == label, [retv.label.name, label]
    return retv


def get_inner_path(term: KInner, path: Iterable[Tuple[int, Optional[str]]]) -> KInner:
    for ids, label in path:
        term = get_inner(term, ids, label)
    return term


def load_token(term: KInner) -> str:
    assert isinstance(term, KToken), term
    return term.token


def load_token_from_child(term: KInner) -> str:
    assert isinstance(term, KApply), term
    assert len(term.args) == 1, term
    return load_token(term.args[0])


def load_map(term: KInner, value_loader: Callable[[KInner], V], loaded: Dict[str, V]) -> None:
    assert isinstance(term, KApply), term
    if term.label.name == '_Map_':
        assert term.arity == 2, term
        load_map(term.args[0], value_loader, loaded)
        load_map(term.args[1], value_loader, loaded)
    elif term.label.name == '_|->_':
        assert term.arity == 2, term
        key = load_token(term.args[0])
        value = value_loader(term.args[1])
        assert not key in loaded, [term, loaded, key]
        loaded[key] = value
    elif term.label.name == '.Map':
        pass
    else:
        raise AssertionError(term)


def filter_map(term: KInner, filter: Callable[[KApply], bool]) -> KApply:
    def find_items(term_: KInner) -> Optional[List[KApply]]:
        assert isinstance(term_, KApply), term_
        if term_.label.name == '_Map_':
            return None
        if term_.label.name == '.Map':
            return []
        if term_.label.name == '_|->_':
            if filter(term_):
                return [term_]
            return []
        raise AssertionError([term_, term_.label.name])

    children: List[KApply] = kinner_top_down_fold(find_items, operator.add, [], term)
    result: Optional[KApply] = None
    for c in children:
        if result is None:
            result = c
        else:
            result = KApply('_Map_', (c, result))
    if result is None:
        return KApply('.Map')
    return result


def load_map_from_child(term: KInner, value_loader: Callable[[KInner], V]) -> Dict[str, V]:
    assert isinstance(term, KApply), term
    assert len(term.args) == 1, term
    kdict = term.args[0]
    retv: Dict[str, V] = {}
    load_map(kdict, value_loader, retv)
    return retv


def get_children(item: KInner) -> Iterable[KInner]:
    if isinstance(item, KApply):
        return item.args
    if isinstance(item, KSort):
        return []
    if isinstance(item, KToken):
        return []
    if isinstance(item, KVariable):
        return []
    if isinstance(item, KLabel):
        return []
    if isinstance(item, KAs):
        return [item.pattern, item.alias]
    if isinstance(item, KRewrite):
        return [item.lhs, item.rhs]
    if isinstance(item, KSequence):
        return item.items
    raise AssertionError([item, type(item)])


def find_term(item: KInner, name: str) -> Optional[KInner]:
    def find_term_summarize(term: KInner) -> Optional[KInner]:
        if not isinstance(term, KApply):
            return None
        if not term.label.name == name:
            return None
        return term

    def find_term_merge(first: Optional[KInner], second: Optional[KInner]) -> Optional[KInner]:
        if first is None:
            return second
        if second is None:
            return first
        assert first == second
        return first

    return kinner_top_down_fold(find_term_summarize, find_term_merge, None, item)


def find_term_get_child(item: KInner, name: str) -> KInner:
    term = find_term(item, name)
    assert term is not None
    assert isinstance(term, KApply)
    assert term.arity == 1
    return term.args[0]


def kinner_top_down_fold(
    summarizer: Callable[[KInner], Optional[V]], merger: Callable[[V, V], V], default: V, to_fold: KInner
) -> V:
    summary = summarizer(to_fold)
    if summary is not None:
        return summary
    children = get_children(to_fold)
    summaries = [kinner_top_down_fold(summarizer, merger, default, x) for x in children]
    return fold(merger, summaries, default)


def extract_rewrite_parents(term: KInner) -> List[KInner]:
    def maybe_with_rewrite_child(value: KInner) -> Optional[List[KInner]]:
        children = get_children(value)
        if fold(operator.or_, [isinstance(x, KRewrite) for x in children], False):
            return [value]
        return None

    return kinner_top_down_fold(maybe_with_rewrite_child, operator.add, [], term)


def fold(folder: Callable[[V, V], V], to_fold: Iterable[V], initial: V) -> V:
    result = initial
    for item in reversed(list(to_fold)):
        result = folder(item, result)
    return result


def join_tree(label: str, leaves: List[KInner]) -> Optional[KInner]:
    tree: Optional[KInner] = None
    for leaf in leaves:
        if tree is None:
            tree = leaf
        else:
            tree = KApply(label, tree, leaf)
    return tree


def make_rewrite(lhs: KInner, rhs: KInner) -> KInner:
    def make_rewrite_if_needed(left: KInner, right: KInner) -> KInner:
        if left == right:
            return left
        return KRewrite(left, right)

    assert isinstance(lhs, KApply)
    assert isinstance(rhs, KApply)
    assert lhs.arity == rhs.arity, [lhs.arity, lhs.label, rhs.arity, rhs.label]
    assert lhs.label == rhs.label
    rw = lhs.let(args=[make_rewrite_if_needed(l, r) for (l, r) in zip(lhs.args, rhs.args, strict=True)])
    return push_down_rewrites(rw)


def has_questionmark_variables(term: KInner) -> bool:
    def maybe_is_questionmark_variable(term: KInner) -> Optional[bool]:
        if not isinstance(term, KVariable):
            return None
        if term.name.startswith('?'):
            return True
        return False

    assert isinstance(term, KInner)
    return kinner_top_down_fold(maybe_is_questionmark_variable, operator.or_, False, term)


def bytes_to_string(b: str) -> str:
    assert b.startswith('b"')
    assert b.endswith('"')

    b = b[2:-1]
    return b


def k_equals(first: KInner, second: KInner) -> KInner:
    return KApply('_==K_', [first, second])


def process_kapply(processor: Callable[[KApply], None], name: str, term: KInner) -> None:
    def process(t: KInner) -> KInner:
        if not isinstance(t, KApply):
            return t
        if not t.label.name == name:
            return t
        processor(t)
        return t

    bottom_up(process, term)


def fix_configuration_map_items_for_map(
    parent: str, concat: str, element: str, unit: str, child: str, term: KInner
) -> KInner:
    def fix(t: KInner) -> KInner:
        if not isinstance(t, KApply):
            return t
        if t.label.name in [parent, concat]:
            assert t.arity in [1, 2], t.arity
            new_args = []
            for arg in t.args:
                assert isinstance(arg, KApply)
                if arg.label.name in [concat, element, unit]:
                    new_args.append(arg)
                    continue
                assert arg.label.name == child, [arg.label.name, parent, concat, element, unit, child]
                assert arg.arity > 1
                new_args.append(KApply(element, (arg.args[0], arg)))
            return t.let(args=new_args)
        return t

    return bottom_up(fix, term)


def fix_configuration_map_items(term: KInner) -> KInner:
    """Fixes the representation for configuration maps returned by the Haskell backend.

    In axioms, configuration maps are represented something like this:
    <parentCell>
        mapConcat(
            mapItem(
                <keyCell> key </keyCell>,
                <valueCell>
                    <keyCell> key </keyCell>
                    ...
                </valueCell>
            ),
            mapConcat(...)
        )
    </parentCell>

    However, the RPC server seems to return this instead:
    <parentCell>
        mapConcat(
            <valueCell>
                <keyCell> key </keyCell>
                ...
            </valueCell>,
            mapConcat(...)
        )
    </parentCell>

    This seems to work fine in most cases. However, when creating rules
    on-the-fly, pyk notices that the sorts do not match, and replaces the above
    with
    <parentCell>
        mapConcat(
            inj{MapSort, ValueCellSort}(
                <valueCell>
                    <keyCell> key </keyCell>
                    ...
                </valueCell>
            ),
            mapConcat(...)
        )
    </parentCell>
    and the Haskell backend does not seem to be able to apply these rules properly.
    """
    term = fix_configuration_map_items_for_map(
        parent='<mems>',
        concat='_MemInstCellMap_',
        element='MemInstCellMapItem',
        unit='.MemInstCellMap',
        child='<memInst>',
        term=term,
    )
    term = fix_configuration_map_items_for_map(
        parent='<globals>',
        concat='_GlobalInstCellMap_',
        element='GlobalInstCellMapItem',
        unit='.GlobalInstCellMap',
        child='<globalInst>',
        term=term,
    )
    term = fix_configuration_map_items_for_map(
        parent='<moduleInstances>',
        concat='_ModuleInstCellMap_',
        element='ModuleInstCellMapItem',
        unit='.ModuleInstCellMap',
        child='<moduleInst>',
        term=term,
    )
    return term


def fix_configuration_map_items_cterm(cterm: CTerm) -> CTerm:
    return CTerm(fix_configuration_map_items(cterm.config), cterm.constraints)
