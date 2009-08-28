From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 28 Aug 2009 01:35:54 -0700
Subject: [Ocfs2-devel] [PATCH 05/14] ocfs2: Wrap calculation of name+value
	pair size.
In-Reply-To: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1251448563-12508-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

An ocfs2 xattr entry stores the text name and value as a pair in the
storage area.  Obviously names and values can be variable-sized.  If a
value is too large for the entry storage, a tree root is stored instead.
The name+value pair is also padded.

Because of this, there are a million places in the code that do:

	if (needs_external_tree(value_size)
		namevalue_size = pad(name_size) + tree_root_size;
	else
		namevalue_size = pad(name_size) + pad(value_size);

Let's create some convenience functions to make the code more readable.
There are three forms.  The first takes the raw sizes.  The second takes
an ocfs2_xattr_info structure.  The third takes an existing
ocfs2_xattr_entry.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  170 +++++++++++++++++++++---------------------------------
 1 files changed, 65 insertions(+), 105 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b92c775..4c5c566 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -187,6 +187,33 @@ struct ocfs2_xa_loc {
 	const struct ocfs2_xa_loc_operations *xl_ops;
 };
 
+/*
+ * Convenience functions to calculate how much space is needed for a
+ * given name+value pair
+ */
+static int namevalue_size(int name_len, uint64_t value_len)
+{
+	if (value_len > OCFS2_XATTR_INLINE_SIZE)
+		return OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
+	else
+		return OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_SIZE(value_len);
+}
+
+static int namevalue_size_xi(struct ocfs2_xattr_info *xi)
+{
+	return namevalue_size(xi->xi_name_len, xi->xi_value_len);
+}
+
+static int namevalue_size_xe(struct ocfs2_xattr_entry *xe)
+{
+	u64 value_len = le64_to_cpu(xe->xe_value_size);
+
+	BUG_ON((value_len > OCFS2_XATTR_INLINE_SIZE) &&
+	       ocfs2_xattr_is_local(xe));
+	return namevalue_size(xe->xe_name_len, value_len);
+}
+
+
 static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 					     struct ocfs2_xattr_header *xh,
 					     int index,
@@ -535,15 +562,20 @@ static void ocfs2_xattr_hash_entry(struct inode *inode,
 
 static int ocfs2_xattr_entry_real_size(int name_len, size_t value_len)
 {
-	int size = 0;
+	return namevalue_size(name_len, value_len) +
+		sizeof(struct ocfs2_xattr_entry);
+}
 
-	if (value_len <= OCFS2_XATTR_INLINE_SIZE)
-		size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_SIZE(value_len);
-	else
-		size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
-	size += sizeof(struct ocfs2_xattr_entry);
+static int ocfs2_xi_entry_usage(struct ocfs2_xattr_info *xi)
+{
+	return namevalue_size_xi(xi) +
+		sizeof(struct ocfs2_xattr_entry);
+}
 
-	return size;
+static int ocfs2_xe_entry_usage(struct ocfs2_xattr_entry *xe)
+{
+	return namevalue_size_xe(xe) +
+		sizeof(struct ocfs2_xattr_entry);
 }
 
 int ocfs2_calc_security_init(struct inode *dir,
@@ -1369,8 +1401,7 @@ static int ocfs2_xattr_cleanup(struct inode *inode,
 {
 	int ret = 0;
 	void *val = xs->base + offs;
-	size_t size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-		OCFS2_XATTR_ROOT_SIZE;
+	size_t size = namevalue_size_xi(xi);
 
 	ret = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
 			    OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1436,8 +1467,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 {
 	void *val = xs->base + offs;
 	struct ocfs2_xattr_value_root *xv = NULL;
-	size_t size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-		OCFS2_XATTR_ROOT_SIZE;
+	size_t size = namevalue_size_xi(xi);
 	int ret = 0;
 
 	memset(val, 0, size);
@@ -1498,15 +1528,10 @@ static void ocfs2_xa_block_wipe_namevalue(struct ocfs2_xa_loc *loc)
 	int namevalue_offset, first_namevalue_offset, namevalue_size;
 	struct ocfs2_xattr_entry *entry = loc->xl_entry;
 	struct ocfs2_xattr_header *xh = loc->xl_header;
-	u64 value_size = le64_to_cpu(entry->xe_value_size);
 	int count = le16_to_cpu(xh->xh_count);
 
 	namevalue_offset = le16_to_cpu(entry->xe_name_offset);
-	namevalue_size = OCFS2_XATTR_SIZE(entry->xe_name_len);
-	if (value_size > OCFS2_XATTR_INLINE_SIZE)
-		namevalue_size += OCFS2_XATTR_ROOT_SIZE;
-	else
-		namevalue_size += OCFS2_XATTR_SIZE(value_size);
+	namevalue_size = namevalue_size_xe(entry);
 
 	for (i = 0, first_namevalue_offset = loc->xl_size;
 	     i < count; i++) {
@@ -1560,17 +1585,8 @@ static void *ocfs2_xa_bucket_offset_pointer(struct ocfs2_xa_loc *loc,
 
 static void ocfs2_xa_bucket_wipe_namevalue(struct ocfs2_xa_loc *loc)
 {
-	int namevalue_size;
-	struct ocfs2_xattr_entry *entry = loc->xl_entry;
-	u64 value_size = le64_to_cpu(entry->xe_value_size);
-
-	namevalue_size = OCFS2_XATTR_SIZE(entry->xe_name_len);
-	if (value_size > OCFS2_XATTR_INLINE_SIZE)
-		namevalue_size += OCFS2_XATTR_ROOT_SIZE;
-	else
-		namevalue_size += OCFS2_XATTR_SIZE(value_size);
-
-	le16_add_cpu(&loc->xl_header->xh_name_value_len, -namevalue_size);
+	le16_add_cpu(&loc->xl_header->xh_name_value_len,
+		     -namevalue_size_xe(loc->xl_entry));
 }
 
 /* Operations for xattrs stored in buckets. */
@@ -1689,16 +1705,8 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 		offs = le16_to_cpu(xs->here->xe_name_offset);
 		val = xs->base + offs;
 
-		if (le64_to_cpu(xs->here->xe_value_size) >
-		    OCFS2_XATTR_INLINE_SIZE)
-			size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-				OCFS2_XATTR_ROOT_SIZE;
-		else
-			size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-			OCFS2_XATTR_SIZE(le64_to_cpu(xs->here->xe_value_size));
-
-		if (xi->xi_value && size == OCFS2_XATTR_SIZE(xi->xi_name_len) +
-				OCFS2_XATTR_SIZE(xi->xi_value_len)) {
+		size = namevalue_size_xe(xs->here);
+		if (xi->xi_value && (size == namevalue_size_xi(xi))) {
 			/* The old and the new value have the
 			   same size. Just replace the value. */
 			ocfs2_xattr_set_local(xs->here, 1);
@@ -1722,8 +1730,7 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 	}
 	if (xi->xi_value) {
 		/* Insert the new name+value. */
-		size_t size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-				OCFS2_XATTR_SIZE(xi->xi_value_len);
+		size_t size = namevalue_size_xi(xi);
 		void *val = xs->base + min_offs - size;
 
 		xs->here->xe_name_offset = cpu_to_le16(min_offs - size);
@@ -1794,41 +1801,25 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	if (free < 0)
 		return -EIO;
 
-	if (!xs->not_found) {
-		size_t size = 0;
-		if (ocfs2_xattr_is_local(xs->here))
-			size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-			OCFS2_XATTR_SIZE(le64_to_cpu(xs->here->xe_value_size));
-		else
-			size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-				OCFS2_XATTR_ROOT_SIZE;
-		free += (size + sizeof(struct ocfs2_xattr_entry));
-	}
+	if (!xs->not_found)
+		free += ocfs2_xe_entry_usage(xs->here);
+
 	/* Check free space in inode or block */
-	if (xi->xi_value && xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
-		if (free < sizeof(struct ocfs2_xattr_entry) +
-			   OCFS2_XATTR_SIZE(xi->xi_name_len) +
-			   OCFS2_XATTR_ROOT_SIZE) {
+	if (xi->xi_value) {
+		if (free < ocfs2_xi_entry_usage(xi)) {
 			ret = -ENOSPC;
 			goto out;
 		}
-		size_l = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-			OCFS2_XATTR_ROOT_SIZE;
-		xi_l.xi_value = (void *)&def_xv;
-		xi_l.xi_value_len = OCFS2_XATTR_ROOT_SIZE;
-	} else if (xi->xi_value) {
-		if (free < sizeof(struct ocfs2_xattr_entry) +
-			   OCFS2_XATTR_SIZE(xi->xi_name_len) +
-			   OCFS2_XATTR_SIZE(xi->xi_value_len)) {
-			ret = -ENOSPC;
-			goto out;
+		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
+			size_l = namevalue_size_xi(xi);
+			xi_l.xi_value = (void *)&def_xv;
+			xi_l.xi_value_len = OCFS2_XATTR_ROOT_SIZE;
 		}
 	}
 
 	if (!xs->not_found) {
 		/* For existing extended attribute */
-		size_t size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-			OCFS2_XATTR_SIZE(le64_to_cpu(xs->here->xe_value_size));
+		size_t size = namevalue_size_xe(xs->here);
 		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
 		void *val = xs->base + offs;
 
@@ -2595,7 +2586,6 @@ static int ocfs2_xattr_can_be_in_inode(struct inode *inode,
 				       struct ocfs2_xattr_info *xi,
 				       struct ocfs2_xattr_search *xs)
 {
-	u64 value_size;
 	struct ocfs2_xattr_entry *last;
 	int free, i;
 	size_t min_offs = xs->end - xs->base;
@@ -2618,13 +2608,7 @@ static int ocfs2_xattr_can_be_in_inode(struct inode *inode,
 
 	BUG_ON(!xs->not_found);
 
-	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
-		value_size = OCFS2_XATTR_ROOT_SIZE;
-	else
-		value_size = OCFS2_XATTR_SIZE(xi->xi_value_len);
-
-	if (free >= sizeof(struct ocfs2_xattr_entry) +
-		   OCFS2_XATTR_SIZE(xi->xi_name_len) + value_size)
+	if (free >= (sizeof(struct ocfs2_xattr_entry) + namevalue_size_xi(xi)))
 		return 1;
 
 	return 0;
@@ -3986,7 +3970,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 				     struct ocfs2_xattr_bucket *bucket)
 {
 	int ret, i;
-	size_t end, offset, len, value_len;
+	size_t end, offset, len;
 	struct ocfs2_xattr_header *xh;
 	char *entries, *buf, *bucket_buf = NULL;
 	u64 blkno = bucket_blkno(bucket);
@@ -4040,12 +4024,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	end = OCFS2_XATTR_BUCKET_SIZE;
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++, xe++) {
 		offset = le16_to_cpu(xe->xe_name_offset);
-		if (ocfs2_xattr_is_local(xe))
-			value_len = OCFS2_XATTR_SIZE(
-					le64_to_cpu(xe->xe_value_size));
-		else
-			value_len = OCFS2_XATTR_ROOT_SIZE;
-		len = OCFS2_XATTR_SIZE(xe->xe_name_len) + value_len;
+		len = namevalue_size_xe(xe);
 
 		/*
 		 * We must make sure that the name/value pair
@@ -4234,7 +4213,7 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 				    int new_bucket_head)
 {
 	int ret, i;
-	int count, start, len, name_value_len = 0, xe_len, name_offset = 0;
+	int count, start, len, name_value_len = 0, name_offset = 0;
 	struct ocfs2_xattr_bucket *s_bucket = NULL, *t_bucket = NULL;
 	struct ocfs2_xattr_header *xh;
 	struct ocfs2_xattr_entry *xe;
@@ -4325,13 +4304,7 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 	name_value_len = 0;
 	for (i = 0; i < start; i++) {
 		xe = &xh->xh_entries[i];
-		xe_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
-		if (ocfs2_xattr_is_local(xe))
-			xe_len +=
-			   OCFS2_XATTR_SIZE(le64_to_cpu(xe->xe_value_size));
-		else
-			xe_len += OCFS2_XATTR_ROOT_SIZE;
-		name_value_len += xe_len;
+		name_value_len += namevalue_size_xe(xe);
 		if (le16_to_cpu(xe->xe_name_offset) < name_offset)
 			name_offset = le16_to_cpu(xe->xe_name_offset);
 	}
@@ -4361,12 +4334,6 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 	xh->xh_free_start = cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE);
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
 		xe = &xh->xh_entries[i];
-		xe_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
-		if (ocfs2_xattr_is_local(xe))
-			xe_len +=
-			   OCFS2_XATTR_SIZE(le64_to_cpu(xe->xe_value_size));
-		else
-			xe_len += OCFS2_XATTR_ROOT_SIZE;
 		if (le16_to_cpu(xe->xe_name_offset) <
 		    le16_to_cpu(xh->xh_free_start))
 			xh->xh_free_start = xe->xe_name_offset;
@@ -5003,12 +4970,7 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 	if (!xs->not_found) {
 		xe = xs->here;
 		offs = le16_to_cpu(xe->xe_name_offset);
-		if (ocfs2_xattr_is_local(xe))
-			size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-			OCFS2_XATTR_SIZE(le64_to_cpu(xe->xe_value_size));
-		else
-			size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-			OCFS2_XATTR_SIZE(OCFS2_XATTR_ROOT_SIZE);
+		size = namevalue_size_xe(xe);
 
 		/*
 		 * If the new value will be stored outside, xi->xi_value has
@@ -5017,8 +4979,7 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 		 * new_size safely here.
 		 * See ocfs2_xattr_set_in_bucket.
 		 */
-		new_size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-			   OCFS2_XATTR_SIZE(xi->xi_value_len);
+		new_size = namevalue_size_xi(xi);
 
 		if (xi->xi_value) {
 			ocfs2_xa_wipe_namevalue(&loc);
@@ -5084,8 +5045,7 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 
 set_new_name_value:
 	/* Insert the new name+value. */
-	size = OCFS2_XATTR_SIZE(xi->xi_name_len) +
-		OCFS2_XATTR_SIZE(xi->xi_value_len);
+	size = namevalue_size_xi(xi);
 
 	/*
 	 * We must make sure that the name/value pair
-- 
1.6.3.3
