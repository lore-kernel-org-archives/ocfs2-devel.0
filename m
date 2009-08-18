From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:17 +0800
Subject: [Ocfs2-devel] [PATCH 16/41] ocfs2: Decrement refcount when
	truncating refcounted extents.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-16-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/alloc.c        |   76 +++++++++++++++--
 fs/ocfs2/journal.h      |    3 +
 fs/ocfs2/refcounttree.c |  212 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    6 ++
 4 files changed, 290 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 96f8ca6..03438a6 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -49,6 +49,7 @@
 #include "super.h"
 #include "uptodate.h"
 #include "xattr.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -6673,7 +6674,7 @@ out:
  */
 static int ocfs2_trim_tree(struct inode *inode, struct ocfs2_path *path,
 			   handle_t *handle, struct ocfs2_truncate_context *tc,
-			   u32 clusters_to_del, u64 *delete_start)
+			   u32 clusters_to_del, u64 *delete_start, u8 *flags)
 {
 	int ret, i, index = path->p_tree_depth;
 	u32 new_edge = 0;
@@ -6683,6 +6684,7 @@ static int ocfs2_trim_tree(struct inode *inode, struct ocfs2_path *path,
 	struct ocfs2_extent_rec *rec;
 
 	*delete_start = 0;
+	*flags = 0;
 
 	while (index >= 0) {
 		bh = path->p_node[index].bh;
@@ -6770,6 +6772,7 @@ find_tail_record:
 			*delete_start = le64_to_cpu(rec->e_blkno)
 				+ ocfs2_clusters_to_blocks(inode->i_sb,
 					le16_to_cpu(rec->e_leaf_clusters));
+			*flags = rec->e_flags;
 
 			/*
 			 * If it's now empty, remove this record.
@@ -6869,7 +6872,8 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 			     struct buffer_head *fe_bh,
 			     handle_t *handle,
 			     struct ocfs2_truncate_context *tc,
-			     struct ocfs2_path *path)
+			     struct ocfs2_path *path,
+			     struct ocfs2_alloc_context *meta_ac)
 {
 	int status;
 	struct ocfs2_dinode *fe;
@@ -6877,6 +6881,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	struct ocfs2_extent_list *el;
 	struct buffer_head *last_eb_bh = NULL;
 	u64 delete_blk = 0;
+	u8 rec_flags;
 
 	fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
@@ -6932,7 +6937,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	inode->i_blocks = ocfs2_inode_sector_count(inode);
 
 	status = ocfs2_trim_tree(inode, path, handle, tc,
-				 clusters_to_del, &delete_blk);
+				 clusters_to_del, &delete_blk, &rec_flags);
 	if (status) {
 		mlog_errno(status);
 		goto bail;
@@ -6964,8 +6969,16 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	}
 
 	if (delete_blk) {
-		status = ocfs2_truncate_log_append(osb, handle, delete_blk,
-						   clusters_to_del);
+		if (rec_flags & OCFS2_EXT_REFCOUNTED)
+			status = ocfs2_decrease_refcount(inode, handle,
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
@@ -7383,11 +7396,14 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 {
 	int status, i, credits, tl_sem = 0;
 	u32 clusters_to_del, new_highest_cpos, range;
+	u64 blkno = 0;
 	struct ocfs2_extent_list *el;
 	handle_t *handle = NULL;
 	struct inode *tl_inode = osb->osb_tl_inode;
 	struct ocfs2_path *path = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	mlog_entry_void();
 
@@ -7413,6 +7429,8 @@ start:
 		goto bail;
 	}
 
+	credits = 0;
+
 	/*
 	 * Truncate always works against the rightmost tree branch.
 	 */
@@ -7453,10 +7471,15 @@ start:
 		clusters_to_del = 0;
 	} else if (le32_to_cpu(el->l_recs[i].e_cpos) >= new_highest_cpos) {
 		clusters_to_del = ocfs2_rec_clusters(el, &el->l_recs[i]);
+		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
 	} else if (range > new_highest_cpos) {
 		clusters_to_del = (ocfs2_rec_clusters(el, &el->l_recs[i]) +
 				   le32_to_cpu(el->l_recs[i].e_cpos)) -
 				  new_highest_cpos;
+		blkno = le64_to_cpu(el->l_recs[i].e_blkno) +
+			ocfs2_clusters_to_blocks(inode->i_sb,
+				ocfs2_rec_clusters(el, &el->l_recs[i]) -
+				clusters_to_del);
 	} else {
 		status = 0;
 		goto bail;
@@ -7465,6 +7488,29 @@ start:
 	mlog(0, "clusters_to_del = %u in this pass, tail blk=%llu\n",
 	     clusters_to_del, (unsigned long long)path_leaf_bh(path)->b_blocknr);
 
+	if (el->l_recs[i].e_flags & OCFS2_EXT_REFCOUNTED && clusters_to_del) {
+		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
+			 OCFS2_HAS_REFCOUNT_FL));
+
+		status = ocfs2_lock_refcount_tree(osb,
+						le64_to_cpu(di->i_refcount_loc),
+						1, &ref_tree, NULL);
+		if (status) {
+			mlog_errno(status);
+			goto bail;
+		}
+
+		status = ocfs2_prepare_refcount_change_for_del(inode, fe_bh,
+							       blkno,
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
@@ -7478,7 +7524,7 @@ start:
 		}
 	}
 
-	credits = ocfs2_calc_tree_trunc_credits(osb->sb, clusters_to_del,
+	credits += ocfs2_calc_tree_trunc_credits(osb->sb, clusters_to_del,
 						(struct ocfs2_dinode *)fe_bh->b_data,
 						el);
 	handle = ocfs2_start_trans(osb, credits);
@@ -7490,7 +7536,7 @@ start:
 	}
 
 	status = ocfs2_do_truncate(osb, clusters_to_del, inode, fe_bh, handle,
-				   tc, path);
+				   tc, path, meta_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -7504,6 +7550,16 @@ start:
 
 	ocfs2_reinit_path(path, 1);
 
+	if (meta_ac) {
+		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
+
+	if (ref_tree) {
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+		ref_tree = NULL;
+	}
+
 	/*
 	 * The check above will catch the case where we've truncated
 	 * away all allocation.
@@ -7520,6 +7576,12 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+
 	ocfs2_run_deallocs(osb, &tc->tc_dealloc);
 
 	ocfs2_free_path(path);
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index bd88c8b..3f74e09 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -504,6 +504,9 @@ static inline int ocfs2_calc_dxi_expand_credits(struct super_block *sb)
  */
 #define OCFS2_REFCOUNT_TREE_REMOVE_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 1)
 
+/* 2 metadata alloc, 2 new blocks and root refcount block */
+#define OCFS2_EXPAND_REFCOUNT_TREE_CREDITS (OCFS2_SUBALLOC_ALLOC * 2 + 3)
+
 /*
  * Please note that the caller must make sure that root_el is the root
  * of extent tree. So for an inode, it should be &fe->id2.i_list. Otherwise
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index bdc86c9..6dee650 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2190,3 +2190,215 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
 out:
 	return ret;
 }
+
+/*
+ * Given some contiguous physical clusters, calculate what we need
+ * for modifying their refcount.
+ */
+static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
+					    struct ocfs2_caching_info *ci,
+					    struct buffer_head *ref_root_bh,
+					    u64 start_cpos,
+					    u32 clusters,
+					    int *meta_add,
+					    int *credits)
+{
+	int ret = 0, index, ref_blocks = 0, recs_add = 0;
+	u64 cpos = start_cpos;
+	struct ocfs2_refcount_block *rb;
+	struct ocfs2_refcount_rec rec;
+	struct buffer_head *ref_leaf_bh = NULL, *prev_bh = NULL;
+	u32 len;
+
+	mlog(0, "start_cpos %llu, clusters %u\n",
+	     (unsigned long long)start_cpos, clusters);
+	while (clusters) {
+		ret = ocfs2_get_refcount_rec(ci, ref_root_bh,
+					     cpos, clusters, &rec,
+					     &index, &ref_leaf_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (ref_leaf_bh != prev_bh) {
+			/*
+			 * Now we encounter a new leaf block, so calculate
+			 * whether we need to extend the old leaf.
+			 */
+			if (prev_bh) {
+				rb = (struct ocfs2_refcount_block *)
+							prev_bh->b_data;
+
+				if (le64_to_cpu(rb->rf_records.rl_used) +
+				    recs_add >
+				    le16_to_cpu(rb->rf_records.rl_count))
+					ref_blocks++;
+			}
+
+			recs_add = 0;
+			*credits += 1;
+			brelse(prev_bh);
+			prev_bh = ref_leaf_bh;
+			get_bh(prev_bh);
+		}
+
+		rb = (struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+
+		mlog(0, "recs_add %d,cpos %llu, clusters %u, rec->r_cpos %llu,"
+		     "rec->r_clusters %u, rec->r_refcount %u, index %d\n",
+		     recs_add, (unsigned long long)cpos, clusters,
+		     (unsigned long long)le64_to_cpu(rec.r_cpos),
+		     le32_to_cpu(rec.r_clusters),
+		     le32_to_cpu(rec.r_refcount), index);
+
+		len = min((u64)cpos + clusters, le64_to_cpu(rec.r_cpos) +
+			  le32_to_cpu(rec.r_clusters)) - cpos;
+		/*
+		 * If the refcount rec already exist, cool. We just need
+		 * to check whether there is a split. Otherwise we just need
+		 * to increase the refcount.
+		 * If we will insert one, increases recs_add.
+		 *
+		 * We record all the records which will be inserted to the
+		 * same refcount block, so that we can tell exactly whether
+		 * we need a new refcount block or not.
+		 */
+		if (rec.r_refcount) {
+			/* Check whether we need a split at the beginning. */
+			if (cpos == start_cpos &&
+			    cpos != le64_to_cpu(rec.r_cpos))
+				recs_add++;
+
+			/* Check whether we need a split in the end. */
+			if (cpos + clusters < le64_to_cpu(rec.r_cpos) +
+			    le32_to_cpu(rec.r_clusters))
+				recs_add++;
+		} else
+			recs_add++;
+
+		brelse(ref_leaf_bh);
+		ref_leaf_bh = NULL;
+		clusters -= len;
+		cpos += len;
+	}
+
+	if (prev_bh) {
+		rb = (struct ocfs2_refcount_block *)prev_bh->b_data;
+
+		if (le64_to_cpu(rb->rf_records.rl_used) + recs_add >
+		    le16_to_cpu(rb->rf_records.rl_count))
+			ref_blocks++;
+
+		*credits += 1;
+	}
+
+	if (!ref_blocks)
+		goto out;
+
+	mlog(0, "we need ref_blocks %d\n", ref_blocks);
+	*meta_add += ref_blocks;
+	*credits += ref_blocks;
+
+	/*
+	 * So we may need ref_blocks to insert into the tree.
+	 * That also means we need to change the b-tree and add that number
+	 * of records since we never merge them.
+	 * We need one more block for expansion since the new created leaf
+	 * block is also full and needs split.
+	 */
+	rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
+	if (le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL) {
+		struct ocfs2_extent_tree et;
+
+		ocfs2_init_refcount_extent_tree(&et, ci, ref_root_bh);
+		*meta_add += ocfs2_extend_meta_needed(et.et_root_el);
+		*credits += ocfs2_calc_extend_credits(sb,
+						      et.et_root_el,
+						      ref_blocks);
+	} else {
+		*credits += OCFS2_EXPAND_REFCOUNT_TREE_CREDITS;
+		*meta_add += 1;
+	}
+
+out:
+	brelse(ref_leaf_bh);
+	brelse(prev_bh);
+	return ret;
+}
+
+/*
+ * For refcount tree, we will decrease some contiguous clusters
+ * refcount count, so just go through it to see how many blocks
+ * we gonna touch and whether we need to create new blocks.
+ *
+ * Normally the refcount blocks store these refcount should be
+ * continguous also, so that we can get the number easily.
+ * As for meta_ac, we will at most add split 2 refcount record and
+ * 2 more refcount block, so just check it in a rough way.
+ *
+ * Caller must hold refcount tree lock.
+ */
+int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
+					  struct buffer_head *di_bh,
+					  u64 phys_blkno,
+					  u32 clusters,
+					  int *credits,
+					  struct ocfs2_alloc_context **meta_ac)
+{
+	int ret, ref_blocks = 0;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_refcount_tree *tree;
+	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
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
+
+	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb),
+				      le64_to_cpu(di->i_refcount_loc), &tree);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_refcount_block(&tree->rf_ci,
+					le64_to_cpu(di->i_refcount_loc),
+					&ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_calc_refcount_meta_credits(inode->i_sb,
+					       &tree->rf_ci,
+					       ref_root_bh,
+					       start_cpos, clusters,
+					       &ref_blocks, credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "reserve new metadata %d, credits = %d\n",
+	     ref_blocks, *credits);
+
+	if (ref_blocks) {
+		ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
+							ref_blocks, meta_ac);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+out:
+	brelse(ref_root_bh);
+	return ret;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 60ea02e..bd2b1ee 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -45,4 +45,10 @@ int ocfs2_decrease_refcount(struct inode *inode,
 			    handle_t *handle, u32 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
 			    struct ocfs2_cached_dealloc_ctxt *dealloc);
+int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
+					  struct buffer_head *di_bh,
+					  u64 phys_blkno,
+					  u32 clusters,
+					  int *credits,
+					  struct ocfs2_alloc_context **meta_ac);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
