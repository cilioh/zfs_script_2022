import sys
import os
import subprocess

#usage: python parse_ftrace.py z_wr_iss-8214 75


finding = sys.argv[1]
pct = sys.argv[2]

batcmd = "grep -r '" + finding + "' /home/kau/jwbang/perf-tools/kernel/" + pct + "_abd_copy_from_buf_off_cb"
out = subprocess.check_output(batcmd, shell=True)

before = 0
interval_sum = 0
count = 0
index = 0
for line in out.split('\n') :
	if line == '' : 
		break
	if line.find("z_wr_iss") == -1 :
		continue
	print(line)
	chunks = line.split()
	if index == 0 :
		for i in range(0, len(chunks)) : 
			if chunks[i] == '....' :
				index = i+1
				break
	time = float(chunks[index][:-1])
	if before == 0 :
		interval = 0
	else :
		interval = time - before
	#interval = '{0:.10f}'.format(time - before)
	interval_sum = interval_sum + interval
	#print(str('{0:.10f}'.format(interval)) + ' ' + str(interval_sum))
	count = count + 1
	before = time

print("when the tid is same")
print('sum:  ' + str(interval_sum))
print('count:' + str(count))
print('avg:  ' + str(interval_sum/count))
