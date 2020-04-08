#!/bin/bash

#Arguments: IP address of NIC
function startProcesses {
	./APMs/APM1 $1 &
	./APMs/APM2 $1 &
	./APMs/APM3 $1 &
	./APMs/APM4 $1 &
	./APMs/APM5 $1 &
	./APMs/APM6 $1 &
}

function cleanup {
	pkill APM1
	pkill APM2
	pkill APM3
	pkill APM4
	pkill APM5
	pkill APM6
}

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
