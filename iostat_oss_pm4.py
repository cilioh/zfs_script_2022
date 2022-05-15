import sys
import numpy as np
#import pandas as pd

filepath = sys.argv[1]

#columns = ['tps','MB_read/s','MB_wrtn/s','MB_read','MB_wrtn']
#data_s = [0,0.0,0.0,0,0]
#data_df = pd.DataFrame(columns=columns)
nv0 = 0.0
nv1 = 0.0
nv2 = 0.0
nv3 = 0.0
io0 = 0.0
io1 = 0.0
io2 = 0.0
io3 = 0.0
linecount = 0

f = open(filepath, 'r')
lines = f.readlines()
for line in lines:
    if (line.find("nvme1n1") != -1):
	io0 += float(line.split()[1])
        nv0 += float(line.split()[3])
    elif (line.find("nvme2n1") != -1):
	io1 += float(line.split()[1])
        nv1 += float(line.split()[3])
    elif (line.find("nvme3n1") != -1):
	io2 += float(line.split()[1])
        nv2 += float(line.split()[3])
    elif (line.find("nvme4n1") != -1):
	io3 += float(line.split()[1])
        nv3 += float(line.split()[3])
	linecount += 1

f.close()

print(str(round(io0/linecount,2))+","+str(round(io1/linecount,2))+","+str(round(io2/linecount,2))+","+str(round(io3/linecount,2))+","+str(round(nv0/linecount/1024,2))+","+str(round(nv1/linecount/1024,2))+","+str(round(nv2/linecount/1024,2))+","+str(round(nv3/linecount/1024,2)))
#+","+str(round((io0+io1+io2+io3)/linecount,2))+","+str(round((nv0+nv1+nv2+nv3)/linecount/1024,2)))
