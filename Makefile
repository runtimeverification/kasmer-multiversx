K_OPTS     := -Xmx12288m
POETRY     := poetry -C kmxwasm
POETRY_RUN := $(POETRY) run


.PHONY: default
default: build

.PHONY: plugin-deps
plugin-deps:
	$(MAKE) -C deps/mx-semantics plugin-deps

.PHONY: kmxwasm
kmxwasm:
	$(POETRY) install

.PHONY: build
build: kmxwasm
	K_OPTS='$(K_OPTS)' $(POETRY) run kdist -v build mxwasm-semantics.\* -j4
