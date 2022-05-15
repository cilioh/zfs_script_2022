#!/bin/bash
sig_dir="/mnt/share/cykim/signal"

echo 3 > /proc/sys/vm/drop_caches
sleep 5

echo "ON" > ${sig_dir}/termall

#PM node WAF calculator ON
/mnt/share/cykim/backup/waf_monitor_raw.sh 1 &

echo "" > /mnt/share/cykim/result/pm_waf1.txt

#Loop
for stripe in 1
do
	echo "ON" > ${sig_dir}/breaksig
	sleep 1

	#Terminate Timer - 60 minutes
	#Placeholder on pm_waf#.txt
	echo "Timer ON"
	/mnt/share/cykim/backup/60min_timer.sh ${stripe} &
	sleep 1

	#FIO - Record Throughput & Latency
	sh /mnt/share/cykim/backup/load_stress_gc.sh 256MB 16 CN8 banana ${stripe} &
	sh /mnt/share/cykim/backup/load_stress_gc.sh 1G 16 CN9 citrus ${stripe} &
	sh /mnt/share/cykim/backup/load_stress_gc.sh 4G 16 CN10 dragonfruit ${stripe} &
	sh /mnt/share/cykim/backup/load_stress_gc.sh 64MB 16 CN7 apple ${stripe} &

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
	sleep 1200

	echo 3 > /proc/sys/vm/drop_caches
done
#Loop END

echo "OFF" > ${sig_dir}/termall
echo "WORKLOAD ALL DONE"

cat /mnt/share/cykim/result/pm_waf1.txt >> /mnt/share/cykim/result/backup/raw/pm_waf1.txt
cat /mnt/share/cykim/result/gc_throughputCN7.txt >> /mnt/share/cykim/result/backup/raw/gc_throughputCN7.txt
cat /mnt/share/cykim/result/gc_throughputCN8.txt >> /mnt/share/cykim/result/backup/raw/gc_throughputCN8.txt
cat /mnt/share/cykim/result/gc_throughputCN9.txt >> /mnt/share/cykim/result/backup/raw/gc_throughputCN9.txt
cat /mnt/share/cykim/result/gc_throughputCN10.txt >> /mnt/share/cykim/result/backup/raw/gc_throughputCN10.txt

#sh /mnt/share/cykim/git-push.sh
exit 0
