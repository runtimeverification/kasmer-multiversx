#!/usr/bin/env python3

import sys
from pathlib import Path

from .build import kbuild_semantics
from .paths import KBUILD_DIR, KBUILD_ML_PATH
from .running import run_claim


def main(args: list[str]) -> None:
    if len(args) != 1:
        print('Usage:')
        print('  python3 -m kmxwasm.property <claim-file>')
        sys.exit(-1)
    claim_path = Path(args[0])
    if not claim_path.exists():
        print(f'Input file ({claim_path}) does not exist.')
        sys.exit(-1)
    definition = kbuild_semantics(KBUILD_DIR, KBUILD_ML_PATH)
    claims = definition.kprove.get_claims(claim_path)
    if len(claims) != 1:
        print(f'Expected exactly one claim in {claim_path}, found {len(claims)}.')
        sys.exit(-1)
    claim = claims[0]
    run_claim(definition, claim)


if __name__ == '__main__':
    main(sys.argv[1:])
