from pyk.cterm import CTerm
from pyk.kast.inner import KInner, KSequence
from pyk.kcfg import KCFG
from pyk.prelude.collections import list_of, map_empty
from pyk.prelude.utils import token

from .ast.elrond import (
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
    set_generated_counter_cell_content,
    set_interim_states_cell_content,
    set_k_cell_contents,
    set_logging_cell_content,
)
from .ast.wasm import set_instrs_cell_contents
from .tools import Tools


class WasmKrunInitializer:
    def __init__(self, tools: Tools):
        self.__tools = tools
        self.__first_wasm_cell: KInner | None = None

    def initialize(self, kcfg: KCFG, start_node: KCFG.Node) -> None:
        start_cell = start_node.cterm.config
        commands_contents = commands_cell_contents(start_cell)
        assert len(commands_contents) > 0
        first = commands_contents.items[0]

        krun_cell = set_call_stack_cell_content(start_cell, list_of([]))
        if not self.__first_wasm_cell:
            # This must run after set_call_stack_cell_content because the call
            # stack also contains <wasm> entries, which makes get_wasm_cell crash.
            self.__first_wasm_cell = get_wasm_cell(krun_cell)
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
        krun_cell = replace_wasm_cell(krun_cell, self.__first_wasm_cell)

        # TODO: Figure out if it's possible to cache the initialization result.
        print('*' * 30, 'Initializing WASM.')
        krun_result = self.__tools.krun(krun_cell)

        wasm_cell = get_wasm_cell(krun_result)
        final_cell = replace_wasm_cell(start_cell, wasm_cell)
        current_module = get_contract_mod_idx_cell(krun_result)
        final_cell = replace_contract_mod_idx_cell(final_cell, current_module)
        final_cell = set_commands_cell_contents(final_cell, KSequence(commands_contents.items[1:]))

        final_cterm = CTerm(final_cell, start_node.cterm.constraints)
        final_node = kcfg.create_node(final_cterm)
        kcfg.create_edge(source_id=start_node.id, target_id=final_node.id, depth=1)
