From: Chen, Yukun <yukun.chen@intel.com>
Date: Tue Jun  1 07:13:41 2004
Subject: [Ocfs2-devel] defect for [SVN 959] with new format on kernel 2.6.6
Message-ID: <941A6821ACE16D4BBB8A958A0EB047F73F47A2@pdsmsx404.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On kernel 2.6.6 , I tried the latest ocfs2 [SVN 959] with new format and
use the new

ocfs-tools

svn

http://oss.oracle.com/projects/ocfs-tools/src/branches/new-dir-format/
<http://oss.oracle.com/projects/ocfs-tools/src/branches/new-dir-format/>


 

My step

1.mkfs.ocfs2 -m /ocfs -L ocfs -b 4 /dev/hda3

2.load_ocfs2

3.mount /dev/hda3 /ocfs

 

Then mount went into uninterruptable sleep with the following error
message from dmesg:

 

3344: warning trying to OCFS_BH_GET_DATA_READ block zero!
dc377d68 00000d10 dc377d90 00000000 00000000 00000000 00000000 00000000 
       00000000 00000000 dcd783f0 dcd783c0 ffffffff c0360d00 20000000
00000032 
Call Trace: 
[<dc377d68>]   (0xdc377d68)

..............
 [<ffffe410>]   (0xdc377fec)

sectbits=9, clusterbits=12, dirbits=17, filebits=9, inodebits=9
(3344) ERROR at /root/ocfs/ocfs2-6/src/inode.c, 419: inlink=0 for 1536
ocfs2: invalid file entry!
------------[ cut here ]------------
kernel BUG at /root/ocfs/ocfs2-6/src/inode.c:362!
invalid operand: 0000 [#1]
SMP 
CPU:    0
EIP:    0060:[<e12fbb3c>]    Not tainted
EFLAGS: 00010282   (2.6.6) 
EIP is at ocfs_populate_inode+0x4ec/0x500 [ocfs2]
eax: 0000001b   ebx: dc603d20   ecx: 00000002   edx: c03d209c
esi: dcc60031   edi: e13220e0   ebp: dcc60000   esp: dc377c74
ds: 007b   es: 007b   ss: 0068
Process mount (pid: 3344, threadinfo=dc376000 task=dede7810)
Stack: e13221a2 dc376000 dffd1ac0 00000bf1 00000246 00000000 00000000
dcb34000 
       dca90000 00000000 00008000 dcc60000 dcc60000 0017e000 00000000
e12fbdaa 
       dc603d20 dcc60000 00008000 00000000 00000000 dc377cdc 00000000
00000000 
Call Trace:
 [<e12fbdaa>] __ocfs_read_inode2+0x24a/0x470 [ocfs2]
 [<e12fb1ae>] ocfs_iget+0x36e/0x710 [ocfs2]
 [<e12fbfd0>] ocfs_find_actor+0x0/0x1a0 [ocfs2]
 [<e12fc170>] ocfs_init_locked_inode+0x0/0x100 [ocfs2]
 [<e1312ac3>] ocfs_init_system_inodes+0x103/0x260 [ocfs2]
 [<e1314347>] ocfs_mount_volume+0x537/0xde0 [ocfs2]
 [<c011c730>] default_wake_function+0x0/0x20
 [<c011c730>] default_wake_function+0x0/0x20
 [<c011c730>] default_wake_function+0x0/0x20
 [<c011c730>] default_wake_function+0x0/0x20
 [<e13199e0>] ocfs_timeout_func+0x0/0x20 [ocfs2]
 [<e1312e11>] __ocfs_read_super+0xf1/0x300 [ocfs2]
 [<c015fd01>] get_sb_bdev+0x141/0x180
 [<e1313060>] ocfs_get_sb+0x30/0x40 [ocfs2]
 [<e1313020>] ocfs_read_super+0x0/0x10 [ocfs2]
 [<c015ff3f>] do_kern_mount+0x5f/0xe0
 [<c0176397>] do_add_mount+0x97/0x1b0
 [<c01766b4>] do_mount+0x144/0x190
 [<c01b221b>] copy_from_user+0x5b/0x90
 [<c0176513>] copy_mount_options+0x63/0xc0
 [<c0176ad9>] sys_mount+0xc9/0x140
 [<c010603d>] sysenter_past_esp+0x52/0x71

Code: 0f 0b 6a 01 80 5c 32 e1 e9 f8 fb ff ff 8d b4 26 00 00 00 00 
 

 

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040601/68b10549/attachment.htm
