From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 15 Mar 2013 02:41:05 +0000
Subject: [Ocfs2-devel] OCFS2 bug reports
Message-ID: <71604351584F6A4EBAE558C676F37CA417BC8EE4@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, I have a test with ocfs2 as virtual machine stores, using Ubuntu12.04, precise version.

Sometimes, there are some exception and the cluster blocked, may be all the nodes in the cluster will be restart to avoid it.


Feb 26 10:37:31 ckvmain kernel: [775057.583863] ------------[ cut here ]------------
Feb 26 10:37:31 ckvmain kernel: [775057.584119] kernel BUG at fs/ocfs2/dlm/dlmast.c:357!
Feb 26 10:37:31 ckvmain kernel: [775057.584390] invalid opcode: 0000 [#1] SMP
Feb 26 10:37:31 ckvmain kernel: [775057.584611] CPU 14
Feb 26 10:37:31 ckvmain kernel: [775057.584722] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ocfs2(O) quota_tree nls_utf8 cifs 8021q garp stp kvm_intel kvm ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs openvswitch_mod(O) vesafb ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc radeon ttm drm_kms_helper drm psmouse i2c_algo_bit serio_raw joydev hpilo acpi_power_meter i7core_edac edac_core mac_hid lp parport usbhid bnx2 hid hpsa
Feb 26 10:37:31 ckvmain kernel: [775057.587731]
Feb 26 10:37:31 ckvmain kernel: [775057.587808] Pid: 28020, comm: kworker/u:1 Tainted: G           O 3.2.0-23-generic #36-Ubuntu HP ProLiant DL380 G7
Feb 26 10:37:31 ckvmain kernel: [775057.605648] RIP: 0010:[<ffffffffa044fcad>]  [<ffffffffa044fcad>] dlm_proxy_ast_handler+0x82d/0xa10 [ocfs2_dlm]
Feb 26 10:37:31 ckvmain kernel: [775057.624512] RSP: 0018:ffff8810fa9cbc80  EFLAGS: 00010246
Feb 26 10:37:31 ckvmain kernel: [775057.634008] RAX: 0000000000000002 RBX: ffff880134922000 RCX: 000000000000001d
Feb 26 10:37:31 ckvmain kernel: [775057.652535] RDX: ffff8811c4a40000 RSI: ffff880134922029 RDI: ffff8808e0a2406c
Feb 26 10:37:31 ckvmain kernel: [775057.671971] RBP: ffff8810fa9cbd20 R08: 0000000000000030 R09: 0000000000000000
Feb 26 10:37:31 ckvmain kernel: [775057.691922] R10: ca00000000000002 R11: 0000000000000001 R12: 0000000000000000
Feb 26 10:37:31 ckvmain kernel: [775057.712323] R13: ffff8808e0a24000 R14: 000000000000001f R15: ffff8811c49444d0
Feb 26 10:37:31 ckvmain kernel: [775057.732965] FS:  0000000000000000(0000) GS:ffff8808fbce0000(0000) knlGS:0000000000000000
Feb 26 10:37:31 ckvmain kernel: [775057.753749] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb 26 10:37:31 ckvmain kernel: [775057.764460] CR2: 00000000004521ee CR3: 0000000001c05000 CR4: 00000000000006e0
Feb 26 10:37:31 ckvmain kernel: [775057.785292] DR0: 0000000000000003 DR1: 00000000000000b0 DR2: 0000000000000001
Feb 26 10:37:31 ckvmain kernel: [775057.806254] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 26 10:37:31 ckvmain kernel: [775057.827160] Process kworker/u:1 (pid: 28020, threadinfo ffff8810fa9ca000, task ffff8811c49444d0)
Feb 26 10:37:31 ckvmain kernel: [775057.848113] Stack:
Feb 26 10:37:31 ckvmain kernel: [775057.858177]  ffff88117e3e0478 ffff8810fa9cbca0 0000000000000286 ffff88117e3e0478
Feb 26 10:37:31 ckvmain kernel: [775057.878536]  ffff8810fa9cbd00 ffffffff81078553 ffff8810fa9cbcf0 ffffffff81082bea
Feb 26 10:37:31 ckvmain kernel: [775057.899471]  ffff8810fa9cbd20 ffffffffa0400f01 ca00000000000002 0000000000000000
Feb 26 10:37:31 ckvmain kernel: [775057.920272] Call Trace:
Feb 26 10:37:31 ckvmain kernel: [775057.930466]  [<ffffffff81078553>] ? mod_timer+0x143/0x2f0
Feb 26 10:37:31 ckvmain kernel: [775057.940754]  [<ffffffff81082bea>] ? queue_delayed_work_on+0xba/0x140
Feb 26 10:37:31 ckvmain kernel: [775057.950933]  [<ffffffffa0400f01>] ? o2net_listen_data_ready+0x61/0xe0 [ocfs2_nodemanager]
Feb 26 10:37:31 ckvmain kernel: [775057.970814]  [<ffffffffa0403836>] o2net_rx_until_empty+0x506/0xdf0 [ocfs2_nodemanager]
Feb 26 10:37:31 ckvmain kernel: [775057.990706]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
Feb 26 10:37:31 ckvmain kernel: [775058.000670]  [<ffffffff8105617a>] ? finish_task_switch+0x4a/0xf0
Feb 26 10:37:31 ckvmain kernel: [775058.010662]  [<ffffffffa0403330>] ? o2net_shutdown_sc+0x1a0/0x1a0 [ocfs2_nodemanager]
Feb 26 10:37:31 ckvmain kernel: [775058.029786]  [<ffffffff81084e2a>] process_one_work+0x11a/0x480
Feb 26 10:37:31 ckvmain kernel: [775058.039393]  [<ffffffff81085bd4>] worker_thread+0x164/0x370
Feb 26 10:37:31 ckvmain kernel: [775058.048794]  [<ffffffff81085a70>] ? manage_workers.isra.29+0x130/0x130
Feb 26 10:37:31 ckvmain kernel: [775058.058189]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
Feb 26 10:37:31 ckvmain kernel: [775058.067421]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
Feb 26 10:37:31 ckvmain kernel: [775058.076537]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
Feb 26 10:37:31 ckvmain kernel: [775058.085518]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
Feb 26 10:37:31 ckvmain kernel: [775058.094265] Code: 1a f7 ff ff e9 7e fc ff ff 48 bb 40 00 00 00 00 00 00 10 48 85 1d 24 c7 fb ff 74 0d 48 85 1d 5b e6 fb ff 0f 84 3f 01 00 00 0f 0b <0f> 0b 0f 0b 65 48 8b 34 25 00 c5 00 00 8b 96 ac 02 00 00 41 b9
Feb 26 10:37:31 ckvmain kernel: [775058.120447] RIP  [<ffffffffa044fcad>] dlm_proxy_ast_handler+0x82d/0xa10 [ocfs2_dlm]
Feb 26 10:37:31 ckvmain kernel: [775058.137954]  RSP <ffff8810fa9cbc80>
Feb 26 10:37:31 ckvmain kernel: [775058.158120] ---[ end trace a161d655692fc859 ]---
Feb 26 10:37:31 ckvmain kernel: [775058.166729] BUG: unable to handle kernel paging request at fffffffffffffff8
Feb 26 10:37:31 ckvmain kernel: [775058.175331] IP: [<ffffffff8108a8c1>] kthread_data+0x11/0x20
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130315/a36dd378/attachment.html 
