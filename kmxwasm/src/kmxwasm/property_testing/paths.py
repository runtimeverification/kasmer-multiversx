import subprocess
from pathlib import Path

ROOT = Path(subprocess.check_output(['git', 'rev-parse', '--show-toplevel']).decode().strip())
KMXWASM_DIR = ROOT / 'kmxwasm'
KBUILD_DIR = ROOT / '.kbuild'
KBUILD_ML_PATH = KMXWASM_DIR / 'k-src/kbuild.toml'
