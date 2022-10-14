#!/bin/bash
#
#/sys/devices/system/cpu/intel_pstate/no_turbo
#--> change 0 to 1
#
#/sys/devices/system/cpu/intel_pstate/status
#--> change passive to off
#
set -e # Exit if any command fails

# Gramine execution
for i in {1..100}
do
  echo "Test $i"
  sudo perf stat -e cycles,instructions,task-clock gramine-sgx target/release/paperback
done
