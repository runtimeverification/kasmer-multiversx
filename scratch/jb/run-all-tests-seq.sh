#!/bin/bash

set -e -o pipefail

#################### Environment ############
LOGS_DIR="$(readlink -f "${LOGS_DIR:-$MAIN_DIR/logs}")"

# extra options for booster
export KORE_RPC_OPTS=${KORE_RPC_OPTS:-"--print-stats"}
export GHCRTS=${GHCRTS:-"-M25G"}

set -u

export ROOT=$(git rev-parse --show-toplevel)
export CLAIM_DIR="$ROOT/kmxwasm/src/tests/integration/data"
export MAIN_DIR="$ROOT/kmxwasm"

BOOSTER=$(which kore-rpc-booster)
echo "Using $BOOSTER"

# Actual runner. $1 is the claim name, e.g. test_add_liquidity-spec.json
function run_claim {

set +x
BOOSTER=$(which kore-rpc-booster)
echo "Running claim $1 with server $BOOSTER, options ${KORE_RPC_OPTS} +RTS ${GHCRTS}"

NAME=$1

CLAIM="$CLAIM_DIR/$NAME"
SAVE_DIR="${LOGS_DIR}/save/kcfg.$NAME"

[ -f "$CLAIM" ] || (echo "$CLAIM: File not found"; exit 2)

mkdir -p "$LOGS_DIR"
mkdir -p "$SAVE_DIR"

cd "$MAIN_DIR"

set -x
poetry run kmxwasm-property \
    --claim "$CLAIM" --kcfg "$SAVE_DIR" \
    --booster \
    --bug-report "${LOGS_DIR}/${NAME}.report" \
    > "$LOGS_DIR/${NAME}.log" 2>&1
}

#################### main ####################

TIMEOUT=""
PARALLEL="0"
TEST_CLAIMS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --timeout)
            TIMEOUT="timeout -s 2 $2"
            shift 2
            ;;
        --sequential)
            PARALLEL="no"
            shift
            ;;
        --parallel)
            PARALLEL=$2
            shift 2
            ;;
        --from)
            TEST_CLAIMS+=" $(sed -e 's/#.*$//' -e '/^ *$/d' $2) "
            shift 2
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            TEST_CLAIMS+=" $1 "
            shift
            ;;
    esac
done

if [ -z "$TEST_CLAIMS" ]; then
    TEST_CLAIMS=$(cd ${CLAIM_DIR} && ls test*.json)
fi


set -x
make kmxwasm
make build

export -f run_claim

if [[ "${PARALLEL}" = "no" ]]; then
    for claim in ${TEST_CLAIMS}; do
        $TIMEOUT run_claim "$claim"
    done
else
    printf "%s\n" ${TEST_CLAIMS} | xargs -t -I {} -P $PARALLEL bash -c "run_claim {}"
    wait
fi
