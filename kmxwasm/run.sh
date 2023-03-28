#!/bin/bash

poetry run python3 -m kmxwasm.proofs $1 2>&1 | tee ../.build/$1.log