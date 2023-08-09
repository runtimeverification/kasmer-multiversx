from pathlib import Path
from typing import Any, Optional

from pyk.kast.pretty import SymbolTable
from pyk.kcfg.explore import KCFGExplore
from pyk.kore.rpc import KoreClient, KoreServer
from pyk.ktool.kprint import KPrint
from pyk.ktool.kprove import KProve


class Tools:
    def __init__(self, definition_dir: Path) -> None:
        self.__definition_dir = definition_dir
        self.__kprove: Optional[KProve] = None
        self.__explorer: Optional[KCFGExplore] = None
        self.__kore_server: Optional[KoreServer] = None
        self.__kore_client: Optional[KoreClient] = None

    def __enter__(self) -> 'Tools':
        return self

    def __exit__(self, *_args: Any) -> None:
        self.close()

    def close(self) -> None:
        if self.__kore_client:
            self.__kore_client.close()
        if self.__kore_server:
            self.__kore_server.close()

    @property
    def kprove(self) -> KProve:
        if not self.__kprove:
            self.__kprove = KProve(self.__definition_dir, patch_symbol_table=my_patch_symbol_table)
        return self.__kprove

    @property
    def printer(self) -> KPrint:
        return self.kprove

    @property
    def explorer(self) -> KCFGExplore:
        if not self.__kore_server:
            if self.__kore_client:
                raise RuntimeError('Non-null KoreClient with null KoreServer.')
            self.__kore_server = KoreServer(
                self.__definition_dir,
                self.printer.main_module,
                # port=39425,
            )
        if not self.__kore_client:
            self.__kore_client = KoreClient('localhost', self.__kore_server.port)

        if not self.__explorer:
            self.__explorer = KCFGExplore(self.printer, self.__kore_client)
        return self.__explorer


def my_patch_symbol_table(symbol_table: SymbolTable) -> None:
    symbol_table['_|->_'] = lambda c1, c2: f'({c1} |-> {c2})'
    symbol_table['_Map_'] = lambda c1, c2: f'({c1} {c2})'

    symbol_table['_Int2Bytes|->_'] = lambda c1, c2: f'({c1} Int2Bytes|-> {c2})'
    symbol_table['_MapInt2Bytes_'] = lambda c1, c2: f'({c1} {c2})'

    symbol_table['_Bytes2Bytes|->_'] = lambda c1, c2: f'({c1} Bytes2Bytes|-> {c2})'
    symbol_table['_MapBytes2Bytes_'] = lambda c1, c2: f'({c1} {c2})'

    symbol_table['_Int2Int|->_'] = lambda c1, c2: f'({c1} Int2Int|-> {c2})'
    symbol_table['_MapInt2Int_'] = lambda c1, c2: f'({c1} {c2})'

    symbol_table['_MapIntwToIntw_'] = lambda c1, c2: f'({c1} {c2})'
    symbol_table['MapIntwToIntw:curly_update'] = lambda c1, c2, c3: f'({c1}){{ {c2} <- {c3} }}'

    symbol_table['_MapIntwToBytesw_'] = lambda c1, c2: f'({c1} {c2})'
    symbol_table['MapIntwToBytesw:curly_update'] = lambda c1, c2, c3: f'({c1}){{ {c2} <- {c3} }}'

    symbol_table['_MapByteswToBytesw_'] = lambda c1, c2: f'({c1} {c2})'
    symbol_table['MapByteswToBytesw:curly_update'] = lambda c1, c2, c3: f'({c1}){{ {c2} <- {c3} }}'

    symbol_table['.TabInstCellMap'] = lambda: '.Bag'

    symbol_table['notBool_'] = lambda c1: f'notBool ({c1})'
    symbol_table['_andBool_'] = lambda c1, c2: f'({c1}) andBool ({c2})'
    symbol_table['_orBool_'] = lambda c1, c2: f'({c1}) orBool ({c2})'
    symbol_table['_andThenBool_'] = lambda c1, c2: f'({c1}) andThenBool ({c2})'
    symbol_table['_xorBool_'] = lambda c1, c2: f'({c1}) xorBool ({c2})'
    symbol_table['_orElseBool_'] = lambda c1, c2: f'({c1}) orElseBool ({c2})'
    symbol_table['_impliesBool_'] = lambda c1, c2: f'({c1}) impliesBool ({c2})'

    symbol_table['~Int_'] = lambda c1: f'~Int ({c1})'
    symbol_table['_modInt_'] = lambda c1, c2: f'({c1}) modInt ({c2})'
    symbol_table['modIntTotal'] = lambda c1, c2: f'({c1}) modIntTotal ({c2})'
    symbol_table['_divInt_'] = lambda c1, c2: f'({c1}) divInt ({c2})'
    symbol_table['divIntTotal'] = lambda c1, c2: f'({c1}) divIntTotal ({c2})'
    symbol_table['_*Int_'] = lambda c1, c2: f'({c1}) *Int ({c2})'
    symbol_table['_/Int_'] = lambda c1, c2: f'({c1}) /Int ({c2})'
    symbol_table['_/IntTotal_'] = lambda c1, c2: f'({c1}) /IntTotal ({c2})'
    symbol_table['_%Int_'] = lambda c1, c2: f'({c1}) %Int ({c2})'
    symbol_table['_%IntTotal_'] = lambda c1, c2: f'({c1}) %IntTotal ({c2})'
    symbol_table['_^Int_'] = lambda c1, c2: f'({c1}) ^Int ({c2})'
    symbol_table['_^%Int_'] = lambda c1, c2: f'({c1}) ^%Int ({c2})'
    symbol_table['_+Int_'] = lambda c1, c2: f'({c1}) +Int ({c2})'
    symbol_table['_-Int_'] = lambda c1, c2: f'({c1}) -Int ({c2})'
    symbol_table['_>>Int_'] = lambda c1, c2: f'({c1}) >>Int ({c2})'
    symbol_table['_<<Int_'] = lambda c1, c2: f'({c1}) <<Int ({c2})'
    symbol_table['_&Int_'] = lambda c1, c2: f'({c1}) &Int ({c2})'
    symbol_table['_xorInt_'] = lambda c1, c2: f'({c1}) xorInt ({c2})'
    symbol_table['_|Int_'] = lambda c1, c2: f'({c1}) |Int ({c2})'
