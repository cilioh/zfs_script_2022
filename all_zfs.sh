#!/bin/bash

sleep 10

ssh cn9 "sh /mnt/share/cykim/backup/lustre-zfs-start.sh mdt"
ssh pm3 "sh /mnt/share/cykim/backup/lustre-zfs-start.sh oss3"
sh /mnt/share/cykim/backup/lustre-zfs-start.sh cn

#ssh pm3 "zfs set compression=off ost9"
#ssh pm3 "zfs set compression=off ost10"
#ssh pm3 "zfs set compression=off ost11"
#ssh pm3 "zfs set compression=off ost12"

lfs setstripe -C 4 /mnt/lustre 

ssh pm3 "/mnt/share/cykim/backup/parse_pid_ctxt/cks_ctxt /mnt/share/cykim/backup/parse_pid_ctxt/cks_log/${1}G-${2}thr"&
ssh pm3 "/mnt/share/cykim/backup/parse_pid_ctxt/dp_ctxt /mnt/share/cykim/backup/parse_pid_ctxt/dp_log/${1}G-${2}thr"&

fio --directory=/mnt/lustre --name=check -rw=write --direct=0 --bs=1M --size=${1}G --numjobs=${2} --group_reporting --fallocate=none

ssh pm3 "pkill cks_ctxt"
ssh pm3 "pkill dp_ctxt" 

sh /mnt/share/cykim/backup/lustre-reboot.sh cn
ssh pm3 "sh /mnt/share/cykim/backup/lustre-reboot.sh oss3"
ssh cn9 "sh /mnt/share/cykim/backup/lustre-reboot.sh mdt"

ssh cn9 "echo 3 > /proc/sys/vm/drop_caches"
ssh pm3 "echo 3 > /proc/sys/vm/drop_caches"
echo 3 > /proc/sys/vm/drop_caches

sleep 20
