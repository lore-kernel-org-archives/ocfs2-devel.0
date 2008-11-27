From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 26 Nov 2008 16:06:26 -0800
Subject: [Ocfs2-devel] [PATCH 13/13] ocfs2: Pass xs->bucket into
	ocfs2_add_new_xattr_bucket().
In-Reply-To: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1227744386-10502-14-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Pass the actual target bucket for insert through to
ocfs2_add_new_xattr_bucket().  Now growing a bucket has no buffer_head
knowledge.

ocfs2_add_new_xattr_bucket() leavs xs->bucket in the proper state for
insert.  However, it doesn't update the rest of the search fields in xs,
so we still have to relse() and re-find.  That's OK, because everything
is cached.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   52 +++++++++++++++++++++++++---------------------------
 1 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 57171d9..cb9617d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4322,43 +4322,42 @@ out:
 }
 
 /*
- * Add new xattr bucket in an extent record and adjust the buckets accordingly.
- * xb_bh is the ocfs2_xattr_block.
- * We will move all the buckets starting from header_bh to the next place. As
- * for this one, half num of its xattrs will be moved to the next one.
+ * Add new xattr bucket in an extent record and adjust the buckets
+ * accordingly.  xb_bh is the ocfs2_xattr_block, and target is the
+ * bucket we want to insert into.
  *
- * We will allocate a new cluster if current cluster is full.  The
- * underlying calls will make sure that there is space at the target
- * bucket, shifting buckets around if necessary.  'target' may be updated
- * by those calls.
+ * In the easy case, we will move all the buckets after target down by
+ * one. Half of target's xattrs will be moved to the next bucket.
+ *
+ * If current cluster is full, we'll allocate a new one.  This may not
+ * be contiguous.  The underlying calls will make sure that there is
+ * space for the insert, shifting buckets around if necessary.
+ * 'target' may be moved by those calls.
  */
 static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 				      struct buffer_head *xb_bh,
-				      struct buffer_head *header_bh,
+				      struct ocfs2_xattr_bucket *target,
 				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct ocfs2_xattr_block *xb =
 			(struct ocfs2_xattr_block *)xb_bh->b_data;
 	struct ocfs2_xattr_tree_root *xb_root = &xb->xb_attrs.xb_root;
 	struct ocfs2_extent_list *el = &xb_root->xt_list;
-	struct ocfs2_xattr_header *xh =
-			(struct ocfs2_xattr_header *)header_bh->b_data;
-	u32 name_hash = le32_to_cpu(xh->xh_entries[0].xe_name_hash);
+	u32 name_hash =
+		le32_to_cpu(bucket_xh(target)->xh_entries[0].xe_name_hash);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int ret, num_buckets, extend = 1;
 	u64 p_blkno;
 	u32 e_cpos, num_clusters;
 	/* The bucket at the front of the extent */
-	struct ocfs2_xattr_bucket *first, *target;
+	struct ocfs2_xattr_bucket *first;
 
-	mlog(0, "Add new xattr bucket starting form %llu\n",
-	     (unsigned long long)header_bh->b_blocknr);
+	mlog(0, "Add new xattr bucket starting from %llu\n",
+	     (unsigned long long)bucket_blkno(target));
 
 	/* The first bucket of the original extent */
 	first = ocfs2_xattr_bucket_new(inode);
-	/* The target bucket for insert */
-	target = ocfs2_xattr_bucket_new(inode);
-	if (!first || !target) {
+	if (!first) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
@@ -4377,12 +4376,6 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_read_xattr_bucket(target, header_bh->b_blocknr);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	num_buckets = ocfs2_xattr_buckets_per_cluster(osb) * num_clusters;
 	if (num_buckets == le16_to_cpu(bucket_xh(first)->xh_num_buckets)) {
 		/*
@@ -4415,7 +4408,6 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 
 out:
 	ocfs2_xattr_bucket_free(first);
-	ocfs2_xattr_bucket_free(target);
 
 	return ret;
 }
@@ -5119,15 +5111,21 @@ try_again:
 
 		ret = ocfs2_add_new_xattr_bucket(inode,
 						 xs->xattr_bh,
-						 xs->bucket->bu_bhs[0],
+						 xs->bucket,
 						 ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 
+		/*
+		 * ocfs2_add_new_xattr_bucket() will have updated
+		 * xs->bucket if it moved, but it will not have updated
+		 * any of the other search fields.  Thus, we drop it and
+		 * re-search.  Everything should be cached, so it'll be
+		 * quick.
+		 */
 		ocfs2_xattr_bucket_relse(xs->bucket);
-
 		ret = ocfs2_xattr_index_block_find(inode, xs->xattr_bh,
 						   xi->name_index,
 						   xi->name, xs);
-- 
1.5.6.5
