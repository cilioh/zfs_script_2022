#!/bin/bash
bsize="2G"
numjobs=32
directory="/mnt/lustre"
sig_dir="/mnt/share/cykim/signal"

# Drop Caches
echo 3 > /proc/sys/vm/drop_caches
sleep 5

# PM START
echo "OFF" > ${sig_dir}/gc_msg1
echo "OFF" > ${sig_dir}/gc_msg2
echo "OFF" > ${sig_dir}/gc_msg3
ssh pm001 'kill -9 `pidof sh`' 2> ${sig_dir}/dummy
ssh pm002 'kill -9 `pidof sh`' 2> ${sig_dir}/dummy
ssh pm003 'kill -9 `pidof sh`' 2> ${sig_dir}/dummy
#ssh pm001 'sh /mnt/share/cykim/pm/gc_receiver.sh 1' &
#ssh pm002 'sh /mnt/share/cykim/pm/gc_receiver.sh 2' &
#ssh pm003 'sh /mnt/share/cykim/pm/gc_receiver.sh 3' &
sleep 1

echo "Waiting for OST nodes to turn on ..."
#while true
#do
#	sleep 0.1
#	checkmsg=`cat ${sig_dir}/gc_msg1`
#	if [[ $checkmsg == "ON" ]]; then
#		rm -rf ${sig_dir}/gc_msg1
#		echo "PM001 node - ON"
#		break
#	fi
#done

#while true
#do
#	sleep 0.1
#	checkmsg=`cat ${sig_dir}/gc_msg2`
#	if [[ $checkmsg == "ON" ]]; then
#		rm -rf ${sig_dir}/gc_msg2
#		echo "PM002 node - ON"
#		break
#	fi
#done

#while true
#do
#	sleep 0.1
#	checkmsg=`cat ${sig_dir}/gc_msg3`
#	if [[ $checkmsg == "ON" ]]; then
#		rm -rf ${sig_dir}/gc_msg3
#		echo "PM003 node - ON"
#		break
#	fi
#done

# FLYER - start command
echo 1 > ${sig_dir}/flyer1
echo 1 > ${sig_dir}/flyer2
echo 1 > ${sig_dir}/flyer3
sleep 1

# FIO STRESS

for iter in {1..10}
do
	echo "FIO step 1 : "${iter}" iteration(s) until full capacity - ("${bsize}", "${numjobs}")"
	output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
	throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`

	echo "Throuhgput : "${throughput}"MB/s"
	sleep 0.1
done

bsize2="32G"
for iter in {115..123}
do
	echo "FIO step 1 : "${iter}" iteration(s) until full capacity - ("${bsize2}", "${numjobs}")"
#	output=`fio --directory=${directory} --name=ttt${iter} --rw=write --direct=0 --bs=1M --size=${bsize2} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
#	throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`

#	echo "Throuhgput : "${throughput}"MB/s"
	sleep 0.1
done

# repeat erase and write

echo "FIO step 2 : erase and write heavily - 512GB writes and erases"

for ii in {1..512}
do
	sleep 1s
	echo " *********"
	echo ""
	echo ${ii}" - iteration"
	echo ""
	echo " *********"

rm -rf /mnt/lustre/tt1*
iter=9
output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`
echo "("${iter}")-Throuhgput : "${throughput}"MB/s"

rm -rf /mnt/lustre/tt2*
iter=1
output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`
echo "("${iter}")-Throuhgput : "${throughput}"MB/s"

rm -rf /mnt/lustre/tt3*
iter=2
output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`
echo "("${iter}")-Throuhgput : "${throughput}"MB/s"

rm -rf /mnt/lustre/tt4*
iter=3
output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`
echo "("${iter}")-Throuhgput : "${throughput}"MB/s"

rm -rf /mnt/lustre/tt5*
iter=4
output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`
echo "("${iter}")-Throuhgput : "${throughput}"MB/s"

rm -rf /mnt/lustre/tt6*
iter=5
output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`
echo "("${iter}")-Throuhgput : "${throughput}"MB/s"

rm -rf /mnt/lustre/tt7*
iter=6
output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`
echo "("${iter}")-Throuhgput : "${throughput}"MB/s"

rm -rf /mnt/lustre/tt8*
iter=7
output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`
echo "("${iter}")-Throuhgput : "${throughput}"MB/s"

rm -rf /mnt/lustre/tt9*
iter=8
output=`fio --directory=${directory} --name=tt${iter} --rw=write --direct=0 --bs=1M --size=${bsize} --numjobs=${numjobs} --group_reporting --fallocate=none --readwrite=randwrite`
throughput=`awk -F 'all jobs'  '{print $2}'  <<< $output | cut -d'(' -f2 | cut -d'M' -f1`
echo "("${iter}")-Throuhgput : "${throughput}"MB/s"

done

echo "FIO step 2 - DONE"

# FLYER - end command
sleep 2
#echo 1 > ${sig_dir}/flyer1
#echo 1 > ${sig_dir}/flyer2
#echo 1 > ${sig_dir}/flyer3
#sleep 2

#waf1=`cat ${sig_dir}/result-waf1` && rm -rf ${sig_dir}/result-waf1
#waf2=`cat ${sig_dir}/result-waf2` && rm -rf ${sig_dir}/result-waf2
#waf3=`cat ${sig_dir}/result-waf3` && rm -rf ${sig_dir}/result-waf3
#echo "WAF : "${waf1}" "${waf2}" "${waf3}
