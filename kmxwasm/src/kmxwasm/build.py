import time
from pathlib import Path

from pyk.kbuild.kbuild import KBuild
from pyk.kbuild.package import Package

from .tools import Tools

HASKELL = 'haskell'
LLVM = 'llvm'
LEMMA_PROOFS = 'lemma-proofs'


def kbuild_semantics(output_dir: Path, config_file: Path, target: str) -> Tools:
    kbuild = KBuild(output_dir)
    package = Package.create(config_file)
    start_time = time.time()
    kbuild.kompile(package, target)
    mid_time = time.time()
    print('Kompiling', target, ':', mid_time - start_time, 'sec')
    kbuild.kompile(package, LLVM)
    print('Kompiling', LLVM, ':', time.time() - mid_time, 'sec')
    return Tools(kbuild.definition_dir(package, target), kbuild.definition_dir(package, LLVM))
