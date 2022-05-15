#!/bin/bash
sig_dir="/mnt/share/cykim/signal"
folder="0525"

echo 3 > /proc/sys/vm/drop_caches
ssh pm1 'echo 3 > /proc/sys/vm/drop_caches'
ssh pm2 'echo 3 > /proc/sys/vm/drop_caches'
ssh pm3 'echo 3 > /proc/sys/vm/drop_caches'
sleep 5

echo "ON" > ${sig_dir}/termall

#PM node WAF calculator ON
ssh pm1 'sh /mnt/share/cykim/backup/waf_monitor_pm.sh 1' &
ssh pm2 'sh /mnt/share/cykim/backup/waf_monitor_pm.sh 2' &
ssh pm3 'sh /mnt/share/cykim/backup/waf_monitor_pm.sh 3' &

echo "" > /mnt/share/cykim/result/pm_waf1.txt
echo "" > /mnt/share/cykim/result/pm_waf2.txt
echo "" > /mnt/share/cykim/result/pm_waf3.txt

#Loop
for stripe in 1 6 48
do
	for bsize in "16GB" "64GB"
	do

	# FILL up the tank
#	fio --directory=/mnt/lustre --name=preset --rw=write --direct=0 --bs=1M --size=5369690464KB --numjobs=1 --group_reporting --fallocate=none
#	sleep 10
#	rm -rf /mnt/lustre/preset*
#	sleep 10

	echo "ON" > ${sig_dir}/breaksig
	sleep 1

	#Set Stripe Count
	echo "SET Stripe Count as : "${stripe}
	lfs setstripe -c ${stripe} /mnt/lustre
	sleep 1

	#Terminate Timer - 60 minutes
	#Placeholder on pm_waf#.txt
	echo "Timer ON"
	/mnt/share/cykim/backup/60min_timer.sh ${stripe} &
	sleep 1

	#FIO - Record Throughput & Latency
#	sh /mnt/share/cykim/backup/load_stress_gc.sh 256MB 16 CN8 banana ${stripe} &
#	sh /mnt/share/cykim/backup/load_stress_gc.sh 1G 16 CN9 citrus ${stripe} &
#	sh /mnt/share/cykim/backup/load_stress_gc.sh 4G 16 CN10 dragonfruit ${stripe} &
	sh /mnt/share/cykim/backup/load_stress_gc.sh ${bsize} 16 CN7 apple ${stripe} &

	#Wait for 60 minutes
	while true
	do
		msgc=`cat /mnt/share/cykim/signal/breaksig`
		if [[ $msgc == "OFF" ]]; then
			break
		fi
		sleep 5
	done

	echo "**************"
	echo ""
	echo "Stripe Count : "${stripe}" DONE !"
	echo ""
	echo "**************"
	sleep 60

	echo 3 > /proc/sys/vm/drop_caches
	ssh pm1 'echo 3 > /proc/sys/vm/drop_caches'
	ssh pm2 'echo 3 > /proc/sys/vm/drop_caches'
	ssh pm3 'echo 3 > /proc/sys/vm/drop_caches'

	rm -rf /mnt/lustre/apple*
	sleep 10
	done
done
#Loop END

echo "OFF" > ${sig_dir}/termall
echo "WORKLOAD ALL DONE"

cat /mnt/share/cykim/result/pm_waf1.txt >> /mnt/share/cykim/result/${folder}/pm_waf1.txt
cat /mnt/share/cykim/result/pm_waf2.txt >> /mnt/share/cykim/result/${folder}/pm_waf2.txt
cat /mnt/share/cykim/result/pm_waf3.txt >> /mnt/share/cykim/result/${folder}/pm_waf3.txt
cat /mnt/share/cykim/result/gc_throughputCN7.txt >> /mnt/share/cykim/result/${folder}/gc_throughputCN7.txt
#cat /mnt/share/cykim/result/gc_throughputCN8.txt >> /mnt/share/cykim/result/backup/raw/gc_throughputCN8.txt
#cat /mnt/share/cykim/result/gc_throughputCN9.txt >> /mnt/share/cykim/result/backup/raw/gc_throughputCN9.txt
#cat /mnt/share/cykim/result/gc_throughputCN10.txt >> /mnt/share/cykim/result/backup/raw/gc_throughputCN10.txt

#sh /mnt/share/cykim/git-push.sh
exit 0
