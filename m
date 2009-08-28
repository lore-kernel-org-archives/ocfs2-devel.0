From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 28 Aug 2009 01:35:55 -0700
Subject: [Ocfs2-devel] [PATCH 06/14] ocfs2: Set the xattr name+value pair in
	one place
In-Reply-To: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1251448563-12508-7-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We create two new functions on ocfs2_xa_loc, ocfs2_xa_prepare_entry()
and ocfs2_xa_store_inline_value().

ocfs2_xa_prepare_entry() makes sure that the xl_entry field of
ocfs2_xa_loc is ready to receive an xattr.  The entry will point to an
appropriately sized name+value region in storage.  If an existing entry
can be reused, it will be.  If no entry already exists, it will be
allocated.  If there isn't space to allocate it, -ENOSPC will be
returned.

ocfs2_xa_store_inline_value() stores the data that goes into the 'value'
part of the name+value pair.  For values that don't fit directly, this
stores the value tree root.

A number of operations are added to ocfs2_xa_loc_operations to support
these functions.  This reflects the disparate behaviors of xattr blocks
and buckets.

With these functions, the overlapping ocfs2_xattr_set_entry_local() and
ocfs2_xattr_set_entry_normal() can be replaced with a single call
scheme.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  606 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 386 insertions(+), 220 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4c5c566..3d14c1c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -151,11 +151,31 @@ struct ocfs2_xa_loc_operations {
 	 */
 	void *(*xlo_offset_pointer)(struct ocfs2_xa_loc *loc, int offset);
 
+	/* Can we reuse the existing entry for the new value? */
+	int (*xlo_can_reuse)(struct ocfs2_xa_loc *loc,
+			     struct ocfs2_xattr_info *xi);
+
+	/* How much space is needed for the new value? */
+	int (*xlo_has_space)(struct ocfs2_xa_loc *loc,
+			     struct ocfs2_xattr_info *xi);
+
+	/*
+	 * Return the offset of the first name+value pair.  This is
+	 * the start of our downward-filling free space.
+	 */
+	int (*xlo_get_free_start)(struct ocfs2_xa_loc *loc);
+
 	/*
 	 * Remove the name+value at this location.  Do whatever is
 	 * appropriate with the remaining name+value pairs.
 	 */
 	void (*xlo_wipe_namevalue)(struct ocfs2_xa_loc *loc);
+
+	/* Fill xl_entry with a new entry */
+	void (*xlo_add_entry)(struct ocfs2_xa_loc *loc, u32 name_hash);
+
+	/* Add name+value storage to an entry */
+	void (*xlo_add_namevalue)(struct ocfs2_xa_loc *loc, int size);
 };
 
 /*
@@ -1499,6 +1519,29 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 	return ret;
 }
 
+static int ocfs2_xa_has_space_helper(int needed_space, int free_start,
+				     int num_entries)
+{
+	int free_space;
+
+	free_space = free_start -
+		sizeof(struct ocfs2_xattr_header) -
+		(num_entries * sizeof(struct ocfs2_xattr_entry)) -
+		OCFS2_XATTR_HEADER_GAP;
+	if (free_space < 0)
+		return -EIO;
+	if (free_space < needed_space)
+		return -ENOSPC;
+
+	return 0;
+}
+
+/* Give a pointer into the storage for the given offset */
+static void *ocfs2_xa_offset_pointer(struct ocfs2_xa_loc *loc, int offset)
+{
+	return loc->xl_ops->xlo_offset_pointer(loc, offset);
+}
+
 /*
  * Wipe the name+value pair and allow the storage to reclaim it.  This
  * must be followed by either removal of the entry or a call to
@@ -1509,6 +1552,60 @@ static void ocfs2_xa_wipe_namevalue(struct ocfs2_xa_loc *loc)
 	loc->xl_ops->xlo_wipe_namevalue(loc);
 }
 
+/*
+ * Find lowest offset to a name+value pair.  This is the start of our
+ * downward-growing free space.
+ */
+static int ocfs2_xa_get_free_start(struct ocfs2_xa_loc *loc)
+{
+	return loc->xl_ops->xlo_get_free_start(loc);
+}
+
+/* Can we reuse loc->xl_entry for xi? */
+static int ocfs2_xa_can_reuse_entry(struct ocfs2_xa_loc *loc,
+				    struct ocfs2_xattr_info *xi)
+{
+	return loc->xl_ops->xlo_can_reuse(loc, xi);
+}
+
+/* How much free space is needed to set the new value */
+static int ocfs2_xa_has_space(struct ocfs2_xa_loc *loc,
+			      struct ocfs2_xattr_info *xi)
+{
+	return loc->xl_ops->xlo_has_space(loc, xi);
+}
+
+static void ocfs2_xa_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
+{
+	loc->xl_ops->xlo_add_entry(loc, name_hash);
+	loc->xl_entry->xe_name_hash = cpu_to_le32(name_hash);
+	/*
+	 * We can't leave the new entry's xe_name_offset at zero or
+	 * add_namevalue() will go nuts.  We set it to the size of our
+	 * storage so that it can never be less than any other entry.
+	 */
+	loc->xl_entry->xe_name_offset = cpu_to_le16(loc->xl_size);
+}
+
+static void ocfs2_xa_add_namevalue(struct ocfs2_xa_loc *loc,
+				   struct ocfs2_xattr_info *xi)
+{
+	int size = namevalue_size_xi(xi);
+	int nameval_offset;
+	char *nameval_buf;
+
+	loc->xl_ops->xlo_add_namevalue(loc, size);
+	loc->xl_entry->xe_value_size = cpu_to_le64(xi->xi_value_len);
+	ocfs2_xattr_set_type(loc->xl_entry, xi->xi_name_index);
+	ocfs2_xattr_set_local(loc->xl_entry,
+			      xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE);
+
+	nameval_offset = le16_to_cpu(loc->xl_entry->xe_name_offset);
+	nameval_buf = ocfs2_xa_offset_pointer(loc, nameval_offset);
+	memset(nameval_buf, 0, size);
+	memcpy(nameval_buf, xi->xi_name, xi->xi_name_len);
+}
+
 static void *ocfs2_xa_block_offset_pointer(struct ocfs2_xa_loc *loc,
 					   int offset)
 {
@@ -1518,6 +1615,56 @@ static void *ocfs2_xa_block_offset_pointer(struct ocfs2_xa_loc *loc,
 	return bh->b_data + offset;
 }
 
+static int ocfs2_xa_block_can_reuse(struct ocfs2_xa_loc *loc,
+				    struct ocfs2_xattr_info *xi)
+{
+	/*
+	 * Block storage is strict.  If the sizes aren't exact, we will
+	 * remove the old one and reinsert the new.
+	 */
+	return namevalue_size_xe(loc->xl_entry) ==
+		namevalue_size_xi(xi);
+}
+
+static int ocfs2_xa_block_get_free_start(struct ocfs2_xa_loc *loc)
+{
+	struct ocfs2_xattr_header *xh = loc->xl_header;
+	int i, count = le16_to_cpu(xh->xh_count);
+	int offset, free_start = loc->xl_size;
+
+	for (i = 0; i < count; i++) {
+		offset = le16_to_cpu(xh->xh_entries[i].xe_name_offset);
+		if (offset < free_start)
+			free_start = offset;
+	}
+
+	return free_start;
+}
+
+static int ocfs2_xa_block_has_space(struct ocfs2_xa_loc *loc,
+				    struct ocfs2_xattr_info *xi)
+{
+	int count = le16_to_cpu(loc->xl_header->xh_count);
+	int free_start = ocfs2_xa_get_free_start(loc);
+	int needed_space = ocfs2_xi_entry_usage(xi);
+
+	/*
+	 * Block storage will reclaim the original entry before inserting
+	 * the new value, so we only need the difference.  If the new
+	 * entry is smaller than the old one, we don't need anything.
+	 */
+	if (loc->xl_entry) {
+		/* Don't need space if we're reusing! */
+		if (ocfs2_xa_can_reuse_entry(loc, xi))
+			needed_space = 0;
+		else
+			needed_space -= ocfs2_xe_entry_usage(loc->xl_entry);
+	}
+	if (needed_space < 0)
+		needed_space = 0;
+	return ocfs2_xa_has_space_helper(needed_space, free_start, count);
+}
+
 /*
  * Block storage for xattrs keeps the name+value pairs compacted.  When
  * we remove one, we have to shift any that preceded it towards the end.
@@ -1532,13 +1679,7 @@ static void ocfs2_xa_block_wipe_namevalue(struct ocfs2_xa_loc *loc)
 
 	namevalue_offset = le16_to_cpu(entry->xe_name_offset);
 	namevalue_size = namevalue_size_xe(entry);
-
-	for (i = 0, first_namevalue_offset = loc->xl_size;
-	     i < count; i++) {
-		offset = le16_to_cpu(xh->xh_entries[i].xe_name_offset);
-		if (offset < first_namevalue_offset)
-			first_namevalue_offset = offset;
-	}
+	first_namevalue_offset = ocfs2_xa_get_free_start(loc);
 
 	/* Shift the name+value pairs */
 	memmove((char *)xh + first_namevalue_offset + namevalue_size,
@@ -1560,13 +1701,33 @@ static void ocfs2_xa_block_wipe_namevalue(struct ocfs2_xa_loc *loc)
 	 */
 }
 
+static void ocfs2_xa_block_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
+{
+	int count = le16_to_cpu(loc->xl_header->xh_count);
+	loc->xl_entry = &(loc->xl_header->xh_entries[count]);
+	le16_add_cpu(&loc->xl_header->xh_count, 1);
+	memset(loc->xl_entry, 0, sizeof(struct ocfs2_xattr_entry));
+}
+
+static void ocfs2_xa_block_add_namevalue(struct ocfs2_xa_loc *loc, int size)
+{
+	int free_start = ocfs2_xa_get_free_start(loc);
+
+	loc->xl_entry->xe_name_offset = cpu_to_le16(free_start - size);
+}
+
 /*
  * Operations for xattrs stored in blocks.  This includes inline inode
  * storage and unindexed ocfs2_xattr_blocks.
  */
 static const struct ocfs2_xa_loc_operations ocfs2_xa_block_loc_ops = {
 	.xlo_offset_pointer	= ocfs2_xa_block_offset_pointer,
+	.xlo_has_space		= ocfs2_xa_block_has_space,
+	.xlo_can_reuse		= ocfs2_xa_block_can_reuse,
+	.xlo_get_free_start	= ocfs2_xa_block_get_free_start,
 	.xlo_wipe_namevalue	= ocfs2_xa_block_wipe_namevalue,
+	.xlo_add_entry		= ocfs2_xa_block_add_entry,
+	.xlo_add_namevalue	= ocfs2_xa_block_add_namevalue,
 };
 
 static void *ocfs2_xa_bucket_offset_pointer(struct ocfs2_xa_loc *loc,
@@ -1583,16 +1744,128 @@ static void *ocfs2_xa_bucket_offset_pointer(struct ocfs2_xa_loc *loc,
 	return bucket_block(bucket, block) + block_offset;
 }
 
+static int ocfs2_xa_bucket_can_reuse(struct ocfs2_xa_loc *loc,
+				     struct ocfs2_xattr_info *xi)
+{
+	return namevalue_size_xe(loc->xl_entry) >=
+		namevalue_size_xi(xi);
+}
+
+static int ocfs2_xa_bucket_get_free_start(struct ocfs2_xa_loc *loc)
+{
+	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
+	return le16_to_cpu(bucket_xh(bucket)->xh_free_start);
+}
+
+static int ocfs2_bucket_align_free_start(struct super_block *sb,
+					 int free_start, int size)
+{
+	/*
+	 * We need to make sure that the name+value pair fits within
+	 * one block.
+	 */
+	if (((free_start - size) >> sb->s_blocksize_bits) !=
+	    ((free_start - 1) >> sb->s_blocksize_bits))
+		free_start -= free_start % sb->s_blocksize;
+
+	return free_start;
+}
+
+static int ocfs2_xa_bucket_has_space(struct ocfs2_xa_loc *loc,
+				     struct ocfs2_xattr_info *xi)
+{
+	int count = le16_to_cpu(loc->xl_header->xh_count);
+	int free_start = ocfs2_xa_get_free_start(loc);
+	int needed_space = ocfs2_xi_entry_usage(xi);
+	int size = namevalue_size_xi(xi);
+	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
+	struct super_block *sb = bucket->bu_inode->i_sb;
+
+	/*
+	 * Bucket storage does not reclaim name+value pairs it cannot
+	 * reuse.  They live as holes until the bucket fills, and then
+	 * the bucket is defragmented.  However, the bucket can reclaim
+	 * the ocfs2_xattr_entry.
+	 */
+	if (loc->xl_entry) {
+		/* Don't need space if we're reusing! */
+		if (ocfs2_xa_can_reuse_entry(loc, xi))
+			needed_space = 0;
+		else
+			needed_space -= sizeof(struct ocfs2_xattr_entry);
+	}
+	BUG_ON(needed_space < 0);
+
+	free_start = ocfs2_bucket_align_free_start(sb, free_start, size);
+	return ocfs2_xa_has_space_helper(needed_space, free_start, count);
+}
+
 static void ocfs2_xa_bucket_wipe_namevalue(struct ocfs2_xa_loc *loc)
 {
 	le16_add_cpu(&loc->xl_header->xh_name_value_len,
 		     -namevalue_size_xe(loc->xl_entry));
 }
 
+static void ocfs2_xa_bucket_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
+{
+	struct ocfs2_xattr_header *xh = loc->xl_header;
+	int count = le16_to_cpu(xh->xh_count);
+	int low = 0, high = count - 1, tmp;
+	struct ocfs2_xattr_entry *tmp_xe;
+
+	/*
+	 * We keep buckets sorted by name_hash, so we need to find
+	 * our insert place.
+	 */
+	while (low <= high && count) {
+		tmp = (low + high) / 2;
+		tmp_xe = &xh->xh_entries[tmp];
+
+		if (name_hash > le32_to_cpu(tmp_xe->xe_name_hash))
+			low = tmp + 1;
+		else if (name_hash < le32_to_cpu(tmp_xe->xe_name_hash))
+			high = tmp - 1;
+		else {
+			low = tmp;
+			break;
+		}
+	}
+
+	if (low != count)
+		memmove(&xh->xh_entries[low + 1],
+			&xh->xh_entries[low],
+			((count - low) * sizeof(struct ocfs2_xattr_entry)));
+
+	le16_add_cpu(&xh->xh_count, 1);
+	loc->xl_entry = &xh->xh_entries[low];
+	memset(loc->xl_entry, 0, sizeof(struct ocfs2_xattr_entry));
+}
+
+static void ocfs2_xa_bucket_add_namevalue(struct ocfs2_xa_loc *loc, int size)
+{
+	int free_start = ocfs2_xa_get_free_start(loc);
+	struct ocfs2_xattr_header *xh = loc->xl_header;
+	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
+	struct super_block *sb = bucket->bu_inode->i_sb;
+	int nameval_offset;
+
+	free_start = ocfs2_bucket_align_free_start(sb, free_start, size);
+	nameval_offset = free_start - size;
+	loc->xl_entry->xe_name_offset = cpu_to_le16(nameval_offset);
+	xh->xh_free_start = cpu_to_le16(nameval_offset);
+	le16_add_cpu(&xh->xh_name_value_len, size);
+
+}
+
 /* Operations for xattrs stored in buckets. */
 static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
 	.xlo_offset_pointer	= ocfs2_xa_bucket_offset_pointer,
+	.xlo_has_space		= ocfs2_xa_bucket_has_space,
+	.xlo_can_reuse		= ocfs2_xa_bucket_can_reuse,
+	.xlo_get_free_start	= ocfs2_xa_bucket_get_free_start,
 	.xlo_wipe_namevalue	= ocfs2_xa_bucket_wipe_namevalue,
+	.xlo_add_entry		= ocfs2_xa_bucket_add_entry,
+	.xlo_add_namevalue	= ocfs2_xa_bucket_add_namevalue,
 };
 
 static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
@@ -1621,6 +1894,74 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
 	}
 }
 
+/*
+ * Prepares loc->xl_entry to receive the new xattr.  This includes
+ * properly setting up the name+value pair region.  If loc->xl_entry
+ * already exists, it will take care of modifying it appropriately.
+ * This also includes deleting entries, but don't call this to remove
+ * a non-existant entry.  That's just a bug.
+ *
+ * Note that this modifies the data.  You did journal_access already,
+ * right?
+ */
+static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
+				  struct ocfs2_xattr_info *xi,
+				  u32 name_hash)
+{
+	int rc = 0;
+	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
+	char *nameval_buf;
+
+	if (!xi->xi_value) {
+		ocfs2_xa_remove_entry(loc);
+		goto out;
+	}
+
+	rc = ocfs2_xa_has_space(loc, xi);
+	if (rc)
+		goto out;
+
+	if (loc->xl_entry) {
+		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
+			nameval_buf = ocfs2_xa_offset_pointer(loc,
+				le16_to_cpu(loc->xl_entry->xe_name_offset));
+			memset(nameval_buf + name_size, 0,
+			       namevalue_size_xe(loc->xl_entry) - name_size);
+			loc->xl_entry->xe_value_size =
+				cpu_to_le64(xi->xi_value_len);
+			goto out;
+		}
+
+		ocfs2_xa_wipe_namevalue(loc);
+	} else
+		ocfs2_xa_add_entry(loc, name_hash);
+
+	/*
+	 * If we get here, we have a blank entry.  Fill it.  We grow our
+	 * name+value pair back from the end.
+	 */
+	ocfs2_xa_add_namevalue(loc, xi);
+
+out:
+	return rc;
+}
+
+/*
+ * Store the value portion of the name+value pair.  This is either an
+ * inline value or the tree root of an external value.
+ */
+static void ocfs2_xa_store_inline_value(struct ocfs2_xa_loc *loc,
+					struct ocfs2_xattr_info *xi)
+{
+	int nameval_offset = le16_to_cpu(loc->xl_entry->xe_name_offset);
+	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
+	int size = namevalue_size_xi(xi);
+	char *nameval_buf;
+
+	nameval_buf = ocfs2_xa_offset_pointer(loc, nameval_offset);
+	memcpy(nameval_buf + name_size, xi->xi_value, size - name_size);
+}
+
 static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
 				     struct inode *inode,
 				     struct buffer_head *bh,
@@ -1671,81 +2012,6 @@ static void ocfs2_init_xattr_bucket_xa_loc(struct ocfs2_xa_loc *loc,
 	loc->xl_size = OCFS2_XATTR_BUCKET_SIZE;
 }
 
-/*
- * ocfs2_xattr_set_entry_local()
- *
- * Set, replace or remove extended attribute in local.
- */
-static void ocfs2_xattr_set_entry_local(struct inode *inode,
-					struct ocfs2_xattr_info *xi,
-					struct ocfs2_xattr_search *xs,
-					struct ocfs2_xattr_entry *last,
-					size_t min_offs)
-{
-	struct ocfs2_xa_loc loc;
-
-	if (xs->xattr_bh == xs->inode_bh)
-		ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
-					 xs->not_found ? NULL : xs->here);
-	else
-		ocfs2_init_xattr_block_xa_loc(&loc, xs->xattr_bh,
-					      xs->not_found ? NULL : xs->here);
-	if (xi->xi_value && xs->not_found) {
-		/* Insert the new xattr entry. */
-		le16_add_cpu(&xs->header->xh_count, 1);
-		ocfs2_xattr_set_type(last, xi->xi_name_index);
-		ocfs2_xattr_set_local(last, 1);
-		last->xe_name_len = xi->xi_name_len;
-	} else {
-		void *first_val;
-		void *val;
-		size_t offs, size;
-
-		first_val = xs->base + min_offs;
-		offs = le16_to_cpu(xs->here->xe_name_offset);
-		val = xs->base + offs;
-
-		size = namevalue_size_xe(xs->here);
-		if (xi->xi_value && (size == namevalue_size_xi(xi))) {
-			/* The old and the new value have the
-			   same size. Just replace the value. */
-			ocfs2_xattr_set_local(xs->here, 1);
-			xs->here->xe_value_size = cpu_to_le64(xi->xi_value_len);
-			/* Clear value bytes. */
-			memset(val + OCFS2_XATTR_SIZE(xi->xi_name_len),
-			       0,
-			       OCFS2_XATTR_SIZE(xi->xi_value_len));
-			memcpy(val + OCFS2_XATTR_SIZE(xi->xi_name_len),
-			       xi->xi_value,
-			       xi->xi_value_len);
-			return;
-		}
-
-		if (!xi->xi_value)
-			ocfs2_xa_remove_entry(&loc);
-		else
-			ocfs2_xa_wipe_namevalue(&loc);
-
-		min_offs += size;
-	}
-	if (xi->xi_value) {
-		/* Insert the new name+value. */
-		size_t size = namevalue_size_xi(xi);
-		void *val = xs->base + min_offs - size;
-
-		xs->here->xe_name_offset = cpu_to_le16(min_offs - size);
-		memset(val, 0, size);
-		memcpy(val, xi->xi_name, xi->xi_name_len);
-		memcpy(val + OCFS2_XATTR_SIZE(xi->xi_name_len),
-		       xi->xi_value,
-		       xi->xi_value_len);
-		xs->here->xe_value_size = cpu_to_le64(xi->xi_value_len);
-		ocfs2_xattr_set_local(xs->here, 1);
-		ocfs2_xattr_hash_entry(inode, xs->header, xs->here);
-	}
-
-	return;
-}
 
 /*
  * ocfs2_xattr_set_entry()
@@ -1753,7 +2019,7 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
  * Set extended attribute entry into inode or block.
  *
  * If extended attribute value size > OCFS2_XATTR_INLINE_SIZE,
- * We first insert tree root(ocfs2_xattr_value_root) with set_entry_local(),
+ * We first insert tree root(ocfs2_xattr_value_root) like a normal value,
  * then set value in B tree with set_value_outside().
  */
 static int ocfs2_xattr_set_entry(struct inode *inode,
@@ -1769,6 +2035,9 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	size_t size_l = 0;
 	handle_t *handle = ctxt->handle;
 	int free, i, ret;
+	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
+					      xi->xi_name_len);
+	struct ocfs2_xa_loc loc;
 	struct ocfs2_xattr_info xi_l = {
 		.xi_name_index = xi->xi_name_index,
 		.xi_name = xi->xi_name,
@@ -1900,11 +2169,28 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		}
 	}
 
+	if (xs->xattr_bh == xs->inode_bh)
+		ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
+					 xs->not_found ? NULL : xs->here);
+	else
+		ocfs2_init_xattr_block_xa_loc(&loc, xs->xattr_bh,
+					      xs->not_found ? NULL : xs->here);
+
 	/*
-	 * Set value in local, include set tree root in local.
-	 * This is the first step for value size >INLINE_SIZE.
+	 * Prepare our entry and insert the inline value.  This will
+	 * be a value tree root for values that are larger than
+	 * OCFS2_XATTR_INLINE_SIZE.
 	 */
-	ocfs2_xattr_set_entry_local(inode, &xi_l, xs, last, min_offs);
+	ret = ocfs2_xa_prepare_entry(&loc, xi, name_hash);
+	if (ret) {
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
+		goto out;
+	}
+	/* XXX For now, until we make ocfs2_xa_prepare_entry() primary */
+	BUG_ON(ret == -ENOSPC);
+	ocfs2_xa_store_inline_value(&loc, xi);
+	xs->here = loc.xl_entry;
 
 	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
 		ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
@@ -4945,139 +5231,6 @@ static inline char *ocfs2_xattr_bucket_get_val(struct inode *inode,
 }
 
 /*
- * Handle the normal xattr set, including replace, delete and new.
- *
- * Note: "local" indicates the real data's locality. So we can't
- * just its bucket locality by its length.
- */
-static void ocfs2_xattr_set_entry_normal(struct inode *inode,
-					 struct ocfs2_xattr_info *xi,
-					 struct ocfs2_xattr_search *xs,
-					 u32 name_hash,
-					 int local)
-{
-	struct ocfs2_xattr_entry *last, *xe;
-	struct ocfs2_xattr_header *xh = xs->header;
-	u16 count = le16_to_cpu(xh->xh_count), start;
-	size_t blocksize = inode->i_sb->s_blocksize;
-	char *val;
-	size_t offs, size, new_size;
-	struct ocfs2_xa_loc loc;
-
-	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
-				       xs->not_found ? NULL : xs->here);
-	last = &xh->xh_entries[count];
-	if (!xs->not_found) {
-		xe = xs->here;
-		offs = le16_to_cpu(xe->xe_name_offset);
-		size = namevalue_size_xe(xe);
-
-		/*
-		 * If the new value will be stored outside, xi->xi_value has
-		 * been initalized as an empty ocfs2_xattr_value_root, and
-		 * the same goes with xi->xi_value_len, so we can set
-		 * new_size safely here.
-		 * See ocfs2_xattr_set_in_bucket.
-		 */
-		new_size = namevalue_size_xi(xi);
-
-		if (xi->xi_value) {
-			ocfs2_xa_wipe_namevalue(&loc);
-			if (new_size > size)
-				goto set_new_name_value;
-
-			/* Now replace the old value with new one. */
-			if (local)
-				xe->xe_value_size =
-					cpu_to_le64(xi->xi_value_len);
-			else
-				xe->xe_value_size = 0;
-
-			val = ocfs2_xattr_bucket_get_val(inode,
-							 xs->bucket, offs);
-			memset(val + OCFS2_XATTR_SIZE(xi->xi_name_len), 0,
-			       size - OCFS2_XATTR_SIZE(xi->xi_name_len));
-			if (OCFS2_XATTR_SIZE(xi->xi_value_len) > 0)
-				memcpy(val + OCFS2_XATTR_SIZE(xi->xi_name_len),
-				       xi->xi_value, xi->xi_value_len);
-
-			le16_add_cpu(&xh->xh_name_value_len, new_size);
-			ocfs2_xattr_set_local(xe, local);
-			return;
-		} else {
-			ocfs2_xa_remove_entry(&loc);
-			if (!xh->xh_count)
-				xh->xh_free_start =
-					cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE);
-
-			return;
-		}
-	} else {
-		/* find a new entry for insert. */
-		int low = 0, high = count - 1, tmp;
-		struct ocfs2_xattr_entry *tmp_xe;
-
-		while (low <= high && count) {
-			tmp = (low + high) / 2;
-			tmp_xe = &xh->xh_entries[tmp];
-
-			if (name_hash > le32_to_cpu(tmp_xe->xe_name_hash))
-				low = tmp + 1;
-			else if (name_hash <
-				 le32_to_cpu(tmp_xe->xe_name_hash))
-				high = tmp - 1;
-			else {
-				low = tmp;
-				break;
-			}
-		}
-
-		xe = &xh->xh_entries[low];
-		if (low != count)
-			memmove(xe + 1, xe, (void *)last - (void *)xe);
-
-		le16_add_cpu(&xh->xh_count, 1);
-		memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
-		xe->xe_name_hash = cpu_to_le32(name_hash);
-		xe->xe_name_len = xi->xi_name_len;
-		ocfs2_xattr_set_type(xe, xi->xi_name_index);
-	}
-
-set_new_name_value:
-	/* Insert the new name+value. */
-	size = namevalue_size_xi(xi);
-
-	/*
-	 * We must make sure that the name/value pair
-	 * exists in the same block.
-	 */
-	offs = le16_to_cpu(xh->xh_free_start);
-	start = offs - size;
-
-	if (start >> inode->i_sb->s_blocksize_bits !=
-	    (offs - 1) >> inode->i_sb->s_blocksize_bits) {
-		offs = offs - offs % blocksize;
-		xh->xh_free_start = cpu_to_le16(offs);
-	}
-
-	val = ocfs2_xattr_bucket_get_val(inode, xs->bucket, offs - size);
-	xe->xe_name_offset = cpu_to_le16(offs - size);
-
-	memset(val, 0, size);
-	memcpy(val, xi->xi_name, xi->xi_name_len);
-	memcpy(val + OCFS2_XATTR_SIZE(xi->xi_name_len), xi->xi_value,
-	       xi->xi_value_len);
-
-	xe->xe_value_size = cpu_to_le64(xi->xi_value_len);
-	ocfs2_xattr_set_local(xe, local);
-	xs->here = xe;
-	le16_add_cpu(&xh->xh_free_start, -size);
-	le16_add_cpu(&xh->xh_name_value_len, size);
-
-	return;
-}
-
-/*
  * Set the xattr entry in the specified bucket.
  * The bucket is indicated by xs->bucket and it should have the enough
  * space for the xattr insertion.
@@ -5091,6 +5244,7 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 {
 	int ret;
 	u64 blkno;
+	struct ocfs2_xa_loc loc;
 
 	mlog(0, "Set xattr entry len = %lu index = %d in bucket %llu\n",
 	     (unsigned long)xi->xi_value_len, xi->xi_name_index,
@@ -5113,7 +5267,19 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 		goto out;
 	}
 
-	ocfs2_xattr_set_entry_normal(inode, xi, xs, name_hash, local);
+	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
+				       xs->not_found ? NULL : xs->here);
+	ret = ocfs2_xa_prepare_entry(&loc, xi, name_hash);
+	if (ret) {
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
+		goto out;
+	}
+	/* XXX For now, until we make ocfs2_xa_prepare_entry() primary */
+	BUG_ON(ret == -ENOSPC);
+	ocfs2_xa_store_inline_value(&loc, xi);
+	xs->here = loc.xl_entry;
+
 	ocfs2_xattr_bucket_journal_dirty(handle, xs->bucket);
 
 out:
-- 
1.6.3.3
