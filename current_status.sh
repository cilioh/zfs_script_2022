#!/bin/bash
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

if [[ `lfs df -h | grep -oP "^UUID"` == "" ]]; then
	exit 0
fi

echo -e "${CYAN}MDS - mds2 node-----------------------"
echo ""
ssh mds2 "zfs list" | grep "^mdt[^/]"
echo -e "--------------------------------------${NC}"
echo ""

echo "OSS1 - pm1 node-----------------------"
echo -e "${RED}"
ssh pm1 'zfs list' | grep "^ost[0-9]*/ost"
echo -e "${NC}--------------------------------------"
echo ""

echo "OSS2 - pm2 node-----------------------"
echo -e "${RED}"
ssh pm2 'zfs list' | grep "^ost[0-9]*/ost"
echo -e "${NC}--------------------------------------"
echo ""

echo "OSS3 - pm3 node-----------------------"
echo -e "${RED}"
ssh pm3 'zfs list' | grep "^ost[0-9]*/ost"
echo -e "${NC}--------------------------------------"
echo ""



