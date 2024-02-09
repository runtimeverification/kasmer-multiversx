import json

from abc import abstractmethod
from dataclasses import dataclass, field
from pathlib import Path
from typing import TYPE_CHECKING, Generic, TypeVar, final

from pyk.cterm import CSubst, CTerm
from pyk.kast.inner import KApply, KInner, KLabel, KSequence, KToken, KVariable, bottom_up_with_summary
from pyk.kast.manip import (
    bool_to_ml_pred,
    extract_lhs,
    extract_rhs,
    remove_source_attributes,
    rename_generated_vars,
)
from pyk.kcfg.kcfg import KCFG, NodeIdLike
from pyk.prelude.kbool import andBool

if TYPE_CHECKING:
    from collections.abc import Mapping
    from typing import Any

    from pyk.kast.outer import KClaim, KDefinition

A = TypeVar('A')


@dataclass
class CachedValues(Generic[A]):
    value_to_id: dict[A, int] = field(default_factory=dict)
    values: list[A] = field(default_factory=list)

    def cache(self, value: A) -> int:
        id = self.value_to_id.get(value)
        if id is not None:
            return id
        id = len(self.values)
        self.value_to_id[value] = id
        self.values.append(value)
        return id


@dataclass(eq=True, frozen=True)
class OptimizedKInner:
    @abstractmethod
    def build(self, klabels: list[KLabel], terms: list[KInner]) -> KInner: ...


@final
@dataclass(eq=True, frozen=True)
class SimpleOptimizedKInner(OptimizedKInner):
    term: KInner

    def build(self, klabels: list[KLabel], terms: list[KInner]) -> KInner:
        return self.term


@final
@dataclass(eq=True, frozen=True)
class OptimizedKApply(OptimizedKInner):
    label: int
    children: tuple[int, ...]

    def build(self, klabels: list[KLabel], terms: list[KInner]) -> KInner:
        return KApply(klabels[self.label], tuple(terms[child] for child in self.children))


@final
@dataclass(eq=True, frozen=True)
class OptimizedKSequence(OptimizedKInner):
    children: tuple[int, ...]

    def build(self, klabels: list[KLabel], terms: list[KInner]) -> KInner:
        return KSequence(tuple(terms[child] for child in self.children))


class KInnerOptimizer:
    def __init__(self) -> None:
        self.__optimized_terms: CachedValues[OptimizedKInner] = CachedValues()
        self.__klabels: CachedValues[KLabel] = CachedValues()

        self.__terms: list[KInner] = []

        self.__found = 0
        self.__not_found = 0

    def optimize(self, term: KInner) -> KInner:
        def optimizer(to_optimize: KInner, children: list[int]) -> tuple[KInner, int]:
            if isinstance(to_optimize, KToken) or isinstance(to_optimize, KVariable):
                optimized_id = self.cache(SimpleOptimizedKInner(to_optimize))
            elif isinstance(to_optimize, KApply):
                klabel_id = self.cache_klabel(to_optimize.label)
                optimized_id = self.cache(OptimizedKApply(klabel_id, tuple(children)))
            elif isinstance(to_optimize, KSequence):
                optimized_id = self.cache(OptimizedKSequence(tuple(children)))
            else:
                raise ValueError('Unknown term type: ' + str(type(to_optimize)))
            return (self.__terms[optimized_id], optimized_id)

        # return term
        optimized, _ = bottom_up_with_summary(optimizer, term)
        return optimized

    def cache(self, term: OptimizedKInner) -> int:
        id = self.__optimized_terms.cache(term)
        assert id <= len(self.__terms)
        if id == len(self.__terms):
            self.__not_found += 1
            self.__terms.append(term.build(self.__klabels.values, self.__terms))
        else:
            self.__found += 1
        if (self.__found + self.__not_found) & 0xFFFF == 0:
            print(self.__found, self.__not_found)
        return id

    def cache_klabel(self, label: KLabel) -> int:
        return self.__klabels.cache(label)


def optimize_cterm(cterm: CTerm, kast_optimizer: KInnerOptimizer) -> CTerm:
    new_config = kast_optimizer.optimize(cterm.config)
    return CTerm(new_config, cterm.constraints)


def optimize_kcfg(kcfg: KCFG, kast_optimizer: KInnerOptimizer) -> None:
    for node in kcfg.nodes:
        kcfg.replace_node(node.id, optimize_cterm(node.cterm, kast_optimizer))


class OptimizedKCFG(KCFG):
    def __init__(self, cfg_dir: Path | None = None) -> None:
        super().__init__(cfg_dir)
        self.__optimizer = KInnerOptimizer()

    @staticmethod
    def from_claim(
        defn: KDefinition, claim: KClaim, cfg_dir: Path | None = None
    ) -> tuple[KCFG, NodeIdLike, NodeIdLike]:
        cfg = KCFG(cfg_dir=cfg_dir)
        claim_body = claim.body
        claim_body = defn.instantiate_cell_vars(claim_body)
        claim_body = rename_generated_vars(claim_body)

        claim_lhs = CTerm.from_kast(extract_lhs(claim_body)).add_constraint(bool_to_ml_pred(claim.requires))
        init_node = cfg.create_node(claim_lhs)

        claim_rhs = CTerm.from_kast(extract_rhs(claim_body)).add_constraint(
            bool_to_ml_pred(andBool([claim.requires, claim.ensures]))
        )
        target_node = cfg.create_node(claim_rhs)

        return cfg, init_node.id, target_node.id

    @staticmethod
    def from_json(s: str) -> KCFG:
        return KCFG.from_dict(json.loads(s))

    @staticmethod
    def from_dict(dct: Mapping[str, Any]) -> KCFG:
        cfg = OptimizedKCFG()

        max_id = 0
        for node_dict in dct.get('nodes') or []:
            node_id = node_dict['id']
            max_id = max(max_id, node_id)
            cterm = CTerm.from_dict(node_dict['cterm'])
            node = KCFG.Node(node_id, cterm)
            cfg.add_node(node)

        cfg._node_id = dct.get('next', max_id + 1)

        for edge_dict in dct.get('edges') or []:
            source_id = edge_dict['source']
            target_id = edge_dict['target']
            depth = edge_dict['depth']
            rules = edge_dict['rules']
            cfg.create_edge(source_id, target_id, depth, rules=rules)

        for cover_dict in dct.get('covers') or []:
            source_id = cover_dict['source']
            target_id = cover_dict['target']
            csubst = CSubst.from_dict(cover_dict['csubst'])
            cfg.create_cover(source_id, target_id, csubst=csubst)

        for vacuous_id in dct.get('vacuous') or []:
            cfg.add_vacuous(vacuous_id)

        for stuck_id in dct.get('stuck') or []:
            cfg.add_stuck(stuck_id)

        for alias, node_id in dct.get('aliases', {}).items():
            cfg.add_alias(alias=alias, node_id=node_id)

        for split_dict in dct.get('splits') or []:
            source_id = split_dict['source']
            targets = [
                (target_dict['target'], CSubst.from_dict(target_dict['csubst']))
                for target_dict in split_dict['targets']
            ]
            cfg.create_split(source_id, targets)

        for ndbranch_dict in dct.get('ndbranches') or []:
            source_id = ndbranch_dict['source']
            target_ids = ndbranch_dict['targets']
            cfg.create_ndbranch(source_id, target_ids)

        return cfg

    def add_node(self, node: KCFG.Node) -> None:
        if node.id in self._nodes:
            raise ValueError(f'Node with id already exists: {node.id}')
        node = KCFG.Node(node.id, optimize_cterm(node.cterm, self.__optimizer))
        self._nodes[node.id] = node
        self._created_nodes.add(node.id)

    def create_node(self, cterm: CTerm) -> KCFG.Node:
        term = cterm.kast
        term = remove_source_attributes(term)
        cterm = optimize_cterm(CTerm.from_kast(term), self.__optimizer)
        node = KCFG.Node(self._node_id, cterm)
        self._node_id += 1
        self._nodes[node.id] = node
        self._created_nodes.add(node.id)
        return self._nodes[node.id]

    def replace_node(self, node_id: NodeIdLike, cterm: CTerm) -> None:
        term = cterm.kast
        term = remove_source_attributes(term)
        cterm = optimize_cterm(CTerm.from_kast(term), self.__optimizer)
        node_id = self._resolve(node_id)
        node = KCFG.Node(node_id, cterm)
        self._nodes[node_id] = node
        self._created_nodes.add(node.id)
