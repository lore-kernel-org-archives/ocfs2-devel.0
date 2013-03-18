From: Guozhonghua <guozhonghua@h3c.com>
Date: Mon, 18 Mar 2013 07:20:13 +0000
Subject: [Ocfs2-devel] Any advices with these exceptions, Thanks.
Message-ID: <71604351584F6A4EBAE558C676F37CA417BC8F89@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, I have a test with ocfs2 as virtual machine stores, using Ubuntu12.04, precise version, with kernel 3.2.X.

205643:Feb 26 10:35:22 ckvmain kernel: [774929.093922] o2net: No longer connected to node cvkslave (num 1) at 192.168.100.12:7100
205644:Feb 26 10:35:22 ckvmain kernel: [774929.094017] o2cb: o2dlm has evicted node 1 from domain 8AAEFC21BC6B4CE0A02DF3C10737AB14
205645:Feb 26 10:35:23 ckvmain kernel: [774930.342401] o2dlm: Begin recovery on domain 8AAEFC21BC6B4CE0A02DF3C10737AB14 for node 1
205646:Feb 26 10:35:23 ckvmain kernel: [774930.344087] o2dlm: Node 2 (me) is the Recovery Master for the dead node 1 in domain 8AAEFC21BC6B4CE0A02DF3C10737AB14
205647:Feb 26 10:35:24 ckvmain kernel: [774931.093949] o2net: Connected to node cvkslave (num 1) at 192.168.100.12:7100
205648:Feb 26 10:35:28 ckvmain kernel: [774935.332139] o2dlm: End recovery on domain 8AAEFC21BC6B4CE0A02DF3C10737AB14
205649:Feb 26 10:35:28 ckvmain kernel: [774935.343294] ocfs2: Begin replay journal (node 1, slot 0) on device (8,16)
205790:Feb 26 10:35:30 ckvmain kernel: [774937.819459] ocfs2: End replay journal (node 1, slot 0) on device (8,16)
205791:Feb 26 10:35:30 ckvmain kernel: [774937.855776] ocfs2: Beginning quota recovery on device (8,16) for slot 0
205792:Feb 26 10:35:30 ckvmain kernel: [774937.858244] ocfs2: Finishing quota recovery on device (8,16) for slot 0
205793:Feb 26 10:35:34 ckvmain kernel: [774941.094705] o2net: No longer connected to node cvkslave (num 1) at 192.168.100.12:7100
205794:Feb 26 10:35:36 ckvmain kernel: [774943.099069] o2net: Connected to node cvkslave (num 1) at 192.168.100.12:7100
207442:Feb 26 10:37:31 ckvmain kernel: [775057.583863] ------------[ cut here ]------------
207443:Feb 26 10:37:31 ckvmain kernel: [775057.584119] kernel BUG at fs/ocfs2/dlm/dlmast.c:357!
207444:Feb 26 10:37:31 ckvmain kernel: [775057.584390] invalid opcode: 0000 [#1] SMP
207445:Feb 26 10:37:31 ckvmain kernel: [775057.584611] CPU 14
207446:Feb 26 10:37:31 ckvmain kernel: [775057.584722] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree nls_utf8 cifs 8021q garp stp kvm_intel kvm ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) vesafb ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc radeon ttm drm_kms_helper drm psmouse i2c_algo_bit serio_raw joydev hpilo acpi_power_meter i7core_edac edac_core mac_hid lp parport usbhid bnx2 hid hpsa
207447:Feb 26 10:37:31 ckvmain kernel: [775057.587731]
207448:Feb 26 10:37:31 ckvmain kernel: [775057.587808] Pid: 28020, comm: kworker/u:1 Tainted: G           O 3.2.0-23-generic #36-Ubuntu HP ProLiant DL380 G7
207449:Feb 26 10:37:31 ckvmain kernel: [775057.605648] RIP: 0010:[<ffffffffa044fcad>]  [<ffffffffa044fcad>] dlm_proxy_ast_handler+0x82d/0xa10 [ocfs2_dlm]
207450:Feb 26 10:37:31 ckvmain kernel: [775057.624512] RSP: 0018:ffff8810fa9cbc80  EFLAGS: 00010246
207451:Feb 26 10:37:31 ckvmain kernel: [775057.634008] RAX: 0000000000000002 RBX: ffff880134922000 RCX: 000000000000001d
207452:Feb 26 10:37:31 ckvmain kernel: [775057.652535] RDX: ffff8811c4a40000 RSI: ffff880134922029 RDI: ffff8808e0a2406c
207453:Feb 26 10:37:31 ckvmain kernel: [775057.671971] RBP: ffff8810fa9cbd20 R08: 0000000000000030 R09: 0000000000000000
207454:Feb 26 10:37:31 ckvmain kernel: [775057.691922] R10: ca00000000000002 R11: 0000000000000001 R12: 0000000000000000
207455:Feb 26 10:37:31 ckvmain kernel: [775057.712323] R13: ffff8808e0a24000 R14: 000000000000001f R15: ffff8811c49444d0
207456:Feb 26 10:37:31 ckvmain kernel: [775057.732965] FS:  0000000000000000(0000) GS:ffff8808fbce0000(0000) knlGS:0000000000000000
207457:Feb 26 10:37:31 ckvmain kernel: [775057.753749] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
207458:Feb 26 10:37:31 ckvmain kernel: [775057.764460] CR2: 00000000004521ee CR3: 0000000001c05000 CR4: 00000000000006e0
207459:Feb 26 10:37:31 ckvmain kernel: [775057.785292] DR0: 0000000000000003 DR1: 00000000000000b0 DR2: 0000000000000001
207460:Feb 26 10:37:31 ckvmain kernel: [775057.806254] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
207461:Feb 26 10:37:31 ckvmain kernel: [775057.827160] Process kworker/u:1 (pid: 28020, threadinfo ffff8810fa9ca000, task ffff8811c49444d0)
207462:Feb 26 10:37:31 ckvmain kernel: [775057.848113] Stack:
207463:Feb 26 10:37:31 ckvmain kernel: [775057.858177]  ffff88117e3e0478 ffff8810fa9cbca0 0000000000000286 ffff88117e3e0478
207464:Feb 26 10:37:31 ckvmain kernel: [775057.878536]  ffff8810fa9cbd00 ffffffff81078553 ffff8810fa9cbcf0 ffffffff81082bea
207465:Feb 26 10:37:31 ckvmain kernel: [775057.899471]  ffff8810fa9cbd20 ffffffffa0400f01 ca00000000000002 0000000000000000
207466:Feb 26 10:37:31 ckvmain kernel: [775057.920272] Call Trace:
207467:Feb 26 10:37:31 ckvmain kernel: [775057.930466]  [<ffffffff81078553>] ? mod_timer+0x143/0x2f0
207468:Feb 26 10:37:31 ckvmain kernel: [775057.940754]  [<ffffffff81082bea>] ? queue_delayed_work_on+0xba/0x140
207469:Feb 26 10:37:31 ckvmain kernel: [775057.950933]  [<ffffffffa0400f01>] ? o2net_listen_data_ready+0x61/0xe0 [ocfs2_nodemanager]
207470:Feb 26 10:37:31 ckvmain kernel: [775057.970814]  [<ffffffffa0403836>] o2net_rx_until_empty+0x506/0xdf0 [ocfs2_nodemanager]
207471:Feb 26 10:37:31 ckvmain kernel: [775057.990706]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
207472:Feb 26 10:37:31 ckvmain kernel: [775058.000670]  [<ffffffff8105617a>] ? finish_task_switch+0x4a/0xf0
207473:Feb 26 10:37:31 ckvmain kernel: [775058.010662]  [<ffffffffa0403330>] ? o2net_shutdown_sc+0x1a0/0x1a0 [ocfs2_nodemanager]
207474:Feb 26 10:37:31 ckvmain kernel: [775058.029786]  [<ffffffff81084e2a>] process_one_work+0x11a/0x480
207475:Feb 26 10:37:31 ckvmain kernel: [775058.039393]  [<ffffffff81085bd4>] worker_thread+0x164/0x370
207476:Feb 26 10:37:31 ckvmain kernel: [775058.048794]  [<ffffffff81085a70>] ? manage_workers.isra.29+0x130/0x130
207477:Feb 26 10:37:31 ckvmain kernel: [775058.058189]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
207478:Feb 26 10:37:31 ckvmain kernel: [775058.067421]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
207479:Feb 26 10:37:31 ckvmain kernel: [775058.076537]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
207480:Feb 26 10:37:31 ckvmain kernel: [775058.085518]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
207481:Feb 26 10:37:31 ckvmain kernel: [775058.094265] Code: 1a f7 ff ff e9 7e fc ff ff 48 bb 40 00 00 00 00 00 00 10 48 85 1d 24 c7 fb ff 74 0d 48 85 1d 5b e6 fb ff 0f 84 3f 01 00 00 0f 0b <0f> 0b 0f 0b 65 48 8b 34 25 00 c5 00 00 8b 96 ac 02 00 00 41 b9
207482:Feb 26 10:37:31 ckvmain kernel: [775058.120447] RIP  [<ffffffffa044fcad>] dlm_proxy_ast_handler+0x82d/0xa10 [ocfs2_dlm]
207483:Feb 26 10:37:31 ckvmain kernel: [775058.137954]  RSP <ffff8810fa9cbc80>
207484:Feb 26 10:37:31 ckvmain kernel: [775058.158120] ---[ end trace a161d655692fc859 ]---
207485:Feb 26 10:37:31 ckvmain kernel: [775058.166729] BUG: unable to handle kernel paging request at fffffffffffffff8
207486:Feb 26 10:37:31 ckvmain kernel: [775058.175331] IP: [<ffffffff8108a8c1>] kthread_data+0x11/0x20



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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130318/1485251c/attachment.html 
