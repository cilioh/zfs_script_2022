#!/bin/bash

ssh root@192.168.0.128 '/mnt/share/cykim/backup/lustre-start.sh oss1'
ssh root@192.168.0.129 '/mnt/share/cykim/backup/lustre-start.sh oss2'
ssh root@192.168.0.130 '/mnt/share/cykim/backup/lustre-start.sh oss3'
