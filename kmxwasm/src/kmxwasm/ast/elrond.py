from typing import Iterable

from pyk.kast.inner import KInner

from .collections import cell_map, full_list, k_map, simple_list


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
