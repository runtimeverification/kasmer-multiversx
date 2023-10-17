<open kmxwasm/k-src/elrond-semantics>

# Init

kbuild kompile haskell
kbuild kompile llvm
kbuild kompile haskell-kasmer
kbuild kompile llvm-kasmer
poetry -C kmultiversx install

# Demos

## Adder concrete

mxpy contract build --path "deps/mx-sdk-rs/contracts/examples/adder" --wasm-symbols
mxpy contract build --path "tests/contracts/test_adder" --wasm-symbols

poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder"
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_fail"
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_magic"

## Adder property

poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_magic" --gen-claims
poetry -C kmxwasm run -- python3 -m kmxwasm.property --claim kmxwasm/k-src/elrond-semantics/generated_claims/test_call_add_magic-spec.json --kcfg=.property/kcfg.test_call_add_magic.json --restart

# Build contracts

mxpy contract build --path "deps/mx-sdk-rs/contracts/examples/adder" --wasm-symbols

mxpy contract build --path "tests/contracts/test_adder" --wasm-symbols
mxpy contract build --path "tests/contracts/test_adder_concrete" --wasm-symbols
mxpy contract build --path "tests/contracts/test_adder_fail" --wasm-symbols

mxpy contract build --path "tests/contracts/magic_adder" --wasm-symbols
mxpy contract build --path "tests/contracts/test_adder_magic" --wasm-symbols

# mxpy contract build --path "tests/contracts/foundrylike" --wasm-symbols
# poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/foundrylike"

poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_concrete"
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder"
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_fail"
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_magic"

poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_concrete" --gen-claims
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder" --gen-claims
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_fail" --gen-claims
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_magic" --gen-claims

poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_concrete" --gen-claims --pretty
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder" --gen-claims --pretty
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_fail" --gen-claims --pretty
poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-kasmer) --directory "tests/contracts/test_adder_magic" --gen-claims --pretty

# Verification

time
poetry -C kmxwasm run -- python3 -m kmxwasm.property \
    --claim kmxwasm/k-src/elrond-semantics/generated_claims/test_call_add-spec.json \
    --kcfg=.property/kcfg.test_call_add.json 2>&1 | tee .property/test_call_add.log

time
poetry -C kmxwasm run -- python3 -m kmxwasm.property \
    --claim kmxwasm/k-src/elrond-semantics/generated_claims/test_call_add_concrete-spec.json \
    --kcfg=.property/kcfg.test_call_add_concrete.json 2>&1 | tee .property/test_call_add_concrete.log

time
poetry -C kmxwasm run -- python3 -m kmxwasm.property \
    --claim kmxwasm/k-src/elrond-semantics/generated_claims/test_call_add_fail-spec.json \
    --kcfg=.property/kcfg.test_call_add_fail.json 2>&1 | tee .property/test_call_add_fail.log

time
poetry -C kmxwasm run -- python3 -m kmxwasm.property \
    --claim kmxwasm/k-src/elrond-semantics/generated_claims/test_call_add_magic-spec.json \
    --kcfg=.property/kcfg.test_call_add_magic.json --restart 2>&1 | tee .property/test_call_add_magic.log

time
poetry -C kmxwasm run -- python3 -m kmxwasm.property \
    --claim kmxwasm/k-src/elrond-semantics/generated_claims/test_call_add_twice-spec.json \
    --kcfg=.property/kcfg.test_call_add_twice.json 2>&1 | tee .property/test_call_add_twice.log

time
poetry -C kmxwasm run -- python3 -m kmxwasm.property \
    --claim kmxwasm/k-src/elrond-semantics/generated_claims/test_call_add_twice_concrete-spec.json \
    --kcfg=.property/kcfg.test_call_add_twice_concrete.json 2>&1 | tee .property/test_call_add_twice_concrete.log
