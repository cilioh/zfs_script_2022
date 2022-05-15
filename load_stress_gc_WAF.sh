#!/bin/bash

bsize=${1}
numjobs=${2}
nodename=${3}
filename=${4}
stripecount=${5}

directory="/mnt/lustre"
sig_dir="/mnt/share/cykim/signal"
iternum=1

#Drop Caches
#echo 3 > /proc/sys/vm/drop_caches
#sleep 5

while true
do
	#Break Loop Sequence
	breaksig=`cat ${sig_dir}/breaksig`
	if [[ $breaksig == "OFF" ]]; then
		break
	fi

	breaksig=`cat ${sig_dir}/breaksig${stripecount}`
	if [[ $breaksig == "OFF" ]]; then
		break
	fi
	sleep 1

	#FIO
#	output=`fio --directory=${directory} --name=${filename}${iternum} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none | awk '$1 == "WRITE:" { print $3 } /9[5-9].[0-9]+th/ { print }' | grep -oP '[\K\[\(](\s*\d+^[.]|\d+^[.]|\d+.\d+)' | grep -oP '(\d+^[.]|\d+.\d+)' | tr '\n' ' ' | awk '{ print $4"," $5"," $7"," $9"," $10}'`

	#output=`fio --directory=${directory} --name=${filename}${iternum} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none | awk '$1 == "WRITE:" { print $3 } /9[5-9].[0-9]+th/ { print }' | grep -oP '(\([0-9.]+|95.00th=\[[\s\d]+|99.00th=\[[\s\d]+|99.90th=\[[\s\d]+|99.99th=\[[\s\d\]+)'`

	output=`fio --directory=${directory} --name=${filename}${iternum} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none | awk '$1 == "WRITE:" { print $3 } /9[5-9].[0-9]+th/ { print }' | grep -oP '(\([0-9.]+|95.00th=\[[\s\d]+|99.00th=\[[\s\d]+|99.90th=\[[\s\d]+|99.99th=\[[\s\d]+)' | grep -oP '[\(\[]\s*(\d+^[.]|\d+.\d+)' | grep -oP '(\d+^[.]|\d+.\d+)' | tr '\n' ' ' | awk '{ print $1"," $2"," $3"," $4"," $5 }'`

	#Result - ECHO
	echo ${nodename}","${bsize}","${numjobs}","${stripecount}","${iternum}","${output} >> /mnt/share/cykim/result/gc_throughput${nodename}.txt
	
	per95=`echo $output | cut -d',' -f1`
	per99=`echo $output | cut -d',' -f2`
	per999=`echo $output | cut -d',' -f3`
	per9999=`echo $output | cut -d',' -f4`
	th=`echo $output | cut -d',' -f5`
	echo "["${nodename}",BJ="${bsize}",NJ="${numjobs}",SC="${stripecount}",ITER-"${iternum}"],95%=["${per95}"],99%=["${per99}"],99.9%=["${per999}"],99.99%=["${per9999}"],Throughput=["${th}"]"
	sleep 1

	#File Remove
	if [ $iternum -gt 1 ]; then
		rmnum=`expr ${iternum} - 1`
		rm -rf ${directory}/${filename}${rmnum}.1*
		rm -rf ${directory}/${filename}${rmnum}.2*
		rm -rf ${directory}/${filename}${rmnum}.3*
		rm -rf ${directory}/${filename}${rmnum}.4*
	fi
	totval=`lfs df -h | awk '$1=="filesystem_summary:" { print $5 }' | grep -oP '\d+'`
#	totval=`expr $totval + 0`

	if [ $totval -ge 98 ]; then

		echo " 98 % storage full - EMPTY "
		rm -rf ${directory}/${filename}*
	fi

	#iteration
	iternum=`expr $iternum + 1`
	sleep 1
done

echo "["${nodename}",BS="${bsize}",NJ="${numjobs}",iter-"${iternum}"] terminated."

exit 0
