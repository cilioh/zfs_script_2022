#!/bin/bash

# drop caches before experiment
echo 3 > /proc/sys/vm/drop_caches
ssh pm1 'echo 3 > /proc/sys/vm/drop_caches'
ssh pm2 'echo 3 > /proc/sys/vm/drop_caches'
ssh pm3 'echo 3 > /proc/sys/vm/drop_caches'
sleep 5

# vmstat - free memory
#fmem=`vmstat | tail -1 | awk '{ print $4 }'`

# iostat - disk throughput
#ssh pm1 'iostat -d -m 1' | awk '$1=="nvme1n1" { n1 = $4 } $1=="nvme0n1" { print $4, n1 }'

echo '' > /mnt/share/cykim/result/vm1
echo '' > /mnt/share/cykim/result/vm2
echo '' > /mnt/share/cykim/result/vm3
echo '' > /mnt/share/cykim/result/io1
echo '' > /mnt/share/cykim/result/io2
echo '' > /mnt/share/cykim/result/io3

ssh pm1 '/mnt/share/cykim/backup/vmstat.sh vm1' &
ssh pm1 '/mnt/share/cykim/backup/iostat.sh io1' &
ssh pm2 '/mnt/share/cykim/backup/vmstat.sh vm2' &
ssh pm2 '/mnt/share/cykim/backup/iostat.sh io2' &
ssh pm3 '/mnt/share/cykim/backup/vmstat.sh vm3' &
ssh pm3 '/mnt/share/cykim/backup/iostat.sh io3' &

#EXP
sh ~/lustre-compute/nvme-log.sh

#Termination
echo "END" >> /mnt/share/cykim/result/vm1
echo "END" >> /mnt/share/cykim/result/vm2
echo "END" >> /mnt/share/cykim/result/vm3
sleep 0.2
echo "END" >> /mnt/share/cykim/result/vm1
echo "END" >> /mnt/share/cykim/result/vm2
echo "END" >> /mnt/share/cykim/result/vm3

sleep 1
ssh pm1 'kill -9 `pidof iostat`'
ssh pm2 'kill -9 `pidof iostat`'
ssh pm3 'kill -9 `pidof iostat`'

exit 0
