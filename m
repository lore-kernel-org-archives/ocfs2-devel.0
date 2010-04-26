From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 26 Apr 2010 14:34:57 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Make ocfs2_extend_trans really
	extending.
In-Reply-To: <20100423204545.GB10637@mail.oracle.com>
References: <20100423204545.GB10637@mail.oracle.com>
Message-ID: <1272263697-5701-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 21, 2010 at 11:29:39AM +0800, Tao Ma wrote:
> > I have finished the tests on xattr and reflink(I use reflink for b-tree
> > test because it also use b-tree heavily and also it has a stress test
> > case which create a b-tree with depth=2 easily). Both test cases works.
> > So please consider including it in the merge window. Thanks.

>	I think I'm happy to take this patch, but a couple things first.

> > I also changed the patch a little in the beginning of ocfs2_extend_trans.
> > -	BUG_ON(!nblocks);
> > +	if (nblocks <= 0)
> > +		return 0;
> > +
> > The reason is that some b-tree codes now will extend transcation with
> > tree depth. So sometimes it may give us a '0' and we will just return back.

>	Well, negative nblocks is still a bug, right?  shouldn't we at
>least warn or make it an unsigned int?
yeah, nblocks < 0 is a bug I think. I have added the BUG_ON for this case.
Here is the updated one.

Regards,
Tao

From c9dc26549b429eede9e47094a98b067bd5cd23b1 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 26 Apr 2010 13:49:11 +0800
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
 fs/ocfs2/journal.c      |   15 +++++++++------
 fs/ocfs2/refcounttree.c |    2 +-
 fs/ocfs2/xattr.c        |   17 ++++++-----------
 4 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a74ea70..0cb2945 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1125,8 +1125,7 @@ static int ocfs2_adjust_rightmost_branch(handle_t *handle,
 		goto out;
 	}
 
-	status = ocfs2_extend_trans(handle, path_num_items(path) +
-				    handle->h_buffer_credits);
+	status = ocfs2_extend_trans(handle, path_num_items(path));
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
@@ -2288,20 +2287,14 @@ static int ocfs2_extend_rotate_transaction(handle_t *handle, int subtree_depth,
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
@@ -2545,8 +2538,7 @@ static int ocfs2_update_edge_lengths(handle_t *handle,
 	 * records for all the bh in the path.
 	 * So we have to allocate extra credits and access them.
 	 */
-	ret = ocfs2_extend_trans(handle,
-				 handle->h_buffer_credits + subtree_index);
+	ret = ocfs2_extend_trans(handle, subtree_index);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4141,17 +4133,13 @@ static int ocfs2_insert_path(handle_t *handle,
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
@@ -5237,7 +5225,7 @@ static int ocfs2_split_tree(handle_t *handle, struct ocfs2_extent_tree *et,
 			    int index, u32 new_range,
 			    struct ocfs2_alloc_context *meta_ac)
 {
-	int ret, depth, credits = handle->h_buffer_credits;
+	int ret, depth, credits;
 	struct buffer_head *last_eb_bh = NULL;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *rightmost_el, *el;
@@ -5268,8 +5256,8 @@ static int ocfs2_split_tree(handle_t *handle, struct ocfs2_extent_tree *et,
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
index cfd271c..47878cf 100644
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
@@ -422,11 +420,15 @@ int ocfs2_commit_trans(struct ocfs2_super *osb,
  */
 int ocfs2_extend_trans(handle_t *handle, int nblocks)
 {
-	int status;
+	int status, old_nblocks;
 
 	BUG_ON(!handle);
-	BUG_ON(!nblocks);
+	BUG_ON(nblocks < 0);
+
+	if (!nblocks)
+		return 0;
 
+	old_nblocks = handle->h_buffer_credits;
 	mlog_entry_void();
 
 	mlog(0, "Trying to extend transaction by %d blocks\n", nblocks);
@@ -445,7 +447,8 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
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
index 44d3e1c..55e4b9a 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1693,7 +1693,7 @@ static int ocfs2_adjust_refcount_rec(handle_t *handle,
 	 * 2 more credits, one for the leaf refcount block, one for
 	 * the extent block contains the extent rec.
 	 */
-	ret = ocfs2_extend_trans(handle, handle->h_buffer_credits + 2);
+	ret = ocfs2_extend_trans(handle, 2);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 26f704c..56f5c71 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3295,8 +3295,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 				goto out;
 			}
 
-			ret = ocfs2_extend_trans(ctxt->handle, credits +
-					ctxt->handle->h_buffer_credits);
+			ret = ocfs2_extend_trans(ctxt->handle, credits);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -3326,8 +3325,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 					goto out;
 				}
 
-				ret = ocfs2_extend_trans(ctxt->handle, credits +
-					ctxt->handle->h_buffer_credits);
+				ret = ocfs2_extend_trans(ctxt->handle, credits);
 				if (ret) {
 					mlog_errno(ret);
 					goto out;
@@ -3361,8 +3359,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 					goto out;
 				}
 
-				ret = ocfs2_extend_trans(ctxt->handle, credits +
-						ctxt->handle->h_buffer_credits);
+				ret = ocfs2_extend_trans(ctxt->handle, credits);
 				if (ret) {
 					mlog_errno(ret);
 					goto out;
@@ -4870,8 +4867,7 @@ static int ocfs2_mv_xattr_buckets(struct inode *inode, handle_t *handle,
 	 * We need to update the first bucket of the old extent and all
 	 * the buckets going to the new extent.
 	 */
-	credits = ((num_buckets + 1) * blks_per_bucket) +
-		handle->h_buffer_credits;
+	credits = ((num_buckets + 1) * blks_per_bucket);
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
@@ -4941,7 +4937,7 @@ static int ocfs2_divide_xattr_cluster(struct inode *inode,
 				      u32 *first_hash)
 {
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	int ret, credits = 2 * blk_per_bucket + handle->h_buffer_credits;
+	int ret, credits = 2 * blk_per_bucket;
 
 	BUG_ON(OCFS2_XATTR_BUCKET_SIZE < OCFS2_SB(inode->i_sb)->s_clustersize);
 
@@ -5181,8 +5177,7 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
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
