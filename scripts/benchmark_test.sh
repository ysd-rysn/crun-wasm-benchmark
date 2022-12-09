#!/bin/bash

SCRIPTS_DIR=$PWD/scripts
source $SCRIPTS_DIR/benchmark.sh

function prepare_rootfs_test() {
	echo "$FUNCNAME"
	prepare_rootfs nbody
	result=`ls -1 $BUNDLE_DIR/rootfs | grep 'nbody-aot.wasm'`
	expected='nbody-aot.wasm'
	if [ "$result" = "$expected" ]; then
		echo 'passed'
	else
		echo 'failed'
		echo -e "result is \n$result"
		echo -e "expected is \n$expected"
	fi
}

function prepare_config_json_test() {
	echo "$FUNCNAME"
	prepare_config_json nbody 3
	result=`cat $BUNDLE_DIR/config.json | jq '.process.args'`
	expected=`echo '["/nbody-aot.wasm", "/nbody-aot.wasm", "/nbody-aot.wasm"]' | jq`
	if [ "$result" = "$expected" ]; then
		echo 'passed'
	else
		echo 'failed'
		echo -e "result is \n$result"
		echo -e "expected is \n$expected"
	fi
}

function prepare_bundle_test() {
	echo "$FUNCNAME"
	prepare_bundle nbody 3
	result=(
		"$(ls -1 $BUNDLE_DIR/rootfs | grep 'nbody-aot.wasm')"
		"$(cat $BUNDLE_DIR/config.json | jq '.process.args')"
	)
	expected=(
		'nbody-aot.wasm'
		"$(echo '["/nbody-aot.wasm", "/nbody-aot.wasm", "/nbody-aot.wasm"]' | jq)"
	)
	for ((i=0; i < ${#result[@]}; i++)); do
		if [ "${result[$i]}" = "${expected[$i]}" ]; then
			if [ $i -eq $((${#result[@]} - 1)) ]; then
				echo 'passed'
			fi
		else
			echo 'failed'
			echo -e "result$i is \n${result[$i]}"
			echo -e "expected$i is \n${expected[$i]}"
		fi
	done
}


# Run tests
echo '' # New line
prepare_rootfs_test
echo ''
prepare_config_json_test
echo ''
prepare_bundle_test
