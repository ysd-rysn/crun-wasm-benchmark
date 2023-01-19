# crun-wasm-benchmark

All benchmark C sources are coming from [The Computer Language Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html).

## Usage

1. Install dependencies.
```
$ make configure
```

2. Build WebAssembly.
```
$ make build
```

3. Run benchmark. (Note: Previous benchmark result is removed)

    - Single wasm (N is number of times to run the benchmark.)
    ```
    $ sudo make benchmark_single_wasm N=1
    ```

    - Multiple wasm (N is number of times to run the benchmark.)
    ```
    $ sudo make benchmark_multiple_wasm N=1
    ```

Log files are generated in `benchmark`.
