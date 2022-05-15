#!/bin/bash

ssh mds2 '/mnt/share/cykim/backup/lustre-start.sh mdt'
#ssh pm1 '/mnt/share/cykim/backup/lustre-start.sh oss1'
#ssh pm2 '/mnt/share/cykim/backup/lustre-start.sh oss2'
ssh pm3 '/mnt/share/cykim/backup/lustre-start.sh oss3'

