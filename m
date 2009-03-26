From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:45 +0800
Subject: [Ocfs2-devel] [PATCH 39/42] ocfs2: Add reflink support for xattr.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-39-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   34 ++-
 fs/ocfs2/refcounttree.h |    5 +
 fs/ocfs2/xattr.c        |  893 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/xattr.h        |    4 +
 4 files changed, 923 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index f72ae93..6d605d3 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -563,11 +563,11 @@ out:
 	return ret;
 }
 
-static int __ocfs2_increase_refcount(handle_t *handle,
-				     struct ocfs2_extent_tree *et,
-				     u32 cpos, u32 len,
-				     struct ocfs2_alloc_context *meta_ac,
-				     struct ocfs2_cached_dealloc_ctxt *dealloc)
+int ocfs2_increase_refcount(handle_t *handle,
+			    struct ocfs2_extent_tree *et,
+			    u32 cpos, u32 len,
+			    struct ocfs2_alloc_context *meta_ac,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	int ret = 0, index;
 	struct ocfs2_extent_rec rec;
@@ -1849,9 +1849,9 @@ int ocfs2_add_refcount_flag(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = __ocfs2_increase_refcount(handle, ref_et,
-					p_cluster, num_clusters,
-					meta_ac, dealloc);
+	ret = ocfs2_increase_refcount(handle, ref_et,
+				      p_cluster, num_clusters,
+				      meta_ac, dealloc);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -2007,9 +2007,9 @@ static int ocfs2_duplicate_extent_list(struct inode *s_inode,
 				break;
 			}
 
-			ret = __ocfs2_increase_refcount(handle, ref_et,
-							p_cluster, num_clusters,
-							meta_ac, dealloc);
+			ret = ocfs2_increase_refcount(handle, ref_et,
+						      p_cluster, num_clusters,
+						      meta_ac, dealloc);
 			if (ret) {
 				mlog_errno(ret);
 				break;
@@ -2145,9 +2145,17 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
 	}
 
 	ret = ocfs2_create_reflink_node(inode, old_bh, new_inode, new_bh);
-	if (ret)
+	if (ret) {
 		mlog_errno(ret);
+		goto inode_unlock;
+	}
 
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_XATTR_FL) {
+		ret = ocfs2_reflink_xattrs(inode, old_bh, new_inode, new_bh);
+		if (ret)
+			mlog_errno(ret);
+	}
+inode_unlock:
 	ocfs2_inode_unlock(new_inode, 1);
 	brelse(new_bh);
 out_unlock:
@@ -2215,12 +2223,14 @@ static int ocfs2_vfs_reflink(struct dentry *old_dentry,
 		goto out_unlock;
 	}
 
+	down_write(&OCFS2_I(inode)->ip_xattr_sem);
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 	DQUOT_INIT(dir);
 	error = __ocfs2_reflink(old_dentry, old_bh, new_orphan_inode);
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	if (error)
 		mlog_errno(error);
+	up_write(&OCFS2_I(inode)->ip_xattr_sem);
 
 	ocfs2_inode_unlock(inode, 1);
 	brelse(old_bh);
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index a995604..bdf19c6 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -101,4 +101,9 @@ int ocfs2_add_refcount_flag(struct inode *inode,
 			    u32 cpos, u32 p_cluster, u32 num_clusters,
 			    struct ocfs2_cached_dealloc_ctxt *dealloc,
 			    struct ocfs2_post_refcount *post);
+int ocfs2_increase_refcount(handle_t *handle,
+			    struct ocfs2_extent_tree *et,
+			    u32 cpos, u32 len,
+			    struct ocfs2_alloc_context *meta_ac,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc);
 #endif /* OCFS2_REFCOUNTTREE_H */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 556fae0..37c3bef 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5745,7 +5745,7 @@ static int ocfs2_get_xattr_tree_value_root(struct super_block *sb,
 			 OCFS2_XATTR_SIZE(xe->xe_name_len));
 
 	if (bh)
-		*bh = bucket->bu_bhs[offset];
+		*bh = bucket->bu_bhs[block_off];
 out:
 	return ret;
 }
@@ -5892,6 +5892,897 @@ out:
 }
 
 /*
+ * Store the information we need in xattr reflink.
+ * old_bh and new_bh are inode bh for the old and new inode.
+ */
+struct ocfs2_xattr_reflink {
+	struct inode *old_inode;
+	struct inode *new_inode;
+	struct buffer_head *old_bh;
+	struct buffer_head *new_bh;
+	struct ocfs2_extent_tree *ref_et;
+	struct ocfs2_cached_dealloc_ctxt *dealloc;
+};
+
+/*
+ * Given a xattr header and xe offset,
+ * return the proper xv and the corresponding bh.
+ * xattr in inode, block and xattr tree have different implementaions.
+ */
+typedef int (get_xattr_value_root)(struct super_block *sb,
+				   struct buffer_head *bh,
+				   struct ocfs2_xattr_header *xh,
+				   int offset,
+				   struct ocfs2_xattr_value_root **xv,
+				   struct buffer_head **ret_bh,
+				   void *para);
+
+/*
+ * Calculate all the xattr value root metadata stored in this xattr header and
+ * credits we need if we create them from the scratch.
+ * We use get_xattr_value_root so that all types of xattr container can use it.
+ */
+static int ocfs2_value_metas_in_xattr_header(struct super_block *sb,
+					     struct buffer_head *bh,
+					     struct ocfs2_xattr_header *xh,
+					     int *metas, int *credits,
+					     get_xattr_value_root *func,
+					     void *para)
+{
+	int i, ret = 0;
+	struct ocfs2_xattr_value_root *xv;
+	struct ocfs2_xattr_entry *xe;
+
+	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
+		xe = &xh->xh_entries[i];
+		if (ocfs2_xattr_is_local(xe))
+			continue;
+
+		ret = func(sb, bh, xh, i, &xv, NULL, para);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		*metas += le16_to_cpu(xv->xr_list.l_tree_depth) *
+			  le16_to_cpu(xv->xr_list.l_next_free_rec) + 1;
+
+		*credits += ocfs2_calc_extend_credits(sb,
+						&def_xv.xv.xr_list,
+						le32_to_cpu(xv->xr_clusters));
+	}
+
+	return ret;
+}
+
+/* Used by xattr inode and block to return the right xv and buffer_head. */
+static int ocfs2_get_xattr_value_root(struct super_block *sb,
+				      struct buffer_head *bh,
+				      struct ocfs2_xattr_header *xh,
+				      int offset,
+				      struct ocfs2_xattr_value_root **xv,
+				      struct buffer_head **ret_bh,
+				      void *para)
+{
+	struct ocfs2_xattr_entry *xe = &xh->xh_entries[offset];
+
+	*xv = (struct ocfs2_xattr_value_root *)((void *)xh +
+		le16_to_cpu(xe->xe_name_offset) +
+		OCFS2_XATTR_SIZE(xe->xe_name_len));
+
+	if (ret_bh)
+		*ret_bh = bh;
+
+	return 0;
+}
+
+/*
+ * Lock the meta_ac and caculate how much credits we need for reflink xattrs.
+ * It is only used for inline xattr and xattr block.
+ */
+static int ocfs2_reflink_lock_xattr_allocators(struct ocfs2_super *osb,
+					struct ocfs2_xattr_header *xh,
+					struct ocfs2_extent_tree *ref_et,
+					int *credits,
+					struct ocfs2_alloc_context **meta_ac)
+{
+	int ret, meta_add = 0;
+
+	*credits = 0;
+
+	ret = ocfs2_value_metas_in_xattr_header(osb->sb, NULL, xh,
+						&meta_add, credits,
+						ocfs2_get_xattr_value_root,
+						NULL);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	/*
+	 * We have to add credits for modifying all the metadata in the
+	 * refount tree.
+	 */
+	*credits += le16_to_cpu(ref_et->et_root_el->l_tree_depth) *
+		    le16_to_cpu(ref_et->et_root_el->l_next_free_rec) + 1;
+
+	ret = ocfs2_reserve_new_metadata_blocks(osb, meta_add, meta_ac);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	return ret;
+}
+
+/*
+ * Given a xattr header, reflink all the xattrs in this container.
+ * It can be used for inode, block and bucket.
+ *
+ * NOTE:
+ * Before we call this function, the caller has memcpy the xattr in
+ * old_xh to the new_xh.
+ */
+static int ocfs2_reflink_xattr_header(handle_t *handle,
+				      struct ocfs2_xattr_reflink *args,
+				      struct buffer_head *old_bh,
+				      struct ocfs2_xattr_header *xh,
+				      struct buffer_head *new_bh,
+				      struct ocfs2_xattr_header *new_xh,
+				      struct ocfs2_xattr_value_buf *vb,
+				      struct ocfs2_alloc_context *meta_ac,
+				      get_xattr_value_root *func,
+				      void *para)
+{
+	int ret = 0, i;
+	struct super_block *sb = args->old_inode->i_sb;
+	struct buffer_head *value_bh;
+	struct ocfs2_xattr_entry *xe;
+	struct ocfs2_xattr_value_root *xv, *new_xv;
+	struct ocfs2_extent_tree data_et;
+	struct ocfs2_extent_rec rec;
+	u32 clusters, cpos, p_cluster, num_clusters;
+	unsigned int ext_flags = 0;
+
+	mlog(0, "reflink xattr in container %llu, count = %u\n",
+	     (unsigned long long)old_bh->b_blocknr, le16_to_cpu(xh->xh_count));
+	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
+		xe = &xh->xh_entries[i];
+
+		if (ocfs2_xattr_is_local(xe))
+			continue;
+
+		ret = func(sb, old_bh, xh, i, &xv, NULL, para);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		ret = func(sb, new_bh, new_xh, i, &new_xv, &value_bh, para);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		/*
+		 * For the xattr which has l_tree_depth = 0, all the extent
+		 * recs have already be copied to the new xh with the
+		 * propriate OCFS2_EXT_REFCOUNTED flag we just need to
+		 * increase the refount count int the refcount tree.
+		 *
+		 * For the xattr which has l_tree_depth > 0, we need
+		 * to initialize it to the empty default value root,
+		 * and then insert the extents one by one.
+		 */
+		if (xv->xr_list.l_tree_depth) {
+			memcpy(new_xv, &def_xv, sizeof(def_xv));
+			vb->vb_xv = new_xv;
+			vb->vb_bh = value_bh;
+			ocfs2_init_xattr_value_extent_tree(&data_et,
+					INODE_CACHE(args->new_inode), vb);
+		}
+
+		clusters = le32_to_cpu(xv->xr_clusters);
+		cpos = 0;
+		while (cpos < clusters) {
+			ret = ocfs2_xattr_get_clusters(args->old_inode,
+						       cpos,
+						       &p_cluster,
+						       &num_clusters,
+						       &xv->xr_list,
+						       &ext_flags);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			BUG_ON(!p_cluster);
+
+			if (xv->xr_list.l_tree_depth) {
+				memset(&rec, 0, sizeof(rec));
+				rec.e_cpos = cpu_to_le32(cpos);
+				rec.e_int_clusters = cpu_to_le32(num_clusters);
+				rec.e_blkno = cpu_to_le64(
+				     ocfs2_clusters_to_blocks(
+							args->old_inode->i_sb,
+							p_cluster));
+				rec.e_flags = ext_flags;
+
+				ret = ocfs2_insert_extent(handle, &data_et,
+							  &rec, meta_ac);
+				if (ret) {
+					mlog_errno(ret);
+					goto out;
+				}
+			}
+
+			ret = ocfs2_increase_refcount(handle, args->ref_et,
+						      p_cluster, num_clusters,
+						      meta_ac, args->dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			cpos += num_clusters;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
+{
+	int ret = 0, credits = 0;
+	handle_t *handle;
+	struct ocfs2_super *osb = OCFS2_SB(args->old_inode->i_sb);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)args->old_bh->b_data;
+	int inline_size = le16_to_cpu(di->i_xattr_inline_size);
+	int header_off = osb->sb->s_blocksize - inline_size;
+	struct ocfs2_xattr_header *xh = (struct ocfs2_xattr_header *)
+					(args->old_bh->b_data + header_off);
+	struct ocfs2_xattr_header *new_xh = (struct ocfs2_xattr_header *)
+					(args->new_bh->b_data + header_off);
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_inode_info *new_oi;
+	struct ocfs2_dinode *new_di;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = args->new_bh,
+		.vb_access = ocfs2_journal_access_di,
+	};
+
+	ret = ocfs2_reflink_lock_xattr_allocators(osb, xh, args->ref_et,
+						  &credits, &meta_ac);
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
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(args->new_inode),
+				      args->new_bh, OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	memcpy(args->new_bh->b_data + header_off,
+	       args->old_bh->b_data + header_off, inline_size);
+
+	new_di = (struct ocfs2_dinode *)args->new_bh->b_data;
+	new_di->i_xattr_inline_size = cpu_to_le16(inline_size);
+
+	ret = ocfs2_reflink_xattr_header(handle, args, args->old_bh, xh,
+					 args->new_bh, new_xh, &vb, meta_ac,
+					 ocfs2_get_xattr_value_root, NULL);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	new_oi = OCFS2_I(args->new_inode);
+	spin_lock(&new_oi->ip_lock);
+	new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL | OCFS2_INLINE_XATTR_FL;
+	new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);
+	spin_unlock(&new_oi->ip_lock);
+
+	ocfs2_journal_dirty(handle, args->new_bh);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out:
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+	return ret;
+}
+
+static int ocfs2_create_empty_xattr_block(struct inode *inode,
+					  struct buffer_head *fe_bh,
+					  struct buffer_head **ret_bh,
+					  int indexed)
+{
+	int ret;
+	handle_t *handle;
+	struct ocfs2_alloc_context *meta_ac;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_XATTR_BLOCK_CREATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "create new xattr block for inode %llu, index = %d\n",
+	     (unsigned long long)fe_bh->b_blocknr, indexed);
+	ret = ocfs2_create_xattr_block(handle, inode, fe_bh,
+				       meta_ac, ret_bh, indexed);
+	if (ret)
+		mlog_errno(ret);
+
+	ocfs2_commit_trans(osb, handle);
+out:
+	ocfs2_free_alloc_context(meta_ac);
+	return ret;
+}
+
+static int ocfs2_reflink_xattr_block(struct ocfs2_xattr_reflink *args,
+				     struct buffer_head *blk_bh,
+				     struct buffer_head *new_blk_bh)
+{
+	int ret = 0, credits = 0;
+	handle_t *handle;
+	struct ocfs2_inode_info *new_oi = OCFS2_I(args->new_inode);
+	struct ocfs2_dinode *new_di;
+	struct ocfs2_super *osb = OCFS2_SB(args->new_inode->i_sb);
+	int header_off = offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)blk_bh->b_data;
+	struct ocfs2_xattr_header *xh = &xb->xb_attrs.xb_header;
+	struct ocfs2_xattr_block *new_xb =
+			(struct ocfs2_xattr_block *)new_blk_bh->b_data;
+	struct ocfs2_xattr_header *new_xh = &new_xb->xb_attrs.xb_header;
+	struct ocfs2_alloc_context *meta_ac;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = new_blk_bh,
+		.vb_access = ocfs2_journal_access_xb,
+	};
+
+	ret = ocfs2_reflink_lock_xattr_allocators(osb, xh, args->ref_et,
+						  &credits, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	/* One more credits in case we need to add xattr flags in new inode. */
+	handle = ocfs2_start_trans(osb, credits + 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (!(new_oi->ip_dyn_features & OCFS2_HAS_XATTR_FL)) {
+		ret = ocfs2_journal_access_di(handle,
+					      INODE_CACHE(args->new_inode),
+					      args->new_bh,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+	}
+
+	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(args->new_inode),
+				      new_blk_bh, OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	memcpy(new_blk_bh->b_data + header_off, blk_bh->b_data + header_off,
+	       osb->sb->s_blocksize - header_off);
+
+	ret = ocfs2_reflink_xattr_header(handle, args, blk_bh, xh,
+					 new_blk_bh, new_xh, &vb, meta_ac,
+					 ocfs2_get_xattr_value_root, NULL);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ocfs2_journal_dirty(handle, new_blk_bh);
+
+	if (!(new_oi->ip_dyn_features & OCFS2_HAS_XATTR_FL)) {
+		new_di = (struct ocfs2_dinode *)args->new_bh->b_data;
+		spin_lock(&new_oi->ip_lock);
+		new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL;
+		new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);
+		spin_unlock(&new_oi->ip_lock);
+
+		ocfs2_journal_dirty(handle, args->new_bh);
+	}
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out:
+	ocfs2_free_alloc_context(meta_ac);
+	return ret;
+}
+
+struct ocfs2_reflink_xattr_tree_args {
+	struct ocfs2_xattr_reflink *reflink;
+	struct buffer_head *old_blk_bh;
+	struct buffer_head *new_blk_bh;
+	struct ocfs2_xattr_bucket *old_bucket;
+	struct ocfs2_xattr_bucket *new_bucket;
+};
+
+/*
+ * NOTE:
+ * We have to handle the case that both old bucket and new bucket
+ * will call this function to get the right ret_bh.
+ * So The caller must give us the right bh.
+ */
+static int ocfs2_get_reflink_xattr_value_root(struct super_block *sb,
+					struct buffer_head *bh,
+					struct ocfs2_xattr_header *xh,
+					int offset,
+					struct ocfs2_xattr_value_root **xv,
+					struct buffer_head **ret_bh,
+					void *para)
+{
+	struct ocfs2_reflink_xattr_tree_args *args =
+			(struct ocfs2_reflink_xattr_tree_args *)para;
+	struct ocfs2_xattr_bucket *bucket;
+
+	if (bh == args->old_bucket->bu_bhs[0])
+		bucket = args->old_bucket;
+	else
+		bucket = args->new_bucket;
+
+	return ocfs2_get_xattr_tree_value_root(sb, bucket, offset,
+					       xv, ret_bh);
+}
+
+struct ocfs2_value_tree_metas {
+	int num_metas;
+	int credits;
+};
+
+static int ocfs2_value_tree_metas_in_bucket(struct super_block *sb,
+					struct buffer_head *bh,
+					struct ocfs2_xattr_header *xh,
+					int offset,
+					struct ocfs2_xattr_value_root **xv,
+					struct buffer_head **ret_bh,
+					void *para)
+{
+	struct ocfs2_xattr_bucket *bucket =
+				(struct ocfs2_xattr_bucket *)para;
+
+	return ocfs2_get_xattr_tree_value_root(sb, bucket, offset,
+					       xv, ret_bh);
+}
+
+static int ocfs2_calc_value_tree_metas(struct inode *inode,
+				      struct ocfs2_xattr_bucket *bucket,
+				      void *para)
+{
+	struct ocfs2_value_tree_metas *metas =
+			(struct ocfs2_value_tree_metas *)para;
+	struct ocfs2_xattr_header *xh =
+			(struct ocfs2_xattr_header *)bucket->bu_bhs[0]->b_data;
+
+	/* Add the credits for this bucket first. */
+	metas->credits += bucket->bu_blocks;
+	return ocfs2_value_metas_in_xattr_header(inode->i_sb, bucket->bu_bhs[0],
+					xh, &metas->num_metas,
+					&metas->credits,
+					ocfs2_value_tree_metas_in_bucket,
+					bucket);
+}
+
+/*
+ * Given a xattr extent rec starting from blkno and having len clusters,
+ * iterate all the buckets calculate how much metadata we need for reflinking
+ * all the ocfs2_xattr_value_root and lock the allocators accordingly.
+ */
+static int ocfs2_lock_reflink_xattr_rec_allocators(
+				struct ocfs2_reflink_xattr_tree_args *args,
+				struct ocfs2_extent_tree *xt_et,
+				u64 blkno, u32 len, int *credits,
+				struct ocfs2_alloc_context **meta_ac,
+				struct ocfs2_alloc_context **data_ac)
+{
+	int ret, num_free_extents;
+	struct ocfs2_value_tree_metas metas;
+	struct ocfs2_extent_tree *ref_et = args->reflink->ref_et;
+	struct ocfs2_super *osb = OCFS2_SB(args->reflink->old_inode->i_sb);
+
+	memset(&metas, 0, sizeof(metas));
+
+	ret = ocfs2_iterate_xattr_buckets(args->reflink->old_inode, blkno, len,
+					  ocfs2_calc_value_tree_metas, &metas);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * We have to add credits for modifying all the metadata in the
+	 * refount tree.
+	 */
+	*credits = metas.credits +
+		   le16_to_cpu(ref_et->et_root_el->l_tree_depth) *
+		   le16_to_cpu(ref_et->et_root_el->l_next_free_rec) + 1;
+
+	/* count in the xattr tree change. */
+	num_free_extents = ocfs2_num_free_extents(osb, xt_et);
+	if (num_free_extents < 0) {
+		ret = num_free_extents;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (num_free_extents < len)
+		metas.num_metas += ocfs2_extend_meta_needed(xt_et->et_root_el);
+
+	*credits += ocfs2_calc_extend_credits(osb->sb,
+					      xt_et->et_root_el, len);
+
+	if (metas.num_metas) {
+		ret = ocfs2_reserve_new_metadata_blocks(osb, metas.num_metas,
+							meta_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	if (len) {
+		ret = ocfs2_reserve_clusters(osb, len, data_ac);
+		if (ret)
+			mlog_errno(ret);
+	}
+out:
+	if (ret) {
+		if (*meta_ac) {
+			ocfs2_free_alloc_context(*meta_ac);
+			meta_ac = NULL;
+		}
+	}
+
+	return ret;
+}
+
+static int ocfs2_reflink_xattr_buckets(handle_t *handle,
+				u64 blkno, u64 new_blkno, u32 clusters,
+				struct ocfs2_alloc_context *meta_ac,
+				struct ocfs2_alloc_context *data_ac,
+				struct ocfs2_reflink_xattr_tree_args *args)
+{
+	int i, j, ret = 0;
+	struct super_block *sb = args->reflink->old_inode->i_sb;
+	u32 bpc = ocfs2_xattr_buckets_per_cluster(OCFS2_SB(sb));
+	u32 num_buckets = clusters * bpc;
+	int bpb = args->old_bucket->bu_blocks;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_access = ocfs2_journal_access,
+	};
+
+	for (i = 0; i < num_buckets; i++, blkno += bpb, new_blkno += bpb) {
+		ret = ocfs2_read_xattr_bucket(args->old_bucket, blkno);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		ret = ocfs2_init_xattr_bucket(args->new_bucket, new_blkno);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		/*
+		 * The real bucket num in this series of blocks is stored
+		 * in the 1st bucket.
+		 */
+		if (i == 0)
+			num_buckets = le16_to_cpu(
+				bucket_xh(args->old_bucket)->xh_num_buckets);
+
+		ret = ocfs2_xattr_bucket_journal_access(handle,
+						args->new_bucket,
+						OCFS2_JOURNAL_ACCESS_CREATE);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		for (j = 0; j < bpb; j++)
+			memcpy(bucket_block(args->new_bucket, j),
+			       bucket_block(args->old_bucket, j),
+			       sb->s_blocksize);
+
+		ocfs2_xattr_bucket_journal_dirty(handle, args->new_bucket);
+
+		ret = ocfs2_reflink_xattr_header(handle, args->reflink,
+					args->old_bucket->bu_bhs[0],
+					bucket_xh(args->old_bucket),
+					args->new_bucket->bu_bhs[0],
+					bucket_xh(args->new_bucket),
+					&vb, meta_ac,
+					ocfs2_get_reflink_xattr_value_root,
+					args);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		/*
+		 * Re-access and dirty the bucket to calculate metaecc.
+		 * Because we may extend the transaction in reflink_xattr_header
+		 * which will let the already accessed block gone.
+		 */
+		ret = ocfs2_xattr_bucket_journal_access(handle,
+						args->new_bucket,
+						OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		ocfs2_xattr_bucket_journal_dirty(handle, args->new_bucket);
+		ocfs2_xattr_bucket_relse(args->old_bucket);
+		ocfs2_xattr_bucket_relse(args->new_bucket);
+	}
+
+	ocfs2_xattr_bucket_relse(args->old_bucket);
+	ocfs2_xattr_bucket_relse(args->new_bucket);
+	return ret;
+}
+/*
+ * Create the same xattr extent record in the new inode's xattr tree.
+ */
+static int ocfs2_reflink_xattr_rec(struct inode *inode,
+				   struct buffer_head *root_bh,
+				   u64 blkno,
+				   u32 cpos,
+				   u32 len,
+				   void *para)
+{
+	int ret, credits = 0;
+	u32 p_cluster, num_clusters;
+	u64 new_blkno;
+	handle_t *handle;
+	struct ocfs2_reflink_xattr_tree_args *args =
+			(struct ocfs2_reflink_xattr_tree_args *)para;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_alloc_context *data_ac = NULL;
+	struct ocfs2_extent_tree et;
+	struct ocfs2_extent_rec rec;
+
+	ocfs2_init_xattr_tree_extent_tree(&et,
+					  INODE_CACHE(args->reflink->new_inode),
+					  args->new_blk_bh);
+
+	ret = ocfs2_lock_reflink_xattr_rec_allocators(args, &et, blkno,
+						      len, &credits,
+						      &meta_ac, &data_ac);
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
+	ret = ocfs2_claim_clusters(osb, handle, data_ac,
+				   len, &p_cluster, &num_clusters);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	new_blkno = ocfs2_clusters_to_blocks(osb->sb, p_cluster);
+
+	mlog(0, "reflink xattr buckets %llu to %llu, len %u\n",
+	     (unsigned long long)blkno, (unsigned long long)new_blkno, len);
+	ret = ocfs2_reflink_xattr_buckets(handle, blkno, new_blkno, len,
+					  meta_ac, data_ac, args);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	memset(&rec, 0, sizeof(rec));
+	rec.e_cpos = cpu_to_le32(cpos);
+	rec.e_leaf_clusters = cpu_to_le16(len);
+	rec.e_blkno = cpu_to_le64(new_blkno);
+
+	mlog(0, "insert new xattr extent rec start %llu len %u to %u\n",
+	     (unsigned long long)new_blkno, len, cpos);
+	ret = ocfs2_insert_extent(handle, &et, &rec, meta_ac);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out:
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+	if (data_ac)
+		ocfs2_free_alloc_context(data_ac);
+	return ret;
+}
+
+/*
+ * Create reflinked xattr buckets.
+ * We will add bucket one by one, and refcount all the xattrs in the bucket
+ * if they are stored outside.
+ */
+static int ocfs2_reflink_xattr_tree(struct ocfs2_xattr_reflink *args,
+				    struct buffer_head *blk_bh,
+				    struct buffer_head *new_blk_bh)
+{
+	int ret;
+	struct ocfs2_reflink_xattr_tree_args para;
+
+	memset(&para, 0, sizeof(para));
+	para.reflink = args;
+	para.old_blk_bh = blk_bh;
+	para.new_blk_bh = new_blk_bh;
+
+	para.old_bucket = ocfs2_xattr_bucket_new(args->old_inode);
+	if (!para.old_bucket) {
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
+	}
+
+	para.new_bucket = ocfs2_xattr_bucket_new(args->new_inode);
+	if (!para.new_bucket) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_iterate_xattr_index_block(args->old_inode, blk_bh,
+					      ocfs2_reflink_xattr_rec,
+					      &para);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	ocfs2_xattr_bucket_free(para.old_bucket);
+	ocfs2_xattr_bucket_free(para.new_bucket);
+	return ret;
+}
+
+static int ocfs2_reflink_xattr_in_block(struct ocfs2_xattr_reflink *args,
+					struct buffer_head *blk_bh)
+{
+	int ret, indexed = 0;
+	struct buffer_head *new_blk_bh = NULL;
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)blk_bh->b_data;
+
+
+	if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)
+		indexed = 1;
+
+	ret = ocfs2_create_empty_xattr_block(args->new_inode, args->new_bh,
+					     &new_blk_bh, indexed);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED))
+		ret = ocfs2_reflink_xattr_block(args, blk_bh, new_blk_bh);
+	else
+		ret = ocfs2_reflink_xattr_tree(args, blk_bh, new_blk_bh);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	brelse(new_blk_bh);
+	return ret;
+}
+
+int ocfs2_reflink_xattrs(struct inode *old_inode,
+			 struct buffer_head *old_bh,
+			 struct inode *new_inode,
+			 struct buffer_head *new_bh)
+{
+	int ret;
+	struct ocfs2_xattr_reflink args;
+	struct ocfs2_inode_info *oi = OCFS2_I(old_inode);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)old_bh->b_data;
+	struct buffer_head *blk_bh = NULL;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_refcount_tree *ref_tree;
+	struct buffer_head *ref_bh = NULL;
+	struct ocfs2_extent_tree ref_et;
+
+	ret = ocfs2_lock_refcount_tree(OCFS2_SB(old_inode->i_sb),
+				       le64_to_cpu(di->i_refcount_loc),
+				       1, &ref_tree, &ref_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_init_refcount_extent_tree(&ref_et, &ref_tree->rf_ci, ref_bh);
+
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	args.old_inode = old_inode;
+	args.new_inode = new_inode;
+	args.old_bh = old_bh;
+	args.new_bh = new_bh;
+	args.ref_et = &ref_et;
+	args.dealloc = &dealloc;
+
+	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
+		ret = ocfs2_reflink_xattr_inline(&args);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_unlock;
+		}
+	}
+
+	if (!di->i_xattr_loc)
+		goto out_unlock;
+
+	ret = ocfs2_read_xattr_block(old_inode, le64_to_cpu(di->i_xattr_loc),
+				     &blk_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ret = ocfs2_reflink_xattr_in_block(&args, blk_bh);
+	if (ret)
+		mlog_errno(ret);
+
+	brelse(blk_bh);
+
+out_unlock:
+	ocfs2_unlock_refcount_tree(OCFS2_SB(old_inode->i_sb),
+				   ref_tree, 1);
+	brelse(ref_bh);
+
+	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+		ocfs2_schedule_truncate_log_flush(OCFS2_SB(old_inode->i_sb), 1);
+		ocfs2_run_deallocs(OCFS2_SB(old_inode->i_sb), &dealloc);
+	}
+
+out:
+	return ret;
+}
+
+/*
  * 'security' attributes support
  */
 static size_t ocfs2_xattr_security_list(struct inode *inode, char *list,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index e5e67e6..3a75cb3 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -89,4 +89,8 @@ int ocfs2_xattr_attach_refcount_tree(struct inode *inode,
 				     struct buffer_head *fe_bh,
 				     struct ocfs2_extent_tree *ref_et,
 				     struct ocfs2_cached_dealloc_ctxt *dealloc);
+int ocfs2_reflink_xattrs(struct inode *old_inode,
+			 struct buffer_head *old_bh,
+			 struct inode *new_inode,
+			 struct buffer_head *new_bh);
 #endif /* OCFS2_XATTR_H */
-- 
1.6.2.rc2.16.gf474c
