from pyk.cterm import CTerm
from pyk.kast.inner import KApply, KInner, KSequence, KToken
from pyk.kcfg import KCFG
from pyk.prelude.collections import list_of, map_empty
from pyk.prelude.utils import token

from ..ast.mx import (
    accountCellMap,
    commands_cell_contents,
    get_contract_mod_idx_cell,
    get_wasm_cell,
    listBytes,
    mapIntToBytes,
    replace_contract_mod_idx_cell,
    replace_wasm_cell,
    set_accounts_cell_content,
    set_big_int_heap_cell_content,
    set_buffer_heap_cell_content,
    set_call_args_cell_content,
    set_call_stack_cell_content,
    set_commands_cell_contents,
    set_cur_block_epoch_cell_content,
    set_cur_block_nonce_cell_content,
    set_cur_block_round_cell_content,
    set_cur_block_timestamp_cell_content,
    set_exit_code_cell_content,
    set_generated_counter_cell_content,
    set_interim_states_cell_content,
    set_k_cell_contents,
    set_logging_cell_content,
    set_output_accounts_cell_content,
)
from ..ast.wasm import set_instrs_cell_contents
from ..tools import Tools


class WasmKrunInitializer:
    def __init__(self, tools: Tools):
        self.__tools = tools
        self.__first_wasm_cell: KInner | None = None
        self.__cache: dict[str, tuple[KInner, KInner]] = {}  # address -> (<wasm>, <contractModIdx>)

    def initialize(self, kcfg: KCFG, start_node: KCFG.Node, first_node: KCFG.Node) -> None:
        self.__first_wasm_cell = get_wasm_cell(first_node.cterm.config)

        start_cell = start_node.cterm.config
        commands_contents = commands_cell_contents(start_cell)
        assert len(commands_contents) > 0
        first = commands_contents.items[0]

        assert isinstance(first, KApply)
        assert isinstance(first.args[0], KToken)
        acct_address = first.args[0].token

        if acct_address in self.__cache:
            print('*' * 30, 'Reading WASM from cache:', acct_address)
            wasm_cell, current_module = self.__cache[acct_address]
        else:
            krun_cell = self.__prepare_krun_cell(start_cell, first)
            print('*' * 30, 'Initializing WASM:', acct_address)
            krun_result = self.__tools.krun(krun_cell)

            wasm_cell = get_wasm_cell(krun_result)
            current_module = get_contract_mod_idx_cell(krun_result)
            self.__cache[acct_address] = (wasm_cell, current_module)

        final_cell = replace_wasm_cell(start_cell, wasm_cell)
        final_cell = replace_contract_mod_idx_cell(final_cell, current_module)
        final_cell = set_commands_cell_contents(final_cell, KSequence(commands_contents.items[1:]))

        final_cterm = CTerm(final_cell, start_node.cterm.constraints)
        final_node = kcfg.create_node(final_cterm)
        kcfg.create_edge(source_id=start_node.id, target_id=final_node.id, depth=1)

    def __prepare_krun_cell(self, start_cell: KInner, first: KInner) -> KInner:
        krun_cell = set_call_stack_cell_content(start_cell, list_of([]))
        krun_cell = set_k_cell_contents(krun_cell, KSequence([]))
        krun_cell = set_commands_cell_contents(krun_cell, KSequence([first]))
        krun_cell = set_instrs_cell_contents(krun_cell, KSequence([]))
        krun_cell = set_interim_states_cell_content(krun_cell, list_of([]))
        krun_cell = set_accounts_cell_content(krun_cell, accountCellMap([]))
        krun_cell = set_logging_cell_content(krun_cell, token(''))
        krun_cell = set_generated_counter_cell_content(krun_cell, token(0))
        krun_cell = set_call_args_cell_content(krun_cell, listBytes([]))
        krun_cell = set_big_int_heap_cell_content(krun_cell, map_empty())
        krun_cell = set_buffer_heap_cell_content(krun_cell, mapIntToBytes({}))
        krun_cell = set_exit_code_cell_content(krun_cell, token(0))
        krun_cell = set_cur_block_timestamp_cell_content(krun_cell, token(0))
        krun_cell = set_cur_block_nonce_cell_content(krun_cell, token(0))
        krun_cell = set_cur_block_round_cell_content(krun_cell, token(0))
        krun_cell = set_cur_block_epoch_cell_content(krun_cell, token(0))
        krun_cell = set_output_accounts_cell_content(krun_cell, map_empty())

        assert self.__first_wasm_cell
        krun_cell = replace_wasm_cell(krun_cell, self.__first_wasm_cell)

        return krun_cell
