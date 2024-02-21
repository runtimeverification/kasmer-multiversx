import subprocess
from pathlib import Path
from typing import Any, Optional

from pyk.kast.att import Atts
from pyk.kast.outer import KAtt, KDefinition, KFlatModule, KImport, KProduction, KRequire, KTerminal
from pyk.kcfg import KCFGExplore
from pyk.konvert import krule_to_kore
from pyk.kore.rpc import KoreClient, KoreServer, kore_server
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
        self.__kore_server: Optional[KoreServer] = None
        self.__kore_client: Optional[KoreClient] = None

    def __enter__(self) -> 'LazyExplorer':
        return self

    def __exit__(self, *_args: Any) -> None:
        self.close()

    def close(self) -> None:
        if self.__kore_client:
            self.__kore_client.close()
        if self.__kore_server:
            self.__kore_server.close()

    def get(self) -> KCFGExplore:
        if self.__explorer is None:
            (self.__explorer, self.__kore_server, self.__kore_client) = make_explorer(
                self.get_kprove(), self.__debug_id != '', self.__make_summary_module()
            )
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
        sentences: list[Sentence] = [Import(module_name='MX-WASM', attrs=())]
        return Module(name=GENERATED_MODULE_NAME, sentences=sentences + axioms)

    def __write_semantics(self) -> None:
        identifier_sentences = [
            KProduction(sort=sort, items=[KTerminal(token.token)], att=KAtt([Atts.TOKEN('')]))
            for sort, tokens in self.__identifiers.sort_to_ids.items()
            for token in tokens
        ]
        identifiers_module = KFlatModule('IDENTIFIERS', sentences=identifier_sentences)

        ims = [KImport('MX-WASM-CONFIGURATION'), KImport('IDENTIFIERS')]

        reqs = [
            KRequire('backend-fixes.md'),
            KRequire('mx-lemmas.md'),
            KRequire('mx-wasm-configuration.md'),
            KRequire('proof-extensions.md'),
        ]
        ims.append(KImport('MX-LEMMAS'))
        ims.append(KImport('MX-WASM-CONFIGURATION'))
        ims.append(KImport('PROOF-EXTENSIONS'))
        ims.append(KImport('SUMMARY-MACROS'))
        summaries_module = KFlatModule('SUMMARIES', sentences=self.__rules.summarize_rules(), imports=ims)

        definition = KDefinition('SUMMARIES', all_modules=[summaries_module, identifiers_module], requires=reqs)

        definition_text = self.__printer.pretty_print(definition)

        self.__summary_folder.mkdir(parents=True, exist_ok=True)
        (self.__summary_folder / 'summaries.k').write_text(definition_text)


def kompile_semantics(k_dir: Path, definition_dir: Path) -> None:
    print(f'Kompile to {definition_dir}', flush=True)
    _ = subprocess.run(['rm', '-r', definition_dir])

    mx_dir = k_dir / 'mx-semantics'
    wasm_dir = mx_dir / 'deps' / 'wasm-semantics'

    _ = kompile(
        k_dir / 'mx-wasm.md',
        output_dir=definition_dir,
        backend=KompileBackend.HASKELL,
        main_module='MX-WASM',
        syntax_module='MX-WASM-SYNTAX',
        include_dirs=[k_dir, mx_dir, wasm_dir],
        md_selector='k',
    )
    print('Kompile done.', flush=True)


def make_kprove(definition_dir: Path) -> KProve:
    return KProve(definition_dir, bug_report=BUG_REPORT)


def make_explorer(kprove: KProve, is_debug: bool, module: Module) -> tuple[KCFGExplore, KoreServer, KoreClient]:
    if is_debug:
        port = 39425
    else:
        port = None
    server = kore_server(kprove.definition_dir, kprove.main_module, port=port)
    kore_client = KoreClient('localhost', server.port)
    explorer = KCFGExplore(kprove, kore_client)
    kore_client.add_module(module)
    return (explorer, server, kore_client)
