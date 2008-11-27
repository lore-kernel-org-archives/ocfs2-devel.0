From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 26 Nov 2008 16:06:25 -0800
Subject: [Ocfs2-devel] [PATCH 12/13] ocfs2: Move buckets up into
	ocfs2_add_new_xattr_bucket().
In-Reply-To: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1227744386-10502-13-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Lift the buckets from ocfs2_add_new_xattr_cluster() up into
ocfs2_add_new_xattr_bucket().  Now ocfs2_add_new_xattr_cluster()
doesn't deal with buffer_heads.  In fact, we no longer have to play
get_bh() tricks at all.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  103 +++++++++++++++++-------------------------------------
 1 files changed, 32 insertions(+), 71 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b9128aa..57171d9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4154,11 +4154,10 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
  */
 static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 				       struct buffer_head *root_bh,
-				       struct buffer_head **first_bh,
-				       struct buffer_head **header_bh,
+				       struct ocfs2_xattr_bucket *first,
+				       struct ocfs2_xattr_bucket *target,
 				       u32 *num_clusters,
 				       u32 prev_cpos,
-				       u64 prev_blkno,
 				       int *extend,
 				       struct ocfs2_xattr_set_ctxt *ctxt)
 {
@@ -4170,38 +4169,14 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	handle_t *handle = ctxt->handle;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
-	struct ocfs2_xattr_bucket *first, *target;
 
 	mlog(0, "Add new xattr cluster for %llu, previous xattr hash = %u, "
 	     "previous xattr blkno = %llu\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     prev_cpos, (unsigned long long)prev_blkno);
+	     prev_cpos, (unsigned long long)bucket_blkno(first));
 
 	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
 
-	/* The first bucket of the original extent */
-	first = ocfs2_xattr_bucket_new(inode);
-	/* The target bucket for insert */
-	target = ocfs2_xattr_bucket_new(inode);
-	if (!first || !target) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto leave;
-	}
-
-	BUG_ON(prev_blkno != (*first_bh)->b_blocknr);
-	ret = ocfs2_read_xattr_bucket(first, prev_blkno);
-	if (ret) {
-		mlog_errno(ret);
-		goto leave;
-	}
-
-	ret = ocfs2_read_xattr_bucket(target, (*header_bh)->b_blocknr);
-	if (ret) {
-		mlog_errno(ret);
-		goto leave;
-	}
-
 	ret = ocfs2_journal_access(handle, inode, root_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
@@ -4223,7 +4198,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	mlog(0, "Allocating %u clusters@block %u for xattr in inode %llu\n",
 	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	if (prev_blkno + prev_clusters * bpc == block &&
+	if (bucket_blkno(first) + (prev_clusters * bpc) == block &&
 	    (prev_clusters + num_bits) << osb->s_clustersize_bits <=
 	     OCFS2_MAX_XATTR_TREE_LEAF_SIZE) {
 		/*
@@ -4252,17 +4227,6 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 			mlog_errno(ret);
 			goto leave;
 		}
-
-		/* Did first+target get moved? */
-		if (prev_blkno != bucket_blkno(first)) {
-			brelse(*first_bh);
-			*first_bh = first->bu_bhs[0];
-			get_bh(*first_bh);
-
-			brelse(*header_bh);
-			*header_bh = target->bu_bhs[0];
-			get_bh(*header_bh);
-		}
 	}
 
 	mlog(0, "Insert %u clusters at block %llu for xattr at %u\n",
@@ -4363,16 +4327,16 @@ out:
  * We will move all the buckets starting from header_bh to the next place. As
  * for this one, half num of its xattrs will be moved to the next one.
  *
- * We will allocate a new cluster if current cluster is full and adjust
- * header_bh and first_bh if the insert place is moved to the new cluster.
+ * We will allocate a new cluster if current cluster is full.  The
+ * underlying calls will make sure that there is space at the target
+ * bucket, shifting buckets around if necessary.  'target' may be updated
+ * by those calls.
  */
 static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 				      struct buffer_head *xb_bh,
 				      struct buffer_head *header_bh,
 				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	struct ocfs2_xattr_header *first_xh = NULL;
-	struct buffer_head *first_bh = NULL;
 	struct ocfs2_xattr_block *xb =
 			(struct ocfs2_xattr_block *)xb_bh->b_data;
 	struct ocfs2_xattr_tree_root *xb_root = &xb->xb_attrs.xb_root;
@@ -4380,31 +4344,26 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 	struct ocfs2_xattr_header *xh =
 			(struct ocfs2_xattr_header *)header_bh->b_data;
 	u32 name_hash = le32_to_cpu(xh->xh_entries[0].xe_name_hash);
-	struct super_block *sb = inode->i_sb;
-	struct ocfs2_super *osb = OCFS2_SB(sb);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int ret, num_buckets, extend = 1;
 	u64 p_blkno;
 	u32 e_cpos, num_clusters;
 	/* The bucket at the front of the extent */
-	struct ocfs2_xattr_bucket *first;
+	struct ocfs2_xattr_bucket *first, *target;
 
 	mlog(0, "Add new xattr bucket starting form %llu\n",
 	     (unsigned long long)header_bh->b_blocknr);
 
+	/* The first bucket of the original extent */
 	first = ocfs2_xattr_bucket_new(inode);
-	if (!first) {
+	/* The target bucket for insert */
+	target = ocfs2_xattr_bucket_new(inode);
+	if (!first || !target) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
 	}
 
-	/*
-	 * Add refrence for header_bh here because it may be
-	 * changed in ocfs2_add_new_xattr_cluster and we need
-	 * to free it in the end.
-	 */
-	get_bh(header_bh);
-
 	ret = ocfs2_xattr_get_rec(inode, name_hash, &p_blkno, &e_cpos,
 				  &num_clusters, el);
 	if (ret) {
@@ -4412,23 +4371,30 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_read_block(inode, p_blkno, &first_bh, NULL);
+	ret = ocfs2_read_xattr_bucket(first, p_blkno);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	num_buckets = ocfs2_xattr_buckets_per_cluster(osb) * num_clusters;
-	first_xh = (struct ocfs2_xattr_header *)first_bh->b_data;
+	ret = ocfs2_read_xattr_bucket(target, header_bh->b_blocknr);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
-	if (num_buckets == le16_to_cpu(first_xh->xh_num_buckets)) {
+	num_buckets = ocfs2_xattr_buckets_per_cluster(osb) * num_clusters;
+	if (num_buckets == le16_to_cpu(bucket_xh(first)->xh_num_buckets)) {
+		/*
+		 * This can move first+target if the target bucket moves
+		 * to the new extent.
+		 */
 		ret = ocfs2_add_new_xattr_cluster(inode,
 						  xb_bh,
-						  &first_bh,
-						  &header_bh,
+						  first,
+						  target,
 						  &num_clusters,
 						  e_cpos,
-						  p_blkno,
 						  &extend,
 						  ctxt);
 		if (ret) {
@@ -4438,24 +4404,19 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 	}
 
 	if (extend) {
-		/* These bucket reads should be cached */
-		ret = ocfs2_read_xattr_bucket(first, first_bh->b_blocknr);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
 		ret = ocfs2_extend_xattr_bucket(inode,
 						ctxt->handle,
-						first, header_bh->b_blocknr,
+						first,
+						bucket_blkno(target),
 						num_clusters);
 		if (ret)
 			mlog_errno(ret);
 	}
 
 out:
-	brelse(first_bh);
-	brelse(header_bh);
 	ocfs2_xattr_bucket_free(first);
+	ocfs2_xattr_bucket_free(target);
+
 	return ret;
 }
 
-- 
1.5.6.5
