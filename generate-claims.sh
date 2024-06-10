#!/usr/bin/env bash

set -e -o pipefail

poetry -C kmxwasm install

make build-kasmer

# Adder

sc-meta all build --path deps/mx-sdk-rs/contracts/examples/adder --wasm-symbols --no-wasm-opt
sc-meta all build --path tests/contracts/foundrylike --wasm-symbols --no-wasm-opt
poetry -C kmxwasm run -- kasmerx -C tests/contracts/foundrylike build 2>&1 | tee kasmer.log
wasm2wat deps/mx-sdk-rs/contracts/examples/adder/output/adder.wasm \
         -o tests/contracts/foundrylike/generated_claims/w-adder.wat
wasm2wat tests/contracts/foundrylike/output/foundrylike.wasm \
         -o tests/contracts/foundrylike/generated_claims/w-foundrylike.wat

# Coindrip

for f in $(find deps/coindrip-protocol-sc/ -name 'Cargo.toml')
do
  cat $f | sed 's/0.39.2/0.50.3/'  | sed 's/0.47.4/0.50.3/' > tmp.rs
  mv tmp.rs $f
done
sc-meta all build --path deps/coindrip-protocol-sc --wasm-symbols --no-wasm-opt
sc-meta all build --path tests/contracts/test_coindrip --wasm-symbols --no-wasm-opt
poetry -C kmxwasm run -- kasmerx -C tests/contracts/test_coindrip build 2>&1 | tee kasmer.log
wasm2wat deps/coindrip-protocol-sc/output/coindrip.wasm -o tests/contracts/test_coindrip/generated_claims/w-coindrip.wat
wasm2wat tests/contracts/test_coindrip/output/test_coindrip.wasm \
         -o tests/contracts/test_coindrip/generated_claims/w-test_coindrip.wat

# Crowdfunding

sc-meta all build --path deps/mx-sdk-rs/contracts/examples/crowdfunding-esdt --wasm-symbols --no-wasm-opt
sc-meta all build --path tests/contracts/test_crowdfunding-esdt --wasm-symbols --no-wasm-opt
poetry -C kmxwasm run -- kasmerx -C tests/contracts/test_crowdfunding-esdt build 2>&1 | tee kasmer.log
wasm2wat deps/mx-sdk-rs/contracts/examples/crowdfunding-esdt/output/crowdfunding-esdt.wasm \
         -o tests/contracts/test_crowdfunding-esdt/generated_claims/w-crowdfunding-esdt.wat
wasm2wat tests/contracts/test_crowdfunding-esdt/output/test_crowdfunding-esdt.wasm \
         -o tests/contracts/test_crowdfunding-esdt/generated_claims/w-test_crowdfunding-esdt.wat

# Pair

sc-meta all build --path deps/mx-exchange-sc/dex/pair --wasm-symbols --no-wasm-opt
sc-meta all build --path tests/contracts/test_pair --wasm-symbols --no-wasm-opt
poetry -C kmxwasm run -- kasmerx -C tests/contracts/test_pair build 2>&1 | tee kasmer.log
wasm2wat deps/mx-exchange-sc/dex/pair/output/pair.wasm -o tests/contracts/test_pair/generated_claims/w-pair.wat
wasm2wat tests/contracts/test_pair/output/test_pair.wasm -o tests/contracts/test_pair/generated_claims/w-test_pair.wat

# Multisig

sc-meta all build --path deps/mx-sdk-rs/contracts/examples/multisig --wasm-symbols --no-wasm-opt
sc-meta all build --path tests/contracts/test_multisig --wasm-symbols --no-wasm-opt
poetry -C kmxwasm run -- kasmerx -C tests/contracts/test_multisig build 2>&1 | tee kasmer.log
wasm2wat deps/mx-sdk-rs/contracts/examples/multisig/output/multisig.wasm \
         -o tests/contracts/test_multisig/generated_claims/w-multisig.wat
wasm2wat tests/contracts/test_multisig/output/test_multisig.wasm \
         -o tests/contracts/test_multisig/generated_claims/w-test_multisig.wat
