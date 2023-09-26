import json
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import Any, Optional

from pyk.utils import BugReport
from pyk.kast.inner import KInner
from pyk.kast.kast import kast_term
from pyk.kast.pretty import SymbolTable
from pyk.kcfg.explore import KCFGExplore
from pyk.kore.rpc import BoosterServer, KoreClient, KoreServer
from pyk.ktool.kprint import KPrint
from pyk.ktool.kprove import KProve
from pyk.ktool.krun import KRunOutput, _krun
from pyk.prelude.k import GENERATED_TOP_CELL


USE_BUG_REPORT = False


class Tools:
    def __init__(
        self, definition_dir: Path, llvm_definition_dir: Path | None, llvm_library_definition_dir: Path, booster: bool
    ) -> None:
        self.__definition_dir = definition_dir
        self.__llvm_definition_dir = llvm_definition_dir
        self.__llvm_library_definition_dir = llvm_library_definition_dir
        self.__booster = booster
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
        bug_report = None
        if (USE_BUG_REPORT):
            bug_report = BugReport(Path('bug-report'))
        if not self.__kore_server:
            if self.__kore_client:
                raise RuntimeError('Non-null KoreClient with null KoreServer.')
            if self.__booster:
                self.__kore_server = BoosterServer(
                    self.__definition_dir,
                    self.__llvm_library_definition_dir,
                    self.printer.main_module,
                    command=('kore-rpc-booster'),
                    # command=('kore-rpc-booster', '-l', 'Rewrite'),
                    bug_report=bug_report
                    # port=39425,
                )
            else:
                self.__kore_server = KoreServer(
                    self.__definition_dir,
                    self.printer.main_module,
                    # port=39425,
                )
        if not self.__kore_client:
            self.__kore_client = KoreClient(
                'localhost',
                self.__kore_server.port,
                bug_report=bug_report
            )

        if not self.__explorer:
            self.__explorer = KCFGExplore(self.printer, self.__kore_client)
        return self.__explorer

    def krun(self, cfg: KInner) -> KInner:
        with NamedTemporaryFile('w') as ntf:
            pattern = self.printer.kast_to_kore(cfg, sort=GENERATED_TOP_CELL)
            ntf.write(pattern.text)
            ntf.flush()
            if self.__llvm_definition_dir:
                krun_dir = self.__llvm_definition_dir
            else:
                krun_dir = self.__definition_dir
            result = _krun(
                input_file=Path(ntf.name),
                definition_dir=krun_dir,
                output=KRunOutput.JSON,
                term=True,
                parser='cat',
            )
            value = json.loads(result.stdout)
            return kast_term(value, KInner)  # type: ignore # https://github.com/python/mypy/issues/4717


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
