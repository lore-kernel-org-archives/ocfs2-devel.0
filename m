From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 18 Dec 2015 18:45:27 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix BUG when calculate new backup super
Message-ID: <5673E3C7.9050607@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When resize, it firstly extends the last gd. Once it should backup super
in the gd, it calculates new backup super and update the corresponding
value. But it currently doesn't consider the situation that the backup
super is already done. And in this case, it still sets the bit in gd
bitmap and then decrease from bg_free_bits_count, which leads to a
corrupted gd and trigger the BUG in ocfs2_block_group_set_bits:
BUG_ON(le16_to_cpu(bg->bg_free_bits_count) < num_bits);
So check whether the backup super is done and then do the updates.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/resize.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index d5da6f6..79b8021 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -54,11 +54,12 @@
 static u16 ocfs2_calc_new_backup_super(struct inode *inode,
 				       struct ocfs2_group_desc *gd,
 				       u16 cl_cpg,
+				       u16 old_bg_clusters,
 				       int set)
 {
 	int i;
 	u16 backups = 0;
-	u32 cluster;
+	u32 cluster, lgd_cluster;
 	u64 blkno, gd_blkno, lgd_blkno = le64_to_cpu(gd->bg_blkno);

 	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
@@ -71,6 +72,12 @@ static u16 ocfs2_calc_new_backup_super(struct inode *inode,
 		else if (gd_blkno > lgd_blkno)
 			break;

+		/* check if already done backup super */
+		lgd_cluster = ocfs2_blocks_to_clusters(inode->i_sb, lgd_blkno);
+		lgd_cluster += old_bg_clusters;
+		if (lgd_cluster >= cluster)
+			continue;
+
 		if (set)
 			ocfs2_set_bit(cluster % cl_cpg,
 				      (unsigned long *)gd->bg_bitmap);
@@ -99,6 +106,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	u16 chain, num_bits, backups = 0;
 	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
 	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
+	u16 old_bg_clusters;

 	trace_ocfs2_update_last_group_and_inode(new_clusters,
 						first_new_cluster);
@@ -112,6 +120,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,

 	group = (struct ocfs2_group_desc *)group_bh->b_data;

+	old_bg_clusters = le16_to_cpu(group->bg_bits) / cl_bpc;
 	/* update the group first. */
 	num_bits = new_clusters * cl_bpc;
 	le16_add_cpu(&group->bg_bits, num_bits);
@@ -125,7 +134,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 				     OCFS2_FEATURE_COMPAT_BACKUP_SB)) {
 		backups = ocfs2_calc_new_backup_super(bm_inode,
 						     group,
-						     cl_cpg, 1);
+						     cl_cpg, old_bg_clusters, 1);
 		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
 	}

@@ -163,7 +172,7 @@ out_rollback:
 	if (ret < 0) {
 		ocfs2_calc_new_backup_super(bm_inode,
 					    group,
-					    cl_cpg, 0);
+					    cl_cpg, old_bg_clusters, 0);
 		le16_add_cpu(&group->bg_free_bits_count, backups);
 		le16_add_cpu(&group->bg_bits, -1 * num_bits);
 		le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
-- 
1.8.4.3
