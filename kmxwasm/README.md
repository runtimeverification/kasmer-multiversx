# kmxwasm


## Installation

Prerequsites: `python 3.8.*`, `pip >= 20.0.2`, `poetry >= 1.3.2`.

```bash
make build
pip install dist/*.whl
```


# Running

The `kmxwasm/samples` directory already contains some compiled contracts
that you can use if you want to test the script. Note that the `multisig`
contract currently stops with an error at some point.

## Preparing a contract for running.

In order to run the summarizer on a contract, first compile that contract to
wasm. The command should look something like this:
```bash
mxpy contract build multisig --wasm-symbols --no-wasm-opt
```

Next, go to the output directory and transform the wasm to wat:
```bash
cd multisig/output
wasm2wat multisig-full.wasm > multisig-full.wat
```

Then take the produced .wat file and copy it to the `kmxwasm/samples` directory.

If the contract has loops, you may want to create some claims that summarize
those loops, see e.g., `kmxwasm/samples/sum-to-n/sum-to-n-spec.k`. You also
need to write a `.deps` file with the same name as the spec
(e.g. `kmxwasm/samples/sum-to-n/sum-to-n-spec.deps`) listing the functions that
need to be summarized before running the claim, separated by commas. You can
leave this file empty if no function is needed.


## Running

Setup:

```bash
cd kmxwasm
poetry install
```

Running, this is an example for the multisig contract:

```bash
poetry run python3 -m kmxwasm.proofs multisig-full
```

You may find it useful to append something like
` 2>&1 | tee ../.build/multisig-full.log` to the command above
in order to debug, since the output is usually fairly large.


## For Developers

Use `make` to run common tasks (see the [Makefile](Makefile) for a complete list of available targets).

* `make build`: Build wheel
* `make check`: Check code style
* `make format`: Format code
* `make test-unit`: Run unit tests

For interactive use, spawn a shell with `poetry shell` (after `poetry install`), then run an interpreter.
