#~/bin/bash

#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/kernel/crypto/crct10dif_common.ko.xz 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/kernel/crypto/crct10dif_common.ko.xz 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/kernel/arch/x86/crypto/crct10dif-pclmul.ko.xz 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/kernel/crypto/crct10dif_common.ko.xz 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/kernel/crypto/crct10dif_generic.ko.xz 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/kernel/lib/crc-t10dif.ko.xz 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/net/libcfs.ko 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/net/lnet.ko networks=o2ib1(ib0) 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/obdclass.ko 

#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/ptlrpc.ko 

modprobe obdclass

insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/ptlrpc.ko 


#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/ptlrpc.ko ptlrpcd_per_cpt_max=16 ptlrpcd_bind_policy=1 ptlrpcd_partner_group_size=-1


#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/fld.ko 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/lov.ko 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/osc.ko 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/fid.ko 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/mdc.ko 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/lmv.ko 
#insmod /lib/modules/3.10.0-1062.1.1.el7.local.x86_64/extra/lustre-client/fs/lustre.ko 
