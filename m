From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sun,  2 Aug 2009 13:04:10 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Initialize the cluster we're
	writing to in a non-sparse extend
In-Reply-To: <1249243450-16209-1-git-send-email-sunil.mushran@oracle.com>
References: <1249243450-16209-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1249243450-16209-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In a non-sparse extend, we correctly allocate (and zero) the clusters between
the old_i_size and pos, but we don't zero the portions of the cluster we're
writing to outside of pos<->len.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/aops.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b745ad0..8b1498e 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -920,13 +920,14 @@ struct ocfs2_write_cluster_desc {
 	 * Give this a unique field because c_phys eventually gets
 	 * filled.
 	 */
-	unsigned	c_new;
-	unsigned	c_unwritten;
+	unsigned	c_new;		/* needs to be allocated */
+	unsigned	c_unwritten;	/* unwritten extent */
+	unsigned	c_needs_zero;	/* nonsparse allocation */
 };
 
 static inline int ocfs2_should_zero_cluster(struct ocfs2_write_cluster_desc *d)
 {
-	return d->c_new || d->c_unwritten;
+	return d->c_new || d->c_unwritten || d->c_needs_zero;
 }
 
 struct ocfs2_write_ctxt {
@@ -934,6 +935,8 @@ struct ocfs2_write_ctxt {
 	u32				w_cpos;
 	u32				w_clen;
 
+	u32				w_first_new_cpos;
+
 	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
 
 	/*
@@ -1011,6 +1014,7 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 		return -ENOMEM;
 
 	wc->w_cpos = pos >> osb->s_clustersize_bits;
+	wc->w_first_new_cpos = UINT_MAX;
 	cend = (pos + len - 1) >> osb->s_clustersize_bits;
 	wc->w_clen = cend - wc->w_cpos + 1;
 	get_bh(di_bh);
@@ -1248,6 +1252,7 @@ out:
  */
 static int ocfs2_write_cluster(struct address_space *mapping,
 			       u32 phys, unsigned int unwritten,
+			       unsigned int zero_it,
 			       struct ocfs2_alloc_context *data_ac,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct ocfs2_write_ctxt *wc, u32 cpos,
@@ -1258,7 +1263,7 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 
 	new = phys == 0 ? 1 : 0;
-	if (new || unwritten)
+	if (new || unwritten || zero_it)
 		should_zero = 1;
 
 	if (new) {
@@ -1370,7 +1375,9 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
 			local_len = osb->s_clustersize - cluster_off;
 
 		ret = ocfs2_write_cluster(mapping, desc->c_phys,
-					  desc->c_unwritten, data_ac, meta_ac,
+					  desc->c_unwritten,
+					  desc->c_needs_zero,
+					  data_ac, meta_ac,
 					  wc, desc->c_cpos, pos, local_len);
 		if (ret) {
 			mlog_errno(ret);
@@ -1495,6 +1502,12 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 			phys++;
 		}
 
+		desc->c_needs_zero = 0;
+		if (desc->c_cpos == wc->w_first_new_cpos) {
+			BUG_ON(phys == 0);
+			desc->c_needs_zero = 1;
+		}
+
 		desc->c_phys = phys;
 		if (phys == 0) {
 			desc->c_new = 1;
@@ -1506,6 +1519,20 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 		num_clusters--;
 	}
 
+	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)
+		wc->w_desc[wc->w_clen - 1].c_needs_zero = 1;
+
+	mlog(0, "inode %llu, wc 0x%p, cpos %lu, clen %lu, fcpos %lu\n",
+	     OCFS2_I(inode)->ip_blkno, wc, wc->w_cpos, wc->w_clen,
+	     wc->w_first_new_cpos);
+
+        for (i = 0; i < wc->w_clen; i++) {
+		desc = &wc->w_desc[i];
+		mlog(0, ("%d => cpos %lu, phys %lu, new %u, unw %u, zero %u\n",
+			 i, desc->c_cpos, desc->c_phys, desc->c_new,
+			 desc->c_unwritten, desc->c_needs_zero);
+	}
+
 	ret = 0;
 out:
 	return ret;
@@ -1658,10 +1685,13 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
 	if (newsize <= i_size_read(inode))
 		return 0;
 
-	ret = ocfs2_extend_no_holes(inode, newsize, newsize - len);
+	ret = ocfs2_extend_no_holes(inode, newsize, pos);
 	if (ret)
 		mlog_errno(ret);
 
+	wc->w_first_new_cpos =
+		ocfs2_align_bytes_to_clusters(inode->i_sb, i_size_read(inode));
+
 	return ret;
 }
 
-- 
1.6.0.4
