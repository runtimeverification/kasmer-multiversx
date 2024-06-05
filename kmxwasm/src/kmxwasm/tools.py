import json
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import Any, Optional

from pyk.cterm import CTermSymbolic
from pyk.kast.inner import KInner
from pyk.kast.kast import kast_term
from pyk.kast.pretty import SymbolTable
from pyk.kcfg.explore import KCFGExplore
from pyk.kore.rpc import KoreClient, KoreServer, kore_server
from pyk.ktool.kprint import KPrint
from pyk.ktool.kprove import KProve
from pyk.ktool.krun import KRunOutput, _krun
from pyk.prelude.k import GENERATED_TOP_CELL
from pyk.utils import BugReport

from .nodeprinter import KasmerNodePrinter

# USE_BUG_REPORT = False


class Tools:
    def __init__(
        self,
        definition_dir: Path,
        llvm_definition_dir: Path | None,
        llvm_library_definition_dir: Path | None,
        bug_report: BugReport | None,
        booster: bool,
    ) -> None:
        self.__definition_dir = definition_dir
        self.__llvm_definition_dir = llvm_definition_dir
        self.__llvm_library_definition_dir = llvm_library_definition_dir
        self.__bug_report = bug_report
        self.__booster = booster
        self.__kprove: Optional[KProve] = None
        self.__explorer: Optional[KCFGExplore] = None
        self.__kore_server: Optional[KoreServer] = None
        self.__kore_client: Optional[KoreClient] = None
        assert self.__llvm_library_definition_dir or not self.__booster

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
    def node_printer(self) -> KasmerNodePrinter:
        return KasmerNodePrinter(self.printer)

    @property
    def explorer(self) -> KCFGExplore:
        if not self.__kore_server:
            if self.__kore_client:
                raise RuntimeError('Non-null KoreClient with null KoreServer.')
            if self.__booster:
                assert self.__llvm_library_definition_dir
                self.__kore_server = kore_server(
                    self.__definition_dir,
                    self.printer.main_module,
                    llvm_definition_dir=self.__llvm_library_definition_dir,
                    # TODO: Remove --no-smt whenever possible.
                    command=(
                        'kore-rpc-booster',
                        '--smt-timeout',
                        '1000',
                        '--equation-max-iterations',
                        '1000',
                        '--equation-max-recursion',
                        '100',
                        '--interim-simplification',
                        '2000',
                        # '--no-smt',
                        # '-l', 'Rewrite',
                        # '-l', 'SimplifySuccess',
                        # '-l', 'Simplify',
                        # '-l', 'SimplifyKore',
                        # '-l', 'ErrorDetails'
                        # '-l', 'SMT',
                        # '--log-context', '*abort',
                        # '--log-context', '*detail',
                        # '--solver-transcript', 'log.z3',
                        # '--no-post-exec-simplify',
                    ),
                    bug_report=self.__bug_report,
                    # port=39425,
                )
            else:
                self.__kore_server = kore_server(
                    self.__definition_dir,
                    self.printer.main_module,
                    bug_report=self.__bug_report,
                    command=(
                        'kore-rpc',
                        '--smt-timeout',
                        '1000',
                        # '--solver-transcript', 'log.z3',
                        # '--log-entries', 'DebugApplyEquation',  # 'DebugAttemptEquation', #DebugSolverSend,DebugSolverRecv,
                        # '--debug-equation', 'xyzzy2'
                    ),
                    # port=39425,
                )
        if not self.__kore_client:
            self.__kore_client = KoreClient('localhost', self.__kore_server.port, bug_report=self.__bug_report)

        if not self.__explorer:
            cterm_symbolic = CTermSymbolic(self.__kore_client, self.printer.definition, self.printer.kompiled_kore)
            self.__explorer = KCFGExplore(cterm_symbolic)
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
            return KInner.from_dict(kast_term(value))


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
    symbol_table['_^IntTotal_'] = lambda c1, c2: f'({c1}) ^IntTotal ({c2})'
    symbol_table['_^%Int_'] = lambda c1, c2: f'({c1}) ^%Int ({c2})'
    symbol_table['_+Int_'] = lambda c1, c2: f'({c1}) +Int ({c2})'
    symbol_table['_-Int_'] = lambda c1, c2: f'({c1}) -Int ({c2})'
    symbol_table['_>>Int_'] = lambda c1, c2: f'({c1}) >>Int ({c2})'
    symbol_table['shrIntTotal'] = lambda c1, c2: f'({c1}) >>IntTotal ({c2})'
    symbol_table['_<<Int_'] = lambda c1, c2: f'({c1}) <<Int ({c2})'
    symbol_table['shlIntTotal'] = lambda c1, c2: f'({c1}) <<IntTotal ({c2})'
    symbol_table['_&Int_'] = lambda c1, c2: f'({c1}) &Int ({c2})'
    symbol_table['_xorInt_'] = lambda c1, c2: f'({c1}) xorInt ({c2})'
    symbol_table['_|Int_'] = lambda c1, c2: f'({c1}) |Int ({c2})'
