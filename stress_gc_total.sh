#!/bin/bash
sig_dir="/mnt/share/cykim/signal"


# ON Signal for sub scripts
echo "ON" > ${sig_dir}/breaksig


# PM - WAF Script
# Not in Use For Now


ssh cn8 'sh /mnt/share/cykim/backup/load_stress_gc.sh 256MB 16 CN8 banana' &
ssh cn9 'sh /mnt/share/cykim/backup/load_stress_gc.sh 1G 16 CN9 citrus' &
ssh cn10 'sh /mnt/share/cykim/backup/load_stress_gc.sh 4G 16 CN10 dragonfruit' &
sh ./load_stress_gc.sh 64MB 16 CN7 apple

exit 0
