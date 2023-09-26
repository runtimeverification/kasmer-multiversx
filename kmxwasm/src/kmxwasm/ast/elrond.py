from typing import Iterable

from pyk.kast.inner import KApply, KInner, KSequence, KToken, collect

from .collections import cell_map, full_list, k_map, simple_list
from .generic import get_with_path, replace_with_path, set_ksequence_cell_contents, set_single_argument_kapply_contents

COMMANDS_CELL_NAME = '<commands>'
INSTRS_CELL_NAME = '<instrs>'
K_CELL_NAME = '<k>'
WASM_CELL_NAME = '<wasm>'
CONTRACT_MOD_IDX_CELL_NAME = '<contractModIdx>'

MANDOS_CELL_PATH = ['<foundry>', '<mandos>']
NODE_CELL_PATH = MANDOS_CELL_PATH + ['<elrond>', '<node>']
CALL_STATE_PATH = NODE_CELL_PATH + ['<callState>']
CALL_STACK_PATH = NODE_CELL_PATH + ['<callStack>']

COMMANDS_CELL_PATH = NODE_CELL_PATH + [COMMANDS_CELL_NAME]
K_CELL_PATH = MANDOS_CELL_PATH + [K_CELL_NAME]
WASM_CELL_PATH = CALL_STATE_PATH + [WASM_CELL_NAME]
INSTRS_CELL_PATH = WASM_CELL_PATH + [INSTRS_CELL_NAME]
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


def get_k_cell(root: KInner) -> KApply:
    result = get_with_path(root, K_CELL_PATH)
    assert isinstance(result, KApply)
    return result


def k_cell_contents(root: KInner) -> KSequence:
    commands = get_k_cell(root)
    assert len(commands.args) == 1
    seq = commands.args[0]
    assert isinstance(seq, KSequence)
    return seq


def get_commands_cell(root: KInner) -> KApply:
    result = get_with_path(root, COMMANDS_CELL_PATH)
    assert isinstance(result, KApply)
    return result


def commands_cell_contents(root: KInner) -> KSequence:
    commands = get_commands_cell(root)
    assert len(commands.args) == 1
    seq = commands.args[0]
    assert isinstance(seq, KSequence)
    return seq


def get_first_command_name(root: KInner) -> str | None:
    seq = commands_cell_contents(root)
    if not seq.items:
        return None
    first = seq.items[0]
    if not isinstance(first, KApply):
        return None
    return first.label.name


def get_instrs_cell(root: KInner) -> KApply:
    result = get_with_path(root, INSTRS_CELL_PATH)
    assert isinstance(result, KApply)
    return result


def instrs_cell_contents(root: KInner) -> KSequence:
    instrs = get_instrs_cell(root)
    assert len(instrs.args) == 1
    seq = instrs.args[0]
    assert isinstance(seq, KSequence)
    return seq


def get_first_instr(root: KInner) -> KApply | None:
    seq = instrs_cell_contents(root)
    if not seq.items:
        return None
    first = seq.items[0]
    if not isinstance(first, KApply):
        return None
    return first


def get_first_instr_name(root: KInner) -> str | None:
    first = get_first_instr(root)
    if first is None:
        return None
    return first.label.name


def get_hostcall_name(hostcall: KApply) -> str | None:
    if hostcall.label.name != 'hostCall':
        return None
    assert hostcall.arity > 1
    arg = hostcall.args[1]
    if not isinstance(arg, KToken):
        return None
    return arg.token


def command_is_new_wasm_instance(root: KInner) -> bool:
    command = get_first_command_name(root)
    if not command:
        return False
    return command == 'newWasmInstance'


def cfg_changes_call_stack(root: KInner) -> bool:
    command = get_first_command_name(root)
    if command in ['pushCallState', 'popCallState', 'dropCallState']:
        return True
    instr = get_first_instr_name(root)
    if not instr:
        return False
    return instr == 'endFoundryImmediately'


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
