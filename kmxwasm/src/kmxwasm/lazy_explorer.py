import subprocess
from contextlib import closing
from pathlib import Path
from socket import AF_INET, SO_REUSEADDR, SOCK_STREAM, SOL_SOCKET, socket
from typing import Any, Optional

from pyk.kast.outer import KAtt, KDefinition, KFlatModule, KImport, KProduction, KRequire, KTerminal
from pyk.kcfg import KCFGExplore
from pyk.konvert import krule_to_kore
from pyk.kore.syntax import Import, Module, Sentence
from pyk.ktool.kompile import KompileBackend, kompile
from pyk.ktool.kprint import KPrint
from pyk.ktool.kprove import KProve
from pyk.utils import BugReport

from .identifiers import Identifiers
from .rules import RuleCreator

BUG_REPORT: BugReport | None = BugReport(Path('bug-report'))
# BUG_REPORT = None
GENERATED_MODULE_NAME = 'SUMMARIZED-CONTRACT'


class LazyExplorer:
    def __init__(
        self,
        rules: RuleCreator,
        identifiers: Identifiers,
        data_folder: Path,
        definition_parent: Path,
        printer: KPrint,
        debug_id: str,
    ) -> None:
        self.__rules = rules
        self.__identifiers = identifiers
        self.__summary_folder = data_folder
        self.__definition_folder = definition_parent
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
            self.__explorer = make_explorer(self.get_kprove(), self.__debug_id != '', self.__make_summary_module())
        return self.__explorer

    def get_kprove(self) -> KProve:
        if self.__kprove is None:
            self.__write_semantics()
            self.__kprove = make_kprove(self.__definition_folder)
        return self.__kprove

    def printer(self) -> KPrint:
        return self.__printer

    def __make_summary_module(self) -> Module:
        axioms: list[Sentence] = [
            krule_to_kore(self.printer().definition, self.printer().kompiled_kore, r)
            for r in self.__rules.summarize_rules()
        ]
        sentences: list[Sentence] = [Import(module_name='ELROND-WASM', attrs=())]
        return Module(name=GENERATED_MODULE_NAME, sentences=sentences + axioms)

    def __write_semantics(self) -> None:
        identifier_sentences = [
            KProduction(sort=sort, items=[KTerminal(token.token)], att=KAtt({'token': ''}))
            for sort, tokens in self.__identifiers.sort_to_ids.items()
            for token in tokens
        ]
        identifiers_module = KFlatModule('IDENTIFIERS', sentences=identifier_sentences)

        ims = [KImport('ELROND-WASM-CONFIGURATION'), KImport('IDENTIFIERS')]

        reqs = [
            KRequire('backend-fixes.md'),
            KRequire('elrond-lemmas.md'),
            KRequire('elrond-wasm-configuration.md'),
            KRequire('proof-extensions.md'),
        ]
        ims.append(KImport('ELROND-LEMMAS'))
        ims.append(KImport('ELROND-WASM-CONFIGURATION'))
        ims.append(KImport('PROOF-EXTENSIONS'))
        ims.append(KImport('SUMMARY-MACROS'))
        summaries_module = KFlatModule('SUMMARIES', sentences=self.__rules.summarize_rules(), imports=ims)

        definition = KDefinition('SUMMARIES', all_modules=[summaries_module, identifiers_module], requires=reqs)

        definition_text = self.__printer.pretty_print(definition)

        self.__summary_folder.mkdir(parents=True, exist_ok=True)
        (self.__summary_folder / 'summaries.k').write_text(definition_text)


def kompile_semantics(k_dir: Path, definition_dir: Path, backend) -> None:
    print(f'Kompile to {definition_dir}', flush=True)
    _ = subprocess.run(['rm', '-r', definition_dir])

    elrond_dir = k_dir / 'elrond-semantics'
    wasm_dir = elrond_dir / 'deps' / 'wasm-semantics'

    _ = kompile(
        k_dir / 'elrond-wasm.md',
        output_dir=definition_dir,
        backend=backend,
        main_module='ELROND-WASM',
        syntax_module='ELROND-WASM-SYNTAX',
        include_dirs=[k_dir, elrond_dir, wasm_dir],
        md_selector='k',
    )
    print('Kompile done.', flush=True)


def make_kprove(definition_dir: Path) -> KProve:
    return KProve(definition_dir, bug_report=BUG_REPORT)


def make_explorer(kprove: KProve, is_debug: bool, module: Module) -> KCFGExplore:
    if is_debug:
        port = 39425
    else:
        port = free_port_on_host()
    explorer = KCFGExplore(
        kprove,
        port=port,
        bug_report=kprove._bug_report,
    )
    explorer._kore_rpc[1].add_module(module)
    return explorer


# Based on: https://stackoverflow.com/a/45690594
# TODO: has an obvious race condition, replace with something better.
def free_port_on_host(host: str = 'localhost') -> int:
    with closing(socket(AF_INET, SOCK_STREAM)) as sock:
        sock.bind((host, 0))
        sock.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
        _, port = sock.getsockname()
    return port
