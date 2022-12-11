# crun-wasm-benchmark

All benchmark C sources are coming from [The Computer Language Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html).

## Requisites

Use the `configure.sh` to install the following dependencies for this benchmark.

- emscripten
- WasmEdge
- crun

## Usage

1. Install dependencies.
```
$ make configure
```

2. Build WebAssembly.
```
$ make build
```

3. Run benchmark.

    1. Single wasm (N is number of times to run the benchmark.)
    ```
    $ make benchmark_single_wasm N=1
    ```

    2. Multiple wasm (N is number of times to run the benchmark.)
    ```
    $ make benchmark_multiple_wasm N=1
    ```

Log files are generated in `benchmark`.
