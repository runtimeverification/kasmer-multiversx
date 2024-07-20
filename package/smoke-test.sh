#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_DIR=$(dirname "$0")
TEST_DIR=${SCRIPT_DIR}/../tests/contracts/test_adder_passing

cd ${TEST_DIR}
kasmer build
kasmer fuzz
kasmer verify test_call_add --booster --bug-report report
