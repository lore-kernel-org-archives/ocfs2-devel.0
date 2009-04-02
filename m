From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:56 +0800
Subject: [Ocfs2-devel] [PATCH 17/42] ocfs2: Add CoW support.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-17-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When replacing the old refcounted extent record, I don't
remove the old extent record first and then insert the new one.
Because during the tree manipulation(e.g, ocfs2_remove_extent),
we often need to call ocfs2_extend_trans which may restart our
transcation. So if we crash right after the removing and before
the inserting, we will lost the data.
So the whole process will be:
1. If we are replacing the whole extent record, just copy the data
   and replace e_blkno.
2. If we are split the extent record, just initialized the data
   and then call ocfs2_split_extent directly, the tree code is
   modified so that it can handle it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |  189 +++++++++++++-
 fs/ocfs2/alloc.h        |   10 +
 fs/ocfs2/aops.c         |   49 ++++-
 fs/ocfs2/refcounttree.c |  662 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    2 +
 5 files changed, 900 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 69a6356..19f80ef 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -582,6 +582,170 @@ static inline int ocfs2_et_sanity_check(struct ocfs2_extent_tree *et)
 	return ret;
 }
 
+static int ocfs2_leaf_eb_num(struct super_block *sb,
+			     struct ocfs2_extent_tree *et, int *num_ebs)
+{
+	int i, ret = 0;
+	int ebs = 0, recs_per_eb = ocfs2_extent_recs_per_eb(sb);
+	struct ocfs2_path *path;
+
+	*num_ebs = 0;
+
+	if (!et->et_root_el->l_tree_depth)
+		return 0;
+
+	path = ocfs2_new_path_from_et(et);
+	if (!path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = ocfs2_find_path(et->et_ci, path, UINT_MAX);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	for (i = 0; i < path->p_tree_depth; i++)
+		ebs = ebs * recs_per_eb +
+		      le16_to_cpu(path->p_node[i].el->l_next_free_rec);
+
+	*num_ebs = ebs;
+out:
+	ocfs2_free_path(path);
+	return ret;
+}
+
+/*
+ * Calculate how much credits we need for adding meta_add blocks.
+ * It is only used when we want to allocate a lot of metas at one time.
+ */
+int ocfs2_calc_create_meta_credits(struct super_block *sb,
+				   int meta_add)
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
+ * Calculate if we add num_recs to ocfs2_extent_tree how much meta and credits
+ * we need at most. Useful when we will add a lot of recs in the tree.
+ */
+int ocfs2_calc_tree_change_need(struct super_block *sb,
+				struct ocfs2_extent_tree *et, int num_recs,
+				int *meta_add, int *credits)
+{
+	int ret = 0, i, tree_depth;
+	int num_ebs, leaf_eb_need, max_leaf_eb, max_empty_eb;
+	int num_free_extents = ocfs2_num_free_extents(OCFS2_SB(sb), et);
+	int recs_per_eb = ocfs2_extent_recs_per_eb(sb);
+
+	if (num_free_extents < 0) {
+		ret = num_free_extents;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	*credits += ocfs2_calc_extend_credits(sb,
+					      et->et_root_el,
+					      num_recs);
+
+	if (num_free_extents >= num_recs)
+		return ret;
+
+	/* We have to change the tree(branch_add or tree_shift). */
+	leaf_eb_need = num_recs / recs_per_eb + 1;
+
+	ret = ocfs2_leaf_eb_num(sb, et, &num_ebs);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	tree_depth = le16_to_cpu(et->et_root_el->l_tree_depth);
+	max_leaf_eb = le16_to_cpu(et->et_root_el->l_count);
+
+	/*
+	 * tree_depth = 0 is a special case, we have to copy all the extent
+	 * record from root to the 1st extent block and the num of the new
+	 * added leaf extent block is limit to l_count, not recs_per_eb.
+	 */
+	if (!tree_depth) {
+		max_empty_eb = max_leaf_eb - 1;
+		goto shift_tree;
+	}
+
+	for (i = 0; i < tree_depth - 1; i++)
+		max_leaf_eb *= recs_per_eb;
+
+	/*
+	 * The empty leaf eb we could have with branch add.
+	 */
+	max_empty_eb = max_leaf_eb - num_ebs;
+
+	if (leaf_eb_need <= max_empty_eb) {
+		/* We could have enough meta by just adding branch. */
+		*meta_add += tree_depth * leaf_eb_need;
+		goto out;
+	}
+
+	/*
+	 * We have to shift the tree now.
+	 * calculate the empty eb we could have after one tree shift.
+	 */
+	max_leaf_eb = max_leaf_eb * recs_per_eb;
+	max_empty_eb = max_leaf_eb - num_ebs;
+
+shift_tree:
+	if (max_leaf_eb <= max_empty_eb) {
+		/* OK, just one tree shift can have enough space for us. */
+		*meta_add += (tree_depth + 1) * leaf_eb_need;
+		goto out;
+	}
+
+	/* sorry, we have to shift the tree twice. */
+	max_leaf_eb = max_leaf_eb * recs_per_eb;
+	max_empty_eb = max_leaf_eb - num_ebs;
+
+	/*
+	 * Even with a tree shift twice, we can't handle this.
+	 * We'd better BUG_OUT here since the meta allocators
+	 * may not handle this also.
+	 */
+	mlog_bug_on_msg(max_leaf_eb > max_empty_eb, "extent tree %llu wants to "
+		"add %d new extent recs, depth %u, count %u, next free %u\n",
+		(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+		num_recs, le16_to_cpu(et->et_root_el->l_tree_depth),
+		le16_to_cpu(et->et_root_el->l_count),
+		le16_to_cpu(et->et_root_el->l_next_free_rec));
+
+	*meta_add += (tree_depth + 2) * leaf_eb_need;
+
+out:
+	if (!ret)
+		*credits += ocfs2_calc_create_meta_credits(sb, *meta_add);
+
+	return ret;
+}
+
 static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc);
 static int ocfs2_cache_extent_block_free(struct ocfs2_cached_dealloc_ctxt *ctxt,
 					 struct ocfs2_extent_block *eb);
@@ -6916,9 +7080,9 @@ static int ocfs2_zero_func(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
-static void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
-				     unsigned int from, unsigned int to,
-				     struct page *page, int zero, u64 *phys)
+void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
+			      unsigned int from, unsigned int to,
+			      struct page *page, int zero, u64 *phys)
 {
 	int ret, partial = 0;
 
@@ -6986,20 +7150,16 @@ out:
 		ocfs2_unlock_and_free_pages(pages, numpages);
 }
 
-static int ocfs2_grab_eof_pages(struct inode *inode, loff_t start, loff_t end,
-				struct page **pages, int *num)
+int ocfs2_grab_pages(struct inode *inode, loff_t start, loff_t end,
+		     struct page **pages, int *num)
 {
 	int numpages, ret = 0;
-	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	unsigned long index;
 	loff_t last_page_bytes;
 
 	BUG_ON(start > end);
 
-	BUG_ON(start >> OCFS2_SB(sb)->s_clustersize_bits !=
-	       (end - 1) >> OCFS2_SB(sb)->s_clustersize_bits);
-
 	numpages = 0;
 	last_page_bytes = PAGE_ALIGN(end);
 	index = start >> PAGE_CACHE_SHIFT;
@@ -7027,6 +7187,17 @@ out:
 	return ret;
 }
 
+static int ocfs2_grab_eof_pages(struct inode *inode, loff_t start, loff_t end,
+				struct page **pages, int *num)
+{
+	struct super_block *sb = inode->i_sb;
+
+	BUG_ON(start >> OCFS2_SB(sb)->s_clustersize_bits !=
+	       (end - 1) >> OCFS2_SB(sb)->s_clustersize_bits);
+
+	return ocfs2_grab_pages(inode, start, end, pages, num);
+}
+
 /*
  * Zero the area past i_size but still within an allocated
  * cluster. This avoids exposing nonzero data on subsequent file
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 6ea9ecf..0fb954a 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -269,6 +269,11 @@ static inline int ocfs2_is_empty_extent(struct ocfs2_extent_rec *rec)
 	return !rec->e_leaf_clusters;
 }
 
+int ocfs2_grab_pages(struct inode *inode, loff_t start, loff_t end,
+		     struct page **pages, int *num);
+void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
+			      unsigned int from, unsigned int to,
+			      struct page *page, int zero, u64 *phys);
 /*
  * Structures which describe a path through a btree, and functions to
  * manipulate them.
@@ -310,4 +315,9 @@ int ocfs2_path_bh_journal_access(handle_t *handle,
 int ocfs2_journal_access_path(struct ocfs2_caching_info *ci,
 			      handle_t *handle,
 			      struct ocfs2_path *path);
+int ocfs2_calc_create_meta_credits(struct super_block *sb,
+				   int meta_add);
+int ocfs2_calc_tree_change_need(struct super_block *sb,
+				struct ocfs2_extent_tree *et, int num_recs,
+				int *meta_add, int *credits);
 #endif /* OCFS2_ALLOC_H */
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 2e71729..3ad77f3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -44,6 +44,7 @@
 #include "suballoc.h"
 #include "super.h"
 #include "symlink.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -1410,18 +1411,29 @@ static void ocfs2_set_target_boundaries(struct ocfs2_super *osb,
 	}
 }
 
+static inline void ocfs2_clear_write_desc(struct ocfs2_write_ctxt *wc)
+{
+	memset(&wc->w_desc, 0,
+	       sizeof(struct ocfs2_write_cluster_desc) * wc->w_clen);
+}
 /*
  * Populate each single-cluster write descriptor in the write context
  * with information about the i/o to be done.
+ * If we encountered a refcounted cluster, break the process and return
+ * the refcounted start cpos.
  *
  * Returns the number of clusters that will have to be allocated, as
  * well as a worst case estimate of the number of extent records that
  * would have to be created during a write to an unwritten region.
+ *
+ * If we find a refcounted record, return directly with refcounted_cpos
+ * set as the position.
  */
 static int ocfs2_populate_write_desc(struct inode *inode,
 				     struct ocfs2_write_ctxt *wc,
 				     unsigned int *clusters_to_alloc,
-				     unsigned int *extents_to_split)
+				     unsigned int *extents_to_split,
+				     unsigned int *refcounted_cpos)
 {
 	int ret;
 	struct ocfs2_write_cluster_desc *desc;
@@ -1432,6 +1444,7 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 
 	*clusters_to_alloc = 0;
 	*extents_to_split = 0;
+	*refcounted_cpos = UINT_MAX;
 
 	for (i = 0; i < wc->w_clen; i++) {
 		desc = &wc->w_desc[i];
@@ -1448,6 +1461,11 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 				goto out;
 			}
 
+			if (ext_flags & OCFS2_EXT_REFCOUNTED) {
+				*refcounted_cpos = desc->c_cpos;
+				ret = -ETXTBSY;
+				goto out;
+			}
 			/*
 			 * Assume worst case - that we're writing in
 			 * the middle of the extent.
@@ -1652,6 +1670,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle;
 	struct ocfs2_extent_tree et;
+	unsigned int refcounted_cpos, write_len;
 
 	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, di_bh);
 	if (ret) {
@@ -1679,12 +1698,36 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	}
 
 	ret = ocfs2_populate_write_desc(inode, wc, &clusters_to_alloc,
-					&extents_to_split);
-	if (ret) {
+					&extents_to_split, &refcounted_cpos);
+	if (ret && ret != -ETXTBSY) {
 		mlog_errno(ret);
 		goto out;
 	}
 
+	if (ret == -ETXTBSY) {
+		BUG_ON(refcounted_cpos == UINT_MAX);
+		write_len = wc->w_clen - (refcounted_cpos - wc->w_cpos);
+
+		ret = ocfs2_refcount_cow(inode, di_bh,
+					 refcounted_cpos, write_len);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/* reinitialize write_desc and populate it again. */
+		ocfs2_clear_write_desc(wc);
+		ret = ocfs2_populate_write_desc(inode, wc, &clusters_to_alloc,
+						&extents_to_split,
+						&refcounted_cpos);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		BUG_ON(refcounted_cpos != UINT_MAX);
+	}
+
 	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 
 	/*
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index f32899d..22ec27d 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -30,6 +30,21 @@
 #include "sysfile.h"
 #include "dlmglue.h"
 #include "extent_map.h"
+#include "aops.h"
+
+struct ocfs2_cow_context {
+	struct inode *inode;
+	struct ocfs2_extent_tree di_et;
+	struct ocfs2_extent_tree ref_et;
+	struct ocfs2_alloc_context *meta_ac;
+	struct ocfs2_alloc_context *data_ac;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct buffer_head **bhs;
+	struct page **cow_pages;
+	int num_pages;
+	u32 cow_start;
+	u32 cow_len;
+};
 
 static int ocfs2_validate_refcount_block(struct super_block *sb,
 					 struct buffer_head *bh)
@@ -770,3 +785,650 @@ out:
 	brelse(ref_bh);
 	return ret;
 }
+
+#define	MAX_COW_BYTES	1048576
+/*
+ * Calculate out the start and number of virtual clusters we need to to CoW.
+ *
+ * cpos is vitual start cluster position we want to do CoW in a
+ * file and write_len is the cluster length.
+ *
+ * Normal we will start CoW from the beginning of extent record cotaining cpos.
+ * And We will try to Cow as much clusters as we can until we reach
+ * MAX_COW_BYTES. If the write_len is larger than MAX_COW_BYTES, we will
+ * use that value as the maximum clusters.
+ */
+static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
+					   struct buffer_head *di_bh,
+					   u32 cpos,
+					   u32 write_len,
+					   u32 *cow_start,
+					   u32 *cow_len,
+					   int *num_recs,
+					   int *has_data)
+{
+	int ret = 0;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
+	struct ocfs2_extent_list *el = &di->id2.i_list;
+	int tree_height = le16_to_cpu(el->l_tree_depth), i;
+	struct buffer_head *eb_bh = NULL;
+	struct ocfs2_extent_block *eb = NULL;
+	struct ocfs2_extent_rec *rec;
+	int max_clusters = ocfs2_clusters_for_bytes(inode->i_sb, MAX_COW_BYTES);
+	int leaf_clusters, rec_end = 0;
+
+	max_clusters = max_clusters < write_len ? write_len : max_clusters;
+	if (tree_height > 0) {
+		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, cpos, &eb_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
+		el = &eb->h_list;
+
+		if (el->l_tree_depth) {
+			ocfs2_error(inode->i_sb,
+				    "Inode %lu has non zero tree depth in "
+				    "leaf block %llu\n", inode->i_ino,
+				    (unsigned long long)eb_bh->b_blocknr);
+			ret = -EROFS;
+			goto out;
+		}
+	}
+
+	*cow_len = 0;
+	*num_recs = 0;
+	*has_data = 0;
+	for (i = 0; i < le16_to_cpu(el->l_next_free_rec);) {
+		rec = &el->l_recs[i];
+		i++;
+
+		if (ocfs2_is_empty_extent(rec)) {
+			mlog_bug_on_msg(i != 0, "Inode %lu has empty record in "
+					"index %d\n", inode->i_ino, i);
+
+			continue;
+		}
+
+		if (le32_to_cpu(rec->e_cpos) +
+		    le16_to_cpu(rec->e_leaf_clusters) <= cpos)
+			continue;
+
+		if (*cow_len == 0) {
+			BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED));
+			*cow_start = le32_to_cpu(rec->e_cpos);
+			rec_end = le32_to_cpu(rec->e_cpos);
+		}
+
+		if (!*has_data && !(rec->e_flags & OCFS2_EXT_UNWRITTEN))
+			*has_data = 1;
+
+		/*
+		 * If we encounter a hole or a non-refcounted record,
+		 * stop the search.
+		 */
+		if ((!(rec->e_flags & OCFS2_EXT_REFCOUNTED)) ||
+		    rec_end != le32_to_cpu(rec->e_cpos))
+			break;
+
+		*num_recs += 1;
+		leaf_clusters = le16_to_cpu(rec->e_leaf_clusters);
+		rec_end = le32_to_cpu(rec->e_cpos) + leaf_clusters;
+
+		if (*cow_len + leaf_clusters >= max_clusters) {
+			if (*cow_len == 0) {
+				/*
+				 * cpos is in a very large extent record.
+				 * So just split max_clusters from the
+				 * extent record.
+				 */
+				leaf_clusters = rec_end - cpos;
+
+				if (leaf_clusters > max_clusters)
+					*cow_start = cpos;
+				else
+					*cow_start = rec_end - max_clusters;
+			}
+			*cow_len = max_clusters;
+			break;
+		} else
+			*cow_len += leaf_clusters;
+
+		/*
+		 * If we reach the end of the extent block and don't get enough
+		 * clusters, continue with the next extent block if possible.
+		 */
+		if (i == le16_to_cpu(el->l_next_free_rec) &&
+		    eb && eb->h_next_leaf_blk) {
+			brelse(eb_bh);
+			eb_bh = NULL;
+
+			ret = ocfs2_read_extent_block(INODE_CACHE(inode),
+					       le64_to_cpu(eb->h_next_leaf_blk),
+					       &eb_bh);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			eb = (struct ocfs2_extent_block *) eb_bh->b_data;
+			el = &eb->h_list;
+			i = 0;
+		}
+	}
+
+out:
+	brelse(eb_bh);
+	return ret;
+}
+
+/*
+ * Prepare the data_ac and meta_ac for all the tree modification,
+ * including both di_tree and refcount_tree.
+ *
+ * cow_len is the cluster length we will do cow.
+ * since we may split the old tree, so we at most will need cow_len + 2
+ * extent recs.
+ */
+static int ocfs2_lock_refcount_cow_allocator(struct super_block *sb,
+					     u32 cow_len,
+					     struct ocfs2_cow_context *context,
+					     int *credits)
+{
+	int ret = 0, meta_add = 0;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+
+	*credits = 0;
+
+	ret = ocfs2_calc_tree_change_need(sb, &context->di_et, cow_len + 2,
+					  &meta_add, credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_calc_tree_change_need(sb, &context->ref_et, cow_len + 2,
+					  &meta_add, credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "reserve new metadata %d, clusters %u, credits = %d\n",
+	     meta_add, cow_len, *credits);
+	ret = ocfs2_reserve_new_metadata_blocks(osb, meta_add,
+						&context->meta_ac);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_reserve_clusters(osb, cow_len, &context->data_ac);
+	if (ret < 0)
+		mlog_errno(ret);
+
+out:
+	if (ret) {
+		if (context->meta_ac) {
+			ocfs2_free_alloc_context(context->meta_ac);
+			context->meta_ac = NULL;
+		}
+	}
+
+	return ret;
+}
+
+static int ocfs2_duplicate_clusters_in_large_page(handle_t *handle,
+					struct ocfs2_caching_info *ci,
+					struct ocfs2_cow_context *context,
+					u32 cpos, u32 len,
+					u64 old_block, u64 new_block)
+{
+	int ret = 0;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	int i, bpc = ocfs2_clusters_to_blocks(sb, 1);
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	int cpp = 1 << (PAGE_CACHE_SHIFT - osb->s_clustersize_bits);
+	int page_start = context->cow_start / cpp;
+	int cow_page, cow_len, cp_len;
+	u64 phys;
+	struct page *page;
+	void *kaddr;
+	unsigned int from, cp_from, to;
+
+	while (len) {
+		phys = new_block;
+		cow_page = cpos / cpp;
+		cow_len = cpp - cpos % cpp;
+		cp_len = 0;
+		if (cow_len > len)
+			cow_len = len;
+
+		page = context->cow_pages[cow_page - page_start];
+		cp_from = from = (cpos % cpp) << osb->s_clustersize_bits;
+		to = from + (cow_len << osb->s_clustersize_bits);
+
+		while (cp_len < cow_len) {
+			ret = ocfs2_read_blocks(ci, old_block, bpc,
+						context->bhs, 0, NULL);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			kaddr = kmap_atomic(page, KM_USER0);
+			for (i = 0; i < bpc; i++)
+				memcpy(kaddr + cp_from + i * sb->s_blocksize,
+					       context->bhs[i]->b_data,
+					       sb->s_blocksize);
+			kunmap_atomic(kaddr, KM_USER0);
+
+			for (i = 0; i < bpc; i++) {
+				brelse(context->bhs[i]);
+				context->bhs[i] = NULL;
+			}
+
+			cpos++;
+			cp_len++;
+			old_block += bpc;
+			cp_from += osb->s_clustersize;
+		}
+
+		ocfs2_map_and_dirty_page(context->inode,
+					 handle, from, to,
+					 page, 0, &phys);
+
+		len -= cow_len;
+		new_block += bpc * cow_len;
+	}
+
+out:
+	return ret;
+}
+
+static int ocfs2_duplicate_clusters(handle_t *handle,
+				    struct ocfs2_cow_context *context,
+				    u32 cpos, u32 old_cluster,
+				    u32 new_cluster, u32 new_len)
+{
+	int ret = 0, bh_num;
+	struct ocfs2_caching_info *ci = context->di_et.et_ci;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	int i, j, bpc = ocfs2_clusters_to_blocks(sb, 1);
+	u64 old_block = ocfs2_clusters_to_blocks(sb, old_cluster);
+	u64 phys, new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	int page_start, ppc = ocfs2_pages_per_cluster(sb);
+	int bpp = 1 << (PAGE_CACHE_SHIFT - sb->s_blocksize_bits);
+	struct page *page;
+	void *kaddr;
+	unsigned int from;
+
+	mlog(0, "old_cluster %u, new %u, len %u at offset %u\n", old_cluster,
+	     new_cluster, new_len, cpos);
+
+	if (osb->s_clustersize_bits >= PAGE_CACHE_SHIFT) {
+		/*
+		 * Page size is less than cluster size, so we just need
+		 * to write all the pages in the new clusters.
+		 */
+		while (new_len) {
+			phys = new_block;
+			ret = ocfs2_read_blocks(ci, old_block, bpc,
+						context->bhs, 0, NULL);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			bh_num = 0;
+
+			page_start = (cpos - context->cow_start) * ppc;
+			from = cpos << osb->s_clustersize_bits;
+
+			for (i = 0; i < ppc; i++, from += PAGE_CACHE_SIZE) {
+				page = context->cow_pages[page_start + i];
+
+				kaddr = kmap_atomic(page, KM_USER0);
+				for (j = 0; j < bpp; j++, bh_num++)
+					memcpy(kaddr + j * sb->s_blocksize,
+					       context->bhs[bh_num]->b_data,
+					       sb->s_blocksize);
+				kunmap_atomic(kaddr, KM_USER0);
+
+				ocfs2_map_and_dirty_page(context->inode,
+							 handle, 0,
+							 PAGE_CACHE_SIZE,
+							 page, 0, &phys);
+			}
+
+			for (i = 0; i < bpc; i++) {
+				brelse(context->bhs[i]);
+				context->bhs[i] = NULL;
+			}
+
+			new_len--;
+			cpos++;
+			old_block += bpc;
+			new_block += bpc;
+		}
+	} else {
+		ret = ocfs2_duplicate_clusters_in_large_page(handle, ci,
+							     context,
+							     cpos, new_len,
+							     old_block,
+							     new_block);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+out:
+	return ret;
+}
+
+static int ocfs2_clear_ext_refcount(handle_t *handle,
+				    struct ocfs2_extent_tree *et,
+				    u32 cpos, u32 p_cluster, u32 len,
+				    unsigned int ext_flags,
+				    struct ocfs2_alloc_context *meta_ac,
+				    struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret, index;
+	struct ocfs2_extent_rec replace_rec;
+	struct ocfs2_path *path = NULL;
+	struct ocfs2_extent_list *el;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
+	u64 ino = ocfs2_metadata_cache_owner(et->et_ci);
+
+	mlog(0, "inode %llu cpos %u, len %u, p_cluster %u, ext_flags %u\n",
+	     (unsigned long long)ino, cpos, len, p_cluster, ext_flags);
+
+	memset(&replace_rec, 0, sizeof(replace_rec));
+	replace_rec.e_cpos = cpu_to_le32(cpos);
+	replace_rec.e_leaf_clusters = cpu_to_le16(len);
+	replace_rec.e_blkno = cpu_to_le64(ocfs2_clusters_to_blocks(sb,
+								   p_cluster));
+	replace_rec.e_flags = ext_flags;
+	replace_rec.e_flags &= ~OCFS2_EXT_REFCOUNTED;
+
+	path = ocfs2_new_path_from_et(et);
+	ret = ocfs2_find_path(et->et_ci, path, cpos);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	el = path_leaf_el(path);
+
+	index = ocfs2_search_extent_list(el, cpos);
+	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+		ocfs2_error(sb,
+			    "Inode %llu has an extent at cpos %u which can no "
+			    "longer be found.\n",
+			    (unsigned long long)ino, cpos);
+		ret = -EROFS;
+		goto out;
+	}
+
+	ret = ocfs2_split_extent(handle, et, path, index,
+				 &replace_rec, meta_ac, dealloc);
+
+out:
+	ocfs2_free_path(path);
+	return ret;
+}
+
+static int ocfs2_replace_clusters(handle_t *handle,
+				  struct ocfs2_cow_context *context,
+				  u32 cpos, u32 old,
+				  u32 new, u32 len,
+				  unsigned int ext_flags)
+{
+	int ret;
+	struct ocfs2_caching_info *ci = context->di_et.et_ci;
+	u64 ino = ocfs2_metadata_cache_owner(ci);
+
+	mlog(0, "inode %llu, cpos %u, old %u, new %u, len %u, ext_flags %u\n",
+	     (unsigned long long)ino, cpos, old, new, len, ext_flags);
+
+	/*If the old clusters is unwritten, no need to duplicate. */
+	if (!(ext_flags & OCFS2_EXT_UNWRITTEN)) {
+		ret = ocfs2_duplicate_clusters(handle, context, cpos,
+					       old, new, len);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	ret = ocfs2_clear_ext_refcount(handle, &context->di_et,
+				       cpos, new, len, ext_flags,
+				       context->meta_ac, &context->dealloc);
+out:
+	return ret;
+}
+
+static int ocfs2_make_clusters_writable(handle_t *handle,
+					struct ocfs2_cow_context *context,
+					u32 cpos, u32 p_cluster,
+					u32 num_clusters, unsigned int e_flags)
+{
+	int ret;
+	u32 new_bit, new_len;
+	struct ocfs2_caching_info *inode_ci = context->di_et.et_ci;
+	struct ocfs2_super *osb =
+			OCFS2_SB(ocfs2_metadata_cache_get_super(inode_ci));
+
+	while (num_clusters) {
+		ret = __ocfs2_claim_clusters(osb, handle, context->data_ac,
+					     1, num_clusters,
+					     &new_bit, &new_len);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		ret = ocfs2_replace_clusters(handle, context,
+					     cpos, p_cluster, new_bit,
+					     new_len, e_flags);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		cpos += new_len;
+		num_clusters -= new_len;
+	}
+
+	return ret;
+}
+
+static int ocfs2_replace_cow(struct inode *inode,
+			     struct buffer_head *di_bh,
+			     struct buffer_head *ref_bh,
+			     u32 cow_start, u32 cow_len,
+			     int num_recs,
+			     struct page **pages,
+			     int num_pages)
+{
+	int ret, credits;
+	u32 p_cluster, num_clusters, start = cow_start;
+	unsigned int ext_flags;
+	handle_t *handle = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_cow_context context;
+
+	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
+		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
+			    "tree, but the feature bit is not set in the "
+			    "super block.", inode->i_ino);
+		return -EROFS;
+	}
+
+	memset(&context, 0, sizeof(context));
+
+	context.inode = inode;
+	context.cow_pages = pages;
+	context.num_pages = num_pages;
+	context.cow_start = cow_start;
+	context.cow_len = cow_len;
+
+	context.bhs = kcalloc(ocfs2_clusters_to_blocks(inode->i_sb, 1),
+			      sizeof(struct buffer_head *), GFP_NOFS);
+	if (!context.bhs) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ocfs2_init_dealloc_ctxt(&context.dealloc);
+	ocfs2_init_dinode_extent_tree(&context.di_et,
+				      INODE_CACHE(inode), di_bh);
+	ocfs2_init_refcount_extent_tree(&context.ref_et,
+					INODE_CACHE(inode), ref_bh);
+
+	ret = ocfs2_lock_refcount_cow_allocator(inode->i_sb, cow_len,
+						&context, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	/*
+	 * We also need the credits for removing extents for both di-tree and
+	 * refcount tree and the copy of data.
+	 */
+	credits += ocfs2_remove_extent_credits(inode->i_sb) * num_recs * 2;
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	while (cow_len) {
+		ret = ocfs2_get_clusters(inode, cow_start, &p_cluster,
+					 &num_clusters, &ext_flags);
+
+		BUG_ON(!(ext_flags & OCFS2_EXT_REFCOUNTED));
+
+		if (cow_len < num_clusters)
+			num_clusters = cow_len;
+
+		ret = ocfs2_make_clusters_writable(handle, &context, cow_start,
+						   p_cluster, num_clusters,
+						   ext_flags);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		ret = __ocfs2_decrease_refcount(handle, &context.ref_et,
+						p_cluster, num_clusters,
+						context.meta_ac,
+						&context.dealloc);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		cow_len -= num_clusters;
+		cow_start += num_clusters;
+	}
+
+
+	/*
+	 * truncate the extent map here since no matter whether we meet with
+	 * any error during the action, we shouldn't trust cached extent map
+	 * any more.
+	 */
+	ocfs2_extent_map_trunc(inode, start);
+	ocfs2_commit_trans(osb, handle);
+
+out:
+	if (context.data_ac)
+		ocfs2_free_alloc_context(context.data_ac);
+	if (context.meta_ac)
+		ocfs2_free_alloc_context(context.meta_ac);
+
+	if (ocfs2_dealloc_has_cluster(&context.dealloc)) {
+		ocfs2_schedule_truncate_log_flush(osb, 1);
+		ocfs2_run_deallocs(osb, &context.dealloc);
+	}
+
+	kfree(context.bhs);
+	return ret;
+}
+
+int ocfs2_refcount_cow(struct inode *inode,
+		       struct buffer_head *di_bh,
+		       u32 cpos, u32 write_len)
+{
+	int ret, num_recs = 0, has_data = 0, num_pages = 0;
+	u32 cow_start = 0, cow_len = 0;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct buffer_head *ref_bh = NULL;
+	struct page **pages = NULL;
+	loff_t start, end;
+
+	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!di->i_refcount_loc);
+
+	ret = ocfs2_refcount_cal_cow_clusters(inode, di_bh, cpos, write_len,
+					      &cow_start, &cow_len,
+					       &num_recs, &has_data);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	mlog(0, "CoW inode %lu, cpos %u, write_len %u, cow_start %u, "
+	     "cow_len %u, num_recs %d\n", inode->i_ino,
+	     cpos, write_len, cow_start, cow_len, num_recs);
+
+	BUG_ON(cow_len == 0 || num_recs == 0);
+
+	if (has_data) {
+		pages = kcalloc(ocfs2_pages_per_cluster(inode->i_sb) * cow_len,
+				sizeof(struct page *), GFP_NOFS);
+		if (pages == NULL) {
+			ret = -ENOMEM;
+			mlog_errno(ret);
+			goto out;
+		}
+
+		start = cow_start << OCFS2_SB(inode->i_sb)->s_clustersize_bits;
+		end = start +
+			(cow_len << OCFS2_SB(inode->i_sb)->s_clustersize_bits);
+		ret = ocfs2_grab_pages(inode, start, end, pages, &num_pages);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
+					le64_to_cpu(di->i_refcount_loc),
+					&ref_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_replace_cow(inode, di_bh, ref_bh,
+				cow_start, cow_len, num_recs,
+				pages, num_pages);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	if (pages) {
+		ocfs2_unlock_and_free_pages(pages, num_pages);
+		kfree(pages);
+	}
+	brelse(ref_bh);
+	return ret;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 9b646c5..1b6e4d6 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -31,4 +31,6 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  struct buffer_head *di_bh,
 					  int *credits,
 					  struct ocfs2_alloc_context **meta_ac);
+int ocfs2_refcount_cow(struct inode *inode, struct buffer_head *di_bh,
+		       u32 cpos, u32 write_len);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
