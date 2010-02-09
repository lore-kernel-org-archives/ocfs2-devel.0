From: David Teigland <teigland@redhat.com>
Date: Tue, 9 Feb 2010 14:55:08 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Plugs race between the dc thread
	and an unlock ast message
In-Reply-To: <4B6CABA7.4020502@oracle.com>
References: <1265221014-10591-1-git-send-email-sunil.mushran@oracle.com>
	<20100204102729.GA4339@laptop.oracle.com>
	<4B6B21BE.10708@oracle.com> <20100205060148.GA3416@mail.oracle.com>
	<4B6C65F3.8000805@oracle.com>
	<20100205193313.GG11402@wotan.suse.de>
	<4B6CABA7.4020502@oracle.com>
Message-ID: <20100209205508.GF29766@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 05, 2010 at 03:37:11PM -0800, Sunil Mushran wrote:
> Mark Fasheh wrote:
> >I really want to say that we should prevent those two threads from racing 
> >in
> >the first place. How to do that though might be problematic. I'm not sure
> >simply spinning on OCFS2_LOCK_QUEUED might not be enough - that flag gets
> >cleared before the ->post_unlock callback...
> 
> David,
> 
> Please could you rerun with the following debug patch.
> 
> http://oss.oracle.com/~smushran/.dlmglue/0001-ocfs2-Patch-to-debug-hang-in-dlmglue-when-running-dl.patch
> 
> May make sense to fire it either later in the day or fire mlocate
> a shortwhile after starting the test. That's to reduce the trace logs.

BUG hit just five minutes after starting make_panic and alternate on four
nodes.  (I can send history before this if you need.)

Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_locking_ast:1104 lock M0000000000000000097bda00000000, action 3, unlock 0, level 3, newlevel 0
Feb  9 14:09:52 bull-05 kernel: (7085,0,alternate):__ocfs2_cluster_lock:1424 lock M000000000000000003f00400000000, convert from 0 to 3
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000003f00400000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres M000000000000000003f00400000000, requeue = yes.
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000003f00400000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_prepare_downconvert:3300 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_downconvert_lock:3320 lock M000000000000000003f00400000000, level 3 => 0
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres M000000000000000003f00400000000, requeue = no.
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb  9 14:09:52 bull-05 kernel: (7085,0,alternate):__ocfs2_cluster_lock:1424 lock M000000000000000003f00400000000, convert from 0 to 3
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000003f00400000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres M000000000000000003f00400000000, requeue = yes.
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000003f00400000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_prepare_downconvert:3300 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_downconvert_lock:3320 lock M000000000000000003f00400000000, level 3 => 0
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres M000000000000000003f00400000000, requeue = no.
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb  9 14:09:52 bull-05 kernel: (7085,0,alternate):__ocfs2_cluster_lock:1424 lock M000000000000000003f00400000000, convert from 0 to 3
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb  9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000009732800000000, action 2, unlock 0, level 0, newlevel 5
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000003f00400000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres M000000000000000003f00400000000, requeue = yes.
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000003f00400000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_locking_ast:1104 lock N000000000003f028, action 1, unlock 0, level -1, newlevel 3
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_prepare_downconvert:3300 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_downconvert_lock:3320 lock M000000000000000003f00400000000, level 3 => 0
Feb  9 14:09:52 bull-05 kernel: (7009,0,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres M000000000000000003f00400000000, requeue = no.
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb  9 14:09:52 bull-05 kernel: (7085,0,alternate):__ocfs2_cluster_lock:1424 lock M000000000000000003f00400000000, convert from 0 to 3
Feb  9 14:09:52 bull-05 kernel: (7083,3,make_panic):__ocfs2_cluster_lock:1424 lock W0000000000000000056e1934638d85, convert from -1 to 5
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb  9 14:09:52 bull-05 kernel: (6696,0,ocfs2_wq):__ocfs2_cluster_lock:1424 lock O000000000000000009732800000000, convert from 3 to 5
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres N000000000003f020, blocking 5, level 3 type Dentry
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres N000000000003f020, block 5, level 3, l_block 5, dwn 1
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000003f00400000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres M000000000000000003f00400000000, requeue = yes.
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres N000000000003f020 blocked.
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_unblock_lock:3544 lock N000000000003f020, UNBLOCK_STOP_POST
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres N000000000003f020, requeue = no.
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_unlock_ast:3075 UNLOCK AST called on lock N000000000003f020, action = 2
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000003f00400000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_unlock_ast:3075 UNLOCK AST called on lock O000000000000000009732800000000, action = 2
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000008f41000000000, blocking 3, level 5 type Meta
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000008f41000000000, block 3, level 5, l_block 3, dwn 1
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_unlock_ast:3075 UNLOCK AST called on lock M000000000000000009732800000000, action = 2
Feb  9 14:09:52 bull-05 kernel: (6696,0,ocfs2_wq):__ocfs2_cluster_lock:1424 lock M0000000000000000097bda00000000, convert from 0 to 5
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000009732800000000, blocking 5, level -1 type Meta
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000009732800000000, block 5, level -1, l_block 5, dwn 1
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_prepare_downconvert:3300 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_downconvert_lock:3320 lock M000000000000000003f00400000000, level 3 => 0
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres M000000000000000003f00400000000, requeue = no.
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000008f41000000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (7084,0,make_panic):__ocfs2_cluster_lock:1424 lock O000000000000000008e0d900000000, convert from -1 to 3
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_prepare_downconvert:3300 lock M000000000000000008f41000000000, new_level = 3, l_blocking = 3
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_downconvert_lock:3320 lock M000000000000000008f41000000000, level 5 => 3
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb  9 14:09:52 bull-05 kernel: (7085,0,alternate):__ocfs2_cluster_lock:1424 lock M000000000000000003f00400000000, convert from 0 to 3
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000008f41000000000, action 3, unlock 0, level 5, newlevel 3
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_locking_ast:1104 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_blocking_ast:1059 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb  9 14:09:52 bull-05 kernel: (6983,2,dlm_astd):ocfs2_generic_handle_bast:932 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_process_blocked_lock:4028 lockres M000000000000000008f41000000000, requeue = no.
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_process_blocked_lock:4004 lockres M000000000000000009732800000000 blocked.
Feb  9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):ocfs2_prepare_downconvert:3295 ERROR: lock M000000000000000009732800000000, lvl -1 <= 0, blcklst 1, mask 1, type 0, flags 0x104, hold 0 0, act 0 0, req 5, block 5, pgen 7
Feb  9 14:09:52 bull-05 kernel: ------------[ cut here ]------------
Feb  9 14:09:52 bull-05 kernel: kernel BUG@fs/ocfs2/dlmglue.c:3296!
Feb  9 14:09:52 bull-05 kernel: invalid opcode: 0000 [#1] SMP 
Feb  9 14:09:52 bull-05 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/0000:03:00.0/irq
Feb  9 14:09:52 bull-05 kernel: CPU 2 
Feb  9 14:09:52 bull-05 kernel: Modules linked in: ocfs2_stack_user dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath amd64_edac_mod edac_core i2c_nforce2 shpchp k8temp i2c_core tg3 serio_raw qla2xxx mptspi mptscsih ata_generic scsi_transport_fc pata_acpi mptbase scsi_tgt scsi_transport_spi sata_nv pata_amd [last unloaded: scsi_wait_scan]
Feb  9 14:09:52 bull-05 kernel: Pid: 7009, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
Feb  9 14:09:52 bull-05 kernel: RIP: 0010:[<ffffffffa01d9632>]  [<ffffffffa01d9632>] ocfs2_prepare_downconvert+0x121/0x1c0 [ocfs2]
Feb  9 14:09:52 bull-05 kernel: RSP: 0018:ffff88007aaabd40  EFLAGS: 00010082
Feb  9 14:09:52 bull-05 kernel: RAX: 00000000000000c2 RBX: ffff880114d19098 RCX: 000000000000e8a4
Feb  9 14:09:52 bull-05 kernel: RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
Feb  9 14:09:52 bull-05 kernel: RBP: ffff88007aaabdc0 R08: 0007ffffffffffff R09: 0000000000000000
Feb  9 14:09:52 bull-05 kernel: R10: 0000000000000000 R11: ffff88002821dd00 R12: 0000000000000000
Feb  9 14:09:52 bull-05 kernel: R13: 0000000000000000 R14: ffff88007cd41000 R15: ffff880114d19068
Feb  9 14:09:52 bull-05 kernel: FS:  00007f6e99054710(0000) GS:ffff880082000000(0000) knlGS:0000000000000000
Feb  9 14:09:52 bull-05 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb  9 14:09:52 bull-05 kernel: CR2: 00007f9acad1a000 CR3: 000000013a47d000 CR4: 00000000000006e0
Feb  9 14:09:52 bull-05 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  9 14:09:52 bull-05 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  9 14:09:52 bull-05 kernel: Process ocfs2dc (pid: 7009, threadinfo ffff88007aaaa000, task ffff88007aad1740)
Feb  9 14:09:52 bull-05 kernel: Stack:
Feb  9 14:09:52 bull-05 kernel: ffff880114d19098 ffff8801ffffffff 0000000000000000 ffff880100000001
Feb  9 14:09:52 bull-05 kernel: <0> ffff880000000001 ffff880100000000 0000000000000104 ffffffff00000000
Feb  9 14:09:52 bull-05 kernel: <0> ffff880000000000 ffffffff00000000 ffff880100000000 ffff880100000005
Feb  9 14:09:52 bull-05 kernel: Call Trace:
Feb  9 14:09:52 bull-05 kernel: [<ffffffffa01dd337>] ocfs2_downconvert_thread+0x954/0xd02 [ocfs2]
Feb  9 14:09:52 bull-05 kernel: [<ffffffff8104e867>] ? finish_task_switch+0x58/0x77
Feb  9 14:09:52 bull-05 kernel: [<ffffffff81074f6b>] ? autoremove_wake_function+0x0/0x39
Feb  9 14:09:52 bull-05 kernel: [<ffffffffa01dc9e3>] ? ocfs2_downconvert_thread+0x0/0xd02 [ocfs2]
Feb  9 14:09:52 bull-05 kernel: [<ffffffff81074c7e>] kthread+0x7f/0x87
Feb  9 14:09:52 bull-05 kernel: [<ffffffff81012cea>] child_rip+0xa/0x20
Feb  9 14:09:52 bull-05 kernel: [<ffffffff81074bff>] ? kthread+0x0/0x87
Feb  9 14:09:52 bull-05 kernel: [<ffffffff81012ce0>] ? child_rip+0x0/0x20
Feb  9 14:09:52 bull-05 kernel: Code: 43 18 89 7c 24 08 48 c7 c7 52 b7 23 a0 44 89 64 24 10 0f 94 c0 48 83 c3 48 0f b6 c0 48 89 1c 24 89 44 24 18 31 c0 e8 c1 76 25 e1 <0f> 0b eb fe 48 ba 00 00 08 00 02 00 00 00 48 85 15 99 94 fb ff 
Feb  9 14:09:52 bull-05 kernel: RIP  [<ffffffffa01d9632>] ocfs2_prepare_downconvert+0x121/0x1c0 [ocfs2]
Feb  9 14:09:52 bull-05 kernel: RSP <ffff88007aaabd40>
Feb  9 14:09:52 bull-05 kernel: ---[ end trace 3d047094e011f93c ]---
