from typing import Iterable

from pyk.kast.inner import KApply, KInner, KSequence, KSort

from .collections import cell_map, simple_list
from .generic import set_ksequence_cell_contents

# TODO: Move these to the wasm-semantics repository
FUNCS_CELL_MAP = KSort('FuncDefCellMap')


def funcDefCellMap(func_defs: Iterable[KInner]) -> KInner:  # noqa: N802
    return cell_map(name='FuncDefCellMap', items=func_defs)


def moduleInstCellMap(module_insts: Iterable[KInner]) -> KInner:  # noqa: N802
    return cell_map(name='ModuleInstCellMap', items=module_insts)


def tabInstCellMap(tab_insts: Iterable[KInner]) -> KInner:  # noqa: N802
    return cell_map(name='TabInstCellMap', items=tab_insts)


def memInstCellMap(mem_insts: Iterable[KInner]) -> KInner:  # noqa: N802
    return cell_map(name='MemInstCellMap', items=mem_insts)


def globalInstCellMap(global_insts: Iterable[KInner]) -> KInner:  # noqa: N802
    return cell_map(name='GlobalInstCellMap', items=global_insts)


def elemInstCellMap(elem_insts: Iterable[KInner]) -> KInner:  # noqa: N802
    return cell_map(name='ElemInstCellMap', items=elem_insts)


def valStack(items: Iterable[KInner]) -> KInner:  # noqa: N802
    return simple_list(concat_label='concatValStack', empty_label='.ValStack', items=items)


def optionalInt_empty() -> KInner:  # noqa: N802
    return KApply('.Int')


def set_instrs_cell_contents(root: KInner, contents: KSequence) -> KInner:
    return set_ksequence_cell_contents(root, '<instrs>', contents)
