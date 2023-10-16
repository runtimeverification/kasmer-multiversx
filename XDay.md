<open kmxwasm/k-src/elrond-semantics>

# Init

kbuild kompile haskell
kbuild kompile llvm
kbuild kompile haskell-foundry
kbuild kompile llvm-foundry
poetry -C kmultiversx install

# Build contracts

mxpy contract build --path "deps/mx-sdk-rs/contracts/examples/adder" --wasm-symbols
mxpy contract build --path "tests/contracts/foundrylike" --wasm-symbols


poetry -C kmultiversx run -- kasmer --definition-dir $(kbuild which llvm-foundry) --directory "tests/contracts/foundrylike"


