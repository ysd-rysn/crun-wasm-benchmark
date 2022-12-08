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
		echo 'prepare_config_json_test failed'
		echo -e "result is \n$result"
		echo -e "expected is \n$expected"
	fi
}


echo '' # new line
prepare_rootfs_test
echo ''
prepare_config_json_test
