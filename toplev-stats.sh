#!/bin/bash

usage() {
	printf "\nusage: $0 n\n"
	printf "    Generates system profiling information, sampling for n seconds\n\n"
}

if [[ ($# == "--help") || $# == "-h" || $1 == "" ]]; then
	usage
	exit 0
fi

duration=$1

(toplev -l2 --global --no-desc -x, --output bottleneck.data -v -- sleep $duration)

python plottoplev.py bottleneck.data
