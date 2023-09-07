from typing import Iterable

from pyk.kast.inner import KApply, KInner, KSequence, bottom_up, collect

from .collections import cell_map, full_list, k_map, simple_list
from .generic import set_ksequence_cell_contents

COMMANDS_CELL_NAME = '<commands>'
WASM_CELL_NAME = '<wasm>'


# TODO: Move these to the elrond-semantics repository.
def listBytes(items: Iterable[KInner]) -> KInner:  # noqa: N802
    return full_list(concat_label='_ListBytes_', item_label='ListBytesItem', empty_label='.ListBytes', items=items)


def mapIntToBytes(int_to_bytes: dict[KInner, KInner]) -> KInner:  # noqa: N802
    return k_map(
        concat_label='_MapIntToBytes_', item_label='_Int2Bytes|->_', empty_label='.MapIntToBytes', items=int_to_bytes
    )


def bytesStack(items: Iterable[KInner]) -> KInner:  # noqa: N802
    return simple_list(concat_label='bytesStackList', empty_label='.List{"bytesStackList"}_BytesStack', items=items)


def accountCellMap(accounts: Iterable[KInner]) -> KInner:  # noqa: N802
    return cell_map(name='AccountCellMap', items=accounts)


def find_single_named_node(root: KInner, name: str) -> KApply:
    nodes: list[KApply] = []

    def commands_cell(node: KInner) -> None:
        if not isinstance(node, KApply):
            return
        if node.label.name == name:
            nodes.append(node)

    collect(commands_cell, root)
    assert len(nodes) == 1
    return nodes[0]


def get_commands_cell(root: KInner) -> KApply:
    return find_single_named_node(root, COMMANDS_CELL_NAME)


def commands_cell_contents(root: KInner) -> KSequence:
    commands = get_commands_cell(root)
    assert len(commands.args) == 1
    seq = commands.args[0]
    assert isinstance(seq, KSequence)
    return seq


def command_is_new_wasm_instance(root: KInner) -> bool:
    seq = commands_cell_contents(root)
    if not seq.items:
        return False
    first = seq.items[0]
    if not isinstance(first, KApply):
        return False
    print(first.label.name)
    return first.label.name == 'newWasmInstance'


def set_commands_cell_contents(root: KInner, contents: KSequence) -> KInner:
    return set_ksequence_cell_contents(root, COMMANDS_CELL_NAME, contents)


def set_k_cell_contents(root: KInner, contents: KSequence) -> KInner:
    return set_ksequence_cell_contents(root, '<k>', contents)


def get_wasm_cell(root: KInner) -> KApply:
    return find_single_named_node(root, WASM_CELL_NAME)


def replace_wasm_cell(root: KInner, replacement: KInner) -> KInner:
    def replace_contents(node: KInner) -> KInner:
        if not isinstance(node, KApply):
            return node
        if node.label.name != WASM_CELL_NAME:
            return node
        return replacement

    return bottom_up(replace_contents, root)
