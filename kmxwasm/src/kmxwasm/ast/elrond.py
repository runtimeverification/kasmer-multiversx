from typing import Iterable

from pyk.kast.inner import KApply, KInner, KSequence, collect

from .collections import cell_map, full_list, k_map, simple_list
from .generic import replace_with_path, set_ksequence_cell_contents, set_single_argument_kapply_contents

COMMANDS_CELL_NAME = '<commands>'
WASM_CELL_NAME = '<wasm>'
CONTRACT_MOD_IDX_CELL_NAME = '<contractModIdx>'

CALL_STATE_PATH = ['<foundry>', '<mandos>', '<elrond>', '<node>', '<callState>']
WASM_CELL_PATH = CALL_STATE_PATH + [WASM_CELL_NAME]
CONTRACT_MOD_IDX_CELL_PATH = CALL_STATE_PATH + [CONTRACT_MOD_IDX_CELL_NAME]


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
    return first.label.name == 'newWasmInstance'


def set_commands_cell_contents(root: KInner, contents: KSequence) -> KInner:
    return set_ksequence_cell_contents(root, COMMANDS_CELL_NAME, contents)


def set_k_cell_contents(root: KInner, contents: KSequence) -> KInner:
    return set_ksequence_cell_contents(root, '<k>', contents)


def get_wasm_cell(root: KInner) -> KApply:
    return find_single_named_node(root, WASM_CELL_NAME)


def replace_wasm_cell(root: KInner, replacement: KInner) -> KInner:
    return replace_with_path(root, WASM_CELL_PATH, replacement=replacement)


def get_contract_mod_idx_cell(root: KInner) -> KApply:
    return find_single_named_node(root, CONTRACT_MOD_IDX_CELL_NAME)


def replace_contract_mod_idx_cell(root: KInner, replacement: KInner) -> KInner:
    return replace_with_path(root, CONTRACT_MOD_IDX_CELL_PATH, replacement=replacement)


def set_call_stack_cell_content(root: KInner, replacement: KInner) -> KInner:
    return set_single_argument_kapply_contents(root, '<callStack>', replacement)


def set_interim_states_cell_content(root: KInner, replacement: KInner) -> KInner:
    return set_single_argument_kapply_contents(root, '<interimStates>', replacement)


def set_accounts_cell_content(root: KInner, replacement: KInner) -> KInner:
    return set_single_argument_kapply_contents(root, '<accounts>', replacement)


def set_logging_cell_content(root: KInner, replacement: KInner) -> KInner:
    return set_single_argument_kapply_contents(root, '<logging>', replacement)


def set_generated_counter_cell_content(root: KInner, replacement: KInner) -> KInner:
    return set_single_argument_kapply_contents(root, '<generatedCounter>', replacement)


def set_call_args_cell_content(root: KInner, replacement: KInner) -> KInner:
    return set_single_argument_kapply_contents(root, '<callArgs>', replacement)


def set_big_int_heap_cell_content(root: KInner, replacement: KInner) -> KInner:
    return set_single_argument_kapply_contents(root, '<bigIntHeap>', replacement)


def set_buffer_heap_cell_content(root: KInner, replacement: KInner) -> KInner:
    return set_single_argument_kapply_contents(root, '<bufferHeap>', replacement)


def set_exit_code_cell_content(root: KInner, replacement: KInner) -> KInner:
    return set_single_argument_kapply_contents(root, '<exit-code>', replacement)
