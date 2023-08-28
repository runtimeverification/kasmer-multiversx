from typing import Iterable

from pyk.kast.inner import KApply, KInner, KLabel

# TODO: Move these to the pyk repository.


def simple_list(concat_label: str | KLabel, empty_label: str | KLabel, items: Iterable[KInner]) -> KInner:
    tail = KApply(empty_label)
    for item in reversed(list(items)):
        tail = KApply(concat_label, [item, tail])
    return tail


def full_list(
    concat_label: str | KLabel, item_label: str | KLabel, empty_label: str | KLabel, items: Iterable[KInner]
) -> KInner:
    items_ast = [KApply(item_label, item) for item in items]
    return simple_list(concat_label=concat_label, empty_label=empty_label, items=items_ast)


def k_map(
    concat_label: str | KLabel, item_label: str | KLabel, empty_label: str | KLabel, items: dict[KInner, KInner]
) -> KInner:
    if not items:
        return KApply(empty_label)
    items_ast = [KApply(item_label, key, value) for key, value in items.items()]
    result = items_ast.pop()
    for item in reversed(items):
        result = KApply(concat_label, [item, result])
    return result


def cell_map(name: str, items: Iterable[KInner]) -> KInner:
    items_dict: dict[KInner, KInner] = {}
    for item in items:
        if not isinstance(item, KApply):
            raise ValueError(f'Expected a list of KApply, one item is of type {type(item)}.')
        if item.arity < 2:
            raise ValueError(
                f'Expected a list of KApply with at least two arguments each, one has {item.arity} arguments.'
            )
        items_dict[item.args[0]] = item
    return k_map(concat_label=f'_{name}_', item_label=f'{name}Item', empty_label=f'.{name}', items=items_dict)
