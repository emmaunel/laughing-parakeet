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

function processlevel {
	# ps -p <pid> -o %cpu,%mem,cmd
	sleep 5
	P1=$(pidof APM1)
	P2=$(pidof APM2)
	P3=$(pidof APM3)
	P4=$(pidof APM4)
	P5=$(pidof APM5)
	P6=$(pidof APM6)

	ps -p $P1 -o %cpu,%mem,cmd
	ps -p $P2 -o %cpu,%mem,cmd
	ps -p $P3 -o %cpu,%mem,cmd
	ps -p $P4 -o %cpu,%mem,cmd
	ps -p $P5 -o %cpu,%mem,cmd
	ps -p $P6 -o %cpu,%mem,cmd
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

startProcesses 127.0.0.1
processlevel
sleep 5
cleanup

