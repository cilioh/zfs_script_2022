#!/bin/bash

ssh cn7 'lfs setstripe -c '${1}' /mnt/lustre'
ssh cn8 'lfs setstripe -c '${1}' /mnt/lustre'
ssh cn9 'lfs setstripe -c '${1}' /mnt/lustre'
ssh cn10 'lfs setstripe -c '${1}' /mnt/lustre'

exit 0
