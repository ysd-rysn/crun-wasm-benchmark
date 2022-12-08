#!/bin/bash

function install_utils() {
	sudo apt install -y jq
}

function install_emscripten() {
	sudo apt install -y llvm clang lld lldb

	sudo apt install -y cmake

	git clone https://github.com/emscripten-core/emsdk.git
	pushd emsdk
	./emsdk install latest
	./emsdk activate latest
	source ./emsdk_env.sh
	echo "source $PWD/emsdk_env.sh" >> $HOME/.bashrc
	popd
}

function install_wasmedge() {
	curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -p /usr/local
}

function install_crun() {
	sudo apt install -y make git gcc build-essential pkgconf libtool \
		libsystemd-dev libprotobuf-c-dev libcap-dev libseccomp-dev libyajl-dev \
		go-md2man libtool autoconf python3 automake
	if [ ! -d crun ]; then
		git clone https://github.com/ysd-rysn/crun.git
	fi
	pushd crun
	./autogen.sh
	./configure --with-wasmedge
	make
	if [ -e crun ]; then
		mkdir ../bin
		cp crun ../bin
		#sudo cp crun /usr/local/bin
	fi
	make clean

	git switch handle_multiple_wasm
	./autogen.sh
	./configure --with-wasmedge
	make
	if [ -e crun ]; then
		cp crun ../bin/crun-with-multiple-wasm
		#sudo cp crun /usr/local/bin/crun-with-multiple-wasm
	fi
	make clean
	popd
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	sudo apt update
	install_utils
	install_emscripten
	install_wasmedge
	install_crun
fi
