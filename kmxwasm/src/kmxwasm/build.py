from pathlib import Path

from pyk.kbuild.kbuild import KBuild
from pyk.kbuild.package import Package

from .tools import Tools

HASKELL = 'haskell'
LEMMA_PROOFS = 'lemma-proofs'


def kbuild_semantics(output_dir: Path, config_file: Path, target: str) -> Tools:
    kbuild = KBuild(output_dir)
    package = Package.create(config_file)
    kbuild.kompile(package, target)
    return Tools(kbuild.definition_dir(package, target))
