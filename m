From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:50 -0800
Subject: [Ocfs2-devel] [PATCH 13/18] ocfs2: Pass ocfs2_xattr_value_buf into
	ocfs2_xattr_value_truncate().
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-14-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The callers of ocfs2_xattr_value_truncate() now pass in
ocfs2_xattr_value_bufs.  These callers are the ones that calculated the
xv location, so they are the right starting point.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   66 +++++++++++++++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a53f49d..316bc37 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -718,19 +718,13 @@ out:
 }
 
 static int ocfs2_xattr_value_truncate(struct inode *inode,
-				      struct buffer_head *root_bh,
-				      struct ocfs2_xattr_value_root *xv,
+				      struct ocfs2_xattr_value_buf *vb,
 				      int len,
 				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret;
 	u32 new_clusters = ocfs2_clusters_for_bytes(inode->i_sb, len);
-	u32 old_clusters = le32_to_cpu(xv->xr_clusters);
-	struct ocfs2_xattr_value_buf vb = {
-		.vb_bh = root_bh,
-		.vb_xv = xv,
-		.vb_access = ocfs2_journal_access,
-	};
+	u32 old_clusters = le32_to_cpu(vb->vb_xv->xr_clusters);
 
 	if (new_clusters == old_clusters)
 		return 0;
@@ -738,11 +732,11 @@ static int ocfs2_xattr_value_truncate(struct inode *inode,
 	if (new_clusters > old_clusters)
 		ret = ocfs2_xattr_extend_allocation(inode,
 						    new_clusters - old_clusters,
-						    &vb, ctxt);
+						    vb, ctxt);
 	else
 		ret = ocfs2_xattr_shrink_size(inode,
 					      old_clusters, new_clusters,
-					      &vb, ctxt);
+					      vb, ctxt);
 
 	return ret;
 }
@@ -1330,6 +1324,10 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 	struct ocfs2_xattr_value_root *xv = NULL;
 	size_t size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
 	int ret = 0;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = xs->xattr_bh,
+		.vb_access = ocfs2_journal_access
+	};
 
 	memset(val, 0, size);
 	memcpy(val, xi->name, name_len);
@@ -1340,9 +1338,9 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 	xv->xr_list.l_tree_depth = 0;
 	xv->xr_list.l_count = cpu_to_le16(1);
 	xv->xr_list.l_next_free_rec = 0;
+	vb.vb_xv = xv;
 
-	ret = ocfs2_xattr_value_truncate(inode, xs->xattr_bh, xv,
-					 xi->value_len, ctxt);
+	ret = ocfs2_xattr_value_truncate(inode, &vb, xi->value_len, ctxt);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -1352,7 +1350,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, xv,
+	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, vb.vb_xv,
 					      xi->value, xi->value_len);
 	if (ret < 0)
 		mlog_errno(ret);
@@ -1550,9 +1548,12 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 			goto out;
 		} else if (!ocfs2_xattr_is_local(xs->here)) {
 			/* For existing xattr which has value outside */
-			struct ocfs2_xattr_value_root *xv = NULL;
-			xv = (struct ocfs2_xattr_value_root *)(val +
-				OCFS2_XATTR_SIZE(name_len));
+			struct ocfs2_xattr_value_buf vb = {
+				.vb_bh = xs->xattr_bh,
+				.vb_xv = (struct ocfs2_xattr_value_root *)
+					(val + OCFS2_XATTR_SIZE(name_len)),
+				.vb_access = ocfs2_journal_access,
+			};
 
 			if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
 				/*
@@ -1561,8 +1562,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				 * then set new value with set_value_outside().
 				 */
 				ret = ocfs2_xattr_value_truncate(inode,
-								 xs->xattr_bh,
-								 xv,
+								 &vb,
 								 xi->value_len,
 								 ctxt);
 				if (ret < 0) {
@@ -1582,7 +1582,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 
 				ret = __ocfs2_xattr_set_value_outside(inode,
 								handle,
-								xv,
+								vb.vb_xv,
 								xi->value,
 								xi->value_len);
 				if (ret < 0)
@@ -1594,8 +1594,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				 * just trucate old value to zero.
 				 */
 				 ret = ocfs2_xattr_value_truncate(inode,
-								  xs->xattr_bh,
-								  xv,
+								  &vb,
 								  0,
 								  ctxt);
 				if (ret < 0)
@@ -1714,15 +1713,17 @@ static int ocfs2_remove_value_outside(struct inode*inode,
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
 
 		if (!ocfs2_xattr_is_local(entry)) {
-			struct ocfs2_xattr_value_root *xv;
+			struct ocfs2_xattr_value_buf vb = {
+				.vb_bh = bh,
+				.vb_access = ocfs2_journal_access,
+			};
 			void *val;
 
 			val = (void *)header +
 				le16_to_cpu(entry->xe_name_offset);
-			xv = (struct ocfs2_xattr_value_root *)
+			vb.vb_xv = (struct ocfs2_xattr_value_root *)
 				(val + OCFS2_XATTR_SIZE(entry->xe_name_len));
-			ret = ocfs2_xattr_value_truncate(inode, bh, xv,
-							 0, &ctxt);
+			ret = ocfs2_xattr_value_truncate(inode, &vb, 0, &ctxt);
 			if (ret < 0) {
 				mlog_errno(ret);
 				break;
@@ -4659,11 +4660,12 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 {
 	int ret, offset;
 	u64 value_blk;
-	struct buffer_head *value_bh = NULL;
-	struct ocfs2_xattr_value_root *xv;
 	struct ocfs2_xattr_entry *xe;
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	size_t blocksize = inode->i_sb->s_blocksize;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_access = ocfs2_journal_access,
+	};
 
 	xe = &xh->xh_entries[xe_off];
 
@@ -4677,11 +4679,11 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 	/* We don't allow ocfs2_xattr_value to be stored in different block. */
 	BUG_ON(value_blk != (offset + OCFS2_XATTR_ROOT_SIZE - 1) / blocksize);
 
-	value_bh = bucket->bu_bhs[value_blk];
-	BUG_ON(!value_bh);
+	vb.vb_bh = bucket->bu_bhs[value_blk];
+	BUG_ON(!vb.vb_bh);
 
-	xv = (struct ocfs2_xattr_value_root *)
-		(value_bh->b_data + offset % blocksize);
+	vb.vb_xv = (struct ocfs2_xattr_value_root *)
+		(vb.vb_bh->b_data + offset % blocksize);
 
 	ret = ocfs2_xattr_bucket_journal_access(ctxt->handle, bucket,
 						OCFS2_JOURNAL_ACCESS_WRITE);
@@ -4699,7 +4701,7 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 	 */
 	mlog(0, "truncate %u in xattr bucket %llu to %d bytes.\n",
 	     xe_off, (unsigned long long)bucket_blkno(bucket), len);
-	ret = ocfs2_xattr_value_truncate(inode, value_bh, xv, len, ctxt);
+	ret = ocfs2_xattr_value_truncate(inode, &vb, len, ctxt);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_dirty;
-- 
1.5.6.5
