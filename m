From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 28 Aug 2009 01:36:03 -0700
Subject: [Ocfs2-devel] [PATCH 14/14] ocfs2: Set inline xattr entries with
	ocfs2_xa_set()
In-Reply-To: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1251448563-12508-15-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_xattr_ibody_set() is the only remaining user of
ocfs2_xattr_set_entry().  ocfs2_xattr_set_entry() actually does two
things: it calls ocfs2_xa_set(), and it initializes the inline xattrs.
Initializing the inline space really belongs in its own call.

We lift the initialization to ocfs2_xattr_ibody_init(), called from
ocfs2_xattr_ibody_set() only when necessary.  Now
ocfs2_xattr_ibody_set() can call ocfs2_xa_set() directly.
ocfs2_xattr_set_entry() goes away.

Another nice fact is that ocfs2_init_dinode_xa_loc() can trust
i_xattr_inline_size.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  156 +++++++++++++++++++++++++-----------------------------
 1 files changed, 72 insertions(+), 84 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 862c56d..d485932 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2088,17 +2088,13 @@ static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 
+	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_XATTR_FL));
+
 	loc->xl_inode = inode;
 	loc->xl_ops = &ocfs2_xa_block_loc_ops;
 	loc->xl_storage = bh;
 	loc->xl_entry = entry;
-
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_XATTR_FL)
-		loc->xl_size = le16_to_cpu(di->i_xattr_inline_size);
-	else {
-		BUG_ON(entry);
-		loc->xl_size = OCFS2_SB(inode->i_sb)->s_xattr_inline_size;
-	}
+	loc->xl_size = le16_to_cpu(di->i_xattr_inline_size);
 	loc->xl_header =
 		(struct ocfs2_xattr_header *)(bh->b_data + bh->b_size -
 					      loc->xl_size);
@@ -2135,80 +2131,6 @@ static void ocfs2_init_xattr_bucket_xa_loc(struct ocfs2_xa_loc *loc,
 	loc->xl_size = OCFS2_XATTR_BUCKET_SIZE;
 }
 
-
-/*
- * ocfs2_xattr_set_entry()
- *
- * Set extended attribute entry into inode or block.
- *
- * If extended attribute value size > OCFS2_XATTR_INLINE_SIZE,
- * We first insert tree root(ocfs2_xattr_value_root) like a normal value,
- * then set value in B tree with set_value_outside().
- */
-static int ocfs2_xattr_set_entry(struct inode *inode,
-				 struct ocfs2_xattr_info *xi,
-				 struct ocfs2_xattr_search *xs,
-				 struct ocfs2_xattr_set_ctxt *ctxt,
-				 int flag)
-{
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
-	handle_t *handle = ctxt->handle;
-	int ret;
-	struct ocfs2_xa_loc loc;
-
-	BUG_ON(!(flag & OCFS2_INLINE_XATTR_FL));
-	BUG_ON(xs->xattr_bh != xs->inode_bh);
-
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), xs->inode_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
-				 xs->not_found ? NULL : xs->here);
-	ret = ocfs2_xa_set(&loc, xi, ctxt);
-	if (ret) {
-		if (ret != -ENOSPC)
-			mlog_errno(ret);
-		goto out;
-	}
-	xs->here = loc.xl_entry;
-
-	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
-		struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-		unsigned int xattrsize = osb->s_xattr_inline_size;
-
-		/*
-		 * Adjust extent record count or inline data size
-		 * to reserve space for extended attribute.
-		 */
-		if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
-			struct ocfs2_inline_data *idata = &di->id2.i_data;
-			le16_add_cpu(&idata->id_count, -xattrsize);
-		} else if (!(ocfs2_inode_is_fast_symlink(inode))) {
-			struct ocfs2_extent_list *el = &di->id2.i_list;
-			le16_add_cpu(&el->l_count, -(xattrsize /
-					sizeof(struct ocfs2_extent_rec)));
-		}
-		di->i_xattr_inline_size = cpu_to_le16(xattrsize);
-	}
-	/* Update xattr flag */
-	spin_lock(&oi->ip_lock);
-	oi->ip_dyn_features |= OCFS2_INLINE_XATTR_FL;
-	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
-	spin_unlock(&oi->ip_lock);
-
-	ret = ocfs2_journal_dirty(handle, xs->inode_bh);
-	if (ret < 0)
-		mlog_errno(ret);
-
-out:
-	return ret;
-}
-
 /*
  * In xattr remove, if it is stored outside and refcounted, we may have
  * the chance to split the refcount tree. So need the allocators.
@@ -2604,6 +2526,55 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
 	return 0;
 }
 
+static int ocfs2_xattr_ibody_init(struct inode *inode,
+				  struct buffer_head *di_bh,
+				  struct ocfs2_xattr_set_ctxt *ctxt)
+{
+	int ret;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	unsigned int xattrsize = osb->s_xattr_inline_size;
+
+	if (!ocfs2_xattr_has_space_inline(inode, di)) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_di(ctxt->handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * Adjust extent record count or inline data size
+	 * to reserve space for extended attribute.
+	 */
+	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		struct ocfs2_inline_data *idata = &di->id2.i_data;
+		le16_add_cpu(&idata->id_count, -xattrsize);
+	} else if (!(ocfs2_inode_is_fast_symlink(inode))) {
+		struct ocfs2_extent_list *el = &di->id2.i_list;
+		le16_add_cpu(&el->l_count, -(xattrsize /
+					     sizeof(struct ocfs2_extent_rec)));
+	}
+	di->i_xattr_inline_size = cpu_to_le16(xattrsize);
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features |= OCFS2_INLINE_XATTR_FL|OCFS2_HAS_XATTR_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	spin_unlock(&oi->ip_lock);
+
+	ret = ocfs2_journal_dirty(ctxt->handle, di_bh);
+	if (ret < 0)
+		mlog_errno(ret);
+
+out:
+	return ret;
+}
+
 /*
  * ocfs2_xattr_ibody_set()
  *
@@ -2615,9 +2586,10 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 				 struct ocfs2_xattr_search *xs,
 				 struct ocfs2_xattr_set_ctxt *ctxt)
 {
+	int ret;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
-	int ret;
+	struct ocfs2_xa_loc loc;
 
 	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
 		return -ENOSPC;
@@ -2630,8 +2602,24 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_xattr_set_entry(inode, xi, xs, ctxt,
-				(OCFS2_INLINE_XATTR_FL | OCFS2_HAS_XATTR_FL));
+	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
+		ret = ocfs2_xattr_ibody_init(inode, xs->inode_bh, ctxt);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
+				 xs->not_found ? NULL : xs->here);
+	ret = ocfs2_xa_set(&loc, xi, ctxt);
+	if (ret) {
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
+		goto out;
+	}
+	xs->here = loc.xl_entry;
+
 out:
 	up_write(&oi->ip_alloc_sem);
 
-- 
1.6.3.3
