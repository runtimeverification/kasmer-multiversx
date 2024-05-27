K_OPTS     := -Xmx12288m
POETRY     := poetry -C kmxwasm
POETRY_RUN := $(POETRY) run


default: build

.PHONY: plugin-deps
plugin-deps:
	$(MAKE) -C deps/mx-semantics plugin-deps

.PHONY: kmxwasm
kmxwasm:
	$(POETRY) install

build: kmxwasm
	K_OPTS='$(K_OPTS)' $(POETRY) run kdist -v build mxwasm-semantics.\* -j4

build-kasmer: kmxwasm
	K_OPTS='-Xmx8G -Xss512m' $(POETRY) run kdist -v build mx-semantics.llvm-kasmer
