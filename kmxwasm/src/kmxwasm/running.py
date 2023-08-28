from pyk.kast.outer import KClaim
from pyk.kcfg import KCFG
from pyk.kcfg.kcfg import NodeIdLike
from pyk.kore.rpc import LogEntry

from .tools import Tools


def run_claim(tools: Tools, claim: KClaim) -> bool:
    (kcfg, init_node_id, target_node_id) = KCFG.from_claim(tools.printer.definition, claim)

    processed: set[NodeIdLike] = {target_node_id}
    to_process: list[KCFG.Node] = expandable_leaves(kcfg, target_node_id)
    final_node = kcfg.node(target_node_id)
    print('Start: ', init_node_id, 'End: ', target_node_id)
    while to_process:
        print(to_process)
        while to_process:
            node = to_process.pop()
            processed.add(node.id)
            print('Processing', node.id)

            assert len(list(kcfg.edges(source_id=node.id))) == 0
            assert len(list(kcfg.covers(source_id=node.id))) == 0
            assert len(list(kcfg.splits(source_id=node.id))) == 0
            assert len(list(kcfg.successors(node.id))) == 0

            logs: dict[int, tuple[LogEntry, ...]] = {}
            max_depth = 1
            tools.explorer.extend(kcfg=kcfg, node=node, logs=logs, execute_depth=max_depth)
        for node in kcfg.stuck:
            if tools.explorer.cterm_implies(node.cterm, final_node.cterm):
                kcfg.create_cover(node.id, final_node.id)
                continue
            return False
        to_process = expandable_leaves(kcfg, target_node_id)

    return True


def expandable_leaves(kcfg: KCFG, target_node_id: NodeIdLike) -> list[KCFG.Node]:
    return [node for node in kcfg.leaves if not node.id == target_node_id]
    # [node for node in kcfg.leaves if not node.id in processed]
