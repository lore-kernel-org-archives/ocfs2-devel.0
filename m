From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 27 Mar 2014 11:45:07 +0000
Subject: [Ocfs2-devel] Hi, is it an issue,
	or had been fixed in new kernel verions? Thanks
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC3DA3B@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

One node A shutdown, another node B recovery It, but the node B panic and should re-powered to avoid it.
There are many soft lockup msg in the syslog.
The test environment is Ubuntu 12.04 with kernel 3.2.50.
The log digested is as below.

Mar 27 00:54:20 cvknode5 kernel: [ 5121.328969] o2net: No connection established with node 8 after 30.0 seconds, giving up.
Mar 27 00:54:20 cvknode5 kernel: [ 5121.328978] o2net_set_nn_state 578: Local and remote node is heartbeating, and try connect
Mar 27 00:54:20 cvknode5 kernel: [ 5121.994075] o2net_set_nn_state 581: Local or remote node is not heartbeating, not try connect
Mar 27 00:54:20 cvknode5 kernel: [ 5122.101757] o2cb: o2dlm has evicted node 8 from domain F803D818039043EBA0D0590A05E8076B
Mar 27 00:54:21 cvknode5 kernel: [ 5123.104931] o2dlm: Waiting on the recovery of node 8 in domain F803D818039043EBA0D0590A05E8076B
Mar 27 00:54:22 cvknode5 kernel: [ 5123.724936] o2dlm: Begin recovery on domain F803D818039043EBA0D0590A05E8076B for node 8
Mar 27 00:54:22 cvknode5 kernel: [ 5123.726360] o2dlm: Node 1 (me) is the Recovery Master for the dead node 8 in domain F803D818039043EBA0D0590A05E8076B
Mar 27 00:54:27 cvknode5 kernel: [ 5128.726079] o2dlm: End recovery on domain F803D818039043EBA0D0590A05E8076B
Mar 27 00:54:52 cvknode5 kernel: [ 5153.721118] BUG: soft lockup - CPU#11 stuck for 22s! [dlm_thread:17918]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760610] Modules linked in: ocfs2(O) quota_tree ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs joydev usbhid hid ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc dm_multipath psmouse serio_raw sb_edac edac_core hpilo ioatdma dca video acpi_power_meter mac_hid lp parport hpsa bnx2x libcrc32c mdio [last unloaded: configfs]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760661] CPU 11
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760662] Modules linked in: ocfs2(O) quota_tree ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs joydev usbhid hid ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc dm_multipath psmouse serio_raw sb_edac edac_core hpilo ioatdma dca video acpi_power_meter mac_hid lp parport hpsa bnx2x libcrc32c mdio [last unloaded: configfs]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760691]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760693] Pid: 17918, comm: dlm_thread Tainted: G        W  O 3.2.50 #1 H3C FlexServer B390
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760697] RIP: 0010:[<ffffffff8103db15>]  [<ffffffff8103db15>] __ticket_spin_lock+0x25/0x30
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760707] RSP: 0018:ffff8806055efd00  EFLAGS: 00000292
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760709] RAX: 000000000000f9f8 RBX: 0000000100126f06 RCX: 00000000000000ff
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760711] RDX: 000000000000056f RSI: ffff8806056ff9b8 RDI: ffff8806056ffa00
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760712] RBP: ffff8806055efd00 R08: ffff880615d66028 R09: ffff880615d65bc0
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760714] R10: ffff8806056ff980 R11: ffff8806056ffa30 R12: ffff8806055efc90
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760716] R13: 0000000000000282 R14: ffff880617dd44d0 R15: ffffffff810773d2
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760718] FS:  0000000000000000(0000) GS:ffff880c3f6a0000(0000) knlGS:0000000000000000
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760720] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760722] CR2: 00007f12275d83d0 CR3: 0000000001c05000 CR4: 00000000000426e0
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760724] DR0: 0000000000000003 DR1: 00000000000000b0 DR2: 0000000000000001
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760726] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760728] Process dlm_thread (pid: 17918, threadinfo ffff8806055ee000, task ffff880615d65bc0)
Mar 27 00:54:52 cvknode5 kernel: [ 5153.760729] Stack:
Mar 27 00:54:52 cvknode5 kernel: [ 5153.798675]  ffff8806055efd10 ffffffff81642fee ffff8806055efd70 ffffffffa0414476
Mar 27 00:54:52 cvknode5 kernel: [ 5153.798679]  ffff8806055efd40 ffff8806055efd40 0000000000000286 ffff880608fc0a70
Mar 27 00:54:52 cvknode5 kernel: [ 5153.798683]  ffff8806055efd50 ffffffff81642fee ffff880605fa8810 ffff880605fa8800
Mar 27 00:54:52 cvknode5 kernel: [ 5153.798687] Call Trace:
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835695]  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835704]  [<ffffffffa0414476>] __dlm_queue_bast+0x86/0x150 [ocfs2_dlm]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835708]  [<ffffffff81642fee>] ? _raw_spin_lock+0xe/0x20
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835712]  [<ffffffffa03ff6f7>] dlm_thread+0x897/0x1740 [ocfs2_dlm]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835717]  [<ffffffff8101b8a9>] ? sched_clock+0x9/0x10
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835722]  [<ffffffff810908ad>] ? sched_clock_cpu+0xbd/0x110
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835728]  [<ffffffff8108a6b0>] ? add_wait_queue+0x60/0x60
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835732]  [<ffffffffa03fee60>] ? __dlm_dirty_lockres+0x130/0x130 [ocfs2_dlm]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835736]  [<ffffffff81089c0c>] kthread+0x8c/0xa0
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835741]  [<ffffffff8164d2f4>] kernel_thread_helper+0x4/0x10
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835744]  [<ffffffff81089b80>] ? flush_kthread_worker+0xa0/0xa0
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835747]  [<ffffffff8164d2f0>] ? gs_change+0x13/0x13
Mar 27 00:54:52 cvknode5 kernel: [ 5153.835749] Code: 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949781] Call Trace:
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949790]  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949795]  [<ffffffffa0414476>] __dlm_queue_bast+0x86/0x150 [ocfs2_dlm]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949798]  [<ffffffff81642fee>] ? _raw_spin_lock+0xe/0x20
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949802]  [<ffffffffa03ff6f7>] dlm_thread+0x897/0x1740 [ocfs2_dlm]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949804]  [<ffffffff8101b8a9>] ? sched_clock+0x9/0x10
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949807]  [<ffffffff810908ad>] ? sched_clock_cpu+0xbd/0x110
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949810]  [<ffffffff8108a6b0>] ? add_wait_queue+0x60/0x60
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949814]  [<ffffffffa03fee60>] ? __dlm_dirty_lockres+0x130/0x130 [ocfs2_dlm]
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949817]  [<ffffffff81089c0c>] kthread+0x8c/0xa0
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949820]  [<ffffffff8164d2f4>] kernel_thread_helper+0x4/0x10
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949823]  [<ffffffff81089b80>] ? flush_kthread_worker+0xa0/0xa0
Mar 27 00:54:52 cvknode5 kernel: [ 5153.949826]  [<ffffffff8164d2f0>] ? gs_change+0x13/0x13
Mar 27 00:55:00 cvknode5 kernel: [ 5161.157117] BUG: soft lockup - CPU#6 stuck for 22s! [ocfs2rec:36720]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194491] Modules linked in: ocfs2(O) quota_tree ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs joydev usbhid hid ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc dm_multipath psmouse serio_raw sb_edac edac_core hpilo ioatdma dca video acpi_power_meter mac_hid lp parport hpsa bnx2x libcrc32c mdio [last unloaded: configfs]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194527] CPU 6
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194528] Modules linked in: ocfs2(O) quota_tree ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs joydev usbhid hid ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc dm_multipath psmouse serio_raw sb_edac edac_core hpilo ioatdma dca video acpi_power_meter mac_hid lp parport hpsa bnx2x libcrc32c mdio [last unloaded: configfs]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194557]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194559] Pid: 36720, comm: ocfs2rec Tainted: G        W  O 3.2.50 #1 H3C FlexServer B390
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194562] RIP: 0010:[<ffffffff8103db15>]  [<ffffffff8103db15>] __ticket_spin_lock+0x25/0x30
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194568] RSP: 0018:ffff880606fff9e0  EFLAGS: 00000297
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194569] RAX: 00000000000003c1 RBX: ffff880606fff980 RCX: 0000000000000000
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194571] RDX: 00000000000003c2 RSI: ffff880c16442f80 RDI: ffff880608fc0870
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194573] RBP: ffff880606fff9e0 R08: 0000000000000000 R09: ffff880c0b146440
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194575] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880606fff960
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194576] R13: ffff880608fc0800 R14: ffff880c0b146440 R15: ffff880c15004000
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194578] FS:  0000000000000000(0000) GS:ffff880c3f600000(0000) knlGS:0000000000000000
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194580] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194582] CR2: 00007fffba310dc8 CR3: 0000000001c05000 CR4: 00000000000426e0
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194584] DR0: 0000000000000001 DR1: 0000000000000002 DR2: 0000000000000001
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194586] DR3: 000000000000000a DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194588] Process ocfs2rec (pid: 36720, threadinfo ffff880606ffe000, task ffff880609b616f0)
Mar 27 00:55:00 cvknode5 kernel: [ 5161.194589] Stack:
Mar 27 00:55:00 cvknode5 kernel: [ 5161.230701]  ffff880606fff9f0 ffffffff81642fee ffff880606fffa20 ffffffffa04143c5
Mar 27 00:55:00 cvknode5 kernel: [ 5161.230705]  0000000000000001 ffff880c0b146440 0000000000000001 ffff880c16442f80
Mar 27 00:55:00 cvknode5 kernel: [ 5161.230709]  ffff880606fffa80 ffffffffa04174a4 ffff880606fffa80 ffffffffa0417a24
Mar 27 00:55:00 cvknode5 kernel: [ 5161.230713] Call Trace:
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266276]  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266283]  [<ffffffffa04143c5>] dlm_queue_ast+0x35/0x60 [ocfs2_dlm]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266289]  [<ffffffffa04174a4>] dlmlock_master+0x194/0x530 [ocfs2_dlm]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266294]  [<ffffffffa0417a24>] ? dlm_new_lock+0xd4/0x170 [ocfs2_dlm]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266298]  [<ffffffffa0418305>] dlmlock+0x845/0x1500 [ocfs2_dlm]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266302]  [<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266306]  [<ffffffffa0118020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266309]  [<ffffffff8101b319>] ? read_tsc+0x9/0x20
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266313]  [<ffffffff81093e0d>] ? ktime_get_ts+0xad/0xe0
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266316]  [<ffffffff8103dba9>] ? default_spin_lock_flags+0x9/0x10
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266319]  [<ffffffffa0118635>] o2cb_dlm_lock+0x65/0x7c [ocfs2_stack_o2cb]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266324]  [<ffffffffa0118000>] ? 0xffffffffa0117fff
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266327]  [<ffffffffa0118020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266332]  [<ffffffffa01124d5>] ocfs2_dlm_lock+0x25/0x50 [ocfs2_stackglue]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266359]  [<ffffffffa05ac01e>] __ocfs2_cluster_lock.isra.34+0x3de/0x810 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266379]  [<ffffffffa060bc70>] ? ocfs2_set_buffer_uptodate+0x30/0x5b0 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266391]  [<ffffffffa05bab57>] ? ocfs2_validate_inode_block+0x57/0x220 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266406]  [<ffffffffa060b969>] ? ocfs2_metadata_cache_io_unlock+0x19/0x20 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266419]  [<ffffffffa05ad64e>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266432]  [<ffffffffa05bdc7b>] ? ocfs2_read_inode_block_full+0x3b/0x60 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266444]  [<ffffffffa05c4d3d>] __ocfs2_recovery_thread+0x66d/0x1230 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266450]  [<ffffffff8105472a>] ? finish_task_switch+0x4a/0xf0
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266462]  [<ffffffffa05c46d0>] ? ocfs2_check_journals_nolocks+0x150/0x150 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266465]  [<ffffffff81089c0c>] kthread+0x8c/0xa0
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266469]  [<ffffffff8164d2f4>] kernel_thread_helper+0x4/0x10
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266472]  [<ffffffff81089b80>] ? flush_kthread_worker+0xa0/0xa0
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266475]  [<ffffffff8164d2f0>] ? gs_change+0x13/0x13
Mar 27 00:55:00 cvknode5 kernel: [ 5161.266477] Code: 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374744] Call Trace:
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374748]  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374753]  [<ffffffffa04143c5>] dlm_queue_ast+0x35/0x60 [ocfs2_dlm]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374758]  [<ffffffffa04174a4>] dlmlock_master+0x194/0x530 [ocfs2_dlm]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374762]  [<ffffffffa0417a24>] ? dlm_new_lock+0xd4/0x170 [ocfs2_dlm]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374766]  [<ffffffffa0418305>] dlmlock+0x845/0x1500 [ocfs2_dlm]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374769]  [<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374772]  [<ffffffffa0118020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374774]  [<ffffffff8101b319>] ? read_tsc+0x9/0x20
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374777]  [<ffffffff81093e0d>] ? ktime_get_ts+0xad/0xe0
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374780]  [<ffffffff8103dba9>] ? default_spin_lock_flags+0x9/0x10
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374783]  [<ffffffffa0118635>] o2cb_dlm_lock+0x65/0x7c [ocfs2_stack_o2cb]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374788]  [<ffffffffa0118000>] ? 0xffffffffa0117fff
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374791]  [<ffffffffa0118020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374794]  [<ffffffffa01124d5>] ocfs2_dlm_lock+0x25/0x50 [ocfs2_stackglue]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374806]  [<ffffffffa05ac01e>] __ocfs2_cluster_lock.isra.34+0x3de/0x810 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374822]  [<ffffffffa060bc70>] ? ocfs2_set_buffer_uptodate+0x30/0x5b0 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374834]  [<ffffffffa05bab57>] ? ocfs2_validate_inode_block+0x57/0x220 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374848]  [<ffffffffa060b969>] ? ocfs2_metadata_cache_io_unlock+0x19/0x20 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374860]  [<ffffffffa05ad64e>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374872]  [<ffffffffa05bdc7b>] ? ocfs2_read_inode_block_full+0x3b/0x60 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374885]  [<ffffffffa05c4d3d>] __ocfs2_recovery_thread+0x66d/0x1230 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374888]  [<ffffffff8105472a>] ? finish_task_switch+0x4a/0xf0
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374900]  [<ffffffffa05c46d0>] ? ocfs2_check_journals_nolocks+0x150/0x150 [ocfs2]
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374903]  [<ffffffff81089c0c>] kthread+0x8c/0xa0
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374906]  [<ffffffff8164d2f4>] kernel_thread_helper+0x4/0x10
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374909]  [<ffffffff81089b80>] ? flush_kthread_worker+0xa0/0xa0
Mar 27 00:55:00 cvknode5 kernel: [ 5161.374912]  [<ffffffff8164d2f0>] ? gs_change+0x13/0x13
Mar 27 00:55:01 cvknode5 CRON[36939]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Mar 27 00:55:01 cvknode5 CRON[36940]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Mar 27 00:55:01 cvknode5 CRON[36941]: (root) CMD (   /opt/bin/ha_check_resource.sh)
Mar 27 00:55:01 cvknode5 CRON[36942]: (root) CMD (   /opt/bin/ha_cleanup.sh)
Mar 27 00:55:01 cvknode5 CRON[36943]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140327/e985d409/attachment-0001.html 
