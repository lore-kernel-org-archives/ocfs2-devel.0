From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri,  4 Nov 2016 16:28:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix not enough credit panic
Message-ID: <1478248135-31963-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following panic was caught when run ocfs2 disconfig single test
(block size 512 and cluster size 8192). ocfs2_journal_dirty() return
-ENOSPC, that means credits were used up. The total credit should
include 3 times of "num_dx_leaves" from ocfs2_dx_dir_rebalance(),
because 2 times will be consumed in ocfs2_dx_dir_transfer_leaf() and
1 time will be consumed in ocfs2_dx_dir_new_cluster()->
__ocfs2_dx_dir_new_cluster()->ocfs2_dx_dir_format_cluster(). But only
two times is included in ocfs2_dx_dir_rebalance_credits(), fix it.
This can cause read-only fs(v4.1+) or panic for mainline linux
depending on mount option.

[34377.331151] ------------[ cut here ]------------
[34377.332007] kernel BUG at fs/ocfs2/journal.c:775!
[34377.344107] invalid opcode: 0000 [#1] SMP
[34377.346090] Modules linked in: ocfs2 nfsd lockd grace nfs_acl auth_rpcgss sunrpc autofs4 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs sd_mod sg ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ppdev xen_kbdfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea parport_pc parport acpi_cpufreq i2c_piix4 i2c_core pcspkr ext4 jbd2 mbcache xen_blkfront floppy pata_acpi ata_generic ata_piix dm_mirror dm_region_hash dm_log dm_mod
[34377.346090] CPU: 2 PID: 10601 Comm: dd Not tainted 4.1.12-71.el6uek.bug24939243.x86_64 #2
[34377.346090] Hardware name: Xen HVM domU, BIOS 4.4.4OVM 02/11/2016
[34377.346090] task: ffff8800b6de6200 ti: ffff8800a7d48000 task.ti: ffff8800a7d48000
[34377.346090] RIP: 0010:[<ffffffffa06e7397>]  [<ffffffffa06e7397>] ocfs2_journal_dirty+0xa7/0xb0 [ocfs2]
[34377.346090] RSP: 0018:ffff8800a7d4b6d8  EFLAGS: 00010286
[34377.346090] RAX: 00000000ffffffe4 RBX: 00000000814d0a9c RCX: 00000000000004f9
[34377.346090] RDX: ffffffffa008e990 RSI: ffffffffa008f1ee RDI: ffff8800622b6460
[34377.346090] RBP: ffff8800a7d4b6f8 R08: ffffffffa008f288 R09: ffff8800622b6460
[34377.346090] R10: 0000000000000000 R11: 0000000000000282 R12: 0000000002c8421e
[34377.346090] R13: ffff88006d0cad00 R14: ffff880092beef60 R15: 0000000000000070
[34377.346090] FS:  00007f9b83e92700(0000) GS:ffff8800be880000(0000) knlGS:0000000000000000
[34377.346090] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[34377.346090] CR2: 00007fb2c0d1a000 CR3: 0000000008f80000 CR4: 00000000000406e0
[34377.346090] Stack:
[34377.346090]  00000000814d0a9c ffff88005fe61e00 ffff88006e995c00 ffff880009847c00
[34377.346090]  ffff8800a7d4b768 ffffffffa06c0999 ffff88009d3c2a10 ffff88005fe61e30
[34377.346090]  ffff8800997ce500 ffff8800997ce980 ffff880092beef60 000000100000000e
[34377.346090] Call Trace:
[34377.346090]  [<ffffffffa06c0999>] ocfs2_dx_dir_transfer_leaf+0x159/0x1a0 [ocfs2]
[34377.346090]  [<ffffffffa06c3eeb>] ocfs2_dx_dir_rebalance+0xd9b/0xea0 [ocfs2]
[34377.346090]  [<ffffffffa06dedb2>] ? ocfs2_inode_cache_io_unlock+0x12/0x20 [ocfs2]
[34377.346090]  [<ffffffffa0761180>] ? ocfs2_refcount_tree_et_ops+0x60/0xfffffffffffe4b31 [ocfs2]
[34377.346090]  [<ffffffffa06e7730>] ? ocfs2_journal_access_dl+0x20/0x20 [ocfs2]
[34377.346090]  [<ffffffffa06c6b63>] ocfs2_find_dir_space_dx+0xd3/0x300 [ocfs2]
[34377.346090]  [<ffffffffa06c9709>] ocfs2_prepare_dx_dir_for_insert+0x219/0x450 [ocfs2]
[34377.346090]  [<ffffffffa06c9b16>] ocfs2_prepare_dir_for_insert+0x1d6/0x580 [ocfs2]
[34377.346090]  [<ffffffffa06dee90>] ? ocfs2_read_inode_block+0x10/0x20 [ocfs2]
[34377.346090]  [<ffffffffa06f38e2>] ocfs2_mknod+0x5a2/0x1400 [ocfs2]
[34377.346090]  [<ffffffffa06f4933>] ocfs2_create+0x73/0x180 [ocfs2]
[34377.346090]  [<ffffffff81211de8>] vfs_create+0xd8/0x100
[34377.346090]  [<ffffffff8120f5fd>] ? lookup_real+0x1d/0x60
[34377.346090]  [<ffffffff81212535>] lookup_open+0x185/0x1c0
[34377.346090]  [<ffffffff8121571d>] do_last+0x36d/0x780
[34377.346090]  [<ffffffff812a85d6>] ? security_file_alloc+0x16/0x20
[34377.346090]  [<ffffffff81215bc2>] path_openat+0x92/0x470
[34377.346090]  [<ffffffff81215fea>] do_filp_open+0x4a/0xa0
[34377.346090]  [<ffffffff8132c570>] ? find_next_zero_bit+0x10/0x20
[34377.346090]  [<ffffffff812232ec>] ? __alloc_fd+0xac/0x150
[34377.346090]  [<ffffffff8120459a>] do_sys_open+0x11a/0x230
[34377.346090]  [<ffffffff810259d3>] ? syscall_trace_enter_phase1+0x153/0x180
[34377.346090]  [<ffffffff812046ee>] SyS_open+0x1e/0x20
[34377.346090]  [<ffffffff816cb6ee>] system_call_fastpath+0x12/0x71
[34377.346090] Code: 1d 3f 29 09 00 48 85 db 74 1f 48 8b 03 0f 1f 80 00 00 00 00 48 8b 7b 08 48 83 c3 10 4c 89 e6 ff d0 48 8b 03 48 85 c0 75 eb eb 90 <0f> 0b eb fe 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54
[34377.346090] RIP  [<ffffffffa06e7397>] ocfs2_journal_dirty+0xa7/0xb0 [ocfs2]
[34377.346090]  RSP <ffff8800a7d4b6d8>
[34377.615401] ---[ end trace 91ac5312a6ee1288 ]---
[34377.618919] Kernel panic - not syncing: Fatal exception
[34377.619910] Kernel Offset: disabled

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index ccd4dcfc3645..39f02b75aaf8 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3712,7 +3712,7 @@ static void ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
 static int ocfs2_dx_dir_rebalance_credits(struct ocfs2_super *osb,
 					  struct ocfs2_dx_root_block *dx_root)
 {
-	int credits = ocfs2_clusters_to_blocks(osb->sb, 2);
+	int credits = ocfs2_clusters_to_blocks(osb->sb, 3);
 
 	credits += ocfs2_calc_extend_credits(osb->sb, &dx_root->dr_list);
 	credits += ocfs2_quota_trans_credits(osb->sb);
-- 
1.7.9.5
