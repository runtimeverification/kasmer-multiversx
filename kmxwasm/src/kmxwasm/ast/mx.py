from collections.abc import Callable
from typing import Iterable

from pyk.kast.inner import KApply, KInner, KSequence, KSort, KToken, collect

from .collections import cell_map, full_list, k_map, simple_list
from .generic import (
    find_with_path,
    get_with_path,
    replace_contents_with_path,
    replace_with_path,
    set_ksequence_cell_contents,
    set_single_argument_kapply_contents,
    set_single_argument_multiple_kapply_contents,
)

COMMANDS_CELL_NAME = '<commands>'
INSTRS_CELL_NAME = '<instrs>'
K_CELL_NAME = '<k>'
WASM_CELL_NAME = '<wasm>'
CONTRACT_MOD_IDX_CELL_NAME = '<contractModIdx>'
CALLEE_CELL_NAME = '<callee>'
MAIN_STORE_CELL_NAME = '<mainStore>'
FUNCS_CELL_NAME = '<funcs>'

MANDOS_CELL_PATH = ['<foundry>', '<mandos>']
ELROND_CELL_PATH = MANDOS_CELL_PATH + ['<elrond>']
LOGGING_CELL_PATH = ELROND_CELL_PATH + ['<logging>']
NODE_CELL_PATH = ELROND_CELL_PATH + ['<node>']

CALL_STATE_PATH = NODE_CELL_PATH + ['<callState>']
CALL_STACK_PATH = NODE_CELL_PATH + ['<callStack>']
INTERIM_STATES_PATH = NODE_CELL_PATH + ['<interimStates>']
ACCOUNTS_PATH = NODE_CELL_PATH + ['<accounts>']

CURRENT_BLOCK_INFO_PATH = NODE_CELL_PATH + ['<currentBlockInfo>']
CUR_BLOCK_TIMESTAMP_PATH = CURRENT_BLOCK_INFO_PATH + ['<curBlockTimestamp>']
CUR_BLOCK_NONCE_PATH = CURRENT_BLOCK_INFO_PATH + ['<curBlockNonce>']
CUR_BLOCK_ROUND_PATH = CURRENT_BLOCK_INFO_PATH + ['<curBlockRound>']
CUR_BLOCK_EPOCH_PATH = CURRENT_BLOCK_INFO_PATH + ['<curBlockEpoch>']

VM_OUTPUT_PATH = NODE_CELL_PATH + ['<vmOutput>']

COMMANDS_CELL_PATH = NODE_CELL_PATH + [COMMANDS_CELL_NAME]
K_CELL_PATH = MANDOS_CELL_PATH + [K_CELL_NAME]
CALL_STATE_CELL_PATH = NODE_CELL_PATH + ['<callState>']

CALLEE_CELL_PATH = CALL_STATE_CELL_PATH + [CALLEE_CELL_NAME]
WASM_CELL_PATH = CALL_STATE_PATH + [WASM_CELL_NAME]
INSTRS_CELL_PATH = WASM_CELL_PATH + [INSTRS_CELL_NAME]

CONTRACT_MOD_IDX_CELL_PATH = CALL_STATE_PATH + [CONTRACT_MOD_IDX_CELL_NAME]

FUNCS_PATH = WASM_CELL_PATH + [MAIN_STORE_CELL_NAME, FUNCS_CELL_NAME]

FINISH_EXECUTE_ON_DEST_CONTEXT_LABEL = 'finishExecuteOnDestContext'

CODE = KSort('Code')


# TODO: Move these to the elrond-semantics repository.
def listBytes(items: Iterable[KInner]) -> KInner:  # noqa: N802
    return full_list(concat_label='_ListBytes_', item_label='ListBytesItem', empty_label='.ListBytes', items=items)


def mapIntToBytes(int_to_bytes: dict[KInner, KInner]) -> KInner:  # noqa: N802
    return k_map(
        concat_label='_MapIntToBytes_', item_label='_Int2Bytes|->_', empty_label='.MapIntToBytes', items=int_to_bytes
    )


def mapIntToInt(int_to_int: dict[KInner, KInner]) -> KInner:  # noqa: N802
    return k_map(concat_label='_MapIntToInt_', item_label='_Int2Int|->_', empty_label='.MapIntToInt', items=int_to_int)


def bytesStack(items: Iterable[KInner]) -> KInner:  # noqa: N802
    return simple_list(concat_label='bytesStackList', empty_label='.List{"bytesStackList"}', items=items)


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


def get_first_k_item(root: KInner) -> KInner | None:
    seq = k_cell_contents(root)
    if not seq.items:
        return None
    return seq.items[0]


def get_first_k_name(root: KInner) -> str | None:
    first = get_first_k_item(root)
    if first is None:
        return None
    if not isinstance(first, KApply):
        return None
    return first.label.name


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


def get_first_command(root: KInner) -> KInner | None:
    seq = commands_cell_contents(root)
    if not seq.items:
        return None
    return seq.items[0]


def get_first_command_name(root: KInner) -> str | None:
    command = get_first_command(root)
    if command is None:
        return None
    if not isinstance(command, KApply):
        return None
    return command.label.name


def get_instrs_cell(root: KInner) -> KApply | None:
    result = find_with_path(root, INSTRS_CELL_PATH)
    if not result:
        return None
    assert isinstance(result, KApply)
    return result


def instrs_cell_contents(root: KInner) -> KSequence | None:
    instrs = get_instrs_cell(root)
    if not instrs:
        return None
    assert len(instrs.args) == 1
    seq = instrs.args[0]
    assert isinstance(seq, KSequence), [seq, type(seq)]
    return seq


def replace_instrs_cell(root: KInner, replacement: KSequence) -> KInner:
    return replace_with_path(root, INSTRS_CELL_PATH, replacement=KApply('<instrs>', replacement))


def get_first_instr(root: KInner) -> KApply | None:
    seq = instrs_cell_contents(root)
    if not seq:
        return None
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


def get_callee_cell(root: KInner) -> KApply | None:
    result = find_with_path(root, CALLEE_CELL_PATH)
    if not result:
        return None
    assert isinstance(result, KApply)
    return result


def get_callee(root: KInner) -> str | None:
    instrs = get_callee_cell(root)
    if not instrs:
        return None
    assert len(instrs.args) == 1
    callee = instrs.args[0]
    if not isinstance(callee, KToken):
        return None
    return callee.token


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


def cfg_changes_call_stack(_k: str | None, command: str | None, instr: str | None) -> bool:
    if command in ['pushCallState', 'popCallState', 'dropCallState']:
        return True
    if not instr:
        return False
    return instr == 'endFoundryImmediately'


def cfg_changes_interim_states(_k: str | None, command: str | None, instr: str | None) -> bool:
    if command in ['pushWorldState', 'popWorldState', 'dropWorldState']:
        return True
    if not instr:
        return False
    return instr == 'endFoundryImmediately'


def cfg_touches_code(k: str | None, command: str | None, instr: str | None) -> bool:
    if k in ['checkAccountCodeAux']:
        return True
    if command in [
        'setAccountFields',
        'setAccountCode',
        'callContractWasmString',
        'createAccount',
        'pushWorldState',
        'popWorldState',
        'determineIsSCCallAfter',
    ]:
        return True
    if not instr:
        return False
    return instr == 'checkIsSmartContract'


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


def set_all_code_cell_content(root: KInner, replacements: Callable[[int], KInner]) -> KInner:
    return set_single_argument_multiple_kapply_contents(root, '<code>', replacements)


def get_logging_cell(root: KInner) -> KApply:
    result = get_with_path(root, LOGGING_CELL_PATH)
    assert isinstance(result, KApply)
    return result


def get_logging_cell_content(root: KInner) -> KInner:
    cell = get_logging_cell(root)
    assert cell.arity == 1
    return cell.args[0]


def set_logging_cell_content(root: KInner, replacement: KInner) -> KInner:
    return replace_contents_with_path(root, LOGGING_CELL_PATH, replacement)


def set_cur_block_timestamp_cell_content(root: KInner, replacement: KInner) -> KInner:
    return replace_contents_with_path(root, CUR_BLOCK_TIMESTAMP_PATH, replacement)


def set_cur_block_nonce_cell_content(root: KInner, replacement: KInner) -> KInner:
    return replace_contents_with_path(root, CUR_BLOCK_NONCE_PATH, replacement)


def set_cur_block_round_cell_content(root: KInner, replacement: KInner) -> KInner:
    return replace_contents_with_path(root, CUR_BLOCK_ROUND_PATH, replacement)


def set_cur_block_epoch_cell_content(root: KInner, replacement: KInner) -> KInner:
    return replace_contents_with_path(root, CUR_BLOCK_EPOCH_PATH, replacement)


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


def get_vm_output_cell(root: KInner) -> KApply:
    result = get_with_path(root, VM_OUTPUT_PATH)
    assert isinstance(result, KApply)
    return result


def get_vm_output_cell_content(root: KInner) -> KInner:
    cell = get_vm_output_cell(root)
    assert cell.arity == 1
    return cell.args[0]
