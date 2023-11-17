import sys
from pathlib import Path

from pyk.ktool.kprove import _kprove


def prove(lemma_file: Path, kompiled_dir: Path) -> None:
    result = _kprove(lemma_file, kompiled_dir=kompiled_dir)
    if result.returncode != 0:
        print(f'Failed to prove {lemma_file}')
        print(f'Args: {result.args}')
        print(f'Stdout: {result.stdout}')
        print(f'Stderr: {result.stderr}')
        result.check_returncode()
    print(f'Proved {lemma_file}')


def main(args: list[str]) -> None:
    if len(args) != 2:
        raise ValueError('Expected two arguments: claim file and kompiled dir.')
    lemma_file = Path(args[0])
    kompiled_dir = Path(args[1])
    if not lemma_file.is_file():
        raise ValueError(f'{lemma_file} is not a file.')
    if not kompiled_dir.is_dir():
        raise ValueError(f'{kompiled_dir} is not a directory.')
    prove(lemma_file=lemma_file, kompiled_dir=kompiled_dir)


if __name__ == '__main__':
    main(sys.argv[1:])
