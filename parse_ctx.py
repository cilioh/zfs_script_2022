import sys
import os
import subprocess

#usage: python parse_ftrace.py \\[010] 5


finding = sys.argv[1]
pct = sys.argv[2]

#batcmd = "grep -r '" + finding + "' /home/kau/jwbang/perf-tools/kernel/" + pct + "_abd_fletcher_4_iter"
batcmd = "grep -r '" + finding + "' /home/kau/jwbang/perf-tools/kernel/" + pct + "_abd_copy_from_buf_off_cb"
#batcmd = "grep -r '" + finding + "' /home/kau/jwbang/perf-tools/kernel/" + pct + "_spin_abd_fletcher_4_iter"
#batcmd = "grep -r '" + finding + "' /home/kau/jwbang/perf-tools/kernel/" + pct + "_zio"
out = subprocess.check_output(batcmd, shell=True)


before = 0
tbefore = 0
interval_sum = 0
count = 0
index = 0
tindex = 0
for line in out.split('\n') :
	if line == '' : 
		break
	if line.find("z_wr_iss") == -1 :
		continue
	#print(line)
	chunks = line.split()
	print(chunks)
	#if index == 0 :
	for i in range(0, len(chunks)) : 
		if chunks[i] == '....' or chunks[i] == 'd.h.' :
			index = i+1
			break
	#if tindex == 0 :
	for i in range(0, len(chunks)) :
		if chunks[i].find("z_wr_iss") != -1:
			tindex = i
			break
	#print("time:"+chunks[index])
	#print("thread:"+chunks[tindex])
	#break

	time = float(chunks[index][:-1])
	thread = chunks[tindex]

	if tbefore == 0 :
		tbefore = thread
		continue
	else :
		if tbefore != thread :
			if before == 0 :
				interval = 0
			else : 
				interval = time - before
			interval_sum = interval_sum + interval
			#print("[before]"+lbefore)
			#print("[after] "+line)
			#print(str('{0:.10f}'.format(interval)) + ' ' + str(interval_sum))
			count = count + 1
			tbefore = thread
			before = time
	lbefore = line

#print("[context switch case] using same CPU, when the thread is changed")
print(finding)
if count != 0 :
	print('sum:' + str(interval_sum))
	print('cnt:' + str(count))
	print('avg:' + str(interval_sum/count))
else :
	print('sum:0')
	print('cnt:0')
	print('avg:0')
