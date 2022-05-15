#!/bin/bash

sig_dir="/mnt/share/cykim/signal"

for ss in 1 2 3 4 5 6 8 16 32 64 128
do
	echo $ss > ${sig_dir}/setstripe
	sleep 0.1

	lfs setstripe -c ${ss} /mnt/lustre
	
	# mc
	ssh cn8 'lfs setstripe -c '${ss}' /mnt/lustre'
	ssh cn9 'lfs setstripe -c '${ss}' /mnt/lustre'
	ssh cn10 'lfs setstripe -c '${ss}' /mnt/lustre'

	lfs getstripe -d /mnt/lustre

	sh /root/lustre-compute/nvme-log.sh

	sleep 3
	lfs setstripe -c 128 /mnt/lustre
	rm -rf /mnt/lustre/tttt1*
	sleep 5s

	rm -rf /mnt/lustre/ttta*
	rm -rf /mnt/lustre/tttb*
	rm -rf /mnt/lustre/tttc*
	sleep 2s

	rm -rf /mnt/lustre/tttt7*
	sleep 5s

	fio --directory=/mnt/lustre --name=tttt7 --rw=write --direct=0 --bs=1M --size=32G --numjobs=16 --group_reporting --fallocate=none | awk '$1=="WRITE" { print $3 }'
	sleep 5s
done
