import subprocess
from pathlib import Path

ROOT = Path(subprocess.check_output(['git', 'rev-parse', '--show-toplevel']).decode().strip())
KBUILD_DIR = ROOT / '.kbuild'
KBUILD_ML_PATH = ROOT / 'kmxwasm/k-src/kbuild.toml'
