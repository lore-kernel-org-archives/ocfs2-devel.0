From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 12 Sep 2016 18:03:43 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix trans extend while free cached
	blocks
In-Reply-To: <1473674623-11810-1-git-send-email-junxiao.bi@oracle.com>
References: <1473674623-11810-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1473674623-11810-2-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Root cause of this issue is the same with the one fixed by last patch,
but this time credits for allocator inode and group descriptor may not
be consumed before trans extend.

The following error was caught.

[  685.240276] WARNING: CPU: 0 PID: 2037 at fs/jbd2/transaction.c:269 start_this_handle+0x4c3/0x510 [jbd2]()
[  685.240294] Modules linked in: ocfs2 nfsd lockd grace nfs_acl auth_rpcgss sunrpc autofs4 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs sd_mod sg ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ppdev xen_kbdfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_netfront parport_pc parport pcspkr i2c_piix4 i2c_core acpi_cpufreq ext4 jbd2 mbcache xen_blkfront floppy pata_acpi ata_generic ata_piix dm_mirror dm_region_hash dm_log dm_mod
[  685.240296] CPU: 0 PID: 2037 Comm: rm Tainted: G        W       4.1.12-37.6.3.el6uek.bug24573128v2.x86_64 #2
[  685.240296] Hardware name: Xen HVM domU, BIOS 4.4.4OVM 02/11/2016
[  685.240298]  000000000000010d ffff88007ac3f808 ffffffff816bc5bc 000000000000010d
[  685.240300]  0000000000000000 ffff88007ac3f848 ffffffff81081475 ffff88007ac3f828
[  685.240301]  ffff880037bbf000 ffff880037688210 0000000000000095 0000000000000050
[  685.240301] Call Trace:
[  685.240305]  [<ffffffff816bc5bc>] dump_stack+0x48/0x5c
[  685.240308]  [<ffffffff81081475>] warn_slowpath_common+0x95/0xe0
[  685.240310]  [<ffffffff810814da>] warn_slowpath_null+0x1a/0x20
[  685.240313]  [<ffffffffa0080993>] start_this_handle+0x4c3/0x510 [jbd2]
[  685.240317]  [<ffffffffa0088f95>] ? __jbd2_log_start_commit+0xe5/0xf0 [jbd2]
[  685.240319]  [<ffffffff810c4eb3>] ? __wake_up+0x53/0x70
[  685.240322]  [<ffffffffa0080b41>] jbd2__journal_restart+0x161/0x1b0 [jbd2]
[  685.240325]  [<ffffffffa0080ba3>] jbd2_journal_restart+0x13/0x20 [jbd2]
[  685.240340]  [<ffffffffa06d1cf4>] ocfs2_extend_trans+0x74/0x220 [ocfs2]
[  685.240347]  [<ffffffffa069762b>] ocfs2_free_cached_blocks+0x16b/0x4e0 [ocfs2]
[  685.240349]  [<ffffffff810e9131>] ? internal_add_timer+0x91/0xc0
[  685.240356]  [<ffffffffa06981b0>] ocfs2_run_deallocs+0x70/0x270 [ocfs2]
[  685.240363]  [<ffffffffa06a2894>] ocfs2_commit_truncate+0x474/0x6f0 [ocfs2]
[  685.240374]  [<ffffffffa0744a40>] ? ocfs2_xattr_tree_et_ops+0x60/0xfffffffffffe8c00 [ocfs2]
[  685.240384]  [<ffffffffa06d1960>] ? ocfs2_journal_access_eb+0x20/0x20 [ocfs2]
[  685.240385]  [<ffffffff81202303>] ? __sb_end_write+0x33/0x70
[  685.240394]  [<ffffffffa06ca57d>] ocfs2_truncate_for_delete+0xbd/0x380 [ocfs2]
[  685.240402]  [<ffffffffa06ca1f4>] ? ocfs2_query_inode_wipe+0xf4/0x320 [ocfs2]
[  685.240409]  [<ffffffffa06caed6>] ocfs2_wipe_inode+0x136/0x6a0 [ocfs2]
[  685.240415]  [<ffffffffa06ca1f4>] ? ocfs2_query_inode_wipe+0xf4/0x320 [ocfs2]
[  685.240422]  [<ffffffffa06cb6e2>] ocfs2_delete_inode+0x2a2/0x3e0 [ocfs2]
[  685.240424]  [<ffffffff812298c9>] ? __inode_wait_for_writeback+0x69/0xc0
[  685.240437]  [<ffffffffa0732100>] ? __PRETTY_FUNCTION__.112282+0x20/0xffffffffffffb500 [ocfs2]
[  685.240444]  [<ffffffffa06cc1f8>] ocfs2_evict_inode+0x28/0x60 [ocfs2]
[  685.240445]  [<ffffffff8121b81b>] evict+0xab/0x1a0
[  685.240456]  [<ffffffffa0732100>] ? __PRETTY_FUNCTION__.112282+0x20/0xffffffffffffb500 [ocfs2]
[  685.240457]  [<ffffffff8121ba06>] iput_final+0xf6/0x190
[  685.240458]  [<ffffffff8121bb68>] iput+0xc8/0xe0
[  685.240460]  [<ffffffff8120f9b7>] do_unlinkat+0x1b7/0x310
[  685.240462]  [<ffffffff81126dbc>] ? __audit_syscall_entry+0xac/0x110
[  685.240464]  [<ffffffff810236cc>] ? do_audit_syscall_entry+0x6c/0x70
[  685.240465]  [<ffffffff81023823>] ? syscall_trace_enter_phase1+0x153/0x180
[  685.240467]  [<ffffffff8120fd52>] SyS_unlinkat+0x22/0x40
[  685.240468]  [<ffffffff816c122e>] system_call_fastpath+0x12/0x71
[  685.240469] ---[ end trace a62437cb060baa71 ]---
[  685.240470] JBD2: rm wants too many credits (149 > 128)

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/alloc.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 51128789a661..f165f867f332 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6404,43 +6404,34 @@ static int ocfs2_free_cached_blocks(struct ocfs2_super *osb,
 		goto out_mutex;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_SUBALLOC_FREE);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto out_unlock;
-	}
-
 	while (head) {
 		if (head->free_bg)
 			bg_blkno = head->free_bg;
 		else
 			bg_blkno = ocfs2_which_suballoc_group(head->free_blk,
 							      head->free_bit);
+		handle = ocfs2_start_trans(osb, OCFS2_SUBALLOC_FREE);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			mlog_errno(ret);
+			goto out_unlock;
+		}
+
 		trace_ocfs2_free_cached_blocks(
 		     (unsigned long long)head->free_blk, head->free_bit);
 
 		ret = ocfs2_free_suballoc_bits(handle, inode, di_bh,
 					       head->free_bit, bg_blkno, 1);
-		if (ret) {
+		if (ret)
 			mlog_errno(ret);
-			goto out_journal;
-		}
 
-		ret = ocfs2_extend_trans(handle, OCFS2_SUBALLOC_FREE);
-		if (ret) {
-			mlog_errno(ret);
-			goto out_journal;
-		}
+		ocfs2_commit_trans(osb, handle);
 
 		tmp = head;
 		head = head->free_next;
 		kfree(tmp);
 	}
 
-out_journal:
-	ocfs2_commit_trans(osb, handle);
-
 out_unlock:
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
-- 
1.7.9.5
