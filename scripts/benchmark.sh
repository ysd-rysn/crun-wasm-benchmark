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
N=${2:-1} # Number of times to run the benchmark.
TIME=1
crun=$BIN_DIR/crun
crun_with_multiple_wasm=$BIN_DIR/crun-with-multiple-wasm


# Prepare rootfs for benchmark.
# Args:
# 	Benchmark program name
function prepare_rootfs() {
	pushd $BUNDLE_DIR/rootfs > /dev/null
	local name
	for name in "${NAME[@]}"; do
		if [ -e ${name}-aot.wasm ]; then
			rm ${name}-aot.wasm
		fi
	done

	local wasm=${1}-aot.wasm
	cp $BUILD_DIR/aot_wasm/$wasm .
	chmod +x $wasm
	popd > /dev/null
}

# Prepare config.json for benchmark.
# Args:
# 	Benchmark program name
# 	Number of programs to run in benchmark
function prepare_config_json() {
	pushd $BUNDLE_DIR > /dev/null
	cat config.json | jq '.process.args |= []' > tmp.json
	cp tmp.json config.json && rm tmp.json

	local wasm=/${1}-aot.wasm
	local num=$2
	local i
	for i in `seq -w $num`; do
		cat config.json | jq --arg v $wasm '.process.args += [$v]' > tmp.json
		cp tmp.json config.json && rm tmp.json
	done
	popd > /dev/null
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
	pushd $BUNDLE_DIR > /dev/null
	echo "$name"
	local i
	for i in `seq -w $num`; do
		/usr/bin/time -v -o "${log_dir}/run${num}/${name}_${i}_${TIME}.time" "$crun" run ${name}-wasm-${num} \
			| egrep '(start|end|elapsed|init) time' > ${log_dir}/run${num}/${name}_${i}_${TIME}
	done
	echo '' # New line
	popd > /dev/null
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
	pushd $BUNDLE_DIR > /dev/null
	echo "$name"
	/usr/bin/time -v -o "${log_dir}/run${num}/${name}_${TIME}.time" "$crun_with_multiple_wasm" run ${name}-wasm \
		| egrep '(start|end|elapsed|init) time' > ${log_dir}/run${num}/${name}_${TIME}
	echo '' # New line
	popd > /dev/null
}

function benchmark_crun() {
	local name
	for name in "${NAME[@]}"; do
		echo -e 'Run 4 programs\n'
		run_crun $name 4
		echo -e 'Run 8 programs\n'
		run_crun $name 8
		echo -e 'Run 12 programs\n'
		run_crun $name 12
	done
}

function benchmark_crun_with_multiple_wasm() {
	local name
	for name in "${NAME[@]}"; do
		echo -e 'Run 4 programs\n'
		run_crun_with_multiple_wasm $name 4
		echo -e 'Run 8 programs\n'
		run_crun_with_multiple_wasm $name 8
		echo -e 'Run 12 programs\n'
		run_crun_with_multiple_wasm $name 12
	done
}

# Args:
# 	Number of times to run benchmark
function print_time() {
	local time=$1
	case "$time" in
		'1')
			echo -e "${time}st time\n"
			;;
		'2')
			echo -e "${time}nd time\n"
			;;
		'3')
			echo -e "${time}rd time\n"
			;;
		*)
			echo -e "${time}th time\n"
			;;
	esac
}


# Run benchmark
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	prepare_log_directory
	case "$MODE" in
		'single_wasm')
			echo -e 'benchmark single wasm\n'
			echo -e "Run benchmark ${N} times\n"
			for i in `seq -w ${N}`; do
				TIME=$i
				print_time $i
				benchmark_crun
			done
			;;
		'multiple_wasm')
			echo -e 'benchmark multiple wasm'
			echo -e "Run benchmark ${N} times\n"
			for i in `seq -w ${N}`; do
				TIME=$i
				print_time $i
				benchmark_crun_with_multiple_wasm
			done
			;;
	esac
fi
