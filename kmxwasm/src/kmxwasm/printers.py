from pyk.kast.manip import ml_pred_to_bool
from pyk.kcfg import KCFG
from pyk.prelude.kbool import TRUE

from .tools import Tools


def print_node(tools: Tools, node: KCFG.Node) -> None:
    pretty = tools.printer.pretty_print(node.cterm.config)
    print(pretty)
    for c in node.cterm.constraints:
        if c != TRUE:
            print()
            print(tools.printer.pretty_print(c))
            print(c)
            print()
            try:
                pretty = tools.printer.pretty_print(ml_pred_to_bool(c))
                print('requires:', pretty)
            except BaseException:
                print('ml_pred_to_bool failed')
    print(flush=True)
