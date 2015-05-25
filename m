From: Guozhonghua <guozhonghua@h3c.com>
Date: Mon, 25 May 2015 02:43:39 +0000
Subject: [Ocfs2-devel] ocfs2 drop lock patch required any reviews, thanks
Message-ID: <71604351584F6A4EBAE558C676F37CA4696D3B3C@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, All

As one resource unlocked, or evicted from the fs, the resource lock may had been released in the function ocfs2_dlm_unlock.
But the return code is not zero, dump the info of the lock resource, because the dlm resource lock had been released, so we would have NULL pointer accessed.
Is the BUG call required with ret value is not zero?

diff -cp dlmglue_org.c dlmglue.c
*** dlmglue_org.c       2015-05-25 10:11:59.086856234 +0800
--- dlmglue.c   2015-05-25 10:13:51.414859206 +0800
*************** static int ocfs2_drop_lock(struct ocfs2_
*** 3140,3147 ****
??ret = ocfs2_dlm_unlock(osb->cconn, &lockres->l_lksb, lkm_flags);
        if (ret) {
                ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
                mlog(ML_ERROR, "lockres flags: %lu\n", lockres->l_flags);
-               ocfs2_dlm_dump_lksb(&lockres->l_lksb);
-               BUG();
        }
        mlog(0, "lock %s, successful return from ocfs2_dlm_unlock\n",
             lockres->l_name);
--- 3140,3145 ----



May  7 09:45:01 FC-07 kernel: [4185225.733003] (ocfs2dc,6401,3):ocfs2_unlock_ast:1129 ERROR: Dlm passes error -22 for lock M000000000000001f89012100000000, unlock_action 2
May  7 09:45:01 FC-07 kernel: [4185225.733022] (ocfs2dc,6401,3):dlmunlock:688 ERROR: dlm status = DLM_IVLOCKID
May  7 09:45:01 FC-07 kernel: [4185225.733028] (ocfs2dc,6401,3):ocfs2_drop_lock:3132 ERROR: DLM error -22 while calling ocfs2_dlm_unlock on resource M000000000000001f89012100000000
May  7 09:45:01 FC-07 kernel: [4185225.733034] (ocfs2dc,6401,3):ocfs2_drop_lock:3133 ERROR: lockres flags: 194
May  7 09:45:01 FC-07 kernel: [4185225.733060] BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
May  7 09:45:01 FC-07 kernel: [4185225.733065] IP: [<ffffffff8175847e>] _raw_spin_lock+0xe/0x50
May  7 09:45:01 FC-07 kernel: [4185225.733083] PGD 0
May  7 09:45:01 FC-07 kernel: [4185225.733086] Oops: 0002 [#1] SMP
May  7 09:45:01 FC-07 kernel: [4185225.733090] Modules linked in: ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) ebtable_nat(F) ebtables(F) x_tables(F) ocfs2(OF) quota_tree(F) drbd(F) lru_cache(F) 8021q(F) mrp(F) garp(F) stp(F) llc(F) vhost_net(F) macvtap(F) macvlan(F) vhost(F) kvm_intel(F) kvm(F) ib_iser(F) rdma_cm(F) ib_cm(F) iw_cm(F) ib_sa(F) ib_mad(F) ib_core(F) ib_addr(F) iscsi_tcp(F) libiscsi_tcp(F) libiscsi(F) scsi_transport_iscsi(F) ocfs2_dlmfs(OF) ocfs2_stack_o2cb(OF) ocfs2_dlm(OF) ocfs2_nodemanager(OF) ocfs2_stackglue(OF) configfs(F) openvswitch(OF) gre(F) nfsd(F) nfs_acl(F) auth_rpcgss(F) nfs(F) fscache(F) lockd(F) dm_round_robin(F) sunrpc(F) ses(F) joydev(F) dm_multipath(F) enclosure(F) scsi_dh(F) gpio_ich(F) psmouse(F) sb_edac(F) ioatdma(F) edac_core(F) dca(F) serio_raw(F) hpilo(F) hid_generic(F) acpi_power_meter(F) lpc_ich(F) hpwdt(F) mac_hid(F) lp(F) parport(F) usbhid(F) bnx2x(F) hid(F) bfa(F) libcrc32c(F) tg3(F) mdio(F) scsi_transport_fc(F) ptp(F) hpsa(F) scsi_tgt(F) pps_core(F)
May  7 09:45:01 FC-07 kernel: nbd(F) [last unloaded: ipmi_si]
May  7 09:45:01 FC-07 kernel: [4185225.733192] CPU: 3 PID: 6401 Comm: ocfs2dc Tainted: GF       W  O 3.13.6 #1
May  7 09:45:01 FC-07 kernel: [4185225.733196] Hardware name: H3C FlexServer R390, BIOS P70 02/10/2014
May  7 09:45:01 FC-07 kernel: [4185225.733200] task: ffff882179b68000 ti: ffff8821736d6000 task.ti: ffff8821736d6000
May  7 09:45:01 FC-07 kernel: [4185225.733203] RIP: 0010:[<ffffffff8175847e>]  [<ffffffff8175847e>] _raw_spin_lock+0xe/0x50
May  7 09:45:01 FC-07 kernel: [4185225.733210] RSP: 0018:ffff8821736d7a68  EFLAGS: 00010286
May  7 09:45:01 FC-07 kernel: [4185225.733213] RAX: 0000000000020000 RBX: 00000000000000b0 RCX: 0000000000000006
May  7 09:45:01 FC-07 kernel: [4185225.733216] RDX: 0000000000000007 RSI: 0000000000000007 RDI: 00000000000000b0
May  7 09:45:01 FC-07 kernel: [4185225.733220] RBP: ffff8821736d7a68 R08: 0000000000000000 R09: 0000000000000000
May  7 09:45:01 FC-07 kernel: [4185225.733235] R10: 00000000000ee2c3 R11: 00000000000ee2c2 R12: 0000000000000000
May  7 09:45:01 FC-07 kernel: [4185225.733239] R13: ffff884366877228 R14: 00000000ffffffea R15: 0000000000000008
May  7 09:45:01 FC-07 kernel: [4185225.733243] FS:  0000000000000000(0000) GS:ffff8821b7a60000(0000) knlGS:0000000000000000
May  7 09:45:01 FC-07 kernel: [4185225.733247] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May  7 09:45:01 FC-07 kernel: [4185225.733250] CR2: 00000000000000b0 CR3: 0000000001c0d000 CR4: 00000000001427e0
May  7 09:45:01 FC-07 kernel: [4185225.733254] Stack:
May  7 09:45:01 FC-07 kernel: [4185225.733256]  ffff8821736d7a88 ffffffffa041f2e7 ffff8843668771b8 ffff884366877224
May  7 09:45:01 FC-07 kernel: [4185225.733264]  ffff8821736d7a98 ffffffffa041f322 ffff8821736d7aa8 ffffffffa029a072
May  7 09:45:01 FC-07 kernel: [4185225.733268]  ffff8821736d7ab8 ffffffffa0267077 ffff8821736d7b78 ffffffffa05ebbfa
May  7 09:45:01 FC-07 kernel: [4185225.733272] Call Trace:
May  7 09:45:01 FC-07 kernel: [4185225.733284]  [<ffffffffa041f2e7>] dlm_print_one_lock_resource+0x27/0x50 [ocfs2_dlm]
May  7 09:45:01 FC-07 kernel: [4185225.733290]  [<ffffffffa041f322>] dlm_print_one_lock+0x12/0x20 [ocfs2_dlm]
May  7 09:45:01 FC-07 kernel: [4185225.733294]  [<ffffffffa029a072>] o2cb_dump_lksb+0x12/0x20 [ocfs2_stack_o2cb]
May  7 09:45:01 FC-07 kernel: [4185225.733299]  [<ffffffffa0267077>] ocfs2_dlm_dump_lksb+0x17/0x20 [ocfs2_stackglue]
May  7 09:45:01 FC-07 kernel: [4185225.733335]  [<ffffffffa05ebbfa>] ocfs2_drop_lock.isra.17+0x3ca/0x6c0 [ocfs2]
May  7 09:45:01 FC-07 kernel: [4185225.733346]  [<ffffffffa05e9f6b>] ? ocfs2_init_mask_waiter+0x3b/0x50 [ocfs2]
May  7 09:45:01 FC-07 kernel: [4185225.733358]  [<ffffffffa05f3b02>] ? ocfs2_extent_map_trunc+0x112/0x140 [ocfs2]
May  7 09:45:01 FC-07 kernel: [4185225.733369]  [<ffffffffa05ed493>] ocfs2_drop_inode_locks+0x73/0x260 [ocfs2]
May  7 09:45:01 FC-07 kernel: [4185225.733379]  [<ffffffffa05f3b02>] ? ocfs2_extent_map_trunc+0x112/0x140 [ocfs2]
May  7 09:45:01 FC-07 kernel: [4185225.733391]  [<ffffffffa05fe1ae>] ocfs2_evict_inode+0x18e/0x21d0 [ocfs2]
May  7 09:45:01 FC-07 kernel: [4185225.733397]  [<ffffffff811ea9c5>] ? __inode_wait_for_writeback+0x65/0xc0
May  7 09:45:01 FC-07 kernel: [4185225.733404]  [<ffffffff810adba0>] ? wake_atomic_t_function+0x40/0x40
May  7 09:45:01 FC-07 kernel: [4185225.733410]  [<ffffffff811dc7a8>] evict+0xb8/0x1c0
May  7 09:45:01 FC-07 kernel: [4185225.733412]  [<ffffffff811dd095>] iput+0x105/0x190
May  7 09:45:01 FC-07 kernel: [4185225.733422]  [<ffffffffa05ded59>] ocfs2_dentry_lock_put+0x59/0x90 [ocfs2]
May  7 09:45:01 FC-07 kernel: [4185225.733431]  [<ffffffffa05ea87a>] ocfs2_dentry_post_unlock+0x1a/0x20 [ocfs2]
May  7 09:45:01 FC-07 kernel: [4185225.733442]  [<ffffffffa05f0891>] ocfs2_process_blocked_lock+0xa1/0x950 [ocfs2]
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
