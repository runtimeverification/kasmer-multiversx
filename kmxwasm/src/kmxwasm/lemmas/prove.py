import sys
from pathlib import Path

from pyk.ktool.kprove import _kprove

from ..build import semantics


def prove(lemma_file: Path, kompiled_dir: Path) -> None:
    result = _kprove(lemma_file, kompiled_dir=kompiled_dir)
    if result.returncode != 0:
        print(f'Failed to prove {lemma_file}')
        print(f'Args: {result.args}')
        print(f'Stdout: {result.stdout}')
        print(f'Stderr: {result.stderr}')
        result.check_returncode()
    print(f'Proved {lemma_file}')


def bad_usage() -> None:
    print('Usage:')
    print('    prove.py kompile <compilation-target>')
    print('    prove.py <claim-file> <compilation-target>')
    raise ValueError('Wrong arguments')


def main(args: list[str]) -> None:
    if len(args) != 2:
        bad_usage()
    target = args[1]

    tools = semantics(target=target, booster=False, bug_report=None)

    if args[0] == 'kompile':
        return
    lemma_file = Path(args[0])
    if not lemma_file.is_file():
        raise ValueError(f'{lemma_file} is not a file.')

    tools.kprove.prove(lemma_file)


if __name__ == '__main__':
    main(sys.argv[1:])
