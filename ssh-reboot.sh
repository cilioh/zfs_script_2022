#!/bin/bash

if [[ ${1} == "cn" ]]; then

        for cli in "cn7" "cn8" "cn9" "cn10"
        do
                ssh $cli 'umount /mnt/lustre'
                ssh $cli 'modprobe -r lustre'
                ssh $cli 'lctl network down'
                ssh $cli 'lustre_rmmod'
                ssh $cli 'modprobe -r lnet'
                echo "${cli} - lustreFS DOWN"
        done
fi

if [[ ${1} =~ "oss" ]]; then

	if [[ ${1} == "oss1" ]]; then

		for ostnum in {0..3}; do
			ssh pm1 'umount /lustre/ost'${ostnum}
			ssh pm1 'zpool destroy ost'${ostnum}
		done
		pms="pm1"
	fi
	if [[ ${1} == "oss2" ]]; then

		for ostnum in {5..8}; do
			ssh pm2 'umount /lustre/ost'${ostnum}
			ssh pm2 'zpool destroy ost'${ostnum}
		done
		pms="pm2"
	fi
	if [[ ${1} == "oss3" ]]; then

		for ostnum in {9..12}; do
			ssh pm3 'umount /lustre/ost'${ostnum}
			ssh pm3 'zpool destroy ost'${ostnum}
		done
		pms="pm3"
	fi

#	for pms in "pm1" "pm2" "pm3"
#	do
        	ssh $pms 'modprobe -r lustre'
		ssh $pms 'lctl network down'
        	ssh $pms 'lustre_rmmod'
		ssh $pms 'systemctl kill zfs-zed'
		ssh $pms 'modprobe -r zfs'
        	ssh $pms 'modprobe -r lnet'
        	echo "${pms} - lustreFS DOWN"
		sleep 1
		ssh $pms 'modprobe -r zfs'
#	done	
fi

if [[ ${1} == "mdt" ]]; then

	ssh mds2 'umount /lustre/mdt'
	ssh mds2 'zpool destroy mdt'
	ssh mds2 'modprobe -r lustre'
	ssh mds2 'lctl network down'
	ssh mds2 'lustre_rmmod'
	ssh mds2 'systemctl kill zfs-zed'
	ssh mds2 'modprobe -r zfs'
	ssh mds2 'modprobe -r lnet'

	echo "MDT - lustreFS DOWN"
fi
