From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:46:06 +0800
Subject: [Ocfs2-devel] [PATCH 27/42] ocfs2: Add caching info for refcount
	tree.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-27-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/refcounttree.c |  114 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/refcounttree.h |   12 +++++
 2 files changed, 114 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 9b460db..8efb0d2 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -52,8 +52,11 @@ struct ocfs2_cow_context {
 	u32 cow_len;
 };
 
+static const struct ocfs2_caching_operations ocfs2_refcount_caching_ops;
 static void ocfs2_delete_refcount_tree(struct ocfs2_super *osb,
 				       struct ocfs2_refcount_tree *tree);
+static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
+				   struct ocfs2_refcount_tree **ret_tree);
 
 static int ocfs2_validate_refcount_block(struct super_block *sb,
 					 struct buffer_head *bh)
@@ -140,6 +143,7 @@ int ocfs2_create_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_refcount_block *rb;
+	struct ocfs2_refcount_tree *tree;
 	u16 slot, suballoc_bit_start;
 	u32 num_got;
 	u64 first_blkno;
@@ -177,10 +181,16 @@ int ocfs2_create_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
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
@@ -257,7 +267,7 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_journal_access_rb(handle, INODE_CACHE(inode), ref_bh,
+	ret = ocfs2_journal_access_rb(handle, &ref_tree->rf_ci, ref_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -276,6 +286,7 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 	spin_unlock(&oi->ip_lock);
 	ocfs2_journal_dirty(handle, di_bh);
 
+	ocfs2_set_ci_lock_trans(osb->journal, &ref_tree->rf_ci);
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 out:
@@ -348,6 +359,8 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 		goto out_unlock;
 	}
 
+	ocfs2_set_ci_lock_trans(osb->journal, &ref_tree->rf_ci);
+
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
@@ -355,7 +368,7 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 		goto out_commit;
 	}
 
-	ret = ocfs2_journal_access_rb(handle, INODE_CACHE(inode), blk_bh,
+	ret = ocfs2_journal_access_rb(handle, &ref_tree->rf_ci, blk_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -591,6 +604,9 @@ static int __ocfs2_increase_refcount(handle_t *handle,
 	}
 
 out:
+	ocfs2_set_ci_lock_trans(
+		OCFS2_SB(ocfs2_metadata_cache_get_super(et->et_ci))->journal,
+		et->et_ci);
 	ocfs2_free_path(path);
 	return ret;
 }
@@ -680,6 +696,7 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 	}
 
 out:
+	ocfs2_set_ci_lock_trans(OCFS2_SB(sb)->journal, et->et_ci);
 	ocfs2_free_path(path);
 	return ret;
 }
@@ -695,11 +712,19 @@ int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 	struct buffer_head *ref_bh = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_extent_tree et;
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
 					&ref_bh);
 	if (ret) {
@@ -707,7 +732,7 @@ int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 		goto out;
 	}
 
-	ocfs2_init_refcount_extent_tree(&et, INODE_CACHE(inode), ref_bh);
+	ocfs2_init_refcount_extent_tree(&et, &tree->rf_ci, ref_bh);
 	ret = __ocfs2_decrease_refcount(handle, &et,
 					cpos, len, meta_ac, dealloc, delete);
 	if (ret)
@@ -773,6 +798,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	struct buffer_head *ref_bh = NULL;
 	struct ocfs2_refcount_block *rb;
 	struct ocfs2_extent_tree et;
+	struct ocfs2_refcount_tree *tree;
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
 		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
@@ -785,7 +811,14 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
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
 					&ref_bh);
 	if (ret < 0) {
@@ -794,7 +827,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	}
 
 	rb = (struct ocfs2_refcount_block *)ref_bh->b_data;
-	ocfs2_init_refcount_extent_tree(&et, INODE_CACHE(inode), ref_bh);
+	ocfs2_init_refcount_extent_tree(&et, &tree->rf_ci, ref_bh);
 
 	ret = ocfs2_lock_allocators(inode, &et, 0, extents_split,
 				    NULL, meta_ac);
@@ -1333,6 +1366,7 @@ static int ocfs2_make_clusters_writable(handle_t *handle,
 static int ocfs2_replace_cow(struct inode *inode,
 			     struct buffer_head *di_bh,
 			     struct buffer_head *ref_bh,
+			     struct ocfs2_caching_info *ref_ci,
 			     u32 cow_start, u32 cow_len,
 			     int num_recs,
 			     struct page **pages,
@@ -1371,8 +1405,7 @@ static int ocfs2_replace_cow(struct inode *inode,
 	ocfs2_init_dealloc_ctxt(&context.dealloc);
 	ocfs2_init_dinode_extent_tree(&context.di_et,
 				      INODE_CACHE(inode), di_bh);
-	ocfs2_init_refcount_extent_tree(&context.ref_et,
-					INODE_CACHE(inode), ref_bh);
+	ocfs2_init_refcount_extent_tree(&context.ref_et, ref_ci, ref_bh);
 
 	ret = ocfs2_lock_refcount_cow_allocator(inode->i_sb, cow_len,
 						&context, &credits);
@@ -1495,7 +1528,7 @@ int ocfs2_refcount_cow(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_replace_cow(inode, di_bh, ref_bh,
+	ret = ocfs2_replace_cow(inode, di_bh, ref_bh, &ref_tree->rf_ci,
 				cow_start, cow_len, num_recs,
 				pages, num_pages);
 	if (ret)
@@ -1791,7 +1824,7 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 		mlog_errno(ret);
 		goto out;
 	}
-	ocfs2_init_refcount_extent_tree(&ref_et, INODE_CACHE(t_inode), ref_bh);
+	ocfs2_init_refcount_extent_tree(&ref_et, &ref_tree->rf_ci, ref_bh);
 	rb = (struct ocfs2_refcount_block *)ref_bh->b_data;
 
 	el = &di->id2.i_list;
@@ -2096,6 +2129,7 @@ static void ocfs2_insert_refcount_tree(struct ocfs2_super *osb,
 static void ocfs2_free_refcount_tree(struct ocfs2_super *osb,
 				     struct ocfs2_refcount_tree *tree)
 {
+	ocfs2_metadata_cache_exit(&tree->rf_ci);
 	ocfs2_simple_drop_lockres(osb, &tree->rf_lockres);
 	ocfs2_lock_res_free(&tree->rf_lockres);
 	kfree(tree);
@@ -2131,8 +2165,12 @@ static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
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
@@ -2226,3 +2264,55 @@ void ocfs2_purge_refcount_tree(struct ocfs2_super *osb)
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
index d108f4d..2930e29 100644
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
