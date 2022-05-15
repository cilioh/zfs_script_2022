#!/bin/bash

if [[ ${1} == "cn" ]]; then

#        for cli in "cn7" "cn8" "cn9" "cn10"
	for cli in "cn8"
        do
                ssh $cli 'umount /mnt/lustre'
                ssh $cli 'modprobe -r lustre'
                ssh $cli 'lctl network down'
                ssh $cli 'lustre_rmmod'
                ssh $cli 'modprobe -r lnet'
                echo "${cli} - lustreFS DOWN"
        done

#	umount /mnt/lustre
#	modprobe -r lustre
#	lctl network down
#	lustre_rmmod
#	modprobe -r lnet
#	echo "client - FS Down"
fi

if [[ ${1} =~ "oss" ]]; then

	if [[ ${1} == "oss1" ]]; then

		for ostnum in {0..3}; do
			umount /lustre/ost${ostnum}
			zpool destroy ost${ostnum}
		done
	fi
	if [[ ${1} == "oss2" ]]; then

		for ostnum in {5..8}; do
			umount /lustre/ost${ostnum}
			zpool destroy ost${ostnum}
		done
	fi
	if [[ ${1} == "oss3" ]]; then

		for ostnum in {9..12}; do
			umount /lustre/ost${ostnum}
			zpool destroy ost${ostnum}
		done
	fi

        modprobe -r lustre
	lctl network down
        lustre_rmmod
	systemctl kill zfs-zed
	modprobe -r zfs
        modprobe -r lnet
        echo "${oss} - lustreFS DOWN"
fi

if [[ ${1} == "cn12" ]]; then
	for ostnum in {13..16}; do
		umount /lustre/ost${ostnum}
		zpool destroy ost${ostnum}
	done
        modprobe -r lustre
	lctl network down
        lustre_rmmod
	systemctl kill zfs-zed
	modprobe -r zfs
        modprobe -r lnet
        echo "${oss} - lustreFS DOWN"
fi

if [[ ${1} == "mdt" ]]; then

	umount /lustre/mdt
	zpool destroy mdt
	modprobe -r lustre
	lctl network down
	lustre_rmmod
	systemctl kill zfs-zed
	modprobe -r zfs
	modprobe -r lnet

	echo "MDT - lustreFS DOWN"
fi
