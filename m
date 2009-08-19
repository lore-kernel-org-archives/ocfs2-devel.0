From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 19 Aug 2009 12:54:33 -0700
Subject: [Ocfs2-devel] [PATCH 08/14] ocfs2: Provide
	ocfs2_xa_fill_value_buf() for external value processing
In-Reply-To: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1250711679-12441-9-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We use the ocfs2_xattr_value_buf structure to manage external values.
It lets the value tree code do its work regardless of the containing
storage.  ocfs2_xa_fill_value_buf() initializes a value buf from an
ocfs2_xa_loc entry.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0f24e0a..b867aa0 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -175,6 +175,13 @@ struct ocfs2_xa_loc_operations {
 
 	/* Add name+value storage to an entry */
 	void (*xlo_add_namevalue)(struct ocfs2_xa_loc *loc, int size);
+
+	/*
+	 * Initialize the value buf's access and bh fields for this entry.
+	 * ocfs2_xa_fill_value_buf() will handle the xv pointer.
+	 */
+	void (*xlo_fill_value_buf)(struct ocfs2_xa_loc *loc,
+				   struct ocfs2_xattr_value_buf *vb);
 };
 
 /*
@@ -1546,6 +1553,23 @@ static void ocfs2_xa_add_namevalue(struct ocfs2_xa_loc *loc,
 	memcpy(nameval_buf, xi->xi_name, xi->xi_name_len);
 }
 
+static void ocfs2_xa_fill_value_buf(struct ocfs2_xa_loc *loc,
+				    struct ocfs2_xattr_value_buf *vb)
+{
+	int nameval_offset = le16_to_cpu(loc->xl_entry->xe_name_offset);
+	int name_size = OCFS2_XATTR_SIZE(loc->xl_entry->xe_name_len);
+
+	/* Value bufs are for value trees */
+	BUG_ON(namevalue_size_xe(loc->xl_entry) !=
+	       (name_size + OCFS2_XATTR_ROOT_SIZE));
+
+	loc->xl_ops->xlo_fill_value_buf(loc, vb);
+	vb->vb_xv =
+		(struct ocfs2_xattr_value_root *)ocfs2_xa_offset_pointer(loc,
+							nameval_offset +
+							name_size);
+}
+
 static void *ocfs2_xa_block_offset_pointer(struct ocfs2_xa_loc *loc,
 					   int offset)
 {
@@ -1656,6 +1680,20 @@ static void ocfs2_xa_block_add_namevalue(struct ocfs2_xa_loc *loc, int size)
 	loc->xl_entry->xe_name_offset = cpu_to_le16(free_start - size);
 }
 
+static void ocfs2_xa_block_fill_value_buf(struct ocfs2_xa_loc *loc,
+					  struct ocfs2_xattr_value_buf *vb)
+{
+	struct buffer_head *bh = loc->xl_storage;
+
+	if (loc->xl_size == (bh->b_size -
+			     offsetof(struct ocfs2_xattr_block,
+				      xb_attrs.xb_header)))
+		vb->vb_access = ocfs2_journal_access_xb;
+	else
+		vb->vb_access = ocfs2_journal_access_di;
+	vb->vb_bh = bh;
+}
+
 /*
  * Operations for xattrs stored in blocks.  This includes inline inode
  * storage and unindexed ocfs2_xattr_blocks.
@@ -1668,6 +1706,7 @@ static const struct ocfs2_xa_loc_operations ocfs2_xa_block_loc_ops = {
 	.xlo_wipe_namevalue	= ocfs2_xa_block_wipe_namevalue,
 	.xlo_add_entry		= ocfs2_xa_block_add_entry,
 	.xlo_add_namevalue	= ocfs2_xa_block_add_namevalue,
+	.xlo_fill_value_buf	= ocfs2_xa_block_fill_value_buf,
 };
 
 static void *ocfs2_xa_bucket_offset_pointer(struct ocfs2_xa_loc *loc,
@@ -1797,6 +1836,25 @@ static void ocfs2_xa_bucket_add_namevalue(struct ocfs2_xa_loc *loc, int size)
 
 }
 
+static void ocfs2_xa_bucket_fill_value_buf(struct ocfs2_xa_loc *loc,
+					   struct ocfs2_xattr_value_buf *vb)
+{
+	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
+	struct super_block *sb = bucket->bu_inode->i_sb;
+	int nameval_offset = le16_to_cpu(loc->xl_entry->xe_name_offset);
+	int size = namevalue_size_xe(loc->xl_entry);
+	int block_offset = nameval_offset >> sb->s_blocksize_bits;
+
+	/* Values are not allowed to straddle block boundaries */
+	BUG_ON(block_offset !=
+	       ((nameval_offset + size - 1) >> sb->s_blocksize_bits));
+	/* We expect the bucket to be filled in */
+	BUG_ON(!bucket->bu_bhs[block_offset]);
+
+	vb->vb_access = ocfs2_journal_access;
+	vb->vb_bh = bucket->bu_bhs[block_offset];
+}
+
 /* Operations for xattrs stored in buckets. */
 static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
 	.xlo_offset_pointer	= ocfs2_xa_bucket_offset_pointer,
@@ -1806,6 +1864,7 @@ static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
 	.xlo_wipe_namevalue	= ocfs2_xa_bucket_wipe_namevalue,
 	.xlo_add_entry		= ocfs2_xa_bucket_add_entry,
 	.xlo_add_namevalue	= ocfs2_xa_bucket_add_namevalue,
+	.xlo_fill_value_buf	= ocfs2_xa_bucket_fill_value_buf,
 };
 
 static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
-- 
1.6.3.3
