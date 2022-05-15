import sys
import os
import subprocess
import time

start_time = time.time()


while True :
	batcmd = "ps -ef | grep z_wr_iss"
	try:
		dmesg = subprocess.check_output(batcmd, shell=True)
	except:
		continue
	
	ctxt = 0
	nctxt = 0
	for line in dmesg.split('\n') :
		if line.find("grep") == -1:
			try:
				chunks = line.split()
				#print(chunks[1])
				subbatcmd = "cat /proc/"+chunks[1]+"/status"
				subdmesg = subprocess.check_output(subbatcmd, shell=True)
				for subline in subdmesg.split('\n') :
					if subline.find("voluntary_ctxt_switches:") != -1:
						ctxt = ctxt + int(subline.split()[1])
					#elif subline.find("nonvoluntary_ctxt_switches:") != -1:
					#	nctxt = nctxt + int(subline.split()[1])
				#print(subdmesg)
			except IndexError:
				continue

	with open('ctxt_zfs', 'w') as f:
		print >> f, str(ctxt+nctxt)
	print("total voluntary ctxt switches: " + str(ctxt))
	#print("total non-volunatry ctxt switches: " + str(nctxt))

	time.sleep(5)

#print("--- %s seconds ---" % (time.time() - start_time))
