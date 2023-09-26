from dataclasses import dataclass
from typing import TYPE_CHECKING, Set

from pyk.kast.inner import KApply, KInner, KSequence, KToken, KVariable
from pyk.prelude.k import K

from .kast import get_inner
from .wasm_cell import get_wasm_cell

if TYPE_CHECKING:
    from pyk.kcfg import KCFG
    from pyk.kcfg.kcfg import NodeIdLike

    from .functions import Functions


class Decision:
    pass


class Continue(Decision):
    pass


class Finish(Decision):
    pass


class Loop(Decision):
    pass


@dataclass(frozen=True)
class UnimplementedElrondFunction(Decision):
    function_id: int
    function_name: str


@dataclass(frozen=True)
class UnsummarizedFunction(Decision):
    function_id: int
    function_name: str


@dataclass(frozen=True)
class ClaimNotAppliedForSummarizedFunction(Decision):
    function_id: int
    function_name: str


class ExecutionManager:
    def __init__(self, functions: Functions, loop_whitelist: Set[str]) -> None:
        self.__already_summarized: Set[int] = set()
        self.__functions = functions
        self.__executing_addr = -1
        self.__loop_whitelist = loop_whitelist

    def decide_configuration(self, kcfg: KCFG, node_id: NodeIdLike) -> Decision:
        node = kcfg.node(node_id)
        instrs = get_instrs_child(node.cterm.config)

        if isinstance(instrs, KVariable):
            assert instrs.name == 'MyOtherInstructions', instrs
            assert instrs.sort == K, instrs
            return Finish()

        assert isinstance(instrs, KSequence)
        if not instrs.items:
            return Finish()
        assert instrs.items, instrs

        first = get_first_instruction(instrs)
        if first.label.name == 'aCall':
            return self.__handle_call(first)
        if first.label.name == '(invoke_)_WASM_Instr_Int':
            return self.__handle_invoke(first)
        if first.label.name == 'trap_WASM_Instr':
            return self.__handle_trap(instrs)
        if first.label.name == 'infiniteLoop':
            return self.__handle_infinite_loop(instrs)
        if first.label.name == 'elrondReverted':
            return Finish()
        if first.label.name == 'aLoop':
            return self.__handle_loop()
        return Continue()

    def start_function(self, function_addr: int) -> None:
        self.__executing_addr = function_addr

    def finish_function(self, function_addr: int) -> None:
        self.__already_summarized.add(function_addr)

    def __handle_loop(self) -> Decision:
        if str(self.__executing_addr) in self.__loop_whitelist:
            return Continue()
        return Loop()

    def __handle_trap(self, instrs: KSequence) -> Decision:
        assert instrs.arity > 1
        second = instrs.items[1]
        if isinstance(second, KApply):
            return Continue()
        assert isinstance(second, KVariable), second
        assert second.name == 'MyOtherInstructions', second
        assert second.sort == K, second
        return Finish()

    def __handle_infinite_loop(self, instrs: KSequence) -> Decision:
        assert instrs.arity > 1
        second = instrs.items[1]
        if isinstance(second, KApply):
            return Continue()
        assert isinstance(second, KVariable), second
        assert second.name == 'MyOtherInstructions', second
        assert second.sort == K, second
        return Finish()

    def __handle_invoke(self, invoke: KApply) -> Decision:
        assert invoke.label.name == '(invoke_)_WASM_Instr_Int'
        assert invoke.arity == 1
        value = invoke.args[0]
        assert isinstance(value, KToken), value
        id = int(value.token)
        if id == self.__executing_addr:
            return Continue()
        assert id in self.__already_summarized
        return ClaimNotAppliedForSummarizedFunction(id, self.__function_name(id))

    def __handle_call(self, call: KApply) -> Decision:
        assert call.label.name == 'aCall'
        assert call.arity == 1
        value = call.args[0]
        assert isinstance(value, KToken), value
        id = int(value.token)
        if id in self.__already_summarized:
            return Continue()
        return UnsummarizedFunction(id, self.__function_name(id))

    def __function_name(self, id: int) -> str:
        return self.__functions.addr_to_function(str(id)).name()

    def __is_elrond_function(self, id: int) -> bool:
        return self.__functions.addr_to_function(str(id)).is_builtin()


def get_instrs_child(term: KInner) -> KInner:
    wasm = get_wasm_cell(term)
    instrs = get_inner(wasm, 0, '<instrs>')
    assert isinstance(instrs, KApply)
    assert instrs.arity == 1, instrs
    return instrs.args[0]


def get_first_instruction(instrs: KSequence) -> KApply:
    assert instrs.items
    first = instrs.items[0]
    assert isinstance(first, KApply), first
    return first
