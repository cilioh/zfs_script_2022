import sys
import os
import subprocess

batcmd = "dmesg | tail -100"
dmesg = subprocess.check_output(batcmd, shell=True)

check = 0
for line in dmesg.split('\n') :
	if line.find("ZFS function profiling END") != -1 :
		check = 1
	if line.find("SPL: Unloaded module") !=  -1 and check == 1 :
		check = 0
	if check == 1 :
		for zfs in ["[__zio_execute]", "[zio_write_bp_init]", "[zio_issue_async]", "[zio_write_compress]", "[zio_checksum_generate]", "[zio_dva_throttle]", "[zio_dva_allocate]", 
			"[zio_ready]", "[zio_vdev_io_start]", "[zio_vdev_io_done]", "[zio_vdev_io_assess]", "[zio_done]", "[abd_iterate_func]", "[abd_a]", "[abd_c]", "[ISSUE_spa_taskq]", "[INTERRUPT_spa_taskq]"] :
			if line.find(zfs) != -1 :
				chunks = line.split(' ')
				for words in chunks :
					if words.find("time") != -1 :
						time = words.split(':')[1]
					if words.find("count") != -1 :
						count = words.split(':')[1]
				print(time + ' ' + count)

		"""
		if line.find("__zio_execute") != -1 :
			chunks = line.split(' ')
			for words in chunks :
				if words.find("time") != -1 :
					time = words.split(':')[1]
				if words.find("count") != -1 :
					count = words.split(':')[1]
print(time)
print(count)
"""

