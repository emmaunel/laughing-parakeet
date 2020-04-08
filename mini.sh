#!/bin/bash

#Arguments: process name, seconds, %cpu, %memory
function logProcess {
	outfile="${1}_metrics.csv"
	echo "${2}, ${3}, ${4}" >> $outfile
}

#Arguments: seconds, RX rate, TX rate, disk writes, disk capacity
function logSystem {
	outfile="system_metrics.csv"
	echo "${1}, ${2}, ${3}, ${4}, ${5}" >> $outfile
}