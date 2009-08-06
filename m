From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  6 Aug 2009 16:12:58 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Initialize the cluster we're
	writing to in a non-sparse extend
In-Reply-To: <1249600378-18706-1-git-send-email-sunil.mushran@oracle.com>
References: <1249600378-18706-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1249600378-18706-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In a non-sparse extend, we correctly allocate (and zero) the clusters between
the old_i_size and pos, but we don't zero the portions of the cluster we're
writing to outside of pos<->len.

It handles clustersize > pagesize and blocksize < pagesize.

[Cleaned up by Joel Becker.]

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/aops.c |   65 +++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b745ad0..f896ea2 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -922,18 +922,17 @@ struct ocfs2_write_cluster_desc {
 	 */
 	unsigned	c_new;
 	unsigned	c_unwritten;
+	unsigned	c_needs_zero;
 };
 
-static inline int ocfs2_should_zero_cluster(struct ocfs2_write_cluster_desc *d)
-{
-	return d->c_new || d->c_unwritten;
-}
-
 struct ocfs2_write_ctxt {
 	/* Logical cluster position / len of write */
 	u32				w_cpos;
 	u32				w_clen;
 
+	/* First cluster allocated in a nonsparse extend */
+	u32				w_first_new_cpos;
+
 	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
 
 	/*
@@ -1011,6 +1010,7 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 		return -ENOMEM;
 
 	wc->w_cpos = pos >> osb->s_clustersize_bits;
+	wc->w_first_new_cpos = UINT_MAX;
 	cend = (pos + len - 1) >> osb->s_clustersize_bits;
 	wc->w_clen = cend - wc->w_cpos + 1;
 	get_bh(di_bh);
@@ -1248,18 +1248,17 @@ out:
  */
 static int ocfs2_write_cluster(struct address_space *mapping,
 			       u32 phys, unsigned int unwritten,
+			       unsigned int should_zero,
 			       struct ocfs2_alloc_context *data_ac,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct ocfs2_write_ctxt *wc, u32 cpos,
 			       loff_t user_pos, unsigned user_len)
 {
-	int ret, i, new, should_zero = 0;
+	int ret, i, new;
 	u64 v_blkno, p_blkno;
 	struct inode *inode = mapping->host;
 
 	new = phys == 0 ? 1 : 0;
-	if (new || unwritten)
-		should_zero = 1;
 
 	if (new) {
 		u32 tmp_pos;
@@ -1370,7 +1369,9 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
 			local_len = osb->s_clustersize - cluster_off;
 
 		ret = ocfs2_write_cluster(mapping, desc->c_phys,
-					  desc->c_unwritten, data_ac, meta_ac,
+					  desc->c_unwritten,
+					  desc->c_needs_zero,
+					  data_ac, meta_ac,
 					  wc, desc->c_cpos, pos, local_len);
 		if (ret) {
 			mlog_errno(ret);
@@ -1420,14 +1421,14 @@ static void ocfs2_set_target_boundaries(struct ocfs2_super *osb,
 		 * newly allocated cluster.
 		 */
 		desc = &wc->w_desc[0];
-		if (ocfs2_should_zero_cluster(desc))
+		if (desc->c_needs_zero)
 			ocfs2_figure_cluster_boundaries(osb,
 							desc->c_cpos,
 							&wc->w_target_from,
 							NULL);
 
 		desc = &wc->w_desc[wc->w_clen - 1];
-		if (ocfs2_should_zero_cluster(desc))
+		if (desc->c_needs_zero)
 			ocfs2_figure_cluster_boundaries(osb,
 							desc->c_cpos,
 							NULL,
@@ -1495,13 +1496,28 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 			phys++;
 		}
 
+		/*
+		 * If w_first_new_cpos is < UINT_MAX, we have a non-sparse
+		 * file that got extended.  w_first_new_cpos tells us
+		 * where the newly allocated clusters are so we can
+		 * zero them.
+		 */
+		if (desc->c_cpos >= wc->w_first_new_cpos) {
+			BUG_ON(phys == 0);
+			desc->c_needs_zero = 1;
+		}
+
 		desc->c_phys = phys;
 		if (phys == 0) {
 			desc->c_new = 1;
+			desc->c_needs_zero = 1;
 			*clusters_to_alloc = *clusters_to_alloc + 1;
 		}
-		if (ext_flags & OCFS2_EXT_UNWRITTEN)
+
+		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
 			desc->c_unwritten = 1;
+			desc->c_needs_zero = 1;
+		}
 
 		num_clusters--;
 	}
@@ -1658,10 +1674,13 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
 	if (newsize <= i_size_read(inode))
 		return 0;
 
-	ret = ocfs2_extend_no_holes(inode, newsize, newsize - len);
+	ret = ocfs2_extend_no_holes(inode, newsize, pos);
 	if (ret)
 		mlog_errno(ret);
 
+	wc->w_first_new_cpos =
+		ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode));
+
 	return ret;
 }
 
@@ -1670,7 +1689,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 			     struct page **pagep, void **fsdata,
 			     struct buffer_head *di_bh, struct page *mmap_page)
 {
-	int ret, credits = OCFS2_INODE_UPDATE_CREDITS;
+	int ret, cluster_of_pages, credits = OCFS2_INODE_UPDATE_CREDITS;
 	unsigned int clusters_to_alloc, extents_to_split;
 	struct ocfs2_write_ctxt *wc;
 	struct inode *inode = mapping->host;
@@ -1738,8 +1757,19 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 
 	}
 
-	ocfs2_set_target_boundaries(osb, wc, pos, len,
-				    clusters_to_alloc + extents_to_split);
+	/*
+	 * We have to zero sparse allocated clusters, unwritten extent clusters,
+	 * and non-sparse clusters we just extended.  For non-sparse writes,
+	 * we know zeros will only be needed in the first and/or last cluster.
+	 */
+	if (clusters_to_alloc || extents_to_split ||
+	    wc->w_desc[0].c_needs_zero ||
+	    wc->w_desc[wc->w_clen - 1].c_needs_zero)
+		cluster_of_pages = 1;
+	else
+		cluster_of_pages = 0;
+
+	ocfs2_set_target_boundaries(osb, wc, pos, len, cluster_of_pages);
 
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
@@ -1767,8 +1797,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	 * extent.
 	 */
 	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos,
-					 clusters_to_alloc + extents_to_split,
-					 mmap_page);
+					 cluster_of_pages, mmap_page);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
-- 
1.6.0.4
