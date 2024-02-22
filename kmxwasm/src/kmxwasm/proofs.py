#!/usr/bin/env python3

import json
import subprocess
import sys
import time
import traceback
from pathlib import Path
from typing import Any, List, Mapping, Set, Tuple

from pyk.cterm import CTerm
from pyk.kast.inner import KApply, KInner, KLabel, KSequence, KSort, KToken, KVariable, bottom_up
from pyk.kast.manip import ml_pred_to_bool, sort_ac_collections
from pyk.kast.outer import KClaim, KDefinition
from pyk.kcfg import KCFG
from pyk.kore.rpc import KoreClientError
from pyk.ktool.kprint import KPrint
from pyk.ktool.krun import KRunOutput, _krun
from pyk.prelude.bytes import BYTES, bytesToken_from_str
from pyk.prelude.k import K
from pyk.prelude.kbool import TRUE, andBool, notBool
from pyk.prelude.kint import INT, intToken, leInt, ltInt
from pyk.prelude.ml import mlAnd, mlEqualsFalse, mlEqualsTrue, mlNot
from pyk.utils import single

from . import execution, wasm_types
from .functions import (
    Functions,
    WasmFunction,
    find_functions,
    remove_all_function_id_to_addrs_but_one_and_builtins,
    remove_all_functions_but_one_and_builtins,
)
from .identifiers import Identifiers, escape_identifiers, find_identifiers
from .kast import (
    DOT_BYTES,
    SET_BYTES_RANGE,
    bytes_to_string,
    extract_rewrite_parents,
    make_rewrite,
    replace_child,
    replace_child_with_seq_variable,
)
from .lazy_explorer import GENERATED_MODULE_NAME, LazyExplorer, kompile_semantics
from .rules import RuleCreator
from .specs import Specs, find_specs
from .tools import my_patch_symbol_table
from .wasm_types import ValType

sys.setrecursionlimit(4000)

ROOT = Path(subprocess.check_output(['git', 'rev-parse', '--show-toplevel']).decode().strip())
K_DIR = ROOT / 'kmxwasm' / 'k-src'
BUILD_DIR = ROOT / '.build'
DEFINITION_PARENT = BUILD_DIR / 'defn/haskell'
DEFINITION_NAME = 'mx-wasm-kompiled'
DATA_DIR = BUILD_DIR / 'data'
JSON_DIR = DATA_DIR / 'json'
DEBUG_DIR = BUILD_DIR / 'debug'
SUMMARIES_DIR = DATA_DIR / 'summaries'

GENERATED_RULE_PRIORITY = 20
MAP = KSort('Map')

# Setting this disables compilation.
DEBUG_ID = ''  #'ca3493ec081b72857fe96a8b6d3b3f969505e6bc09d91d16eaff9995f2c551ad'


def filter_bytes(term: KToken) -> KInner:
    assert term.sort == BYTES
    bytes = bytes_to_string(term.token)

    zero = '\x00'
    zeros = []
    start = bytes.find(zero, 0)
    if start < 0:
        return term
    while start >= 0:
        idx = start
        next = bytes.find(zero, idx + 1)
        # TODO: Revert this to the previous version.
        while next - idx == len(zero):
            idx = next
            next = bytes.find(zero, idx + 1)
        zeros.append((start, idx))
        start = next
    zeros = [(start, end) for (start, end) in zeros if end - start > 100]
    if not zeros:
        return term

    keep = []
    last_end = 0
    for start, end in zeros:
        if start > last_end:
            keep.append((last_end, start))
        last_end = end
    if last_end < len(bytes):
        keep.append((last_end, len(bytes)))

    new_term = KApply(DOT_BYTES, ())
    for start, end in keep:
        new_term = KApply(SET_BYTES_RANGE, (new_term, KToken(str(start), INT), bytesToken_from_str(bytes[start:end])))
    return new_term


def print_kore_cfg(node_id: int, kcfg: KCFG, printer: KPrint) -> None:
    cterm = kcfg.node(node_id).cterm
    kore = printer.kast_to_kore(cterm.config)
    print(printer.kore_to_pretty(kore))
    for constraint in cterm.constraints:
        kore = printer.kast_to_kore(constraint)
        print(printer.kore_to_pretty(kore))


def krun(input_file: Path, output_file: Path, definition_dir: Path) -> None:
    print('Run', flush=True)
    result = _krun(input_file=input_file, definition_dir=definition_dir, output=KRunOutput.JSON)
    output_file.parent.mkdir(parents=True, exist_ok=True)
    output_file.write_text(result.stdout)


def load_json_dict(input_file: Path) -> Mapping[str, Any]:
    print('Load json', flush=True)
    with input_file.open() as f:
        return json.load(f)


def load_json_krun(input_file: Path) -> KInner:
    start_time = time.time()
    print('Starting', flush=True)
    value = load_json_dict(input_file)
    print('Before dict', time.time() - start_time, flush=True)
    term = KInner.from_dict(value['term'])
    print('term', time.time() - start_time, flush=True)
    return term


def load_json(input_file: Path) -> KInner:
    value = load_json_dict(input_file)
    return KInner.from_dict(value)


def sort_ac_c_term(_definition: KDefinition, term: CTerm) -> CTerm:
    return CTerm(sort_ac_collections(term.config), term.constraints)


def make_apply(label: str, args: List[KInner]) -> KApply:
    return KApply(KLabel(label, []), args)


# TODO: Replace with intToken.
def make_int_token(value: str) -> KToken:
    return KToken(value, INT)


def make_a_call(address: str) -> KApply:
    return make_apply('aCall', [make_int_token(address)])


def k_type_to_val_type(ktype: KInner) -> ValType:
    assert isinstance(ktype, KApply), ktype
    if ktype.label.name == 'i32':
        return wasm_types.I32
    if ktype.label.name == 'i64':
        return wasm_types.I64
    if ktype.label.name == 'f32':
        return wasm_types.F32
    if ktype.label.name == 'f64':
        return wasm_types.F64
    raise AssertionError(ktype)


def make_type(vtype: ValType) -> KApply:
    if vtype == wasm_types.I32:
        return KApply('i32')
    if vtype == wasm_types.I64:
        return KApply('i64')
    if vtype == wasm_types.F32:
        return KApply('f32')
    if vtype == wasm_types.F64:
        return KApply('f64')
    raise AssertionError(vtype)


def make_statement_list(statements: List[KInner]) -> KSequence:
    return KSequence(statements)


def make_sort(t: ValType) -> KSort:
    if t == wasm_types.I32 or t == wasm_types.I64:
        return KSort('Int')
    if t == wasm_types.F32 or t == wasm_types.F64:
        return KSort('Float')
    raise AssertionError(t)


def make_variable(name: str, t: ValType) -> KVariable:
    return KVariable(name=name, sort=make_sort(t))


def make_variables(types: List[ValType]) -> List[KVariable]:
    retv = []
    for idx in range(0, len(types)):
        retv.append(make_variable(f'MyArg{idx}', types[idx]))
    return retv


def make_type_constraint(var: KInner, v_type: ValType) -> KInner:
    if v_type == wasm_types.I32:
        return andBool([leInt(intToken(0), var), ltInt(var, intToken(2**32))])
    if v_type == wasm_types.I64:
        return andBool([leInt(intToken(0), var), ltInt(var, intToken(2**64))])
    raise AssertionError(v_type)


def make_balanced_and_bool(constraints: List[KInner]) -> KInner:
    return andBool(constraints)
    # if not constraints:
    #     return TRUE
    # while len(constraints) > 1:
    #     new_constraints = []
    #     idx = 0
    #     while idx + 1 < len(constraints):
    #         new_constraints.append(andBool(constraints[idx], constraints[idx + 1]))
    #         idx += 2
    #     if idx < len(constraints):
    #         new_constraints.append(constraints)[idx]
    #     constraints = new_constraints
    # return constraints[0]


def generate_symbolic_function_call(function: WasmFunction) -> Tuple[KSequence, KInner, KInner]:
    argument_types_list = function.argument_types_list()
    variables = make_variables(argument_types_list)
    assert len(variables) == len(argument_types_list)
    stack: KInner = KVariable('MyStack', sort=KSort('ValStack'))
    for var, vtype in zip(variables, argument_types_list, strict=True):
        stack = KApply(
            '_:__WASM-DATA-COMMON_ValStack_Val_ValStack',
            (KApply('<_>__WASM-DATA-COMMON_IVal_IValType_Int', (make_type(vtype), var)), stack),
        )
    statements = [KApply('aNop'), make_a_call(function.address()), KVariable('MyOtherInstructions', sort=K)]
    call = make_statement_list(statements)
    constraint_list: List[KInner] = [
        make_type_constraint(var, vtype) for var, vtype in zip(variables, argument_types_list, strict=True)
    ]
    constraint = make_balanced_and_bool(constraint_list)
    return (call, stack, constraint)


def make_claim(term: KInner, constraint: KInner, address: str, functions: Functions) -> Tuple[KInner, KClaim]:
    function = functions.addr_to_function(address)
    (call, stack, fn_constraint) = generate_symbolic_function_call(function)
    lhs = replace_child(term, '<instrs>', call)
    lhs = replace_child(lhs, '<valstack>', stack)
    lhs = replace_child(lhs, '<mdata>', KVariable('MyMdata', sort=BYTES))
    lhs = replace_child(lhs, '<locals>', KVariable('MyLocals', sort=MAP))
    rewrite = make_rewrite(lhs, term)
    write_json(rewrite, DEBUG_DIR / 'rewrite.json')
    full_constraint = make_balanced_and_bool([constraint, fn_constraint])
    return (lhs, KClaim(body=rewrite, requires=full_constraint))


def write_json(term: KInner, output_file: Path) -> None:
    output_file.parent.mkdir(parents=True, exist_ok=True)
    output_file.write_text(json.dumps(term.to_dict()))


def debug_cterm(term: CTerm, printer: KPrint) -> None:
    pretty = printer.pretty_print(term.config)
    print(pretty, flush=True)
    print()

    for constraint in term.constraints:
        prefix1 = '++'
        prefix2 = '**'
        print(prefix1, printer.pretty_print(constraint), flush=True)
        try:
            print(prefix2, printer.pretty_print(ml_pred_to_bool(constraint)), flush=True)
        except Exception:
            print(prefix2, 'Cannot print bool constraint', flush=True)


def my_step(explorer: LazyExplorer, kcfg: KCFG, node_id: int) -> List[int]:
    node = kcfg.node(node_id)
    out_edges: List[int] = []
    for split in kcfg.splits(source_id=node.id):
        for n in split.targets:
            out_edges.append(n.id)
    for branch in kcfg.ndbranches(source_id=node.id):
        for n in branch.targets:
            out_edges.append(n.id)
    for e in kcfg.edges(source_id=node.id):
        out_edges.append(e.target.id)
    if len(out_edges) > 0:
        return out_edges
    assert len(list(kcfg.edges(source_id=node.id))) == 0
    assert len(list(kcfg.covers(source_id=node.id))) == 0
    assert len(list(kcfg.splits(source_id=node.id))) == 0
    assert len(list(kcfg.successors(node.id))) == 0

    print(f'Executing {node.id}!', flush=True)
    try:
        (cterm, next_cterms, depth, _is_vacuous, next_node_logs) = explorer.get().cterm_execute(
            node.cterm, depth=1, module_name=GENERATED_MODULE_NAME
        )
    except BaseException:
        debug_cterm(node.cterm, explorer.printer())
        raise

    # Basic block
    if depth > 0:
        if len(next_cterms) != 0:
            raise ValueError(f'Unexpected next cterms length {len(next_cterms)}: {node.id}')
        cterm = sort_ac_c_term(explorer.printer().definition, cterm)
        next_node = kcfg.create_node(cterm)
        print(next_node_logs)
        # TODO: This may be other things than mlTop()
        kcfg.create_edge(node.id, next_node.id, depth=depth)
        return [next_node.id]

    # Stuck
    if len(next_cterms) == 0:
        print(node.id)
        print(explorer.printer().pretty_print(node.cterm.config), flush=True)
        for constraint in node.cterm.constraints:
            print('--', explorer.printer().pretty_print(constraint), flush=True)
        for constraint in node.cterm.constraints:
            print('**', explorer.printer().pretty_print(ml_pred_to_bool(constraint)), flush=True)
        write_json(node.cterm.config, DEBUG_DIR / 'stuck.json')
        raise ValueError(f'Found stuck node {node.id}.')

    # Cut Rule
    if len(next_cterms) == 1:
        cterm = sort_ac_c_term(explorer.printer().definition, cterm)
        next_node = kcfg.create_node(cterm)
        print(next_node_logs)
        kcfg.create_edge(node.id, next_node.id, depth=depth)
        return [next_node.id]

    # Branch
    if len(next_cterms) > 1:
        branches = [mlAnd(c for c in s.constraints if c not in cterm.constraints) for s in next_cterms]
        branch_and = mlAnd(branches)
        branch_patterns = [
            mlAnd([mlEqualsTrue(KVariable('B')), mlEqualsTrue(notBool(KVariable('B')))]),
            mlAnd([mlEqualsTrue(notBool(KVariable('B'))), mlEqualsTrue(KVariable('B'))]),
            mlAnd([mlEqualsTrue(KVariable('B')), mlEqualsFalse(KVariable('B'))]),
            mlAnd([mlEqualsFalse(KVariable('B')), mlEqualsTrue(KVariable('B'))]),
            mlAnd([mlNot(KVariable('B')), KVariable('B')]),
            mlAnd([KVariable('B'), mlNot(KVariable('B'))]),
        ]

        # Split on branch patterns
        if any(branch_pattern.match(branch_and) for branch_pattern in branch_patterns):
            next_ids = kcfg.split_on_constraints(node.id, branches)

        # NDBranch on successor nodes
        else:
            next_ids = [kcfg.create_node(sort_ac_c_term(explorer.printer().definition, ct)).id for ct in next_cterms]
            print(next_node_logs)
            kcfg.create_ndbranch(node.id, next_ids)
        for next_id in next_ids:
            print(node.id, '-*>', next_id)
        assert node.id not in next_ids
        return next_ids

    raise ValueError('Unhandled case.')


def my_step_logging(explorer: LazyExplorer, kcfg: KCFG, node_id: int, branches: int) -> List[int]:
    prev_cterm = kcfg.node(node_id).cterm
    prev_config = prev_cterm.config
    new_node_ids = my_step(explorer=explorer, kcfg=kcfg, node_id=node_id)
    first = True
    print([node_id], '->', new_node_ids, f'{branches - 1} branches left', flush=True)
    for new_node_id in new_node_ids:
        new_cterm = kcfg.node(new_node_id).cterm
        config = new_cterm.config

        diff = make_rewrite(prev_config, config)
        if not first:
            print('-' * 80)
        first = False
        # pretty = explorer.printer().pretty_print(diff)
        # print(pretty)
        children = extract_rewrite_parents(diff)
        for child in children:
            pretty = explorer.printer().pretty_print(child)
            print(pretty)
            print()

        for c in new_cterm.constraints:
            if c != TRUE and not c in prev_cterm.constraints:
                print(explorer.printer().pretty_print(c))
                print(c)
                print()
                try:
                    pretty = explorer.printer().pretty_print(ml_pred_to_bool(c))
                except ValueError:
                    pretty = traceback.format_exc()
                print('requires:', pretty)
                print()
    print('=' * 80, flush=True)
    return new_node_ids


def execute_function(
    function_addr: str,
    term: KInner,
    constraint: KInner,
    functions: Functions,
    explorer: LazyExplorer,
    state_path: Path,
    execution_decision: execution.ExecutionManager,
    rules: RuleCreator,
) -> execution.Decision:
    print('*' * 80)
    print('*' * 80)
    print('*' * 26, ' ' * 10, function_addr)
    print('*' * 80)
    print('*' * 80, flush=True)

    function_state_path = state_path / 'functions'
    function_state_path.mkdir(parents=True, exist_ok=True)
    function_state_path = function_state_path / f'{function_addr}.json'

    if function_state_path.exists():
        json = function_state_path.read_text()
        kcfg = KCFG.from_json(json)
    else:
        # TODO: This is WRONG, should find a better way to solve the speed issue.
        # We should replace the removed functions with a variable, or something
        # similar.
        hacked_term = remove_all_functions_but_one_and_builtins(term, function_addr, functions)
        hacked_term = remove_all_function_id_to_addrs_but_one_and_builtins(hacked_term, function_addr, functions)

        # TODO: Set kcfg with a LHS only, not an entire claim.
        hacked_term = sort_ac_collections(hacked_term)
        (_rule_creator, claim) = make_claim(hacked_term, constraint, function_addr, functions)
        kcfg, _init_node_id, target_node_id = KCFG.from_claim(explorer.printer().definition, claim)
        kcfg.remove_node(target_node_id)

    debug = kcfg.get_node(DEBUG_ID)
    if debug:
        for e in kcfg.edges(source_id=debug.id):
            kcfg.remove_edge(e.source.id, e.target.id)
            kcfg.remove_node(e.target.id)

    try:
        first_node_id = single(kcfg.root).id
        node_ids = my_step(explorer, kcfg, first_node_id)
        assert len(node_ids) == 1
        lhs_id = node_ids[0]
        rhs_ids = []
        while node_ids:
            current_node_id = node_ids[-1]
            node_ids.pop()
            new_node_ids = my_step_logging(explorer, kcfg, current_node_id, len(node_ids) + 1)
            for node_id in reversed(new_node_ids):
                decision = execution_decision.decide_configuration(kcfg, node_id)
                if isinstance(decision, execution.Finish):
                    rhs_ids.append(node_id)
                    print([node_id], 'finished', flush=True)
                elif isinstance(decision, execution.UnimplementedMxFunction):
                    raise ValueError(repr(decision))
                elif isinstance(decision, execution.UnsummarizedFunction):
                    return decision
                elif isinstance(decision, execution.Loop):
                    return decision
                elif isinstance(decision, execution.Continue):
                    node_ids.append(node_id)
                elif isinstance(decision, execution.ClaimNotAppliedForSummarizedFunction):
                    # rule = make_final_rule(current_node_id, node_id, kcfg)
                    # print(explorer.printer().pretty_print(rule))
                    # print_kore_cfg(current_node_id, kcfg, explorer.printer())
                    raise ValueError(repr(decision))
                else:
                    raise AssertionError(decision)
    finally:
        function_state_path.parent.mkdir(parents=True, exist_ok=True)
        function_state_path.write_text(kcfg.to_json())
    for rhs_id in rhs_ids:
        rules.add_rule(lhs_id, rhs_id, kcfg)
    return execution.Finish()


def execute_functions(
    term: KInner,
    constraints: KInner,
    functions: Functions,
    blacklisted_functions: Set[str],
    specs: Specs,
    identifiers: Identifiers,
    printer: KPrint,
    state_path: Path,
    summaries_path: Path,
    definition_parent: Path,
    execution_decision: execution.ExecutionManager,
) -> None:
    rules = RuleCreator(GENERATED_RULE_PRIORITY)
    unprocessed_functions: List[str] = [
        addr
        for addr in functions.addrs()
        if not functions.addr_to_function(addr).is_builtin()
        if not addr in blacklisted_functions
    ]
    not_processable: List[str] = []
    processed_functions: List[str] = []
    while unprocessed_functions:
        postponed_functions: List[str] = []
        for function_addr in unprocessed_functions:
            with LazyExplorer(
                rules=rules,
                identifiers=identifiers,
                data_folder=summaries_path / function_addr,
                definition_parent=definition_parent,
                printer=printer,
                debug_id=DEBUG_ID,
            ) as explorer:
                specs.add_rules(processed_functions, rules, explorer)

                execution_decision.start_function(int(function_addr))
                result = execute_function(
                    function_addr, term, constraints, functions, explorer, state_path, execution_decision, rules
                )
                if isinstance(result, execution.UnsummarizedFunction):
                    postponed_functions.append(function_addr)
                elif isinstance(result, execution.Loop):
                    not_processable.append(function_addr)
                else:
                    assert isinstance(result, execution.Finish), result
                    processed_functions.append(function_addr)
                    execution_decision.finish_function(int(function_addr))
        if len(postponed_functions) == len(unprocessed_functions):
            with LazyExplorer(
                rules=rules,
                identifiers=identifiers,
                data_folder=summaries_path / 'final',
                definition_parent=definition_parent,
                printer=printer,
                debug_id=DEBUG_ID,
            ) as explorer:
                explorer.get()
            raise ValueError(
                f'Cannot summarize {unprocessed_functions}, postponed={postponed_functions}, unprocessable={not_processable}, processed={processed_functions}'
            )
        unprocessed_functions = postponed_functions
    with LazyExplorer(
        rules=rules,
        identifiers=identifiers,
        data_folder=summaries_path / 'final',
        definition_parent=definition_parent,
        printer=printer,
        debug_id=DEBUG_ID,
    ) as explorer:
        explorer.get()
    print(f'unprocessed={unprocessed_functions}, unprocessable={not_processable}, processed={processed_functions}')


class VariablesForGlobals:
    def __init__(self) -> None:
        self.__next_index = 0
        self.__constraints: List[KInner] = []

    def replace_globals(self, term: KInner) -> KInner:
        if not isinstance(term, KApply):
            return term
        if term.label.name != '<globalInst>':
            return term
        assert term.arity == 3, term
        gmut = term.args[2]
        assert isinstance(gmut, KApply), gmut
        assert gmut.label.name == '<gMut>', gmut
        assert gmut.arity == 1, term
        mutability = gmut.args[0]
        assert isinstance(mutability, KApply), mutability
        if mutability.label.name == 'mutConst':
            return term
        assert mutability.label.name == 'mutVar', mutability

        gvalue = term.args[1]
        assert isinstance(gvalue, KApply), gvalue
        assert gvalue.label.name == '<gValue>', gvalue
        assert gvalue.arity == 1, gvalue

        typed_value = gvalue.args[0]
        assert isinstance(typed_value, KApply)
        val_type = k_type_to_val_type(typed_value.args[0])

        assert isinstance(typed_value, KApply), typed_value
        assert typed_value.label.name == '<_>__WASM-DATA-COMMON_IVal_IValType_Int', typed_value
        assert typed_value.arity == 2, typed_value

        variable = make_variable(f'MyGlobal{self.__next_index}', val_type)
        self.__next_index += 1

        typed_value = typed_value.let(args=(typed_value.args[0], variable))
        gvalue = gvalue.let(args=(typed_value,))
        term = term.let(args=(term.args[0], gvalue, term.args[2]))

        self.__constraints.append(make_type_constraint(variable, val_type))

        return term

    def constraints(self) -> List[KInner]:
        return self.__constraints


def replace_globals_with_variables(term: KInner) -> Tuple[KInner, List[KInner]]:
    replacer = VariablesForGlobals()
    new_term = bottom_up(replacer.replace_globals, term)
    return (new_term, replacer.constraints())


# TODO: Move somewhere else, perhaps in pyk:
LIST = KSort('List')
SET = KSort('Set')


def run_for_input(
    input_file: Path, short_name: str, blacklisted_functions: Set[str], whitelisted_for_loops: Set[str]
) -> None:
    json_dir = JSON_DIR / short_name
    summaries_dir = SUMMARIES_DIR / short_name
    definitions_dir = DEFINITION_PARENT / short_name
    main_definition_dir = definitions_dir / DEFINITION_NAME

    if not DEBUG_ID:
        kompile_semantics(k_dir=K_DIR, definition_dir=main_definition_dir)

    krun_output_file = json_dir / 'krun.json'
    bytes_output_file = json_dir / 'bytes.json'
    if not bytes_output_file.exists():
        if not krun_output_file.exists():
            krun(input_file, krun_output_file, main_definition_dir)
        term = load_json_krun(krun_output_file)
        write_json(term, bytes_output_file)

    term = load_json(bytes_output_file)

    # TODO: We should not simply remove the top condition.
    # However, due to
    # https://github.com/runtimeverification/haskell-backend/issues/3562
    # we get a spurious side condition. This is an attempt to change the
    # term to what it should be if the bug was fixed.
    if isinstance(term, KApply):
        if term.label.name == '#And':
            term = term.args[1]

    term = escape_identifiers(term)
    identifiers = find_identifiers(term)
    functions = find_functions(term)
    specs = find_specs(input_file.parent / short_name)

    replacements = [
        # The exports field contains wasm strings that are not serialized properly.
        ('<exports>', 'MyExports', MAP),
        # These are not needed and increase the execution + parsing time:
        ('<funcIds>', 'MyFuncIds', MAP),
        # Real symbolic inputs
        # <elrond>
        ('<bufferHeap>', 'MyBuffers', KSort('MapIntToBytes')),
        ('<bigIntHeap>', 'MyInts', KSort('MapIntToInt')),
        # <elrond>/<node>/<callState>
        ('<callArgs>', 'MyCallArgs', KSort('ListBytes')),
        ('<caller>', 'MyCaller', BYTES),
        ('<callee>', 'MyCallee', BYTES),
        ('<callValue>', 'MyCallValue', INT),
        ('<esdtTransfers>', 'MyEsdtTransfers', LIST),
        ('<out>', 'MyOut', KSort('ListBytes')),
        ('<interimStates>', 'MyInterimStates', LIST),
        ('<logs>', 'MyLogs', LIST),
        # <elrond>/<node>
        ('<accounts>', 'MyAccounts', KSort('AccountCellMap')),
        # ('<accounts>', 'MyAccounts', KSort('MapBytesToAccount')),
        # <elrond>/<node>/<previousBlockInfo>
        ('<prevBlockTimestamp>', 'MyPrevBlockTimestamp', INT),
        ('<prevBlockNonce>', 'MyPrevBlockNonce', INT),
        ('<prevBlockRound>', 'MyPrevBlockRound', INT),
        ('<prevBlockEpoch>', 'MyPrevBlockEpoch', INT),
        ('<prevBlockRandomSeed>', 'MyPrevBlockRandomSeed', BYTES),
        # <elrond>/<node>/<currentBlockInfo>
        ('<curBlockTimestamp>', 'MyCurBlockTimestamp', INT),
        ('<curBlockNonce>', 'MyCurBlockNonce', INT),
        ('<curBlockRound>', 'MyCurBlockRound', INT),
        ('<curBlockEpoch>', 'MyCurBlockEpoch', INT),
        ('<curBlockRandomSeed>', 'MyCurBlockRandomSeed', BYTES),
    ]
    # TODO: Add constraints for the variables above.

    for name, var_name, sort in replacements:
        term = replace_child_with_seq_variable(term=term, parent_name=name, variable_name=var_name, sort=sort)

    # TODO: Check what is worth generalizing from
    # <contractModIdx>, <moduleInst>, <memAddrs>, <memInst>, <mAddr>, <msize>
    term = replace_child(term, '<contractModIdx>', intToken(1))

    term, constraints = replace_globals_with_variables(term)
    constraints.append(leInt(intToken(0), KVariable('MyCallValue')))
    constraint = make_balanced_and_bool(constraints)

    printer = KPrint(main_definition_dir, patch_symbol_table=my_patch_symbol_table)
    execution_decision = execution.ExecutionManager(functions, whitelisted_for_loops)

    term = sort_ac_collections(term)

    print(printer.pretty_print(constraint))

    execute_functions(
        term,
        constraint,
        functions,
        blacklisted_functions,
        specs,
        identifiers,
        printer,
        json_dir,
        summaries_dir,
        main_definition_dir,
        execution_decision,
    )


def main(args: List[str]) -> None:
    if len(args) != 1:
        print('Usage:')
        print('  python3 -m kmxwasm.proofs <sample-no-extension>')
        sys.exit(-1)
    sample_name = args[0]
    sample_path = ROOT / 'kmxwasm' / 'samples' / f'{sample_name}.wat'
    if not sample_path.exists():
        print(f'Input file ({sample_path}) does not exit.')
    blacklist = {'multisig-full': {'78'}}
    loop_whitelist = {'sum-to-n': {'13'}}
    try:
        run_for_input(
            sample_path, sample_name, blacklist.get(sample_name, set()), loop_whitelist.get(sample_name, set())
        )
    except KoreClientError as e:
        print(e)
        raise
    # run_for_input(samples / 'multisig-full.wat', 'multisig-full', {'78'})
    # run_for_input(samples / 'sum-to-n.wat', 'sum-to-n', set())
    return


"""
Python debugging of RPC responses:

import kmxwasm.proofs as proofs
from pathlib import Path
from pyk.ktool.kprint import KPrint
from pyk.kore.syntax import Pattern

# contract = 'multisig-full'
contract = 'sum-to-n'
my_kprint = KPrint(proofs.DEFINITION_PARENT / contract / proofs.DEFINITION_NAME)

-------------

d = proofs.load_json_dict(c.DEBUG_DIR / 'response.log')

d['result']['state']['term']['term']['args'][0]['args'][1]['args'][7]['args'][4]['args'][0]['args'][1]['args'][3]['args'][0]['value'] = '...removed-memory...'

kore = Pattern.from_dict(d['result']['state']['term']['term'])
pretty = my_kprint.kore_to_pretty(kore)
print(pretty)


----------------


term = proofs.load_json(proofs.JSON_DIR / contract / 'bytes.json')
print(my_kprint.pretty_print(term))

"""


if __name__ == '__main__':
    main(sys.argv[1:])
