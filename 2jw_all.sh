#!/bin/bash

path="/home/kau/jwbang/210306_ctxt"
dbgmsg=0
opt=1
active=0

echo "==========" > ${path}

for batch_pct in "75"
do
	for zio_ctxt in "100" "300" "500" "1000" "2000" "5000" "8000" "10000" "15000"
	do
		echo "WRITE:"${batch_pct}"-"${zio_ctxt} >> ${path}
		for iter in {1..3}
		do
			sh jw_all.sh ${batch_pct} ${opt} ${active} ${zio_ctxt} ${dbgmsg} >> ${path}
			echo ${batch_pct}"-"${zio_ctxt}"==========iter:"${iter}" end" >> ${path}
		done
	done

	echo "WRITE:"${batch_pct}"-no opt" >> ${path}
	for iter in {1..3}
	do
		sh jw_all.sh ${batch_pct} 0 0 0 0 >> ${path}
		echo ${batch_pct}"-no opt==========iter:"${iter}" end" >> ${path}
	done
done
	

for batch_pct in "5"
do
	for zio_ctxt in "0" "100" "300" "500"
	do
		echo "WRITE:"${batch_pct}"-"${zio_ctxt} >> ${path}
		for iter in {1..3}
		do
			sh jw_all.sh ${batch_pct} ${opt} ${active} ${zio_ctxt} ${dbgmsg} >> ${path}
			echo ${batch_pct}"-"${zio_ctxt}"==========iter:"${iter}" end" >> ${path}
		done
	done

	echo "WRITE:"${batch_pct}"-no opt" >> ${path}
	for iter in {1..3}
	do
		sh jw_all.sh ${batch_pct} 0 0 0 0 >> ${path}
		echo ${batch_pct}"-no opt==========iter:"${iter}" end" >> ${path}
	done
done


