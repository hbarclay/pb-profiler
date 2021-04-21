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

# CPI, Branch MPKI, L1 MPKI, dTLB MPKI, iTLB MPKI
(perf stat -e '{cycles,instructions}, \
    {branch-misses,instructions}, \
    {L1-dcache-misses,instructions}, \
    {dTLB-load-misses,dTLB-store-misses,instructions}, \
    {iTLB-load-misses,instructions}, \
    {L1-icache-load-misses,instructions}, \
    {instructions:u,instructions:k}, \
    {stalled-cycles-frontend,cycles}' \
        -aAv -D 1 -o "microarch.data" -x "," -- sleep $duration)



sed -i -e 1,2d microarch.data

python plotmicroarch.py microarch.data
