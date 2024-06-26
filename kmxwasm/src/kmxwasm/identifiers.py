from dataclasses import dataclass
from typing import Mapping, Optional, Set

from pyk.kast.inner import KInner, KSort, KToken, bottom_up

from .kast import kinner_top_down_fold


@dataclass(frozen=True)
class Identifiers:
    sort_to_ids: Mapping[KSort, Set[KToken]]


def escape_identifiers(term: KInner) -> KInner:
    def escape_identifier(term_: KInner) -> KInner:
        if not isinstance(term_, KToken):
            return term_
        if not term_.sort.name == 'IdentifierToken':
            return term_
        return term_.let(token=term_.token.replace('"', '_Quot_'))

    return bottom_up(escape_identifier, term)


def find_identifiers(term: KInner) -> Identifiers:
    def maybe_identifier(term_: KInner) -> Optional[Mapping[KSort, Set[KToken]]]:
        if isinstance(term_, KToken):
            if term_.sort.name in ['IdentifierToken']:
                return {term_.sort: {term_}}
        return None

    def merge_dicts(
        first: Mapping[KSort, Set[KToken]], second: Mapping[KSort, Set[KToken]]
    ) -> Mapping[KSort, Set[KToken]]:
        result = dict(first)
        for key, value in second.items():
            if key in result:
                result[key] |= value
            else:
                result[key] = value
        return result

    return Identifiers(kinner_top_down_fold(maybe_identifier, merge_dicts, {}, term))
