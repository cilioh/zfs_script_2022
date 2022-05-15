#!/bin/bash

mdsname="cn9e"

echo "mdt / oss1 / cn"

if [[ $1 == "cn" ]]; then

	/mnt/share/cykim/backup/ptlrpcd_start_insmod.sh
fi

modprobe lustre

sleep 2

if [[ $1 =~ "oss" ]]; then

	#/mnt/share/cykim/backup/zfs_start_insmod.sh $2 $3 $4 $5 $6
	/mnt/share/cykim/backup/zfs_start_insmod.sh
	#insmod /usr/lib/modules/3.10.0-1062.1.1.el7_cgr2.x86_64/extra/zfs/zfs/zfs.ko cksum_zio_taskq_batch_pct=75 zio_taskq_batch_pct=75 zio_opt=1
	#modprobe zfs
	sleep 2
elif [[ $1 = "cn12" ]]; then

	#/mnt/share/cykim/backup/zfs_start_insmod.sh $2 $3 $4 $5 $6
	/mnt/share/cykim/backup/zfs_start_insmod.sh
	#modprobe zfs
	sleep 2

elif [[ $1 == "mdt" ]]; then

	modprobe zfs
	sleep 2
fi

modprobe lnet
sleep 2

lctl lustre_build_version
sleep 2

lctl network configure
sleep 2

lnetctl net add --net o2ib --if ib0
sleep 2

if [[ $1 == "cn12" ]]; then
	lnetctl net del --net o2ib1 --if ib1
	lnetctl net add --net tcp --if em2
fi

if [[ $1 == "cn" ]]; then
	lnetctl net del --net o2ib1
	lnetctl net add --net tcp --if em2
fi

if [[ $1 == "mdt" ]]; then
	lnetctl net del --net o2ib1
	lnetctl net add --net tcp --if em2
fi





sleep 2

if [[ $1 == "mdt" ]]; then

	if [[ $mdsname == "mds2e" ]]; then
		mkfs.lustre --mdt --mgs --fsname=lustre --backfstype=zfs --reformat --index=0 mdt/mdt0 /dev/sdc
	else
		mkfs.lustre --mdt --mgs --fsname=lustre --backfstype=zfs --reformat --index=0 mdt/mdt0 /dev/nvme0n1
	fi

	sleep 5

	mkdir -p /lustre/mdt
	mount -t lustre mdt/mdt0 /lustre/mdt
	df -h
fi

if [[ $1 == "md0" ]]; then


	mkfs.lustre --ost --backfstype=zfs --index=1 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost0/ost0 /dev/md0
	sleep 2

	mount -t lustre ost0/ost0 /lustre/ost0
	mount -t lustre ost0/ost0 /lustre/ost0
	df -h
fi

if [[ $1 == "oss1" ]]; then

	mkfs.lustre --ost --backfstype=zfs --index=1 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost0/ost0 /dev/nvme0n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=2 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost1/ost1 /dev/nvme1n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=3 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost2/ost2 /dev/nvme2n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=4 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost3/ost3 /dev/nvme3n1
	sleep 2

#mkfs.lustre --ost --backfstype=zfs --index=1 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost4/ost4 nvme0n1 nvme1n1 nvme2n1 nvme3n1
#mkfs.lustre --ost --backfstype=zfs --index=1 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost4/ost4 md0
#sleep 2

	mount -t lustre ost0/ost0 /lustre/ost0
	mount -t lustre ost1/ost1 /lustre/ost1
	mount -t lustre ost2/ost2 /lustre/ost2
	mount -t lustre ost3/ost3 /lustre/ost3
#mount -t lustre ost4/ost4 /lustre/ost4

	mount -t lustre ost0/ost0 /lustre/ost0
	mount -t lustre ost1/ost1 /lustre/ost1
	mount -t lustre ost2/ost2 /lustre/ost2
	mount -t lustre ost3/ost3 /lustre/ost3
#mount -t lustre ost4/ost4 /lustre/ost4
	df -h
fi

if [[ $1 == "oss2" ]]; then

	#mkfs.lustre --ost --backfstype=zfs --index=5 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost5/ost5 mirror /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
	mkfs.lustre --ost --backfstype=zfs --index=5 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost5/ost5 /dev/nvme0n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=6 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost6/ost6 /dev/nvme1n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=7 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost7/ost7 /dev/nvme2n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=8 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost8/ost8 /dev/nvme3n1
	sleep 2

	mount -t lustre ost5/ost5 /lustre/ost5
	mount -t lustre ost6/ost6 /lustre/ost6
	mount -t lustre ost7/ost7 /lustre/ost7
	mount -t lustre ost8/ost8 /lustre/ost8

	mount -t lustre ost5/ost5 /lustre/ost5
	mount -t lustre ost6/ost6 /lustre/ost6
	mount -t lustre ost7/ost7 /lustre/ost7
	mount -t lustre ost8/ost8 /lustre/ost8
	df -h
fi

if [[ $1 == "oss3" ]]; then

	mkfs.lustre --ost --backfstype=zfs --index=9 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost9/ost9 /dev/nvme0n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=10 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost10/ost10 /dev/nvme1n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=11 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost11/ost11 /dev/nvme2n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=12 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost12/ost12 /dev/nvme3n1
	sleep 2

	mount -t lustre ost9/ost9 /lustre/ost9
	mount -t lustre ost10/ost10 /lustre/ost10
	mount -t lustre ost11/ost11 /lustre/ost11
	mount -t lustre ost12/ost12 /lustre/ost12

	mount -t lustre ost9/ost9 /lustre/ost9
	mount -t lustre ost10/ost10 /lustre/ost10
	mount -t lustre ost11/ost11 /lustre/ost11
	mount -t lustre ost12/ost12 /lustre/ost12
	df -h
fi

if [[ $1 == "cn12" ]]; then

	mkfs.lustre --ost --backfstype=zfs --index=13 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost13/ost13 /dev/nvme0n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=14 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost14/ost14 /dev/nvme1n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=15 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost15/ost15 /dev/nvme2n1
	sleep 2
	mkfs.lustre --ost --backfstype=zfs --index=16 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre ost16/ost16 /dev/nvme3n1
	sleep 2

	mount -t lustre ost13/ost13 /lustre/ost13
	mount -t lustre ost14/ost14 /lustre/ost14
	mount -t lustre ost15/ost15 /lustre/ost15
	mount -t lustre ost16/ost16 /lustre/ost16

	mount -t lustre ost13/ost13 /lustre/ost13
	mount -t lustre ost14/ost14 /lustre/ost14
	mount -t lustre ost15/ost15 /lustre/ost15
	mount -t lustre ost16/ost16 /lustre/ost16
	df -h
fi


if [[ $1 == "cn" ]]; then

	mount -t lustre ${mdsname}@o2ib:/lustre /mnt/lustre
	sleep 3
	chmod 777 /mnt/lustre
	sleep 2
	lfs df -h
fi

exit 0
