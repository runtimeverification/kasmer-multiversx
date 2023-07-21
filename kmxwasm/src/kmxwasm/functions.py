import operator
from typing import Dict, Iterable, List, Optional

from pyk.kast.inner import KApply, KInner, KToken, bottom_up
from pyk.prelude.kint import INT

from . import wasm_types
from .kast import (
    filter_map,
    find_term_get_child,
    get_inner,
    get_inner_path,
    join_tree,
    kinner_top_down_fold,
    load_map_from_child,
    load_token,
    load_token_from_child,
)
from .wasm_cell import get_wasm_cell
from .wasm_types import FuncType, ValType, VecType


class WasmFunction:
    def __init__(self, name: str, ftype: FuncType, is_builtin: bool, has_instructions: bool, address: str) -> None:
        self.__name = name
        self.__type = ftype
        self.__is_builtin = is_builtin
        self.__has_instructions = has_instructions
        self.__address = address

    def argument_types_list(self) -> List[ValType]:
        return self.__type.argument_types_list()

    def address(self) -> str:
        return self.__address

    def name(self) -> str:
        return self.__name

    def is_builtin(self) -> bool:
        return self.__is_builtin

    def __str__(self) -> str:
        return repr(self)

    def __repr__(self) -> str:
        return f'WasmFunction(name={repr(self.__name)}, ftype={repr(self.__type)}, is_builtin={repr(self.__is_builtin)}, has_instructions={self.__has_instructions}, address={repr(self.__address)})'


class Functions:
    def __init__(
        self,
        name_to_id: dict[str, str],
        id_to_addr: dict[str, str],
        id_to_type: dict[str, FuncType],
        addr_to_def: dict[str, WasmFunction],
    ):
        self.__name_to_id = name_to_id
        self.__id_to_addr = id_to_addr
        self.__id_to_type = id_to_type
        self.__addr_to_def = addr_to_def

    def addr_to_function(self, addr: str) -> WasmFunction:
        assert addr in self.__addr_to_def, [addr, self.__addr_to_def.keys()]
        return self.__addr_to_def[addr]

    def addrs(self) -> Iterable[str]:
        return self.__addr_to_def.keys()

    def __str__(self) -> str:
        return repr(self)

    def __repr__(self) -> str:
        return f'Functions(name_to_id={repr(self.__name_to_id)}, id_to_addr={repr(self.__id_to_addr)}, id_to_type={repr(self.__id_to_type)}, addr_to_def={repr(self.__addr_to_def)})'


def get_first_instruction(term: KInner) -> Optional[KInner]:
    assert isinstance(term, KApply), term
    assert term.label.name == '<fCode>', term
    assert term.arity == 1
    term = term.args[0]
    while True:
        if not isinstance(term, KApply):
            return term
        if term.label.name == '.List{"listStmt"}_EmptyStmts':
            return None
        if not term.label.name == '___WASM-COMMON-SYNTAX_Instrs_Instr_Instrs':
            return term
        term = term.args[0]


def is_elrond_trap(term: KInner) -> bool:
    if not isinstance(term, KApply):
        return False
    return term.label.name == 'elrond_trap'


def load_val_type(term: KInner) -> ValType:
    assert isinstance(term, KApply), term
    if term.label.name == 'i32':
        assert term.arity == 0, term
        return wasm_types.I32
    if term.label.name == 'i64':
        assert term.arity == 0, term
        return wasm_types.I64
    if term.label.name == 'f32':
        assert term.arity == 0, term
        return wasm_types.F32
    if term.label.name == 'f64':
        assert term.arity == 0, term
        return wasm_types.F64
    raise AssertionError(term)


def load_vec_type(term: KInner) -> VecType:
    assert isinstance(term, KApply), term
    assert term.label.name == 'aVecType', term
    assert term.arity == 1, term
    term = term.args[0]

    types: List[ValType] = []
    while True:
        assert isinstance(term, KApply), term
        if term.label.name == '.List{"listValTypes"}_ValTypes':
            assert term.arity == 0, term
            return VecType(types)
        if term.label.name == 'listValTypes':
            assert term.arity == 2, term
            types.append(load_val_type(term.args[0]))
            term = term.args[1]
        else:
            raise AssertionError(term)


def load_function_type(term: KInner) -> FuncType:
    assert isinstance(term, KApply)
    assert term.label.name == 'aFuncType', term
    assert term.arity == 2, term
    arg_types = load_vec_type(term.args[0])
    result_types = load_vec_type(term.args[1])
    return FuncType(arg_types, result_types)


def load_function_type_from_child(term: KInner) -> FuncType:
    assert isinstance(term, KApply), term
    assert term.arity == 1
    return load_function_type(term.args[0])


def load_function(kfunc_def: KApply, loaded: Dict[str, WasmFunction]) -> None:
    assert kfunc_def.label.name == '<funcDef>', kfunc_def

    kfaddr = get_inner(kfunc_def, 0, '<fAddr>')
    assert kfaddr is not None
    addr = load_token_from_child(kfaddr)

    kfcode = get_inner(kfunc_def, 1, '<fCode>')
    k_first_instruction = get_first_instruction(kfcode)
    if k_first_instruction is not None:
        is_elrond_trap_ = is_elrond_trap(k_first_instruction)
        has_instructions = True
    else:
        is_elrond_trap_ = False
        has_instructions = False

    kftype = get_inner(kfunc_def, 2, '<fType>')
    function_type = load_function_type_from_child(kftype)

    kfunc_id = get_inner_path(kfunc_def, [(5, '<funcMetadata>'), (0, '<funcId>')])
    function_name = load_token_from_child(kfunc_id)

    f = WasmFunction(
        name=function_name,
        ftype=function_type,
        is_builtin=is_elrond_trap_,
        has_instructions=has_instructions,
        address=addr,
    )
    loaded[addr] = f


def function_map_to_list(term: KInner, functions: List[KInner]) -> None:
    assert isinstance(term, KApply)
    if term.label.name == '_FuncDefCellMap_':
        assert term.arity == 2, term
        function_map_to_list(term.args[0], functions)
        function_map_to_list(term.args[1], functions)
    elif term.label.name == 'FuncDefCellMapItem':
        assert term.arity == 2, term
        func = term.args[1]
        assert isinstance(func, KApply), func
        assert func.label.name == '<funcDef>', func
        functions.append(func)
    else:
        raise AssertionError([term, term.label.name])


def load_functions_from_store(term: KInner) -> Dict[str, WasmFunction]:
    assert isinstance(term, KApply), term
    assert term.label.name == '<funcs>', term
    assert term.arity == 1
    funcs: List[KInner] = []
    function_map_to_list(term.args[0], funcs)
    func_addr_to_def: Dict[str, WasmFunction] = {}
    for kfunc_def in funcs:
        assert isinstance(kfunc_def, KApply), kfunc_def
        assert kfunc_def.label.name == '<funcDef>', kfunc_def

        load_function(kfunc_def, func_addr_to_def)
    return func_addr_to_def


def find_functions(term: KInner) -> Functions:
    kwasm = get_wasm_cell(term)
    kmodule_instances = get_inner(kwasm, 5, '<moduleInstances>')
    assert isinstance(kmodule_instances, KApply), kmodule_instances
    assert len(kmodule_instances.args) == 1, kmodule_instances
    # Skip the first module as it seems to contain only builtins, which also
    # exist in the second module.
    kmodule_instance = get_inner_path(
        kmodule_instances, [(0, '_ModuleInstCellMap_'), (1, 'ModuleInstCellMapItem'), (1, '<moduleInst>')]
    )
    ktypes = get_inner(kmodule_instance, 2, '<types>')
    kfunc_addrs = get_inner(kmodule_instance, 4, '<funcAddrs>')
    kfunc_ids = get_inner_path(kmodule_instance, [(13, '<moduleMetadata>'), (2, '<funcIds>')])
    kfuncs = get_inner_path(kwasm, [(7, '<mainStore>'), (0, '<funcs>')])

    func_name_to_id = load_map_from_child(kfunc_ids, load_token)
    func_id_to_addr = load_map_from_child(kfunc_addrs, load_token)
    func_id_to_type = load_map_from_child(ktypes, load_function_type)  # TODO: Probably not needed.
    func_addr_to_def = load_functions_from_store(kfuncs)
    return Functions(
        name_to_id=func_name_to_id, id_to_addr=func_id_to_addr, id_to_type=func_id_to_type, addr_to_def=func_addr_to_def
    )


def remove_all_functions_but_one_and_builtins(term: KInner, function_addr: str, functions: Functions) -> KInner:
    def find_func_items(term_: KApply) -> List[KInner]:
        def func_selector(item: KInner) -> Optional[List[KInner]]:
            if not isinstance(item, KApply):
                return None
            if item.label.name != 'FuncDefCellMapItem':
                return None
            addr = find_term_get_child(item, '<fAddr>')
            assert isinstance(addr, KToken), addr
            if addr.token == function_addr:
                return [item]
            if functions.addr_to_function(addr.token).is_builtin():
                return [item]
            return []

        return kinner_top_down_fold(func_selector, operator.add, [], term_)

    def rewrite_funcs(term: KApply) -> KApply:
        assert term.label.name == '<funcs>'
        assert term.arity == 1
        child = term.args[0]
        assert isinstance(child, KApply)
        my_funcs = find_func_items(child)
        tree = join_tree('_FuncDefCellMap_', my_funcs)
        assert tree is not None
        return term.let(args=(tree,))
        # KApply(
        #     '_FuncDefCellMap_',
        #     myfunc,
        #     KVariable('MyFuncDefCellMap', sort=KSort('FuncDefCellMap'))
        # )

    def replace_funcs(term: KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if not term.label.name == '<funcs>':
            return term
        return rewrite_funcs(term)

    return bottom_up(replace_funcs, term)


def remove_all_function_id_to_addrs_but_one_and_builtins(
    term: KInner, function_addr: str, functions: Functions
) -> KInner:
    def keep_mapping(item: KApply) -> bool:
        assert item.label.name == '_|->_', item
        assert item.arity == 2
        key, value = item.args
        assert isinstance(value, KToken)
        assert value.sort == INT
        addr = value.token
        if addr == function_addr:
            return True
        if functions.addr_to_function(addr).is_builtin():
            return True
        return False

    def replace_funcs(term: KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if not term.label.name == '<funcAddrs>':
            return term
        assert term.arity == 1, term
        mapping = term.args[0]
        return term.let(args=[filter_map(mapping, keep_mapping)])

    return bottom_up(replace_funcs, term)
