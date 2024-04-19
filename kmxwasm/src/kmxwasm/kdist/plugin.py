from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from kmultiversx.kdist.plugin import SOURCE_DIR as MX_K_DIR
from pyk.kbuild.utils import k_version
from pyk.kdist.api import Target
from pyk.ktool.kompile import KompileBackend, LLVMKompileType, kompile
from pykwasm.kdist.plugin import SOURCE_DIR as WASM_DIR

if TYPE_CHECKING:
    from collections.abc import Mapping
    from typing import Any, Final


MX_DIR: Final = MX_K_DIR.parent  # TODO fix in upstream


SOURCE_DIR: Final = Path(__file__).parent
K_DIR: Final = SOURCE_DIR / 'mxwasm-semantics'
PLUGIN_DIR: Final = (
    SOURCE_DIR.parents[3] / 'deps/mx-semantics/deps/plugin'
)  # TODO Distribute plugin files with kmultiversx


class KompileTarget(Target):
    _kompile_args: dict[str, Any]

    def __init__(self, kompile_args: Mapping[str, Any]):
        self._kompile_args = dict(kompile_args)

    def build(self, output_dir: Path, deps: dict[str, Path], args: dict[str, Any], verbose: bool) -> None:
        # TODO Pass K_OPTS='-Xmx8192m'
        kompile(
            output_dir=output_dir,
            verbose=verbose,
            **self._kompile_args,
        )

    def source(self) -> tuple[Path, ...]:
        return (SOURCE_DIR,)

    def context(self) -> dict[str, str]:
        return {'k-version': k_version().text}


KOMPILE_DEFAULTS: Final = {
    'include_dirs': [WASM_DIR, MX_DIR, PLUGIN_DIR],
    'md_selector': 'k',
}


__TARGETS__: Final = {
    'llvm': KompileTarget(
        {
            'main_file': K_DIR / 'mx-wasm.md',
            'backend': KompileBackend.LLVM,
            **KOMPILE_DEFAULTS,
        },
    ),
    'llvm-library': KompileTarget(
        {
            'main_file': K_DIR / 'mx-wasm.md',
            'backend': KompileBackend.LLVM,
            'llvm_kompile_type': LLVMKompileType.C,
            **KOMPILE_DEFAULTS,
        },
    ),
    'haskell': KompileTarget(
        {
            'main_file': K_DIR / 'mx-wasm.md',
            'backend': KompileBackend.HASKELL,
            **KOMPILE_DEFAULTS,
        },
    ),
    'lemma-proofs': KompileTarget(
        {
            'main_file': K_DIR / 'lemmas/semantics/mx-wasm-lemma-proofs.md',
            'backend': KompileBackend.HASKELL,
            **KOMPILE_DEFAULTS,
        },
    ),
    'lemma-tests': KompileTarget(
        {
            'main_file': K_DIR / 'lemmas/semantics/mx-wasm-lemma-tests.md',
            'backend': KompileBackend.HASKELL,
            **KOMPILE_DEFAULTS,
        },
    ),
}
