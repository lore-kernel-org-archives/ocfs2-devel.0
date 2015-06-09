From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Tue, 9 Jun 2015 09:59:38 +0000
Subject: [Ocfs2-devel] __ocfs2_journal_access review, BUG
Message-ID: <2015060917590038012350@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the process of  __ocfs2_journal_access?

If  LUNs can not be accessed for some reasons?such as storage network fails )?then BUG.

When disk timeout ,  the server of  fence ( emergency_restart() ) will fail, only can recovery by the reset of ILO.

So we have to return the error -EIO, and avoid to BUG(panic).

Moreover, whether all BUG_ON(!buffer_uptodate(bh)) in the ocfs2 file system can handle in the same way??

Finally, any feedback about this process (positive or negative) would be greatly appreciated.


--- journal.c   2015-05-18 00:55:21.000000000 +0800
+++ journal.c.bk        2015-06-09 17:37:13.531333444 +0800
@@ -670,7 +670,7 @@
                mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
                mlog(ML_ERROR, "b_blocknr=%llu\n",
                     (unsigned long long)bh->b_blocknr);
-               BUG();
+               return -EIO;
        }

        /* Set the current transaction information on the ci so



Jun 9 15:20:23 cvk68 kernel: [76994.822719] (pool,13568,12):__ocfs2_journal_access:664 ERROR: giving me a buffer that's not uptodate!
Jun 9 15:20:23 cvk68 kernel: [76994.822721] (pool,13568,12):__ocfs2_journal_access:666 ERROR: b_blocknr=33030401
Jun 9 15:20:23 cvk68 kernel: [76994.822716] Read(10): 28 00 00 00 29 80 00 00 1f 00
Jun 9 15:20:23 cvk68 kernel: [76994.822729] (ksoftirqd/25,263,25):o2hb_bio_end_io:381 ERROR: IO Error -5
Jun 9 15:20:23 cvk68 kernel: [76994.822737] ------------[ cut here ]------------
Jun 9 15:20:23 cvk68 kernel: [76994.822740] (o2hb-771CAAF371,7589,9):o2hb_do_disk_heartbeat:993 ERROR: status = -5
Jun 9 15:20:23 cvk68 kernel: [76994.822746] Kernel BUG at ffffffffa048b15d [verbose debug info unavailable]
Jun 9 15:20:23 cvk68 kernel: [76994.822748] invalid opcode: 0000 [#1] SMP
Jun 9 15:20:23 cvk68 kernel: [76994.822751] sd 13:0:0:0: rejecting I/O to offline device
Jun 9 15:20:23 cvk68 kernel: [76994.822753] (o2hb-771CAAF371,7589,9):o2hb_bio_end_io:381 ERROR: IO Error -5
Jun 9 15:20:23 cvk68 kernel: [76994.822755] (o2hb-771CAAF371,7589,9):o2hb_do_disk_heartbeat:993 ERROR: status = -5
Jun 9 15:20:23 cvk68 kernel: [76994.822751] Modules linked in: ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) ebtable_nat(F) ebtables(F) x_tables(F) ocfs2(OF) quota_tree(F) cls_u32(F) sch_sfq(F) sch_htb(F) drbd(F) lru_cache(F) 8021q(F) mrp(F) garp(F) stp(F) llc(F) vhost_net(F) macvtap(F) macvlan(F) vhost(F) kvm_intel(F) kvm(F) ib_iser(F) rdma_cm(F) ib_cm(F) iw_cm(F) ib_sa(F) ib_mad(F) ib_core(F) ib_addr(F) iscsi_tcp(F) libiscsi_tcp(F) ocfs2_dlmfs(OF) ocfs2_stack_o2cb(OF) ocfs2_dlm(OF) ocfs2_nodemanager(OF) ocfs2_stackglue(OF) configfs(F) openvswitch(OF) libcrc32c(F) gre(F) nfsd(F) nfs_acl(F) auth_rpcgss(F) nfs(F) fscache(F) lockd(F) sunrpc(F) psmouse(F) sb_edac(F) ioatdma(F) edac_core(F) gpio_ich(F) dm_multipath(F) serio_raw(F) scsi_dh(F) dca(F) hpwdt(F) hpilo(F) mac_hid(F) lpc_ich(F) video(F) acpi_power_meter(F) lp(F) parport(F) be2iscsi(F) iscsi_boot_sysfs(F) libiscsi(F) hpsa(F) scsi_transport_iscsi(F) be2net(F) nbd(F) [last unloaded: ipmi_si]
Jun 9 15:20:23 cvk68 kernel: [76994.822802] CPU: 12 PID: 13568 Comm: pool Tainted: GF O 3.13.6 #1
Jun 9 15:20:23 cvk68 kernel: [76994.822804] Hardware name: H3C FlexServer B390, BIOS I31 02/10/2014
Jun 9 15:20:23 cvk68 kernel: [76994.822806] task: ffff880611451810 ti: ffff8802cf8da000 task.ti: ffff8802cf8da000
Jun 9 15:20:23 cvk68 kernel: [76994.822808] RIP: 0010:[<ffffffffa048b15d>] [<ffffffffa048b15d>] __ocfs2_journal_access+0x30d/0x350 [ocfs2]
Jun 9 15:20:23 cvk68 kernel: [76994.822832] RSP: 0018:ffff8802cf8dbb78 EFLAGS: 00010292
Jun 9 15:20:23 cvk68 kernel: [76994.822834] RAX: 0000000000000044 RBX: 1000000000000000 RCX: 000000000000c5c0
Jun 9 15:20:23 cvk68 kernel: [76994.822836] RDX: 0000000000000082 RSI: 0000000065ee65ea RDI: 0000000000000246
Jun 9 15:20:23 cvk68 kernel: [76994.822838] RBP: ffff8802cf8dbbf8 R08: ffffffff81ec09a8 R09: ffffffff81ee8f20
Jun 9 15:20:23 cvk68 kernel: [76994.822840] R10: 0000000000000064 R11: 0000000000017adc R12: ffff880604b31138
Jun 9 15:20:23 cvk68 kernel: [76994.822842] R13: ffff880611451810 R14: ffff880611451ce0 R15: 0000000000000001
Jun 9 15:20:23 cvk68 kernel: [76994.822845] FS: 00007f9bcffff700(0000) GS:ffff880c3f880000(0000) knlGS:0000000000000000
Jun 9 15:20:23 cvk68 kernel: [76994.822847] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 9 15:20:23 cvk68 kernel: [76994.822849] CR2: 000000000133b7b8 CR3: 000000061168a000 CR4: 00000000001427e0
Jun 9 15:20:23 cvk68 kernel: [76994.822851] Stack:
Jun 9 15:20:23 cvk68 kernel: [76994.822852] 0000000001f80101 000000000000000b ffff880c1cc84030 0000000000000000
Jun 9 15:20:23 cvk68 kernel: [76994.822857] ffffffffa0505430 ffff880c1d183000 ffff880c1cc84030 0000000001f80101
Jun 9 15:20:23 cvk68 kernel: [76994.822861] 0000000001f80101 00001000a0473010 0000000000000000 ffff880c1dd35000
Jun 9 15:20:23 cvk68 kernel: [76994.822865] Call Trace:
Jun 9 15:20:23 cvk68 kernel: [76994.822878] [<ffffffffa048bf98>] ocfs2_journal_access_di+0x18/0x20 [ocfs2]
Jun 9 15:20:23 cvk68 kernel: [76994.822888] [<ffffffffa0463cf3>] ocfs2_write_end_nolock+0x63/0x430 [ocfs2]
Jun 9 15:20:23 cvk68 kernel: [76994.822897] [<ffffffffa0463c42>] ? ocfs2_write_begin+0x1e2/0x230 [ocfs2]
Jun 9 15:20:23 cvk68 kernel: [76994.822906] [<ffffffffa04640e6>] ocfs2_write_end+0x26/0x50 [ocfs2]
Jun 9 15:20:23 cvk68 kernel: [76994.822910] [<ffffffff81153495>] generic_file_buffered_write+0x165/0x280
Jun 9 15:20:23 cvk68 kernel: [76994.822921] [<ffffffffa048453f>] ocfs2_file_aio_write+0x74f/0x790 [ocfs2]
Jun 9 15:20:23 cvk68 kernel: [76994.822925] [<ffffffff811c14ba>] do_sync_write+0x5a/0x90
Jun 9 15:20:23 cvk68 kernel: [76994.822928] [<ffffffff811c1fc5>] vfs_write+0xc5/0x1f0
Jun 9 15:20:23 cvk68 kernel: [76994.822931] [<ffffffff811c24c2>] SyS_write+0x52/0xa0
Jun 9 15:20:23 cvk68 kernel: [76994.822934] [<ffffffff8176106d>] system_call_fastpath+0x1a/0x1f
Jun 9 15:20:23 cvk68 kernel: [76994.822936] Code: 8b 95 fc 02 00 00 48 63 c9 48 89 04 24 41 b9 9a 02 00 00 49 c7 c0 e0 dc 4e a0 4c 89 f6 48 c7 c7 18 a4 4f a0 31 c0 e8 29 09 2c e1 <0f> 0b 65 8b 0c 25 64 b0 00 00 65 48 8b 34 25 c0 c7 00 00 8b 96
Jun 9 15:20:23 cvk68 kernel: [76994.822961] RIP [<ffffffffa048b15d>] __ocfs2_journal_access+0x30d/0x350 [ocfs2]

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150609/57e507e1/attachment.html 
