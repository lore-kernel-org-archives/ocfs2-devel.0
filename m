From: David Teigland <teigland@redhat.com>
Date: Tue, 12 Jan 2010 13:47:13 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock() dead
	lock
In-Reply-To: <20100112015946.GE20285@mail.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<20100112015946.GE20285@mail.oracle.com>
Message-ID: <20100112194713.GD24645@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 11, 2010 at 05:59:46PM -0800, Joel Becker wrote:
> 	I've attached the full patch with my changes.  Dave, please test
> my version (the attached one) instead of Wengang's.

Your new patch fixes the mount, so I went on to test make_panic which is
the test we never got to work:

http://oss.oracle.com/pipermail/ocfs2-devel/2009-April/004313.html
https://bugzilla.novell.com/show_bug.cgi?id=492055

It ran on three nodes for several minutes; much longer than it ever had
before.  It eventually triggered different BUG's on two of the nodes,
rather than just getting stuck as it used to.  I wasn't watching, so I
don't know which of these came first.

One node had:

kernel BUG at fs/ocfs2/dlmglue.c:3567!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
CPU 3
Modules linked in: ocfs2_stack_user dlm ocfs2 jbd2 ocfs2_nodemanager
configfs ocfs2_stackglue ipt_REJECT xt_tcpudp iptable_filter ip_tables
x_tables bridge stp autofs4 sunrpc ipv6 iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi cpufreq_ondemand dm_multipath video output sbs sbshc
battery ac parport_pc lp parport sg serio_raw button tg3 libphy
i2c_nforce2 i2c_core pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash
dm_log dm_mod qla2xxx scsi_transport_fc shpchp mptspi mptscsih mptbase
scsi_transport_spi sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Pid: 4019, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
RIP: 0010:[<ffffffffa03a8148>]  [<ffffffffa03a8148>]
ocfs2_ci_checkpointed+0x7c/0xcb [ocfs2]
RSP: 0018:ffff8800785b7dc0  EFLAGS: 00010002
RAX: 0000000000000001 RBX: 0000000000000411 RCX: ffff8800779b53b8
RDX: 000000000000d0cf RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff8800785b7df0 R08: ffffffffa03a810a R09: ffffffffa03aa010
R10: ffff88013f421e68 R11: ffff8800839d36c0 R12: ffffffffffffffff
R13: ffff880078b73938 R14: 0000000000000000 R15: ffff880078b73368
FS:  00007f589e5126e0(0000) GS:ffff880083a00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f0598be6000 CR3: 0000000133608000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ocfs2dc (pid: 4019, threadinfo ffff8800785b6000, task
ffff8800779b4cc0)
Stack:
 ffff88007856c000 0000000000000282 ffff880078b73368 0000000000000000
<0> ffff88007856c000 0000000000000282 ffff8800785b7e00 ffffffffa03ab4b0
<0> ffff8800785b7eb0 ffffffffa03aa16d ffff8800785b7eb0 ffffffff813528ed
Call Trace:
 [<ffffffffa03ab4b0>] ocfs2_check_meta_downconvert+0x32/0x34 [ocfs2]
 [<ffffffffa03aa16d>] ocfs2_downconvert_thread+0x470/0x869 [ocfs2]
 [<ffffffff813528ed>] ? thread_return+0x3e/0xee
 [<ffffffff8105ff63>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffffa03a9cfd>] ? ocfs2_downconvert_thread+0x0/0x869 [ocfs2]
 [<ffffffff8105fe55>] kthread+0x82/0x8d
 [<ffffffff8100cc1a>] child_rip+0xa/0x20
 [<ffffffff8105fdb2>] ? kthreadd+0xc7/0xe8
 [<ffffffff8105fdd3>] ? kthread+0x0/0x8d
 [<ffffffff8100cc10>] ? child_rip+0x0/0x20
Code: e0 45 85 f6 74 0a 41 83 fe 03 74 04 0f 0b eb fe 49 29 dc 49 f7 d4 4c
89 e0 48 c1 e8 3f 41 83 bf a0 00 00 00 05 74 08 84 c0 74 08 <0f> 0b eb fe
84 c0 75 07 b8 01 00 00 00 eb 33 4c 89 ef e8 07 ac
RIP  [<ffffffffa03a8148>] ocfs2_ci_checkpointed+0x7c/0xcb [ocfs2]
 RSP <ffff8800785b7dc0>

Another node had:

(2881,2):ocfs2_inode_lock_update:2224 ERROR: bug expression:
inode->i_generation != le32_to_cpu(fe->i_generation)
(2881,2):ocfs2_inode_lock_update:2224 ERROR: Invalid dinode 420382 disk
generation: 1523484106 inode->i_generation: 1523484094
------------[ cut here ]------------
kernel BUG at fs/ocfs2/dlmglue.c:2224!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
CPU 2
Modules linked in: ocfs2_stack_user dlm ocfs2 jbd2 ocfs2_nodemanager
configfs ocfs2_stackglue ipt_REJECT xt_tcpudp iptable_filter ip_tables
x_tables bridge stp sunrpc ipv6 cpufreq_ondemand dm_multipath uinput
serio_raw pcspkr sg qla2xxx scsi_transport_fc tg3 libphy i2c_nforce2
i2c_core button dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod
shpchp mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd
uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2881, comm: make_panic Not tainted 2.6.32.3 #1 ProLiant DL145 G2
RIP: 0010:[<ffffffffa032e9a0>]  [<ffffffffa032e9a0>]
ocfs2_inode_lock_full_nested+0x850/0xd00 [ocfs2]
RSP: 0018:ffff88007b55bce8  EFLAGS: 00010296
RAX: 0000000000000085 RBX: ffff880067c95000 RCX: 000000000000be01
RDX: ffff880083800000 RSI: 0000000000000001 RDI: 0000000000000003
RBP: ffff88007b55bd58 R08: 0000000000000092 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000018600 R12: ffff880066a8b2d8
R13: ffff880066a8b6e8 R14: ffff880066a8b840 R15: ffff880066a8b040
FS:  00007fa9c96b66f0(0000) GS:ffff880083800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f54f5021000 CR3: 000000007e82a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process make_panic (pid: 2881, threadinfo ffff88007b55a000, task
ffff88007e9d40c0)
Stack:
 ffffffff5ace85ca 000001015ace85be 00000000810f4897 0000000000000000
<0> 0000000000000000 000000017f59ece0 ffff880066a8b228 ffffffff81103794
<0> ffff880068122cb0 ffff880066a8b840 ffff880066a8b840 0000000000000026
Call Trace:
 [<ffffffff81103794>] ? mntput_no_expire+0x29/0xfd
 [<ffffffffa03354f1>] ocfs2_permission+0x78/0x16f [ocfs2]
 [<ffffffff810f3ea5>] inode_permission+0x6e/0x9e
 [<ffffffff810f593c>] may_open+0x9e/0x252
 [<ffffffff810f8389>] do_filp_open+0x51f/0xa55
 [<ffffffff81101c14>] ? alloc_fd+0x122/0x133
 [<ffffffff810ea0b0>] do_sys_open+0x62/0x109
 [<ffffffff810ea18a>] sys_open+0x20/0x22
 [<ffffffff8100bc5b>] system_call_fastpath+0x16/0x1b
Code: ff 48 c7 c1 b0 eb 37 a0 48 c7 c7 0b 6d 38 a0 65 8b 14 25 08 cd 00 00
89 44 24 08 8b 43 08 48 63 d2 89 04 24 31 c0 e8 37 cc 02 e1 <0f> 0b eb fe
48 83 7b 48 00 75 0a f6 43 2c 01 0f 85 bc 00 00 00
RIP  [<ffffffffa032e9a0>] ocfs2_inode_lock_full_nested+0x850/0xd00 [ocfs2]
 RSP <ffff88007b55bce8>
