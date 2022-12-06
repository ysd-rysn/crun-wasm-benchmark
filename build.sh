#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

WD=$PWD
NAME=(
	nbody-c
	nbody-cpp
	fannkuch-redux-c
	mandelbrot-c
	mandelbrot-simd-c
	binary-trees-c
	fasta-c
)


function compile_wasm() {
	if [ -d $WD/build ]; then
		mkdir -p build/aot_wasm
	fi

	for ((i=0; i<"${#NAME[@]}"; ++i)); do
		echo "Compile ${NAME[i]}.wasm" 
		wasmedgec $WD/build/wasm/${NAME[i]}.wasm $WD/build/aot_wasm/${NAME[i]}-aot.wasm
		#cp $WD/build/aot_wasm/${NAME[i]}-aot.wasm $WD/bundle/rootfs
	done
}

function invoke_cmake() {
    cmake -B build . -DCMAKE_BUILD_TYPE=Release
    cmake --build build
}


invoke_cmake
compile_wasm
