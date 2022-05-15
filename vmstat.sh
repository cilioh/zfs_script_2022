#!/bin/bash

while true
do
	chkend=`tail -1 /mnt/share/cykim/result/${1}`
	if [[ $chkend == "END" ]]; then
		break
	fi

	vmstat | tail -1 | awk '{ print $4 }' >> /mnt/share/cykim/result/${1}
	sleep 1
done

kill -9 `pidof iostat`
echo "vmstat & iostat terminated"

exit 0
