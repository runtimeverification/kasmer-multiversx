import os
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
LEMMA_TESTS = 'lemma-tests'


class Kompiled:
    def __init__(self, output_dir: Path, config_file: Path, target: str, llvm: bool, booster: bool):

        self.output_dir = output_dir
        self.config_file = config_file
        self.target = target
        self.llvm = llvm
        self.booster = booster

        kbuild = KBuild(output_dir)
        package = Project.load(config_file)

        self.kbuild = kbuild
        self.package = package

        # TODO: This is wrong. This is changing a global setting in order to
        # fix a local issue. kbuild.kompile should allow users to set k_opts
        new_k_opts = '-Xmx8192m'
        existing_k_opts = os.environ.get('K_OPTS')
        if not existing_k_opts:
            os.environ['K_OPTS'] = '-Xmx8192m'
        elif new_k_opts not in existing_k_opts:
            os.environ['K_OPTS'] = f'{existing_k_opts} -Xmx8192m'

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

    def make_tools(self, bug_report: BugReport | None) -> Tools:
        return Tools(
            definition_dir=self.kbuild.definition_dir(self.package, self.target),
            llvm_definition_dir=self.kbuild.definition_dir(self.package, LLVM) if self.llvm else None,
            llvm_library_definition_dir=(
                self.kbuild.definition_dir(self.package, LLVM_LIBRARY) if self.booster else None
            ),
            booster=self.booster,
            bug_report=bug_report,
        )


def kbuild_semantics(
    output_dir: Path, config_file: Path, target: str, llvm: bool, booster: bool, bug_report: BugReport | None
) -> Tools:
    kompiled = Kompiled(output_dir, config_file, target, llvm, booster)
    return kompiled.make_tools(bug_report)
