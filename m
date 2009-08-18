From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:18 +0800
Subject: [Ocfs2-devel] [PATCH 17/41] ocfs2: Add CoW support.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-17-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch try CoW support for a refcounted record.

the whole process will be:
1. Calculate how much clusters we need to CoW and where we start.
   Currently we will CoW 1MB at most.
2. Do CoW for the clusters with the help of page cache.
3. Change the b-tree structure with the new allocated clusters.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |   25 ++-
 fs/ocfs2/alloc.h        |    5 +
 fs/ocfs2/aops.c         |    4 +-
 fs/ocfs2/aops.h         |    2 +
 fs/ocfs2/refcounttree.c |  677 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    2 +
 6 files changed, 704 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 03438a6..b8fc95d 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6998,9 +6998,9 @@ static int ocfs2_zero_func(handle_t *handle, struct buffer_head *bh)
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
 
@@ -7068,20 +7068,16 @@ out:
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
@@ -7109,6 +7105,17 @@ out:
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
index 19d5b88..9c122d5 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -271,6 +271,11 @@ static inline int ocfs2_is_empty_extent(struct ocfs2_extent_rec *rec)
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
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7208ea9..65e17b3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -126,8 +126,8 @@ bail:
 	return err;
 }
 
-static int ocfs2_get_block(struct inode *inode, sector_t iblock,
-			   struct buffer_head *bh_result, int create)
+int ocfs2_get_block(struct inode *inode, sector_t iblock,
+		    struct buffer_head *bh_result, int create)
 {
 	int err = 0;
 	unsigned int ext_flags;
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 503e492..c48e93f 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -57,6 +57,8 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 			   struct buffer_head *di_bh);
 int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
 
+int ocfs2_get_block(struct inode *inode, sector_t iblock,
+		    struct buffer_head *bh_result, int create);
 /* all ocfs2_dio_end_io()'s fault */
 #define ocfs2_iocb_is_rw_locked(iocb) \
 	test_bit(0, (unsigned long *)&iocb->private)
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 6dee650..5adcd6a 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -31,6 +31,27 @@
 #include "sysfile.h"
 #include "dlmglue.h"
 #include "extent_map.h"
+#include "aops.h"
+
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/gfp.h>
+#include <linux/slab.h>
+#include <linux/writeback.h>
+#include <linux/pagevec.h>
+#include <linux/swap.h>
+
+struct ocfs2_cow_context {
+	struct inode *inode;
+	u32 cow_start;
+	u32 cow_len;
+	struct ocfs2_extent_tree di_et;
+	struct ocfs2_caching_info *ref_ci;
+	struct buffer_head *ref_root_bh;
+	struct ocfs2_alloc_context *meta_ac;
+	struct ocfs2_alloc_context *data_ac;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+};
 
 static inline struct ocfs2_refcount_tree *
 cache_info_to_refcount(struct ocfs2_caching_info *ci)
@@ -2402,3 +2423,659 @@ out:
 	brelse(ref_root_bh);
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
+					   u32 *cow_len)
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
+	for (i = 0; i < le16_to_cpu(el->l_next_free_rec); i++) {
+		rec = &el->l_recs[i];
+
+		if (ocfs2_is_empty_extent(rec)) {
+			mlog_bug_on_msg(i != 0, "Inode %lu has empty record in "
+					"index %d\n", inode->i_ino, i);
+			continue;
+		}
+
+		if (le32_to_cpu(rec->e_cpos) +
+		    le16_to_cpu(rec->e_leaf_clusters) <= cpos)
+			continue;
+
+		if (*cow_len == 0) {
+			/*
+			 * We should find a refcounted record in the
+			 * first pass.
+			 */
+			BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED));
+			*cow_start = le32_to_cpu(rec->e_cpos);
+		}
+
+		/*
+		 * If we encounter a hole or a non-refcounted record,
+		 * stop the search.
+		 */
+		if ((!(rec->e_flags & OCFS2_EXT_REFCOUNTED)) ||
+		    (*cow_len && rec_end != le32_to_cpu(rec->e_cpos)))
+			break;
+
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
+				if ((rec_end - cpos) <= max_clusters) {
+					/*
+					 * We can take max_clusters off
+					 * the end and cover all of our
+					 * write.
+					 */
+					*cow_start = rec_end - max_clusters;
+				} else if ((*cow_start + max_clusters) >
+					   (cpos + write_len)) {
+					/*
+					 * We can take max_clusters off
+					 * the front and cover all of
+					 * our write.
+					 */
+					/* NOOP, *cow_start is already set */
+				} else {
+					/*
+					 * We're CoWing more data than
+					 * write_len for contiguousness,
+					 * but it doesn't fit at the
+					 * front or end of this extent.
+					 * Let's try to slice the extent
+					 * up nicely.  Optimally, our
+					 * CoW region starts at a
+					 * multiple of max_clusters.  If
+					 * that doesn't fit, we give up
+					 * and just CoW at cpos.
+					 */
+					*cow_start +=
+						(cpos - *cow_start) &
+							~(max_clusters - 1);
+					if ((*cow_start + max_clusters) <
+					    (cpos + write_len))
+						*cow_start = cpos;
+				}
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
+		if (i + 1 == le16_to_cpu(el->l_next_free_rec) &&
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
+			i = -1;
+		}
+	}
+
+out:
+	brelse(eb_bh);
+	return ret;
+}
+
+/*
+ * Prepare meta_ac, data_ac and calculate credits when we want to add some
+ * num_clusters in data_tree "et" and change the refcount for the old
+ * clusters(starting form p_cluster) in the refcount tree.
+ *
+ * Note:
+ * 1. since we may split the old tree, so we at most will need num_clusters + 2
+ *    more new leaf records.
+ * 2. In some case, we may not need to reserve new clusters(e.g, reflink), so
+ *    just give data_ac = NULL.
+ */
+static int ocfs2_lock_refcount_allocators(struct super_block *sb,
+					u32 p_cluster, u32 num_clusters,
+					struct ocfs2_extent_tree *et,
+					struct ocfs2_caching_info *ref_ci,
+					struct buffer_head *ref_root_bh,
+					struct ocfs2_alloc_context **meta_ac,
+					struct ocfs2_alloc_context **data_ac,
+					int *credits)
+{
+	int ret = 0, meta_add = 0;
+	int num_free_extents = ocfs2_num_free_extents(OCFS2_SB(sb), et);
+
+	if (num_free_extents < 0) {
+		ret = num_free_extents;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (num_free_extents < num_clusters + 2)
+		meta_add =
+			ocfs2_extend_meta_needed(et->et_root_el);
+
+	*credits += ocfs2_calc_extend_credits(sb, et->et_root_el,
+					      num_clusters + 2);
+
+	ret = ocfs2_calc_refcount_meta_credits(sb, ref_ci, ref_root_bh,
+					       p_cluster, num_clusters,
+					       &meta_add, credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "reserve new metadata %d, clusters %u, credits = %d\n",
+	     meta_add, num_clusters, *credits);
+	ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(sb), meta_add,
+						meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (data_ac) {
+		ret = ocfs2_reserve_clusters(OCFS2_SB(sb), num_clusters,
+					     data_ac);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+out:
+	if (ret) {
+		if (*meta_ac) {
+			ocfs2_free_alloc_context(*meta_ac);
+			*meta_ac = NULL;
+		}
+	}
+
+	return ret;
+}
+
+static int ocfs2_clear_cow_buffer(handle_t *handle, struct buffer_head *bh)
+{
+	BUG_ON(buffer_dirty(bh));
+
+	clear_buffer_mapped(bh);
+
+	return 0;
+}
+
+static int ocfs2_duplicate_clusters(handle_t *handle,
+				    struct ocfs2_cow_context *context,
+				    u32 cpos, u32 old_cluster,
+				    u32 new_cluster, u32 new_len)
+{
+	int ret = 0, partial;
+	struct ocfs2_caching_info *ci = context->di_et.et_ci;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
+	struct page *page;
+	pgoff_t page_index;
+	unsigned int from, to;
+	loff_t offset, end, map_end;
+	struct address_space *mapping = context->inode->i_mapping;
+
+	mlog(0, "old_cluster %u, new %u, len %u at offset %u\n", old_cluster,
+	     new_cluster, new_len, cpos);
+
+	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
+	end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
+
+	while (offset < end) {
+		page_index = offset >> PAGE_CACHE_SHIFT;
+		map_end = (page_index + 1) << PAGE_CACHE_SHIFT;
+		if (map_end > end)
+			map_end = end;
+
+		/* from, to is the offset within the page. */
+		from = offset & (PAGE_CACHE_SIZE - 1);
+		to = PAGE_CACHE_SIZE;
+		if (map_end & (PAGE_CACHE_SIZE - 1))
+			to = map_end & (PAGE_CACHE_SIZE - 1);
+
+		page = grab_cache_page(mapping, page_index);
+
+		/* This page can't be dirtied before we CoW it out. */
+		BUG_ON(PageDirty(page));
+
+		if (!PageUptodate(page)) {
+			ret = block_read_full_page(page, ocfs2_get_block);
+			if (ret) {
+				mlog_errno(ret);
+				goto unlock;
+			}
+			lock_page(page);
+		}
+
+		if (page_has_buffers(page)) {
+			ret = walk_page_buffers(handle, page_buffers(page),
+						from, to, &partial,
+						ocfs2_clear_cow_buffer);
+			if (ret) {
+				mlog_errno(ret);
+				goto unlock;
+			}
+		}
+
+		ocfs2_map_and_dirty_page(context->inode,
+					 handle, from, to,
+					 page, 0, &new_block);
+		mark_page_accessed(page);
+unlock:
+		unlock_page(page);
+		page_cache_release(page);
+		page = NULL;
+		offset = map_end;
+		if (ret)
+			break;
+	}
+
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
+	if (!path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
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
+	if (ret)
+		mlog_errno(ret);
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
+	if (ret)
+		mlog_errno(ret);
+out:
+	return ret;
+}
+
+static int ocfs2_cow_sync_writeback(struct super_block *sb,
+				    struct ocfs2_cow_context *context,
+				    u32 cpos, u32 num_clusters)
+{
+	int ret = 0;
+	loff_t offset, end, map_end;
+	pgoff_t page_index;
+	struct page *page;
+
+	if (ocfs2_should_order_data(context->inode))
+		return 0;
+
+	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
+	end = offset + (num_clusters << OCFS2_SB(sb)->s_clustersize_bits);
+
+	ret = filemap_fdatawrite_range(context->inode->i_mapping,
+				       offset, end - 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	while (offset < end) {
+		page_index = offset >> PAGE_CACHE_SHIFT;
+		map_end = (page_index + 1) << PAGE_CACHE_SHIFT;
+		if (map_end > end)
+			map_end = end;
+
+		page = grab_cache_page(context->inode->i_mapping, page_index);
+		BUG_ON(!page);
+
+		wait_on_page_writeback(page);
+		if (PageError(page)) {
+			ret = -EIO;
+			mlog_errno(ret);
+		} else
+			mark_page_accessed(page);
+
+		unlock_page(page);
+		page_cache_release(page);
+		page = NULL;
+		offset = map_end;
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int ocfs2_make_clusters_writable(struct super_block *sb,
+					struct ocfs2_cow_context *context,
+					u32 cpos, u32 p_cluster,
+					u32 num_clusters, unsigned int e_flags)
+{
+	int ret, credits =  0;
+	u32 new_bit, new_len;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	handle_t *handle;
+
+	ret = ocfs2_lock_refcount_allocators(sb, p_cluster, num_clusters,
+					     &context->di_et,
+					     context->ref_ci,
+					     context->ref_root_bh,
+					     &context->meta_ac,
+					     &context->data_ac, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	while (num_clusters) {
+		ret = __ocfs2_claim_clusters(osb, handle, context->data_ac,
+					     1, num_clusters,
+					     &new_bit, &new_len);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		ret = ocfs2_replace_clusters(handle, context,
+					     cpos, p_cluster, new_bit,
+					     new_len, e_flags);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		cpos += new_len;
+		p_cluster += new_len;
+		num_clusters -= new_len;
+	}
+
+	ret = __ocfs2_decrease_refcount(handle, context->ref_ci,
+					context->ref_root_bh,
+					p_cluster, num_clusters,
+					context->meta_ac,
+					&context->dealloc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * Here we should write the new page out first if we are
+	 * in write-back mode.
+	 */
+	ret = ocfs2_cow_sync_writeback(sb, context, cpos, num_clusters);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out:
+	if (context->data_ac) {
+		ocfs2_free_alloc_context(context->data_ac);
+		context->data_ac = NULL;
+	}
+	if (context->meta_ac) {
+		ocfs2_free_alloc_context(context->meta_ac);
+		context->meta_ac = NULL;
+	}
+
+	return ret;
+}
+
+static int ocfs2_replace_cow(struct inode *inode,
+			     struct buffer_head *di_bh,
+			     struct buffer_head *ref_root_bh,
+			     struct ocfs2_caching_info *ref_ci,
+			     u32 cow_start, u32 cow_len)
+{
+	int ret;
+	u32 p_cluster, num_clusters, start = cow_start;
+	unsigned int ext_flags;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_cow_context *context;
+
+	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
+		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
+			    "tree, but the feature bit is not set in the "
+			    "super block.", inode->i_ino);
+		return -EROFS;
+	}
+
+	context = kzalloc(sizeof(struct ocfs2_cow_context), GFP_NOFS);
+	if (!context) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		return ret;
+	}
+
+	context->inode = inode;
+	context->cow_start = cow_start;
+	context->cow_len = cow_len;
+	context->ref_ci = ref_ci;
+	context->ref_root_bh = ref_root_bh;
+
+	ocfs2_init_dealloc_ctxt(&context->dealloc);
+	ocfs2_init_dinode_extent_tree(&context->di_et,
+				      INODE_CACHE(inode), di_bh);
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
+		ret = ocfs2_make_clusters_writable(inode->i_sb, context,
+						   cow_start, p_cluster,
+						   num_clusters, ext_flags);
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
+
+	if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
+		ocfs2_schedule_truncate_log_flush(osb, 1);
+		ocfs2_run_deallocs(osb, &context->dealloc);
+	}
+
+	kfree(context);
+	return ret;
+}
+
+int ocfs2_refcount_cow(struct inode *inode,
+		       struct buffer_head *di_bh,
+		       u32 cpos, u32 write_len)
+{
+	int ret;
+	u32 cow_start = 0, cow_len = 0;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_refcount_tree *ref_tree;
+
+	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+
+	ret = ocfs2_refcount_cal_cow_clusters(inode, di_bh, cpos, write_len,
+					      &cow_start, &cow_len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	mlog(0, "CoW inode %lu, cpos %u, write_len %u, cow_start %u, "
+	     "cow_len %u\n", inode->i_ino,
+	     cpos, write_len, cow_start, cow_len);
+
+	BUG_ON(cow_len == 0);
+
+	ret = ocfs2_lock_refcount_tree(osb, le64_to_cpu(di->i_refcount_loc),
+				       1, &ref_tree, &ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_replace_cow(inode, di_bh, ref_root_bh, &ref_tree->rf_ci,
+				cow_start, cow_len);
+	if (ret)
+		mlog_errno(ret);
+
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	brelse(ref_root_bh);
+out:
+	return ret;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index bd2b1ee..949ff45 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -51,4 +51,6 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  u32 clusters,
 					  int *credits,
 					  struct ocfs2_alloc_context **meta_ac);
+int ocfs2_refcount_cow(struct inode *inode, struct buffer_head *di_bh,
+		       u32 cpos, u32 write_len);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
