from pyk.kcfg import KCFG
from pyk.kcfg.show import NodePrinter
from pyk.ktool.kprint import KPrint

from .property_testing.printers import node_summary


class KasmerNodePrinter(NodePrinter):
    def __init__(self, kprint: KPrint):
        NodePrinter.__init__(self, kprint)

    def print_node(self, kcfg: KCFG, node: KCFG.Node) -> list[str]:
        ret_strs = super().print_node(kcfg, node)
        ret_strs += node_summary(node.cterm, self.kprint)
        return ret_strs
