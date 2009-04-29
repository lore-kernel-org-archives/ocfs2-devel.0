From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:36 +0800
Subject: [Ocfs2-devel] [PATCH 24/39] ocfs2: Add caching info for refcount
	tree.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-24-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

refcount tree should use its own caching info so that when
we downconvert the refcount tree lock, we can drop all the
cached buffer head.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |  124 +++++++++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/refcounttree.h |   12 +++++
 2 files changed, 122 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 56c8c52..4ef6bd2 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -54,8 +54,11 @@ struct ocfs2_cow_context {
 	u32 cow_len;
 };
 
+static const struct ocfs2_caching_operations ocfs2_refcount_caching_ops;
 static void ocfs2_delete_refcount_tree(struct ocfs2_super *osb,
 				       struct ocfs2_refcount_tree *tree);
+static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
+				   struct ocfs2_refcount_tree **ret_tree);
 
 static int ocfs2_validate_refcount_block(struct super_block *sb,
 					 struct buffer_head *bh)
@@ -142,6 +145,7 @@ int ocfs2_create_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_refcount_block *rb;
+	struct ocfs2_refcount_tree *tree;
 	u16 suballoc_bit_start;
 	u32 num_got;
 	u64 first_blkno;
@@ -179,10 +183,16 @@ int ocfs2_create_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 		goto out_commit;
 	}
 
+	ret = ocfs2_get_refcount_tree(osb, first_blkno, &tree);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
 	new_bh = sb_getblk(inode->i_sb, first_blkno);
-	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
+	ocfs2_set_new_buffer_uptodate(&tree->rf_ci, new_bh);
 
-	ret = ocfs2_journal_access_rb(handle, INODE_CACHE(inode), new_bh,
+	ret = ocfs2_journal_access_rb(handle, &tree->rf_ci, new_bh,
 				      OCFS2_JOURNAL_ACCESS_CREATE);
 	if (ret) {
 		mlog_errno(ret);
@@ -261,7 +271,7 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_journal_access_rb(handle, INODE_CACHE(inode), ref_root_bh,
+	ret = ocfs2_journal_access_rb(handle, &ref_tree->rf_ci, ref_root_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -280,6 +290,7 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 	spin_unlock(&oi->ip_lock);
 	ocfs2_journal_dirty(handle, di_bh);
 
+	ocfs2_set_ci_lock_trans(osb->journal, &ref_tree->rf_ci);
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 out:
@@ -352,6 +363,8 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 		goto out_unlock;
 	}
 
+	ocfs2_set_ci_lock_trans(osb->journal, &ref_tree->rf_ci);
+
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
@@ -359,7 +372,7 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 		goto out_commit;
 	}
 
-	ret = ocfs2_journal_access_rb(handle, INODE_CACHE(inode), blk_bh,
+	ret = ocfs2_journal_access_rb(handle, &ref_tree->rf_ci, blk_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -1333,6 +1346,8 @@ static int __ocfs2_increase_refcount(handle_t *handle,
 	}
 
 out:
+	ocfs2_set_ci_lock_trans(
+		OCFS2_SB(ocfs2_metadata_cache_get_super(ci))->journal, ci);
 	brelse(ref_leaf_bh);
 	return ret;
 }
@@ -1518,6 +1533,7 @@ out:
 	return ret;
 }
 
+/* Caller must hold refcount tree lock. */
 int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 			    handle_t *handle, u32 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
@@ -1528,11 +1544,19 @@ int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_refcount_tree *tree;
 
 	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
 	BUG_ON(!di->i_refcount_loc);
 
-	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
+	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb),
+				      le64_to_cpu(di->i_refcount_loc), &tree);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_refcount_block(&tree->rf_ci,
 					le64_to_cpu(di->i_refcount_loc),
 					&ref_root_bh);
 	if (ret) {
@@ -1540,7 +1564,7 @@ int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 		goto out;
 	}
 
-	ret = __ocfs2_decrease_refcount(handle, INODE_CACHE(inode), ref_root_bh,
+	ret = __ocfs2_decrease_refcount(handle, &tree->rf_ci, ref_root_bh,
 					cpos, len, meta_ac, dealloc, delete);
 	if (ret)
 		mlog_errno(ret);
@@ -1725,6 +1749,8 @@ out:
  * continguous also, so that we can get the number easily.
  * As for meta_ac, we will at most add split 2 refcount record and
  * 2 more refcount block, so just check it in a rough way.
+ *
+ * Caller must hold refcount tree lock.
  */
 int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  struct buffer_head *di_bh,
@@ -1737,6 +1763,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_refcount_tree *tree;
 	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
@@ -1750,7 +1777,14 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
 	BUG_ON(!di->i_refcount_loc);
 
-	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
+	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb),
+				      le64_to_cpu(di->i_refcount_loc), &tree);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_refcount_block(&tree->rf_ci,
 					le64_to_cpu(di->i_refcount_loc),
 					&ref_root_bh);
 	if (ret) {
@@ -1759,7 +1793,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	}
 
 	ret = ocfs2_calc_refcount_meta_credits(inode->i_sb,
-					       INODE_CACHE(inode),
+					       &tree->rf_ci,
 					       ref_root_bh,
 					       start_cpos, clusters,
 					       &ref_blocks, credits);
@@ -2187,6 +2221,9 @@ static int ocfs2_clear_ext_refcount(handle_t *handle,
 		mlog_errno(ret);
 
 out:
+	ocfs2_set_ci_lock_trans(
+		OCFS2_SB(ocfs2_metadata_cache_get_super(et->et_ci))->journal,
+		et->et_ci);
 	ocfs2_free_path(path);
 	return ret;
 }
@@ -2348,6 +2385,7 @@ out:
 static int ocfs2_replace_cow(struct inode *inode,
 			     struct buffer_head *di_bh,
 			     struct buffer_head *ref_root_bh,
+			     struct ocfs2_caching_info *ref_ci,
 			     u32 cow_start, u32 cow_len,
 			     struct page **pages,
 			     int num_pages)
@@ -2372,7 +2410,7 @@ static int ocfs2_replace_cow(struct inode *inode,
 	context.num_pages = num_pages;
 	context.cow_start = cow_start;
 	context.cow_len = cow_len;
-	context.ref_ci = INODE_CACHE(inode);
+	context.ref_ci = ref_ci;
 	context.ref_root_bh = ref_root_bh;
 
 	context.bhs = kcalloc(ocfs2_clusters_to_blocks(inode->i_sb, 1),
@@ -2480,7 +2518,7 @@ int ocfs2_refcount_cow(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_replace_cow(inode, di_bh, ref_root_bh,
+	ret = ocfs2_replace_cow(inode, di_bh, ref_root_bh, &ref_tree->rf_ci,
 				cow_start, cow_len, pages, num_pages);
 	if (ret)
 		mlog_errno(ret);
@@ -2611,7 +2649,7 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 			continue;
 
 		ret = ocfs2_add_refcount_flag(inode, &di_et,
-					      INODE_CACHE(inode), ref_root_bh,
+					      &ref_tree->rf_ci, ref_root_bh,
 					      cpos - num_clusters,
 					      p_cluster, num_clusters,
 					      &dealloc);
@@ -2694,6 +2732,7 @@ out:
 static int ocfs2_duplicate_extent_list(struct inode *s_inode,
 				struct inode *t_inode,
 				struct buffer_head *t_bh,
+				struct ocfs2_caching_info *ref_ci,
 				struct buffer_head *ref_root_bh,
 				struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
@@ -2715,8 +2754,7 @@ static int ocfs2_duplicate_extent_list(struct inode *s_inode,
 
 		if (p_cluster) {
 			ret = ocfs2_add_refcounted_extent(t_inode, &et,
-							  INODE_CACHE(t_inode),
-							  ref_root_bh,
+							  ref_ci, ref_root_bh,
 							  cpos, p_cluster,
 							  num_clusters,
 							  ext_flags,
@@ -2806,7 +2844,8 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 	el = &di->id2.i_list;
 
 	ret = ocfs2_duplicate_extent_list(s_inode, t_inode, t_bh,
-					  ref_root_bh, &dealloc);
+					  &ref_tree->rf_ci, ref_root_bh,
+					  &dealloc);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_unlock_refcount;
@@ -3076,6 +3115,7 @@ static void ocfs2_insert_refcount_tree(struct ocfs2_super *osb,
 static void ocfs2_free_refcount_tree(struct ocfs2_super *osb,
 				     struct ocfs2_refcount_tree *tree)
 {
+	ocfs2_metadata_cache_exit(&tree->rf_ci);
 	ocfs2_simple_drop_lockres(osb, &tree->rf_lockres);
 	ocfs2_lock_res_free(&tree->rf_lockres);
 	kfree(tree);
@@ -3113,8 +3153,12 @@ static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
 	}
 
 	new->rf_blkno = rf_blkno;
+	new->rf_sb = osb->sb;
+	spin_lock_init(&new->rf_lock);
+	mutex_init(&new->rf_io_mutex);
 	init_rwsem(&new->rf_sem);
 	ocfs2_refcount_lock_res_init(&new->rf_lockres, osb, rf_blkno);
+	ocfs2_metadata_cache_init(&new->rf_ci, &ocfs2_refcount_caching_ops);
 
 	spin_lock(&osb->osb_lock);
 	tree = ocfs2_find_refcount_tree(osb, rf_blkno);
@@ -3208,3 +3252,55 @@ void ocfs2_purge_refcount_tree(struct ocfs2_super *osb)
 		ocfs2_free_refcount_tree(osb, tree);
 	}
 }
+
+static u64 ocfs2_refcount_cache_owner(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	return rf->rf_blkno;
+}
+
+static struct super_block *
+ocfs2_refcount_cache_get_super(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	return rf->rf_sb;
+}
+
+static void ocfs2_refcount_cache_lock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	spin_lock(&rf->rf_lock);
+}
+
+static void ocfs2_refcount_cache_unlock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	spin_unlock(&rf->rf_lock);
+}
+
+static void ocfs2_refcount_cache_io_lock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	mutex_lock(&rf->rf_io_mutex);
+}
+
+static void ocfs2_refcount_cache_io_unlock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	mutex_unlock(&rf->rf_io_mutex);
+}
+
+static const struct ocfs2_caching_operations ocfs2_refcount_caching_ops = {
+	.co_owner		= ocfs2_refcount_cache_owner,
+	.co_get_super		= ocfs2_refcount_cache_get_super,
+	.co_cache_lock		= ocfs2_refcount_cache_lock,
+	.co_cache_unlock	= ocfs2_refcount_cache_unlock,
+	.co_io_lock		= ocfs2_refcount_cache_io_lock,
+	.co_io_unlock		= ocfs2_refcount_cache_io_unlock,
+};
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 5590127..b7fb077 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -22,7 +22,13 @@ struct ocfs2_refcount_tree {
 	u64 rf_blkno;
 	struct rw_semaphore rf_sem;
 	struct ocfs2_lock_res rf_lockres;
+
+	/* the following 4 fields are used by caching_info. */
 	struct ocfs2_caching_info rf_ci;
+	spinlock_t rf_lock;
+	struct mutex rf_io_mutex;
+	struct super_block *rf_sb;
+
 };
 
 static inline struct ocfs2_refcount_tree *
@@ -31,6 +37,12 @@ OCFS2_REF_ITEM(struct ocfs2_lock_res *res)
 	return container_of(res, struct ocfs2_refcount_tree, rf_lockres);
 }
 
+static inline struct ocfs2_refcount_tree *
+cache_info_to_refcount(struct ocfs2_caching_info *ci)
+{
+	return container_of(ci, struct ocfs2_refcount_tree, rf_ci);
+}
+
 int ocfs2_create_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
 int ocfs2_set_refcount_tree(struct inode *inode,
 			    struct buffer_head *di_bh,
-- 
1.6.2.rc2.16.gf474c
