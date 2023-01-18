.PHONY: usage configure build benchmark_single_wasm benchmark_multiple_wasm clean clean_results test_scripts

usage:
	@echo 'See README for usage.'

configure:
	@./scripts/configure.sh

build:
	@./scripts/build.sh	

benchmark_single_wasm: clean_results
	@./scripts/benchmark.sh single_wasm $(N)

benchmark_multiple_wasm: clean_resluts
	@./scripts/benchmark.sh multiple_wasm $(N)

clean:
	@rm -ri build bin benchmark

clean_resluts:
	@rm -rf benchmark

test_scripts:
	@./scripts/benchmark_test.sh
