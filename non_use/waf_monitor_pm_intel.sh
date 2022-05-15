#!/bin/bash

sig_dir="/mnt/share/cykim/signal"
node_value=${1}

while true
do
	sleep 1

	checkmsg=`cat /mnt/share/cykim/signal/termall`
	if [[ $checkmsg == "OFF" ]]; then
		break
	fi

	#nvme command for WAF
	output=`nvme smart-log-add /dev/nvme0n1 | grep '^[nh][ao][ns][dt]' | awk '{ print $5 }'`
	user_writes_bf_0=`expr $(echo $output | awk '{ print $2 }') + 0`
	nand_writes_bf_0=`expr $(echo $output | awk '{ print $1 }') + 0`

	output=`nvme smart-log-add /dev/nvme1n1 | grep '^[nh][ao][ns][dt]' | awk '{ print $5 }'`
	user_writes_bf_1=`expr $(echo $output | awk '{ print $2 }') + 0`
	nand_writes_bf_1=`expr $(echo $output | awk '{ print $1 }') + 0`

	output=`nvme smart-log-add /dev/nvme2n1 | grep '^[nh][ao][ns][dt]' | awk '{ print $5 }'`
	user_writes_bf_2=`expr $(echo $output | awk '{ print $2 }') + 0`
	nand_writes_bf_2=`expr $(echo $output | awk '{ print $1 }') + 0`

	output=`nvme smart-log-add /dev/nvme3n1 | grep '^[nh][ao][ns][dt]' | awk '{ print $5 }'`
	user_writes_bf_3=`expr $(echo $output | awk '{ print $2 }') + 0`
	nand_writes_bf_3=`expr $(echo $output | awk '{ print $1 }') + 0`
	# interval
	sleep 59


	#nvme command for WAF
	output=`nvme smart-log-add /dev/nvme0n1 | grep '^[nh][ao][ns][dt]' | awk '{ print $5 }'`
	user_writes_at_0=`expr $(echo $output | awk '{ print $2 }') + 0`
	nand_writes_at_0=`expr $(echo $output | awk '{ print $1 }') + 0`

	output=`nvme smart-log-add /dev/nvme1n1 | grep '^[nh][ao][ns][dt]' | awk '{ print $5 }'`
	user_writes_at_1=`expr $(echo $output | awk '{ print $2 }') + 0`
	nand_writes_at_1=`expr $(echo $output | awk '{ print $1 }') + 0`

	output=`nvme smart-log-add /dev/nvme2n1 | grep '^[nh][ao][ns][dt]' | awk '{ print $5 }'`
	user_writes_at_2=`expr $(echo $output | awk '{ print $2 }') + 0`
	nand_writes_at_2=`expr $(echo $output | awk '{ print $1 }') + 0`

	output=`nvme smart-log-add /dev/nvme3n1 | grep '^[nh][ao][ns][dt]' | awk '{ print $5 }'`
	user_writes_at_3=`expr $(echo $output | awk '{ print $2 }') + 0`
	nand_writes_at_3=`expr $(echo $output | awk '{ print $1 }') + 0`

	#WAF
	if [ $nand_writes_bf_0 -eq $nand_writes_at_0 ]; then
	        WAF_0=-1
	elif [ $user_writes_bf_0 -eq $user_writes_at_0 ]; then
		WAF_0=-1
	else
	        WAF_0=$(echo "$nand_writes_bf_0 $user_writes_bf_0 $nand_writes_at_0 $user_writes_at_0" | awk '{printf "%.4f \n", ($3-$1)/($4-$2)}')
	fi

	if [ $nand_writes_bf_1 -eq $nand_writes_at_1 ]; then
	        WAF_1=-1
	elif [ $user_writes_bf_1 -eq $user_writes_at_1 ]; then
		WAF_1=-1
	else
	        WAF_1=$(echo "$nand_writes_bf_1 $user_writes_bf_1 $nand_writes_at_1 $user_writes_at_1" | awk '{printf "%.4f \n", ($3-$1)/($4-$2)}')
	fi

	if [ $nand_writes_bf_2 -eq $nand_writes_at_2 ]; then
	        WAF_2=-1
	elif [ $user_writes_bf_2 -eq $user_writes_at_2 ]; then
		WAF_2=-1
	else
	        WAF_2=$(echo "$nand_writes_bf_2 $user_writes_bf_2 $nand_writes_at_2 $user_writes_at_2" | awk '{printf "%.4f \n", ($3-$1)/($4-$2)}')
	fi

	if [ $nand_writes_bf_3 -eq $nand_writes_at_3 ]; then
	        WAF_3=-1
	elif [ $user_writes_bf_3 -eq $user_writes_at_3 ]; then
		WAF_3=-1
	else
	        WAF_3=$(echo "$nand_writes_bf_3 $user_writes_bf_3 $nand_writes_at_3 $user_writes_at_3" | awk '{printf "%.4f \n", ($3-$1)/($4-$2)}')
	fi

	echo $WAF_0 $WAF_1 $WAF_2 $WAF_3 >> /mnt/share/cykim/result/pm_waf${1}.txt
done

exit 0
