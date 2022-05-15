#!/bin/bash

#--------------- SETTINGS----------------
filename='test.log'
bsize="32G"
numjobs=16
annot="3client/3ost/2oss/GC"
directory="/mnt/lustre/"
sig_dir="/mnt/share/cykim/signal"
#---------------------------------------

#ssh - multi-client mode
echo 0 > ${sig_dir}/fio_run
echo "OFF" > ${sig_dir}/cn8
echo "OFF" > ${sig_dir}/cn9
echo "OFF" > ${sig_dir}/cn10
ssh cn8 'kill -9 `pidof sh`' 2> ${sig_dir}/dummy
ssh cn9 'kill -9 `pidof sh`' 2> ${sig_dir}/dummy
ssh cn10 'kill -9 `pidof sh`' 2> ${sig_dir}/dummy
#ssh cn8 'sh /root/lustre-compute/nvme-log-mc.sh '${bsize} ${numjobs} ${annot}' 8' &
#ssh cn9 'sh /root/lustre-compute/nvme-log-mc.sh '${bsize} ${numjobs} ${annot}' 9' &
#ssh cn10 'sh /root/lustre-compute/nvme-log-mc.sh '${bsize} ${numjobs} ${annot}' 10' &
sleep 1

#ssh - start nvme-cli script for each pm node
echo "OFF" > ${sig_dir}/msg1
echo "OFF" > ${sig_dir}/msg2
echo "OFF" > ${sig_dir}/msg3
ssh pm001 'kill -9 `pidof sh`' 2> ${sig_dir}/dummy
ssh pm002 'kill -9 `pidof sh`' 2> ${sig_dir}/dummy
ssh pm003 'kill -9 `pidof sh`' 2> ${sig_dir}/dummy
ssh pm001 'sh /mnt/share/cykim/pm/receiver.sh 1' &
ssh pm002 'sh /mnt/share/cykim/pm/receiver.sh 2' &
ssh pm003 'sh /mnt/share/cykim/pm/receiver.sh 3' &
sleep 1

# OST nodes CHECK Sequence
echo "Waiting for OST nodes to turn on ..."
while true
do
	sleep 0.1
	checkmsg=`cat ${sig_dir}/msg1`
	if [[ $checkmsg == "ON" ]]; then
		rm -rf ${sig_dir}/msg1
		echo "PM001 node 1 - ON"
		break
	fi
done

while true
do
	sleep 0.1
	checkmsg=`cat ${sig_dir}/msg2`
	if [[ $checkmsg == "ON" ]]; then
		rm -rf ${sig_dir}/msg2
		echo "PM002 node 2 - ON"
		break
	fi
done

while true
do
	sleep 0.1
	checkmsg=`cat ${sig_dir}/msg3`
	if [[ $checkmsg == "ON" ]]; then
		rm -rf ${sig_dir}/msg3
		echo "PM003 node 3 - ON"
		break
	fi
done

# FLYER - start command
echo 1 > ${sig_dir}/flyer1
echo 1 > ${sig_dir}/flyer2
echo 1 > ${sig_dir}/flyer3
sleep 1

# FLYER - start fio
echo 1 > ${sig_dir}/fio_run
sleep 0.1

#fio
echo "CN7 node - ON"
echo "FIO start - bsize: "${bsize}", numjobs: "${numjobs}
output=`fio --directory=${directory} --name=tttt1 --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none`

#clat percentiles (usec)
percentile_95=`echo $output | cut -d'[' -f13 | cut -d']' -f1`
percentile_99=`echo $output | cut -d'[' -f14 | cut -d']' -f1`
percentile_999=`echo $output | cut -d'[' -f16 | cut -d']' -f1`
percentile_9999=`echo $output | cut -d'[' -f18 | cut -d']' -f1`

#Write Bandwidth
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`

# fLYER - end command
sleep 2
echo 1 > ${sig_dir}"/flyer1"
echo 1 > ${sig_dir}"/flyer2"
echo 1 > ${sig_dir}"/flyer3"
sleep 2

waf1=`cat ${sig_dir}/result-waf1` && rm -rf ${sig_dir}/result-waf1
waf2=`cat ${sig_dir}/result-waf2` && rm -rf ${sig_dir}/result-waf2
waf3=`cat ${sig_dir}/result-waf3` && rm -rf ${sig_dir}/result-waf3

stripesize=`cat ${sig_dir}/setstripe`
echo "["${bsize}","${numjobs}","${annot}","${stripesize}",CN7] "$percentile_95 $percentile_99 $percentile_999 $percentile_9999 $throughput $waf1 $waf2 $waf3 >> $filename
echo "["${bsize}","${numjobs}","${annot}","${stripesize}",CN7] "$percentile_95 $percentile_99 $percentile_999 $percentile_9999 $throughput $waf1 $waf2 $waf3 >> /mnt/share/cykim/result/test-total.log

cp $filename /mnt/share/cykim/result/test7.log

echo "["${bsize}","${numjobs}","${annot}","${stripesize}",CN7] "$percentile_95 $percentile_99 $percentile_999 $percentile_9999 $throughput $waf1 $waf2 $waf3

# mc
#echo `tail -1 /mnt/share/cykim/result/test8.log`
#echo `tail -1 /mnt/share/cykim/result/test9.log`
#echo `tail -1 /mnt/share/cykim/result/test10.log`
exit 0
