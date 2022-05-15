import sys
import os
import subprocess

pct = sys.argv[1]

sum = 0
cnt = 0
avg = 0
for cpu in range(0, 32) :
	if len(str(cpu)) == 1 :
		cpu = "0"+str(cpu)
	else : 
		cpu = str(cpu)
	batcmd = "python parse_ctx.py \\\[0" + cpu + "] " + pct
	try :
		out = subprocess.check_output(batcmd, shell=True)
		for line in out.split('\n') :
			if line == ' ':
				break
			#print(line)
			chunks = line.split(':')
			if chunks[0] == 'sum' :
				sum = sum + float(chunks[1])
				#print(chunks[1])
			if chunks[0] == 'cnt' :
				cnt = cnt + float(chunks[1])
				#print(chunks[1])
			if chunks[0] == 'avg' :
				print(chunks[1])
	except :
		pass
	
print('[ALL]sum:' + str(sum))
print('[ALL]cnt:' + str(cnt))
print('[ALL]avg:' + str(sum/cnt))
