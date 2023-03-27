import operator

from typing import Callable, Dict, Iterable, List, Optional, Tuple, TypeVar

from pyk.kast.inner import (
    KAs,
    KApply,
    KInner,
    KLabel,
    KRewrite,
    KSequence,
    KSort,
    KToken,
    KVariable,
    top_down,
    )

V = TypeVar('V')

def replace_child(term:KInner, parent_name:str, replacement:KInner) -> KInner:
    def replace_child_callback(term:KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if not term.label.name == parent_name:
            return term
        assert term.arity == 1, term
        return term.let(args=[replacement])

    return top_down(replace_child_callback, term)

def replace_term(term:KInner, name:str, replacement:KInner) -> KInner:
    def replace_term_callback(term:KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if not term.label.name == name:
            return term
        return replacement

    return top_down(replace_term_callback, term)


def get_inner(term:KInner, idx:int, label:Optional[str]) -> KInner:
  assert isinstance(term, KApply), term
  assert idx < term.arity, [term, idx]
  retv = term.args[idx]
  if label is not None:
    assert isinstance(retv, KApply), retv
    assert retv.label.name == label, [retv.label.name, label]
  return retv

def get_inner_path(term:KInner, path:Iterable[Tuple[int, Optional[str]]]) -> KInner:
    for (ids, label) in path:
        term = get_inner(term, ids, label)
    return term

def load_token(term:KInner) -> str:
    assert isinstance(term, KToken), term
    return term.token

def load_token_from_child(term:KInner) -> str:
    assert isinstance(term, KApply), term
    assert len(term.args) == 1, term
    return load_token(term.args[0])

def load_map(term:KInner, value_loader:Callable[[KInner], V], loaded: Dict[str, V]) -> None:
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

def filter_map(term:KInner, filter:Callable[[KApply], bool]) -> KApply:
    def find_items(term_:KInner) -> Optional[List[KApply]]:
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

    children = kinner_top_down_fold(find_items, operator.add, [], term)
    result:Optional[KApply] = None
    for c in children:
        if result is None:
            result = c
        else:
            result = KApply('_Map_', (c, result))
    if result is None:
        return KApply('.Map')
    return result

def load_map_from_child(term:KInner, value_loader:Callable[[KInner], V]) -> Dict[str, V]:
    assert isinstance(term, KApply), term
    assert len(term.args) == 1, term
    kdict = term.args[0]
    retv:Dict[str, V] = {}
    load_map(kdict, value_loader, retv)
    return retv

def get_children(item:KInner) -> Iterable[KInner]:
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

def find_term(item:KInner, name:str) -> Optional[KInner]:
    def find_term_summarize(term:KInner) -> Optional[KInner]:
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

def find_term_get_child(item:KInner, name:str) -> KInner:
    term = find_term(item, name)
    assert term is not None
    assert isinstance(term, KApply)
    assert term.arity == 1
    return term.args[0]

def kinner_top_down_fold(
    summarizer:Callable[[KInner], Optional[V]],
    merger:Callable[[V, V], V],
    default:V,
    to_fold:KInner
) -> V:
    summary = summarizer(to_fold)
    if summary is not None:
        return summary
    children = get_children(to_fold)
    summaries = [
        kinner_top_down_fold(summarizer, merger, default, x)
        for x in children
    ]
    return fold(merger, summaries, default)

def extract_rewrite_parents(term:KInner) -> List[KInner]:
    def maybe_with_rewrite_child(value:KInner) -> Optional[List[KInner]]:
        children = get_children(value)
        if fold(operator.or_, [isinstance(x, KRewrite) for x in children], False):
            return [value]
        return None
    return kinner_top_down_fold(maybe_with_rewrite_child, operator.add, [], term)

def fold(folder:Callable[[V, V], V], to_fold:Iterable[V], initial:V) -> V:
    result = initial
    for item in reversed(list(to_fold)):
        result = folder(item, result)
    return result

def join_tree(label:str, leaves:List[KInner]) -> Optional[KInner]:
    tree:Optional[KInner] = None
    for leaf in leaves:
        if tree is None:
            tree = leaf
        else:
            tree = KApply(label, tree, leaf)
    return tree