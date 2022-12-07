.PHONY: configure build bench clean

configure:
	./scripts/configure.sh

build:
	./scripts/build.sh	

bench:
	./scripts/benchmark.sh

clean:
	rm -rf build bin
