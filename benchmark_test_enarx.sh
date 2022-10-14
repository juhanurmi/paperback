#!/bin/bash
#
#/sys/devices/system/cpu/intel_pstate/no_turbo
#--> change 0 to 1
#
#/sys/devices/system/cpu/intel_pstate/status
#--> change passive to off
#
set -e # Exit if any command fails

WASMBINARY="./target/wasm32-wasi/release/paperback.wasm"
ENARX="/usr/bin/enarx"
ENARXTOML="./Enarx.toml"

if [ ! -f "$WASMBINARY" ]; then
    echo "$WASMBINARY does not exist."
    exit 1
fi

if [ ! -f "$ENARX" ]; then
    echo "$ENARX does not exist."
    exit 1
fi

if [ ! -f "$ENARXTOML" ]; then
    echo "$ENARXTOML does not exist."
    exit 1
fi

# Enarx Keep execution
for i in {1..100}
do
  echo "Test $i"
  sudo perf stat -e cycles,instructions,task-clock $ENARX run --backend=nil --wasmcfgfile $ENARXTOML $WASMBINARY
done
