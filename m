From: Chen, Yukun <yukun.chen@intel.com>
Date: Fri May 21 05:24:32 2004
Subject: [Ocfs2-devel] Error when mount ocfs2 partition on kernel 2.6.6
Message-ID: <941A6821ACE16D4BBB8A958A0EB047F730704A@pdsmsx404.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi All

         I find a hang issue when trying to mount an ocfs2 partition in
a cluster environment. Machine 1 and machine 2 share a raid array.

         Steps to reproduce: (m1 represent machine 1, and m2 represent
machine 2)

 

         First In m1

1.       load_ocfs2

2.       mkfs.ocfs2 -b 4 -F -L ocfs2 -m /ocfs /dev/sdd2

3.       mount /dev/sdd2 /ocfs -t ocfs2

 

Then in m2

1.       load_ocfs2

2.       mount /dev/sdd2 /ocfs -t ocfs2    <===System hangs and the
following is the call trace information

 

Oracle Cluster FileSystem x y (build z)
ocfs2: hostname is westvile2
sectbits=9, clusterbits=12, dirbits=17, filebits=9
ocfs2: Adding west1 (node 0) to clustered device (8,66)
(3263) ERROR at /root/ocfs/ocfs2-6/src/dlm.c, 1395: DISKVOTE!!:
req_lock=2, flags=40000401, offset=1532416, inode=3
(3263) ERROR@/root/ocfs/ocfs2-6/src/dlm.c, 1398: DISKVOTE!!: this=1,
master=0, locktype=0, ronode=-1, romap=00000000
Call Trace: 
[<dc16dbf4>]   (0xdc16dbf4)

.........
 [<c0ed0000>]   (0xdc16dfd0)
[<ffffe410>]   (0xdc16dfec)

(3263) ERROR at /root/ocfs/ocfs2-6/src/dlm.c, 1395: DISKVOTE!!:
req_lock=2, flags=40000401, offset=1532416, inode=3
(3263) ERROR at /root/ocfs/ocfs2-6/src/dlm.c, 1398: DISKVOTE!!: this=1,
master=0, locktype=0, ronode=-1, romap=00000000
Call Trace: 
[<dc16dbf4>]   (0xdc16dbf4)
[<ffffffff>]   (0xdc16dc04)

...........
 [<c0105f71>]   (0xdc16dfc0)
[<c0ed0000>]   (0xdc16dfd0)
[<ffffe410>]   (0xdc16dfec)

ocfs2: Removing west1 (node 0) from clustered device (8,66)
ocfs2: Recovering node 0 from device (8,66)
(fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status 0,
recovered transactions 5 to 5
(fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 0 and revoked
0/0 blocks
kjournald starting.  Commit interval 5 seconds
Unable to handle kernel NULL pointer dereference at virtual address
0000001c
 printing eip:
e0ad4eeb
*pde = 1dfef067
*pte = 00000000
Oops: 0000 [#1]
SMP 
CPU:    2
EIP:    0060:[<e0ad4eeb>]    Not tainted
EFLAGS: 00010286   (2.6.6) 
EIP is at ocfs_bh_sem_lookup+0x1b/0x370 [ocfs2]
eax: 00000000   ebx: 00000800   ecx: db405dc4   edx: 00000000
esi: 00000000   edi: 00000000   ebp: dbe51e84   esp: dbe51e44
ds: 007b   es: 007b   ss: 0068
Process ocfs2rec-0 (pid: 3267, threadinfo=dbe50000 task=dd3ed480)
Stack: db58d378 dc2ee600 db58d378 c1416be0 00014025 88ad2fc6 000000ba
dd3ed630 
       c1416be0 c0498e20 dbe51ea8 00000000 c0498e20 00000000 00000000
00000000 
       dbe51e98 e0ad5257 00000000 00000000 00000000 dbe51efc e0ac175b
00000000 
Call Trace:
 [<e0ad5257>] ocfs_bh_sem_lock+0x17/0x60 [ocfs2]
 [<e0ac175b>] ocfs_sync_local_to_main+0x9b/0x7e0 [ocfs2]
 [<e0ad4c90>] ocfs_bh_sem_put+0x20/0xb0 [ocfs2]
 [<e0ad5472>] ocfs_bh_sem_unlock+0x32/0x50 [ocfs2]
 [<e0adee39>] ocfs_read_bhs+0x3f9/0x8e0 [ocfs2]
 [<e0ac369d>] ocfs_shutdown_local_alloc+0xdd/0x350 [ocfs2]
 [<e0ac39f7>] ocfs_recover_local_alloc+0xe7/0x1c6 [ocfs2]
 [<e0ae4ac9>] ocfs_recover_vol+0x699/0xc70 [ocfs2]
 [<e0ae4163>] __ocfs_recovery_thread+0x113/0x1e0 [ocfs2]
 [<e0ae4050>] __ocfs_recovery_thread+0x0/0x1e0 [ocfs2]
 [<c01042e5>] kernel_thread_helper+0x5/0x10
 

         Any ideas on this issue? 

 

Thanx.

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040521/9aabd332/attachment.htm
