## paperback -- TEE testing without file interaction

# Install perf tool using your Linux kernel sources.

```
cd linux/tools/perf
make
sudo cp perf /usr/bin
```

# Enarx test (SEV and SGX) and comparison to wasmtime

Modify `benchmark_test_enarx.sh`and select --backend=sgx or --backend=sev.

```
cargo build --target wasm32-wasi --release

sudo bash benchmark_test_wasmtime.sh > 100_tests_wasmtime.log 2>&1
sudo bash benchmark_test_enarx.sh > 100_tests_enarx.log 2>&1
```

# Gramine test after installing Gramine

```
bash setup.sh
gramine-sgx target/release/paperback
```

# Gramine test

```
sudo bash benchmark_test_gramine.sh > 100_tests_gramine.log 2>&1
```
