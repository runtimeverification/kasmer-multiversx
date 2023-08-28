from pathlib import Path

from pyk.kbuild.kbuild import KBuild
from pyk.kbuild.package import Package

from .tools import Tools


def kbuild_semantics(kbuild_dir: Path, ml_file: Path) -> Tools:
    kbuild = KBuild(kbuild_dir)
    package = Package.create(ml_file)
    kbuild.kompile(package, 'haskell')
    return Tools(kbuild.definition_dir(package, 'haskell'))
