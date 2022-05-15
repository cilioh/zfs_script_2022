#!/bin/bash

lctl set_param subsystem_debug=$1
#lctl set_param debug="dlmtrace vfstrace"
lctl set_param debug=$2
lctl get_param subsystem_debug
lctl get_param debug
lctl clear

/usr/local/bin/mpirun -np 16 ior -w -t=1M -b=1M -o /mnt/lustre/AAA -k

lctl dk debug
