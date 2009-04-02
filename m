From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:46:15 +0800
Subject: [Ocfs2-devel] [PATCH 36/42] ocfs2: Attach xattr clusters to
	refcount tree.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-36-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2, when xattr's value is larger than OCFS2_XATTR_INLINE_SIZE,
it will be kept outside of the blocks we store xattr entry. And they
are stored in a b-tree also. So this patch try to attach all these
clusters to refcount tree also.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   36 +++++--
 fs/ocfs2/refcounttree.h |    6 +
 fs/ocfs2/xattr.c        |  279 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.h        |    5 +-
 4 files changed, 317 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 7eaab1d..d680edb 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1708,11 +1708,12 @@ out:
  * Insert a new extent into refcount tree and mark a extent rec
  * as refcounted in the dinode tree.
  */
-static int ocfs2_add_refcount_flag(struct inode *inode,
-				   struct ocfs2_extent_tree *di_et,
-				   struct ocfs2_extent_tree *ref_et,
-				   u32 cpos, u32 p_cluster, u32 num_clusters,
-				   struct ocfs2_cached_dealloc_ctxt *dealloc)
+int ocfs2_add_refcount_flag(struct inode *inode,
+			    struct ocfs2_extent_tree *data_et,
+			    struct ocfs2_extent_tree *ref_et,
+			    u32 cpos, u32 p_cluster, u32 num_clusters,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc,
+			    struct ocfs2_post_refcount *post)
 {
 	int ret;
 	handle_t *handle;
@@ -1729,6 +1730,8 @@ static int ocfs2_add_refcount_flag(struct inode *inode,
 	credits += ocfs2_calc_extend_credits(inode->i_sb,
 					     ref_et->et_root_el, 0);
 
+	if (post)
+		credits += post->credits;
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -1736,7 +1739,7 @@ static int ocfs2_add_refcount_flag(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_mark_extent_refcounted(inode, di_et, handle,
+	ret = ocfs2_mark_extent_refcounted(inode, data_et, handle,
 					   cpos, num_clusters, p_cluster,
 					   meta_ac, dealloc);
 	if (ret) {
@@ -1747,8 +1750,17 @@ static int ocfs2_add_refcount_flag(struct inode *inode,
 	ret = __ocfs2_increase_refcount(handle, ref_et,
 					p_cluster, num_clusters,
 					meta_ac, dealloc);
-	if (ret)
+	if (ret) {
 		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/* handle some pos_cow case. */
+	if (post && post->func) {
+		ret = post->func(inode, handle, post->para);
+		if (ret)
+			mlog_errno(ret);
+	}
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
@@ -1811,7 +1823,7 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 		ret = ocfs2_add_refcount_flag(inode, &di_et, &ref_et,
 					      cpos - num_clusters,
 					      p_cluster, num_clusters,
-					      &dealloc);
+					      &dealloc, NULL);
 		if (ret) {
 			mlog_errno(ret);
 			break;
@@ -1824,6 +1836,14 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 	 */
 	ocfs2_extent_map_trunc(inode, 0);
 
+	if (oi->ip_dyn_features & OCFS2_HAS_XATTR_FL) {
+		ret = ocfs2_xattr_attach_refcount_tree(inode, fe_bh,
+						       &ref_et, &dealloc);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_bh);
 
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 32ae584..0ad42c0 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -93,4 +93,10 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
 			     struct buffer_head *ref_bh,
 			     u32 cpos, u32 write_len,
 			     struct ocfs2_post_refcount *post);
+int ocfs2_add_refcount_flag(struct inode *inode,
+			    struct ocfs2_extent_tree *data_et,
+			    struct ocfs2_extent_tree *ref_et,
+			    u32 cpos, u32 p_cluster, u32 num_clusters,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc,
+			    struct ocfs2_post_refcount *post);
 #endif /* OCFS2_REFCOUNTTREE_H */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index c67ba60..b606604 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5578,6 +5578,285 @@ out:
 }
 
 /*
+ * Add the REFCOUNTED flags for all the extent rec in ocfs2_xattr_value_root.
+ * The physical clusters will be added to refcount tree.
+ */
+static int ocfs2_xattr_value_attach_refcount(struct inode *inode,
+				struct ocfs2_xattr_value_root *xv,
+				struct ocfs2_extent_tree *value_et,
+				struct ocfs2_extent_tree *ref_et,
+				struct ocfs2_cached_dealloc_ctxt *dealloc,
+				struct ocfs2_post_refcount *refcount)
+{
+	int ret = 0;
+	u32 clusters = le32_to_cpu(xv->xr_clusters);
+	u32 cpos, p_cluster, num_clusters;
+	struct ocfs2_extent_list *el = &xv->xr_list;
+	unsigned int ext_flags;
+
+	cpos = 0;
+	while (cpos < clusters) {
+		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
+					       &num_clusters, el, &ext_flags);
+
+		cpos += num_clusters;
+		if ((ext_flags & OCFS2_EXT_REFCOUNTED))
+			continue;
+
+		BUG_ON(!p_cluster);
+
+		ret = ocfs2_add_refcount_flag(inode, value_et, ref_et,
+					      cpos - num_clusters,
+					      p_cluster, num_clusters,
+					      dealloc, refcount);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Given a normal ocfs2_xattr_header, refcount all the entries which
+ * have value stored outside.
+ * Used for xattrs stored in inode and ocfs2_xattr_block.
+ */
+static int ocfs2_xattr_attach_refcount_normal(struct inode *inode,
+				struct ocfs2_xattr_value_buf *vb,
+				struct ocfs2_xattr_header *header,
+				struct ocfs2_extent_tree *ref_et,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+
+	struct ocfs2_xattr_entry *xe;
+	struct ocfs2_xattr_value_root *xv;
+	struct ocfs2_extent_tree et;
+	int i, ret = 0;
+
+	for (i = 0; i < le16_to_cpu(header->xh_count); i++) {
+		xe = &header->xh_entries[i];
+
+		if (ocfs2_xattr_is_local(xe))
+			continue;
+
+		xv = (struct ocfs2_xattr_value_root *)((void *)header +
+			le16_to_cpu(xe->xe_name_offset) +
+			OCFS2_XATTR_SIZE(xe->xe_name_len));
+
+		vb->vb_xv = xv;
+		ocfs2_init_xattr_value_extent_tree(&et, INODE_CACHE(inode), vb);
+
+		ret = ocfs2_xattr_value_attach_refcount(inode, xv,
+							&et, ref_et,
+							dealloc, NULL);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int ocfs2_xattr_inline_attach_refcount(struct inode *inode,
+				struct buffer_head *fe_bh,
+				struct ocfs2_extent_tree *ref_et,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
+	struct ocfs2_xattr_header *header = (struct ocfs2_xattr_header *)
+				(fe_bh->b_data + inode->i_sb->s_blocksize -
+				le16_to_cpu(di->i_xattr_inline_size));
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = fe_bh,
+		.vb_access = ocfs2_journal_access_di,
+	};
+
+	return ocfs2_xattr_attach_refcount_normal(inode, &vb, header,
+						  ref_et, dealloc);
+}
+
+struct ocfs2_xattr_tree_value_refcount_para {
+	struct ocfs2_extent_tree *et;
+	struct ocfs2_cached_dealloc_ctxt *dealloc;
+};
+
+static int ocfs2_get_xattr_tree_value_root(struct super_block *sb,
+					   struct ocfs2_xattr_bucket *bucket,
+					   int offset,
+					   struct ocfs2_xattr_value_root **xv,
+					   struct buffer_head **bh)
+{
+	int ret, block_off, name_offset;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
+	struct ocfs2_xattr_entry *xe = &xh->xh_entries[offset];
+	void *base;
+
+	ret = ocfs2_xattr_bucket_get_name_value(sb,
+						bucket_xh(bucket),
+						offset,
+						&block_off,
+						&name_offset);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	base = bucket_block(bucket, block_off);
+
+	*xv = (struct ocfs2_xattr_value_root *)(base + name_offset +
+			 OCFS2_XATTR_SIZE(xe->xe_name_len));
+
+	if (bh)
+		*bh = bucket->bu_bhs[offset];
+out:
+	return ret;
+}
+
+/*
+ * For a given xattr bucket, refcount all the entries which
+ * have value stored outside.
+ */
+static int ocfs2_xattr_bucket_value_refcount(struct inode *inode,
+					     struct ocfs2_xattr_bucket *bucket,
+					     void *para)
+{
+	int i, ret = 0;
+	struct ocfs2_extent_tree et;
+	struct ocfs2_xattr_tree_value_refcount_para *ref =
+			(struct ocfs2_xattr_tree_value_refcount_para *)para;
+	struct ocfs2_xattr_header *xh =
+			(struct ocfs2_xattr_header *)bucket->bu_bhs[0]->b_data;
+	struct ocfs2_xattr_entry *xe;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_access = ocfs2_journal_access,
+	};
+	struct ocfs2_post_refcount refcount = {
+		.credits = bucket->bu_blocks,
+		.para = bucket,
+		.func = ocfs2_xattr_bucket_post_refcount,
+	};
+	struct ocfs2_post_refcount *p = NULL;
+
+	/* We only need post_refcount if we support metaecc. */
+	if (ocfs2_meta_ecc(OCFS2_SB(inode->i_sb)))
+		p = &refcount;
+
+	mlog(0, "refcount bucket %llu, count = %u\n",
+	     (unsigned long long)bucket_blkno(bucket),
+	     le16_to_cpu(xh->xh_count));
+	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
+		xe = &xh->xh_entries[i];
+
+		if (ocfs2_xattr_is_local(xe))
+			continue;
+
+		ret = ocfs2_get_xattr_tree_value_root(inode->i_sb, bucket, i,
+						      &vb.vb_xv, &vb.vb_bh);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		ocfs2_init_xattr_value_extent_tree(&et,
+						   INODE_CACHE(inode), &vb);
+
+		ret = ocfs2_xattr_value_attach_refcount(inode, vb.vb_xv,
+							&et, ref->et,
+							ref->dealloc, p);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+	}
+
+	return ret;
+
+}
+
+static int ocfs2_refcount_xattr_tree_rec(struct inode *inode,
+				     struct buffer_head *root_bh,
+				     u64 blkno, u32 cpos, u32 len, void *para)
+{
+	return ocfs2_iterate_xattr_buckets(inode, blkno, len,
+					   ocfs2_xattr_bucket_value_refcount,
+					   para);
+}
+
+static int ocfs2_xattr_block_attach_refcount(struct inode *inode,
+				struct buffer_head *blk_bh,
+				struct ocfs2_extent_tree *ref_et,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret = 0;
+	struct ocfs2_xattr_block *xb =
+				(struct ocfs2_xattr_block *)blk_bh->b_data;
+
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		struct ocfs2_xattr_header *header = &xb->xb_attrs.xb_header;
+		struct ocfs2_xattr_value_buf vb = {
+			.vb_bh = blk_bh,
+			.vb_access = ocfs2_journal_access_xb,
+		};
+
+		ret = ocfs2_xattr_attach_refcount_normal(inode, &vb, header,
+							 ref_et, dealloc);
+	} else {
+		struct ocfs2_xattr_tree_value_refcount_para para = {
+							.et = ref_et,
+							.dealloc = dealloc,
+		};
+
+		ret = ocfs2_iterate_xattr_index_block(inode, blk_bh,
+						ocfs2_refcount_xattr_tree_rec,
+						&para);
+	}
+
+	return ret;
+}
+
+int ocfs2_xattr_attach_refcount_tree(struct inode *inode,
+				     struct buffer_head *fe_bh,
+				     struct ocfs2_extent_tree *ref_et,
+				     struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
+	struct buffer_head *blk_bh = NULL;
+
+	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
+		ret = ocfs2_xattr_inline_attach_refcount(inode, fe_bh,
+							 ref_et, dealloc);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	if (!di->i_xattr_loc)
+		goto out;
+
+	ret = ocfs2_read_xattr_block(inode, le64_to_cpu(di->i_xattr_loc),
+				     &blk_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_xattr_block_attach_refcount(inode, blk_bh, ref_et, dealloc);
+	if (ret)
+		mlog_errno(ret);
+
+	brelse(blk_bh);
+out:
+
+	return ret;
+}
+
+/*
  * 'security' attributes support
  */
 static size_t ocfs2_xattr_security_list(struct inode *inode, char *list,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 5a1ebc7..22a7cee 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -83,5 +83,8 @@ struct ocfs2_xattr_value_buf {
 	struct ocfs2_xattr_value_root	*vb_xv;
 };
 
-
+int ocfs2_xattr_attach_refcount_tree(struct inode *inode,
+				     struct buffer_head *fe_bh,
+				     struct ocfs2_extent_tree *ref_et,
+				     struct ocfs2_cached_dealloc_ctxt *dealloc);
 #endif /* OCFS2_XATTR_H */
-- 
1.6.2.rc2.16.gf474c
