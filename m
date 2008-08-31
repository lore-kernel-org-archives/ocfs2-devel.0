From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  1 Sep 2008 02:40:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up ocfs2_journal_dirty mess in
	xattr.c
Message-ID: <1220208013-5682-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In xattr.c, ocfs2_journal_dirty is called in many places, but they
are quite a mess, some are called with their return value checked,
some are not and in ocfs2_half_xattr_bucket there is even a bug which
we don't set the return value while checking  it. So this patch go
through all the places we call ocfs2_journal_dirty and add the check
for return value.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   84 +++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 61 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2ccffb1..f87bbf1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1842,7 +1842,9 @@ static int ocfs2_restore_xattr_block(struct inode *inode,
 
 	xb->xb_flags = cpu_to_le16(xb_flags & ~OCFS2_XATTR_INDEXED);
 
-	ocfs2_journal_dirty(handle, xs->xattr_bh);
+	ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
+	if (ret)
+		mlog_errno(ret);
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
@@ -1928,7 +1930,6 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		xs->end = (void *)xblk + inode->i_sb->s_blocksize;
 		xs->here = xs->header->xh_entries;
 
-
 		ret = ocfs2_journal_dirty(handle, new_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2824,9 +2825,19 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 
 	ocfs2_cp_xattr_block_to_bucket(inode, xb_bh, xh_bh, data_bh);
 
-	ocfs2_journal_dirty(handle, xh_bh);
-	if (data_bh)
-		ocfs2_journal_dirty(handle, data_bh);
+	ret = ocfs2_journal_dirty(handle, xh_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	if (data_bh) {
+		ret = ocfs2_journal_dirty(handle, data_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+	}
 
 	ocfs2_xattr_update_xattr_search(inode, xs, xb_bh, xh_bh);
 
@@ -2848,10 +2859,8 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	xb->xb_flags = cpu_to_le16(xb_flags | OCFS2_XATTR_INDEXED);
 
 	ret = ocfs2_journal_dirty(handle, xb_bh);
-	if (ret) {
+	if (ret)
 		mlog_errno(ret);
-		goto out_commit;
-	}
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
@@ -3015,7 +3024,11 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	buf = bucket_buf;
 	for (i = 0; i < blk_per_bucket; i++, buf += blocksize) {
 		memcpy(bhs[i]->b_data, buf, blocksize);
-		ocfs2_journal_dirty(handle, bhs[i]);
+		ret = ocfs2_journal_dirty(handle, bhs[i]);
+		if (ret) {
+			mlog_errno(ret);
+			goto commit;
+		}
 	}
 
 commit:
@@ -3131,7 +3144,11 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 			get_bh(new_first_bh);
 		}
 
-		ocfs2_journal_dirty(handle, new_bh);
+		ret = ocfs2_journal_dirty(handle, new_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 
 		if (*header_bh == old_bh) {
 			brelse(*header_bh);
@@ -3148,7 +3165,9 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 
 	le16_add_cpu(&xh->xh_num_buckets, -(num_buckets / 2));
 
-	ocfs2_journal_dirty(handle, prev_bh);
+	ret = ocfs2_journal_dirty(handle, prev_bh);
+	if (ret)
+		mlog_errno(ret);
 out:
 	brelse(prev_bh);
 	brelse(new_first_bh);
@@ -3312,9 +3331,11 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 		xh->xh_num_buckets = 0;
 
 	for (i = 0; i < blk_per_bucket; i++) {
-		ocfs2_journal_dirty(handle, t_bhs[i]);
-		if (ret)
+		ret = ocfs2_journal_dirty(handle, t_bhs[i]);
+		if (ret) {
 			mlog_errno(ret);
+			goto out;
+		}
 	}
 
 	/* store the first_hash of the new bucket. */
@@ -3332,7 +3353,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	xh->xh_free_start = cpu_to_le16(name_offset);
 	xh->xh_name_value_len = cpu_to_le16(name_value_len);
 
-	ocfs2_journal_dirty(handle, s_bhs[0]);
+	ret = ocfs2_journal_dirty(handle, s_bhs[0]);
 	if (ret)
 		mlog_errno(ret);
 
@@ -3403,7 +3424,11 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 
 	for (i = 0; i < blk_per_bucket; i++) {
 		memcpy(t_bhs[i]->b_data, s_bhs[i]->b_data, blocksize);
-		ocfs2_journal_dirty(handle, t_bhs[i]);
+		ret = ocfs2_journal_dirty(handle, t_bhs[i]);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 	}
 
 out:
@@ -3478,7 +3503,11 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 	xh = (struct ocfs2_xattr_header *)first_bh->b_data;
 	le16_add_cpu(&xh->xh_num_buckets, -num_buckets);
 
-	ocfs2_journal_dirty(handle, first_bh);
+	ret = ocfs2_journal_dirty(handle, first_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
 	/* update the new bucket header. */
 	ret = ocfs2_read_block(osb, to_blk_start, &bh, OCFS2_BH_CACHED, inode);
@@ -3497,7 +3526,11 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 	xh = (struct ocfs2_xattr_header *)bh->b_data;
 	xh->xh_num_buckets = cpu_to_le16(num_buckets);
 
-	ocfs2_journal_dirty(handle, bh);
+	ret = ocfs2_journal_dirty(handle, bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
 	if (first_hash)
 		*first_hash = le32_to_cpu(xh->xh_entries[0].xe_name_hash);
@@ -3727,10 +3760,8 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	}
 
 	ret = ocfs2_journal_dirty(handle, root_bh);
-	if (ret < 0) {
+	if (ret < 0)
 		mlog_errno(ret);
-		goto leave;
-	}
 
 leave:
 	if (handle)
@@ -3803,7 +3834,9 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 				      start_blk + blk_per_bucket, NULL, 0);
 
 	le16_add_cpu(&first_xh->xh_num_buckets, 1);
-	ocfs2_journal_dirty(handle, first_bh);
+	ret = ocfs2_journal_dirty(handle, first_bh);
+	if (ret)
+		mlog_errno(ret);
 
 commit:
 	ocfs2_commit_trans(osb, handle);
@@ -4057,8 +4090,10 @@ static int ocfs2_xattr_bucket_handle_journal(struct inode *inode,
 	 * and journal_dirty. The first block should always be touched.
 	 */
 	ret = ocfs2_journal_dirty(handle, bhs[0]);
-	if (ret)
+	if (ret) {
 		mlog_errno(ret);
+		goto out;
+	}
 
 	/* calc the data. */
 	off = le16_to_cpu(xe->xe_name_offset);
@@ -4067,6 +4102,7 @@ static int ocfs2_xattr_bucket_handle_journal(struct inode *inode,
 	if (ret)
 		mlog_errno(ret);
 
+out:
 	return ret;
 }
 
@@ -4325,7 +4361,9 @@ static int ocfs2_rm_xattr_bucket(struct inode *inode,
 
 	/* update the first_bh. */
 	xh->xh_num_buckets = cpu_to_le16(bucket_num - 1);
-	ocfs2_journal_dirty(handle, first_bh);
+	ret = ocfs2_journal_dirty(handle, first_bh);
+	if (ret)
+		mlog_errno(ret);
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
-- 
1.5.4.GIT
