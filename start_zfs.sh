#!/bin/bash

ssh cn9 "sh /mnt/share/cykim/backup/lustre-zfs-start.sh mdt"
ssh pm3 "sh /mnt/share/cykim/backup/lustre-zfs-start.sh oss3"
/mnt/share/cykim/backup/lustre-zfs-start.sh cn

lfs setstripe -C 4 /mnt/lustre

