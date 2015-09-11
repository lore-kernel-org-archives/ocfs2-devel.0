From: Ryan Ding <ryan.ding@oracle.com>
Date: Fri, 11 Sep 2015 16:19:13 +0800
Subject: [Ocfs2-devel] [PATCH 2/8] ocfs2: use c_new to indicate newly
	allocated extents
In-Reply-To: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
References: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
Message-ID: <1441959559-29947-3-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

There is a problem in ocfs2's direct io implement: if system crashed after
extents allocated, and before data return, we will get a extent with dirty data
on disk. This problem violate the journal=order semantics, which means meta
changes take effect after data written to disk.
To resolve this issue, direct write can use the UNWRITTEN flag to describe a
extent during direct data writeback. The direct write procedure should act in
the following order:

phase 1: alloc extent with UNWRITTEN flag
phase 2: submit direct data to disk, add zero page to page cache
phase 3: clear UNWRITTEN flag when data has been written to disk

This patch is to change the 'c_unwritten' member of ocfs2_write_cluster_desc to
'c_clear_unwritten'. Means whether to clear the unwritten flag. It do not care
if a extent is allocated or not. And use 'c_new' to specify a newly allocated
extent. So the direct io procedure can use c_clear_unwritten to control the
UNWRITTEN bit on extent.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
cc: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b65ebb1..0f022dc 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1204,7 +1204,7 @@ struct ocfs2_write_cluster_desc {
 	 * filled.
 	 */
 	unsigned	c_new;
-	unsigned	c_unwritten;
+	unsigned	c_clear_unwritten;
 	unsigned	c_needs_zero;
 };
 
@@ -1580,19 +1580,19 @@ out:
  * Prepare a single cluster for write one cluster into the file.
  */
 static int ocfs2_write_cluster(struct address_space *mapping,
-			       u32 phys, unsigned int unwritten,
+			       u32 phys, unsigned int new,
+			       unsigned int clear_unwritten,
 			       unsigned int should_zero,
 			       struct ocfs2_alloc_context *data_ac,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct ocfs2_write_ctxt *wc, u32 cpos,
 			       loff_t user_pos, unsigned user_len)
 {
-	int ret, i, new;
+	int ret, i;
 	u64 v_blkno, p_blkno;
 	struct inode *inode = mapping->host;
 	struct ocfs2_extent_tree et;
 
-	new = phys == 0 ? 1 : 0;
 	if (new) {
 		u32 tmp_pos;
 
@@ -1602,9 +1602,9 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 		 */
 		tmp_pos = cpos;
 		ret = ocfs2_add_inode_data(OCFS2_SB(inode->i_sb), inode,
-					   &tmp_pos, 1, 0, wc->w_di_bh,
-					   wc->w_handle, data_ac,
-					   meta_ac, NULL);
+					   &tmp_pos, 1, !clear_unwritten,
+					   wc->w_di_bh, wc->w_handle,
+					   data_ac, meta_ac, NULL);
 		/*
 		 * This shouldn't happen because we must have already
 		 * calculated the correct meta data allocation required. The
@@ -1621,7 +1621,7 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 			mlog_errno(ret);
 			goto out;
 		}
-	} else if (unwritten) {
+	} else if (clear_unwritten) {
 		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
 					      wc->w_di_bh);
 		ret = ocfs2_mark_extent_written(inode, &et,
@@ -1704,7 +1704,8 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
 			local_len = osb->s_clustersize - cluster_off;
 
 		ret = ocfs2_write_cluster(mapping, desc->c_phys,
-					  desc->c_unwritten,
+					  desc->c_new,
+					  desc->c_clear_unwritten,
 					  desc->c_needs_zero,
 					  data_ac, meta_ac,
 					  wc, desc->c_cpos, pos, local_len);
@@ -1849,11 +1850,12 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 		if (phys == 0) {
 			desc->c_new = 1;
 			desc->c_needs_zero = 1;
+			desc->c_clear_unwritten = 1;
 			*clusters_to_alloc = *clusters_to_alloc + 1;
 		}
 
 		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
-			desc->c_unwritten = 1;
+			desc->c_clear_unwritten = 1;
 			desc->c_needs_zero = 1;
 		}
 
-- 
1.7.1
