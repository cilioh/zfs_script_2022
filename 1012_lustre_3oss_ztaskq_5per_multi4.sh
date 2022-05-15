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
echo ${todaydate}"-"${todaytime} > /mnt/share/cykim/result/${todaydate}/Result_${todaytime}_CN7.txt
echo ${todaydate}"-"${todaytime} > /mnt/share/cykim/result/${todaydate}/Result_${todaytime}_CN8.txt
echo ${todaydate}"-"${todaytime} > /mnt/share/cykim/result/${todaydate}/Result_${todaytime}_CN9.txt
echo ${todaydate}"-"${todaytime} > /mnt/share/cykim/result/${todaydate}/Result_${todaytime}_CN10.txt

# parameter change here!
for xfersize in "1M"
do
	for blocksize in "1M"
	do
		for bsize in "32G"
		do
			for numjobs in "1" "2" "4" "8" "16"
			do
				for stripecount in "12"
				do
					rm -rf /mnt/lustre/*
					sleep 10

					lfs setstripe -C ${stripecount} /mnt/lustre

					for nodes in "CN8" "CN9" "CN10"  #"CN11" "CN12"
					do
						ssh $nodes "lfs setstripe -C "${stripecount}" /mnt/lustre"
					done

					for iter in {1..3}  #iteration
					do
						rm -rf /mnt/lustre/*
						sleep 5

						echo 3 > /proc/sys/vm/drop_caches
						echo "OFF" > ${sig_dir}/CN7
						for nodes in "CN8" "CN9" "CN10"  #"CN11" "CN12"
						do
							#ssh $nodes 'echo 3 > /proc/sys/vm/drop_caches'
							echo "OFF" > ${sig_dir}/${nodes}
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

						/mnt/share/cykim/backup/fio_script.sh ${bsize} ${numjobs} ${nodename} ${filename} ${stripecount} ${todaydate} ${todaytime} ${iter} ${directory} ${blocksize} ${xfersize} ${experiment} &
						ssh cn8 "/mnt/share/cykim/backup/fio_script.sh" ${bsize} ${numjobs} "CN8" "banana" ${stripecount} ${todaydate} ${todaytime} ${iter} ${directory} ${blocksize} ${xfersize} ${experiment} &
						ssh cn9 "/mnt/share/cykim/backup/fio_script.sh" ${bsize} ${numjobs} "CN9" "citrus" ${stripecount} ${todaydate} ${todaytime} ${iter} ${directory} ${blocksize} ${xfersize} ${experiment} &
						ssh cn10 "/mnt/share/cykim/backup/fio_script.sh" ${bsize} ${numjobs} "CN10" "dragon" ${stripecount} ${todaydate} ${todaytime} ${iter} ${directory} ${blocksize} ${xfersize} ${experiment}
						while true
						do
							msg=`cat ${sig_dir}/CN9`
							if [[ $msg == "ON" ]]; then
							msg=`cat ${sig_dir}/CN8`
							if [[ $msg == "ON" ]]; then
							msg=`cat ${sig_dir}/CN7`
							if [[ $msg == "ON" ]]; then
								break
							fi
							fi
							fi
							sleep 1
						done

						/mnt/share/cykim/backup/result_iostat_save.sh ${todaydate} ${todaytime} "CN7" ${experiment}
						/mnt/share/cykim/backup/result_iostat_save.sh ${todaydate} ${todaytime} "CN8" ${experiment}
						/mnt/share/cykim/backup/result_iostat_save.sh ${todaydate} ${todaytime} "CN9" ${experiment}
						/mnt/share/cykim/backup/result_iostat_save.sh ${todaydate} ${todaytime} "CN10" ${experiment}

						totval=`lfs df -h | awk '$1=="filesystem_summary:" { print $5 }' | grep -oP '\d+'`
						if [ $totval -ge 98 ]; then
							echo " LUSTRE storage 98% FULL --- EMPTY "
							rm -rf ${directory}/${filename}*
						fi
					done
				done
			done
		done
	done
done

duration=$SECONDS
echo "$(($duration / 3600)) hours, $(($duration % 3600 / 60)) minutes, and $(($duration % 60)) seconds elapsed. SCRIPT DONE"
exit 0
