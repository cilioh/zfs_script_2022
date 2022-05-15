#!/bin/bash

bsize=${1}
numjobs=${2}
nodename=${3}
filename=${4}
stripecount=${5}
todaydate=${6}
todaytime=${7}
iternum=${8}
directory=${9}
blsize=${10}
xfersize=${11}
experiment=${12}

sig_dir="/mnt/share/cykim/signal"
direct=0  #0: buffered , 1:directIO

	output=`fio --directory=${directory} --name=${filename}${iternum} --rw=randwrite --direct=${direct} --bs=${blsize} --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none | awk '$1 == "WRITE:" { print $3 } $1 == "iops" { print } /9[5-9].[0-9]+th/ { print }' | grep -oP '(\([0-9.]+|95.00th=\[[\s\d]+|99.00th=\[[\s\d]+|99.90th=\[[\s\d]+|99.99th=\[[\s\d]+|min=[\s\d.]+|max=[\s\d.]+|avg=[\s\d.]+)' | grep -oP '([\(\[]\s*(\d+^[.]|\d+.\d+)|=\s*(\d+^[.]|\d+.\d+))' | grep -oP '(\d+^[.]|\d+.\d+)' | tr '\n' ' ' | awk '{ print $1"," $2"," $3"," $4"," $5"," $6"," $7"," $8}'`

	#Result - ECHO
	echo ${nodename}","${bsize}" "${xfersize}" "${blsize}" "${13}" "${14}","${numjobs}","${stripecount}","${iternum}","${output} > /mnt/share/cykim/result/${nodename}.txt

	#/mnt/share/cykim/result/${todaydate}/Result_${todaytime}_${nodename}.txt
	
	per95=`echo $output | cut -d',' -f1`
	per99=`echo $output | cut -d',' -f2`
	per999=`echo $output | cut -d',' -f3`
	per9999=`echo $output | cut -d',' -f4`
	iopsmin=`echo $output | cut -d',' -f5`
	iopsmax=`echo $output | cut -d',' -f6`
	iopsavg=`echo $output | cut -d',' -f7`
	th=`echo $output | cut -d',' -f8`
	echo "["${nodename}",BJ="${bsize}",BS="${blsize}",Xfer="${xfersize}",NJ="${numjobs}",SC="${stripecount}",IT-"${iternum}"],99%=["${per99}"],iops_avg=["${iopsavg}"],TH=["${th}"]"
#	echo "["${nodename}",BJ="${bsize}",Mpages="${13}",Mflight="${14}",NJ="${numjobs}",SC="${stripecount}",IT-"${iternum}"],99%=["${per99}"],iops_avg=["${iopsavg}"],TH=["${th}"]"
	sleep 1

	echo "ON" > /mnt/share/cykim/signal/${nodename}
exit 0
