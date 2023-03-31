import subprocess
import tempfile
from contextlib import closing
from pathlib import Path
from socket import AF_INET, SO_REUSEADDR, SOCK_STREAM, SOL_SOCKET, socket
from typing import Any, Optional

from pyk.kast.outer import (
    KAtt,
    KDefinition,
    KFlatModule,
    KImport,
    KProduction,
    KRequire,
    KTerminal,
)
from pyk.kcfg import KCFGExplore
from pyk.ktool.kompile import kompile, KompileBackend
from pyk.ktool.kprint import KPrint
from pyk.ktool.kprove import KProve

from .identifiers import Identifiers
from .rules import RuleCreator


class LazyExplorer:
    def __init__(self,
                 rules: RuleCreator,
                 identifiers: Identifiers,
                 data_folder: Path,
                 definition_parent: Path,
                 k_dir: Path,
                 printer: KPrint,
                 debug_id: str,
                 ) -> None:
        self.__rules = rules
        self.__identifiers = identifiers
        self.__summary_folder = data_folder
        self.__definition_folder = definition_parent
        self.__k_dir = k_dir
        self.__printer = printer
        self.__debug_id = debug_id
        self.__explorer: Optional[KCFGExplore] = None
        self.__kprove: Optional[KProve] = None

    def __enter__(self) -> 'LazyExplorer':
        return self

    def __exit__(self, *_args: Any) -> None:
        self.close()

    def close(self) -> None:
        if self.__explorer:
            self.__explorer.close()

    def get(self) -> KCFGExplore:
        if self.__explorer is None:
            self.__explorer = make_explorer(self.get_kprove(), self.__debug_id != '')
        return self.__explorer
    
    def get_kprove(self) -> KProve:
        if self.__kprove is None:
            if not self.__debug_id:
                self.__make_semantics()
            self.__kprove = make_kprove(self.__definition_folder)
        return self.__kprove

    def printer(self) -> KPrint:
        return self.__printer

    def __make_semantics(self) -> None:
        identifier_sentences = [
            KProduction(sort=sort, items=[KTerminal(token.token)], att=KAtt({'token': ''}))
            for sort, tokens in self.__identifiers.sort_to_ids.items()
            for token in tokens
        ]
        identifiers_module = KFlatModule('IDENTIFIERS', sentences=identifier_sentences)

        ims = [KImport('ELROND-IMPL'), KImport('IDENTIFIERS')]
        macros_module = KFlatModule('SUMMARY-MACROS', sentences=self.__rules.macro_rules(), imports=ims)

        reqs = [
            KRequire('backend-fixes.md'),
            KRequire('elrond-impl.md'),
            KRequire('elrond-lemmas.md'),
            KRequire('elrond-wasm-configuration.md'),
            KRequire('proof-extensions.md'),
        ]
        ims.append(KImport('BACKEND-FIXES'))
        ims.append(KImport('ELROND-LEMMAS'))
        ims.append(KImport('ELROND-WASM-CONFIGURATION'))
        ims.append(KImport('PROOF-EXTENSIONS'))
        ims.append(KImport('SUMMARY-MACROS'))
        # TODO: pyk now supports sending a module of claims when proving.
        # Investigate using that. One possible problem: When executing
        # step-by-step, the Haskell backend might or might not be able to
        # figure out whether a specific rpc we send is the forst step or not,
        # and claims should not be applied at the first step.
        summaries_module = KFlatModule('SUMMARIES', sentences=self.__rules.summarize_rules(), imports=ims)

        definition = KDefinition(
            'SUMMARIES', all_modules=[summaries_module, identifiers_module, macros_module], requires=reqs
        )

        definition_text = self.__printer.pretty_print(definition)
        # definition_text = definition_text.replace('$', '$#')

        self.__summary_folder.mkdir(parents=True, exist_ok=True)
        (self.__summary_folder / 'summaries.k').write_text(definition_text)

        kompile_semantics(self.__k_dir, self.__summary_folder, self.__definition_folder)


def kompile_semantics(k_dir:Path, summary_folder: Optional[Path], definition_dir:Path) -> None:
    print(f'Kompile with {summary_folder} to {definition_dir}', flush=True)
    _result = subprocess.run(['rm', '-r', definition_dir])

    default_summaries_dir = k_dir / 'summaries'
    wasm_dir = k_dir / 'wasm-semantics'

    _output_dir = kompile(
        k_dir / 'elrond-wasm.md',
        output_dir=definition_dir,
        backend=KompileBackend.HASKELL,
        main_module='ELROND-WASM',
        syntax_module='ELROND-WASM-SYNTAX',
        include_dirs=[summary_folder or default_summaries_dir, k_dir, wasm_dir],
        md_selector='k',
    )
    print(f'Kompile done.', flush=True)


def make_kprove(definition_dir: Path) -> KProve:
    return KProve(
        definition_dir,
        bug_report=None
        # bug_report=BugReport(Path('bug_report'))
    )


def make_explorer(kprove: KProve, is_debug:bool) -> KCFGExplore:
    if is_debug:
        port = 39425
    else:
        port = free_port_on_host()
    return KCFGExplore(
        kprove,
        port=port,
        bug_report=kprove._bug_report,
    )


# Based on: https://stackoverflow.com/a/45690594
# TODO: has an obvious race condition, replace with something better.
def free_port_on_host(host: str = 'localhost') -> int:
    with closing(socket(AF_INET, SOCK_STREAM)) as sock:
        sock.bind((host, 0))
        sock.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
        _, port = sock.getsockname()
    return port
