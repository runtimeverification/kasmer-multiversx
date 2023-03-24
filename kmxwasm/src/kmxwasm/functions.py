import operator
from typing import Dict, Iterable, List, Optional

from pyk.kast.inner import (
    KApply,
    KInner,
    KToken,
    bottom_up)
from pyk.prelude.kint import INT

from .kast import (filterMap,
                   findTermGetChild,
                   getInner,
                   getInnerPath,
                   joinTree,
                   kinner_top_down_fold,
                   loadMapFromChild,
                   loadToken,
                   loadTokenFromChild,
                   )
from .wasm_types import (FuncType, ValType, VecType)

class WasmFunction:
    def __init__(self, name:str, ftype:FuncType, is_builtin:bool, has_instructions:bool, address:str) -> None:
        self.__name = name
        self.__type = ftype
        self.__is_builtin = is_builtin
        self.__has_instructions = has_instructions
        self.__address = address

    def argumentTypesList(self) -> List[ValType]:
        return self.__type.argumentTypesList()
    
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
    def __init__(self,
                 name_to_id:dict[str, str],
                 id_to_addr:dict[str, str],
                 id_to_type:dict[str, FuncType],
                 addr_to_def:dict[str, WasmFunction]):
        self.__name_to_id = name_to_id
        self.__id_to_addr = id_to_addr
        self.__id_to_type = id_to_type
        self.__addr_to_def = addr_to_def

    def addrToFunction(self, addr:str) -> WasmFunction:
        return self.__addr_to_def[addr]

    def addrs(self) -> Iterable[str]:
        return self.__addr_to_def.keys()

    def __str__(self) -> str:
        return repr(self)
    
    def __repr__(self) -> str:
        return f'Functions(name_to_id={repr(self.__name_to_id)}, id_to_addr={repr(self.__id_to_addr)}, id_to_type={repr(self.__id_to_type)}, addr_to_def={repr(self.__addr_to_def)})'


def getFirstInstruction(term:KInner) -> Optional[KInner]:
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

def isElrondTrap(term:KInner) -> bool:
    if not isinstance(term, KApply):
        return False
    return term.label.name == 'elrond_trap'


def loadValType(term:KInner) -> ValType:
    assert isinstance(term, KApply), term
    if term.label.name == 'i32':
        assert term.arity == 0, term
        return ValType.I32
    if term.label.name == 'i64':
        assert term.arity == 0, term
        return ValType.I64
    if term.label.name == 'f32':
        assert term.arity == 0, term
        return ValType.F32
    if term.label.name == 'f64':
        assert term.arity == 0, term
        return ValType.F64
    assert False, term

def loadVecType(term:KInner) -> VecType:
    assert isinstance(term, KApply), term
    assert term.label.name == 'aVecType', term
    assert term.arity == 1, term
    term = term.args[0]

    types:List[ValType] = []
    while True:
        assert isinstance(term, KApply), term
        if term.label.name == '.List{"listValTypes"}_ValTypes':
            assert term.arity == 0, term
            return VecType(types)
        if term.label.name == 'listValTypes':
            assert term.arity == 2, term
            types.append(loadValType(term.args[0]))
            term = term.args[1]
        else:
            assert False, term

def loadFunctionType(term:KInner) -> FuncType:
    assert isinstance(term, KApply)
    assert term.label.name == 'aFuncType', term
    assert term.arity == 2, term
    arg_types = loadVecType(term.args[0])
    result_types = loadVecType(term.args[1])
    return FuncType(arg_types, result_types)


def loadFunctionTypeFromChild(term:KInner) -> FuncType:
    assert isinstance(term, KApply), term
    assert term.arity == 1
    return loadFunctionType(term.args[0])

def loadFunction(kfunc_def:KApply, loaded: Dict[str, WasmFunction]) -> None:
    assert kfunc_def.label.name == '<funcDef>', kfunc_def

    kfaddr = getInner(kfunc_def, 0, '<fAddr>')
    assert kfaddr is not None
    addr = loadTokenFromChild(kfaddr)

    kfcode = getInner(kfunc_def, 1, '<fCode>')
    kFirstInstruction = getFirstInstruction(kfcode)
    if kFirstInstruction is not None:
        is_elrond_trap = isElrondTrap(kFirstInstruction)
        has_instructions = True
    else:
        is_elrond_trap = False
        has_instructions = False

    kftype = getInner(kfunc_def, 2, '<fType>')
    function_type = loadFunctionTypeFromChild(kftype)

    kfunc_id = getInnerPath(kfunc_def, [(5, '<funcMetadata>'), (0, '<funcId>')])
    function_name = loadTokenFromChild(kfunc_id)

    f = WasmFunction(
        name = function_name,
        ftype = function_type,
        is_builtin = is_elrond_trap,
        has_instructions=has_instructions,
        address = addr
    )
    loaded[addr] = f

def functionMapToList(term:KInner, functions:List[KInner]) -> None:
    assert isinstance(term, KApply)
    if term.label.name == '_FuncDefCellMap_':
        assert term.arity == 2, term
        functionMapToList(term.args[0], functions)
        functionMapToList(term.args[1], functions)
    elif term.label.name == 'FuncDefCellMapItem':
        assert term.arity == 2, term
        func = term.args[1]
        assert isinstance(func, KApply), func
        assert func.label.name == '<funcDef>', func
        functions.append(func)
    else:
        assert False, [term, term.label.name]

def loadFunctionsFromStore(term:KInner) -> Dict[str, WasmFunction]:
    assert isinstance(term, KApply), term
    assert term.label.name == '<funcs>', term
    assert term.arity == 1
    funcs:List[KInner] = []
    functionMapToList(term.args[0], funcs)
    func_addr_to_def:Dict[str, WasmFunction] = {}
    for kfunc_def in funcs:
        assert isinstance(kfunc_def, KApply), kfunc_def
        assert kfunc_def.label.name == '<funcDef>', kfunc_def

        loadFunction(kfunc_def, func_addr_to_def)
    return func_addr_to_def


def findFunctions(term:KInner) -> Functions:
    kwasm = getInnerPath(term, [(0, '<elrond-wasm>'), (1, '<wasm>')])
    kmodule_instances = getInner(kwasm, 5, '<moduleInstances>')
    assert isinstance(kmodule_instances, KApply), kmodule_instances
    assert len(kmodule_instances.args) == 1, kmodule_instances
    kmodule_instance = getInnerPath(kmodule_instances, [(0, 'ModuleInstCellMapItem'), (1, '<moduleInst>')])
    ktypes = getInner(kmodule_instance, 2, '<types>')
    kfunc_addrs = getInner(kmodule_instance, 4, '<funcAddrs>')
    kfunc_ids = getInnerPath(kmodule_instance, [(13, '<moduleMetadata>'), (2, '<funcIds>')])
    kfuncs = getInnerPath(kwasm, [(7, '<mainStore>'), (0, '<funcs>')])

    func_name_to_id = loadMapFromChild(kfunc_ids, loadToken)
    func_id_to_addr = loadMapFromChild(kfunc_addrs, loadToken)
    func_id_to_type = loadMapFromChild(ktypes, loadFunctionType)  # TODO: Probably not needed.
    func_addr_to_def = loadFunctionsFromStore(kfuncs)
    return Functions(
        name_to_id=func_name_to_id,
        id_to_addr=func_id_to_addr,
        id_to_type=func_id_to_type,
        addr_to_def=func_addr_to_def
    )

def removeAllFunctionsButOneAndBuiltins(term:KInner, function_addr:str, functions:Functions) -> KInner:
    def findFuncItems(term_:KApply) -> List[KInner]:
        def funcSelector(item:KInner) -> Optional[List[KInner]]:
            if not isinstance(item, KApply):
                return None
            if item.label.name != 'FuncDefCellMapItem':
                return None
            addr = findTermGetChild(item, '<fAddr>')
            assert isinstance(addr, KToken), addr
            if addr.token == function_addr:
                return [item]
            if functions.addrToFunction(addr.token).is_builtin():
                return [item]
            return []
        return kinner_top_down_fold(funcSelector, operator.add, [], term_)
    def rewriteFuncs(term:KApply) -> KApply:
        assert term.label.name == '<funcs>'
        assert term.arity == 1
        child = term.args[0]
        assert isinstance(child, KApply)
        my_funcs = findFuncItems(child)
        return term.let(args=(joinTree('_FuncDefCellMap_', my_funcs),))
        # KApply(
        #     '_FuncDefCellMap_',
        #     myfunc,
        #     KVariable('MyFuncDefCellMap', sort=KSort('FuncDefCellMap'))
        # )
    def replaceFuncs(term:KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if not term.label.name == '<funcs>':
            return term
        return rewriteFuncs(term)
    return bottom_up(replaceFuncs, term)

def removeAllFunctionIdToAddrsButOneAndBuiltins(term:KInner, function_addr:str, functions:Functions) -> KInner:
    def keepMapping(item:KApply) -> bool:
        assert item.label.name == '_|->_', item
        assert item.arity == 2
        key, value = item.args
        assert isinstance(value, KToken)
        assert value.sort == INT
        addr = value.token
        if addr == function_addr:
            return True
        if functions.addrToFunction(addr).is_builtin():
            return True
        return False
    def replaceFuncs(term:KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if not term.label.name == '<funcAddrs>':
            return term
        assert term.arity == 1, term
        mapping = term.args[0]
        return term.let(args=[filterMap(mapping, keepMapping)])
    return bottom_up(replaceFuncs, term)
