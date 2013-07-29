From: Guozhonghua <guozhonghua@h3c.com>
Date: Mon, 29 Jul 2013 03:02:43 +0000
Subject: [Ocfs2-devel] Another null poiner issue reports,
 is the code modified ok?  thanks a lot
Message-ID: <71604351584F6A4EBAE558C676F37CA417BDD8F9@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,


There is an another null pointer issue, sometime may cause the host node blocked.

I don't know whether had it been fixed and not applied into main line.

And I diff the code from Linux kernel 3.10 with 3.2.40, and it is in the code.


Is it correct to fix this issue?

The code diff is as below, I think sc_put should after kernel_sock_shutdown, the pointer should valid before shutdown.
diff -pc tcp.c diff/tcp.c
*** tcp.c 2013-04-26 03:25:51.000000000 +0800
--- diff/tcp.c     2013-07-29 10:32:46.878105443 +0800
*************** static void o2net_shutdown_sc(struct wor
*** 741,748 ****
               * races with pending sc work structs are harmless */
              del_timer_sync(&sc->sc_idle_timeout);
              o2net_sc_cancel_delayed_work(sc, &sc->sc_keepalive_work);
              sc_put(sc);
-              kernel_sock_shutdown(sc->sc_sock, SHUT_RDWR);
      }

      /* not fatal so failed connects before the other guy has our
--- 741,753 ----
               * races with pending sc work structs are harmless */
              del_timer_sync(&sc->sc_idle_timeout);
              o2net_sc_cancel_delayed_work(sc, &sc->sc_keepalive_work);
+
+       /* Avoiding null pointer */
+       if (sc && sc->sc_sock) {
+                     kernel_sock_shutdown(sc->sc_sock, SHUT_RDWR);
+             }
+
              sc_put(sc);
      }

      /* not fatal so failed connects before the other guy has our


The syslog info is as below:

Jul 27 18:06:44 server19 kernel: [ 9866.275007] o2dlm: Leaving domain 6BD5E5E544114F5C835FCC7614C34DD7
Jul 27 18:06:46 server19 kernel: [ 9868.166118] o2net: No longer connected to node Server20 (num 1) at 192.168.20.20:7100
Jul 27 18:06:46 server19 kernel: [ 9868.166236] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
Jul 27 18:06:46 server19 kernel: [ 9868.166250] IP: [<ffffffff81526de9>] kernel_sock_shutdown+0x9/0x20
Jul 27 18:06:46 server19 kernel: [ 9868.166264] PGD 0
Jul 27 18:06:46 server19 kernel: [ 9868.166269] Oops: 0000 [#1] SMP
Jul 27 18:06:46 server19 kernel: [ 9868.166276] CPU 0
Jul 27 18:06:46 server19 kernel: [ 9868.166280] Modules linked in: ocfs2(O) quota_tree ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs joydev usbhid hid ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables drbd lru_cache 8021q garp stp kvm_intel kvm openvswitch_mod(O) vesafb ib_iser nfsd nfs lockd rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fscache auth_rpcgss nfs_acl sunrpc dm_round_robin psmouse serio_raw hpilo sb_edac edac_core mac_hid acpi_power_meter ioatdma dca video dm_multipath lp parport lpfc scsi_transport_fc hpsa be2net scsi_tgt [last unloaded: configfs]
Jul 27 18:06:46 server19 kernel: [ 9868.166389]
Jul 27 18:06:46 server19 kernel: [ 9868.166395] Pid: 8306, comm: kworker/u:3 Tainted: G        W  O 3.2.0-23-generic #36-Ubuntu HP ProLiant BL460c Gen8
Jul 27 18:06:46 server19 kernel: [ 9868.166407] RIP: 0010:[<ffffffff81526de9>]  [<ffffffff81526de9>] kernel_sock_shutdown+0x9/0x20
Jul 27 18:06:46 server19 kernel: [ 9868.166418] RSP: 0018:ffff880809a23d90  EFLAGS: 00010286
Jul 27 18:06:46 server19 kernel: [ 9868.166424] RAX: 0000000000000001 RBX: ffff880fdc9dcc58 RCX: 000000018020000a
Jul 27 18:06:46 server19 kernel: [ 9868.166430] RDX: 000000018020000b RSI: 0000000000000002 RDI: 0000000000000000
Jul 27 18:06:46 server19 kernel: [ 9868.166436] RBP: ffff880809a23d90 R08: 0000000000000001 R09: 0000000000000000
Jul 27 18:06:46 server19 kernel: [ 9868.166443] R10: f7c2fe93f8d0f203 R11: 000000001414a801 R12: ffff880fdc9dcc00
Jul 27 18:06:46 server19 kernel: [ 9868.166449] R13: ffffffffa03577c0 R14: ffff8808047ba1c0 R15: ffff8808047ba328
Jul 27 18:06:46 server19 kernel: [ 9868.166456] FS:  0000000000000000(0000) GS:ffff88081fa00000(0000) knlGS:0000000000000000
Jul 27 18:06:46 server19 kernel: [ 9868.166464] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul 27 18:06:46 server19 kernel: [ 9868.166470] CR2: 0000000000000028 CR3: 0000000001c05000 CR4: 00000000000406f0
Jul 27 18:06:46 server19 kernel: [ 9868.166477] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul 27 18:06:46 server19 kernel: [ 9868.166483] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 27 18:06:46 server19 kernel: [ 9868.166490] Process kworker/u:3 (pid: 8306, threadinfo ffff880809a22000, task ffff880807e25bc0)
Jul 27 18:06:46 server19 kernel: [ 9868.166497] Stack:
Jul 27 18:06:46 server19 kernel: [ 9868.166501]  ffff880809a23e00 ffffffffa034c2ab ffff880809a23dd0 ffff88100aa31800
Jul 27 18:06:46 server19 kernel: [ 9868.166516]  0000000000000000 ffff88100aa31800 ffffffff81e534c0 ffffffffa034d480
Jul 27 18:06:46 server19 kernel: [ 9868.166528]  ffff880809a23e00 ffff880fdc9dcc58 ffff88080b378b00 ffff88100aa31800
Jul 27 18:06:46 server19 kernel: [ 9868.166541] Call Trace:
Jul 27 18:06:46 server19 kernel: [ 9868.166559]  [<ffffffffa034c2ab>] o2net_shutdown_sc+0x11b/0x1a0 [ocfs2_nodemanager]
Jul 27 18:06:46 server19 kernel: [ 9868.166573]  [<ffffffffa034d480>] ? sc_alloc+0x2a0/0x2a0 [ocfs2_nodemanager]
Jul 27 18:06:46 server19 kernel: [ 9868.166585]  [<ffffffffa034c190>] ? o2net_sc_connect_completed+0xb0/0xb0 [ocfs2_nodemanager]
Jul 27 18:06:46 server19 kernel: [ 9868.166600]  [<ffffffff81084e2a>] process_one_work+0x11a/0x480
Jul 27 18:06:46 server19 kernel: [ 9868.166609]  [<ffffffff81085bd4>] worker_thread+0x164/0x370
Jul 27 18:06:46 server19 kernel: [ 9868.166619]  [<ffffffff81085a70>] ? manage_workers.isra.29+0x130/0x130
Jul 27 18:06:46 server19 kernel: [ 9868.166629]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
Jul 27 18:06:46 server19 kernel: [ 9868.166639]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
Jul 27 18:06:46 server19 kernel: [ 9868.166648]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
Jul 27 18:06:46 server19 kernel: [ 9868.166656]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
Jul 27 18:06:46 server19 kernel: [ 9868.166661] Code: ff ff 48 8b 47 28 ff 50 48 4c 89 a3 48 e0 ff ff 48 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 <48> 8b 47 28 ff 50 60 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00
Jul 27 18:06:46 server19 kernel: [ 9868.166726] RIP  [<ffffffff81526de9>] kernel_sock_shutdown+0x9/0x20
Jul 27 18:06:46 server19 kernel: [ 9868.166734]  RSP <ffff880809a23d90>
Jul 27 18:06:46 server19 kernel: [ 9868.166738] CR2: 0000000000000028
Jul 27 18:07:46 server19 kernel: [ 9868.178199] ---[ end trace a7919e7f17c0a727 ]---
Jul 27 18:07:46 server19 kernel: [ 9868.178248] BUG: unable to handle kernel paging request at fffffffffffffff8
Jul 27 18:07:46 server19 kernel: [ 9868.178257] IP: [<ffffffff8108a8c1>] kthread_data+0x11/0x20
Jul 27 18:07:46 server19 kernel: [ 9868.178267] PGD 1c07067 PUD 1c08067 PMD 0
Jul 27 18:07:46 server19 kernel: [ 9868.178275] Oops: 0000 [#2] SMP
Jul 27 18:07:46 server19 kernel: [ 9868.178280] CPU 0
Jul 27 18:07:46 server19 kernel: [ 9868.178283] Modules linked in: ocfs2(O) quota_tree ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs joydev usbhid hid ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables drbd lru_cache 8021q garp stp kvm_intel kvm openvswitch_mod(O) vesafb ib_iser nfsd nfs lockd rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fscache auth_rpcgss nfs_acl sunrpc dm_round_robin psmouse serio_raw hpilo sb_edac edac_core mac_hid acpi_power_meter ioatdma dca video dm_multipath lp parport lpfc scsi_transport_fc hpsa be2net scsi_tgt [last unloaded: configfs]
Jul 27 18:07:46 server19 kernel: [ 9868.178378]
Jul 27 18:07:46 server19 kernel: [ 9868.178383] Pid: 8306, comm: kworker/u:3 Tainted: G      D W  O 3.2.0-23-generic #36-Ubuntu HP ProLiant BL460c Gen8
Jul 27 18:07:46 server19 kernel: [ 9868.178394] RIP: 0010:[<ffffffff8108a8c1>]  [<ffffffff8108a8c1>] kthread_data+0x11/0x20
Jul 27 18:07:46 server19 kernel: [ 9868.178404] RSP: 0018:ffff880809a239e0  EFLAGS: 00010096
Jul 27 18:07:46 server19 kernel: [ 9868.178410] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
Jul 27 18:07:46 server19 kernel: [ 9868.178416] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880807e25bc0
Jul 27 18:07:46 server19 kernel: [ 9868.178423] RBP: ffff880809a239f8 R08: 0000000000989680 R09: 0000000000000000
Jul 27 18:07:46 server19 kernel: [ 9868.178429] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
Jul 27 18:07:46 server19 kernel: [ 9868.178435] R13: ffff880807e25f88 R14: 0000000000000000 R15: 0000000000000246
Jul 27 18:07:46 server19 kernel: [ 9868.178442] FS:  0000000000000000(0000) GS:ffff88081fa00000(0000) knlGS:0000000000000000
Jul 27 18:07:46 server19 kernel: [ 9868.178450] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul 27 18:07:46 server19 kernel: [ 9868.178456] CR2: fffffffffffffff8 CR3: 0000000001c05000 CR4: 00000000000406f0
Jul 27 18:07:46 server19 kernel: [ 9868.178462] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul 27 18:07:46 server19 kernel: [ 9868.178468] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 27 18:07:46 server19 kernel: [ 9868.178475] Process kworker/u:3 (pid: 8306, threadinfo ffff880809a22000, task ffff880807e25bc0)
Jul 27 18:07:46 server19 kernel: [ 9868.178482] Stack:
Jul 27 18:07:46 server19 kernel: [ 9868.178485]  ffffffff81086135 ffff880809a239f8 ffff88081fa13780 ffff880809a23a78
Jul 27 18:07:46 server19 kernel: [ 9868.178499]  ffffffff8165a117 ffff880809a23a38 ffff880807e25bc0 ffff880809a23fd8
Jul 27 18:07:46 server19 kernel: [ 9868.178511]  ffff880809a23fd8 ffff880809a23fd8 0000000000013780 ffff880809a23a68
Jul 27 18:07:46 server19 kernel: [ 9868.178524] Call Trace:
Jul 27 18:07:46 server19 kernel: [ 9868.178533]  [<ffffffff81086135>] ? wq_worker_sleeping+0x15/0xa0
Jul 27 18:07:46 server19 kernel: [ 9868.178544]  [<ffffffff8165a117>] __schedule+0x5d7/0x6f0
Jul 27 18:07:46 server19 kernel: [ 9868.178552]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Jul 27 18:07:46 server19 kernel: [ 9868.178562]  [<ffffffff8106bafb>] do_exit+0x26b/0x420
Jul 27 18:07:46 server19 kernel: [ 9868.178572]  [<ffffffff8165d620>] oops_end+0xb0/0xf0
Jul 27 18:07:46 server19 kernel: [ 9868.178581]  [<ffffffff81642ebd>] no_context+0x150/0x15d
Jul 27 18:07:46 server19 kernel: [ 9868.178589]  [<ffffffff81643093>] __bad_area_nosemaphore+0x1c9/0x1e8
Jul 27 18:07:46 server19 kernel: [ 9868.178598]  [<ffffffff816430c5>] bad_area_nosemaphore+0x13/0x15
Jul 27 18:07:46 server19 kernel: [ 9868.178607]  [<ffffffff81660276>] do_page_fault+0x426/0x520
Jul 27 18:07:46 server19 kernel: [ 9868.178615]  [<ffffffff81526e93>] ? sock_destroy_inode+0x33/0x40
Jul 27 18:07:46 server19 kernel: [ 9868.178626]  [<ffffffff8119235c>] ? destroy_inode+0x3c/0x70
Jul 27 18:07:46 server19 kernel: [ 9868.178638]  [<ffffffffa0349a50>] ? o2net_sc_queue_work+0x50/0x50 [ocfs2_nodemanager]
Jul 27 18:07:46 server19 kernel: [ 9868.178651]  [<ffffffffa0349ab9>] ? sc_kref_release+0x69/0x100 [ocfs2_nodemanager]
Jul 27 18:07:46 server19 kernel: [ 9868.178664]  [<ffffffff811620d4>] ? kfree+0x114/0x140
Jul 27 18:07:46 server19 kernel: [ 9868.178672]  [<ffffffff8165cbf5>] page_fault+0x25/0x30
Jul 27 18:07:46 server19 kernel: [ 9868.178680]  [<ffffffff81526de9>] ? kernel_sock_shutdown+0x9/0x20
Jul 27 18:07:46 server19 kernel: [ 9868.178692]  [<ffffffffa034c2ab>] o2net_shutdown_sc+0x11b/0x1a0 [ocfs2_nodemanager]
Jul 27 18:07:46 server19 kernel: [ 9868.178704]  [<ffffffffa034d480>] ? sc_alloc+0x2a0/0x2a0 [ocfs2_nodemanager]
Jul 27 18:07:46 server19 kernel: [ 9868.178716]  [<ffffffffa034c190>] ? o2net_sc_connect_completed+0xb0/0xb0 [ocfs2_nodemanager]
Jul 27 18:07:46 server19 kernel: [ 9868.178727]  [<ffffffff81084e2a>] process_one_work+0x11a/0x480
Jul 27 18:07:46 server19 kernel: [ 9868.178736]  [<ffffffff81085bd4>] worker_thread+0x164/0x370
Jul 27 18:07:46 server19 kernel: [ 9868.178745]  [<ffffffff81085a70>] ? manage_workers.isra.29+0x130/0x130
Jul 27 18:07:46 server19 kernel: [ 9868.178753]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
Jul 27 18:07:46 server19 kernel: [ 9868.178761]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
Jul 27 18:07:46 server19 kernel: [ 9868.178770]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
Jul 27 18:07:46 server19 kernel: [ 9868.178778]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
Jul 27 18:07:46 server19 kernel: [ 9868.178783] Code: 41 5f 5d c3 be 3e 01 00 00 48 c7 c7 80 9a a0 81 e8 c5 c8 fd ff e9 74 fe ff ff 55 48 89 e5 66 66 66 66 90 48 8b 87 70 03 00 00 5d <48> 8b 40 f8 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66
Jul 27 18:07:46 server19 kernel: [ 9868.178848] RIP  [<ffffffff8108a8c1>] kthread_data+0x11/0x20
Jul 27 18:07:46 server19 kernel: [ 9868.178856]  RSP <ffff880809a239e0>
Jul 27 18:07:46 server19 kernel: [ 9868.178860] CR2: fffffffffffffff8
Jul 27 18:07:46 server19 kernel: [ 9868.178865] ---[ end trace a7919e7f17c0a728 ]---
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130729/e9edff3c/attachment-0001.html 
