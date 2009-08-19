From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 19 Aug 2009 12:54:38 -0700
Subject: [Ocfs2-devel] [PATCH 13/14] ocfs2: Set xattr block entries with
	ocfs2_xa_set()
In-Reply-To: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1250711679-12441-14-git-send-email-joel.becker@oracle.com>
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

While we're there, ocfs2_xattr_block_set() is kind of busy.  Split the
creation of a new xattr block to ocfs2_xattr_block_new().  Now
ocfs2_xattr_block_set() is quite the readable function.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  157 +++++++++++++++++++++++++++++++-----------------------
 1 files changed, 90 insertions(+), 67 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f0205e6..0dd691f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2098,10 +2098,8 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	int ret;
 	struct ocfs2_xa_loc loc;
 
-	if (!(flag & OCFS2_INLINE_XATTR_FL))
-		BUG_ON(xs->xattr_bh == xs->inode_bh);
-	else
-		BUG_ON(xs->xattr_bh != xs->inode_bh);
+	BUG_ON(!(flag & OCFS2_INLINE_XATTR_FL));
+	BUG_ON(xs->xattr_bh != xs->inode_bh);
 
 	ret = ocfs2_journal_access_di(handle, inode, xs->inode_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -2110,13 +2108,8 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
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
@@ -2125,8 +2118,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	}
 	xs->here = loc.xl_entry;
 
-	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) &&
-	    (flag & OCFS2_INLINE_XATTR_FL)) {
+	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
 		struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 		unsigned int xattrsize = osb->s_xattr_inline_size;
 
@@ -2146,7 +2138,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	}
 	/* Update xattr flag */
 	spin_lock(&oi->ip_lock);
-	oi->ip_dyn_features |= flag;
+	oi->ip_dyn_features |= OCFS2_INLINE_XATTR_FL;
 	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
 	spin_unlock(&oi->ip_lock);
 
@@ -2541,6 +2533,72 @@ cleanup:
 	return ret;
 }
 
+static int ocfs2_xattr_block_new(struct inode *inode,
+				 struct buffer_head *di_bh,
+				 struct ocfs2_xattr_set_ctxt *ctxt,
+				 struct buffer_head **xb_bh)
+{
+	int ret;
+	struct buffer_head *new_bh = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	u16 suballoc_bit_start;
+	u32 num_got;
+	u64 first_blkno;
+	struct ocfs2_xattr_block *xb;
+
+	ret = ocfs2_journal_access_di(ctxt->handle, inode, di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto end;
+	}
+
+	ret = ocfs2_claim_metadata(osb, ctxt->handle, ctxt->meta_ac, 1,
+				   &suballoc_bit_start, &num_got,
+				   &first_blkno);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto end;
+	}
+
+	new_bh = sb_getblk(inode->i_sb, first_blkno);
+	ocfs2_set_new_buffer_uptodate(inode, new_bh);
+	ret = ocfs2_journal_access_xb(ctxt->handle, inode, new_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto end;
+	}
+
+	/* Initialize ocfs2_xattr_block */
+	xb = (struct ocfs2_xattr_block *)new_bh->b_data;
+	memset(xb, 0, inode->i_sb->s_blocksize);
+	strcpy((void *)xb, OCFS2_XATTR_BLOCK_SIGNATURE);
+	xb->xb_suballoc_slot = cpu_to_le16(osb->slot_num);
+	xb->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
+	xb->xb_fs_generation = cpu_to_le32(osb->fs_generation);
+	xb->xb_blkno = cpu_to_le64(first_blkno);
+	ocfs2_journal_dirty(ctxt->handle, new_bh);
+
+	/* Add it to the inode */
+	di->i_xattr_loc = cpu_to_le64(first_blkno);
+
+	spin_lock(&OCFS2_I(inode)->ip_lock);
+	OCFS2_I(inode)->ip_dyn_features |= OCFS2_HAS_XATTR_FL;
+	di->i_dyn_features = cpu_to_le16(OCFS2_I(inode)->ip_dyn_features);
+	spin_unlock(&OCFS2_I(inode)->ip_lock);
+
+	ocfs2_journal_dirty(ctxt->handle, di_bh);
+
+	*xb_bh = new_bh;
+	new_bh = NULL;
+
+end:
+	brelse(new_bh);
+	return ret;
+}
+
 /*
  * ocfs2_xattr_block_set()
  *
@@ -2553,82 +2611,47 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 				 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct buffer_head *new_bh = NULL;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)xs->inode_bh->b_data;
-	handle_t *handle = ctxt->handle;
 	struct ocfs2_xattr_block *xblk = NULL;
-	u16 suballoc_bit_start;
-	u32 num_got;
-	u64 first_blkno;
 	int ret;
+	struct ocfs2_xa_loc loc;
 
 	if (!xs->xattr_bh) {
-		ret = ocfs2_journal_access_di(handle, inode, xs->inode_bh,
-					      OCFS2_JOURNAL_ACCESS_CREATE);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto end;
-		}
-
-		ret = ocfs2_claim_metadata(osb, handle, ctxt->meta_ac, 1,
-					   &suballoc_bit_start, &num_got,
-					   &first_blkno);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto end;
-		}
-
-		new_bh = sb_getblk(inode->i_sb, first_blkno);
-		ocfs2_set_new_buffer_uptodate(inode, new_bh);
-
-		ret = ocfs2_journal_access_xb(handle, inode, new_bh,
-					      OCFS2_JOURNAL_ACCESS_CREATE);
-		if (ret < 0) {
+		ret = ocfs2_xattr_block_new(inode, xs->inode_bh, ctxt,
+					    &new_bh);
+		if (ret) {
 			mlog_errno(ret);
 			goto end;
 		}
 
-		/* Initialize ocfs2_xattr_block */
 		xs->xattr_bh = new_bh;
-		xblk = (struct ocfs2_xattr_block *)new_bh->b_data;
-		memset(xblk, 0, inode->i_sb->s_blocksize);
-		strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
-		xblk->xb_suballoc_slot = cpu_to_le16(osb->slot_num);
-		xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
-		xblk->xb_fs_generation = cpu_to_le32(osb->fs_generation);
-		xblk->xb_blkno = cpu_to_le64(first_blkno);
-
+		xblk = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
 		xs->header = &xblk->xb_attrs.xb_header;
 		xs->base = (void *)xs->header;
 		xs->end = (void *)xblk + inode->i_sb->s_blocksize;
 		xs->here = xs->header->xh_entries;
-
-		ret = ocfs2_journal_dirty(handle, new_bh);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto end;
-		}
-		di->i_xattr_loc = cpu_to_le64(first_blkno);
-		ocfs2_journal_dirty(handle, xs->inode_bh);
 	} else
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
 
-- 
1.6.3.3
