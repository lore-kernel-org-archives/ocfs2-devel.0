From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Fri May 14 17:09:30 2004
Subject: [Ocfs2-devel] 
	New bug 72 found "System halt when try to mount a volume under
	kernel 2.6.6 on IPF"
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65EB9@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	The ocfs2 version svn911 fails to work on IA64 under kernel
2.6.6.

Platform: Tiger4(IA64 with 4 CPUs)
OS version: Kernel 2.6.6
OCFS2 svn: 911

After insert OCFS2 module into the kernel 2.6.6 on IPF and mount an
OCFS2 
volume, the system halts. I enabled KDB in the kernel, so some debug 
information is output.

Steps:
1. create ocfs2 volume on /dev/sda2
2. insert ocfs2 module into kernel 2.6.6
3. mount ocfs2 volume /dev/sda2 onto /dev/ocfs2

Results:
System halt.

Call Trace:
 [<a000000100019760>] show_stack+0x80/0xa0
                             sp=e00000003054f760 bsp=e000000030549378
 [<a00000010003c0b0>] die+0x190/0x240
                             sp=e00000003054f930 bsp=e000000030549340
 [<a00000010003d6f0>] ia64_bad_break+0x2f0/0x400
                             sp=e00000003054f930 bsp=e000000030549318
 [<a000000100010160>] ia64_leave_kernel+0x0/0x260
                             sp=e00000003054f9c0 bsp=e000000030549318
 [<a00000020023c5e0>] ocfs_populate_inode+0x6a0/0x8c0 [ocfs2]
                             sp=e00000003054fb90 bsp=e000000030549268
 [<a00000020023d6a0>] ocfs_iget+0xea0/0x15c0 [ocfs2]
                             sp=e00000003054fb90 bsp=e000000030549200
 [<a0000002002706f0>] ocfs_mount_volume+0x1030/0x1a80 [ocfs2]
                             sp=e00000003054fbc0 bsp=e000000030549178
 [<a000000200272600>] ocfs_read_super+0x7e0/0x1180 [ocfs2]
                             sp=e00000003054fd10 bsp=e0000000305490b0
 [<a00000010013dde0>] get_sb_bdev+0x2a0/0x3c0
                             sp=e00000003054fd30 bsp=e000000030549060
 [<a00000020026eb80>] ocfs_get_sb+0x40/0x60 [ocfs2]
                             sp=e00000003054fd50 bsp=e000000030549028
 [<a00000010013d570>] do_kern_mount+0xb0/0x280
                             sp=e00000003054fd50 bsp=e000000030548fd8
 [<a000000100171f40>] do_mount+0xa20/0x1060
                             sp=e00000003054fd50 bsp=e000000030548f80
 [<a000000100172700>] sys_mount+0x180/0x2c0
                             sp=e00000003054fe10 bsp=e000000030548f00
 [<a00000010000ffe0>] ia64_ret_from_syscall+0x0/0x20
                             sp=e00000003054fe30 bsp=e000000030548f00
 [<a000000000010640>] 0xa000000000010640
                             sp=e000000030550000 bsp=e000000030548f00



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
