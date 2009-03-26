From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:22 +0800
Subject: [Ocfs2-devel] [PATCH 16/42] ocfs2: Hook 'Decrement refcount for
	delete'.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-16-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add 'Decrement refcount for delete' in to the normal truncate
process. So for a refcounted extent record, call refcount rec
decrementation instead of cluster free.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |   48 ++++++++++++++++---
 fs/ocfs2/refcounttree.c |  118 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    4 ++
 3 files changed, 163 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index bbfb15a..d557d49 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6592,7 +6592,7 @@ out:
  */
 static int ocfs2_trim_tree(struct inode *inode, struct ocfs2_path *path,
 			   handle_t *handle, struct ocfs2_truncate_context *tc,
-			   u32 clusters_to_del, u64 *delete_start)
+			   u32 clusters_to_del, u64 *delete_start, u8 *flags)
 {
 	int ret, i, index = path->p_tree_depth;
 	u32 new_edge = 0;
@@ -6602,6 +6602,7 @@ static int ocfs2_trim_tree(struct inode *inode, struct ocfs2_path *path,
 	struct ocfs2_extent_rec *rec;
 
 	*delete_start = 0;
+	*flags = 0;
 
 	while (index >= 0) {
 		bh = path->p_node[index].bh;
@@ -6689,6 +6690,7 @@ find_tail_record:
 			*delete_start = le64_to_cpu(rec->e_blkno)
 				+ ocfs2_clusters_to_blocks(inode->i_sb,
 					le16_to_cpu(rec->e_leaf_clusters));
+			*flags = rec->e_flags;
 
 			/*
 			 * If it's now empty, remove this record.
@@ -6788,7 +6790,8 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 			     struct buffer_head *fe_bh,
 			     handle_t *handle,
 			     struct ocfs2_truncate_context *tc,
-			     struct ocfs2_path *path)
+			     struct ocfs2_path *path,
+			     struct ocfs2_alloc_context *meta_ac)
 {
 	int status;
 	struct ocfs2_dinode *fe;
@@ -6796,6 +6799,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	struct ocfs2_extent_list *el;
 	struct buffer_head *last_eb_bh = NULL;
 	u64 delete_blk = 0;
+	u8 rec_flags;
 
 	fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
@@ -6851,7 +6855,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	inode->i_blocks = ocfs2_inode_sector_count(inode);
 
 	status = ocfs2_trim_tree(inode, path, handle, tc,
-				 clusters_to_del, &delete_blk);
+				 clusters_to_del, &delete_blk, &rec_flags);
 	if (status) {
 		mlog_errno(status);
 		goto bail;
@@ -6883,8 +6887,16 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	}
 
 	if (delete_blk) {
-		status = ocfs2_truncate_log_append(osb, handle, delete_blk,
-						   clusters_to_del);
+		if (rec_flags & OCFS2_EXT_REFCOUNTED)
+			status = ocfs2_decrease_refcount(inode, fe_bh, handle,
+					ocfs2_blocks_to_clusters(osb->sb,
+								 delete_blk),
+					clusters_to_del, meta_ac,
+					&tc->tc_dealloc);
+		else
+			status = ocfs2_truncate_log_append(osb, handle,
+							   delete_blk,
+							   clusters_to_del);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -7312,6 +7324,7 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 	struct inode *tl_inode = osb->osb_tl_inode;
 	struct ocfs2_path *path = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
+	struct ocfs2_alloc_context *meta_ac = NULL;
 
 	mlog_entry_void();
 
@@ -7337,6 +7350,8 @@ start:
 		goto bail;
 	}
 
+	credits = 0;
+
 	/*
 	 * Truncate always works against the rightmost tree branch.
 	 */
@@ -7389,6 +7404,17 @@ start:
 	mlog(0, "clusters_to_del = %u in this pass, tail blk=%llu\n",
 	     clusters_to_del, (unsigned long long)path_leaf_bh(path)->b_blocknr);
 
+	if (el->l_recs[i].e_flags & OCFS2_EXT_REFCOUNTED) {
+		status = ocfs2_prepare_refcount_change_for_del(inode, fe_bh,
+							       clusters_to_del,
+							       &credits,
+							       &meta_ac);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
 	mutex_lock(&tl_inode->i_mutex);
 	tl_sem = 1;
 	/* ocfs2_truncate_log_needs_flush guarantees us at least one
@@ -7402,7 +7428,7 @@ start:
 		}
 	}
 
-	credits = ocfs2_calc_tree_trunc_credits(osb->sb, clusters_to_del,
+	credits += ocfs2_calc_tree_trunc_credits(osb->sb, clusters_to_del,
 						(struct ocfs2_dinode *)fe_bh->b_data,
 						el);
 	handle = ocfs2_start_trans(osb, credits);
@@ -7414,7 +7440,7 @@ start:
 	}
 
 	status = ocfs2_do_truncate(osb, clusters_to_del, inode, fe_bh, handle,
-				   tc, path);
+				   tc, path, meta_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -7428,6 +7454,11 @@ start:
 
 	ocfs2_reinit_path(path, 1);
 
+	if (meta_ac) {
+		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
+
 	/*
 	 * The check above will catch the case where we've truncated
 	 * away all allocation.
@@ -7442,6 +7473,9 @@ bail:
 
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+
 	if (tl_sem)
 		mutex_unlock(&tl_inode->i_mutex);
 
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 73b49cd..403087c 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -717,3 +717,121 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
 out:
 	return ret;
 }
+
+/*
+ * Calculate how much credits we need for reflink meta_add blocks.
+ * It is only used when we want to allocate a lot of metas at one time.
+ */
+static int ocfs2_calc_create_meta_credits(struct super_block *sb,
+					  struct ocfs2_extent_tree *et,
+					  int meta_add)
+{
+	int max_sub_alloc = 0, max_group;
+	int bitmap_blocks;
+
+	/*
+	 * calculate the global_bitmap first. It include all the group
+	 * and the dinode and one more group if we relink.
+	 */
+	max_group = meta_add / (OCFS2_SB(sb)->bitmap_cpg * 8) + 1;
+	bitmap_blocks = 1 + max_group * 2;
+
+	/* calculate the local alloc file. */
+	if (OCFS2_SB(sb)->local_alloc_bits)
+		max_sub_alloc = meta_add / OCFS2_SB(sb)->local_alloc_bits + 1;
+
+	mlog(0, "bitmap %d, max_sub %d, meta_add %d\n", bitmap_blocks,
+	     max_sub_alloc, meta_add);
+
+	return bitmap_blocks + max_sub_alloc + meta_add + 1 +
+	       ocfs2_quota_trans_credits(sb);
+}
+
+/*
+ * Calculate if we add len clusters to refcount tree how much meta and credits
+ * we need at most.
+ */
+static int ocfs2_calc_refcount_credits(struct super_block *sb,
+				       struct ocfs2_extent_tree *et,
+				       u32 len, int *meta_add, int *credits)
+{
+	int ret = 0;
+	int recs_per_eb = ocfs2_extent_recs_per_eb(sb);
+	int max_recs_needed = len + 2;
+	int max_eb_needed = max_recs_needed / recs_per_eb + 1;
+	int max_eb_level_2 = max_eb_needed / recs_per_eb + 1;
+	int num_free_extents = ocfs2_num_free_extents(OCFS2_SB(sb), et);
+
+	if (num_free_extents < 0) {
+		ret = num_free_extents;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	*credits += ocfs2_calc_extend_credits(sb,
+					      et->et_root_el,
+					      len);
+
+	if (num_free_extents < max_recs_needed) {
+		*meta_add += ocfs2_extend_meta_needed(et->et_root_el) *
+			     (max_eb_needed + max_eb_level_2);
+
+		*credits += ocfs2_calc_create_meta_credits(sb, et,
+					max_eb_needed + max_eb_level_2);
+	}
+out:
+	return ret;
+}
+
+int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
+					  struct buffer_head *di_bh,
+					  u32 clusters, int *credits,
+					  struct ocfs2_alloc_context **meta_ac)
+{
+	int ret, meta_add = 0;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct buffer_head *ref_bh = NULL;
+	struct ocfs2_refcount_block *rb;
+	struct ocfs2_extent_tree et;
+
+	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
+		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
+			    "tree, but the feature bit is not set in the "
+			    "super block.", inode->i_ino);
+		ret = -EROFS;
+		goto out;
+	}
+
+	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!di->i_refcount_loc);
+
+	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
+					le64_to_cpu(di->i_refcount_loc),
+					&ref_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	rb = (struct ocfs2_refcount_block *)ref_bh->b_data;
+	ocfs2_init_refcount_extent_tree(&et, INODE_CACHE(inode), ref_bh);
+
+	ret = ocfs2_calc_refcount_credits(inode->i_sb, &et, clusters,
+					  &meta_add, credits);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (meta_add) {
+		ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
+							meta_add, meta_ac);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+out:
+	brelse(ref_bh);
+	return ret;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 92fe116..9585a5f 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -27,4 +27,8 @@ int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 			    handle_t *handle, u32 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
 			    struct ocfs2_cached_dealloc_ctxt *dealloc);
+int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
+					  struct buffer_head *di_bh,
+					  u32 clusters, int *credits,
+					  struct ocfs2_alloc_context **meta_ac);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
