import json
from typing import TYPE_CHECKING, Any, Mapping

from pyk.kast import kast_term
from pyk.kast.inner import KInner
from pyk.kast.outer import KClaim
from pyk.kcfg import KCFG

if TYPE_CHECKING:
    from pathlib import Path


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


def load_json_kcfg(input_file: Path) -> KCFG:
    value = load_json_dict(input_file)
    return KCFG.from_dict(value)


def load_json_kclaim(input_file: Path) -> KClaim:
    value = load_json_dict(input_file)
    return kast_term(value, KClaim)


def write_json(term_dict: dict[str, Any], output_file: Path) -> None:
    output_file.parent.mkdir(parents=True, exist_ok=True)
    output_file.write_text(json.dumps(term_dict))


def write_kinner_json(term: KInner, output_file: Path) -> None:
    write_json(term.to_dict(), output_file)


def write_kcfg_json(kcfg: KCFG, output_file: Path) -> None:
    write_json(kcfg.to_dict(), output_file)
