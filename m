From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 21 Feb 2014 03:28:18 +0000
Subject: [Ocfs2-devel] Hi everyone,
 is it an issue? The host is blocked as the issue created. Thanks a
 lot.
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC3AD7B@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi everyone, as we test the performance of the ocfs2 with fio. As the test case running, one of host of ocfs2 cluster will be blocked a small time and restart sooner.
The test environment is that there are six host sharing one iSCSI LUN which capacity is about 1T and it is formatted with ocfs2, and mount point on every host is /vms/vStore.
All of the host's OS is ubuntu 12.04, and we upgrade the kernel with 3.2.50, and ocfs2 as compiled according with kernel 3.2.50.
We test the performance of the ocfs2 with fio on one every host.

The fio test configure is as below, and the filename is different on every host.
Such as file1...file5 is on host1, file6....file10 are on host2, and so on.

One example fio file is as below:
root at cvknode4:~/fios_test4# cat 1024k_10r
[global]
ioengine=libaio
rw=read
bs=1024K
time_based
runtime=180
size=9g
direct=1
iodepth=1

[file1]
filename=/vms/vStor/file41

[file2]
filename=/vms/vStor/file42

[file3]
filename=/vms/vStor/file43

[file4]
filename=/vms/vStor/file44

[file5]
filename=/vms/vStor/file45

As we start fio tools on the hosts sequent, several minute later, one host will blocked and restart(fenced).
Is it one issue of ocfs2? Or is there any fixed patch for it?

The syslog is as below:
Feb 19 17:50:01 cvknode9 CRON[16143]: (CRON) info (No MTA installed, discarding output)
Feb 19 17:50:01 cvknode9 CRON[16147]: (CRON) info (No MTA installed, discarding output)
Feb 19 17:50:01 cvknode9 CRON[16146]: (CRON) info (No MTA installed, discarding output)
Feb 19 17:50:01 cvknode9 CRON[16144]: (CRON) info (No MTA installed, discarding output)
Feb 19 17:50:01 cvknode9 CRON[16141]: (CRON) info (No MTA installed, discarding output)
Feb 19 17:50:02 cvknode9 CRON[16134]: (CRON) info (No MTA installed, discarding output)
Feb 19 17:50:03 cvknode9 crmadmin: [16194]: ERROR: admin_message_timeout: No messages received in 2 seconds
Feb 19 17:50:03 cvknode9 CRON[16140]: (CRON) info (No MTA installed, discarding output)
Feb 19 17:51:00 cvknode9 kernel: [  803.464977] ------------[ cut here ]------------
Feb 19 17:51:00 cvknode9 kernel: [  803.464991] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9a/0xc0()
Feb 19 17:51:00 cvknode9 kernel: [  803.464993] Hardware name: FlexServer B590
Feb 19 17:51:00 cvknode9 kernel: [  803.464995] Watchdog detected hard LOCKUP on cpu 0
Feb 19 17:51:00 cvknode9 kernel: [  803.464997] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse ioatdma dm_multipath serio_raw sb_edac hpilo edac_core dca acpi_power_meter mac_hid lp parport hpsa be2iscsi iscsi_boot_sysfs libiscsi be2net scsi_transport_iscsi
Feb 19 17:51:00 cvknode9 kernel: [  803.465065] Pid: 6029, comm: ocfs2dc Tainted: G           O 3.2.50 #1
Feb 19 17:51:00 cvknode9 kernel: [  803.465067] Call Trace:
Feb 19 17:51:00 cvknode9 kernel: [  803.465069]  <NMI>  [<ffffffff81066daf>] warn_slowpath_common+0x7f/0xc0
Feb 19 17:51:00 cvknode9 kernel: [  803.465084]  [<ffffffff81066ea6>] warn_slowpath_fmt+0x46/0x50
Feb 19 17:51:00 cvknode9 kernel: [  803.465089]  [<ffffffff8101b833>] ? native_sched_clock+0x13/0x80
Feb 19 17:51:00 cvknode9 kernel: [  803.465093]  [<ffffffff810d6b1a>] watchdog_overflow_callback+0x9a/0xc0
Feb 19 17:51:00 cvknode9 kernel: [  803.465099]  [<ffffffff8110eb76>] __perf_event_overflow+0x96/0x1f0
Feb 19 17:51:00 cvknode9 kernel: [  803.465103]  [<ffffffff8110c491>] ? perf_event_update_userpage+0x11/0xc0
Feb 19 17:51:00 cvknode9 kernel: [  803.465109]  [<ffffffff8102468a>] ? x86_perf_event_set_period+0xda/0x150
Feb 19 17:51:00 cvknode9 kernel: [  803.465113]  [<ffffffff8110f534>] perf_event_overflow+0x14/0x20
Feb 19 17:51:00 cvknode9 kernel: [  803.465118]  [<ffffffff81028c93>] intel_pmu_handle_irq+0x163/0x2e0
Feb 19 17:51:00 cvknode9 kernel: [  803.465130]  [<ffffffff81644b01>] perf_event_nmi_handler+0x21/0x30
Feb 19 17:51:00 cvknode9 kernel: [  803.465134]  [<ffffffff816443d1>] do_nmi+0x101/0x350
Feb 19 17:51:00 cvknode9 kernel: [  803.465138]  [<ffffffff81643a30>] nmi+0x20/0x30
Feb 19 17:51:00 cvknode9 kernel: [  803.465147]  [<ffffffff8103db15>] ? __ticket_spin_lock+0x25/0x30
Feb 19 17:51:00 cvknode9 kernel: [  803.465149]  <<EOE>>  <IRQ>  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Feb 19 17:51:00 cvknode9 kernel: [  803.465216]  [<ffffffffa03e5487>] ocfs2_wake_downconvert_thread+0x27/0x60 [ocfs2]
Feb 19 17:51:00 cvknode9 kernel: [  803.465231]  [<ffffffffa03e5554>] __ocfs2_cluster_unlock.isra.32+0x94/0xf0 [ocfs2]
Feb 19 17:51:00 cvknode9 kernel: [  803.465245]  [<ffffffffa03e5b2b>] ocfs2_rw_unlock+0x6b/0xe0 [ocfs2]
Feb 19 17:51:00 cvknode9 kernel: [  803.465252]  [<ffffffff811aa22f>] ? bio_free+0x5f/0x70
Feb 19 17:51:00 cvknode9 kernel: [  803.465264]  [<ffffffffa03cfa2a>] ocfs2_dio_end_io+0x6a/0x110 [ocfs2]
Feb 19 17:51:00 cvknode9 kernel: [  803.465268]  [<ffffffff811ad806>] dio_complete+0xe6/0xf0
Feb 19 17:51:00 cvknode9 kernel: [  803.465271]  [<ffffffff811ad87d>] dio_bio_end_aio+0x6d/0xc0
Feb 19 17:51:00 cvknode9 kernel: [  803.465275]  [<ffffffff816432d5>] ? _raw_spin_lock_irq+0x15/0x20
Feb 19 17:51:00 cvknode9 kernel: [  803.465279]  [<ffffffff811a8ecd>] bio_endio+0x1d/0x40
Feb 19 17:51:00 cvknode9 kernel: [  803.465286]  [<ffffffff812ebaf3>] req_bio_endio.isra.45+0xa3/0xe0
Feb 19 17:51:00 cvknode9 kernel: [  803.465290]  [<ffffffff812ec23d>] blk_update_request+0xfd/0x480
Feb 19 17:51:00 cvknode9 kernel: [  803.465293]  [<ffffffff812ec5f1>] blk_update_bidi_request+0x31/0x90
Feb 19 17:51:00 cvknode9 kernel: [  803.465297]  [<ffffffff812ed8ec>] blk_end_bidi_request+0x2c/0x80
Feb 19 17:51:00 cvknode9 kernel: [  803.465301]  [<ffffffff812ed980>] blk_end_request+0x10/0x20
Feb 19 17:51:00 cvknode9 kernel: [  803.465308]  [<ffffffff814229bf>] scsi_io_completion+0xaf/0x630
Feb 19 17:51:00 cvknode9 kernel: [  803.465316]  [<ffffffff81418ebc>] scsi_finish_command+0xcc/0x130
Feb 19 17:51:00 cvknode9 kernel: [  803.465319]  [<ffffffff8142281e>] scsi_softirq_done+0x13e/0x150
Feb 19 17:51:00 cvknode9 kernel: [  803.465325]  [<ffffffff812f38b3>] blk_done_softirq+0x83/0xa0
Feb 19 17:51:00 cvknode9 kernel: [  803.465331]  [<ffffffff8104f835>] ? check_preempt_curr+0x75/0xa0
Feb 19 17:51:00 cvknode9 kernel: [  803.465336]  [<ffffffff8106e438>] __do_softirq+0xa8/0x210
Feb 19 17:51:00 cvknode9 kernel: [  803.465339]  [<ffffffff8104f89d>] ? ttwu_do_wakeup+0x3d/0x120
Feb 19 17:51:00 cvknode9 kernel: [  803.465345]  [<ffffffff8164d3ec>] call_softirq+0x1c/0x30
Feb 19 17:51:00 cvknode9 kernel: [  803.465352]  [<ffffffff81016205>] do_softirq+0x65/0xa0
Feb 19 17:51:00 cvknode9 kernel: [  803.465355]  [<ffffffff8106e81e>] irq_exit+0x8e/0xb0
Feb 19 17:51:00 cvknode9 kernel: [  803.465361]  [<ffffffff810313c5>] smp_call_function_single_interrupt+0x35/0x40
Feb 19 17:51:00 cvknode9 kernel: [  803.465366]  [<ffffffff8164ce5e>] call_function_single_interrupt+0x6e/0x80
Feb 19 17:51:00 cvknode9 kernel: [  803.465368]  <EOI>  [<ffffffffa01eda72>] ? o2net_send_message_vec+0x142/0x9f0 [ocfs2_nodemanager]
Feb 19 17:51:00 cvknode9 kernel: [  803.465380]  [<ffffffff8103dafd>] ? __ticket_spin_lock+0xd/0x30
Feb 19 17:51:00 cvknode9 kernel: [  803.465384]  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Feb 19 17:51:00 cvknode9 kernel: [  803.465398]  [<ffffffffa03e862f>] ocfs2_downconvert_thread+0x1af/0xc50 [ocfs2]
Feb 19 17:51:00 cvknode9 kernel: [  803.465402]  [<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Feb 19 17:51:00 cvknode9 kernel: [  803.465408]  [<ffffffff8108a6b0>] ? add_wait_queue+0x60/0x60
Feb 19 17:51:00 cvknode9 kernel: [  803.465421]  [<ffffffffa03e8480>] ? ocfs2_downconvert_lock+0x250/0x250 [ocfs2]
Feb 19 17:51:00 cvknode9 kernel: [  803.465425]  [<ffffffff81089c0c>] kthread+0x8c/0xa0
Feb 19 17:51:00 cvknode9 kernel: [  803.465429]  [<ffffffff8164d2f4>] kernel_thread_helper+0x4/0x10
Feb 19 17:51:00 cvknode9 kernel: [  803.465433]  [<ffffffff81089b80>] ? flush_kthread_worker+0xa0/0xa0
Feb 19 17:51:00 cvknode9 kernel: [  803.465436]  [<ffffffff8164d2f0>] ? gs_change+0x13/0x13
Feb 19 17:51:00 cvknode9 kernel: [  803.465438] ---[ end trace aa7a8184efeebe01 ]---
Feb 19 17:51:15 cvknode9 kernel: [  819.045428] o2net: Connection to node cvmnode (num 2) at 192.168.3.5:7100 shutdown, state 8
Feb 19 17:51:15 cvknode9 kernel: [  819.049277] o2net: Connection to node cvmnode (num 2) at 192.168.3.5:7100 has been idle for 30.64 secs, shutting it down.
Feb 19 17:51:15 cvknode9 kernel: [  819.049284] o2net_idle_timer 1598: Local and remote node is heartbeating, and try connect
Feb 19 17:51:15 cvknode9 kernel: [  819.368962] o2net: Connection to node cvknode13 (num 6) at 192.168.3.13:7100 has been idle for 30.102 secs, shutting it down.
Feb 19 17:51:15 cvknode9 kernel: [  819.368973] o2net_idle_timer 1598: Local and remote node is heartbeating, and try connect
Feb 19 17:51:15 cvknode9 kernel: [  819.378952] o2net: Connection to node cvknode13 (num 6) at 192.168.3.13:7100 shutdown, state 8
Feb 19 17:51:19 cvknode9 kernel: [  822.754439] ------------[ cut here ]------------
Feb 19 17:51:19 cvknode9 kernel: [  822.754451] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9a/0xc0()
Feb 19 17:51:19 cvknode9 kernel: [  822.754454] Hardware name: FlexServer B590
Feb 19 17:51:19 cvknode9 kernel: [  822.754455] Watchdog detected hard LOCKUP on cpu 28
Feb 19 17:51:19 cvknode9 kernel: [  822.754457] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree drbd lru_cache 8021q garp stp vhost_net macvtap macvlan kvm_intel kvm ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse ioatdma dm_multipath serio_raw sb_edac hpilo edac_core dca acpi_power_meter mac_hid lp parport hpsa be2iscsi iscsi_boot_sysfs libiscsi be2net scsi_transport_iscsi
Feb 19 17:51:19 cvknode9 kernel: [  822.754530] Pid: 230, comm: kworker/u:1 Tainted: G        W  O 3.2.50 #1
Feb 19 17:51:19 cvknode9 kernel: [  822.754532] Call Trace:
Feb 19 17:51:19 cvknode9 kernel: [  822.754534]  <NMI>  [<ffffffff81066daf>] warn_slowpath_common+0x7f/0xc0
Feb 19 17:51:19 cvknode9 kernel: [  822.754546]  [<ffffffff81066ea6>] warn_slowpath_fmt+0x46/0x50
Feb 19 17:51:19 cvknode9 kernel: [  822.754551]  [<ffffffff8101b833>] ? native_sched_clock+0x13/0x80
Feb 19 17:51:19 cvknode9 kernel: [  822.754555]  [<ffffffff810d6b1a>] watchdog_overflow_callback+0x9a/0xc0
Feb 19 17:51:19 cvknode9 kernel: [  822.754559]  [<ffffffff8110eb76>] __perf_event_overflow+0x96/0x1f0
Feb 19 17:51:19 cvknode9 kernel: [  822.754563]  [<ffffffff8110c491>] ? perf_event_update_userpage+0x11/0xc0
Feb 19 17:51:19 cvknode9 kernel: [  822.754568]  [<ffffffff8102468a>] ? x86_perf_event_set_period+0xda/0x150
Feb 19 17:51:19 cvknode9 kernel: [  822.754572]  [<ffffffff8110f534>] perf_event_overflow+0x14/0x20
Feb 19 17:51:19 cvknode9 kernel: [  822.754576]  [<ffffffff81028c93>] intel_pmu_handle_irq+0x163/0x2e0
Feb 19 17:51:19 cvknode9 kernel: [  822.754583]  [<ffffffff81644b01>] perf_event_nmi_handler+0x21/0x30
Feb 19 17:51:19 cvknode9 kernel: [  822.754587]  [<ffffffff816443d1>] do_nmi+0x101/0x350
Feb 19 17:51:19 cvknode9 kernel: [  822.754591]  [<ffffffff81643a30>] nmi+0x20/0x30
Feb 19 17:51:19 cvknode9 kernel: [  822.754598]  [<ffffffff8103db15>] ? __ticket_spin_lock+0x25/0x30
Feb 19 17:51:19 cvknode9 kernel: [  822.754599]  <<EOE>>  [<ffffffff81642fee>] _raw_spin_lock+0xe/0x20
Feb 19 17:51:19 cvknode9 kernel: [  822.754669]  [<ffffffffa03e3034>] ocfs2_schedule_blocked_lock+0x84/0x130 [ocfs2]
Feb 19 17:51:19 cvknode9 kernel: [  822.754684]  [<ffffffffa03ea90b>] ocfs2_blocking_ast+0x24b/0x2b0 [ocfs2]
Feb 19 17:51:19 cvknode9 kernel: [  822.754692]  [<ffffffffa021ffea>] ? __dlm_lookup_lockres_full+0xba/0x130 [ocfs2_dlm]
Feb 19 17:51:19 cvknode9 kernel: [  822.754696]  [<ffffffff81642fee>] ? _raw_spin_lock+0xe/0x20
Feb 19 17:51:19 cvknode9 kernel: [  822.754700]  [<ffffffffa00ba020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Feb 19 17:51:19 cvknode9 kernel: [  822.754704]  [<ffffffffa00ba034>] o2dlm_blocking_ast_wrapper+0x14/0x20 [ocfs2_stack_o2cb]
Feb 19 17:51:19 cvknode9 kernel: [  822.754711]  [<ffffffffa02396eb>] dlm_do_local_bast+0x4b/0xe0 [ocfs2_dlm]
Feb 19 17:51:19 cvknode9 kernel: [  822.754716]  [<ffffffffa02201f8>] ? dlm_lookup_lockres+0x88/0xa0 [ocfs2_dlm]
Feb 19 17:51:19 cvknode9 kernel: [  822.754722]  [<ffffffffa0239f86>] dlm_proxy_ast_handler+0x806/0xa10 [ocfs2_dlm]
Feb 19 17:51:19 cvknode9 kernel: [  822.754728]  [<ffffffff81077e5c>] ? mod_timer+0x24c/0x2f0
Feb 19 17:51:19 cvknode9 kernel: [  822.754734]  [<ffffffff810823fe>] ? queue_delayed_work_on+0xbe/0x1a0
Feb 19 17:51:19 cvknode9 kernel: [  822.754741]  [<ffffffffa01eb003>] ? o2net_handler_tree_lookup+0x23/0xc0 [ocfs2_nodemanager]
Feb 19 17:51:19 cvknode9 kernel: [  822.754748]  [<ffffffffa01ed036>] o2net_rx_until_empty+0x506/0xe00 [ocfs2_nodemanager]
Feb 19 17:51:19 cvknode9 kernel: [  822.754753]  [<ffffffff8104f698>] ? hrtick_update+0x38/0x40
Feb 19 17:51:19 cvknode9 kernel: [  822.754757]  [<ffffffff81056838>] ? dequeue_task_fair+0xb8/0x100
Feb 19 17:51:19 cvknode9 kernel: [  822.754762]  [<ffffffff810136e5>] ? __switch_to+0xf5/0x360
Feb 19 17:51:19 cvknode9 kernel: [  822.754767]  [<ffffffff810843c7>] process_one_work+0x127/0x470
Feb 19 17:51:19 cvknode9 kernel: [  822.754771]  [<ffffffff810854a4>] worker_thread+0x164/0x370
Feb 19 17:51:19 cvknode9 kernel: [  822.754775]  [<ffffffff81085340>] ? manage_workers.isra.31+0x230/0x230
Feb 19 17:51:19 cvknode9 kernel: [  822.754780]  [<ffffffff81089c0c>] kthread+0x8c/0xa0
Feb 19 17:51:19 cvknode9 kernel: [  822.754785]  [<ffffffff8164d2f4>] kernel_thread_helper+0x4/0x10
Feb 19 17:51:19 cvknode9 kernel: [  822.754789]  [<ffffffff81089b80>] ? flush_kthread_worker+0xa0/0xa0
Feb 19 17:51:19 cvknode9 kernel: [  822.754793]  [<ffffffff8164d2f0>] ? gs_change+0x13/0x13
Feb 19 17:51:19 cvknode9 kernel: [  822.754794] ---[ end trace aa7a8184efeebe02 ]---
Feb 19 17:51:45 cvknode9 kernel: [  849.247579] INFO: rcu_sched detected stalls on CPUs/tasks: { 0 28} (detected by 32, t=15002 jiffies)
Feb 19 17:51:45 cvknode9 kernel: [  849.247598] sending NMI to all CPUs:
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140221/8720b079/attachment-0001.html 
