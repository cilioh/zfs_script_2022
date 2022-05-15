#!/bin/bash

sh /mnt/share/cykim/backup/all_zfs.sh 4 8
sleep 10

sh /mnt/share/cykim/backup/all_zfs.sh 4 16
sleep 10

sh /mnt/share/cykim/backup/all_zfs.sh 8 8
sleep 10

sh /mnt/share/cykim/backup/all_zfs.sh 8 16
sleep 10

sh /mnt/share/cykim/backup/all_zfs.sh 16 8
sleep 10

sh /mnt/share/cykim/backup/all_zfs.sh 16 16
sleep 10

sh /mnt/share/cykim/backup/all_zfs.sh 32 8
sleep 10

sh /mnt/share/cykim/backup/all_zfs.sh 32 16
sleep 10


