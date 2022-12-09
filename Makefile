.PHONY: usage configure build benchmark clean test_scripts

usage:
	@echo 'Usage is written in README.'

configure:
	./scripts/configure.sh

build:
	./scripts/build.sh	

benchmark:
	./scripts/benchmark.sh

clean:
	rm -ri build bin benchmark

test_scripts:
	./scripts/benchmark_test.sh
