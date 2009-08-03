From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  3 Aug 2009 11:13:29 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Initialize the cluster we're
	writing to in a non-sparse extend
In-Reply-To: <1249323209-28169-1-git-send-email-sunil.mushran@oracle.com>
References: <1249323209-28169-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1249323209-28169-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In a non-sparse extend, we correctly allocate (and zero) the clusters between
the old_i_size and pos, but we don't zero the portions of the cluster we're
writing to outside of pos<->len.

[Cleaned up by Joel Becker.]

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/aops.c |   54 +++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b745ad0..4d9881c 100644
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
@@ -1495,17 +1496,41 @@ static int ocfs2_populate_write_desc(struct inode *inode,
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
 		desc->c_phys = phys;
 		if (phys == 0) {
 			desc->c_new = 1;
+			desc->c_needs_zero = 1;
 			*clusters_to_alloc = *clusters_to_alloc + 1;
 		}
-		if (ext_flags & OCFS2_EXT_UNWRITTEN)
+		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
 			desc->c_unwritten = 1;
+			desc->c_needs_zero = 1;
+		}
 
 		num_clusters--;
 	}
 
+	mlog(0, "inode %llu, wc 0x%p, cpos %u, clen %u, fcpos %u\n",
+	     OCFS2_I(inode)->ip_blkno, wc, wc->w_cpos, wc->w_clen,
+	     wc->w_first_new_cpos);
+
+        for (i = 0; i < wc->w_clen; i++) {
+		desc = &wc->w_desc[i];
+		mlog(0, "%d => cpos %u, phys %u, new %u, unw %u, zero %u\n",
+		     i, desc->c_cpos, desc->c_phys, desc->c_new,
+		     desc->c_unwritten, desc->c_needs_zero);
+	}
+
 	ret = 0;
 out:
 	return ret;
@@ -1658,10 +1683,13 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
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
 
-- 
1.6.0.4
