From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 28 Aug 2009 01:36:02 -0700
Subject: [Ocfs2-devel] [PATCH 13/14] ocfs2: Set xattr block entries with
	ocfs2_xa_set()
In-Reply-To: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1251448563-12508-14-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_xattr_block_set() calls into ocfs2_xattr_set_entry() with just the
HAS_XATTR flag.  Most of the machinery of ocfs2_xattr_set_entry() is
skipped.  All that really happens other than the call to ocfs2_xa_set()
is making sure the HAS_XATTR flag is set on the inode.

But HAS_XATTR should be set when we also set di->i_xattr_loc.  And
that's done in ocfs2_xattr_block_set().  So let's move it there, and
then ocfs2_xattr_block_set() can just call ocfs2_xa_set().

While we're there, ocfs2_create_xattr_block() can take the set_ctxt for
a smaller argument list.  It also learns to set HAS_XATTR_FL, because it
knows for sure.  ocfs2_create_empty_xatttr_block() in the reflink path
fakes a set_ctxt to call ocfs2_create_xattr_block().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   97 ++++++++++++++++++++++++++---------------------------
 1 files changed, 48 insertions(+), 49 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e400d64..862c56d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2157,10 +2157,8 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	int ret;
 	struct ocfs2_xa_loc loc;
 
-	if (!(flag & OCFS2_INLINE_XATTR_FL))
-		BUG_ON(xs->xattr_bh == xs->inode_bh);
-	else
-		BUG_ON(xs->xattr_bh != xs->inode_bh);
+	BUG_ON(!(flag & OCFS2_INLINE_XATTR_FL));
+	BUG_ON(xs->xattr_bh != xs->inode_bh);
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), xs->inode_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -2169,13 +2167,8 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		goto out;
 	}
 
-	if (xs->xattr_bh == xs->inode_bh)
-		ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
-					 xs->not_found ? NULL : xs->here);
-	else
-		ocfs2_init_xattr_block_xa_loc(&loc, inode, xs->xattr_bh,
-					      xs->not_found ? NULL : xs->here);
-
+	ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
+				 xs->not_found ? NULL : xs->here);
 	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (ret) {
 		if (ret != -ENOSPC)
@@ -2184,8 +2177,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	}
 	xs->here = loc.xl_entry;
 
-	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) &&
-	    (flag & OCFS2_INLINE_XATTR_FL)) {
+	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
 		struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 		unsigned int xattrsize = osb->s_xattr_inline_size;
 
@@ -2205,7 +2197,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	}
 	/* Update xattr flag */
 	spin_lock(&oi->ip_lock);
-	oi->ip_dyn_features |= flag;
+	oi->ip_dyn_features |= OCFS2_INLINE_XATTR_FL;
 	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
 	spin_unlock(&oi->ip_lock);
 
@@ -2699,12 +2691,11 @@ cleanup:
 	return ret;
 }
 
-static int ocfs2_create_xattr_block(handle_t *handle,
-				    struct inode *inode,
+static int ocfs2_create_xattr_block(struct inode *inode,
 				    struct buffer_head *inode_bh,
-				    struct ocfs2_alloc_context *meta_ac,
-				    struct buffer_head **ret_bh,
-				    int indexed)
+				    struct ocfs2_xattr_set_ctxt *ctxt,
+				    int indexed,
+				    struct buffer_head **ret_bh)
 {
 	int ret;
 	u16 suballoc_bit_start;
@@ -2715,14 +2706,14 @@ static int ocfs2_create_xattr_block(handle_t *handle,
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_xattr_block *xblk;
 
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), inode_bh,
-				      OCFS2_JOURNAL_ACCESS_CREATE);
+	ret = ocfs2_journal_access_di(ctxt->handle, INODE_CACHE(inode),
+				      inode_bh, OCFS2_JOURNAL_ACCESS_CREATE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto end;
 	}
 
-	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1,
+	ret = ocfs2_claim_metadata(osb, ctxt->handle, ctxt->meta_ac, 1,
 				   &suballoc_bit_start, &num_got,
 				   &first_blkno);
 	if (ret < 0) {
@@ -2733,7 +2724,7 @@ static int ocfs2_create_xattr_block(handle_t *handle,
 	new_bh = sb_getblk(inode->i_sb, first_blkno);
 	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
 
-	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode),
+	ret = ocfs2_journal_access_xb(ctxt->handle, INODE_CACHE(inode),
 				      new_bh,
 				      OCFS2_JOURNAL_ACCESS_CREATE);
 	if (ret < 0) {
@@ -2749,7 +2740,6 @@ static int ocfs2_create_xattr_block(handle_t *handle,
 	xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
 	xblk->xb_fs_generation = cpu_to_le32(osb->fs_generation);
 	xblk->xb_blkno = cpu_to_le64(first_blkno);
-
 	if (indexed) {
 		struct ocfs2_xattr_tree_root *xr = &xblk->xb_attrs.xb_root;
 		xr->xt_clusters = cpu_to_le32(1);
@@ -2760,14 +2750,17 @@ static int ocfs2_create_xattr_block(handle_t *handle,
 		xr->xt_list.l_next_free_rec = cpu_to_le16(1);
 		xblk->xb_flags = cpu_to_le16(OCFS2_XATTR_INDEXED);
 	}
+	ocfs2_journal_dirty(ctxt->handle, new_bh);
 
-	ret = ocfs2_journal_dirty(handle, new_bh);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto end;
-	}
+	/* Add it to the inode */
 	di->i_xattr_loc = cpu_to_le64(first_blkno);
-	ocfs2_journal_dirty(handle, inode_bh);
+
+	spin_lock(&OCFS2_I(inode)->ip_lock);
+	OCFS2_I(inode)->ip_dyn_features |= OCFS2_HAS_XATTR_FL;
+	di->i_dyn_features = cpu_to_le16(OCFS2_I(inode)->ip_dyn_features);
+	spin_unlock(&OCFS2_I(inode)->ip_lock);
+
+	ocfs2_journal_dirty(ctxt->handle, inode_bh);
 
 	*ret_bh = new_bh;
 	new_bh = NULL;
@@ -2789,13 +2782,13 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 				 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct buffer_head *new_bh = NULL;
-	handle_t *handle = ctxt->handle;
 	struct ocfs2_xattr_block *xblk = NULL;
 	int ret;
+	struct ocfs2_xa_loc loc;
 
 	if (!xs->xattr_bh) {
-		ret = ocfs2_create_xattr_block(handle, inode, xs->inode_bh,
-					       ctxt->meta_ac, &new_bh, 0);
+		ret = ocfs2_create_xattr_block(inode, xs->inode_bh, ctxt,
+					       0, &new_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto end;
@@ -2811,21 +2804,25 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		xblk = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
 
 	if (!(le16_to_cpu(xblk->xb_flags) & OCFS2_XATTR_INDEXED)) {
-		/* Set extended attribute into external block */
-		ret = ocfs2_xattr_set_entry(inode, xi, xs, ctxt,
-					    OCFS2_HAS_XATTR_FL);
-		if (!ret || ret != -ENOSPC)
-			goto end;
+		ocfs2_init_xattr_block_xa_loc(&loc, inode, xs->xattr_bh,
+					      xs->not_found ? NULL : xs->here);
 
-		ret = ocfs2_xattr_create_index_block(inode, xs, ctxt);
-		if (ret)
+		ret = ocfs2_xa_set(&loc, xi, ctxt);
+		if (!ret)
+			xs->here = loc.xl_entry;
+		else if (ret != -ENOSPC)
 			goto end;
+		else {
+			ret = ocfs2_xattr_create_index_block(inode, xs, ctxt);
+			if (ret)
+				goto end;
+		}
 	}
 
-	ret = ocfs2_xattr_set_entry_index_block(inode, xi, xs, ctxt);
+	if (le16_to_cpu(xblk->xb_flags) & OCFS2_XATTR_INDEXED)
+		ret = ocfs2_xattr_set_entry_index_block(inode, xi, xs, ctxt);
 
 end:
-
 	return ret;
 }
 
@@ -6366,9 +6363,11 @@ static int ocfs2_create_empty_xattr_block(struct inode *inode,
 					  int indexed)
 {
 	int ret;
-	handle_t *handle;
 	struct ocfs2_alloc_context *meta_ac;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_xattr_set_ctxt ctxt = {
+		.meta_ac = meta_ac,
+	};
 
 	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
 	if (ret < 0) {
@@ -6376,21 +6375,21 @@ static int ocfs2_create_empty_xattr_block(struct inode *inode,
 		return ret;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_XATTR_BLOCK_CREATE_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
+	ctxt.handle = ocfs2_start_trans(osb, OCFS2_XATTR_BLOCK_CREATE_CREDITS);
+	if (IS_ERR(ctxt.handle)) {
+		ret = PTR_ERR(ctxt.handle);
 		mlog_errno(ret);
 		goto out;
 	}
 
 	mlog(0, "create new xattr block for inode %llu, index = %d\n",
 	     (unsigned long long)fe_bh->b_blocknr, indexed);
-	ret = ocfs2_create_xattr_block(handle, inode, fe_bh,
-				       meta_ac, ret_bh, indexed);
+	ret = ocfs2_create_xattr_block(inode, fe_bh, &ctxt, indexed,
+				       ret_bh);
 	if (ret)
 		mlog_errno(ret);
 
-	ocfs2_commit_trans(osb, handle);
+	ocfs2_commit_trans(osb, ctxt.handle);
 out:
 	ocfs2_free_alloc_context(meta_ac);
 	return ret;
-- 
1.6.3.3
