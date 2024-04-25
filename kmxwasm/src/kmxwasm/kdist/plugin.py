from __future__ import annotations

import shutil
from pathlib import Path
from typing import TYPE_CHECKING

from pyk.kbuild.utils import k_version
from pyk.kdist.api import Target
from pyk.ktool.kompile import KompileBackend, LLVMKompileType, kompile

if TYPE_CHECKING:
    from collections.abc import Callable, Mapping
    from typing import Any, Final


# TODO Distribute plugin files with kmultiversx
PLUGIN_DIR: Final = Path(__file__).parents[4] / 'deps/mx-semantics/deps/plugin'


class SourceTarget(Target):
    SRC_DIR: Final = Path(__file__).parent

    def build(self, output_dir: Path, deps: dict[str, Path], args: dict[str, Any], verbose: bool) -> None:
        shutil.copytree(deps['mx-semantics.source'] / 'wasm-semantics', output_dir / 'wasm-semantics')
        shutil.copytree(deps['mx-semantics.source'] / 'mx-semantics', output_dir / 'mx-semantics')
        shutil.copytree(self.SRC_DIR / 'mxwasm-semantics', output_dir / 'mxwasm-semantics')

    def source(self) -> tuple[Path, ...]:
        return (self.SRC_DIR,)

    def deps(self) -> tuple[str]:
        return ('mx-semantics.source',)


class KompileTarget(Target):
    _kompile_args: Callable[[Path], Mapping[str, Any]]

    def __init__(self, kompile_args: Callable[[Path], Mapping[str, Any]]):
        self._kompile_args = kompile_args

    def build(self, output_dir: Path, deps: dict[str, Path], args: dict[str, Any], verbose: bool) -> None:
        # TODO Pass K_OPTS='-Xmx8192m'
        kompile_args = self._kompile_args(deps['mxwasm-semantics.source'])
        kompile(output_dir=output_dir, verbose=verbose, **kompile_args)

    def context(self) -> dict[str, str]:
        return {'k-version': k_version().text}

    def deps(self) -> tuple[str]:
        return ('mxwasm-semantics.source',)


def _default_args(src_dir: Path) -> dict[str, Any]:
    return {
        'include_dirs': [src_dir, PLUGIN_DIR],
        'md_selector': 'k',
        'warnings_to_errors': True,
    }


__TARGETS__: Final = {
    'source': SourceTarget(),
    'llvm': KompileTarget(
        lambda src_dir: {
            'main_file': src_dir / 'mxwasm-semantics/mx-wasm.md',
            'backend': KompileBackend.LLVM,
            **_default_args(src_dir),
        },
    ),
    'llvm-library': KompileTarget(
        lambda src_dir: {
            'main_file': src_dir / 'mxwasm-semantics/mx-wasm.md',
            'backend': KompileBackend.LLVM,
            'llvm_kompile_type': LLVMKompileType.C,
            **_default_args(src_dir),
        },
    ),
    'haskell': KompileTarget(
        lambda src_dir: {
            'main_file': src_dir / 'mxwasm-semantics/mx-wasm.md',
            'backend': KompileBackend.HASKELL,
            **_default_args(src_dir),
        },
    ),
    'lemma-proofs': KompileTarget(
        lambda src_dir: {
            'main_file': src_dir / 'mxwasm-semantics/lemmas/semantics/mx-wasm-lemma-proofs.md',
            'backend': KompileBackend.HASKELL,
            **_default_args(src_dir),
        },
    ),
    'lemma-tests': KompileTarget(
        lambda src_dir: {
            'main_file': src_dir / 'mxwasm-semantics/lemmas/semantics/mx-wasm-lemma-tests.md',
            'backend': KompileBackend.HASKELL,
            **_default_args(src_dir),
        },
    ),
}
