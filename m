From: Ryan Ding <ryan.ding@oracle.com>
Date: Fri, 11 Sep 2015 16:19:16 +0800
Subject: [Ocfs2-devel] [PATCH 5/8] ocfs2: return the physical address in
	ocfs2_write_cluster
In-Reply-To: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
References: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
Message-ID: <1441959559-29947-6-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

Direct io needs to get the physical address from write_begin, to map the user
page. This patch is to change the arg 'phys' of ocfs2_write_cluster to a
pointer, so it can be retrieved to write_begin. And we can retrieve it to the
direct io procedure.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
cc: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 41563aa..16bba6b 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1588,7 +1588,7 @@ out:
  * Prepare a single cluster for write one cluster into the file.
  */
 static int ocfs2_write_cluster(struct address_space *mapping,
-			       u32 phys, unsigned int new,
+			       u32 *phys, unsigned int new,
 			       unsigned int clear_unwritten,
 			       unsigned int should_zero,
 			       struct ocfs2_alloc_context *data_ac,
@@ -1597,9 +1597,10 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 			       loff_t user_pos, unsigned user_len)
 {
 	int ret, i;
-	u64 v_blkno, p_blkno;
+	u64 p_blkno;
 	struct inode *inode = mapping->host;
 	struct ocfs2_extent_tree et;
+	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 
 	if (new) {
 		u32 tmp_pos;
@@ -1633,7 +1634,7 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
 					      wc->w_di_bh);
 		ret = ocfs2_mark_extent_written(inode, &et,
-						wc->w_handle, cpos, 1, phys,
+						wc->w_handle, cpos, 1, *phys,
 						meta_ac, &wc->w_dealloc);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -1641,26 +1642,23 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 		}
 	}
 
-	if (should_zero)
-		v_blkno = ocfs2_clusters_to_blocks(inode->i_sb, cpos);
-	else
-		v_blkno = user_pos >> inode->i_sb->s_blocksize_bits;
-
 	/*
 	 * The only reason this should fail is due to an inability to
 	 * find the extent added.
 	 */
-	ret = ocfs2_extent_map_get_blocks(inode, v_blkno, &p_blkno, NULL,
-					  NULL);
+	ret = ocfs2_get_clusters(inode, cpos, phys, NULL, NULL);
 	if (ret < 0) {
 		mlog(ML_ERROR, "Get physical blkno failed for inode %llu, "
-			    "at logical block %llu",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			    (unsigned long long)v_blkno);
+			    "at logical cluster %u",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos);
 		goto out;
 	}
 
-	BUG_ON(p_blkno == 0);
+	BUG_ON(*phys == 0);
+
+	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *phys);
+	if (!should_zero)
+		p_blkno += (user_pos >> inode->i_sb->s_blocksize_bits) & (u64)(bpc - 1);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		int tmpret;
@@ -1717,7 +1715,7 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
 		if ((cluster_off + local_len) > osb->s_clustersize)
 			local_len = osb->s_clustersize - cluster_off;
 
-		ret = ocfs2_write_cluster(mapping, desc->c_phys,
+		ret = ocfs2_write_cluster(mapping, &desc->c_phys,
 					  desc->c_new,
 					  desc->c_clear_unwritten,
 					  desc->c_needs_zero,
-- 
1.7.1
