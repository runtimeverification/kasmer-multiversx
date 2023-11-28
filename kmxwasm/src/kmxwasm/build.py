from pathlib import Path

from pyk.kbuild.kbuild import KBuild
from pyk.kbuild.project import Project
from pyk.utils import BugReport

from .timing import Timer
from .tools import Tools

HASKELL = 'haskell'
LLVM = 'llvm'
LLVM_LIBRARY = 'llvm-library'
LEMMA_PROOFS = 'lemma-proofs'


def kbuild_semantics(
    output_dir: Path, config_file: Path, target: str, llvm: bool, booster: bool, bug_report: BugReport | None
) -> Tools:
    kbuild = KBuild(output_dir)
    package = Project.load(config_file)

    t = Timer(f'Kompiling {target}:')
    kbuild.kompile(package, target)
    t.measure()

    if llvm:
        t = Timer(f'Kompiling {LLVM}:')
        kbuild.kompile(package, LLVM)
        t.measure()

    if booster:
        t = Timer(f'Kompiling {LLVM_LIBRARY}:')
        kbuild.kompile(package, LLVM_LIBRARY)
        t.measure()

    return Tools(
        definition_dir=kbuild.definition_dir(package, target),
        llvm_definition_dir=kbuild.definition_dir(package, LLVM) if llvm else None,
        llvm_library_definition_dir=kbuild.definition_dir(package, LLVM_LIBRARY) if booster else None,
        booster=booster,
        bug_report=bug_report,
    )
