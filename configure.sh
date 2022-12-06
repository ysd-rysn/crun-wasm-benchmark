#!/bin/bash

sudo apt update

### Install LLVM
sudo apt install -y llvm clang lld lldb

### Install cmake
sudo apt install -y cmake

### Install emscripten
git clone https://github.com/emscripten-core/emsdk.git
pushd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
echo "source $PWD/emsdk_env.sh" >> $HOME/.bashrc
popd

### Install wasmedge
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -p /usr/local

### Install crun
sudo apt install -y make git gcc build-essential pkgconf libtool \
	    libsystemd-dev libprotobuf-c-dev libcap-dev libseccomp-dev libyajl-dev \
		go-md2man libtool autoconf python3 automake
git clone https://github.com/ysd-rysn/crun.git
cd crun
git switch handle_mulitple_wasm
./autogen.sh
./configure --with-wasmedge
make
sudo make install
