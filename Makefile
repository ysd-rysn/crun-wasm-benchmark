.PHONY: configure build bench clean test_scripts

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
