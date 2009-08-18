From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:22 +0800
Subject: [Ocfs2-devel] [PATCH 21/41] ocfs2: Add normal functions for reflink
	a normal file's extents.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-21-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

2 major functions are added in this patch.

ocfs2_attach_refcount_tree will create a new refcount tree to the
old file if it doesn't have one and insert all the extent records
to the tree if they are not refcounted.

ocfs2_create_reflink_node will:
1. set the refcount tree to the new file.
2. call ocfs2_duplicate_extent_list which will iterate all the
   extents for the old file, insert it to the new file and increase
   the corresponding referennce count.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |  286 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 286 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 0231f17..ec07518 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3139,3 +3139,289 @@ int ocfs2_refcount_cow(struct inode *inode,
 out:
 	return ret;
 }
+
+/*
+ * Insert a new extent into refcount tree and mark a extent rec
+ * as refcounted in the dinode tree.
+ */
+int ocfs2_add_refcount_flag(struct inode *inode,
+			    struct ocfs2_extent_tree *data_et,
+			    struct ocfs2_caching_info *ref_ci,
+			    struct buffer_head *ref_root_bh,
+			    u32 cpos, u32 p_cluster, u32 num_clusters,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	handle_t *handle;
+	int credits = 1, ref_blocks = 0;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_alloc_context *meta_ac = NULL;
+
+	ret = ocfs2_calc_refcount_meta_credits(inode->i_sb,
+					       ref_ci, ref_root_bh,
+					       p_cluster, num_clusters,
+					       &ref_blocks, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "reserve new metadata %d, credits = %d\n",
+	     ref_blocks, credits);
+
+	if (ref_blocks) {
+		ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
+							ref_blocks, &meta_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_mark_extent_refcounted(inode, data_et, handle,
+					   cpos, num_clusters, p_cluster,
+					   meta_ac, dealloc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = __ocfs2_increase_refcount(handle, ref_ci, ref_root_bh,
+					p_cluster, num_clusters,
+					meta_ac, dealloc);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+	return ret;
+}
+
+static int ocfs2_attach_refcount_tree(struct inode *inode,
+				      struct buffer_head *di_bh)
+{
+	int ret;
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_refcount_tree *ref_tree;
+	unsigned int ext_flags;
+	loff_t size;
+	u32 cpos, num_clusters, clusters, p_cluster;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_extent_tree di_et;
+
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	if (!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL)) {
+		ret = ocfs2_create_refcount_tree(inode, di_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	BUG_ON(!di->i_refcount_loc);
+	ret = ocfs2_lock_refcount_tree(osb,
+				       le64_to_cpu(di->i_refcount_loc), 1,
+				       &ref_tree, &ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_init_dinode_extent_tree(&di_et, INODE_CACHE(inode), di_bh);
+
+	size = i_size_read(inode);
+	clusters = ocfs2_clusters_for_bytes(inode->i_sb, size);
+
+	cpos = 0;
+	while (cpos < clusters) {
+		ret = ocfs2_get_clusters(inode, cpos, &p_cluster,
+					 &num_clusters, &ext_flags);
+
+		if (p_cluster && !(ext_flags & OCFS2_EXT_REFCOUNTED)) {
+			ret = ocfs2_add_refcount_flag(inode, &di_et,
+						      &ref_tree->rf_ci,
+						      ref_root_bh, cpos,
+						      p_cluster, num_clusters,
+						      &dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				break;
+			}
+		}
+		cpos += num_clusters;
+	}
+
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	brelse(ref_root_bh);
+
+	if (!ret && ocfs2_dealloc_has_cluster(&dealloc)) {
+		ocfs2_schedule_truncate_log_flush(osb, 1);
+		ocfs2_run_deallocs(osb, &dealloc);
+	}
+out:
+	/*
+	 * Empty the extent map so that we may get the right extent
+	 * record from the disk.
+	 */
+	ocfs2_extent_map_trunc(inode, 0);
+
+	return ret;
+}
+
+static int ocfs2_add_refcounted_extent(struct inode *inode,
+				   struct ocfs2_extent_tree *et,
+				   struct ocfs2_caching_info *ref_ci,
+				   struct buffer_head *ref_root_bh,
+				   u32 cpos, u32 p_cluster, u32 num_clusters,
+				   unsigned int ext_flags,
+				   struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	handle_t *handle;
+	int credits = 0;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_alloc_context *meta_ac = NULL;
+
+	ret = ocfs2_lock_refcount_allocators(inode->i_sb,
+					     p_cluster, num_clusters,
+					     et, ref_ci,
+					     ref_root_bh, &meta_ac,
+					     NULL, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_insert_extent(handle, et, cpos,
+			cpu_to_le64(ocfs2_clusters_to_blocks(inode->i_sb,
+							     p_cluster)),
+			num_clusters, ext_flags, meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = __ocfs2_increase_refcount(handle, ref_ci, ref_root_bh,
+					p_cluster, num_clusters,
+					meta_ac, dealloc);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+	return ret;
+}
+
+static int ocfs2_duplicate_extent_list(struct inode *s_inode,
+				struct inode *t_inode,
+				struct buffer_head *t_bh,
+				struct ocfs2_caching_info *ref_ci,
+				struct buffer_head *ref_root_bh,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret = 0;
+	u32 p_cluster, num_clusters, clusters, cpos;
+	loff_t size;
+	unsigned int ext_flags;
+	struct ocfs2_extent_tree et;
+
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(t_inode), t_bh);
+
+	size = i_size_read(s_inode);
+	clusters = ocfs2_clusters_for_bytes(s_inode->i_sb, size);
+
+	cpos = 0;
+	while (cpos < clusters) {
+		ret = ocfs2_get_clusters(s_inode, cpos, &p_cluster,
+					 &num_clusters, &ext_flags);
+
+		if (p_cluster) {
+			ret = ocfs2_add_refcounted_extent(t_inode, &et,
+							  ref_ci, ref_root_bh,
+							  cpos, p_cluster,
+							  num_clusters,
+							  ext_flags,
+							  dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		}
+
+		cpos += num_clusters;
+	}
+
+out:
+	return ret;
+}
+
+static int ocfs2_create_reflink_node(struct inode *s_inode,
+				     struct buffer_head *s_bh,
+				     struct inode *t_inode,
+				     struct buffer_head *t_bh)
+{
+	int ret;
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_super *osb = OCFS2_SB(s_inode->i_sb);
+	struct ocfs2_refcount_block *rb;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)s_bh->b_data;
+	struct ocfs2_refcount_tree *ref_tree;
+
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	ret = ocfs2_set_refcount_tree(t_inode, t_bh,
+				      le64_to_cpu(di->i_refcount_loc));
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_lock_refcount_tree(osb, le64_to_cpu(di->i_refcount_loc),
+				       1, &ref_tree, &ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
+
+	ret = ocfs2_duplicate_extent_list(s_inode, t_inode, t_bh,
+					  &ref_tree->rf_ci, ref_root_bh,
+					  &dealloc);
+	if (ret)
+		mlog_errno(ret);
+
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	brelse(ref_root_bh);
+out:
+	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+		ocfs2_schedule_truncate_log_flush(osb, 1);
+		ocfs2_run_deallocs(osb, &dealloc);
+	}
+
+	return ret;
+}
-- 
1.6.2.rc2.16.gf474c
