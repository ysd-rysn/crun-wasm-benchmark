#!/bin/bash

SCRIPTS_DIR=$PWD/scripts
source $SCRIPTS_DIR/benchmark.sh

function prepare_rootfs_test() {
	echo "$FUNCNAME"
	prepare_rootfs_for_wasm nbody
	local result=`ls -1 $BUNDLE_DIR/rootfs | grep 'nbody-aot.wasm'`
	local expected='nbody-aot.wasm'
	if [ "$result" = "$expected" ]; then
		echo 'passed'
	else
		echo 'failed'
		echo -e "result is \n$result"
		echo -e "expected is \n$expected"
		return 1
	fi
}

function prepare_rootfs_for_native_test() {
	echo "$FUNCNAME"
	prepare_rootfs_for_native nbody
	local result=`ls -1 $BUNDLE_DIR_FOR_NATIVE/rootfs | grep 'nbody'`
	local expected='nbody'
	if [ "$result" = "$expected" ]; then
		echo 'passed'
	else
		echo 'failed'
		echo -e "result is \n$result"
		echo -e "expected is \n$expected"
		return 1
	fi
}

function prepare_config_json_test() {
	echo "$FUNCNAME"
	prepare_config_json_for_wasm nbody 3
	local result=`cat $BUNDLE_DIR/config.json | jq '.process.args'`
	local expected=`echo '["/nbody-aot.wasm", "/nbody-aot.wasm", "/nbody-aot.wasm"]' | jq`
	if [ "$result" = "$expected" ]; then
		echo 'passed'
	else
		echo 'failed'
		echo -e "result is \n$result"
		echo -e "expected is \n$expected"
		return 1
	fi
}

function prepare_bundle_test() {
	echo "$FUNCNAME"
	prepare_bundle_for_wasm nbody 3
	local result=(
		"$(ls -1 $BUNDLE_DIR/rootfs | grep 'nbody-aot.wasm')"
		"$(cat $BUNDLE_DIR/config.json | jq '.process.args')"
	)
	local expected=(
		'nbody-aot.wasm'
		"$(echo '["/nbody-aot.wasm", "/nbody-aot.wasm", "/nbody-aot.wasm"]' | jq)"
	)
	local i
	for ((i = 0; i < ${#result[@]}; i++)); do
		if [ "${result[$i]}" = "${expected[$i]}" ]; then
			if [ $i -eq $((${#result[@]} - 1)) ]; then
				echo 'passed'
			fi
		else
			echo 'failed'
			echo -e "result$i is \n${result[$i]}"
			echo -e "expected$i is \n${expected[$i]}"
			return 1
		fi
	done
}


# Run tests
prepare_rootfs_test
echo '' # New line
prepare_config_json_test
echo ''
prepare_bundle_test
echo ''
prepare_rootfs_for_native_test
