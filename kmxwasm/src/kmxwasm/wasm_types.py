from typing import List

class ValType:

    def __init__(self, ktype:int) -> None:
        self.__type = ktype

    def __str__(self) -> str:
        return repr(self)
    
    def __repr__(self) -> str:
        if self == I32:
            return 'wasm_types.I32'
        if self == I64:
            return 'wasm_types.I64'
        if self == F32:
            return 'wasm_types.F32'
        if self == F64:
            return 'wasm_types.F64'
        raise AssertionError(self)

(I32, I64, F32, F64) = (ValType(i) for i in range(0, 4))

class VecType:
    def __init__(self, types:List[ValType]) -> None:
        self.__types = types

    def types(self) -> List[ValType]:
        return self.__types

    def __str__(self) -> str:
        return repr(self)
    
    def __repr__(self) -> str:
        return f'VecType(types={repr(self.__types)})'

class FuncType:
    def __init__(self, arg_types: VecType, result_types: VecType) -> None:
        self.__arg_types = arg_types
        self.__result_types = result_types

    def argument_types_list(self) -> List[ValType]:
        return self.__arg_types.types()

    def __str__(self) -> str:
        return repr(self)
    
    def __repr__(self) -> str:
        return f'FuncType(arg_types={repr(self.__arg_types)}, result_types={repr(self.__result_types)})'
