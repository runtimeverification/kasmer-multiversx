import json
import subprocess
import sys
from pathlib import Path

import pytest
from kmultiversx.kasmer import deploy_test, generate_claim, load_wasm
from kmultiversx.utils import kast_to_json_str
from pyk.cli.utils import BugReport
from pyk.kast.inner import KInner
from pyk.kbuild.kbuild import KBuild
from pyk.kbuild.project import Project
from pyk.ktool.krun import KRun

from kmxwasm.build import LLVM
from kmxwasm.property import RunClaim

sys.setrecursionlimit(1500000000)


TEST_DATA = (Path(__file__).parent / 'data' / 'booster').resolve(strict=True)
TEST_FILES = TEST_DATA.glob('*.json')
SCRIPT_FILE = TEST_DATA / 'run.sh'


class AbortTestParams:
    endpoint: str
    input_types: list[str]
    aborted: int
    stuck: int

    def __init__(self, testcase: Path):
        with open(testcase, 'r') as f:
            j = json.load(f)
            self.endpoint = j.get('endpoint', 'test')
            self.input_types = j['inputs']
            self.aborted = j.get('aborted', 0)
            self.stuck = j.get('stuck', 0)


@pytest.mark.parametrize('testcase', TEST_FILES, ids=str)
def test_aborted(
    testcase: Path,
    kompiled: tuple[KBuild, Project],
    tmp_path: Path,
    bug_report: BugReport | None,
    capfd: pytest.CaptureFixture[str],
) -> None:

    # Given
    kbuild, package = kompiled

    args = AbortTestParams(testcase)

    wasm_path = wat_to_wasm(tmp_path, testcase.with_suffix('.wat'))
    test_wasm = load_wasm(str(wasm_path))

    claim_str = generate_test_claim(args, kbuild.definition_dir(package, LLVM), test_wasm)
    claim_path = tmp_path / 'claim.json'
    claim_path.write_text(claim_str)

    if bug_report is not None:
        bug_report.add_file(claim_path, Path(f'claims/{testcase.stem}-spec.json'))

    # When

    try:
        RunClaim(
            claim_path=claim_path,
            is_k=False,
            restart=False,
            booster=True,
            remove=[],
            run_node_id=None,
            depth=1,
            kcfg_path=tmp_path / 'kcfg',
            bug_report=bug_report,
        ).run()
    except Exception as e:
        if bug_report is not None:
            bug_report.add_file_contents(str(e), Path(f'exception'))
        raise e from None

    captured = capfd.readouterr()

    if bug_report is not None:
        bug_report.add_file_contents(captured.out, Path(f'logs/{testcase.stem}.out'))
        bug_report.add_file_contents(captured.err, Path(f'logs/{testcase.stem}.err'))

    # Then
    cnt_aborted = captured.err.count('[Info#proxy] Booster Aborted')
    cnt_stuck = captured.err.count('[Info#proxy] Booster Stuck')

    assert args.aborted == cnt_aborted
    assert args.stuck == cnt_stuck


def generate_test_claim(args: AbortTestParams, llvm_dir: Path, test_wasm: KInner) -> str:
    empty_conf, init_subst = deploy_test(krun=KRun(llvm_dir), test_wasm=test_wasm, contract_wasms={})
    input_types = tuple(args.input_types)
    claim, _, _ = generate_claim(args.endpoint, input_types, empty_conf, init_subst)
    return kast_to_json_str(claim)


def wat_to_wasm(tmp_path: Path, wat_path: Path) -> Path:
    wasm_name = wat_path.with_suffix('.wasm').name
    wasm_path = tmp_path / wasm_name
    subprocess.call(['wat2wasm', str(wat_path), '-o', str(wasm_path)])
    return wasm_path
