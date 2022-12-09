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
```
$ make benchmark
```

Log files are generated in `benchmark`.
