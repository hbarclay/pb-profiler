#!/bin/bash

usage() {
	printf "\nusage: $0 [--help] [OPTIONS] -o runname -f frequency -d duration\n"
	printf "    Generates system profiling information\n\n"
}

if [ "$EUID" -ne 0 ]; then 
	printf "Depending on system configuration, this script may need to be run as root\n"
fi

if [[ ($# == "--help") || $# == "-h" ]]; then
	usage
	exit 0
fi

base_path=$(pwd)

sys_stats=''
microarch_stats=''
bottleneck=''
function_profile=''
run_name="$(date +"%FT%H%M%S")"
interval=''
frequency=''
duration=''
verbose=''
all=''
while getopts 'smbno:vf:d:i:a' flag; do
	case "${flag}" in
		s) sys_stats='true' ;;
		m) microarch_stats='true' ;;
		b) bottleneck='true' ;;
		n) function_profile='true' ;;
		o) run_name="${OPTARG}" ;;
		v) verbose='true' ;;
		f) frequency="${OPTARG}" ;;
		i) interval="${OPTARG}" ;;
		d) duration="${OPTARG}" ;;
		a) all='true' ;;
		*) 	usage 
			exit 1 ;;
	esac
done

if [[ $frequency == '' ]] ; then
	printf "Must provide sample frequency\n"
	exit 1
fi

if [[ $duration == '' ]] ; then
	printf "Defaulting to 10s duration\n"
	duration=10
fi

mkdir out 2>/dev/null
mkdir out/$run_name
cd out/$run_name

if [[ "$microarch_stats" == 'true' || "$all" == 'true' ]] ; then
	# FIXME detailed, all cores, etc.
	printf "Launching perf for microarch data\n"
	touch microarch.data
	(perf stat -daAv -D 1 -F $frequency -o "microarch.data" -x "," sleep $duration > perf_microarch.log 2>&1;) &

	# TODO add perf record
fi


#if [[ "$sys_stats" == 'true' || "$all" == 'true' ]] ; then
#		# TODO 
#		
#fi
#
#
#if [[ "$bottleneck" == 'true' || "$all" == 'true' ]] ; then
#		# TODO 
#fi

if [[ "$function_profile" == 'true'  || "$all" == 'true' ]] ; then
		printf "Launching perf for call stack data"
		perf record -F $frequency -ag -- sleep $duration
		perf script | $base_path/flamegraph/stackcollapse-perf.pl > out.perf-folded
		cat out.perf-folded | $base_path/flamegraph/flamegraph.pl > perf-kernel.svg
fi

# process 



