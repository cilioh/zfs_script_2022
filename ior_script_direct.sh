#!/bin/bash

bsize=${1}
numjobs=${2}
nodename=${3}
filename=${4}
stripecount=${5}
todaydate=${6}
todaytime=${7}
iternum=${8}
directory=${9}

sig_dir="/mnt/share/cykim/signal"

mpirun -np ${numjobs} ior -w -i=1 -t=${bsize} -useO_DIRECT -b=${bsize} -o=${directory}/${filename} > ${sig_dir}/ior_result${nodename}

throughput=`cat ${sig_dir}/ior_result${nodename} | awk '$1=="write" { print }' | head -1 | awk ' { print $2 }'`
iops=`cat ${sig_dir}/ior_result${nodename} | awk '$1=="write" { print }' | head -1 | awk ' { print $3 }'`

lat=`cat ${sig_dir}/ior_result${nodename} | awk '$1=="write" { print }' | head -1 | awk ' { print $4 }'`

echo ${nodename}","${bsize}","${numjobs}","${stripecount}","${iternum}",0,0,0,0,0,0,"${iops}","${throughput} > /mnt/share/cykim/result/${nodename}.txt

echo "["${nodename}",BJ="${bsize}",NJ="${numjobs}",SC="${stripecount}",IT-"${iternum}"],iops=["${iops}"],TH=["${throughput}"]"

sleep 1

echo "ON" > /mnt/share/cykim/signal/${nodename}

exit 0
