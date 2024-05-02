#!/bin/bash

# $1 is the claim name, e.g. test_add_liquidity-spec.json

set -e -o pipefail

ROOT=$(git rev-parse --show-toplevel)
CLAIM_DIR="$ROOT/kmxwasm/src/tests/integration/data"
CLAIM="$CLAIM_DIR/$1"
SAVE_DIR="$ROOT/.property/kcfg.$1"
MAIN_DIR="$ROOT/kmxwasm"
LOGS_DIR="$MAIN_DIR/logs"

mkdir -p "$LOGS_DIR"
mkdir -p "$SAVE_DIR"

cd "$MAIN_DIR"

poetry install

K_OPTS=-Xmx12288m time poetry run kdist build mxwasm-semantics.{llvm,llvm-library,haskell} -j3

time poetry run python3 -m src.kmxwasm.property \
    --claim "$CLAIM" --kcfg "$SAVE_DIR" \
    --booster \
    --bug-report "$1.report"
    2>&1 | tee > "$LOGS_DIR/$1.log"
