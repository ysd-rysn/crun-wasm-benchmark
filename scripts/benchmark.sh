#!/bin/bash

NAME=(
    nbody
    fannkuch-redux
    binary-trees
)

ARGS=(
    50000000
    12
    21
)

BUNDLE_DIR=$PWD/bundle
BUILD_DIR=$PWD/build


# Prepare rootfs.
# Args:
# 	benchmark program name
function prepare_rootfs() {
	pushd $BUNDLE_DIR/rootfs
	for name in "${NAME[@]}"; do
		if [ -e ${name}-aot.wasm ]; then
			rm ${name}-aot.wasm
		fi
	done

	wasm=${1}-aot.wasm
	cp $BUILD_DIR/aot_wasm/$wasm .
	popd
}

# Prepare config.json.
# Args:
# 	benchmark program name
# 	number of programs to run in benchmark
function prepare_config_json() {
	pushd $BUNDLE_DIR
	cat config.json | jq '.process.args |= []' > tmp.json
	cp tmp.json config.json && rm tmp.json

	wasm=/${1}-aot.wasm
	num=$2
	for i in `seq $num`; do
		cat config.json | jq --arg v $wasm '.process.args += [$v]' > tmp.json
		cp tmp.json config.json && rm tmp.json
	done
	popd
}

# Prepare bundle.
# Args:
# 	benchmark program name
# 	number of programs to run in benchmark
function prepare_bundle() {
	cp_wasm_to_rootfs $1
	prepare_config_json $1 $2
}

function benchmark_crun() {
	echo
}


function benchmark_crun_with_multiple_wasm() {
	echo
}

# Print benchmark result.
# Args:
# 	log file
function print_result() {
	echo
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	mkdir -p benchmark/crun
	mkdir -p benchmark/crun_with_multiple_wasm

	benchmark_crun
	benchmark_crun_with_multiple_wasm
fi
