from pathlib import Path

from pyk.kbuild.kbuild import KBuild
from pyk.kbuild.package import Package

from .tools import Tools


def kbuild_semantics(output_dir: Path, config_file: Path) -> Tools:
    kbuild = KBuild(output_dir)
    package = Package.create(config_file)
    kbuild.kompile(package, 'haskell')
    return Tools(kbuild.definition_dir(package, 'haskell'))
