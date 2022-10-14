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
WASMTIME="/home/silver/.wasmtime/bin/wasmtime"

if [ ! -f "$WASMBINARY" ]; then
    echo "$WASMBINARY does not exist."
    exit 1
fi

if [ ! -f "$WASMTIME" ]; then
    echo "$WASMTIME does not exist."
    exit 1
fi

# Wasmtime execution
for i in {1..100}
do
  echo "Test $i"
  sudo perf stat -e cycles,instructions,task-clock $WASMTIME $WASMBINARY
done
