from typing import TYPE_CHECKING

from .kast import get_inner_path

if TYPE_CHECKING:
    from pyk.kast.inner import KInner

TOP_CELL = '<elrond-wasm>'


def get_wasm_cell(term: KInner) -> KInner:
    return get_inner_path(term, [(0, TOP_CELL), (1, '<elrond>'), (0, '<node>'), (1, '<callState>'), (2, '<wasm>')])
