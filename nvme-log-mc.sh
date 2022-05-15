#!/bin/bash

#--------------- SETTINGS----------------
filename='test.log'
bsize=${1}
numjobs=${2}
annot=${3}
clientnum=${4}
directory="/mnt/lustre/"
sig_dir="/mnt/share/cykim/signal"
#---------------------------------------

# CLIENT - Run Sequence
while true
do
	sleep 0.1
	checkmsg=`cat ${sig_dir}/fio_run`
	if [[ $checkmsg == "1" ]]; then
		rm -rf ${sig_dir}/msg1
		echo "CN"${clientnum}" node - ON"
		break
	fi
done

#fio
echo "FIO start - bsize: "${bsize}", numjobs: "${numjobs}
output=`fio --directory=${directory} --name=test --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none`

#clat percentiles (usec)
percentile_95=`echo $output | cut -d'[' -f13 | cut -d']' -f1`
percentile_99=`echo $output | cut -d'[' -f14 | cut -d']' -f1`
percentile_999=`echo $output | cut -d'[' -f16 | cut -d']' -f1`
percentile_9999=`echo $output | cut -d'[' -f18 | cut -d']' -f1`

#Write Bandwidth
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`

stripesize=`cat ${sig_dir}/setstripe`
echo "["${bsize}","${numjobs}","${annot}","${stripesize}",CN"${clientnum}"] "$percentile_95 $percentile_99 $percentile_999 $percentile_9999 $throughput >> $filename
echo "["${bsize}","${numjobs}","${annot}","${stripesize}",CN"${clientnum}"] "$percentile_95 $percentile_99 $percentile_999 $percentile_9999 $throughput >> /mnt/share/cykim/result/test-total.log

cp $filename /mnt/share/cykim/result/test${clientnum}.log

exit 0
