From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 27 Feb 2014 00:58:24 +0000
Subject: [Ocfs2-devel] Is it an isssue, or any patchs, thanks a lot
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC3B120@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As we test the performance of ocfs2, and found that one node is always blocked.
The ocfs2 module code we merged from 3.11 to 3.2.50.
My co-worker analysis the log and said that it may be the hard ware which lead to the resut.
Is there any other advices?
Thanks a lot.

root at cvknode7:~# numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
node 0 size: 8157 MB
node 0 free: 6937 MB
node 1 cpus: 8 9 10 11 12 13 14 15
node 1 size: 8191 MB
node 1 free: 7436 MB
node distances:
node   0   1
  0:  10  21
  1:  21  10



Feb 26 19:16:01 cvknode7 CRON[35625]: (CRON) info (No MTA installed, discarding output)
Feb 26 19:16:27 cvknode7 kernel: [13795.021452] ------------[ cut here ]------------
Feb 26 19:16:27 cvknode7 kernel: [13795.021465] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9a/0xc0()
Feb 26 19:16:27 cvknode7 kernel: [13795.021467] Hardware name: FlexServer B590
Feb 26 19:16:27 cvknode7 kernel: [13795.021468] Watchdog detected hard LOCKUP on cpu 0
Feb 26 19:16:27 cvknode7 kernel: [13795.021470] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse dm_multipath serio_raw joydev sb_edac hpilo edac_core mac_hid ioatdma lp acpi_power_meter dca parport usbhid hid bnx2x libcrc32c mdio hpsa
Feb 26 19:16:27 cvknode7 kernel: [13795.021527] Pid: 4880, comm: ocfs2dc Tainted: G        W  O 3.2.50 #1
Feb 26 19:16:27 cvknode7 kernel: [13795.021529] Call Trace:
Feb 26 19:16:27 cvknode7 kernel: [13795.021530]  <NMI>  [<ffffffff81066daf>] warn_slowpath_common+0x7f/0xc0
Feb 26 19:16:27 cvknode7 kernel: [13795.021543]  [<ffffffff81066ea6>] warn_slowpath_fmt+0x46/0x50
Feb 26 19:16:27 cvknode7 kernel: [13795.021547]  [<ffffffff8101b833>] ? native_sched_clock+0x13/0x80
Feb 26 19:16:27 cvknode7 kernel: [13795.021551]  [<ffffffff810d6b1a>] watchdog_overflow_allback+0x9a/0xc0
Feb 26 19:16:27 cvknode7 kernel: [13795.021556]  [<ffffffff8110eb76>] __perf_event_overflow+0x96/0x1f0
Feb 26 19:16:27 cvknode7 kernel: [13795.021559]  [<ffffffff8110c491>] ? perf_event_update_userpage+0x11/0xc0
Feb 26 19:16:27 cvknode7 kernel: [13795.021564]  [<ffffffff8102468a>] ? x86_perf_event_set_period+0xda/0x150
Feb 26 19:16:27 cvknode7 kernel: [13795.021567]  [<ffffffff8110f534>] perf_event_overflow+0x14/0x20
Feb 26 19:16:27 cvknode7 kernel: [13795.021571]  [<ffffffff81028c93>] intel_pmu_handle_irq+0x163/0x2e0
Feb 26 19:16:27 cvknode7 kernel: [13795.021581]  [<ffffffff81644b01>] perf_event_nmi_handler+0x21/0x30
Feb 26 19:16:27 cvknode7 kernel: [13795.021584]  [<ffffffff816443d1>] do_nmi+0x101/0x350
Feb 26 19:16:27 cvknode7 kernel: [13795.021587]  [<ffffffff81643a30>] nmi+0x20/0x30
Feb 26 19:16:27 cvknode7 kernel: [13795.021594]  [<ffffffff8103db15>] ? __ticket_spin_lock+0x25/0x30
Feb 26 19:16:27 cvknode7 kernel: [13795.021595]  <<EOE>>  <IRQ>  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Feb 26 19:16:27 cvknode7 kernel: [13795.021620]  [<ffffffffa0450487>] ocfs2_wake_downconvert_thread+0x27/0x60 [ocfs2]
Feb 26 19:16:27 cvknode7 kernel: [13795.021632]  [<ffffffffa0450554>] __ocfs2_cluster_unlock.isra.32+0x94/0xf0 [ocfs2]
Feb 26 19:16:27 cvknode7 kernel: [13795.021643]  [<ffffffffa0450b2b>] ocfs2_rw_unlock+0x6b/0xe0 [ocfs2]
Feb 26 19:16:27 cvknode7 kernel: [13795.021648]  [<ffffffff811aa22f>] ? bio_free+0x5f/0x70
Feb 26 19:16:27 cvknode7 kernel: [13795.021658]  [<ffffffffa043aa2a>] ocfs2_dio_end_io+0x6a/0x110 [ocfs2]
Feb 26 19:16:27 cvknode7 kernel: [13795.021661]  [<ffffffff811ad806>] dio_complete+0xe6/0xf0
Feb 26 19:16:27 cvknode7 kernel: [13795.021664]  [<ffffffff811ad87d>] dio_bio_end_aio+0x6d/0xc0
Feb 26 19:16:27 cvknode7 kernel: [13795.021667]  [<ffffffff816432d5>] ? _raw_spin_lock_irq+0x15/0x20
Feb 26 19:16:27 cvknode7 kernel: [13795.021670]  [<ffffffff811a8ecd>] bio_endio+0x1d/0x40
Feb 26 19:16:27 cvknode7 kernel: [13795.021675]  [<ffffffff812ebaf3>] req_bio_endio.isra.45+0xa3/0xe0
Feb 26 19:16:27 cvknode7 kernel: [13795.021678]  [<ffffffff812ec23d>] blk_update_request+0xfd/0x480
Feb 26 19:16:27 cvknode7 kernel: [13795.021681]  [<ffffffff812ec5f1>] blk_update_bidi_request+0x31/0x90
Feb 26 19:16:27 cvknode7 kernel: [13795.021684]  [<ffffffff812ed8ec>] blk_end_bidi_request+0x2c/0x80
Feb 26 19:16:27 cvknode7 kernel: [13795.021687]  [<ffffffff812ed980>] blk_end_request+0x10/0x20
Feb 26 19:16:27 cvknode7 kernel: [13795.021692]  [<ffffffff814229bf>] scsi_io_completion+0xaf/0x630
Feb 26 19:16:27 cvknode7 kernel: [13795.021698]  [<ffffffff81418ebc>] scsi_finish_command+0xcc/0x130
Feb 26 19:16:27 cvknode7 kernel: [13795.021701]  [<ffffffff8142281e>] scsi_softirq_done+0x13e/0x150
Feb 26 19:16:27 cvknode7 kernel: [13795.021705]  [<ffffffff812f38b3>] blk_done_softirq+0x83/0xa0
Feb 26 19:16:27 cvknode7 kernel: [13795.021710]  [<ffffffff8104f835>] ? check_preempt_curr+0x75/0xa0
Feb 26 19:16:27 cvknode7 kernel: [13795.021714]  [<ffffffff8106e438>] __do_softirq+0xa8/0x210
Feb 26 19:16:27 cvknode7 kernel: [13795.021716]  [<ffffffff8104f89d>] ? ttwu_do_wakeup+0x3d/0x120
Feb 26 19:16:27 cvknode7 kernel: [13795.021722]  [<ffffffff8164d3ec>] call_softirq+0x1c/0x30
Feb 26 19:16:27 cvknode7 kernel: [13795.021728]  [<ffffffff81016205>] do_softirq+0x65/0xa0
Feb 26 19:16:27 cvknode7 kernel: [13795.021730]  [<ffffffff8106e81e>] irq_exit+0x8e/0xb0
Feb 26 19:16:27 cvknode7 kernel: [13795.021734]  [<ffffffff810313c5>] smp_call_function_single_interrupt+0x35/0x40
Feb 26 19:16:27 cvknode7 kernel: [13795.021737]  [<ffffffff8164ce5e>] call_function_single_interrupt+0x6e/0x80
Feb 26 19:16:27 cvknode7 kernel: [13795.021739]  <EOI>  [<ffffffffa0282a72>] ? o2net_send_message_vec+0x142/0x9f0 [ocfs2_nodemanager]
Feb 26 19:16:27 cvknode7 kernel: [13795.021752]  [<ffffffff8103dafd>] ? __ticket_spin_lock+0xd/0x30
Feb 26 19:16:27 cvknode7 kernel: [13795.021755]  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Feb 26 19:16:27 cvknode7 kernel: [13795.021766]  [<ffffffffa045362f>] ocfs2_downconvert_thread+0x1af/0xc50 [ocfs2]
Feb 26 19:16:27 cvknode7 kernel: [13795.021769]  [<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Feb 26 19:16:27 cvknode7 kernel: [13795.021775]  [<ffffffff8108a6b0>] ? add_wait_queue+0x60/0x60
Feb 26 19:16:27 cvknode7 kernel: [13795.021786]  [<ffffffffa0453480>] ? ocfs2_downconvert_lock+0x250/0x250 [ocfs2]
Feb 26 19:16:27 cvknode7 kernel: [13795.021789]  [<ffffffff81089c0c>] kthread+0x8c/0xa0
Feb 26 19:16:27 cvknode7 kernel: [13795.021792]  [<ffffffff8164d2f4>] kernel_thread_helper+0x4/0x10
Feb 26 19:16:27 cvknode7 kernel: [13795.021795]  [<ffffffff81089b80>] ? flush_kthread_worker+0xa0/0xa0
Feb 26 19:16:27 cvknode7 kernel: [13795.021798]  [<ffffffff8164d2f0>] ? gs_change+0x13/0x13
Feb 26 19:16:27 cvknode7 kernel: [13795.021800] ---[ end trace 54aca07eb6804380 ]---
Feb 26 19:16:27 cvknode7 kernel: [13804.327684] ------------[ cut here ]------------
Feb 26 19:16:27 cvknode7 kernel: [13804.327695] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9a/0xc0()
Feb 26 19:16:27 cvknode7 kernel: [13804.327697] Hardware name: FlexServer B590
Feb 26 19:16:27 cvknode7 kernel: [13804.327698] Watchdog detected hard LOCKUP on cpu 5
Feb 26 19:16:27 cvknode7 kernel: [13804.327700] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse dm_multipath serio_raw joydev sb_edac hpilo edac_core mac_hid ioatdma lp acpi_power_meter dca parport usbhid hid bnx2x libcrc32c mdio hpsa
Feb 26 19:16:27 cvknode7 kernel: [13804.327752] Pid: 7842, comm: kworker/u:2 Tainted: G        W  O 3.2.50 #1
Feb 26 19:16:27 cvknode7 kernel: [13804.327753] Call Trace:
Feb 26 19:16:27 cvknode7 kernel: [13804.327755]  <NMI>  [<ffffffff81066daf>] warn_slowpath_common+0x7f/0xc0
Feb 26 19:16:27 cvknode7 kernel: [13804.327764]  [<ffffffff81066ea6>] warn_slowpath_fmt+0x46/0x50
Feb 26 19:16:27 cvknode7 kernel: [13804.327768]  [<ffffffff8101b833>] ? native_sched_clock+0x13/0x80
Feb 26 19:16:27 cvknode7 kernel: [13804.327771]  [<ffffffff810d6b1a>] watchdog_overflow_callback+0x9a/0xc0
Feb 26 19:16:27 cvknode7 kernel: [13804.327775]  [<ffffffff8110eb76>] __perf_event_overflow+0x96/0x1f0
Feb 26 19:16:27 cvknode7 kernel: [13804.327778]  [<ffffffff8110c491>] ? perf_event_update_userpage+0x11/0xc0
Feb 26 19:16:27 cvknode7 kernel: [13804.327782]  [<ffffffff8102468a>] ? x86_perf_event_set_period+0xda/0x150
Feb 26 19:16:27 cvknode7 kernel: [13804.327785]  [<ffffffff8110f534>] perf_event_overflow+0x14/0x20
Feb 26 19:16:27 cvknode7 kernel: [13804.327789]  [<ffffffff81028c93>] intel_pmu_handle_irq+0x163/0x2e0
Feb 26 19:16:27 cvknode7 kernel: [13804.327795]  [<ffffffff81644b01>] perf_event_nmi_handler+0x21/0x30
Feb 26 19:16:27 cvknode7 kernel: [13804.327798]  [<ffffffff816443d1>] do_nmi+0x101/0x350
Feb 26 19:16:27 cvknode7 kernel: [13804.327801]  [<ffffffff81643a30>] nmi+0x20/0x30
Feb 26 19:16:27 cvknode7 kernel: [13804.327805]  [<ffffffff8103db12>] ? __ticket_spin_lock+0x22/0x30
Feb 26 19:16:27 cvknode7 kernel: [13804.327807]  <<EOE>>  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Feb 26 19:16:27 cvknode7 kernel: [13804.327834]  [<ffffffffa044e034>] ocfs2_schedule_blocked_lock+0x84/0x130 [ocfs2]
Feb 26 19:16:27 cvknode7 kernel: [13804.327847]  [<ffffffffa045590b>] ocfs2_blocking_ast+0x24b/0x2b0 [ocfs2]
Feb 26 19:16:27 cvknode7 kernel: [13804.327856]  [<ffffffffa02b4fea>] ? __dlm_lookup_lockres_full+0xba/0x130 [ocfs2_dlm]
Feb 26 19:16:27 cvknode7 kernel: [13804.327861]  [<ffffffffa00e5020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Feb 26 19:16:27 cvknode7 kernel: [13804.327864]  [<ffffffffa00e5034>] o2dlm_blocking_ast_wrapper+0x14/0x20 [ocfs2_stack_o2cb]
Feb 26 19:16:27 cvknode7 kernel: [13804.327872]  [<ffffffffa02ce6eb>] dlm_do_local_bast+0x4b/0xe0 [ocfs2_dlm]
Feb 26 19:16:27 cvknode7 kernel: [13804.327877]  [<ffffffffa02b51f8>] ? dlm_lookup_lockres+0x88/0xa0 [ocfs2_dlm]
Feb 26 19:16:27 cvknode7 kernel: [13804.327881]  [<ffffffffa02cef86>] dlm_proxy_ast_handler+0x806/0xa10 [ocfs2_dlm]
Feb 26 19:16:27 cvknode7 kernel: [13804.327887]  [<ffffffff81077e5c>] ? mod_timer+0x24c/0x2f0
Feb 26 19:16:27 cvknode7 kernel: [13804.327892]  [<ffffffff810823fe>] ? queue_delayed_work_on+0xbe/0x1a0
Feb 26 19:16:27 cvknode7 kernel: [13804.327909]  [<ffffffffa0280002>] ? o2net_handler_tree_lookup+0x22/0xc0 [ocfs2_nodemanager]
Feb 26 19:16:27 cvknode7 kernel: [13804.327915]  [<ffffffffa0282036>] o2net_rx_until_empty+0x506/0xe00 [ocfs2_nodemanager]
Feb 26 19:16:27 cvknode7 kernel: [13804.327920]  [<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Feb 26 19:16:27 cvknode7 kernel: [13804.327924]  [<ffffffff810843c7>] process_one_work+0x127/0x470
Feb 26 19:16:27 cvknode7 kernel: [13804.327927]  [<ffffffff810854a4>] worker_thread+0x164/0x370
Feb 26 19:16:27 cvknode7 kernel: [13804.327930]  [<ffffffff81085340>] ? manage_workers.isra.31+0x230/0x230
Feb 26 19:16:27 cvknode7 kernel: [13804.327934]  [<ffffffff81089c0c>] kthread+0x8c/0xa0
Feb 26 19:16:27 cvknode7 kernel: [13804.327938]  [<ffffffff8164d2f4>] kernel_thread_helper+0x4/0x10
Feb 26 19:16:27 cvknode7 kernel: [13804.327941]  [<ffffffff81089b80>] ? flush_kthread_worker+0xa0/0xa0
Feb 26 19:16:27 cvknode7 kernel: [13804.327944]  [<ffffffff8164d2f0>] ? gs_change+0x13/0x13
Feb 26 19:16:27 cvknode7 kernel: [13804.327946] ---[ end trace 54aca07eb6804381 ]---
Feb 26 19:16:27 cvknode7 kernel: [13815.194830] o2net: Connection to node cvknode9 (num 5) at 192.168.3.9:7100 shutdown, state 8
Feb 26 19:16:27 cvknode7 kernel: [13815.199118] o2net: Connection to node cvknode9 (num 5) at 192.168.3.9:7100 has been idle for 30.76 secs, shutting it down.
Feb 26 19:16:27 cvknode7 kernel: [13815.199123] o2net_idle_timer 1598: Local and remote node is heartbeating, and try connect
Feb 26 19:16:27 cvknode7 kernel: [13815.234687] o2net: Connection to node cvknode4 (num 3) at 192.168.3.4:7100 shutdown, state 8
Feb 26 19:16:27 cvknode7 kernel: [13815.263054] o2net: Connection to node cvknode4 (num 3) at 192.168.3.4:7100 has been idle for 30.60 secs, shutting it down.
Feb 26 19:16:27 cvknode7 kernel: [13815.263061] o2net_idle_timer 1598: Local and remote node is heartbeating, and try connect
Feb 26 19:16:28 cvknode7 kernel: [13816.349993] o2net: Connection to node cvknode13 (num 2) at 192.168.3.13:7100 has been idle for 30.81 secs, shutting it down.
Feb 26 19:16:28 cvknode7 kernel: [13816.349998] o2net_idle_timer 1598: Local and remote node is heartbeating, and try connect
Feb 26 19:16:29 cvknode7 kernel: [13816.419584] ------------[ cut here ]------------
Feb 26 19:16:29 cvknode7 kernel: [13816.419599] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9a/0xc0()
Feb 26 19:16:29 cvknode7 kernel: [13816.419601] Hardware name: FlexServer B590
Feb 26 19:16:29 cvknode7 kernel: [13816.419603] Watchdog detected hard LOCKUP on cpu 27
Feb 26 19:16:29 cvknode7 kernel: [13816.419604] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse dm_multipath serio_raw joydev sb_edac hpilo edac_core mac_hid ioatdma lp acpi_power_meter dca parport usbhid hid bnx2x libcrc32c mdio hpsa
Feb 26 19:16:29 cvknode7 kernel: [13816.419670] Pid: 4308, comm: lichd Tainted: G        W  O 3.2.50 #1
Feb 26 19:16:29 cvknode7 kernel: [13816.419672] Call Trace:
Feb 26 19:16:29 cvknode7 kernel: [13816.419674]  <NMI>  [<ffffffff81066daf>] warn_slowpath_common+0x7f/0xc0
Feb 26 19:16:29 cvknode7 kernel: [13816.419688]  [<ffffffff81066ea6>] warn_slowpath_fmt+0x46/0x50
Feb 26 19:16:29 cvknode7 kernel: [13816.419693]  [<ffffffff8101b833>] ? native_sched_clock+0x13/0x80
Feb 26 19:16:29 cvknode7 kernel: [13816.419696]  [<ffffffff810d6b1a>] watchdog_overflow_callback+0x9a/0xc0
Feb 26 19:16:29 cvknode7 kernel: [13816.419702]  [<ffffffff8110eb76>] __perf_event_overflow+0x96/0x1f0
Feb 26 19:16:29 cvknode7 kernel: [13816.419706]  [<ffffffff8110c491>] ? perf_event_update_userpage+0x11/0xc0
Feb 26 19:16:29 cvknode7 kernel: [13816.419712]  [<ffffffff8102468a>] ? x86_perf_event_set_period+0xda/0x150
Feb 26 19:16:29 cvknode7 kernel: [13816.419715]  [<ffffffff8110f534>] perf_event_overflow+0x14/0x20
Feb 26 19:16:29 cvknode7 kernel: [13816.419720]  [<ffffffff81028c93>] intel_pmu_handle_irq+0x163/0x2e0
Feb 26 19:16:29 cvknode7 kernel: [13816.419731]  [<ffffffff81644b01>] perf_event_nmi_handler+0x21/0x30
Feb 26 19:16:29 cvknode7 kernel: [13816.419734]  [<ffffffff816443d1>] do_nmi+0x101/0x350
Feb 26 19:16:29 cvknode7 kernel: [13816.419738]  [<ffffffff81643a30>] nmi+0x20/0x30
Feb 26 19:16:29 cvknode7 kernel: [13816.419745]  [<ffffffff8103db15>] ? __ticket_spin_lock+0x25/0x30
Feb 26 19:16:29 cvknode7 kernel: [13816.419747]  <<EOE>>  <IRQ>  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Feb 26 19:16:29 cvknode7 kernel: [13816.419809]  [<ffffffffa0450487>] ocfs2_wake_downconvert_thread+0x27/0x60 [ocfs2]
Feb 26 19:16:29 cvknode7 kernel: [13816.419820]  [<ffffffffa0450554>] __ocfs2_cluster_unlock.isra.32+0x94/0xf0 [ocfs2]
Feb 26 19:16:29 cvknode7 kernel: [13816.419832]  [<ffffffffa0450b2b>] ocfs2_rw_unlock+0x6b/0xe0 [ocfs2]
Feb 26 19:16:29 cvknode7 kernel: [13816.419838]  [<ffffffff811aa22f>] ? bio_free+0x5f/0x70
Feb 26 19:16:29 cvknode7 kernel: [13816.419848]  [<ffffffffa043aa2a>] ocfs2_dio_end_io+0x6a/0x110 [ocfs2]
Feb 26 19:16:29 cvknode7 kernel: [13816.419852]  [<ffffffff811ad806>] dio_complete+0xe6/0xf0
Feb 26 19:16:29 cvknode7 kernel: [13816.419855]  [<ffffffff811ad87d>] dio_bio_end_aio+0x6d/0xc0
Feb 26 19:16:29 cvknode7 kernel: [13816.419859]  [<ffffffff811a8ecd>] bio_endio+0x1d/0x40
Feb 26 19:16:29 cvknode7 kernel: [13816.419866]  [<ffffffff812ebaf3>] req_bio_endio.isra.45+0xa3/0xe0
Feb 26 19:16:29 cvknode7 kernel: [13816.419869]  [<ffffffff812ec23d>] blk_update_request+0xfd/0x480
Feb 26 19:16:29 cvknode7 kernel: [13816.419871]  [<ffffffff812ec5f1>] blk_update_bidi_request+0x31/0x90
Feb 26 19:16:29 cvknode7 kernel: [13816.419875]  [<ffffffff812ed8ec>] blk_end_bidi_request+0x2c/0x80
Feb 26 19:16:29 cvknode7 kernel: [13816.419878]  [<ffffffff812ed980>] blk_end_request+0x10/0x20
Feb 26 19:16:29 cvknode7 kernel: [13816.419886]  [<ffffffff814229bf>] scsi_io_completion+0xaf/0x630
Feb 26 19:16:29 cvknode7 kernel: [13816.419893]  [<ffffffff81418ebc>] scsi_finish_command+0xcc/0x130
Feb 26 19:16:29 cvknode7 kernel: [13816.419896]  [<ffffffff8142281e>] scsi_softirq_done+0x13e/0x150
Feb 26 19:16:29 cvknode7 kernel: [13816.419901]  [<ffffffff812f38b3>] blk_done_softirq+0x83/0xa0
Feb 26 19:16:29 cvknode7 kernel: [13816.419906]  [<ffffffff8106e438>] __do_softirq+0xa8/0x210
Feb 26 19:16:29 cvknode7 kernel: [13816.419911]  [<ffffffff8164d3ec>] call_softirq+0x1c/0x30
Feb 26 19:16:29 cvknode7 kernel: [13816.419912]  <EOI>  [<ffffffff81016205>] do_softirq+0x65/0xa0
Feb 26 19:16:29 cvknode7 kernel: [13816.419922]  [<ffffffff8106daa4>] local_bh_enable+0x94/0xa0
Feb 26 19:16:29 cvknode7 kernel: [13816.419930]  [<ffffffff815393d1>] dev_queue_xmit+0x1c1/0x650
Feb 26 19:16:29 cvknode7 kernel: [13816.419938]  [<ffffffff815702ab>] ip_finish_output+0x16b/0x2f0
Feb 26 19:16:29 cvknode7 kernel: [13816.419941]  [<ffffffff81570df8>] ip_output+0x98/0xa0
Feb 26 19:16:29 cvknode7 kernel: [13816.419944]  [<ffffffff815704d4>] ? __ip_local_out+0xa4/0xb0
Feb 26 19:16:29 cvknode7 kernel: [13816.419946]  [<ffffffff81570509>] ip_local_out+0x29/0x30
Feb 26 19:16:29 cvknode7 kernel: [13816.419949]  [<ffffffff81570661>] ip_queue_xmit+0x151/0x3f0
Feb 26 19:16:29 cvknode7 kernel: [13816.419953]  [<ffffffff81587af0>] tcp_transmit_skb+0x400/0x8d0
Feb 26 19:16:29 cvknode7 kernel: [13816.419956]  [<ffffffff8158860f>] tcp_write_xmit+0xff/0xa70
Feb 26 19:16:29 cvknode7 kernel: [13816.419960]  [<ffffffff8158b260>] ? tcp_v4_md5_lookup+0x10/0x20
Feb 26 19:16:29 cvknode7 kernel: [13816.419962]  [<ffffffff81588fe6>] __tcp_push_pending_frames+0x26/0x90
Feb 26 19:16:29 cvknode7 kernel: [13816.419967]  [<ffffffff8157b866>] do_tcp_setsockopt.isra.31+0x726/0x7b0
Feb 26 19:16:29 cvknode7 kernel: [13816.419974]  [<ffffffff810908ad>] ? sched_clock_cpu+0xbd/0x110
Feb 26 19:16:29 cvknode7 kernel: [13816.419977]  [<ffffffff8152d986>] ? verify_iovec+0x56/0xd0
Feb 26 19:16:29 cvknode7 kernel: [13816.419983]  [<ffffffff81520f56>] ? ___sys_sendmsg+0x396/0x3b0
Feb 26 19:16:29 cvknode7 kernel: [13816.419987]  [<ffffffff8151ecca>] ? sock_poll+0x1a/0x20
Feb 26 19:16:29 cvknode7 kernel: [13816.419994]  [<ffffffff811b76d5>] ? ep_send_events_proc+0x65/0x110
Feb 26 19:16:29 cvknode7 kernel: [13816.419997]  [<ffffffff8103dba9>] ? default_spin_lock_flags+0x9/0x10
Feb 26 19:16:29 cvknode7 kernel: [13816.420000]  [<ffffffff811b8063>] ? ep_scan_ready_list.isra.7+0x183/0x190
Feb 26 19:16:29 cvknode7 kernel: [13816.420004]  [<ffffffff811b8c73>] ? sys_epoll_wait+0x93/0x440
Feb 26 19:16:29 cvknode7 kernel: [13816.420007]  [<ffffffff8157b953>] tcp_setsockopt+0x33/0x40
Feb 26 19:16:29 cvknode7 kernel: [13816.420010]  [<ffffffff815241c4>] sock_common_setsockopt+0x14/0x20
Feb 26 19:16:29 cvknode7 kernel: [13816.420013]  [<ffffffff8152319f>] sys_setsockopt+0x7f/0xe0
Feb 26 19:16:29 cvknode7 kernel: [13816.420017]  [<ffffffff8164b182>] system_call_fastpath+0x16/0x1b
Feb 26 19:16:29 cvknode7 kernel: [13816.420019] ---[ end trace 54aca07eb6804382 ]---
Feb 26 19:16:29 cvknode7 kernel: [13817.221256] BUG: soft lockup - CPU#19 stuck for 23s! [lichd:4335]
Feb 26 19:16:29 cvknode7 kernel: [13817.221264] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse dm_multipath serio_raw joydev sb_edac hpilo edac_core mac_hid ioatdma lp acpi_power_meter dca parport usbhid hid bnx2x libcrc32c mdio hpsa
Feb 26 19:16:29 cvknode7 kernel: [13817.221342] CPU 19
Feb 26 19:16:29 cvknode7 kernel: [13817.221343] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse dm_multipath serio_raw joydev sb_edac hpilo edac_core mac_hid ioatdma lp acpi_power_meter dca parport usbhid hid bnx2x libcrc32c mdio hpsa
Feb 26 19:16:29 cvknode7 kernel: [13817.221370]
Feb 26 19:16:29 cvknode7 kernel: [13817.221373] Pid: 4335, comm: lichd Tainted: G        W  O 3.2.50 #1 H3C FlexServer B590
Feb 26 19:16:29 cvknode7 kernel: [13817.221376] RIP: 0010:[<ffffffff810458a2>]  [<ffffffff810458a2>] native_flush_tlb_others+0x122/0x140
Feb 26 19:16:29 cvknode7 kernel: [13817.221389] RSP: 0018:ffff880222ef3d68  EFLAGS: 00000246
Feb 26 19:16:29 cvknode7 kernel: [13817.221391] RAX: 0000000000000000 RBX: dead000000100100 RCX: 0000000000000004
Feb 26 19:16:29 cvknode7 kernel: [13817.221393] RDX: 0000000000000019 RSI: 0000000000000100 RDI: ffffffff81e08d18
Feb 26 19:16:29 cvknode7 kernel: [13817.221394] RBP: ffff880222ef3da8 R08: ffff88023756db60 R09: 0000000000000100
Feb 26 19:16:29 cvknode7 kernel: [13817.221396] R10: dead000000100100 R11: dead000000200200 R12: ffff88023760db60
Feb 26 19:16:29 cvknode7 kernel: [13817.221398] R13: ffff880222ef3da8 R14: ffffffff813067a6 R15: ffff880222ef3cd8
Feb 26 19:16:29 cvknode7 kernel: [13817.221400] FS:  00007fa82ffff700(0000) GS:ffff880237560000(0000) knlGS:0000000000000000
Feb 26 19:16:29 cvknode7 kernel: [13817.221401] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb 26 19:16:29 cvknode7 kernel: [13817.221403] CR2: 00007fa88863b000 CR3: 0000000430bf8000 CR4: 00000000000406e0
Feb 26 19:16:29 cvknode7 kernel: [13817.221405] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 26 19:16:29 cvknode7 kernel: [13817.221407] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 26 19:16:29 cvknode7 kernel: [13817.221409] Process lichd (pid: 4335, threadinfo ffff880222ef2000, task ffff88022eacade0)
Feb 26 19:16:29 cvknode7 kernel: [13817.221410] Stack:
Feb 26 19:16:29 cvknode7 kernel: [13817.221413]  ffffffffffffffff ffff88022f739f80 00007fa888800000 ffff88022f739f80
Feb 26 19:16:29 cvknode7 kernel: [13817.221420]  ffff88022f73a240 ffff88043115a160 ffff8802308a6210 00007fa88863c000
Feb 26 19:16:29 cvknode7 kernel: [13817.221423]  ffff880222ef3dc8 ffffffff8104598b ffff88043115a0b0 ffff880222ef3e40
Feb 26 19:16:29 cvknode7 kernel: [13817.221428] Call Trace:
Feb 26 19:16:29 cvknode7 kernel: [13817.221434]  [<ffffffff8104598b>] flush_tlb_mm+0x5b/0xa0
Feb 26 19:16:29 cvknode7 kernel: [13817.221439]  [<ffffffff811380d6>] tlb_flush_mmu+0x46/0x90
Feb 26 19:16:29 cvknode7 kernel: [13817.221442]  [<ffffffff81138134>] tlb_finish_mmu+0x14/0x40
Feb 26 19:16:29 cvknode7 kernel: [13817.221447]  [<ffffffff8113f6ad>] unmap_region+0x10d/0x130
Feb 26 19:16:29 cvknode7 kernel: [13817.221454]  [<ffffffff8118a6fc>] ? d_free+0x4c/0x70
Feb 26 19:16:29 cvknode7 kernel: [13817.221466]  [<ffffffff81642fee>] ? _raw_spin_lock+0xe/0x20
Feb 26 19:16:29 cvknode7 kernel: [13817.221471]  [<ffffffff8119214e>] ? vfsmount_lock_local_unlock+0x1e/0x30
Feb 26 19:16:29 cvknode7 kernel: [13817.221475]  [<ffffffff81193b80>] ? mntput_no_expire+0x30/0xf0
Feb 26 19:16:29 cvknode7 kernel: [13817.221478]  [<ffffffff81140968>] do_munmap+0x318/0x3a0
Feb 26 19:16:29 cvknode7 kernel: [13817.221481]  [<ffffffff81141cd3>] sys_munmap+0x53/0x80
Feb 26 19:16:29 cvknode7 kernel: [13817.221488]  [<ffffffff8164b182>] system_call_fastpath+0x16/0x1b
Feb 26 19:16:29 cvknode7 kernel: [13817.221490] Code: 2e 0f 1f 84 00 00 00 00 00 48 8b 05 11 89 c9 00 41 8d b6 cf 00 00 00 4c 89 e7 ff 90 d0 00 00 00 eb 09 0f 1f 80 00 00 00 00 f3 90 <be> 00 01 00 00 4c 89 e7 e8 b1 fc 2c 00 85 c0 74 ed e9 59 ff ff
Feb 26 19:16:29 cvknode7 kernel: [13817.221521] Call Trace:
Feb 26 19:16:29 cvknode7 kernel: [13817.221523]  [<ffffffff8104598b>] flush_tlb_mm+0x5b/0xa0
Feb 26 19:16:29 cvknode7 kernel: [13817.221525]  [<ffffffff811380d6>] tlb_flush_mmu+0x46/0x90
Feb 26 19:16:29 cvknode7 kernel: [13817.221528]  [<ffffffff81138134>] tlb_finish_mmu+0x14/0x40
Feb 26 19:16:29 cvknode7 kernel: [13817.221530]  [<ffffffff8113f6ad>] unmap_region+0x10d/0x130
Feb 26 19:16:29 cvknode7 kernel: [13817.221533]  [<ffffffff8118a6fc>] ? d_free+0x4c/0x70
Feb 26 19:16:29 cvknode7 kernel: [13817.221536]  [<ffffffff81642fee>] ? _raw_spin_lock+0xe/0x20
Feb 26 19:16:29 cvknode7 kernel: [13817.221539]  [<ffffffff8119214e>] ? vfsmount_lock_local_unlock+0x1e/0x30
Feb 26 19:16:29 cvknode7 kernel: [13817.221542]  [<ffffffff81193b80>] ? mntput_no_expire+0x30/0xf0
Feb 26 19:16:29 cvknode7 kernel: [13817.221545]  [<ffffffff81140968>] do_munmap+0x318/0x3a0
Feb 26 19:16:29 cvknode7 kernel: [13817.221547]  [<ffffffff81141cd3>] sys_munmap+0x53/0x80
Feb 26 19:16:29 cvknode7 kernel: [13817.221550]  [<ffffffff8164b182>] system_call_fastpath+0x16/0x1b
Feb 26 19:16:57 cvknode7 kernel: [13845.193836] BUG: soft lockup - CPU#19 stuck for 22s! [lichd:4335]
Feb 26 19:16:57 cvknode7 kernel: [13845.193852] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse dm_multipath serio_raw joydev sb_edac hpilo edac_core mac_hid ioatdma lp acpi_power_meter dca parport usbhid hid bnx2x libcrc32c mdio hpsa
Feb 26 19:16:57 cvknode7 kernel: [13845.193895] CPU 19
Feb 26 19:16:57 cvknode7 kernel: [13845.193896] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse dm_multipath serio_raw joydev sb_edac hpilo edac_core mac_hid ioatdma lp acpi_power_meter dca parport usbhid hid bnx2x libcrc32c mdio hpsa
Feb 26 19:16:57 cvknode7 kernel: [13845.193934]
Feb 26 19:16:57 cvknode7 kernel: [13845.193936] Pid: 4335, comm: lichd Tainted: G        W  O 3.2.50 #1 H3C FlexServer B590
Feb 26 19:16:57 cvknode7 kernel: [13845.193939] RIP: 0010:[<ffffffff81315560>]  [<ffffffff81315560>] kasprintf+0x40/0x40
Feb 26 19:16:57 cvknode7 kernel: [13845.193947] RSP: 0018:ffff880222ef3d60  EFLAGS: 00000246
Feb 26 19:16:57 cvknode7 kernel: [13845.193948] RAX: 0000000000000000 RBX: dead000000100100 RCX: 0000000000000004
Feb 26 19:16:57 cvknode7 kernel: [13845.193950] RDX: 0000000000000019 RSI: 0000000000000100 RDI: ffffffff81e08d18
Feb 26 19:16:57 cvknode7 kernel: [13845.193951] RBP: ffff880222ef3da8 R08: ffff88023756db60 R09: 0000000000000100
Feb 26 19:16:57 cvknode7 kernel: [13845.193953] R10: dead000000100100 R11: dead000000200200 R12: ffff88023760db60
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140227/0c70d73f/attachment-0001.html 
