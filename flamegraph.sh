#!/bin/bash


usage() {
	printf "\nusage: $0 n f\n"
	printf "    Generates s\n\n"
}

if [[ ($# == "--help") || $# == "-h" || $1 == "" ]]; then
	usage
	exit 0
fi


base_path=$(pwd)
perf record -F $2 -ag -- sleep $1
perf script | $base_path/flamegraph/stackcollapse-perf.pl > out.perf-folded
cat out.perf-folded | $base_path/flamegraph/flamegraph.pl > flamegraph.svg
