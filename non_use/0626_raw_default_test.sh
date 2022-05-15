#!/bin/bash

directory="/mnt/local"
sig_dir="/mnt/share/cykim/signal"
nodename="PM2"
filename="apple"
todaydate=`date "+%m%d"`
todaytime=`date "+%H%M"`
SECONDS=0

mkdir -p /mnt/share/cykim/result/${todaydate}
echo ${todaydate}"-"${todaytime} > /mnt/share/cykim/result/${todaydate}/Result_${todaytime}_PM2.txt

#for bsize in "16G"
for bsize in "4G" "8G" "16G" "32G"
do
#	for numjobs in "4"
	for numjobs in "1" "2" "4" "8" "16" "32"
	do
		for stripecount in "1"
#		for stripecount in "1" "2" "4" "8" "16" "32" "64"
		do
#			lfs setstripe -C ${stripecount} /mnt/lustre
#			for iter in {1..2}
			for iter in {1..5}
			do
				rm -rf /mnt/local/*
				sleep 5

				echo 3 > /proc/sys/vm/drop_caches
#				ssh pm1 'echo 3 > /proc/sys/vm/drop_caches'
				sleep 1

				#iostat initiate
#				ssh pm1 'iostat -d nvme0n1 nvme1n1 nvme2n1 nvme3n1 -c 1 | grep nvme > /mnt/share/cykim/result/output1' &
				ssh pm2 'iostat -d nvme0n1 nvme1n1 nvme2n1 nvme3n1 -c 1 | grep nvme > /mnt/share/cykim/result/output2' &
#				ssh pm3 'iostat -d nvme0n1 nvme1n1 nvme2n1 nvme3n1 -c 1 | grep nvme > /mnt/share/cykim/result/output3' &

				echo "Block Size:"${bsize}" NumJobs:"${numjobs}" iter-"${iter}
				/mnt/share/cykim/backup/fio_script.sh ${bsize} ${numjobs} ${nodename} ${filename} ${stripecount} ${todaydate} ${todaytime} ${iter}

				/mnt/share/cykim/backup/result_iostat_save.sh ${todaydate} ${todaytime} ${nodename}

				#totval=`lfs df -h | awk '$1=="filesystem_summary:" { print $5 }' | grep -oP '\d+'`
				totval=`df -h | grep /dev/md0 | awk '{ print $5 }' | grep -oP '\d+'`
				if [ $totval -ge 98 ]; then
					echo " RAW storage 98% FULL --- EMPTY "
					rm -rf ${directory}/${filename}*
					echo "-"
				fi
			done
		done
	done
done

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed. SCRIPT DONE"

exit 0
