#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

WD=$PWD
NAME=(
	nbody
	fannkuch-redux
	mandelbrot
	mandelbrot-simd
	binary-trees
	fasta
)


function compile_wasm() {
	if [ -d $WD/build ]; then
		mkdir -p build/aot_wasm

		for ((i=0; i<"${#NAME[@]}"; ++i)); do
			echo "Compile ${NAME[i]}.wasm" 
			wasmedgec $WD/build/wasm/${NAME[i]}.wasm $WD/build/aot_wasm/${NAME[i]}-aot.wasm
		done
	fi
}

function invoke_cmake() {
    cmake -B build . -DCMAKE_BUILD_TYPE=Release
    cmake --build build
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	invoke_cmake
	compile_wasm
fi
