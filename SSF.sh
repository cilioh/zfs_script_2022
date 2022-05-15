#!/bin/bash

directory="/mnt/lustre"
sig_dir="/mnt/share/cykim/signal"
nodename="CN7"
filename="apple"
todaydate=`date "+%m%d"`
todaytime=`date "+%H%M"`
SECONDS=0
experiment="123"

mkdir -p /mnt/share/cykim/result/${todaydate}
echo ${todaydate}"-"${todaytime} > /mnt/share/cykim/result/${todaydate}/Result_${todaytime}_${nodename}.txt

for xfersize in "1M"
do
#	for blocksize in "1M"
#	do
#		for bsize in "8G"
		for bsize in "1M"
		do
			#for numjobs in "16"
			#for numjobs in "1" "2" "4" "8" "16" "32" "64" "128"
			#for numjobs in "4" "8" "16" "32" "64" "128" "256" "512"
			for numjobs in "4"
			do

#				for stripecount in "12"
#				do
					lfs setstripe -S ${bsize} -C ${numjobs} /mnt/lustre
					#lfs setstripe -S ${bsize} -c 1 /mnt/lustre

					for iter in {1..1}
					do
						rm -rf /mnt/lustre/*
						sleep 5

						echo 3 > /proc/sys/vm/drop_caches
						for nodes in "CN8" "CN9" "CN10"
						do
							ssh $nodes 'echo 3 > /proc/sys/vm/drop_caches'
							sleep 1
						done
						if [[ $experiment =~ "1" ]]; then
							ssh pm1 'echo 3 > /proc/sys/vm/drop_caches'
							sleep 1
						fi
						if [[ $experiment =~ "2" ]]; then
							ssh pm2 'echo 3 > /proc/sys/vm/drop_caches'
							sleep 1
						fi
						if [[ $experiment =~ "3" ]]; then
							ssh pm3 'echo 3 > /proc/sys/vm/drop_caches'
							sleep 1
						fi
						if [[ $experiment =~ "4" ]]; then
							ssh pm4 'echo 3 > /proc/sys/vm/drop_caches'
							sleep 1
						fi

						#iostat initiate
						if [[ $experiment =~ "1" ]]; then
							ssh pm1 'iostat -d nvme0n1 nvme1n1 nvme2n1 nvme3n1 -c 1 | grep nvme > /mnt/share/cykim/result/output1' &
						fi
						if [[ $experiment =~ "2" ]]; then
							ssh pm2 'iostat -d nvme0n1 nvme1n1 nvme2n1 nvme3n1 -c 1 | grep nvme > /mnt/share/cykim/result/output2' &
						fi
						if [[ $experiment =~ "3" ]]; then
							ssh pm3 'iostat -d nvme0n1 nvme1n1 nvme2n1 nvme3n1 -c 1 | grep nvme > /mnt/share/cykim/result/output3' &
						fi
						if [[ $experiment =~ "4" ]]; then
							ssh pm4 'iostat -d nvme1n1 nvme2n1 nvme3n1 nvme4n1 -c 1 | grep nvme > /mnt/share/cykim/result/output4' &
						fi

						/usr/local/bin/mpirun --host cn7,cn8,cn9,cn10 -np ${numjobs} ior -w -t=${xfersize} -b=${bsize} -o /mnt/lustre/apple -k
						#/mnt/share/cykim/backup/fio_script.sh ${bsize} ${numjobs} ${nodename} ${filename} ${stripecount} ${todaydate} ${todaytime} ${iter} ${directory} ${blocksize} ${xfersize} ${experiment}

						#/mnt/share/cykim/backup/result_iostat_save.sh ${todaydate} ${todaytime} ${nodename} ${experiment}

						#totval=`lfs df -h | awk '$1=="filesystem_summary:" { print $5 }' | grep -oP '\d+'`
						#if [ $totval -ge 98 ]; then
						#	echo " LUSTRE storage 98% FULL --- EMPTY "
						#	rm -rf ${directory}/${filename}*
						#	echo "-"
						#fi
					done
				done
			done
		done
	done
done

duration=$SECONDS
echo "$(($duration / 3600)) hours, $(($duration % 3600 / 60)) minutes, and $(($duration % 60)) seconds elapsed. SCRIPT DONE"
exit 0
