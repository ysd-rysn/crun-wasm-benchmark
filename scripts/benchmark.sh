#!/bin/bash

BUNDLE_DIR=$PWD/bundle
BUILD_DIR=$PWD/build
BIN_DIR=$PWD/bin
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
MODE=${1:-'single_wasm'}
TIME=${2:-1} # Number of times to run the benchmark.
crun=$BIN_DIR/crun
crun_with_multiple_wasm=$BIN_DIR/crun-with-multiple-wasm


# Prepare rootfs for benchmark.
# Args:
# 	Benchmark program name
function prepare_rootfs() {
	pushd $BUNDLE_DIR/rootfs
	local name
	for name in "${NAME[@]}"; do
		if [ -e ${name}-aot.wasm ]; then
			rm ${name}-aot.wasm
		fi
	done

	local wasm=${1}-aot.wasm
	cp $BUILD_DIR/aot_wasm/$wasm .
	chmod +x $wasm
	popd
}

# Prepare config.json for benchmark.
# Args:
# 	Benchmark program name
# 	Number of programs to run in benchmark
function prepare_config_json() {
	pushd $BUNDLE_DIR
	cat config.json | jq '.process.args |= []' > tmp.json
	cp tmp.json config.json && rm tmp.json

	local wasm=/${1}-aot.wasm
	local num=$2
	local i
	for i in `seq -w $num`; do
		cat config.json | jq --arg v $wasm '.process.args += [$v]' > tmp.json
		cp tmp.json config.json && rm tmp.json
	done
	popd
}

# Prepare bundle for benchmark.
# Args:
# 	Benchmark program name
# 	Number of programs to run in benchmark
function prepare_bundle() {
	prepare_rootfs $1
	prepare_config_json $1 $2
}

function prepare_log_directory() {
	if [ ! -d benchmark ]; then
		mkdir -p benchmark/crun
		local name
		for name in "${NAME[@]}"; do
			local log_dir="$PWD/benchmark/crun/$name"
			mkdir $log_dir
		done

		mkdir -p benchmark/crun_with_multiple_wasm
		for name in "${NAME[@]}"; do
			log_dir="$PWD/benchmark/crun_with_multiple_wasm/$name"
			mkdir $log_dir
		done
	fi
}

# Args:
# 	Benchmark program name
# 	Number of programs to run in benchmark
function run_crun() {
	local name=$1
	local num=$2
	prepare_bundle $name 1

	local log_dir="$PWD/benchmark/crun/$name"
	if [ ! -d ${log_dir}/run${num} ]; then
		mkdir ${log_dir}/run${num}
	fi
	pushd $BUNDLE_DIR
	echo "$name"
	local i
	for i in `seq -w $num`; do
		/usr/bin/time -v -o "${log_dir}/run${num}/${name}_${i}_${TIME}.time" sudo "$crun_with_multiple_wasm" run ${name}-wasm-${i}
	done
	echo '' # New line
	popd
}

# Args:
# 	Benchmark program name
# 	Number of programs to run in benchmark
function run_crun_with_multiple_wasm() {
	local name=$1
	local num=$2
	prepare_bundle $name $num

	local log_dir="$PWD/benchmark/crun_with_multiple_wasm/$name"
	if [ ! -d ${log_dir}/run${num} ]; then
		mkdir ${log_dir}/run${num}
	fi
	pushd $BUNDLE_DIR
	echo "$name"
	/usr/bin/time -v -o "${log_dir}/run${num}/${name}_${TIME}.time" sudo "$crun_with_multiple_wasm" run ${name}-wasm
	echo '' # New line
	popd
}

function benchmark_crun() {
	local name
	for name in "${NAME[@]}"; do
		# Run 5 programs
		#run_crun $name 5
		# Run 10 programs
		#run_crun $name 10
		# Run 15 programs
		#run_crun $name 15
		run_crun $name 3
	done
}

function benchmark_crun_with_multiple_wasm() {
	local name
	for name in "${NAME[@]}"; do
		# Run 5 programs
		#run_crun_with_multiple_wasm $name 5
		# Run 10 programs
		#run_crun_with_multiple_wasm $name 10
		# Run 15 programs
		#run_crun_with_multiple_wasm $name 15
		run_crun_with_multiple_wasm $name 3
	done
}

# Print benchmark result.
# Args:
# 	Log file
function print_result() {
	echo
}


# Run benchmark
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	prepare_log_directory
	if [ $MODE = 'single_wasm' ]; then
		echo -e 'benchmark single wasm\n'
		for i in `seq -w ${TIME}`; do
			echo -e "${i} time"
			benchmark_crun
		done
	elif [ $MODE = 'multiple_wasm' ]; then
		echo -e 'benchmark multiple wasm\n'
		for i in `seq -w ${TIME}`; do
			echo -e "${i} time"
			benchmark_crun_with_multiple_wasm
		done
	fi
fi
