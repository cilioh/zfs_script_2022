#!/bin/bash

directory="/mnt/lustre"
sig_dir="/mnt/share/cykim/signal"
nodename="CN7"
filename="apple"
todaydate=`date "+%m%d"`
todaytime=`date "+%H%M"`
SECONDS=0
experiment="1"

mkdir -p /mnt/share/cykim/result/${todaydate}
echo ${todaydate}"-"${todaytime} > /mnt/share/cykim/result/${todaydate}/Result_${todaytime}_${nodename}.txt

#OSS maximum IO size change
ssh pm1 'lctl set_param obdfilter.lustre-OST*.brw_size=16'

for osc_maxpages in "2048" "4096"
#for osc_maxpages in "64" "128" "256" "512" "1024" "2048" "4096"
do

lctl set_param osc.lustre-OST*.max_pages_per_rpc=${osc_maxpages}
sleep 2

for osc_maxflight in "1" "4" "8" "16"
do

lctl set_param osc.lustre-OST*.max_rpcs_in_flight=${osc_maxflight}
sleep 2

for xfersize in "1M"
#for xfersize in "1M" "4M" "16M"
do

	case $xfersize in
		"1M")   blsize1="1M"
			blsize2="2M"
			blsize3="4M"
			blsize4="8M";;
		"4M")   blsize1="4M"
			blsize2="8M"
			blsize3="16M"
			blsize4="32M";;
		"16M")  blsize1="16M"
			blsize2="32M"
			blsize3="64M"
			blsize4="128M";;
	esac
	for blocksize in "1M"
#	for blocksize in $blsize1 $blsize2 $blsize3 $blsize4
	do

		for bsize in "4G" "8G" "16G" "32G"
		do

		#	for numjobs in "4"
			for numjobs in "1" "2" "4" "8"
			do

		#		for stripecount in "12"
				for stripecount in "4"
				do

					lfs setstripe -C ${stripecount} /mnt/lustre
		#			lfs setstripe -S ${xfersize} /mnt/lustre
		#			lfs setstripe -o 1 /mnt/lustre

#					for iter in {1..2}
					for iter in {1..3}
					do
						rm -rf /mnt/lustre/*
						sleep 5

						echo 3 > /proc/sys/vm/drop_caches
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

						/mnt/share/cykim/backup/fio_script.sh ${bsize} ${numjobs} ${nodename} ${filename} ${stripecount} ${todaydate} ${todaytime} ${iter} ${directory} ${blocksize} ${xfersize} ${experiment} ${osc_maxpages} ${osc_maxflight}

						/mnt/share/cykim/backup/result_iostat_save.sh ${todaydate} ${todaytime} ${nodename} ${experiment}


						totval=`lfs df -h | awk '$1=="filesystem_summary:" { print $5 }' | grep -oP '\d+'`
						if [ $totval -ge 98 ]; then
							echo " LUSTRE storage 98% FULL --- EMPTY "
							rm -rf ${directory}/${filename}*
							echo "-"
						fi
					done
				done
			done
		done
	done
done

#osc lctl param
done
done

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed. SCRIPT DONE"

exit 0
