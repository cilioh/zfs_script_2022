#!/bin/bash

mdsname="cn9e"

echo "mdt / oss1 / cn"

modprobe lustre
sleep 2

modprobe lnet
sleep 2

lctl lustre_build_version
sleep 2

lctl network configure
sleep 2

lnetctl net add --net o2ib --if ib0
sleep 2


if [[ $1 == "mdt" ]]; then
	lnetctl net del --net o2ib1
	lnetctl net add --net tcp --if em2
fi

if [[ $1 == "cn" ]]; then
	lnetctl net del --net o2ib1
	lnetctl net add --net tcp --if em2
fi

if [[ $1 == "mdt" ]]; then
	mkfs.lustre --mdt --mgs --fsname=lustre --backfstype=ldiskfs --reformat --index=0 /dev/nvme0n1
	sleep 5

	mkdir -p /lustre/mdt
	mount -t lustre /dev/nvme0n1 /lustre/mdt
	df -h
fi
if [[ $1 == "oss1" ]]; then

	mkfs.lustre --ost --backfstype=ldiskfs --index=1 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme0n1
	sleep 2
	mkfs.lustre --ost --backfstype=ldiskfs --index=2 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme1n1
	sleep 2
	mkfs.lustre --ost --backfstype=ldiskfs --index=3 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme2n1
	sleep 2
	mkfs.lustre --ost --backfstype=ldiskfs --index=4 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme3n1
	sleep 2

	mount -t lustre /dev/nvme0n1 /lustre/ost0
	mount -t lustre /dev/nvme1n1 /lustre/ost1
	mount -t lustre /dev/nvme2n1 /lustre/ost2
	mount -t lustre /dev/nvme3n1 /lustre/ost3

	mount -t lustre /dev/nvme0n1 /lustre/ost0
	mount -t lustre /dev/nvme1n1 /lustre/ost1
	mount -t lustre /dev/nvme2n1 /lustre/ost2
	mount -t lustre /dev/nvme3n1 /lustre/ost3
	df -h
fi
if [[ $1 == "oss11" ]]; then

	mkfs.lustre --ost --backfstype=ldiskfs --index=1 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme0n1
	sleep 2

	mount -t lustre /dev/nvme0n1 /lustre/ost0
	mount -t lustre /dev/nvme0n1 /lustre/ost0
	df -h
fi
if [[ $1 == "oss2" ]]; then

	mkfs.lustre --ost --backfstype=ldiskfs --index=5 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme0n1
	sleep 2
	mkfs.lustre --ost --backfstype=ldiskfs --index=6 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme1n1
	sleep 2
	mkfs.lustre --ost --backfstype=ldiskfs --index=7 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme2n1
	sleep 2
	mkfs.lustre --ost --backfstype=ldiskfs --index=8 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme3n1
	sleep 2

	mount -t lustre /dev/nvme0n1 /lustre/ost0
	mount -t lustre /dev/nvme1n1 /lustre/ost1
	mount -t lustre /dev/nvme2n1 /lustre/ost2
	mount -t lustre /dev/nvme3n1 /lustre/ost3

	mount -t lustre /dev/nvme0n1 /lustre/ost0
	mount -t lustre /dev/nvme1n1 /lustre/ost1
	mount -t lustre /dev/nvme2n1 /lustre/ost2
	mount -t lustre /dev/nvme3n1 /lustre/ost3
	df -h
fi
if [[ $1 == "oss21" ]]; then

	mkfs.lustre --ost --backfstype=ldiskfs --index=1 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme0n1
	sleep 2

	mount -t lustre /dev/nvme0n1 /lustre/ost0
	mount -t lustre /dev/nvme0n1 /lustre/ost0
	df -h
fi
if [[ $1 == "oss3" ]]; then

	mkfs.lustre --ost --backfstype=ldiskfs --index=9 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme0n1
	sleep 2
	mkfs.lustre --ost --backfstype=ldiskfs --index=10 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme1n1
	sleep 2
	mkfs.lustre --ost --backfstype=ldiskfs --index=11 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme2n1
	sleep 2
	mkfs.lustre --ost --backfstype=ldiskfs --index=12 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme3n1
	sleep 2

	mount -t lustre /dev/nvme0n1 /lustre/ost9
	mount -t lustre /dev/nvme1n1 /lustre/ost10
	mount -t lustre /dev/nvme2n1 /lustre/ost11
	mount -t lustre /dev/nvme3n1 /lustre/ost12

	mount -t lustre /dev/nvme0n1 /lustre/ost9
	mount -t lustre /dev/nvme1n1 /lustre/ost10
	mount -t lustre /dev/nvme2n1 /lustre/ost11
	mount -t lustre /dev/nvme3n1 /lustre/ost12
	df -h
fi
if [[ $1 == "oss31" ]]; then

	mkfs.lustre --ost --backfstype=ldiskfs --index=1 --reformat --mgsnode=${mdsname}@o2ib --fsname=lustre /dev/nvme0n1
	sleep 2

	mount -t lustre /dev/nvme0n1 /lustre/ost0
	mount -t lustre /dev/nvme0n1 /lustre/ost0
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
