import sys
from typing import Final

import pytest
from pyk.kast.inner import KApply, KInner, KRewrite, KSequence, KVariable
from pyk.kast.outer import KClaim
from pyk.prelude.bytes import bytesToken
from pyk.prelude.collections import list_empty, map_empty, map_of, set_empty
from pyk.prelude.kbool import FALSE, TRUE
from pyk.prelude.kint import intToken
from pyk.prelude.string import stringToken

from kmxwasm.ast.configuration import wrap_with_generated_top_if_needed
from kmxwasm.ast.mx import accountCellMap, bytesStack, directCall, listAsyncCall, listBytes
from kmxwasm.ast.wasm import (
    elemInstCellMap,
    funcDefCellMap,
    globalInstCellMap,
    memInstCellMap,
    moduleInstCellMap,
    optionalInt_empty,
    tabInstCellMap,
    valStack,
)
from kmxwasm.property_testing.running import RunException, Success, run_claim
from kmxwasm.property_testing.wasm_krun_initializer import WasmKrunInitializer
from kmxwasm.testing.fixtures import Tools

sys.setrecursionlimit(1500000000)


def wasmCell() -> KInner:  # noqa: N802
    return KApply(
        '<wasm>',
        (
            KApply('<instrs>', KSequence()),
            KApply('<valstack>', valStack([])),
            KApply('<curFrame>', (KApply('<locals>', map_empty()), KApply('<curModIdx>', optionalInt_empty()))),
            KApply('<moduleRegistry>', map_empty()),
            KApply('<moduleIds>', map_empty()),
            KApply('<moduleInstances>', moduleInstCellMap([])),
            KApply('<nextModuleIdx>', intToken(0)),
            KApply(
                '<mainStore>',
                (
                    KApply('<funcs>', funcDefCellMap([])),
                    KApply('<nextFuncAddr>', intToken(0)),
                    KApply('<tabs>', tabInstCellMap([])),
                    KApply('<nextTabAddr>', intToken(0)),
                    KApply('<mems>', memInstCellMap([])),
                    KApply('<nextMemAddr>', intToken(0)),
                    KApply('<globals>', globalInstCellMap([])),
                    KApply('<nextGlobAddr>', intToken(0)),
                    KApply('<elems>', elemInstCellMap([])),
                    KApply('<nextElemAddr>', intToken(0)),
                ),
            ),
            KApply('<deterministicMemoryGrowth>', TRUE),
        ),
    )


def callStateCell() -> KInner:  # noqa: N802
    return KApply(
        '<callState>',
        (
            KApply('<callee>', bytesToken(b'')),
            KApply('<function>', stringToken('')),
            KApply(
                '<vmInput>',
                (
                    KApply('<caller>', bytesToken(b'')),
                    KApply('<callArgs>', listBytes([])),
                    KApply('<callValue>', intToken(0)),
                    KApply('<callType>', directCall()),
                    KApply('<esdtTransfers>', list_empty()),
                    KApply('<gasProvided>', intToken(0)),
                    KApply('<gasPrice>', intToken(0)),
                    KApply('<txHash>', bytesToken(b'')),
                ),
            ),
            wasmCell(),
            KApply('<bigIntHeap>', map_empty()),
            KApply('<bufferHeap>', map_empty()),
            KApply('<bytesStack>', bytesStack([])),
            KApply('<contractModIdx>', optionalInt_empty()),
            KApply('<asyncCalls>', listAsyncCall([])),
            KApply('<out>', listBytes([])),
            KApply('<logs>', list_empty()),
            KApply('<outputAccounts>', map_empty()),
        ),
    )


def nodeCell(vm_output: KInner, accounts: list[KInner]) -> KInner:  # noqa: N802
    zero_random_seed = b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'
    return KApply(
        '<node>',
        (
            KApply('<commands>', KSequence()),
            callStateCell(),
            KApply('<callStack>', list_empty()),
            KApply('<interimStates>', list_empty()),
            KApply('<vmOutput>', vm_output),
            KApply('<accounts>', accountCellMap(accounts)),
            KApply(
                '<previousBlockInfo>',
                (
                    KApply('<prevBlockTimestamp>', intToken(0)),
                    KApply('<prevBlockNonce>', intToken(0)),
                    KApply('<prevBlockRound>', intToken(0)),
                    KApply('<prevBlockEpoch>', intToken(0)),
                    KApply('<prevBlockRandomSeed>', bytesToken(zero_random_seed)),
                ),
            ),
            KApply(
                '<currentBlockInfo>',
                (
                    KApply('<curBlockTimestamp>', intToken(0)),
                    KApply('<curBlockNonce>', intToken(0)),
                    KApply('<curBlockRound>', intToken(0)),
                    KApply('<curBlockEpoch>', intToken(0)),
                    KApply('<curBlockRandomSeed>', bytesToken(zero_random_seed)),
                ),
            ),
        ),
    )


def configCell(  # noqa: N802
    k_cell: KInner, vm_output: KInner, addresses: dict[KInner, KInner], accounts: list[KInner], logging: KVariable
) -> KInner:
    return KApply(
        '<kasmer>',
        (
            KApply(
                '<mandos>',
                (
                    KApply('<k>', (k_cell,)),
                    KApply('<newAddresses>', map_of(addresses)),
                    KApply('<checkedAccounts>', set_empty()),
                    KApply(
                        '<elrond>', (nodeCell(vm_output=vm_output, accounts=accounts), KApply('<logging>', logging))
                    ),
                    KApply('<txCount>', intToken(0)),
                    KApply('<exit-code>', intToken(0)),
                ),
            ),
            KApply('<wasmStore>', map_empty()),
            KApply('<prank>', FALSE),
        ),
    )


def full_configuration(
    k_cell: KInner, vm_output: KInner, addresses: dict[KInner, KInner], accounts: list[KInner], logging: KVariable
) -> KInner:
    return wrap_with_generated_top_if_needed(
        configCell(k_cell=k_cell, vm_output=vm_output, addresses=addresses, accounts=accounts, logging=logging),
        counter=KVariable('GeneratedCounter'),
    )


SIMPLE_PROOFS_DATA: Final = (
    (
        'simple transaction',
        KClaim(
            body=KRewrite(
                full_configuration(
                    k_cell=KSequence(KApply('checkExpectStatus', KApply('OK', ()))),
                    vm_output=KApply(
                        'VMOutput', (KApply('OK'), bytesToken(b''), listBytes([]), list_empty(), map_empty())
                    ),
                    addresses={},
                    accounts=[],
                    logging=KVariable('Logging'),
                ),
                full_configuration(
                    k_cell=KSequence(),
                    vm_output=KApply(
                        'VMOutput', (KApply('OK'), bytesToken(b''), listBytes([]), list_empty(), map_empty())
                    ),
                    addresses={},
                    accounts=[],
                    logging=KVariable('Logging2'),
                ),
            ),
            requires=TRUE,
            ensures=TRUE,
        ),
        True,
    ),
    (
        'simple transaction fail',
        KClaim(
            body=KRewrite(
                full_configuration(
                    k_cell=KSequence(KApply('checkExpectStatus', KApply('ExecutionFailed'))),
                    vm_output=KApply(
                        'VMOutput', (KApply('OK'), bytesToken(b''), listBytes([]), list_empty(), map_empty())
                    ),
                    addresses={},
                    accounts=[],
                    logging=KVariable('Logging'),
                ),
                full_configuration(
                    k_cell=KSequence(),
                    vm_output=KApply(
                        'VMOutput', (KApply('OK'), bytesToken(b''), listBytes([]), list_empty(), map_empty())
                    ),
                    addresses={},
                    accounts=[],
                    logging=KVariable('Logging2'),
                ),
            ),
            requires=TRUE,
            ensures=TRUE,
        ),
        False,
    ),
)


class TestSimpleProofs:
    @pytest.mark.parametrize(
        'test_id,claim,success',
        SIMPLE_PROOFS_DATA,
        ids=[test_id for test_id, *_ in SIMPLE_PROOFS_DATA],
    )
    def test_run_claim(self, tools: Tools, test_id: str, claim: KClaim, success: bool) -> None:
        result = run_claim(
            tools,
            WasmKrunInitializer(tools),
            claim,
            restart_kcfg=None,
            kcfg_path=None,
            run_id=None,
            depth=1000,
            iterations=10000,
        )
        if isinstance(result, RunException) and success:
            raise result.exception
        assert isinstance(result, Success) == success
