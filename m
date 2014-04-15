From: Guozhonghua <guozhonghua@h3c.com>
Date: Tue, 15 Apr 2014 01:22:49 +0000
Subject: [Ocfs2-devel] Is it an issue,
	or had been fixed in new kernel verions? Thanks
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC3FB37@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, everyone:

As the disk is umounted, the host is panic or bloked.
The host must be repowered.
The test scenario is with Linux kernel 3.13.6.


Apr 12 20:55:01 ZJ-HZDX-0321-D20-CVK-03 kernel: [870221.355731] sd 7:0:0:0: [sdl] Very big device. Trying to use READ CAPACITY(16).
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782364] (umount,44814,19):dlm_prepare_lvb_for_migration:1205 ERROR: Mismatched lvb in lock cookie=2:519367, name=M00000000000000000002094cc0d288, node=2
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782383] lockres: M00000000000000000002094cc0d288, owner=3, state=32
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782386]   last used: 0, refcnt: 4, on purge list: no
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782389]   on dirty list: no, on reco list: no, migrating pending: no
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782392]   inflight locks: 0, asts reserved: 0
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782394]   refmap nodes: [ 1 2 ], inflight=0
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782400]   granted queue:
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782405]     type=3, conv=-1, node=1, cookie=1:7, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782410]     type=3, conv=-1, node=2, cookie=2:519367, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782412]   converting queue:
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782414]   blocked queue:
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782457] ------------[ cut here ]------------
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782462] Kernel BUG at ffffffffa02f8d4f [verbose debug info unavailable]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782469] invalid opcode: 0000 [#1] SMP
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782476] Modules linked in: ext2(F) ocfs2(OF) quota_tree(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) ebtable_nat(F) ebtables(F) x_tables(F) 8021q(F) mrp(F) garp(F) stp(F) llc(F) vhost_net(F) macvtap(F) macvlan(F) vhost(F) kvm_intel(F) kvm(F) ib_iser(F) rdma_cm(F) ib_cm(F) iw_cm(F) ib_sa(F) ib_mad(F) ib_core(F) ib_addr(F) iscsi_tcp(F) libiscsi_tcp(F) libiscsi(F) scsi_transport_iscsi(F) ocfs2_dlmfs(OF) ocfs2_stack_o2cb(OF) ocfs2_dlm(OF) ocfs2_nodemanager(OF) ocfs2_stackglue(OF) configfs(F) openvswitch(OF) gre(F) nfsd(F) nfs_acl(F) auth_rpcgss(F) nfs(F) fscache(F) lockd(F) sunrpc(F) psmouse(F) dm_multipath(F) sb_edac(F) ipmi_si(F) edac_core(F) serio_raw(F) ioatdma(F) hpilo(F) gpio_ich(F) scsi_dh(F) hpwdt(F) mac_hid(F) dca(F) acpi_power_meter(F) lpc_ich(F) lp(F) parport(F) tg3(F) ptp(F) hpsa(F) pps_core(F) bnx2x(F) libcrc32c(F) mdio(F) nbd(F)
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782597] CPU: 19 PID: 44814 Comm: umount Tainted: GF          O 3.13.6 #1
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782603] Hardware name: H3C FlexServer R390, BIOS P70 09/18/2013
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782609] task: ffff881772fae000 ti: ffff881385d8a000 task.ti: ffff881385d8a000
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782616] RIP: 0010:[<ffffffffa02f8d4f>]  [<ffffffffa02f8d4f>] dlm_add_lock_to_array+0x1cf/0x1e0 [ocfs2_dlm]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782637] RSP: 0018:ffff881385d8b9d8  EFLAGS: 00010246
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782643] RAX: 0000000000000000 RBX: ffff880049d33600 RCX: 0000000000000006
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782650] RDX: 0000000000000007 RSI: 0000000002680266 RDI: ffff8817fbf57170
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782656] RBP: ffff881385d8ba28 R08: 000000000000000a R09: 0000000000000000
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782662] R10: 0000000000047a48 R11: 0000000000047a47 R12: ffff8811b3d5b000
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782669] R13: ffff8811b3d5b080 R14: ffff8817fbf570e8 R15: 0000000000000000
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782676] FS:  00007fbdb8d5e800(0000) GS:ffff88183f8e0000(0000) knlGS:0000000000000000
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782683] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782689] CR2: 00007fbdb8378120 CR3: 00000015de25f000 CR4: 00000000000407e0
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782695] Stack:
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782699]  ffff881300000002 000000000007ecc7 ffff88170000001f ffff8817faf6a9e0
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782712]  0000000000000002 0000000000000002 0000000000000000 ffff880049d33600
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782723]  0000000000000002 ffff8811b3d5b000 ffff881385d8bae8 ffffffffa02fd5eb
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782734] Call Trace:
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782750]  [<ffffffffa02fd5eb>] dlm_send_one_lockres+0x19b/0x4f0 [ocfs2_dlm]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782765]  [<ffffffff81083f19>] ? flush_workqueue+0x1c9/0x610
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782780]  [<ffffffffa030aa4b>] dlm_empty_lockres+0x4cb/0x1140 [ocfs2_dlm]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782795]  [<ffffffff810ada96>] ? autoremove_wake_function+0x16/0x40
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782804]  [<ffffffff810ad358>] ? __wake_up_common+0x58/0x90
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782817]  [<ffffffffa02f40a0>] dlm_unregister_domain+0x270/0x890 [ocfs2_dlm]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782829]  [<ffffffff81099cf5>] ? check_preempt_curr+0x75/0xa0
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782840]  [<ffffffffa02e62dc>] ? o2cb_cluster_disconnect+0x3c/0x60 [ocfs2_stack_o2cb]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782855]  [<ffffffff811a7824>] ? kfree+0x134/0x170
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782864]  [<ffffffffa02e62e4>] o2cb_cluster_disconnect+0x44/0x60 [ocfs2_stack_o2cb]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782878]  [<ffffffffa025cb6e>] ocfs2_cluster_disconnect+0x2e/0x68 [ocfs2_stackglue]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782916]  [<ffffffffa04f6917>] ocfs2_dlm_shutdown+0xb7/0x100 [ocfs2]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782952]  [<ffffffffa0544752>] ocfs2_dismount_volume+0x202/0x3f0 [ocfs2]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782965]  [<ffffffff8115324b>] ? filemap_fdatawait+0x2b/0x30
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.782974]  [<ffffffff81154f64>] ? filemap_write_and_wait+0x34/0x60
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783004]  [<ffffffffa0544977>] ocfs2_put_super+0x37/0x90 [ocfs2]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783017]  [<ffffffff811c3fde>] generic_shutdown_super+0x7e/0x110
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783025]  [<ffffffff811c40a0>] kill_block_super+0x30/0x80
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783053]  [<ffffffffa0541043>] ocfs2_kill_sb+0x83/0xa0 [ocfs2]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783062]  [<ffffffff811c42ed>] deactivate_locked_super+0x4d/0x80
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783070]  [<ffffffff811c4f3e>] deactivate_super+0x4e/0x70
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783082]  [<ffffffff811e0ea8>] mntput_no_expire+0xc8/0x150
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783092]  [<ffffffff811e211f>] SyS_umount+0xaf/0x3b0
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783106]  [<ffffffff81760fbf>] tracesys+0xe1/0xe6
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783111] Code: 48 81 c6 c0 04 00 00 41 b9 b5 04 00 00 49 c7 c0 20 51 31 a0 48 c7 c7 60 7c 31 a0 31 c0 e8 c0 2a 45 e1 48 8b 7b 40 e8 71 d5 ff ff <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783179] RIP  [<ffffffffa02f8d4f>] dlm_add_lock_to_array+0x1cf/0x1e0 [ocfs2_dlm]
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.783192]  RSP <ffff881385d8b9d8>
Apr 12 20:55:08 ZJ-HZDX-0321-D20-CVK-03 kernel: [870227.844940] ---[ end trace ccf348a85391d27e ]---
Apr 12 20:55:28 ZJ-HZDX-0321-D20-CVK-03 kernel: [870247.737249] o2dlm: Leaving domain 1220B17D51D141C784B30E8FE4C7E19C
Apr 12 20:55:30 ZJ-HZDX-0321-D20-CVK-03 kernel: [870249.949859] ocfs2: Unmounting device (8,176) on (node 3)
Apr 12 20:55:30 ZJ-HZDX-0321-D20-CVK-03 multipathd: sdl: remove path (uevent)
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140415/a7ca0d0b/attachment.html 
