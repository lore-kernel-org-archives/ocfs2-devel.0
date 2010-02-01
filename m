From: David Teigland <teigland@redhat.com>
Date: Mon, 1 Feb 2010 15:20:56 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not downconvert if the lock
	level is already compatible
In-Reply-To: <20100201201930.GA25885@redhat.com>
References: <4B632024.1090102@oracle.com> <20100129222102.GC16606@redhat.com>
	<4B637A67.6070007@oracle.com> <20100201201930.GA25885@redhat.com>
Message-ID: <20100201212056.GB25885@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 01, 2010 at 02:19:30PM -0600, David Teigland wrote:
> On Fri, Jan 29, 2010 at 04:16:39PM -0800, Sunil Mushran wrote:
> > David Teigland wrote:
> > >With this patch I ran alternate and make_panic for about 2.5 hours, and
> > >then one node hit this BUG.  /var/log/messages didn't catch any of it, so
> > >no additional info this time.
> > >
> > >kernel BUG at fs/ocfs2/dlmglue.c:3395
> > 
> > David,
> > 
> > Please could you re-run with this debug patch.
> > 
> > http://oss.oracle.com/~smushran/.dlmglue/0001-ocfs2-Patch-to-debug-hang-in-dlmglue-when-running-dl.patch

Using the update to reduce the volume of log messages...

Ran alternate by itself for 10 minutes with no problem, then added
make_panic and got the panic on second node within a couple minutes.

from console:

 ------------[ cut here ]------------
(6930,2,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000003f00435e4a660, action 2, unlock 0, level 0, newlevel 5
(6930,1,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000004eefc00000000, blocking 3, level 5 type Meta
(6930,1,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000004eefc00000000, block 3, level 5, l_block 3, dwn 1
(6930,1,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000000000b6354ea08, blocking 5, level 5 type Meta
(6930,1,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000000000b6354ea08, block 5, level 5, l_block 5, dwn 1
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f016, action 1, unlock 0, level -1, newlevel 3
(7073,1,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01500000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01500000000, action 2, unlock 0, level 0, newlevel 3
(6930,1,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f01800000000, blocking 3, level 5 type Meta
(6930,1,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f01800000000, block 3, level 5, l_block 3, dwn 1
kernel BUG at fs/ocfs2/dlmglue.c:3417!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:80/0000:80:02.0/0000:86:01.0/local_cpus
CPU 0
Modules linked in: ocfs2_stack_user dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath a
md64_edac_mod edac_core tg3 shpchp serio_raw i2c_nforce2 i2c_core k8temp qla2xxx ata_generic mptspi scsi_transport_fc pata_acpi mptscsih mptbase scsi_trans
port_spi scsi_tgt pata_amd sata_nv [last unloaded: scsi_wait_scan]
Pid: 6957, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
RIP: 0010:[<ffffffffa020de29>]  [<ffffffffa020de29>] ocfs2_downconvert_thread+0x4cb/0xdad [ocfs2]
RSP: 0018:ffff88007abb7d90  EFLAGS: 00010046
RAX: 00000000000000b9 RBX: ffff88007b99bd50 RCX: 0000000000008506
RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
RBP: ffff88007abb7ee0 R08: ffff88007abb7c80 R09: 0000000000000000
R10: 0000000000000004 R11: 000000107abb7900 R12: 0000000000000282
R13: 0000000000000000 R14: ffff88013a000000 R15: ffff88007b99bd68
FS:  00007f11c9de2710(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f7c6df2f000 CR3: 000000013d11c000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ocfs2dc (pid: 6957, threadinfo ffff88007abb6000, task ffff88007d3cc5c0)
Stack:
 ffff88007b99bd98 ffffffff00000000 ffff880000000001 ffffffff00000001
<0> 0000000000000000 0000000000000041 0000000000000000 ffff880000000000
<0> ffffffff00000000 ffff880100000000 ffff880000000000 ffffffff00000000
Call Trace:
 [<ffffffff81074f6b>] ? autoremove_wake_function+0x0/0x39
 [<ffffffffa020d95e>] ? ocfs2_downconvert_thread+0x0/0xdad [ocfs2]
 [<ffffffff81074c7e>] kthread+0x7f/0x87
 [<ffffffff81012cea>] child_rip+0xa/0x20
 [<ffffffff81074bff>] ? kthread+0x0/0x87
 [<ffffffff81012ce0>] ? child_rip+0x0/0x20
Code: 24 10 8b 43 68 89 44 24 08 48 8d 43 48 48 89 04 24 31 c0 e8 dd 2e 22 e1 f6 43 40 04 74 0d 4c 8d 63 48 c7 45 8c 00 00 00 00 eb 04 <0f> 0b eb fe 48 8b 
4b 40 f6 c1 02 0f 84 2d 01 00 00 80 e5 04 74
RIP  [<ffffffffa020de29>] ocfs2_downconvert_thread+0x4cb/0xdad [ocfs2]
 RSP <ffff88007abb7d90>
---[ end trace 692271ffad8ccf0d ]---
(7073,1,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f03100000000, convert from 3 to 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f03100000000, action 2, unlock 0, level 3, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000004f181f5dfe12d, action 1, unlock 0, level -1, newlevel 5
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock N000000000003f031, convert from -1 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000004f18100000000, action 1, unlock 0, level -1, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock O000000000000000004f18100000000, action 1, unlock 0, level -1, newlevel 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f031, action 1, unlock 0, level -1, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01f00000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01f00000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f00900000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00900000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01e00000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01e00000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f02c00000000, convert from 3 to 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f02c00000000, action 2, unlock 0, level 3, newlevel 5
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock N000000000003f02c, convert from -1 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000004f182f5dfe12e, action 1, unlock 0, level -1, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock O000000000000000004f18200000000, action 1, unlock 0, level -1, newlevel 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000004f18200000000, action 1, unlock 0, level -1, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f02c, action 1, unlock 0, level -1, newlevel 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock O000000000000000004f18300000000, action 1, unlock 0, level -1, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock N000000000003f016, convert from -1 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f016, action 1, unlock 0, level -1, newlevel 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000004f183f5dfe12f, action 1, unlock 0, level -1, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000004f18300000000, action 1, unlock 0, level -1, newlevel 5
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f00500000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00500000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f03600000000, convert from 3 to 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f03600000000, action 2, unlock 0, level 3, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000004f18400000000, action 1, unlock 0, level -1, newlevel 5
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock N000000000003f036, convert from -1 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock O000000000000000004f18400000000, action 1, unlock 0, level -1, newlevel 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000004f184f5dfe130, action 1, unlock 0, level -1, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f036, action 1, unlock 0, level -1, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f00f00000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00f00000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f02700000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f02700000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f02100000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f02100000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01a00000000, convert from 3 to 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01a00000000, action 2, unlock 0, level 3, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000004f185f5dfe131, action 1, unlock 0, level -1, newlevel 5
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock N000000000003f01a, convert from -1 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000004f18500000000, action 1, unlock 0, level -1, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f01a, action 1, unlock 0, level -1, newlevel 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock O000000000000000004f18500000000, action 1, unlock 0, level -1, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f02600000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f02600000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f00700000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00700000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01200000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01200000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01100000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01100000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f02500000000, convert from 0 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f02500000000, action 2, unlock 0, level 0, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01c00000000, convert from 3 to 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01c00000000, action 2, unlock 0, level 3, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000004f186f5dfe132, action 1, unlock 0, level -1, newlevel 5
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock N000000000003f01c, convert from -1 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000004f18600000000, action 1, unlock 0, level -1, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock O000000000000000004f18600000000, action 1, unlock 0, level -1, newlevel 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f01c, action 1, unlock 0, level -1, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01300000000, convert from 3 to 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01300000000, action 2, unlock 0, level 3, newlevel 5
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock N000000000003f013, convert from -1 to 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000004f187f5dfe133, action 1, unlock 0, level -1, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000004f18700000000, action 1, unlock 0, level -1, newlevel 5
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock O000000000000000004f18700000000, action 1, unlock 0, level -1, newlevel 3
(6930,1,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f013, action 1, unlock 0, level -1, newlevel 3
(7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f02300000000, convert from 3 to 5


from another window doing a tail -f /var/log/messages:
(can go back further if needed)

Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000004f17f00000000, action 1, unlock 0, level -1, newlevel 5
Feb  1 15:12:49 bull-02 kernel: (7073,0,make_panic):__ocfs2_cluster_lock:1424 lock N000000000003f018, convert from -1 to 3
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f018, action 1, unlock 0, level -1, newlevel 3
Feb  1 15:12:49 bull-02 kernel: (7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01000000000, convert from 0 to 3
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f02000000000, blocking 5, level 3 type Meta
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f02000000000, block 5, level 3, l_block 5, dwn 1
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:3996 lockres M000000000000000003f00400000000 blocked.
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_prepare_downconvert:3293 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_downconvert_lock:3313 lock M000000000000000003f00400000000, level 3 => 0
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:4020 lockres M000000000000000003f00400000000, requeue = no.
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:3996 lockres M000000000000000003f02000000000 blocked.
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_prepare_downconvert:3293 lock M000000000000000003f02000000000, new_level = 0, l_blocking = 5
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_downconvert_lock:3313 lock M000000000000000003f02000000000, level 3 => 0
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:4020 lockres M000000000000000003f02000000000, requeue = no.
Feb  1 15:12:49 bull-02 kernel: (7014,0,alternate):__ocfs2_cluster_lock:1424 lock M000000000000000003f00400000000, convert from 0 to 3
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f02000000000, action 3, unlock 0, level 3, newlevel 0
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock O000000000000000004f17f00000000, action 1, unlock 0, level -1, newlevel 3
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01000000000, action 2, unlock 0, level 0, newlevel 3
Feb  1 15:12:49 bull-02 kernel: (7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01600000000, convert from 0 to 3
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01600000000, action 2, unlock 0, level 0, newlevel 3
Feb  1 15:12:49 bull-02 kernel: (7073,0,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01600000000, convert from 3 to 5
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000006e59d00000000, blocking 3, level 5 type Meta
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000006e59d00000000, block 3, level 5, l_block 3, dwn 1
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:3996 lockres M000000000000000006e59d00000000 blocked.
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_prepare_downconvert:3293 lock M000000000000000006e59d00000000, new_level = 3, l_blocking = 3
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_downconvert_lock:3313 lock M000000000000000006e59d00000000, level 5 => 3
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01600000000, action 2, unlock 0, level 3, newlevel 5
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:4020 lockres M000000000000000006e59d00000000, requeue = no.
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000006e59d00000000, action 3, unlock 0, level 5, newlevel 3
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:3996 lockres M000000000000000003f00400000000 blocked.
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:4020 lockres M000000000000000003f00400000000, requeue = yes.
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:3996 lockres M000000000000000003f00400000000 blocked.
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_prepare_downconvert:3293 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_downconvert_lock:3313 lock M000000000000000003f00400000000, level 3 => 0
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:4020 lockres M000000000000000003f00400000000, requeue = no.
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb  1 15:12:49 bull-02 kernel: (7014,2,alternate):__ocfs2_cluster_lock:1424 lock M000000000000000003f00400000000, convert from 0 to 5
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock O000000000000000004f18000000000, action 1, unlock 0, level -1, newlevel 3
Feb  1 15:12:49 bull-02 kernel: (7073,0,make_panic):__ocfs2_cluster_lock:1424 lock N000000000003f016, convert from -1 to 3
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000006e59d00000000, blocking 5, level 3 type Meta
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000006e59d00000000, block 5, level 3, l_block 5, dwn 1
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:3996 lockres M000000000000000006e59d00000000 blocked.
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_prepare_downconvert:3293 lock M000000000000000006e59d00000000, new_level = 0, l_blocking = 5
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_downconvert_lock:3313 lock M000000000000000006e59d00000000, level 3 => 0
Feb  1 15:12:49 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:4020 lockres M000000000000000006e59d00000000, requeue = no.
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000006e59d00000000, action 3, unlock 0, level 3, newlevel 0
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000004f180f5dfe12c, action 1, unlock 0, level -1, newlevel 5
Feb  1 15:12:49 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000004f18000000000, action 1, unlock 0, level -1, newlevel 5
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 5
Feb  1 15:12:50 bull-02 kernel: (7014,2,alternate):__ocfs2_cluster_lock:1424 lock W000000000000000003f00435e4a660, convert from 0 to 5
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f00400000000, blocking 3, level 5 type Meta
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f00400000000, block 3, level 5, l_block 3, dwn 1
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f01900000000, blocking 5, level 3 type Meta
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f01900000000, block 5, level 3, l_block 5, dwn 1
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:3996 lockres M000000000000000003f00400000000 blocked.
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 5 type Meta
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f00400000000, block 5, level 5, l_block 5, dwn 1
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_prepare_downconvert:3293 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_downconvert_lock:3313 lock M000000000000000003f00400000000, level 5 => 0
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:4020 lockres M000000000000000003f00400000000, requeue = no.
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:3996 lockres M000000000000000003f01900000000 blocked.
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_prepare_downconvert:3293 lock M000000000000000003f01900000000, new_level = 0, l_blocking = 5
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_downconvert_lock:3313 lock M000000000000000003f01900000000, level 3 => 0
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 3, unlock 0, level 5, newlevel 0
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:4020 lockres M000000000000000003f01900000000, requeue = no.
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01900000000, action 3, unlock 0, level 3, newlevel 0
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_process_blocked_lock:3996 lockres M000000000000000003f00400000000 blocked.
Feb  1 15:12:50 bull-02 kernel: (6957,0,ocfs2dc):ocfs2_unblock_lock:3414 ERROR: lock M000000000000000003f00400000000, lvl 0 , blcklst 1, mask 1, type 0, flags 0x41, hold 0 0, act 0 0, req 0, block 0, pgen 24429
Feb  1 15:12:50 bull-02 kernel: ------------[ cut here ]------------
Message from syslogd at bull-02 at Feb  1 15:12:50 ...
 kernel:------------[ cut here ]------------
Feb  1 15:12:50 bull-02 kernel: (6930,2,dlm_astd):ocfs2_locking_ast:1104 lock W000000000000000003f00435e4a660, action 2, unlock 0, level 0, newlevel 5
Feb  1 15:12:50 bull-02 kernel: (6930,1,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000004eefc00000000, blocking 3, level 5 type Meta
Feb  1 15:12:50 bull-02 kernel: (6930,1,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000004eefc00000000, block 3, level 5, l_block 3, dwn 1
Feb  1 15:12:50 bull-02 kernel: (6930,1,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000000000b6354ea08, blocking 5, level 5 type Meta
Feb  1 15:12:50 bull-02 kernel: (6930,1,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000000000b6354ea08, block 5, level 5, l_block 5, dwn 1
Feb  1 15:12:50 bull-02 kernel: (6930,1,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f016, action 1, unlock 0, level -1, newlevel 3
Feb  1 15:12:50 bull-02 kernel: (7073,1,make_panic):__ocfs2_cluster_lock:1424 lock M000000000000000003f01500000000, convert from 0 to 3
Feb  1 15:12:50 bull-02 kernel: (6930,1,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f01500000000, action 2, unlock 0, level 0, newlevel 3
Feb  1 15:12:50 bull-02 kernel: (6930,1,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f01800000000, blocking 3, level 5 type Meta
Feb  1 15:12:50 bull-02 kernel: (6930,1,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f01800000000, block 3, level 5, l_block 3, dwn 1
Feb  1 15:12:50 bull-02 kernel: kernel BUG at fs/ocfs2/dlmglue.c:3417!
Feb  1 15:12:50 bull-02 kernel: invalid opcode: 0000 [#1] SMP
Feb  1 15:12:50 bull-02 kernel: last sysfs file: /sys/devices/pci0000:80/0000:80:02.0/0000:86:01.0/local_cpus
Feb  1 15:12:50 bull-02 kernel: CPU 0
Feb  1 15:12:50 bull-02 kernel: Modules linked in: ocfs2_stack_user dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath amd64_edac_mod edac_core tg3 shpchp serio_raw i2c_nforce2 i2c_core k8temp qla2xxx ata_generic mptspi scsi_transport_fc pata_acpi mptscsih mptbase scsi_transport_spi scsi_tgt pata_amd sata_nv [last unloaded: scsi_wait_scan]
Feb  1 15:12:50 bull-02 kernel: Pid: 6957, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
Feb  1 15:12:50 bull-02 kernel: RIP: 0010:[<ffffffffa020de29>]  [<ffffffffa020de29>] ocfs2_downconvert_thread+0x4cb/0xdad [ocfs2]
Feb  1 15:12:50 bull-02 kernel: RSP: 0018:ffff88007abb7d90  EFLAGS: 00010046
Feb  1 15:12:50 bull-02 kernel: RAX: 00000000000000b9 RBX: ffff88007b99bd50 RCX: 0000000000008506
Feb  1 15:12:50 bull-02 kernel: RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
Feb  1 15:12:50 bull-02 kernel: RBP: ffff88007abb7ee0 R08: ffff88007abb7c80 R09: 0000000000000000
Feb  1 15:12:50 bull-02 kernel: R10: 0000000000000004 R11: 000000107abb7900 R12: 0000000000000282
Feb  1 15:12:50 bull-02 kernel: R13: 0000000000000000 R14: ffff88013a000000 R15: ffff88007b99bd68
Feb  1 15:12:50 bull-02 kernel: FS:  00007f11c9de2710(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
Feb  1 15:12:50 bull-02 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb  1 15:12:50 bull-02 kernel: CR2: 00007f7c6df2f000 CR3: 000000013d11c000 CR4: 00000000000006f0
Feb  1 15:12:50 bull-02 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  1 15:12:50 bull-02 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  1 15:12:50 bull-02 kernel: Process ocfs2dc (pid: 6957, threadinfo ffff88007abb6000, task ffff88007d3cc5c0)
Feb  1 15:12:50 bull-02 kernel: Stack:
Feb  1 15:12:50 bull-02 kernel: ffff88007b99bd98 ffffffff00000000 ffff880000000001 ffffffff00000001
Feb  1 15:12:50 bull-02 kernel: <0> 0000000000000000 0000000000000041 0000000000000000 ffff880000000000
Feb  1 15:12:50 bull-02 kernel: <0> ffffffff00000000 ffff880100000000 ffff880000000000 ffffffff00000000
Feb  1 15:12:50 bull-02 kernel: Call Trace:
Feb  1 15:12:50 bull-02 kernel: [<ffffffff81074f6b>] ? autoremove_wake_function+0x0/0x39
Feb  1 15:12:50 bull-02 kernel: [<ffffffffa020d95e>] ? ocfs2_downconvert_thread+0x0/0xdad [ocfs2]
Feb  1 15:12:50 bull-02 kernel: [<ffffffff81074c7e>] kthread+0x7f/0x87
Feb  1 15:12:50 bull-02 kernel: [<ffffffff81012cea>] child_rip+0xa/0x20
Feb  1 15:12:50 bull-02 kernel: [<ffffffff81074bff>] ? kthread+0x0/0x87
Feb  1 15:12:50 bull-02 kernel: [<ffffffff81012ce0>] ? child_rip+0x0/0x20
Feb  1 15:12:50 bull-02 kernel: Code: 24 10 8b 43 68 89 44 24 08 48 8d 43 48 48 89 04 24 31 c0 e8 dd 2e 22 e1 f6 43 40 04 74 0d 4c 8d 63 48 c7 45 8c 00 00 00 00 eb 04 <0f> 0b eb fe 48 8b 4b 40 f6 c1 02 0f 84 2d 01 00 00 80 e5 04 74
Feb  1 15:12:50 bull-02 kernel: RIP  [<ffffffffa020de29>] ocfs2_downconvert_thread+0x4cb/0xdad [ocfs2]
Feb  1 15:12:50 bull-02 kernel: RSP <ffff88007abb7d90>
Feb  1 15:12:50 bull-02 kernel: ---[ end trace 692271ffad8ccf0d ]---
