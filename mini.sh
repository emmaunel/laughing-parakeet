#!/bin/bash

PS1outfile="APM1_metrics.csv"
echo -e "time %CPU %MEM" >> $PS1outfile
PS2outfile="APM2_metrics.csv"
echo -e "time %CPU %MEM" >> $PS2outfile
PS3outfile="APM3_metrics.csv"
echo -e "time %CPU %MEM" >> $PS3outfile
PS4outfile="APM4_metrics.csv"
echo -e "time %CPU %MEM" >> $PS4outfile
PS5outfile="APM5_metrics.csv"
echo -e "time %CPU %MEM" >> $PS5outfile
PS6outfile="APM6_metrics.csv"
echo -e "time %CPU %MEM" >> $PS6outfile

systemlog="system_metrics.csv"
echo -e "Time RX-Data TX-Data Disk-Write Disk-Use" >> $systemlog


#Arguments: IP address of NIC
function startProcesses {
	./APMs/APM1 $1 &
	./APMs/APM2 $1 &
	./APMs/APM3 $1 &
	./APMs/APM4 $1 &
	./APMs/APM5 $1 &
	./APMs/APM6 $1 &

	ifstat -d 1
}

#Arguments: time
function processlevel {
	# ps -p <pid> -o %cpu,%mem,cmd
	#sleep 5
	P1=$(pidof APM1)
	P2=$(pidof APM2)
	P3=$(pidof APM3)
	P4=$(pidof APM4)
	P5=$(pidof APM5)
	P6=$(pidof APM6)

	
	PS1=$(ps -p $P1 -o %cpu,%mem,cmd | tail -n 1)
	echo "${1} , $PS1" >> $PS1outfile

	PS2=$(ps -p $P2 -o %cpu,%mem,cmd | tail -n 1)
	echo "${1} , $PS2" >> $PS2outfile

	PS3=$(ps -p $P3 -o %cpu,%mem,cmd | tail -n 1)
	echo "${1} , $PS3" >> $PS3outfile

	PS4=$(ps -p $P4 -o %cpu,%mem,cmd | tail -n 1)
	echo "${1} , $PS4" >> $PS4outfile

	PS5=$(ps -p $P5 -o %cpu,%mem,cmd | tail -n 1)
	echo "${1} , $PS5" >> $PS5outfile

	PS6=$(ps -p $P6 -o %cpu,%mem,cmd | tail -n 1)
	echo "${1} , $PS6" >> $PS6outfile
}

function cleanup {
	pkill APM1
	pkill APM2
	pkill APM3
	pkill APM4
	pkill APM5
	pkill APM6

	pkill ifstat
}

function system() {
	local DISKW=$(iostat -ky 5 1 | grep sda | awk '{print $4}')
	local IFOUT=$(ifstat lo | grep lo)
	local RX=$(printf "$IFOUT" | awk '{print $6}')
	local TX=$(printf "$IFOUT" | awk '{print $8}')
	local DISKUSE=$(df / -B MB | grep /dev/mapper/centos-root | awk '{print $3}')
	logSystem ${1} "$RX" "$TX" "$DISKW" "$DISKUSE"
}

#Arguments: process name, seconds, %cpu, %memory
function logProcess {
	outfile="${1}_metrics.csv"
	echo "${2}, ${3}, ${4}" >> $outfile
}

#Arguments: seconds, RX rate, TX rate, disk writes, disk capacity
function logSystem {
	echo "${1}, ${2}, ${3}, ${4}, ${5}" >> $systemlog
}

end=900
SECONDS=0

cleanup
startProcesses 127.0.0.1
while [ $SECONDS -lt $end ]; do
	echo $SECONDS
	sleep 5
	# Monitor process
	processlevel $SECONDS
	system $SECONDS
done

cleanup

