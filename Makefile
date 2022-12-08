.PHONY: configure build bench clean test_scripts

configure:
	./scripts/configure.sh

build:
	./scripts/build.sh	

bench:
	./scripts/benchmark.sh

clean:
	rm -rf build bin

test_scripts:
	./scripts/benchmark_test.sh
