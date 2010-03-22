From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 22 Mar 2010 16:01:44 +0800
Subject: [Ocfs2-devel] [RFC] ocfs2: Make ocfs2_extend_trans really extending.
Message-ID: <1269244904-5783-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel/Mark/Sunil,
	This patch just want to make ocfs2_extend_trans(which used
to restart the journal with only 'nblocks' in some case) really
extending. I have met with many troubles when I used this function
in implementing xattr support. And I used to think that it is
my fault.

But I changed my mind when I saw that Joel(Sorry, Joel, ;) ) also use
it wrongly. See
http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=commitdiff;h=991f171d287781ae12d1ec06cb1917dae3334a9b;hp=f5abd5404e8d1551f1bf58b711543e3b5dcc1079

Acutally ocfs2_extend_trans in ocfs2_block_group_alloc_discontig
has to be
	status = ocfs2_extend_trans(handle,
				    ocfs2_calc_bg_discontig_credits(osb->sb) +
				    handle->h_buffer_credits);
because we will modify the bitmap file later which isn't included in
ocfs2_calc_bg_discontig_credits.

That makes me to think more. So why we don't reserve the old blocks? I just
skimmed all the callers of ocfs2_extend_trans, and to my surprise, 12 of 15
callers added h_buffer_credits by themself to avoid the problem. Then why
handle this in ocfs2_extend_trans? So here comes the patch. Please review.

btw, I am not sure whether this patch will have some conflict with Joel's
patch "make ocfs2_journal_dirty void". I suppose not. But if yes, I will
rebase it when I get some ack.

Regards,
Tao

From 68973800e76d5677a1d519d15fa8969ae348e248 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 22 Mar 2010 15:50:06 +0800
Subject: [PATCH] ocfs2: Make ocfs2_extend_trans really extending.

In ocfs2, we use ocfs2_extend_trans to extend a journal's
blocks. But it is designed that in case jbd2_journal_extend
fails, it will only restart with the the new block number.
This tends to be awkward since in most cases we want our
original reserved blocks there and make our codes hard to
mantain since the caller sometimes can't make sure all the
original blocks will not be accessed and dirtied again.
There are 15 callers of ocfs2_extend_trans in fs/ocfs2,
and 12 of them have to add h_buffer_credits before they
call ocfs2_extend_trans. So make it really behaves like
extending.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |   30 +++++++++---------------------
 fs/ocfs2/journal.c      |   10 +++++-----
 fs/ocfs2/refcounttree.c |    2 +-
 fs/ocfs2/xattr.c        |   17 ++++++-----------
 4 files changed, 21 insertions(+), 38 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 9f8bd91..0c55b53 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1129,8 +1129,7 @@ static int ocfs2_adjust_rightmost_branch(handle_t *handle,
 		goto out;
 	}
 
-	status = ocfs2_extend_trans(handle, path_num_items(path) +
-				    handle->h_buffer_credits);
+	status = ocfs2_extend_trans(handle, path_num_items(path));
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
@@ -2327,20 +2326,14 @@ static int ocfs2_extend_rotate_transaction(handle_t *handle, int subtree_depth,
 					   int op_credits,
 					   struct ocfs2_path *path)
 {
-	int ret;
+	int ret = 0;
 	int credits = (path->p_tree_depth - subtree_depth) * 2 + 1 + op_credits;
 
-	if (handle->h_buffer_credits < credits) {
+	if (handle->h_buffer_credits < credits)
 		ret = ocfs2_extend_trans(handle,
 					 credits - handle->h_buffer_credits);
-		if (ret)
-			return ret;
-
-		if (unlikely(handle->h_buffer_credits < credits))
-			return ocfs2_extend_trans(handle, credits);
-	}
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -2584,8 +2577,7 @@ static int ocfs2_update_edge_lengths(handle_t *handle,
 	 * records for all the bh in the path.
 	 * So we have to allocate extra credits and access them.
 	 */
-	ret = ocfs2_extend_trans(handle,
-				 handle->h_buffer_credits + subtree_index);
+	ret = ocfs2_extend_trans(handle, subtree_index);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4203,17 +4195,13 @@ static int ocfs2_insert_path(handle_t *handle,
 	struct buffer_head *leaf_bh = path_leaf_bh(right_path);
 
 	if (left_path) {
-		int credits = handle->h_buffer_credits;
-
 		/*
 		 * There's a chance that left_path got passed back to
 		 * us without being accounted for in the
 		 * journal. Extend our transaction here to be sure we
 		 * can change those blocks.
 		 */
-		credits += left_path->p_tree_depth;
-
-		ret = ocfs2_extend_trans(handle, credits);
+		ret = ocfs2_extend_trans(handle, left_path->p_tree_depth);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -5309,7 +5297,7 @@ static int ocfs2_split_tree(handle_t *handle, struct ocfs2_extent_tree *et,
 			    int index, u32 new_range,
 			    struct ocfs2_alloc_context *meta_ac)
 {
-	int ret, depth, credits = handle->h_buffer_credits;
+	int ret, depth, credits;
 	struct buffer_head *last_eb_bh = NULL;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *rightmost_el, *el;
@@ -5340,8 +5328,8 @@ static int ocfs2_split_tree(handle_t *handle, struct ocfs2_extent_tree *et,
 	} else
 		rightmost_el = path_leaf_el(path);
 
-	credits += path->p_tree_depth +
-		   ocfs2_extend_meta_needed(et->et_root_el);
+	credits = path->p_tree_depth +
+		  ocfs2_extend_meta_needed(et->et_root_el);
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9336c60..4b03a21 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -402,9 +402,7 @@ int ocfs2_commit_trans(struct ocfs2_super *osb,
 }
 
 /*
- * 'nblocks' is what you want to add to the current
- * transaction. extend_trans will either extend the current handle by
- * nblocks, or commit it and start a new one with nblocks credits.
+ * 'nblocks' is what you want to add to the current transaction.
  *
  * This might call jbd2_journal_restart() which will commit dirty buffers
  * and then restart the transaction. Before calling
@@ -422,11 +420,12 @@ int ocfs2_commit_trans(struct ocfs2_super *osb,
  */
 int ocfs2_extend_trans(handle_t *handle, int nblocks)
 {
-	int status;
+	int status, old_nblocks;
 
 	BUG_ON(!handle);
 	BUG_ON(!nblocks);
 
+	old_nblocks = handle->h_buffer_credits;
 	mlog_entry_void();
 
 	mlog(0, "Trying to extend transaction by %d blocks\n", nblocks);
@@ -445,7 +444,8 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 		mlog(0,
 		     "jbd2_journal_extend failed, trying "
 		     "jbd2_journal_restart\n");
-		status = jbd2_journal_restart(handle, nblocks);
+		status = jbd2_journal_restart(handle,
+					      old_nblocks + nblocks);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 29405f2..02d3f82 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1695,7 +1695,7 @@ static int ocfs2_adjust_refcount_rec(handle_t *handle,
 	 * 2 more credits, one for the leaf refcount block, one for
 	 * the extent block contains the extent rec.
 	 */
-	ret = ocfs2_extend_trans(handle, handle->h_buffer_credits + 2);
+	ret = ocfs2_extend_trans(handle, 2);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3e77730..bbbe212 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3312,8 +3312,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 				goto out;
 			}
 
-			ret = ocfs2_extend_trans(ctxt->handle, credits +
-					ctxt->handle->h_buffer_credits);
+			ret = ocfs2_extend_trans(ctxt->handle, credits);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -3343,8 +3342,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 					goto out;
 				}
 
-				ret = ocfs2_extend_trans(ctxt->handle, credits +
-					ctxt->handle->h_buffer_credits);
+				ret = ocfs2_extend_trans(ctxt->handle, credits);
 				if (ret) {
 					mlog_errno(ret);
 					goto out;
@@ -3378,8 +3376,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 					goto out;
 				}
 
-				ret = ocfs2_extend_trans(ctxt->handle, credits +
-						ctxt->handle->h_buffer_credits);
+				ret = ocfs2_extend_trans(ctxt->handle, credits);
 				if (ret) {
 					mlog_errno(ret);
 					goto out;
@@ -4887,8 +4884,7 @@ static int ocfs2_mv_xattr_buckets(struct inode *inode, handle_t *handle,
 	 * We need to update the first bucket of the old extent and all
 	 * the buckets going to the new extent.
 	 */
-	credits = ((num_buckets + 1) * blks_per_bucket) +
-		handle->h_buffer_credits;
+	credits = ((num_buckets + 1) * blks_per_bucket);
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
@@ -4958,7 +4954,7 @@ static int ocfs2_divide_xattr_cluster(struct inode *inode,
 				      u32 *first_hash)
 {
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	int ret, credits = 2 * blk_per_bucket + handle->h_buffer_credits;
+	int ret, credits = 2 * blk_per_bucket;
 
 	BUG_ON(OCFS2_XATTR_BUCKET_SIZE < OCFS2_SB(inode->i_sb)->s_clustersize);
 
@@ -5200,8 +5196,7 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	 * existing bucket.  Then we add the last existing bucket, the
 	 * new bucket, and the first bucket (3 * blk_per_bucket).
 	 */
-	credits = (end_blk - target_blk) + (3 * blk_per_bucket) +
-		  handle->h_buffer_credits;
+	credits = (end_blk - target_blk) + (3 * blk_per_bucket);
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
-- 
1.5.5
