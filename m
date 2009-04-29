From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:23 +0800
Subject: [Ocfs2-devel] [PATCH 11/39] ocfs2: Add support of decrementing
	refcount for delete.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-11-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/refcounttree.c |  227 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/refcounttree.h |    4 +
 2 files changed, 229 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index bc4bfb8..58b2c12 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -603,6 +603,10 @@ static void ocfs2_refcount_rec_merge(struct ocfs2_refcount_block *rb,
 		ocfs2_rotate_refcount_rec_left(rb, index);
 }
 
+/*
+ * Change the refcount indexed by "index" in ref_bh.
+ * If refcount reaches 0, remove it.
+ */
 static int ocfs2_change_refcount_rec(handle_t *handle,
 				     struct ocfs2_caching_info *ci,
 				     struct buffer_head *ref_leaf_bh,
@@ -611,7 +615,8 @@ static int ocfs2_change_refcount_rec(handle_t *handle,
 	int ret;
 	struct ocfs2_refcount_block *rb =
 			(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
-	struct ocfs2_refcount_rec *rec = &rb->rf_records.rl_recs[index];
+	struct ocfs2_refcount_list *rl = &rb->rf_records;
+	struct ocfs2_refcount_rec *rec = &rl->rl_recs[index];
 
 	ret = ocfs2_journal_access_rb(handle, ci, ref_leaf_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -624,7 +629,18 @@ static int ocfs2_change_refcount_rec(handle_t *handle,
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
@@ -1288,3 +1304,210 @@ out:
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
+		mlog(0, "reset refcount block root %llu to a leaf block.\n",
+		     (unsigned long long)ref_root_bh->b_blocknr);
+
+		memset(&rb->rf_records, 0, sb->s_blocksize -
+		       offsetof(struct ocfs2_refcount_block, rf_records));
+		rb->rf_flags = cpu_to_le32(OCFS2_REFCOUNT_LEAF_FL);
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
+	if (cpos == le64_to_cpu(rec->r_cpos) && cpos + len ==
+	    le64_to_cpu(rec->r_cpos) + le32_to_cpu(rec->r_clusters))
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
+int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
+			    handle_t *handle, u32 cpos, u32 len,
+			    struct ocfs2_alloc_context *meta_ac,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!di->i_refcount_loc);
+
+	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
+					le64_to_cpu(di->i_refcount_loc),
+					&ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = __ocfs2_decrease_refcount(handle, INODE_CACHE(inode), ref_root_bh,
+					cpos, len, meta_ac, dealloc);
+	if (ret)
+		mlog_errno(ret);
+out:
+	brelse(ref_root_bh);
+	return ret;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 9f4bdac..92fe116 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -23,4 +23,8 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 			    u64 blkno);
 int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
 
+int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
+			    handle_t *handle, u32 cpos, u32 len,
+			    struct ocfs2_alloc_context *meta_ac,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
