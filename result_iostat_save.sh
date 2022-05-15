#!/bin/bash

todaydate=${1}
todaytime=${2}
nodename=${3}
experiment=${4}

if [[ $experiment =~ "1" ]]; then
	msg=$(ssh pm1 'pidof iostat')
elif [[ $experiment =~ "2" ]]; then
	msg=$(ssh pm2 'pidof iostat')
elif [[ $experiment =~ "3" ]]; then
	msg=$(ssh pm3 'pidof iostat')
elif [[ $experiment =~ "4" ]]; then
	msg=$(ssh pm4 'pidof iostat')
fi

if [[ $msg == "" ]]; then
	sleep 0.1
else
	if [[ $experiment =~ "1" ]]; then
		ssh pm1 'kill -9 $(pidof iostat)'
	fi
	if [[ $experiment =~ "2" ]]; then
		ssh pm2 'kill -9 $(pidof iostat)'
	fi
	if [[ $experiment =~ "3" ]]; then
		ssh pm3 'kill -9 $(pidof iostat)'
	fi
	if [[ $experiment =~ "4" ]]; then
		ssh pm4 'kill -9 $(pidof iostat)'
	fi
fi

sleep 1

if [[ $experiment =~ "1" ]]; then
	pm1result=`python iostat_oss.py /mnt/share/cykim/result/output1`
fi
if [[ $experiment =~ "2" ]]; then
	pm2result=`python iostat_oss.py /mnt/share/cykim/result/output2`
fi
if [[ $experiment =~ "3" ]]; then
	pm3result=`python iostat_oss.py /mnt/share/cykim/result/output3`
fi
if [[ $experiment =~ "4" ]]; then
	pm4result=`python iostat_oss_pm4.py /mnt/share/cykim/result/output4`
fi

out=`cat /mnt/share/cykim/result/${nodename}.txt`
if [[ $experiment =~ "1" ]]; then
	out=`echo ${out}","${pm1result}`
fi
if [[ $experiment =~ "2" ]]; then
	out=`echo ${out}","${pm2result}`
fi
if [[ $experiment =~ "3" ]]; then
	out=`echo ${out}","${pm3result}`
fi
if [[ $experiment =~ "4" ]]; then
	out=`echo ${out}","${pm4result}`
fi

echo ${out} >> /mnt/share/cykim/result/${todaydate}/Result_${todaytime}_${nodename}.txt
