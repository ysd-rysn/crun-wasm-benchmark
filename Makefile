.PHONY: usage configure build benchmark_single_wasm benchmark_multiple_wasm benchmark_native clean test_scripts

usage:
	@echo 'See README for usage.'

configure:
	@./scripts/configure.sh

build:
	@./scripts/build.sh

benchmark_single_wasm:
	@rm -rf ./benchmark/crun
	@./scripts/benchmark.sh single_wasm $(N)

benchmark_multiple_wasm:
	@rm -rf ./benchmark/crun_with_multiple_wasm
	@./scripts/benchmark.sh multiple_wasm $(N)

benchmark_native:
	@rm -rf ./benchmark/crun_native
	@./scripts/benchmark.sh native $(N)

clean:
	@rm -ri ./build ./bin ./benchmark

test_scripts:
	@./scripts/benchmark_test.sh
