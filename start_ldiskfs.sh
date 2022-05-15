#!/bin/bash

ssh cn9 "sh /mnt/share/cykim/backup/lustre-start.sh mdt"
ssh pm3 "sh /mnt/share/cykim/backup/lustre-start.sh oss3"
sh /mnt/share/cykim/backup/lustre-start.sh cn

lfs setstripe -C 4 /mnt/lustre

