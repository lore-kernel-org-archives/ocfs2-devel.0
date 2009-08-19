From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 19 Aug 2009 12:54:27 -0700
Subject: [Ocfs2-devel] [PATCH 02/14] ocfs2: Remove xattrs via ocfs2_xa_loc
In-Reply-To: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1250711679-12441-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add ocfs2_xa_remove_entry(), which will remove an xattr entry from its
storage via the ocfs2_xa_loc descriptor.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   62 ++++++++++++++++++++++++-----------------------------
 1 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 953cf32..f42edb1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1520,7 +1520,28 @@ static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
 
 static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
 {
+	int index, count;
+	struct ocfs2_xattr_header *xh = loc->xl_header;
+	struct ocfs2_xattr_entry *entry = loc->xl_entry;
+
 	ocfs2_xa_wipe_namevalue(loc);
+
+	le16_add_cpu(&xh->xh_count, -1);
+	count = le16_to_cpu(xh->xh_count);
+
+	/*
+	 * Only zero out the entry if there are more remaining.  This is
+	 * important for an empty bucket, as it keeps track of the
+	 * bucket's hash value.  It doesn't hurt empty block storage.
+	 */
+	if (count) {
+		index = ((char *)entry - (char *)&xh->xh_entries) /
+			sizeof(struct ocfs2_xattr_entry);
+		memmove(&xh->xh_entries[index], &xh->xh_entries[index + 1],
+			(count - index) * sizeof(struct ocfs2_xattr_entry));
+		memset(&xh->xh_entries[count], 0,
+		       sizeof(struct ocfs2_xattr_entry));
+	}
 }
 
 static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
@@ -1585,7 +1606,6 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 					size_t min_offs)
 {
 	size_t name_len = strlen(xi->name);
-	int i;
 	struct ocfs2_xa_loc loc;
 
 	if (xs->xattr_bh == xs->inode_bh)
@@ -1633,26 +1653,12 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 			return;
 		}
 
-		/* Remove the old name+value. */
-		ocfs2_xa_wipe_namevalue(&loc);
-		xs->here->xe_name_hash = 0;
-		xs->here->xe_name_offset = 0;
-		ocfs2_xattr_set_local(xs->here, 1);
-		xs->here->xe_value_size = 0;
+		if (!xi->value)
+			ocfs2_xa_remove_entry(&loc);
+		else
+			ocfs2_xa_wipe_namevalue(&loc);
 
 		min_offs += size;
-
-		if (!xi->value) {
-			/* Remove the old entry. */
-			i = le16_to_cpu(xs->header->xh_count);
-			i--;
-			last = &xs->header->xh_entries[i - 1];
-			xs->header->xh_count = cpu_to_le16(i);
-
-			memmove(xs->here, xs->here + 1,
-				(void *)last - (void *)xs->here);
-			memset(last, 0, sizeof(struct ocfs2_xattr_entry));
-		}
 	}
 	if (xi->value) {
 		/* Insert the new name+value. */
@@ -4761,8 +4767,8 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 		new_size = OCFS2_XATTR_SIZE(name_len) +
 			   OCFS2_XATTR_SIZE(xi->value_len);
 
-		ocfs2_xa_wipe_namevalue(&loc);
 		if (xi->value) {
+			ocfs2_xa_wipe_namevalue(&loc);
 			if (new_size > size)
 				goto set_new_name_value;
 
@@ -4784,20 +4790,8 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 			ocfs2_xattr_set_local(xe, local);
 			return;
 		} else {
-			/*
-			 * Remove the old entry if there is more than one.
-			 * We don't remove the last entry so that we can
-			 * use it to indicate the hash value of the empty
-			 * bucket.
-			 */
-			last -= 1;
-			le16_add_cpu(&xh->xh_count, -1);
-			if (xh->xh_count) {
-				memmove(xe, xe + 1,
-					(void *)last - (void *)xe);
-				memset(last, 0,
-				       sizeof(struct ocfs2_xattr_entry));
-			} else
+			ocfs2_xa_remove_entry(&loc);
+			if (!xh->xh_count)
 				xh->xh_free_start =
 					cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE);
 
-- 
1.6.3.3
