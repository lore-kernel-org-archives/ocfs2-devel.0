From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:15 +0800
Subject: [Ocfs2-devel] [PATCH 14/41] ocfs2: Add support of decrementing
	refcount for delete.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-14-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

    Given a physical cpos and length, decrement the refcount
in the tree. If the refcount for any portion of the extent goes
to zero, that portion is queued for freeing.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |    6 +-
 fs/ocfs2/alloc.h        |    3 +
 fs/ocfs2/refcounttree.c |  256 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/refcounttree.h |    5 +
 4 files changed, 265 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 2c8ce32..9dd68cd 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6522,9 +6522,9 @@ ocfs2_find_per_slot_free_list(int type,
 	return fl;
 }
 
-static int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
-				     int type, int slot, u64 blkno,
-				     unsigned int bit)
+int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
+			      int type, int slot, u64 blkno,
+			      unsigned int bit)
 {
 	int ret;
 	struct ocfs2_per_slot_free_list *fl;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 3f43489..0610ba1 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -202,6 +202,9 @@ static inline void ocfs2_init_dealloc_ctxt(struct ocfs2_cached_dealloc_ctxt *c)
 }
 int ocfs2_cache_cluster_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
 				u64 blkno, unsigned int bit);
+int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
+			      int type, int slot, u64 blkno,
+			      unsigned int bit);
 static inline int ocfs2_dealloc_has_cluster(struct ocfs2_cached_dealloc_ctxt *c)
 {
 	return c->c_global_allocator != NULL;
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 4c3f5e9..1c6d425 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1069,6 +1069,10 @@ static void ocfs2_refcount_rec_merge(struct ocfs2_refcount_block *rb,
 		ocfs2_rotate_refcount_rec_left(rb, index);
 }
 
+/*
+ * Change the refcount indexed by "index" in ref_bh.
+ * If refcount reaches 0, remove it.
+ */
 static int ocfs2_change_refcount_rec(handle_t *handle,
 				     struct ocfs2_caching_info *ci,
 				     struct buffer_head *ref_leaf_bh,
@@ -1077,7 +1081,8 @@ static int ocfs2_change_refcount_rec(handle_t *handle,
 	int ret;
 	struct ocfs2_refcount_block *rb =
 			(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
-	struct ocfs2_refcount_rec *rec = &rb->rf_records.rl_recs[index];
+	struct ocfs2_refcount_list *rl = &rb->rf_records;
+	struct ocfs2_refcount_rec *rec = &rl->rl_recs[index];
 
 	ret = ocfs2_journal_access_rb(handle, ci, ref_leaf_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1090,7 +1095,18 @@ static int ocfs2_change_refcount_rec(handle_t *handle,
 	     le32_to_cpu(rec->r_refcount), change);
 	le32_add_cpu(&rec->r_refcount, change);
 
-	ocfs2_refcount_rec_merge(rb, index);
+	if (!rec->r_refcount) {
+		if (index != le16_to_cpu(rl->rl_used) - 1) {
+			memmove(rec, rec + 1,
+				(le16_to_cpu(rl->rl_used) - index - 1) *
+				sizeof(struct ocfs2_refcount_rec));
+			memset(&rl->rl_recs[le16_to_cpu(rl->rl_used) - 1],
+			       0, sizeof(struct ocfs2_refcount_rec));
+		}
+
+		le16_add_cpu(&rl->rl_used, -1);
+	} else
+		ocfs2_refcount_rec_merge(rb, index);
 
 	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
 	if (ret)
@@ -1899,3 +1915,239 @@ out:
 	brelse(ref_leaf_bh);
 	return ret;
 }
+
+static int ocfs2_remove_refcount_extent(handle_t *handle,
+				struct ocfs2_caching_info *ci,
+				struct buffer_head *ref_root_bh,
+				struct buffer_head *ref_leaf_bh,
+				struct ocfs2_alloc_context *meta_ac,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	struct ocfs2_refcount_block *rb =
+			(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+	struct ocfs2_extent_tree et;
+
+	BUG_ON(rb->rf_records.rl_used);
+
+	ocfs2_init_refcount_extent_tree(&et, ci, ref_root_bh);
+	ret = ocfs2_remove_extent(handle, &et, le32_to_cpu(rb->rf_cpos),
+				  1, meta_ac, dealloc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_remove_from_cache(ci, ref_leaf_bh);
+
+	/*
+	 * add the freed block to the dealloc so that it will be freed
+	 * when we run dealloc.
+	 */
+	ret = ocfs2_cache_block_dealloc(dealloc, EXTENT_ALLOC_SYSTEM_INODE,
+					le16_to_cpu(rb->rf_suballoc_slot),
+					le64_to_cpu(rb->rf_blkno),
+					le16_to_cpu(rb->rf_suballoc_bit));
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_rb(handle, ci, ref_root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
+
+	le32_add_cpu(&rb->rf_clusters, -1);
+
+	/*
+	 * check whether we need to restore the root refcount block if
+	 * there is no leaf extent block at atll.
+	 */
+	if (!rb->rf_list.l_next_free_rec) {
+		BUG_ON(rb->rf_clusters);
+
+		mlog(0, "reset refcount tree root %llu to be a record block.\n",
+		     (unsigned long long)ref_root_bh->b_blocknr);
+
+		rb->rf_flags = 0;
+		rb->rf_parent = 0;
+		rb->rf_cpos = 0;
+		memset(&rb->rf_records, 0, sb->s_blocksize -
+		       offsetof(struct ocfs2_refcount_block, rf_records));
+		rb->rf_records.rl_count =
+				cpu_to_le16(ocfs2_refcount_recs_per_rb(sb));
+	}
+
+	ocfs2_journal_dirty(handle, ref_root_bh);
+
+out:
+	return ret;
+}
+
+static int ocfs2_decrease_refcount_rec(handle_t *handle,
+				struct ocfs2_caching_info *ci,
+				struct buffer_head *ref_root_bh,
+				struct buffer_head *ref_leaf_bh,
+				int index, u64 cpos, unsigned int len,
+				struct ocfs2_alloc_context *meta_ac,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	struct ocfs2_refcount_block *rb =
+			(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+	struct ocfs2_refcount_rec *rec = &rb->rf_records.rl_recs[index];
+
+	BUG_ON(cpos < le64_to_cpu(rec->r_cpos));
+	BUG_ON(cpos + len >
+	       le64_to_cpu(rec->r_cpos) + le32_to_cpu(rec->r_clusters));
+
+	if (cpos == le64_to_cpu(rec->r_cpos) &&
+	    len == le32_to_cpu(rec->r_clusters))
+		ret = ocfs2_change_refcount_rec(handle, ci,
+						ref_leaf_bh, index, -1);
+	else {
+		struct ocfs2_refcount_rec split = *rec;
+		split.r_cpos = cpu_to_le64(cpos);
+		split.r_clusters = cpu_to_le32(len);
+
+		le32_add_cpu(&split.r_refcount, -1);
+
+		mlog(0, "split refcount rec, start %llu, "
+		     "len %u, count %u, original start %llu, len %u\n",
+		     (unsigned long long)le64_to_cpu(split.r_cpos),
+		     len, le32_to_cpu(split.r_refcount),
+		     (unsigned long long)le64_to_cpu(rec->r_cpos),
+		     le32_to_cpu(rec->r_clusters));
+		ret = ocfs2_split_refcount_rec(handle, ci,
+					       ref_root_bh, ref_leaf_bh,
+					       &split, index,
+					       meta_ac, dealloc);
+	}
+
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/* Remove the leaf refcount block if it contains no refcount record. */
+	if (!rb->rf_records.rl_used && ref_leaf_bh != ref_root_bh) {
+		ret = ocfs2_remove_refcount_extent(handle, ci, ref_root_bh,
+						   ref_leaf_bh, meta_ac,
+						   dealloc);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+out:
+	return ret;
+}
+
+static int __ocfs2_decrease_refcount(handle_t *handle,
+				     struct ocfs2_caching_info *ci,
+				     struct buffer_head *ref_root_bh,
+				     u64 cpos, u32 len,
+				     struct ocfs2_alloc_context *meta_ac,
+				     struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret = 0, index = 0;
+	struct ocfs2_refcount_rec rec;
+	unsigned int r_count = 0, r_len;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	struct buffer_head *ref_leaf_bh = NULL;
+
+	mlog(0, "Tree owner %llu, decrease refcount start %llu, len %u\n",
+	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
+	     (unsigned long long)cpos, len);
+
+	while (len) {
+		ret = ocfs2_get_refcount_rec(ci, ref_root_bh,
+					     cpos, len, &rec, &index,
+					     &ref_leaf_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		r_count = le32_to_cpu(rec.r_refcount);
+		BUG_ON(r_count == 0);
+
+		r_len = min((u64)(cpos + len), le64_to_cpu(rec.r_cpos) +
+			      le32_to_cpu(rec.r_clusters)) - cpos;
+
+		ret = ocfs2_decrease_refcount_rec(handle, ci, ref_root_bh,
+						  ref_leaf_bh, index,
+						  cpos, r_len,
+						  meta_ac, dealloc);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (le32_to_cpu(rec.r_refcount) == 1) {
+			ret = ocfs2_cache_cluster_dealloc(dealloc,
+					  ocfs2_clusters_to_blocks(sb, cpos),
+							  r_len);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		}
+
+		cpos += r_len;
+		len -= r_len;
+		brelse(ref_leaf_bh);
+		ref_leaf_bh = NULL;
+	}
+
+out:
+	brelse(ref_leaf_bh);
+	return ret;
+}
+
+/* Caller must hold refcount tree lock. */
+int ocfs2_decrease_refcount(struct inode *inode,
+			    handle_t *handle, u32 cpos, u32 len,
+			    struct ocfs2_alloc_context *meta_ac,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	u64 ref_blkno;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_refcount_tree *tree;
+
+	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+
+	ret = ocfs2_get_refcount_block(inode, &ref_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb), ref_blkno, &tree);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_refcount_block(&tree->rf_ci, tree->rf_blkno,
+					&ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = __ocfs2_decrease_refcount(handle, &tree->rf_ci, ref_root_bh,
+					cpos, len, meta_ac, dealloc);
+	if (ret)
+		mlog_errno(ret);
+out:
+	brelse(ref_root_bh);
+	return ret;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 3c38bbd..60ea02e 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -40,4 +40,9 @@ int ocfs2_lock_refcount_tree(struct ocfs2_super *osb, u64 ref_blkno, int rw,
 void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
 				struct ocfs2_refcount_tree *tree,
 				int rw);
+
+int ocfs2_decrease_refcount(struct inode *inode,
+			    handle_t *handle, u32 cpos, u32 len,
+			    struct ocfs2_alloc_context *meta_ac,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
