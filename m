From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 19 Aug 2009 12:54:34 -0700
Subject: [Ocfs2-devel] [PATCH 09/14] ocfs2: Teach ocfs2_xa_loc how to do its
	own journal work
In-Reply-To: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1250711679-12441-10-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We're going to want to make sure our buffers get accessed and dirtied
correctly.  So have the xa_loc do the work.  This includes storing the
inode on ocfs2_xa_loc.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  115 ++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 86 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b867aa0..7c8edbe 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -145,6 +145,13 @@ struct ocfs2_xattr_search {
 struct ocfs2_xa_loc;
 struct ocfs2_xa_loc_operations {
 	/*
+	 * Journal functions
+	 */
+	int (*xlo_journal_access)(handle_t *handle, struct ocfs2_xa_loc *loc,
+				  int type);
+	void (*xlo_journal_dirty)(handle_t *handle, struct ocfs2_xa_loc *loc);
+
+	/*
 	 * Return a pointer to the appropriate buffer in loc->xl_storage
 	 * at the given offset from loc->xl_header.
 	 */
@@ -189,6 +196,9 @@ struct ocfs2_xa_loc_operations {
  * tracking the on-disk structure.
  */
 struct ocfs2_xa_loc {
+	/* This xattr belongs to this inode */
+	struct inode *xl_inode;
+
 	/* The ocfs2_xattr_header inside the on-disk storage. Not NULL. */
 	struct ocfs2_xattr_header *xl_header;
 
@@ -1483,6 +1493,17 @@ static int ocfs2_xa_has_space_helper(int needed_space, int free_start,
 	return 0;
 }
 
+static int ocfs2_xa_journal_access(handle_t *handle, struct ocfs2_xa_loc *loc,
+				   int type)
+{
+	return loc->xl_ops->xlo_journal_access(handle, loc, type);
+}
+
+static void ocfs2_xa_journal_dirty(handle_t *handle, struct ocfs2_xa_loc *loc)
+{
+	loc->xl_ops->xlo_journal_dirty(handle, loc);
+}
+
 /* Give a pointer into the storage for the given offset */
 static void *ocfs2_xa_offset_pointer(struct ocfs2_xa_loc *loc, int offset)
 {
@@ -1570,6 +1591,29 @@ static void ocfs2_xa_fill_value_buf(struct ocfs2_xa_loc *loc,
 							name_size);
 }
 
+static int ocfs2_xa_block_journal_access(handle_t *handle,
+					 struct ocfs2_xa_loc *loc, int type)
+{
+	struct buffer_head *bh = loc->xl_storage;
+	ocfs2_journal_access_func access;
+
+	if (loc->xl_size == (bh->b_size -
+			     offsetof(struct ocfs2_xattr_block,
+				      xb_attrs.xb_header)))
+		access = ocfs2_journal_access_xb;
+	else
+		access = ocfs2_journal_access_di;
+	return access(handle, loc->xl_inode, bh, type);
+}
+
+static void ocfs2_xa_block_journal_dirty(handle_t *handle,
+					 struct ocfs2_xa_loc *loc)
+{
+	struct buffer_head *bh = loc->xl_storage;
+
+	ocfs2_journal_dirty(handle, bh);
+}
+
 static void *ocfs2_xa_block_offset_pointer(struct ocfs2_xa_loc *loc,
 					   int offset)
 {
@@ -1699,6 +1743,8 @@ static void ocfs2_xa_block_fill_value_buf(struct ocfs2_xa_loc *loc,
  * storage and unindexed ocfs2_xattr_blocks.
  */
 static const struct ocfs2_xa_loc_operations ocfs2_xa_block_loc_ops = {
+	.xlo_journal_access	= ocfs2_xa_block_journal_access,
+	.xlo_journal_dirty	= ocfs2_xa_block_journal_dirty,
 	.xlo_offset_pointer	= ocfs2_xa_block_offset_pointer,
 	.xlo_has_space		= ocfs2_xa_block_has_space,
 	.xlo_can_reuse		= ocfs2_xa_block_can_reuse,
@@ -1709,6 +1755,22 @@ static const struct ocfs2_xa_loc_operations ocfs2_xa_block_loc_ops = {
 	.xlo_fill_value_buf	= ocfs2_xa_block_fill_value_buf,
 };
 
+static int ocfs2_xa_bucket_journal_access(handle_t *handle,
+					  struct ocfs2_xa_loc *loc, int type)
+{
+	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
+
+	return ocfs2_xattr_bucket_journal_access(handle, bucket, type);
+}
+
+static void ocfs2_xa_bucket_journal_dirty(handle_t *handle,
+					  struct ocfs2_xa_loc *loc)
+{
+	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
+
+	ocfs2_xattr_bucket_journal_dirty(handle, bucket);
+}
+
 static void *ocfs2_xa_bucket_offset_pointer(struct ocfs2_xa_loc *loc,
 					    int offset)
 {
@@ -1717,8 +1779,8 @@ static void *ocfs2_xa_bucket_offset_pointer(struct ocfs2_xa_loc *loc,
 
 	BUG_ON(offset >= OCFS2_XATTR_BUCKET_SIZE);
 
-	block = offset >> bucket->bu_inode->i_sb->s_blocksize_bits;
-	block_offset = offset % bucket->bu_inode->i_sb->s_blocksize;
+	block = offset >> loc->xl_inode->i_sb->s_blocksize_bits;
+	block_offset = offset % loc->xl_inode->i_sb->s_blocksize;
 
 	return bucket_block(bucket, block) + block_offset;
 }
@@ -1757,8 +1819,7 @@ static int ocfs2_xa_bucket_has_space(struct ocfs2_xa_loc *loc,
 	int free_start = ocfs2_xa_get_free_start(loc);
 	int needed_space = ocfs2_xi_entry_usage(xi);
 	int size = namevalue_size_xi(xi);
-	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
-	struct super_block *sb = bucket->bu_inode->i_sb;
+	struct super_block *sb = loc->xl_inode->i_sb;
 
 	/*
 	 * Bucket storage does not reclaim name+value pairs it cannot
@@ -1824,8 +1885,7 @@ static void ocfs2_xa_bucket_add_namevalue(struct ocfs2_xa_loc *loc, int size)
 {
 	int free_start = ocfs2_xa_get_free_start(loc);
 	struct ocfs2_xattr_header *xh = loc->xl_header;
-	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
-	struct super_block *sb = bucket->bu_inode->i_sb;
+	struct super_block *sb = loc->xl_inode->i_sb;
 	int nameval_offset;
 
 	free_start = ocfs2_bucket_align_free_start(sb, free_start, size);
@@ -1840,7 +1900,7 @@ static void ocfs2_xa_bucket_fill_value_buf(struct ocfs2_xa_loc *loc,
 					   struct ocfs2_xattr_value_buf *vb)
 {
 	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
-	struct super_block *sb = bucket->bu_inode->i_sb;
+	struct super_block *sb = loc->xl_inode->i_sb;
 	int nameval_offset = le16_to_cpu(loc->xl_entry->xe_name_offset);
 	int size = namevalue_size_xe(loc->xl_entry);
 	int block_offset = nameval_offset >> sb->s_blocksize_bits;
@@ -1857,6 +1917,8 @@ static void ocfs2_xa_bucket_fill_value_buf(struct ocfs2_xa_loc *loc,
 
 /* Operations for xattrs stored in buckets. */
 static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
+	.xlo_journal_access	= ocfs2_xa_bucket_journal_access,
+	.xlo_journal_dirty	= ocfs2_xa_bucket_journal_dirty,
 	.xlo_offset_pointer	= ocfs2_xa_bucket_offset_pointer,
 	.xlo_has_space		= ocfs2_xa_bucket_has_space,
 	.xlo_can_reuse		= ocfs2_xa_bucket_can_reuse,
@@ -1973,6 +2035,7 @@ static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 
+	loc->xl_inode = inode;
 	loc->xl_ops = &ocfs2_xa_block_loc_ops;
 	loc->xl_storage = bh;
 	loc->xl_entry = entry;
@@ -1989,6 +2052,7 @@ static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
 }
 
 static void ocfs2_init_xattr_block_xa_loc(struct ocfs2_xa_loc *loc,
+					  struct inode *inode,
 					  struct buffer_head *bh,
 					  struct ocfs2_xattr_entry *entry)
 {
@@ -1997,6 +2061,7 @@ static void ocfs2_init_xattr_block_xa_loc(struct ocfs2_xa_loc *loc,
 
 	BUG_ON(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED);
 
+	loc->xl_inode = inode;
 	loc->xl_ops = &ocfs2_xa_block_loc_ops;
 	loc->xl_storage = bh;
 	loc->xl_header = &(xb->xb_attrs.xb_header);
@@ -2009,6 +2074,7 @@ static void ocfs2_init_xattr_bucket_xa_loc(struct ocfs2_xa_loc *loc,
 					   struct ocfs2_xattr_bucket *bucket,
 					   struct ocfs2_xattr_entry *entry)
 {
+	loc->xl_inode = bucket->bu_inode;
 	loc->xl_ops = &ocfs2_xa_bucket_loc_ops;
 	loc->xl_storage = bucket;
 	loc->xl_header = bucket_xh(bucket);
@@ -2150,21 +2216,18 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		goto out;
 	}
 
-	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
-		ret = vb.vb_access(handle, inode, vb.vb_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
-
 	if (xs->xattr_bh == xs->inode_bh)
 		ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
 					 xs->not_found ? NULL : xs->here);
 	else
-		ocfs2_init_xattr_block_xa_loc(&loc, xs->xattr_bh,
+		ocfs2_init_xattr_block_xa_loc(&loc, inode, xs->xattr_bh,
 					      xs->not_found ? NULL : xs->here);
+	ret = ocfs2_xa_journal_access(handle, &loc,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
 	/*
 	 * Prepare our entry and insert the inline value.  This will
@@ -2182,13 +2245,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	ocfs2_xa_store_inline_value(&loc, xi);
 	xs->here = loc.xl_entry;
 
-	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
-		ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
+	ocfs2_xa_journal_dirty(handle, &loc);
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) &&
 	    (flag & OCFS2_INLINE_XATTR_FL)) {
@@ -5061,15 +5118,15 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_xattr_bucket_journal_access(handle, xs->bucket,
-						OCFS2_JOURNAL_ACCESS_WRITE);
+	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
+				       xs->not_found ? NULL : xs->here);
+	ret = ocfs2_xa_journal_access(handle, &loc,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
-				       xs->not_found ? NULL : xs->here);
 	ret = ocfs2_xa_prepare_entry(&loc, xi, name_hash);
 	if (ret) {
 		if (ret != -ENOSPC)
@@ -5081,7 +5138,7 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 	ocfs2_xa_store_inline_value(&loc, xi);
 	xs->here = loc.xl_entry;
 
-	ocfs2_xattr_bucket_journal_dirty(handle, xs->bucket);
+	ocfs2_xa_journal_dirty(handle, &loc);
 
 out:
 	return ret;
-- 
1.6.3.3
