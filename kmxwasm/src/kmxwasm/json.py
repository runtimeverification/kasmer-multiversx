import json
from pathlib import Path
from typing import Any, Mapping

from pyk.kast import kast_term
from pyk.kast.inner import KInner
from pyk.kast.outer import KClaim


def load_json_dict(input_file: Path) -> Mapping[str, Any]:
    with input_file.open() as f:
        return json.load(f)


def load_json_kinner(input_file: Path) -> KInner:
    value = load_json_dict(input_file)
    return KInner.from_dict(value)


def load_json_kinner_from_krun(input_file: Path) -> KInner:
    value = load_json_dict(input_file)
    term = KInner.from_dict(value['term'])
    return term


def load_json_kclaim(input_file: Path) -> KClaim:
    value = load_json_dict(input_file)
    result = KClaim.from_dict(kast_term(value))
    if not isinstance(result, KClaim):
        raise ValueError(f'Input ({input_file}) is not a claim.')
    return result


def write_json(term_dict: dict[str, Any], output_file: Path) -> None:
    output_file.parent.mkdir(parents=True, exist_ok=True)
    output_file.write_text(json.dumps(term_dict))


def write_kinner_json(term: KInner, output_file: Path) -> None:
    write_json(term.to_dict(), output_file)
