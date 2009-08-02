From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 2 Aug 2009 15:05:24 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Initialize the cluster we're
 writing to in a non-sparse extend
In-Reply-To: <1249243450-16209-2-git-send-email-sunil.mushran@oracle.com>
References: <1249243450-16209-1-git-send-email-sunil.mushran@oracle.com>
	<1249243450-16209-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090802220524.GB27037@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Aug 02, 2009 at 01:04:10PM -0700, Sunil Mushran wrote:
> In a non-sparse extend, we correctly allocate (and zero) the clusters between
> the old_i_size and pos, but we don't zero the portions of the cluster we're
> writing to outside of pos<->len.

	I'd do it more like this.  Rather than have magic based on
c_new, c_unwritten, and c_needs_zero_but_is_only_set_for_nonsparse,
let's set c_needs_zero for all types that need zeroing.  Then we can
just trust c_needs_zero everywhere.  I saw your attempt at optimization,
setting c_needs_zero on only the first and last cluster of a non-sparse
write, but it's not necessary.  ocfs2_write_cluster() will figure out
that user_pos and user_len cover the entire cluster.

Joel

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index e511df1..8b853e5 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -893,20 +893,18 @@ struct ocfs2_write_cluster_desc {
 	 * Give this a unique field because c_phys eventually gets
 	 * filled.
 	 */
-	unsigned	c_new;
-	unsigned	c_unwritten;
+	unsigned	c_new;		/* needs to be allocated */
+	unsigned	c_unwritten;	/* unwritten extent */
+	unsigned	c_needs_zero;	/* nonsparse allocation */
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
 
+	u32				w_first_new_cpos;
+
 	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
 
 	/*
@@ -984,6 +982,7 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 		return -ENOMEM;
 
 	wc->w_cpos = pos >> osb->s_clustersize_bits;
+	wc->w_first_new_cpos = UINT_MAX;
 	cend = (pos + len - 1) >> osb->s_clustersize_bits;
 	wc->w_clen = cend - wc->w_cpos + 1;
 	get_bh(di_bh);
@@ -1218,19 +1217,18 @@ out:
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
 	struct ocfs2_extent_tree et;
 
 	new = phys == 0 ? 1 : 0;
-	if (new || unwritten)
-		should_zero = 1;
 
 	if (new) {
 		u32 tmp_pos;
@@ -1342,7 +1340,9 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
 			local_len = osb->s_clustersize - cluster_off;
 
 		ret = ocfs2_write_cluster(mapping, desc->c_phys,
-					  desc->c_unwritten, data_ac, meta_ac,
+					  desc->c_unwritten,
+					  desc->c_needs_zero,
+					  data_ac, meta_ac,
 					  wc, desc->c_cpos, pos, local_len);
 		if (ret) {
 			mlog_errno(ret);
@@ -1392,14 +1392,14 @@ static void ocfs2_set_target_boundaries(struct ocfs2_super *osb,
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
@@ -1467,17 +1467,41 @@ static int ocfs2_populate_write_desc(struct inode *inode,
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
@@ -1633,10 +1657,13 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
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

#!/bin/perl -sp0777i<X+d*lMLa^*lN%0]dsXx++lMlN/dsM0<j]dsj
$/=unpack('H*',$_);$_=`echo 16dio\U$k"SK$/SM$n\EsN0p[lN*1
lK[d2%Sa2/d0$^Ixp"|dc`;s/\W//g;$_=pack('H*',/((..)*)$/)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
