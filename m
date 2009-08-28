From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 28 Aug 2009 01:35:50 -0700
Subject: [Ocfs2-devel] [PATCH 01/14] ocfs2: Introduce ocfs2_xa_loc
In-Reply-To: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1251448563-12508-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ocfs2 extended attribute (xattr) code is very flexible.  It can
store xattrs in the inode itself, in an external block, or in a tree of
data structures.  This allows the number of xattrs to be bounded by the
filesystem size.

However, the code that manages each possible storage location is
different.  Maintaining the ocfs2 xattr code requires changing each hunk
separately.

This patch is the start of a series introducing the ocfs2_xa_loc
structure.  This structure wraps the on-disk details of an xattr
entry.  The goal is that the generic xattr routines can use
ocfs2_xa_loc without knowing the underlying storage location.

This first pass merely implements the basic structure, initializing it,
and wiping the name+value pair of the entry.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  242 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 227 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a3eed49..848f24e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -141,6 +141,51 @@ struct ocfs2_xattr_search {
 	int not_found;
 };
 
+/* Operations on struct ocfs2_xa_entry */
+struct ocfs2_xa_loc;
+struct ocfs2_xa_loc_operations {
+	/*
+	 * Return a pointer to the appropriate buffer in loc->xl_storage
+	 * at the given offset from loc->xl_header.
+	 */
+	void *(*xlo_offset_pointer)(struct ocfs2_xa_loc *loc, int offset);
+
+	/*
+	 * Remove the name+value at this location.  Do whatever is
+	 * appropriate with the remaining name+value pairs.
+	 */
+	void (*xlo_wipe_namevalue)(struct ocfs2_xa_loc *loc);
+};
+
+/*
+ * Describes an xattr entry location.  This is a memory structure
+ * tracking the on-disk structure.
+ */
+struct ocfs2_xa_loc {
+	/* The ocfs2_xattr_header inside the on-disk storage. Not NULL. */
+	struct ocfs2_xattr_header *xl_header;
+
+	/* Bytes from xl_header to the end of the storage */
+	int xl_size;
+
+	/*
+	 * The ocfs2_xattr_entry this location describes.  If this is
+	 * NULL, this location describes the on-disk structure where it
+	 * would have been.
+	 */
+	struct ocfs2_xattr_entry *xl_entry;
+
+	/*
+	 * Internal housekeeping
+	 */
+
+	/* Buffer(s) containing this entry */
+	void *xl_storage;
+
+	/* Operations on the storage backing this location */
+	const struct ocfs2_xa_loc_operations *xl_ops;
+};
+
 static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 					     struct ocfs2_xattr_header *xh,
 					     int index,
@@ -1424,6 +1469,171 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 }
 
 /*
+ * Wipe the name+value pair and allow the storage to reclaim it.  This
+ * must be followed by either removal of the entry or a call to
+ * ocfs2_xa_add_namevalue().
+ */
+static void ocfs2_xa_wipe_namevalue(struct ocfs2_xa_loc *loc)
+{
+	loc->xl_ops->xlo_wipe_namevalue(loc);
+}
+
+static void *ocfs2_xa_block_offset_pointer(struct ocfs2_xa_loc *loc,
+					   int offset)
+{
+	struct buffer_head *bh = loc->xl_storage;
+
+	BUG_ON(offset >= bh->b_size);
+	return bh->b_data + offset;
+}
+
+/*
+ * Block storage for xattrs keeps the name+value pairs compacted.  When
+ * we remove one, we have to shift any that preceded it towards the end.
+ */
+static void ocfs2_xa_block_wipe_namevalue(struct ocfs2_xa_loc *loc)
+{
+	int i, offset;
+	int namevalue_offset, first_namevalue_offset, namevalue_size;
+	struct ocfs2_xattr_entry *entry = loc->xl_entry;
+	struct ocfs2_xattr_header *xh = loc->xl_header;
+	u64 value_size = le64_to_cpu(entry->xe_value_size);
+	int count = le16_to_cpu(xh->xh_count);
+
+	namevalue_offset = le16_to_cpu(entry->xe_name_offset);
+	namevalue_size = OCFS2_XATTR_SIZE(entry->xe_name_len);
+	if (value_size > OCFS2_XATTR_INLINE_SIZE)
+		namevalue_size += OCFS2_XATTR_ROOT_SIZE;
+	else
+		namevalue_size += OCFS2_XATTR_SIZE(value_size);
+
+	for (i = 0, first_namevalue_offset = loc->xl_size;
+	     i < count; i++) {
+		offset = le16_to_cpu(xh->xh_entries[i].xe_name_offset);
+		if (offset < first_namevalue_offset)
+			first_namevalue_offset = offset;
+	}
+
+	/* Shift the name+value pairs */
+	memmove((char *)xh + first_namevalue_offset + namevalue_size,
+		(char *)xh + first_namevalue_offset,
+		namevalue_offset - first_namevalue_offset);
+	memset((char *)xh + first_namevalue_offset, 0, namevalue_size);
+
+	/* Now tell xh->xh_entries about it */
+	for (i = 0; i < count; i++) {
+		offset = le16_to_cpu(xh->xh_entries[i].xe_name_offset);
+		if (offset < namevalue_offset)
+			le16_add_cpu(&xh->xh_entries[i].xe_name_offset,
+				     namevalue_size);
+	}
+
+	/*
+	 * Note that we don't update xh_free_start or xh_name_value_len
+	 * because they're not used in block-stored xattrs.
+	 */
+}
+
+/*
+ * Operations for xattrs stored in blocks.  This includes inline inode
+ * storage and unindexed ocfs2_xattr_blocks.
+ */
+static const struct ocfs2_xa_loc_operations ocfs2_xa_block_loc_ops = {
+	.xlo_offset_pointer	= ocfs2_xa_block_offset_pointer,
+	.xlo_wipe_namevalue	= ocfs2_xa_block_wipe_namevalue,
+};
+
+static void *ocfs2_xa_bucket_offset_pointer(struct ocfs2_xa_loc *loc,
+					    int offset)
+{
+	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
+	int block, block_offset;
+
+	BUG_ON(offset >= OCFS2_XATTR_BUCKET_SIZE);
+
+	block = offset >> bucket->bu_inode->i_sb->s_blocksize_bits;
+	block_offset = offset % bucket->bu_inode->i_sb->s_blocksize;
+
+	return bucket_block(bucket, block) + block_offset;
+}
+
+static void ocfs2_xa_bucket_wipe_namevalue(struct ocfs2_xa_loc *loc)
+{
+	int namevalue_size;
+	struct ocfs2_xattr_entry *entry = loc->xl_entry;
+	u64 value_size = le64_to_cpu(entry->xe_value_size);
+
+	namevalue_size = OCFS2_XATTR_SIZE(entry->xe_name_len);
+	if (value_size > OCFS2_XATTR_INLINE_SIZE)
+		namevalue_size += OCFS2_XATTR_ROOT_SIZE;
+	else
+		namevalue_size += OCFS2_XATTR_SIZE(value_size);
+
+	le16_add_cpu(&loc->xl_header->xh_name_value_len, -namevalue_size);
+}
+
+/* Operations for xattrs stored in buckets. */
+static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
+	.xlo_offset_pointer	= ocfs2_xa_bucket_offset_pointer,
+	.xlo_wipe_namevalue	= ocfs2_xa_bucket_wipe_namevalue,
+};
+
+static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
+{
+	ocfs2_xa_wipe_namevalue(loc);
+}
+
+static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
+				     struct inode *inode,
+				     struct buffer_head *bh,
+				     struct ocfs2_xattr_entry *entry)
+{
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
+
+	loc->xl_ops = &ocfs2_xa_block_loc_ops;
+	loc->xl_storage = bh;
+	loc->xl_entry = entry;
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_XATTR_FL)
+		loc->xl_size = le16_to_cpu(di->i_xattr_inline_size);
+	else {
+		BUG_ON(entry);
+		loc->xl_size = OCFS2_SB(inode->i_sb)->s_xattr_inline_size;
+	}
+	loc->xl_header =
+		(struct ocfs2_xattr_header *)(bh->b_data + bh->b_size -
+					      loc->xl_size);
+}
+
+static void ocfs2_init_xattr_block_xa_loc(struct ocfs2_xa_loc *loc,
+					  struct buffer_head *bh,
+					  struct ocfs2_xattr_entry *entry)
+{
+	struct ocfs2_xattr_block *xb =
+		(struct ocfs2_xattr_block *)bh->b_data;
+
+	BUG_ON(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED);
+
+	loc->xl_ops = &ocfs2_xa_block_loc_ops;
+	loc->xl_storage = bh;
+	loc->xl_header = &(xb->xb_attrs.xb_header);
+	loc->xl_entry = entry;
+	loc->xl_size = bh->b_size - offsetof(struct ocfs2_xattr_block,
+					     xb_attrs.xb_header);
+}
+
+static void ocfs2_init_xattr_bucket_xa_loc(struct ocfs2_xa_loc *loc,
+					   struct ocfs2_xattr_bucket *bucket,
+					   struct ocfs2_xattr_entry *entry)
+{
+	loc->xl_ops = &ocfs2_xa_bucket_loc_ops;
+	loc->xl_storage = bucket;
+	loc->xl_header = bucket_xh(bucket);
+	loc->xl_entry = entry;
+	loc->xl_size = OCFS2_XATTR_BUCKET_SIZE;
+}
+
+/*
  * ocfs2_xattr_set_entry_local()
  *
  * Set, replace or remove extended attribute in local.
@@ -1436,7 +1646,14 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 {
 	size_t name_len = strlen(xi->name);
 	int i;
+	struct ocfs2_xa_loc loc;
 
+	if (xs->xattr_bh == xs->inode_bh)
+		ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
+					 xs->not_found ? NULL : xs->here);
+	else
+		ocfs2_init_xattr_block_xa_loc(&loc, xs->xattr_bh,
+					      xs->not_found ? NULL : xs->here);
 	if (xi->value && xs->not_found) {
 		/* Insert the new xattr entry. */
 		le16_add_cpu(&xs->header->xh_count, 1);
@@ -1475,9 +1692,9 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 			       xi->value_len);
 			return;
 		}
+
 		/* Remove the old name+value. */
-		memmove(first_val + size, first_val, val - first_val);
-		memset(first_val, 0, size);
+		ocfs2_xa_wipe_namevalue(&loc);
 		xs->here->xe_name_hash = 0;
 		xs->here->xe_name_offset = 0;
 		ocfs2_xattr_set_local(xs->here, 1);
@@ -1485,23 +1702,15 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 
 		min_offs += size;
 
-		/* Adjust all value offsets. */
-		last = xs->header->xh_entries;
-		for (i = 0 ; i < le16_to_cpu(xs->header->xh_count); i++) {
-			size_t o = le16_to_cpu(last->xe_name_offset);
-
-			if (o < offs)
-				last->xe_name_offset = cpu_to_le16(o + size);
-			last += 1;
-		}
-
 		if (!xi->value) {
 			/* Remove the old entry. */
-			last -= 1;
+			i = le16_to_cpu(xs->header->xh_count) - 1;
+			last = &xs->header->xh_entries[i];
+			xs->header->xh_count = cpu_to_le16(i);
+
 			memmove(xs->here, xs->here + 1,
 				(void *)last - (void *)xs->here);
 			memset(last, 0, sizeof(struct ocfs2_xattr_entry));
-			le16_add_cpu(&xs->header->xh_count, -1);
 		}
 	}
 	if (xi->value) {
@@ -4775,7 +4984,10 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 	size_t blocksize = inode->i_sb->s_blocksize;
 	char *val;
 	size_t offs, size, new_size;
+	struct ocfs2_xa_loc loc;
 
+	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
+				       xs->not_found ? NULL : xs->here);
 	last = &xh->xh_entries[count];
 	if (!xs->not_found) {
 		xe = xs->here;
@@ -4796,7 +5008,7 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 		new_size = OCFS2_XATTR_SIZE(name_len) +
 			   OCFS2_XATTR_SIZE(xi->value_len);
 
-		le16_add_cpu(&xh->xh_name_value_len, -size);
+		ocfs2_xa_wipe_namevalue(&loc);
 		if (xi->value) {
 			if (new_size > size)
 				goto set_new_name_value;
-- 
1.6.3.3
