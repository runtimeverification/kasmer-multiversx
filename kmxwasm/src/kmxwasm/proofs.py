#!/usr/bin/env python3

import json
import operator
import subprocess
import sys
import tempfile
from contextlib import closing
from dataclasses import dataclass
from pathlib import Path
from socket import AF_INET, SO_REUSEADDR, SOCK_STREAM, SOL_SOCKET, socket
from typing import Any, Dict, Iterable, List, Mapping, Optional, Set, Tuple

from pyk.cli_utils import BugReport
from pyk.cterm import CTerm
from pyk.kast.inner import KApply, KInner, KLabel, KRewrite, KSequence, KSort, KToken, KVariable, bottom_up
from pyk.kast.manip import ml_pred_to_bool, push_down_rewrites
from pyk.kast.outer import (
    KAtt,
    KClaim,
    KDefinition,
    KFlatModule,
    KImport,
    KProduction,
    KRequire,
    KRule,
    KSentence,
    KTerminal,
)
from pyk.kcfg import KCFG, KCFGExplore
from pyk.ktool.kprint import KPrint, SymbolTable
from pyk.ktool.kprove import KProve
from pyk.ktool.krun import KRunOutput, _krun
from pyk.prelude.bytes import BYTES, bytesToken
from pyk.prelude.k import GENERATED_TOP_CELL, K
from pyk.prelude.kbool import TRUE, andBool
from pyk.prelude.kint import INT, intToken, leInt, ltInt
from pyk.prelude.ml import mlAnd, mlTop

from . import execution, wasm_types
from .functions import (
    Functions,
    WasmFunction,
    find_functions,
    remove_all_function_id_to_addrs_but_one_and_builtins,
    remove_all_functions_but_one_and_builtins,
)
from .kast import extract_rewrite_parents, find_term, get_inner, kinner_top_down_fold, replace_child, replace_term
from .wasm_types import ValType

sys.setrecursionlimit(4000)

ROOT = Path(subprocess.check_output(['git', 'rev-parse', '--show-toplevel']).decode().strip())
K_DIR = ROOT / 'kmxwasm' / 'k-src'
BUILD_DIR = ROOT / '.build'
DEFINITION_PARENT = BUILD_DIR / 'defn/haskell'
DEFINITION_DIR = DEFINITION_PARENT / 'elrond-wasm-kompiled'
DATA_DIR = BUILD_DIR / 'data'
JSON_DIR = DATA_DIR / 'json'
DEBUG_DIR = BUILD_DIR / 'debug'
SUMMARIES_DIR = DATA_DIR / 'summaries'
WASM_DIR = K_DIR / 'wasm-semantics'
DEFAULT_SUMMARIES_DIR = K_DIR / 'summaries'
MACRO_CELLS = {
    # <moduleInstances> needs MyExports as an argument
    # '<moduleInstances>' : 'moduleInstancesMacro',
    '<tabs>': 'tabsMacro',
}

GENERATED_RULE_PRIORITY = 20
MAP = KSort('Map')

# Setting this disables compilation.
DEBUG_ID = ''  #'ca3493ec081b72857fe96a8b6d3b3f969505e6bc09d91d16eaff9995f2c551ad'


@dataclass(frozen=True)
class Identifiers:
    sort_to_ids: Mapping[KSort, Set[KToken]]


class MyKPrint(KPrint):
    def __init__(
        self,
        definition_dir: Path,
        use_directory: Optional[Path] = None,
        bug_report: Optional[BugReport] = None,
        extra_unparsing_modules: Iterable[KFlatModule] = (),
    ) -> None:
        super().__init__(definition_dir, use_directory, bug_report, extra_unparsing_modules)

    @classmethod
    def _patch_symbol_table(cls, symbol_table: SymbolTable) -> None:
        symbol_table['_|->_'] = lambda c1, c2: f'({c1} |-> {c2})'
        symbol_table['_Map_'] = lambda c1, c2: f'({c1} {c2})'
        symbol_table['.TabInstCellMap'] = lambda: '.Bag'


class RuleCreator:
    def __init__(self, definition: KDefinition) -> None:
        self.__macros: Dict[str, Tuple[str, KInner]] = {}
        self.__macro_rules: List[KSentence] = []
        self.__rules: List[KRule] = []
        self.__definition = definition

    def add_rule(self, lhs_id: str, rhs_id: str, kcfg: KCFG) -> None:
        lhs_cterm = kcfg.node(lhs_id).cterm
        rhs_cterm = kcfg.node(rhs_id).cterm
        if not self.__macro_rules:
            self.__initialize_macros(lhs_cterm.config)

        lhs = self.__replace_macros(lhs_cterm.config)
        # TODO: This is WRONG, should find a better way to solve the speed issue.
        #
        # These rules are valid summarizations only for a very specific <funcs> cell.
        # Replacing its contents with a variable means that we are claiming
        # that the rule should apply regardless of the contents of the cell.
        # This rule works properly in the context in which we are currently
        # using it, but this is rather fragile.
        #
        # This also applies to the <funcAddrs> cell.
        lhs = replace_term(lhs, '<funcs>', KVariable('MyFuncs'))
        lhs = replace_term(lhs, '<funcAddrs>', KVariable('MyFuncAddrs'))
        # lhs = replace_term(lhs, '<funcIds>', KVariable('MyFuncIds'))

        rhs = self.__replace_macros(rhs_cterm.config)
        # TODO: This is WRONG, should find a better way to solve the speed issue.
        # See the similar comment above.
        rhs = replace_term(rhs, '<funcs>', KVariable('MyFuncs'))
        rhs = replace_term(rhs, '<funcAddrs>', KVariable('MyFuncAddrs'))
        # rhs = replace_term(rhs, '<funcIds>', KVariable('MyFuncIds'))
        self.__rules.append(make_final_rule_new(lhs, lhs_cterm.constraints, rhs, rhs_cterm.constraints))

    def __initialize_macros(self, config: KInner) -> None:
        for cell, macro_name in MACRO_CELLS.items():
            child = find_term(config, cell)
            assert child is not None
            self.__macros[cell] = (macro_name, child)
            self.__add_macro_rules(macro_name, child)

    def __replace_macros(self, config: KInner) -> KInner:
        for cell, macro_name in MACRO_CELLS.items():
            _macro_name, macro_value = self.__macros[cell]
            child = find_term(config, cell)
            assert child == macro_value
            config = replace_term(config, cell, KApply(macro_name))
        return config

    def __add_macro_rules(self, name: str, term: KInner) -> None:
        assert isinstance(term, KApply)
        self.__macro_rules.append(
            KProduction(
                sort=self.__definition.return_sort(term.label),
                items=[KTerminal(name), KTerminal('('), KTerminal(')')],
                att=KAtt({'macro': ''}),
            )
        )
        self.__macro_rules.append(KRule(body=KRewrite(KApply(name), term)))

    def macro_rules(self) -> List[KSentence]:
        return self.__macro_rules

    def summarize_rules(self) -> List[KRule]:
        return self.__rules


class LazyExplorer:
    def __init__(self, rules: RuleCreator, identifiers: Identifiers, data_folder: Path, printer: KPrint) -> None:
        self.__rules = rules
        self.__identifiers = identifiers
        self.__summary_folder = data_folder
        self.__printer = printer
        self.__explorer: Optional[KCFGExplore] = None

    def __enter__(self) -> 'LazyExplorer':
        return self

    def __exit__(self, *_args: Any) -> None:
        self.close()

    def close(self) -> None:
        if self.__explorer:
            self.__explorer.close()

    def get(self) -> KCFGExplore:
        if self.__explorer is None:
            if not DEBUG_ID:
                self.__make_semantics()
            temp_dir = tempfile.TemporaryDirectory(prefix='kprove')
            kprove = make_kprove(temp_dir)
            self.__explorer = make_explorer(kprove)
        return self.__explorer

    def printer(self) -> KPrint:
        return self.__printer

    def __make_semantics(self) -> None:
        identifier_sentences = [
            KProduction(sort=sort, items=[KTerminal(token.token)], att=KAtt({'token': ''}))
            for sort, tokens in self.__identifiers.sort_to_ids.items()
            for token in tokens
        ]
        identifiers_module = KFlatModule('IDENTIFIERS', sentences=identifier_sentences)

        ims = [KImport('ELROND-IMPL'), KImport('IDENTIFIERS')]
        macros_module = KFlatModule('SUMMARY-MACROS', sentences=self.__rules.macro_rules(), imports=ims)

        req1 = KRequire('elrond-impl.md')
        req2 = KRequire('elrond-wasm-configuration.md')
        ims.append(KImport('ELROND-WASM-CONFIGURATION'))
        ims.append(KImport('SUMMARY-MACROS'))
        # TODO: pyk now supports sending a module of claims when proving.
        # Investigate using that. One possible problem: When executing
        # step-by-step, the Haskell backend might or might not be able to
        # figure out whether a specific rpc we send is the forst step or not,
        # and claims should not be applied at the first step.
        summaries_module = KFlatModule('SUMMARIES', sentences=self.__rules.summarize_rules(), imports=ims)

        definition = KDefinition(
            'SUMMARIES', all_modules=[summaries_module, identifiers_module, macros_module], requires=[req1, req2]
        )

        definition_text = self.__printer.pretty_print(definition)
        # definition_text = definition_text.replace('$', '$#')

        self.__summary_folder.mkdir(parents=True, exist_ok=True)
        (self.__summary_folder / 'summaries.k').write_text(definition_text)

        kompile_semantics(self.__summary_folder)


def kompile_semantics(summary_folder: Optional[Path]) -> None:
    result = subprocess.run(['rm', '-r', DEFINITION_DIR])
    # TODO: Surely there is a better way to fo this with pyk.
    args = [
        'kompile',
        '--backend',
        'haskell',
        '--md-selector',
        'k',
        '--emit-json',
        '-I',
        str(summary_folder) if summary_folder else str(DEFAULT_SUMMARIES_DIR),
        '-I',
        str(K_DIR),
        '-I',
        str(WASM_DIR),
        '--directory',
        str(DEFINITION_PARENT),
        '--main-module',
        'ELROND-WASM',
        '--syntax-module',
        'ELROND-WASM-SYNTAX',
        str(K_DIR / 'elrond-wasm.md'),
    ]
    print('Running:', ' '.join(args), flush=True)
    result = subprocess.run(args)
    assert result.returncode == 0


SET_BYTES_RANGE = '#setBytesRange(_,_,_)_WASM-DATA_Bytes_Bytes_Int_Bytes'
DOT_BYTES = '.Bytes_BYTES-HOOKED_Bytes'


def bytes_to_string(b: str) -> str:
    assert b.startswith('b"')
    assert b.endswith('"')

    b = b[2:-1]
    return b


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
        new_term = KApply(SET_BYTES_RANGE, (new_term, KToken(str(start), INT), bytesToken(bytes[start:end])))
    return new_term


def filter_bytes_callback(term: KInner) -> KInner:
    if isinstance(term, KToken):
        if term.sort == BYTES:
            term = filter_bytes(term)
            s = str(term)
            pos = s.find(('\\x00' * 100))
            pos -= 100
            if pos < 0:
                pos = 0
            return term
    return term


def compute_bytes(term: KInner) -> KToken:
    if isinstance(term, KToken):
        assert term.sort == BYTES, term
        return term
    assert isinstance(term, KApply)
    if term.label.name == DOT_BYTES:
        return bytesToken('')
    assert term.label.name == SET_BYTES_RANGE, term
    assert len(term.args) == 3, term
    (inner, start, token) = term.args

    inner = compute_bytes(inner)
    assert inner.sort == BYTES, inner
    inner_str = bytes_to_string(inner.token)

    assert isinstance(start, KToken), start
    assert start.sort == INT
    start_int = int(start.token)

    assert isinstance(token, KToken), token
    assert token.sort == BYTES, token
    token_str = bytes_to_string(token.token)

    if len(inner_str) < start_int + len(token_str):
        inner_str += '\x00' * (start_int + len(token_str) - len(inner_str))
    inner_str = inner_str[:start_int] + token_str + inner_str[start_int + len(token_str) :]

    return bytesToken(inner_str)


def unpack_bytes_callback(term: KInner) -> KInner:
    if isinstance(term, KApply):
        if term.label.name == SET_BYTES_RANGE:
            return compute_bytes(term)
    return term


def print_kore_cfg(node_id: str, kcfg: KCFG, printer: KPrint) -> None:
    cterm = kcfg.node(node_id).cterm
    kore = printer.kast_to_kore(cterm.config)
    print(printer.kore_to_pretty(kore))
    for constraint in cterm.constraints:
        kore = printer.kast_to_kore(constraint)
        print(printer.kore_to_pretty(kore))


def krun(input_file: Path, output_file: Path) -> None:
    print('Run', flush=True)
    result = _krun(input_file=input_file, definition_dir=DEFINITION_DIR, output=KRunOutput.JSON)
    output_file.parent.mkdir(parents=True, exist_ok=True)
    output_file.write_text(result.stdout)


def load_json_dict(input_file: Path) -> Mapping[str, Any]:
    print('Load json', flush=True)
    value = input_file.read_text()
    return json.loads(value)


def load_json_krun(input_file: Path) -> KInner:
    value = load_json_dict(input_file)
    return KInner.from_dict(value['term'])


def load_json(input_file: Path) -> KInner:
    value = load_json_dict(input_file)
    return KInner.from_dict(value)


def replace_bytes(term: KInner) -> KInner:
    term = bottom_up(filter_bytes_callback, term)
    return term


def unpack_bytes(term: KInner) -> KInner:
    term = bottom_up(unpack_bytes_callback, term)
    return term


def replace_bytes_c_term(term: CTerm) -> CTerm:
    new_term = replace_bytes(term.config)
    thing = mlAnd([new_term] + list(term.constraints), GENERATED_TOP_CELL)
    return CTerm(thing)


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
            '_:__WASM-DATA_ValStack_Val_ValStack',
            (KApply('<_>__WASM-DATA_IVal_IValType_Int', (make_type(vtype), var)), stack),
        )
    statements = [KApply('aNop'), make_a_call(function.address()), KVariable('MyOtherInstructions', sort=K)]
    call = make_statement_list(statements)
    constraint_list: List[KInner] = [
        make_type_constraint(var, vtype) for var, vtype in zip(variables, argument_types_list, strict=True)
    ]
    constraint = make_balanced_and_bool(constraint_list)
    return (call, stack, constraint)


def has_questionmark_variables(term: KInner) -> bool:
    def maybe_is_questionmark_variable(term: KInner) -> Optional[bool]:
        if not isinstance(term, KVariable):
            return None
        if term.name.startswith('?'):
            return True
        return False

    assert isinstance(term, KInner)
    return kinner_top_down_fold(maybe_is_questionmark_variable, operator.or_, False, term)


def make_rewrite(lhs: KInner, rhs: KInner) -> KInner:
    def make_rewrite_if_needed(left: KInner, right: KInner) -> KInner:
        if left == right:
            return left
        return KRewrite(left, right)

    assert isinstance(lhs, KApply)
    assert isinstance(rhs, KApply)
    assert lhs.arity == rhs.arity, [lhs.arity, lhs.label, rhs.arity, rhs.label]
    assert lhs.label == rhs.label
    rw = lhs.let(args=[make_rewrite_if_needed(l, r) for (l, r) in zip(lhs.args, rhs.args, strict=True)])
    return push_down_rewrites(rw)


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


def build_rewrite_requires_new(
    lhs: KInner, lhs_constraints: Tuple[KInner, ...], rhs: KInner, rhs_constraints: Tuple[KInner, ...]
) -> Tuple[KInner, KInner]:
    lhs_config = unpack_bytes(lhs)
    rhs_config = unpack_bytes(rhs)
    rewrite = make_rewrite(lhs_config, rhs_config)
    rewrite = get_inner(rewrite, 0, '<elrond-wasm>')
    requires = [c for c in lhs_constraints if c != TRUE]
    for c in rhs_constraints:
        if c != TRUE and c not in lhs_constraints and not has_questionmark_variables(c):
            requires.append(c)
    constraint = andBool([ml_pred_to_bool(c) for c in requires])
    return (rewrite, constraint)


def build_rewrite_requires(lhs_id: str, rhs_id: str, kcfg: KCFG) -> Tuple[KInner, KInner]:
    lhs_node = kcfg.node(lhs_id)
    rhs_node = kcfg.node(rhs_id)
    return build_rewrite_requires_new(
        lhs_node.cterm.config, lhs_node.cterm.constraints, rhs_node.cterm.config, rhs_node.cterm.constraints
    )


# It would be tempting to use cterm.build_rule or cterm.build_claim, however,
# we should check first if those, say, remove function definitions from the
# configuration when calling `minimize_rule`. The rule is not valid without
# those.
def make_final_claim(lhs_id: str, rhs_id: str, kcfg: KCFG) -> KClaim:
    (rewrite, constraint) = build_rewrite_requires(lhs_id=lhs_id, rhs_id=rhs_id, kcfg=kcfg)
    return KClaim(body=rewrite, requires=constraint)


# It would be tempting to use cterm.build_rule or cterm.build_claim, however,
# we should check first if those, say, remove function definitions from the
# configuration when calling `minimize_rule`. The rule is not valid without
# those.
def make_final_rule(lhs_id: str, rhs_id: str, kcfg: KCFG) -> KRule:
    (rewrite, constraint) = build_rewrite_requires(lhs_id=lhs_id, rhs_id=rhs_id, kcfg=kcfg)

    att_dict = {'priority': str(GENERATED_RULE_PRIORITY)}
    rule_att = KAtt(atts=att_dict)
    return KRule(body=rewrite, requires=constraint, att=rule_att)


def make_final_rule_new(
    lhs: KInner, lhs_constraints: Tuple[KInner, ...], rhs: KInner, rhs_constraints: Tuple[KInner, ...]
) -> KRule:
    (rewrite, constraint) = build_rewrite_requires_new(lhs, lhs_constraints, rhs, rhs_constraints)

    att_dict = {'priority': str(GENERATED_RULE_PRIORITY)}
    rule_att = KAtt(atts=att_dict)
    return KRule(body=rewrite, requires=constraint, att=rule_att)


def make_kprove(temp_dir: tempfile.TemporaryDirectory) -> KProve:
    return KProve(
        DEFINITION_DIR,
        use_directory=Path(temp_dir.name),
        bug_report=None
        # bug_report=BugReport(Path('bug_report'))
    )


def make_explorer(kprove: KProve) -> KCFGExplore:
    return KCFGExplore(
        kprove,
        39425,
        # free_port_on_host(),
        bug_report=kprove._bug_report,
    )


# Based on: https://stackoverflow.com/a/45690594
# TODO: has an obvious race condition, replace with something better.
def free_port_on_host(host: str = 'localhost') -> int:
    with closing(socket(AF_INET, SOCK_STREAM)) as sock:
        sock.bind((host, 0))
        sock.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
        _, port = sock.getsockname()
    return port


def write_json(term: KInner, output_file: Path) -> None:
    output_file.parent.mkdir(parents=True, exist_ok=True)
    output_file.write_text(json.dumps(term.to_dict()))


def my_step(explorer: LazyExplorer, cfg: KCFG, node_id: str) -> List[str]:
    node = cfg.node(node_id)
    out_edges = cfg.edges(source_id=node.id)
    if len(out_edges) > 0:
        return [edge.target.id for edge in out_edges]
    print('Executing!', flush=True)
    actual_depth, cterm, next_cterms = explorer.get().cterm_execute(node.cterm, depth=1)
    if actual_depth == 0:
        if len(next_cterms) < 2:
            print(explorer.printer().pretty_print(node.cterm.config))
            raise ValueError(
                f'Unable to take {1} steps from node (next={len(next_cterms)}), got {actual_depth} steps: {node.id}'
            )
        next_ids = []
        for next_cterm in next_cterms:
            next_cterm = replace_bytes_c_term(next_cterm)
            new_node = cfg.get_or_create_node(next_cterm)
            cfg.create_edge(node.id, new_node.id, condition=mlTop(), depth=1)
            next_ids.append(new_node.id)
        return next_ids
    if actual_depth != 1:
        write_json(node.cterm.config, DEBUG_DIR / 'stuck.json')
        print('cterm=', cterm)
        print('cterms.len=', len(next_cterms), flush=True)
        raise ValueError(f'Unable to take {1} steps from node, got {actual_depth} steps: {node.id}')
    if len(next_cterms) != 0:
        raise ValueError(f'Unexpected next cterms length {len(next_cterms)}: {node.id}')
    cterm = replace_bytes_c_term(cterm)
    new_node = cfg.get_or_create_node(cterm)
    # TODO: This may be other things than mlTop()
    cfg.create_edge(node.id, new_node.id, condition=mlTop(), depth=1)
    return [new_node.id]


def my_step_logging(explorer: LazyExplorer, kcfg: KCFG, node_id: str, branches: int) -> List[str]:
    prev_cterm = kcfg.node(node_id).cterm
    prev_config = prev_cterm.config
    # prev_config = replace_bytes(prev_config)
    new_node_ids = my_step(explorer=explorer, cfg=kcfg, node_id=node_id)
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
                pretty = explorer.printer().pretty_print(ml_pred_to_bool(c))
                print('requires:', pretty)
                print(explorer.printer().pretty_print(c))
                print(c)
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

        (_rule_creator, claim) = make_claim(hacked_term, constraint, function_addr, functions)
        kcfg = KCFG.from_claim(explorer.printer().definition, claim)

    debug = kcfg.get_node(DEBUG_ID)
    if debug:
        for e in kcfg.edges(source_id=debug.id):
            kcfg.remove_edge(e.source.id, e.target.id)
            kcfg.remove_node(e.target.id)

    try:
        first_node_id = kcfg.get_unique_init().id
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
                elif isinstance(decision, execution.UnimplementedElrondFunction):
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
    identifiers: Identifiers,
    printer: KPrint,
    state_path: Path,
    summaries_path: Path,
    execution_decision: execution.ExecutionManager,
) -> None:
    rules = RuleCreator(printer.definition)
    unprocessed_functions: List[str] = [
        addr for addr in functions.addrs() if not functions.addr_to_function(addr).is_builtin()
    ]
    not_processable: List[str] = []
    processed_functions: List[str] = []
    while unprocessed_functions:
        postponed_functions: List[str] = []
        for function_addr in unprocessed_functions:
            with LazyExplorer(rules, identifiers, summaries_path / function_addr, printer) as explorer:
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
            with LazyExplorer(rules, identifiers, summaries_path / 'final', printer) as explorer:
                explorer.get()
            raise ValueError(
                f'Cannot summarize {unprocessed_functions}, postponed={postponed_functions}, unprocessable={unprocessed_functions}, processed={processed_functions}'
            )
        unprocessed_functions = postponed_functions
    with LazyExplorer(rules, identifiers, summaries_path / 'final', printer) as explorer:
        explorer.get()
    print(
        f'unprocessed={unprocessed_functions}, unprocessable={unprocessed_functions}, processed={processed_functions}'
    )


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
        assert typed_value.label.name == '<_>__WASM-DATA_IVal_IValType_Int', typed_value
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


def run_for_input(input_file: Path, short_name: str) -> None:
    if not DEBUG_ID:
        kompile_semantics(None)

    json_dir = JSON_DIR / short_name
    summaries_dir = SUMMARIES_DIR / short_name
    krun_output_file = json_dir / 'krun.json'
    bytes_output_file = json_dir / 'bytes.json'
    if not bytes_output_file.exists():
        if not krun_output_file.exists():
            krun(input_file, krun_output_file)
        term = load_json_krun(krun_output_file)
        # TODO: Replace the config in the term
        # assert not term.constraints
        # print(term.constraints)
        config = replace_bytes(term)
        write_json(config, bytes_output_file)

    term = load_json(bytes_output_file)
    identifiers = find_identifiers(term)
    functions = find_functions(term)

    # The exports field contains wasm strings that are not serialized properly.
    term = replace_child(term, '<exports>', KVariable('MyExports', sort=MAP))

    # These are not needed and increase the execution + parsing time:
    term = replace_child(term, '<funcIds>', KVariable('MyFuncIds', sort=MAP))

    # Real symbolic inputs
    term = replace_child(term, '<caller>', KVariable('MyCaller', sort=BYTES))
    term = replace_child(term, '<gas>', KVariable('MyGas', sort=INT))
    term = replace_child(term, '<call-value>', KVariable('MyCallValue', sort=INT))
    term = replace_child(term, '<arguments>', KVariable('MyEndpointArguments', sort=KSort('ListBytesw')))
    term = replace_child(term, '<original-tx-hash>', KVariable('MyOriginalTxHash', sort=BYTES))
    term, constraints = replace_globals_with_variables(term)
    constraint = make_balanced_and_bool(constraints)

    printer = MyKPrint(DEFINITION_DIR)
    execution_decision = execution.ExecutionManager(functions)

    execute_functions(term, constraint, functions, identifiers, printer, json_dir, summaries_dir, execution_decision)


def main() -> None:
    samples = ROOT / 'kmxwasm' / 'samples'
    # run_for_input(samples / 'multisig-full.wat', 'multisig-full')
    run_for_input(samples / 'sum-to-n.wat', 'sum-to-n')
    return


"""
Python debugging of RPC responses:

import compress_bytes.compress_bytes as c
from pathlib import Path
from pyk.ktool.kprint import KPrint
from pyk.kore.syntax import Pattern

my_kprint = KPrint(c.DEFINITION_DIR)

d = c.load_json_dict(c.DEBUG_DIR / 'response.log')

d['result']['state']['term']['term']['args'][0]['args'][1]['args'][7]['args'][4]['args'][0]['args'][1]['args'][3]['args'][0]['value'] = '...removed-memory...'

kore = Pattern.from_dict(d['result']['state']['term']['term'])
pretty = my_kprint.kore_to_pretty(kore)
print(pretty)
"""


if __name__ == '__main__':
    main()
