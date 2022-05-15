#!/bin/bash

sig_dir="/mnt/share/cykim/signal"
node_value=${1}

echo "ON" > ${sig_dir}/msg${node_value}
echo 0 > ${sig_dir}/flyer${node_value}
rm -rf ${sig_dir}result-waf${node_value}

while true
do
	sleep 0.001
	checkvalue=`cat ${sig_dir}/flyer${node_value}`
	if [[ $checkvalue == "1" ]]; then
		echo 0 > ${sig_dir}/flyer${node_value}
		break
	fi
done

#nvme command for WAF
output=`nvme get-log /dev/nvme0n1 -i 0xc1 -l 128`
user_writes_bf_0=`expr $(echo $output | awk '{print $22}' | cut -d'(' -f2 | cut -d')' -f1) + 0`
nand_writes_bf_0=`expr $(echo $output | awk '{print $26}' | cut -d'(' -f2 | cut -d')' -f1) + 0`

output=`nvme get-log /dev/nvme1n1 -i 0xc1 -l 128`
user_writes_bf_1=`expr $(echo $output | awk '{print $22}' | cut -d'(' -f2 | cut -d')' -f1) + 0`
nand_writes_bf_1=`expr $(echo $output | awk '{print $26}' | cut -d'(' -f2 | cut -d')' -f1) + 0`

while true
do
	sleep 0.001
	checkvalue=`cat ${sig_dir}/flyer${node_value}`
	if [[ $checkvalue == "1" ]]; then
		echo 0 > ${sig_dir}/flyer${node_value}
		break
	fi
done

#nvme command for WAF
output=`nvme get-log /dev/nvme0n1 -i 0xc1 -l 128`
user_writes_at_0=`expr $(echo $output | awk '{print $22}' | cut -d'(' -f2 | cut -d')' -f1) + 0`
nand_writes_at_0=`expr $(echo $output | awk '{print $26}' | cut -d'(' -f2 | cut -d')' -f1) + 0`

output=`nvme get-log /dev/nvme1n1 -i 0xc1 -l 128`
user_writes_at_1=`expr $(echo $output | awk '{print $22}' | cut -d'(' -f2 | cut -d')' -f1) + 0`
nand_writes_at_1=`expr $(echo $output | awk '{print $26}' | cut -d'(' -f2 | cut -d')' -f1) + 0`

#WAF
if [ $nand_writes_bf_0 -eq $nand_writes_at_0 ]; then
        WAF_0=-1
else
        WAF_0=$(echo "$nand_writes_bf_0 $user_writes_bf_0 $nand_writes_at_0 $user_writes_at_0" | awk '{printf "%.4f \n", ($3-$1)/($4-$2)}')
fi

if [ $nand_writes_bf_1 -eq $nand_writes_at_1 ]; then
        WAF_1=-1
else
        WAF_1=$(echo "$nand_writes_bf_1 $user_writes_bf_1 $nand_writes_at_1 $user_writes_at_1" | awk '{printf "%.4f \n", ($3-$1)/($4-$2)}')
fi

echo $WAF_0 $WAF_1 > ${sig_dir}/result-waf${node_value}

exit 0
