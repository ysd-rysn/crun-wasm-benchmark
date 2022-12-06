.PHONY: configure build

configure:
	./configure.sh

build:
	./build.sh	

clean:
	rm -rf build
