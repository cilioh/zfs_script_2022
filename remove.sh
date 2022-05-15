#!/bin/bash


sh /mnt/share/cykim/backup/lustre-reboot.sh cn
ssh pm3 "sh /mnt/share/cykim/backup/lustre-reboot.sh oss3"
ssh cn9 "sh /mnt/share/cykim/backup/lustre-reboot.sh mdt"

echo 3 > /proc/sys/vm/drop_caches
ssh pm3 "echo 3 > /proc/sys/vm/drop_caches"
ssh cn9 "echo 3 > /proc/sys/vm/drop_caches"

