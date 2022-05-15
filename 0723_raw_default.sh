#!/bin/bash

directory="/mnt/nvme"
sig_dir="/mnt/share/cykim/signal"
nodename="PM1"
filename="apple"
todaydate=`date "+%m%d"`
todaytime=`date "+%H%M"`
SECONDS=0

mkdir -p /mnt/share/cykim/result/${todaydate}
echo ${todaydate}"-"${todaytime} > /mnt/share/cykim/result/${todaydate}/Result_${todaytime}_${nodename}.txt

for xfersize in "1M"
do
	for blocksize in "1M"
	do
		for bsize in "4G" "8G" "16G" "32G"
		do
			for numjobs in "1" "2" "4" "8" "16"
			do
				for iter in {1..5}
				do
					rm -rf /mnt/nvme/*
					sleep 5

					echo 3 > /proc/sys/vm/drop_caches

					/mnt/share/cykim/backup/fio_script_raw.sh ${bsize} ${numjobs} ${nodename} ${filename} ${todaydate} ${todaytime} ${iter} ${directory} ${blocksize} ${xfersize}

					/mnt/share/cykim/backup/result_iostat_save.sh ${todaydate} ${todaytime} ${nodename} 4

#					totval=`df -h | awk '$1=="/dev/nvme0n1" { print $5 }' | grep -oP '\d+'`
					totval=`df -h | awk '$1=="nvme/nvme0" { print $5 }' | grep -oP '\d+'`
					if [ $totval -ge 98 ]; then
						echo " Storage 98% FULL --- EMPTY "
						rm -rf ${directory}/${filename}*
						echo "-"
					fi
				done
			done
		done
	done
done

duration=$SECONDS
echo "$(($duration / 3600)) hours, $(($duration % 3600 / 60)) minutes, and $(($duration % 60)) seconds elapsed. SCRIPT DONE"

exit 0
