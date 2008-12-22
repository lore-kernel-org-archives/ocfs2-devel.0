From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:26 -0800
Subject: [Ocfs2-devel] [PATCH 45/56] ocfs2: Dirty the entire first bucket in
	ocfs2_cp_xattr_cluster().
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-46-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

ocfs2_cp_xattr_cluster() takes the last bucket of a full extent and
copies it over to a new extent.  It then updates the headers of both
extents to reflect the new state.  It is passed the first bh of
the first bucket in order to update that first extent's bucket count.
It reads and dirties the first bh of the new extent for the same reason.

However, future code wants to always dirty the entire bucket when it
is changed.  So it is changed to read the entire bucket it is updating
for both extents.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   80 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index ed1e959..4dba347 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3936,9 +3936,10 @@ out:
 }
 
 /*
- * Copy one xattr cluster from src_blk to to_blk.
- * The to_blk will become the first bucket header of the cluster, so its
- * xh_num_buckets will be initialized as the bucket num in the cluster.
+ * src_blk points to the last cluster of an existing extent.  to_blk
+ * points to a newly allocated extent.  We copy the cluster over to the
+ * new extent, initializing its xh_num_buckets.  The old extent's
+ * xh_num_buckets shrinks by the same amount.
  */
 static int ocfs2_cp_xattr_cluster(struct inode *inode,
 				  handle_t *handle,
@@ -3950,27 +3951,42 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 	int i, ret, credits;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+	int blks_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	int num_buckets = ocfs2_xattr_buckets_per_cluster(osb);
-	struct buffer_head *bh = NULL;
-	struct ocfs2_xattr_header *xh;
-	u64 to_blk_start = to_blk;
+	struct ocfs2_xattr_bucket *old_first, *new_first;
 
 	mlog(0, "cp xattrs from cluster %llu to %llu\n",
 	     (unsigned long long)src_blk, (unsigned long long)to_blk);
 
+	/* The first bucket of the original extent */
+	old_first = ocfs2_xattr_bucket_new(inode);
+	/* The first bucket of the new extent */
+	new_first = ocfs2_xattr_bucket_new(inode);
+	if (!old_first || !new_first) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_xattr_bucket(old_first, first_bh->b_blocknr);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
 	/*
-	 * We need to update the new cluster and 1 more for the update of
-	 * the 1st bucket of the previous extent rec.
+	 * We need to update the first bucket of the old extent and the
+	 * entire first cluster of the new extent.
 	 */
-	credits = bpc + 1 + handle->h_buffer_credits;
+	credits = blks_per_bucket + bpc + handle->h_buffer_credits;
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, first_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_xattr_bucket_journal_access(handle, old_first,
+						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3978,45 +3994,45 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 
 	for (i = 0; i < num_buckets; i++) {
 		ret = ocfs2_cp_xattr_bucket(inode, handle,
-					    src_blk, to_blk, 1);
+					    src_blk + (i * blks_per_bucket),
+					    to_blk + (i * blks_per_bucket),
+					    1);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
-
-		src_blk += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-		to_blk += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	}
 
-	/* update the old bucket header. */
-	xh = (struct ocfs2_xattr_header *)first_bh->b_data;
-	le16_add_cpu(&xh->xh_num_buckets, -num_buckets);
-
-	ocfs2_journal_dirty(handle, first_bh);
-
-	/* update the new bucket header. */
-	ret = ocfs2_read_block(inode, to_blk_start, &bh, NULL);
-	if (ret < 0) {
+	/*
+	 * Get the new bucket ready before we dirty anything
+	 * (This actually shouldn't fail, because we already dirtied
+	 * it once in ocfs2_cp_xattr_bucket()).
+	 */
+	ret = ocfs2_read_xattr_bucket(new_first, to_blk);
+	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
-
-	ret = ocfs2_journal_access(handle, inode, bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_xattr_bucket_journal_access(handle, new_first,
+						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	xh = (struct ocfs2_xattr_header *)bh->b_data;
-	xh->xh_num_buckets = cpu_to_le16(num_buckets);
+	/* Now update the headers */
+	le16_add_cpu(&bucket_xh(old_first)->xh_num_buckets, -num_buckets);
+	ocfs2_xattr_bucket_journal_dirty(handle, old_first);
 
-	ocfs2_journal_dirty(handle, bh);
+	bucket_xh(new_first)->xh_num_buckets = cpu_to_le16(num_buckets);
+	ocfs2_xattr_bucket_journal_dirty(handle, new_first);
 
 	if (first_hash)
-		*first_hash = le32_to_cpu(xh->xh_entries[0].xe_name_hash);
+		*first_hash = le32_to_cpu(bucket_xh(new_first)->xh_entries[0].xe_name_hash);
+
 out:
-	brelse(bh);
+	ocfs2_xattr_bucket_free(new_first);
+	ocfs2_xattr_bucket_free(old_first);
 	return ret;
 }
 
-- 
1.5.6
