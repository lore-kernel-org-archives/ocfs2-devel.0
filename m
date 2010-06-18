From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 18 Jun 2010 11:29:44 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Make xattr reflink work with new
	local alloc reservation.
In-Reply-To: <1276830171-5908-2-git-send-email-tao.ma@oracle.com>
References: <1276830171-5908-2-git-send-email-tao.ma@oracle.com>
Message-ID: <1276831784-6159-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/18/2010 11:02 AM, Tao Ma wrote:
> The new reservation code in local alloc has add the limitation
> that the caller should handle the case that the local alloc
> doesn't give use enough contiguous clusters. It make the old
> xattr reflink code broken.
> 
> So this patch udpate the xattr reflink code so that it can
> handle the case that local alloc give us one cluster at a time.
> 
> Signed-off-by: Tao Ma<tao.ma@oralce.com>
oh, I used the wrong sob here. ;) Here is the updated one.

Regards,
Tao

From 5b714e5a16c6ff912fcd720b916d4324f6151d16 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 18 Jun 2010 10:38:48 +0800
Subject: [PATCH v2] ocfs2: Make xattr reflink work with new local alloc reservation.

The new reservation code in local alloc has add the limitation
that the caller should handle the case that the local alloc
doesn't give use enough contiguous clusters. It make the old
xattr reflink code broken.

So this patch udpate the xattr reflink code so that it can
handle the case that local alloc give us one cluster at a time.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  125 ++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 89 insertions(+), 36 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 894734b..bc52840 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6805,16 +6805,15 @@ out:
 	return ret;
 }
 
-static int ocfs2_reflink_xattr_buckets(handle_t *handle,
+static int ocfs2_reflink_xattr_bucket(handle_t *handle,
 				u64 blkno, u64 new_blkno, u32 clusters,
+				u32 *cpos, int num_buckets,
 				struct ocfs2_alloc_context *meta_ac,
 				struct ocfs2_alloc_context *data_ac,
 				struct ocfs2_reflink_xattr_tree_args *args)
 {
 	int i, j, ret = 0;
 	struct super_block *sb = args->reflink->old_inode->i_sb;
-	u32 bpc = ocfs2_xattr_buckets_per_cluster(OCFS2_SB(sb));
-	u32 num_buckets = clusters * bpc;
 	int bpb = args->old_bucket->bu_blocks;
 	struct ocfs2_xattr_value_buf vb = {
 		.vb_access = ocfs2_journal_access,
@@ -6833,14 +6832,6 @@ static int ocfs2_reflink_xattr_buckets(handle_t *handle,
 			break;
 		}
 
-		/*
-		 * The real bucket num in this series of blocks is stored
-		 * in the 1st bucket.
-		 */
-		if (i == 0)
-			num_buckets = le16_to_cpu(
-				bucket_xh(args->old_bucket)->xh_num_buckets);
-
 		ret = ocfs2_xattr_bucket_journal_access(handle,
 						args->new_bucket,
 						OCFS2_JOURNAL_ACCESS_CREATE);
@@ -6854,6 +6845,18 @@ static int ocfs2_reflink_xattr_buckets(handle_t *handle,
 			       bucket_block(args->old_bucket, j),
 			       sb->s_blocksize);
 
+		/*
+		 * Record the start cpos so that we can use it to initialize
+		 * our xattr tree we also set the xh_num_bucket for the new
+		 * bucket.
+		 */
+		if (i == 0) {
+			*cpos = le32_to_cpu(bucket_xh(args->new_bucket)->
+					    xh_entries[0].xe_name_hash);
+			bucket_xh(args->new_bucket)->xh_num_buckets =
+				cpu_to_le16(num_buckets);
+		}
+
 		ocfs2_xattr_bucket_journal_dirty(handle, args->new_bucket);
 
 		ret = ocfs2_reflink_xattr_header(handle, args->reflink,
@@ -6883,6 +6886,7 @@ static int ocfs2_reflink_xattr_buckets(handle_t *handle,
 		}
 
 		ocfs2_xattr_bucket_journal_dirty(handle, args->new_bucket);
+
 		ocfs2_xattr_bucket_relse(args->old_bucket);
 		ocfs2_xattr_bucket_relse(args->new_bucket);
 	}
@@ -6891,6 +6895,74 @@ static int ocfs2_reflink_xattr_buckets(handle_t *handle,
 	ocfs2_xattr_bucket_relse(args->new_bucket);
 	return ret;
 }
+
+static int ocfs2_reflink_xattr_buckets(handle_t *handle,
+				struct inode *inode,
+				struct ocfs2_reflink_xattr_tree_args *args,
+				struct ocfs2_extent_tree *et,
+				struct ocfs2_alloc_context *meta_ac,
+				struct ocfs2_alloc_context *data_ac,
+				u64 blkno, u32 cpos, u32 len)
+{
+	int ret, num_buckets, reflink_buckets, first_inserted = 0;
+	u32 p_cluster, num_clusters, reflink_cpos = 0;
+	u64 new_blkno;
+	int bpc = ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb));
+
+	ret = ocfs2_read_xattr_bucket(args->old_bucket, blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	num_buckets = le16_to_cpu(bucket_xh(args->old_bucket)->xh_num_buckets);
+	ocfs2_xattr_bucket_relse(args->old_bucket);
+
+	while (len && num_buckets) {
+		ret = ocfs2_claim_clusters(handle, data_ac,
+					   1, &p_cluster, &num_clusters);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		new_blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
+		reflink_buckets = num_buckets < bpc * num_clusters ?
+				  num_buckets : bpc * num_clusters;
+
+		ret = ocfs2_reflink_xattr_bucket(handle, blkno,
+						 new_blkno, num_clusters,
+						 &reflink_cpos, reflink_buckets,
+						 meta_ac, data_ac, args);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/*
+		 * For the 1st allocated cluster, we make it use the same cpos
+		 * so that the xattr tree looks the same as the original one
+		 * in the most case.
+		 */
+		if (!first_inserted) {
+			reflink_cpos = cpos;
+			first_inserted = 1;
+		}
+		ret = ocfs2_insert_extent(handle, et, reflink_cpos, new_blkno,
+					  num_clusters, 0, meta_ac);
+		if (ret)
+			mlog_errno(ret);
+
+		mlog(0, "insert new xattr extent rec start %llu len %u to %u\n",
+		     (unsigned long long)new_blkno, num_clusters, reflink_cpos);
+
+		len -= num_clusters;
+		blkno += ocfs2_clusters_to_blocks(inode->i_sb, num_clusters);
+		num_buckets -= reflink_buckets;
+	}
+out:
+	return ret;
+}
+
 /*
  * Create the same xattr extent record in the new inode's xattr tree.
  */
@@ -6902,8 +6974,6 @@ static int ocfs2_reflink_xattr_rec(struct inode *inode,
 				   void *para)
 {
 	int ret, credits = 0;
-	u32 p_cluster, num_clusters;
-	u64 new_blkno;
 	handle_t *handle;
 	struct ocfs2_reflink_xattr_tree_args *args =
 			(struct ocfs2_reflink_xattr_tree_args *)para;
@@ -6912,6 +6982,9 @@ static int ocfs2_reflink_xattr_rec(struct inode *inode,
 	struct ocfs2_alloc_context *data_ac = NULL;
 	struct ocfs2_extent_tree et;
 
+	mlog(0, "reflink xattr buckets %llu len %u\n",
+	     (unsigned long long)blkno, len);
+
 	ocfs2_init_xattr_tree_extent_tree(&et,
 					  INODE_CACHE(args->reflink->new_inode),
 					  args->new_blk_bh);
@@ -6931,32 +7004,12 @@ static int ocfs2_reflink_xattr_rec(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_claim_clusters(handle, data_ac,
-				   len, &p_cluster, &num_clusters);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
-
-	new_blkno = ocfs2_clusters_to_blocks(osb->sb, p_cluster);
-
-	mlog(0, "reflink xattr buckets %llu to %llu, len %u\n",
-	     (unsigned long long)blkno, (unsigned long long)new_blkno, len);
-	ret = ocfs2_reflink_xattr_buckets(handle, blkno, new_blkno, len,
-					  meta_ac, data_ac, args);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
-
-	mlog(0, "insert new xattr extent rec start %llu len %u to %u\n",
-	     (unsigned long long)new_blkno, len, cpos);
-	ret = ocfs2_insert_extent(handle, &et, cpos, new_blkno,
-				  len, 0, meta_ac);
+	ret = ocfs2_reflink_xattr_buckets(handle, inode, args, &et,
+					  meta_ac, data_ac,
+					  blkno, cpos, len);
 	if (ret)
 		mlog_errno(ret);
 
-out_commit:
 	ocfs2_commit_trans(osb, handle);
 
 out:
-- 
1.5.5
