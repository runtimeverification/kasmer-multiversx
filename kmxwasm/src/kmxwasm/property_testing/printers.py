from pyk.cterm import CTerm
from pyk.kast.inner import KApply, KInner, KVariable
from pyk.kast.manip import ml_pred_to_bool
from pyk.kcfg import KCFG
from pyk.ktool.kprint import KPrint
from pyk.prelude.kbool import TRUE

from ..ast.mx import (
    get_first_command,
    get_first_instr,
    get_first_k_item,
    get_logging_cell_content,
    get_vm_output_cell_content,
)


def print_node(printer: KPrint, node: KCFG.Node) -> None:
    pretty = printer.pretty_print(node.cterm.config, sort_collections=True)
    print(pretty)
    for c in node.cterm.constraints:
        if c != TRUE:
            print()
            print(printer.pretty_print(c))
            print(c)
            print()
            try:
                pretty = printer.pretty_print(ml_pred_to_bool(c))
                print('requires:', pretty)
            except BaseException:  # noqa: B036
                print('ml_pred_to_bool failed')
    print(flush=True)


def node_summary(node: CTerm, printer: KPrint) -> list[str]:
    def print_short_left(thing: KInner) -> str:
        result = printer.pretty_print(thing)
        if len(result) > 120:
            result = result[:117] + '...'
        return result

    def print_short_right(thing: KInner) -> str:
        result = printer.pretty_print(thing)
        if len(result) > 120:
            result = '...' + result[-117:]
        return result

    summary: list[str] = []
    instr = get_first_instr(node.config)
    if instr is not None:
        summary = [f'instrs: {print_short_left(instr)}']
    else:
        command = get_first_command(node.config)
        if command is not None:
            summary = [f'command: {print_short_left(command)}']
        else:
            kitem = get_first_k_item(node.config)
            if kitem is not None:
                summary = [f'k: {print_short_left(kitem)}']
            else:
                summary = ['Nothing to execute']

    log = get_logging_cell_content(node.config)
    if not isinstance(log, KVariable):
        summary.append(f'logging: {print_short_right(log)}')

    output = get_vm_output_cell_content(node.config)
    if isinstance(output, KApply):
        if output.label.name == 'VMOutput':
            assert 1 < output.arity
            summary.append(f'VM Output return code: {print_short_left(output.args[0])}')
            summary.append(f'VM Output return message: {print_short_left(output.args[1])}')
    return summary
