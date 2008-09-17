From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Wed, 17 Sep 2008 21:59:26 +0400
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: fix printk format warnings
Message-ID: <20080917175926.GA29966@orion>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/ocfs2/xattr.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index bbe87d0..dda520d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2423,7 +2423,8 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 	BUG_ON(p_blkno == 0 || num_clusters == 0 || first_hash > name_hash);
 
 	mlog(0, "find xattr extent rec %u clusters from %llu, the first hash "
-	     "in the rec is %u\n", num_clusters, p_blkno, first_hash);
+	     "in the rec is %u\n", num_clusters, (unsigned long long)p_blkno,
+	     first_hash);
 
 	ret = ocfs2_xattr_bucket_find(inode, name_index, name, name_hash,
 				      p_blkno, first_hash, num_clusters, xs);
@@ -2447,7 +2448,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 	memset(&bucket, 0, sizeof(bucket));
 
 	mlog(0, "iterating xattr buckets in %u clusters starting from %llu\n",
-	     clusters, blkno);
+	     clusters, (unsigned long long)blkno);
 
 	for (i = 0; i < num_buckets; i++, blkno += blk_per_bucket) {
 		ret = ocfs2_read_blocks(OCFS2_SB(inode->i_sb),
@@ -2466,7 +2467,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 		if (i == 0)
 			num_buckets = le16_to_cpu(bucket.xh->xh_num_buckets);
 
-		mlog(0, "iterating xattr bucket %llu\n", blkno);
+		mlog(0, "iterating xattr bucket %llu\n", (unsigned long long)blkno);
 		if (func) {
 			ret = func(inode, &bucket, para);
 			if (ret) {
@@ -2799,7 +2800,8 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	 */
 	blkno = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
 
-	mlog(0, "allocate 1 cluster from %llu to xattr block\n", blkno);
+	mlog(0, "allocate 1 cluster from %llu to xattr block\n",
+	     (unsigned long long)blkno);
 
 	xh_bh = sb_getblk(inode->i_sb, blkno);
 	if (!xh_bh) {
@@ -2966,8 +2968,8 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 
 	mlog(0, "adjust xattr bucket in %llu, count = %u, "
 	     "xh_free_start = %u, xh_name_value_len = %u.\n",
-	     blkno, le16_to_cpu(xh->xh_count), xh_free_start,
-	     le16_to_cpu(xh->xh_name_value_len));
+	     (unsigned long long)blkno, le16_to_cpu(xh->xh_count),
+	     xh_free_start, le16_to_cpu(xh->xh_name_value_len));
 
 	/*
 	 * sort all the entries by their offset.
@@ -3083,7 +3085,7 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 	prev_blkno += (num_clusters - 1) * bpc + bpc / 2;
 
 	mlog(0, "move half of xattrs in cluster %llu to %llu\n",
-	     prev_blkno, new_blkno);
+	     (unsigned long long)prev_blkno, (unsigned long long)new_blkno);
 
 	/*
 	 * We need to update the 1st half of the new cluster and
@@ -3214,7 +3216,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	int blocksize = inode->i_sb->s_blocksize;
 
 	mlog(0, "move half of xattrs from bucket %llu to %llu\n",
-	     blk, new_blk);
+	     (unsigned long long)blk, (unsigned long long)new_blk);
 
 	s_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
 	if (!s_bhs)
@@ -3385,7 +3387,8 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	BUG_ON(s_blkno == t_blkno);
 
 	mlog(0, "cp bucket %llu to %llu, target is %d\n",
-	     s_blkno, t_blkno, t_is_new);
+	     (unsigned long long)s_blkno, (unsigned long long)t_blkno,
+	     t_is_new);
 
 	s_bhs = kzalloc(sizeof(struct buffer_head *) * blk_per_bucket,
 			GFP_NOFS);
@@ -3455,7 +3458,8 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 	struct ocfs2_xattr_header *xh;
 	u64 to_blk_start = to_blk;
 
-	mlog(0, "cp xattrs from cluster %llu to %llu\n", src_blk, to_blk);
+	mlog(0, "cp xattrs from cluster %llu to %llu\n",
+	     (unsigned long long)src_blk, (unsigned long long)to_blk);
 
 	/*
 	 * We need to update the new cluster and 1 more for the update of
@@ -3586,7 +3590,8 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 
 	mlog(0, "adjust xattrs from cluster %llu len %u to %llu\n",
-	     prev_blk, prev_clusters, new_blk);
+	     (unsigned long long)prev_blk, prev_clusters,
+	     (unsigned long long)new_blk);
 
 	if (ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb)) > 1)
 		ret = ocfs2_mv_xattr_bucket_cross_cluster(inode,
@@ -3656,7 +3661,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	mlog(0, "Add new xattr cluster for %llu, previous xattr hash = %u, "
 	     "previous xattr blkno = %llu\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     prev_cpos, prev_blkno);
+	     prev_cpos, (unsigned long long)prev_blkno);
 
 	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
 
@@ -3743,7 +3748,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		}
 	}
 	mlog(0, "Insert %u clusters at block %llu for xattr at %u\n",
-	     num_bits, block, v_start);
+	     num_bits, (unsigned long long)block, v_start);
 	ret = ocfs2_insert_extent(osb, handle, inode, &et, v_start, block,
 				  num_bits, 0, meta_ac);
 	if (ret < 0) {
@@ -3788,7 +3793,7 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	u16 bucket = le16_to_cpu(first_xh->xh_num_buckets);
 
 	mlog(0, "extend xattr bucket in %llu, xattr extend rec starting "
-	     "from %llu, len = %u\n", start_blk,
+	     "from %llu, len = %u\n", (unsigned long long)start_blk,
 	     (unsigned long long)first_bh->b_blocknr, num_clusters);
 
 	BUG_ON(bucket >= num_buckets);
@@ -4314,7 +4319,7 @@ static int ocfs2_rm_xattr_bucket(struct inode *inode,
 
 	end = first_bh->b_blocknr + (bucket_num - 1) * blk_per_bucket;
 
-	mlog(0, "rm xattr bucket %llu\n", start);
+	mlog(0, "rm xattr bucket %llu\n", (unsigned long long)start);
 	/*
 	 * We need to update the first xattr_header and all the buckets starting
 	 * from start in this xattr rec.
