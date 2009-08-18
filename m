From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:14 +0800
Subject: [Ocfs2-devel] [PATCH 13/41] ocfs2: Add support for incrementing
	refcount in the tree.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-13-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

    Given a physical cpos and length, increment the refcount
in the tree. If the extent has not been seen before, a refcount
record is created for it. Refcount records may be merged or
split by this operation.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/extent_map.c   |   15 +-
 fs/ocfs2/extent_map.h   |    5 +
 fs/ocfs2/ocfs2_fs.h     |    7 +
 fs/ocfs2/refcounttree.c | 1053 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1073 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index dc9482c..40b5105 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -353,11 +353,11 @@ static int ocfs2_search_for_hole_index(struct ocfs2_extent_list *el,
  * eb_bh is NULL. Otherwise, eb_bh should point to the extent block
  * containing el.
  */
-static int ocfs2_figure_hole_clusters(struct inode *inode,
-				      struct ocfs2_extent_list *el,
-				      struct buffer_head *eb_bh,
-				      u32 v_cluster,
-				      u32 *num_clusters)
+int ocfs2_figure_hole_clusters(struct ocfs2_caching_info *ci,
+			       struct ocfs2_extent_list *el,
+			       struct buffer_head *eb_bh,
+			       u32 v_cluster,
+			       u32 *num_clusters)
 {
 	int ret, i;
 	struct buffer_head *next_eb_bh = NULL;
@@ -375,7 +375,7 @@ static int ocfs2_figure_hole_clusters(struct inode *inode,
 		if (le64_to_cpu(eb->h_next_leaf_blk) == 0ULL)
 			goto no_more_extents;
 
-		ret = ocfs2_read_extent_block(INODE_CACHE(inode),
+		ret = ocfs2_read_extent_block(ci,
 					      le64_to_cpu(eb->h_next_leaf_blk),
 					      &next_eb_bh);
 		if (ret) {
@@ -456,7 +456,8 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 		 * field.
 		 */
 		if (hole_len) {
-			ret = ocfs2_figure_hole_clusters(inode, el, eb_bh,
+			ret = ocfs2_figure_hole_clusters(INODE_CACHE(inode),
+							 el, eb_bh,
 							 v_cluster, &len);
 			if (ret) {
 				mlog_errno(ret);
diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
index b7dd973..9942f47 100644
--- a/fs/ocfs2/extent_map.h
+++ b/fs/ocfs2/extent_map.h
@@ -61,6 +61,11 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 			   struct buffer_head *bhs[], int flags,
 			   int (*validate)(struct super_block *sb,
 					   struct buffer_head *bh));
+int ocfs2_figure_hole_clusters(struct ocfs2_caching_info *ci,
+			       struct ocfs2_extent_list *el,
+			       struct buffer_head *eb_bh,
+			       u32 v_cluster,
+			       u32 *num_clusters);
 static inline int ocfs2_read_virt_block(struct inode *inode, u64 v_block,
 					struct buffer_head **bh,
 					int (*validate)(struct super_block *sb,
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index e4288b4..40072cd 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -916,6 +916,7 @@ struct ocfs2_refcount_rec {
 	__le32 r_refcount;	/* Reference count of this extent */
 /*10*/
 };
+#define OCFS2_32BIT_POS_MASK		(0xffffffffULL)
 
 #define OCFS2_REFCOUNT_LEAF_FL          (0x00000001)
 #define OCFS2_REFCOUNT_TREE_FL          (0x00000002)
@@ -1394,6 +1395,12 @@ static inline u16 ocfs2_refcount_recs_per_rb(struct super_block *sb)
 
 	return size / sizeof(struct ocfs2_refcount_rec);
 }
+
+static inline u32
+ocfs2_get_ref_rec_low_cpos(const struct ocfs2_refcount_rec *rec)
+{
+	return le64_to_cpu(rec->r_cpos) & OCFS2_32BIT_POS_MASK;
+}
 #else
 static inline int ocfs2_fast_symlink_chars(int blocksize)
 {
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 650347b..4c3f5e9 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -15,6 +15,7 @@
  * General Public License for more details.
  */
 
+#include <linux/sort.h>
 #define MLOG_MASK_PREFIX ML_REFCOUNT
 #include <cluster/masklog.h>
 #include "ocfs2.h"
@@ -29,6 +30,7 @@
 #include "refcounttree.h"
 #include "sysfile.h"
 #include "dlmglue.h"
+#include "extent_map.h"
 
 static inline struct ocfs2_refcount_tree *
 cache_info_to_refcount(struct ocfs2_caching_info *ci)
@@ -846,3 +848,1054 @@ out:
 
 	return ret;
 }
+
+static void ocfs2_find_refcount_rec_in_rl(struct ocfs2_caching_info *ci,
+					  struct buffer_head *ref_leaf_bh,
+					  u64 cpos, unsigned int len,
+					  struct ocfs2_refcount_rec *ret_rec,
+					  int *index)
+{
+	int i = 0;
+	struct ocfs2_refcount_block *rb =
+		(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+	struct ocfs2_refcount_rec *rec = NULL;
+
+	for (; i < le16_to_cpu(rb->rf_records.rl_used); i++) {
+		rec = &rb->rf_records.rl_recs[i];
+
+		if (le64_to_cpu(rec->r_cpos) +
+		    le32_to_cpu(rec->r_clusters) <= cpos)
+			continue;
+		else if (le64_to_cpu(rec->r_cpos) > cpos)
+			break;
+
+		/* ok, cpos fail in this rec. Just return. */
+		if (ret_rec)
+			*ret_rec = *rec;
+		goto out;
+	}
+
+	if (ret_rec) {
+		/* We meet with a hole here, so fake the rec. */
+		ret_rec->r_cpos = cpu_to_le64(cpos);
+		ret_rec->r_refcount = 0;
+		if (i < le16_to_cpu(rb->rf_records.rl_used) &&
+		    le64_to_cpu(rec->r_cpos) < cpos + len)
+			ret_rec->r_clusters =
+				cpu_to_le32(le64_to_cpu(rec->r_cpos) - cpos);
+		else
+			ret_rec->r_clusters = cpu_to_le32(len);
+	}
+
+out:
+	*index = i;
+}
+
+/*
+ * Given a cpos and len, try to find the refcount record which contains cpos.
+ * 1. If cpos can be found in one refcount record, return the record.
+ * 2. If cpos can't be found, return a fake record which start from cpos
+ *    and end at a small value between cpos+len and start of the next record.
+ *    This fake record has r_refcount = 0.
+ */
+static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
+				  struct buffer_head *ref_root_bh,
+				  u64 cpos, unsigned int len,
+				  struct ocfs2_refcount_rec *ret_rec,
+				  int *index,
+				  struct buffer_head **ret_bh)
+{
+	int ret = 0, i, found;
+	u32 low_cpos;
+	struct ocfs2_extent_list *el;
+	struct ocfs2_extent_rec *tmp, *rec = NULL;
+	struct ocfs2_extent_block *eb;
+	struct buffer_head *eb_bh = NULL, *ref_leaf_bh = NULL;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	struct ocfs2_refcount_block *rb =
+			(struct ocfs2_refcount_block *)ref_root_bh->b_data;
+
+	if (!(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL)) {
+		ocfs2_find_refcount_rec_in_rl(ci, ref_root_bh, cpos, len,
+					      ret_rec, index);
+		*ret_bh = ref_root_bh;
+		get_bh(ref_root_bh);
+		return 0;
+	}
+
+	el = &rb->rf_list;
+	low_cpos = cpos & OCFS2_32BIT_POS_MASK;
+
+	if (el->l_tree_depth) {
+		ret = ocfs2_find_leaf(ci, el, low_cpos, &eb_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
+		el = &eb->h_list;
+
+		if (el->l_tree_depth) {
+			ocfs2_error(sb,
+			"refcount tree %llu has non zero tree "
+			"depth in leaf btree tree block %llu\n",
+			(unsigned long long)ocfs2_metadata_cache_owner(ci),
+			(unsigned long long)eb_bh->b_blocknr);
+			ret = -EROFS;
+			goto out;
+		}
+	}
+
+	found = 0;
+	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
+		rec = &el->l_recs[i];
+
+		if (le32_to_cpu(rec->e_cpos) <= low_cpos) {
+			found = 1;
+			break;
+		}
+	}
+
+	/* adjust len when we have ocfs2_extent_rec after it. */
+	if (found && i < le16_to_cpu(el->l_next_free_rec) - 1) {
+		tmp = &el->l_recs[i+1];
+
+		if (le32_to_cpu(tmp->e_cpos) < cpos + len)
+			len = le32_to_cpu(tmp->e_cpos) - cpos;
+	}
+
+	ret = ocfs2_read_refcount_block(ci, le64_to_cpu(rec->e_blkno),
+					&ref_leaf_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_find_refcount_rec_in_rl(ci, ref_leaf_bh, cpos, len,
+				      ret_rec, index);
+	*ret_bh = ref_leaf_bh;
+out:
+	brelse(eb_bh);
+	return ret;
+}
+
+enum ocfs2_ref_rec_contig {
+	REF_CONTIG_NONE = 0,
+	REF_CONTIG_LEFT,
+	REF_CONTIG_RIGHT,
+	REF_CONTIG_LEFTRIGHT,
+};
+
+static enum ocfs2_ref_rec_contig
+	ocfs2_refcount_rec_adjacent(struct ocfs2_refcount_block *rb,
+				    int index)
+{
+	if ((rb->rf_records.rl_recs[index].r_refcount ==
+	    rb->rf_records.rl_recs[index + 1].r_refcount) &&
+	    (le64_to_cpu(rb->rf_records.rl_recs[index].r_cpos) +
+	    le32_to_cpu(rb->rf_records.rl_recs[index].r_clusters) ==
+	    le64_to_cpu(rb->rf_records.rl_recs[index + 1].r_cpos)))
+		return REF_CONTIG_RIGHT;
+
+	return REF_CONTIG_NONE;
+}
+
+static enum ocfs2_ref_rec_contig
+	ocfs2_refcount_rec_contig(struct ocfs2_refcount_block *rb,
+				  int index)
+{
+	enum ocfs2_ref_rec_contig ret = REF_CONTIG_NONE;
+
+	if (index < le16_to_cpu(rb->rf_records.rl_used) - 1)
+		ret = ocfs2_refcount_rec_adjacent(rb, index);
+
+	if (index > 0) {
+		enum ocfs2_ref_rec_contig tmp;
+
+		tmp = ocfs2_refcount_rec_adjacent(rb, index - 1);
+
+		if (tmp == REF_CONTIG_RIGHT) {
+			if (ret == REF_CONTIG_RIGHT)
+				ret = REF_CONTIG_LEFTRIGHT;
+			else
+				ret = REF_CONTIG_LEFT;
+		}
+	}
+
+	return ret;
+}
+
+static void ocfs2_rotate_refcount_rec_left(struct ocfs2_refcount_block *rb,
+					   int index)
+{
+	BUG_ON(rb->rf_records.rl_recs[index].r_refcount !=
+	       rb->rf_records.rl_recs[index+1].r_refcount);
+
+	le32_add_cpu(&rb->rf_records.rl_recs[index].r_clusters,
+		     le32_to_cpu(rb->rf_records.rl_recs[index+1].r_clusters));
+
+	if (index < le16_to_cpu(rb->rf_records.rl_used) - 2)
+		memmove(&rb->rf_records.rl_recs[index + 1],
+			&rb->rf_records.rl_recs[index + 2],
+			sizeof(struct ocfs2_refcount_rec) *
+			(le16_to_cpu(rb->rf_records.rl_used) - index - 2));
+
+	memset(&rb->rf_records.rl_recs[le16_to_cpu(rb->rf_records.rl_used) - 1],
+	       0, sizeof(struct ocfs2_refcount_rec));
+	le16_add_cpu(&rb->rf_records.rl_used, -1);
+}
+
+/*
+ * Merge the refcount rec if we are contiguous with the adjacent recs.
+ */
+static void ocfs2_refcount_rec_merge(struct ocfs2_refcount_block *rb,
+				     int index)
+{
+	enum ocfs2_ref_rec_contig contig =
+				ocfs2_refcount_rec_contig(rb, index);
+
+	if (contig == REF_CONTIG_NONE)
+		return;
+
+	if (contig == REF_CONTIG_LEFT || contig == REF_CONTIG_LEFTRIGHT) {
+		BUG_ON(index == 0);
+		index--;
+	}
+
+	ocfs2_rotate_refcount_rec_left(rb, index);
+
+	if (contig == REF_CONTIG_LEFTRIGHT)
+		ocfs2_rotate_refcount_rec_left(rb, index);
+}
+
+static int ocfs2_change_refcount_rec(handle_t *handle,
+				     struct ocfs2_caching_info *ci,
+				     struct buffer_head *ref_leaf_bh,
+				     int index, int change)
+{
+	int ret;
+	struct ocfs2_refcount_block *rb =
+			(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+	struct ocfs2_refcount_rec *rec = &rb->rf_records.rl_recs[index];
+
+	ret = ocfs2_journal_access_rb(handle, ci, ref_leaf_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "change index %d, old count %u, change %d\n", index,
+	     le32_to_cpu(rec->r_refcount), change);
+	le32_add_cpu(&rec->r_refcount, change);
+
+	ocfs2_refcount_rec_merge(rb, index);
+
+	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
+	if (ret)
+		mlog_errno(ret);
+out:
+	return ret;
+}
+
+static int ocfs2_expand_inline_ref_root(handle_t *handle,
+					struct ocfs2_caching_info *ci,
+					struct buffer_head *ref_root_bh,
+					struct buffer_head **ref_leaf_bh,
+					struct ocfs2_alloc_context *meta_ac)
+{
+	int ret;
+	u16 suballoc_bit_start;
+	u32 num_got;
+	u64 blkno;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	struct buffer_head *new_bh = NULL;
+	struct ocfs2_refcount_block *new_rb;
+	struct ocfs2_refcount_block *root_rb =
+			(struct ocfs2_refcount_block *)ref_root_bh->b_data;
+
+	ret = ocfs2_journal_access_rb(handle, ci, ref_root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_claim_metadata(OCFS2_SB(sb), handle, meta_ac, 1,
+				   &suballoc_bit_start, &num_got,
+				   &blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	new_bh = sb_getblk(sb, blkno);
+	if (new_bh == NULL) {
+		ret = -EIO;
+		mlog_errno(ret);
+		goto out;
+	}
+	ocfs2_set_new_buffer_uptodate(ci, new_bh);
+
+	ret = ocfs2_journal_access_rb(handle, ci, new_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * Initialize ocfs2_refcount_block.
+	 * It should contain the same information as the old root.
+	 * so just memcpy it and change the corresponding field.
+	 */
+	memcpy(new_bh->b_data, ref_root_bh->b_data, sb->s_blocksize);
+
+	new_rb = (struct ocfs2_refcount_block *)new_bh->b_data;
+	new_rb->rf_suballoc_slot = cpu_to_le16(OCFS2_SB(sb)->slot_num);
+	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
+	new_rb->rf_blkno = cpu_to_le64(blkno);
+	new_rb->rf_cpos = cpu_to_le32(0);
+	new_rb->rf_parent = cpu_to_le64(ref_root_bh->b_blocknr);
+	new_rb->rf_flags = cpu_to_le32(OCFS2_REFCOUNT_LEAF_FL);
+	ocfs2_journal_dirty(handle, new_bh);
+
+	/* Now change the root. */
+	memset(&root_rb->rf_list, 0, sb->s_blocksize -
+	       offsetof(struct ocfs2_refcount_block, rf_list));
+	root_rb->rf_list.l_count = cpu_to_le16(ocfs2_extent_recs_per_rb(sb));
+	root_rb->rf_clusters = cpu_to_le32(1);
+	root_rb->rf_list.l_next_free_rec = cpu_to_le16(1);
+	root_rb->rf_list.l_recs[0].e_blkno = cpu_to_le64(blkno);
+	root_rb->rf_list.l_recs[0].e_leaf_clusters = cpu_to_le16(1);
+	root_rb->rf_flags = cpu_to_le32(OCFS2_REFCOUNT_TREE_FL);
+
+	ocfs2_journal_dirty(handle, ref_root_bh);
+
+	mlog(0, "new leaf block %llu, used %u\n", (unsigned long long)blkno,
+	     le16_to_cpu(new_rb->rf_records.rl_used));
+
+	*ref_leaf_bh = new_bh;
+	new_bh = NULL;
+out:
+	brelse(new_bh);
+	return ret;
+}
+
+static int ocfs2_refcount_rec_no_intersect(struct ocfs2_refcount_rec *prev,
+					   struct ocfs2_refcount_rec *next)
+{
+	if (ocfs2_get_ref_rec_low_cpos(prev) + le32_to_cpu(prev->r_clusters) <=
+		ocfs2_get_ref_rec_low_cpos(next))
+		return 1;
+
+	return 0;
+}
+
+static int cmp_refcount_rec_by_low_cpos(const void *a, const void *b)
+{
+	const struct ocfs2_refcount_rec *l = a, *r = b;
+	u32 l_cpos = ocfs2_get_ref_rec_low_cpos(l);
+	u32 r_cpos = ocfs2_get_ref_rec_low_cpos(r);
+
+	if (l_cpos > r_cpos)
+		return 1;
+	if (l_cpos < r_cpos)
+		return -1;
+	return 0;
+}
+
+static int cmp_refcount_rec_by_cpos(const void *a, const void *b)
+{
+	const struct ocfs2_refcount_rec *l = a, *r = b;
+	u64 l_cpos = le64_to_cpu(l->r_cpos);
+	u64 r_cpos = le64_to_cpu(r->r_cpos);
+
+	if (l_cpos > r_cpos)
+		return 1;
+	if (l_cpos < r_cpos)
+		return -1;
+	return 0;
+}
+
+static void swap_refcount_rec(void *a, void *b, int size)
+{
+	struct ocfs2_refcount_rec *l = a, *r = b, tmp;
+
+	tmp = *(struct ocfs2_refcount_rec *)l;
+	*(struct ocfs2_refcount_rec *)l =
+			*(struct ocfs2_refcount_rec *)r;
+	*(struct ocfs2_refcount_rec *)r = tmp;
+}
+
+/*
+ * The refcount cpos are ordered by their 64bit cpos,
+ * But we will use the low 32 bit to be the e_cpos in the b-tree.
+ * So we need to make sure that this pos isn't intersected with others.
+ *
+ * Note: The refcount block is already sorted by their low 32 bit cpos,
+ *       So just try the middle pos first, and we will exit when we find
+ *       the good position.
+ */
+static int ocfs2_find_refcount_split_pos(struct ocfs2_refcount_list *rl,
+					 u32 *split_pos, int *split_index)
+{
+	int num_used = le16_to_cpu(rl->rl_used);
+	int delta, middle = num_used / 2;
+
+	for (delta = 0; delta < middle; delta++) {
+		/* Let's check delta earlier than middle */
+		if (ocfs2_refcount_rec_no_intersect(
+					&rl->rl_recs[middle - delta - 1],
+					&rl->rl_recs[middle - delta])) {
+			*split_index = middle - delta;
+			break;
+		}
+
+		/* For even counts, don't walk off the end */
+		if ((middle + delta + 1) == num_used)
+			continue;
+
+		/* Now try delta past middle */
+		if (ocfs2_refcount_rec_no_intersect(
+					&rl->rl_recs[middle + delta],
+					&rl->rl_recs[middle + delta + 1])) {
+			*split_index = middle + delta + 1;
+			break;
+		}
+	}
+
+	if (delta >= middle)
+		return -ENOSPC;
+
+	*split_pos = ocfs2_get_ref_rec_low_cpos(&rl->rl_recs[*split_index]);
+	return 0;
+}
+
+static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
+					    struct buffer_head *new_bh,
+					    u32 *split_cpos)
+{
+	int split_index = 0, num_moved, ret;
+	u32 cpos = 0;
+	struct ocfs2_refcount_block *rb =
+			(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+	struct ocfs2_refcount_list *rl = &rb->rf_records;
+	struct ocfs2_refcount_block *new_rb =
+			(struct ocfs2_refcount_block *)new_bh->b_data;
+	struct ocfs2_refcount_list *new_rl = &new_rb->rf_records;
+
+	mlog(0, "split old leaf refcount block %llu, count = %u, used = %u\n",
+	     (unsigned long long)ref_leaf_bh->b_blocknr,
+	     le32_to_cpu(rl->rl_count), le32_to_cpu(rl->rl_used));
+
+	/*
+	 * XXX: Improvement later.
+	 * If we know all the high 32 bit cpos is the same, no need to sort.
+	 *
+	 * In order to make the whole process safe, we do:
+	 * 1. sort the entries by their low 32 bit cpos first so that we can
+	 *    find the split cpos easily.
+	 * 2. call ocfs2_insert_extent to insert the new refcount block.
+	 * 3. move the refcount rec to the new block.
+	 * 4. sort the entries by their 64 bit cpos.
+	 * 5. dirty the new_rb and rb.
+	 */
+	sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
+	     sizeof(struct ocfs2_refcount_rec),
+	     cmp_refcount_rec_by_low_cpos, swap_refcount_rec);
+
+	ret = ocfs2_find_refcount_split_pos(rl, &cpos, &split_index);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	new_rb->rf_cpos = cpu_to_le32(cpos);
+
+	/* move refcount records starting from split_index to the new block. */
+	num_moved = le16_to_cpu(rl->rl_used) - split_index;
+	memcpy(new_rl->rl_recs, &rl->rl_recs[split_index],
+	       num_moved * sizeof(struct ocfs2_refcount_rec));
+
+	/*ok, remove the entries we just moved over to the other block. */
+	memset(&rl->rl_recs[split_index], 0,
+	       num_moved * sizeof(struct ocfs2_refcount_rec));
+
+	/* change old and new rl_used accordingly. */
+	le16_add_cpu(&rl->rl_used, -num_moved);
+	new_rl->rl_used = cpu_to_le32(num_moved);
+
+	sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
+	     sizeof(struct ocfs2_refcount_rec),
+	     cmp_refcount_rec_by_cpos, swap_refcount_rec);
+
+	sort(&new_rl->rl_recs, le16_to_cpu(new_rl->rl_used),
+	     sizeof(struct ocfs2_refcount_rec),
+	     cmp_refcount_rec_by_cpos, swap_refcount_rec);
+
+	*split_cpos = cpos;
+	return 0;
+}
+
+static int ocfs2_new_leaf_refcount_block(handle_t *handle,
+					 struct ocfs2_caching_info *ci,
+					 struct buffer_head *ref_root_bh,
+					 struct buffer_head *ref_leaf_bh,
+					 struct ocfs2_alloc_context *meta_ac)
+{
+	int ret;
+	u16 suballoc_bit_start;
+	u32 num_got, new_cpos;
+	u64 blkno;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	struct ocfs2_refcount_block *root_rb =
+			(struct ocfs2_refcount_block *)ref_root_bh->b_data;
+	struct buffer_head *new_bh = NULL;
+	struct ocfs2_refcount_block *new_rb;
+	struct ocfs2_extent_tree ref_et;
+
+	BUG_ON(!(le32_to_cpu(root_rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL));
+
+	ret = ocfs2_journal_access_rb(handle, ci, ref_root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_rb(handle, ci, ref_leaf_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_claim_metadata(OCFS2_SB(sb), handle, meta_ac, 1,
+				   &suballoc_bit_start, &num_got,
+				   &blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	new_bh = sb_getblk(sb, blkno);
+	if (new_bh == NULL) {
+		ret = -EIO;
+		mlog_errno(ret);
+		goto out;
+	}
+	ocfs2_set_new_buffer_uptodate(ci, new_bh);
+
+	ret = ocfs2_journal_access_rb(handle, ci, new_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/* Initialize ocfs2_refcount_block. */
+	new_rb = (struct ocfs2_refcount_block *)new_bh->b_data;
+	memset(new_rb, 0, sb->s_blocksize);
+	strcpy((void *)new_rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
+	new_rb->rf_suballoc_slot = cpu_to_le16(OCFS2_SB(sb)->slot_num);
+	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
+	new_rb->rf_fs_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
+	new_rb->rf_blkno = cpu_to_le64(blkno);
+	new_rb->rf_parent = cpu_to_le64(ref_root_bh->b_blocknr);
+	new_rb->rf_flags = cpu_to_le32(OCFS2_REFCOUNT_LEAF_FL);
+	new_rb->rf_records.rl_count =
+				cpu_to_le16(ocfs2_refcount_recs_per_rb(sb));
+	new_rb->rf_generation = root_rb->rf_generation;
+
+	ret = ocfs2_divide_leaf_refcount_block(ref_leaf_bh, new_bh, &new_cpos);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_journal_dirty(handle, ref_leaf_bh);
+	ocfs2_journal_dirty(handle, new_bh);
+
+	ocfs2_init_refcount_extent_tree(&ref_et, ci, ref_root_bh);
+
+	mlog(0, "insert new leaf block %llu at %u\n",
+	     (unsigned long long)new_bh->b_blocknr, new_cpos);
+
+	/* Insert the new leaf block with the specific offset cpos. */
+	ret = ocfs2_insert_extent(handle, &ref_et, new_cpos, new_bh->b_blocknr,
+				  1, 0, meta_ac);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	brelse(new_bh);
+	return ret;
+}
+
+static int ocfs2_expand_refcount_tree(handle_t *handle,
+				      struct ocfs2_caching_info *ci,
+				      struct buffer_head *ref_root_bh,
+				      struct buffer_head *ref_leaf_bh,
+				      struct ocfs2_alloc_context *meta_ac)
+{
+	int ret;
+	struct buffer_head *expand_bh = NULL;
+
+	if (ref_root_bh == ref_leaf_bh) {
+		/*
+		 * the old root bh hasn't been expanded to a b-tree,
+		 * so expand it first.
+		 */
+		ret = ocfs2_expand_inline_ref_root(handle, ci, ref_root_bh,
+						   &expand_bh, meta_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	} else {
+		expand_bh = ref_leaf_bh;
+		get_bh(expand_bh);
+	}
+
+
+	/* Now add a new refcount block into the tree.*/
+	ret = ocfs2_new_leaf_refcount_block(handle, ci, ref_root_bh,
+					    expand_bh, meta_ac);
+	if (ret)
+		mlog_errno(ret);
+out:
+	brelse(expand_bh);
+	return ret;
+}
+
+/*
+ * Adjust the extent rec in b-tree representing ref_leaf_bh.
+ *
+ * Only called when we have inserted a new refcount rec at index 0
+ * which means ocfs2_extent_rec.e_cpos may need some change.
+ */
+static int ocfs2_adjust_refcount_rec(handle_t *handle,
+				     struct ocfs2_caching_info *ci,
+				     struct buffer_head *ref_root_bh,
+				     struct buffer_head *ref_leaf_bh,
+				     struct ocfs2_refcount_rec *rec)
+{
+	int ret = 0, i;
+	u32 new_cpos, old_cpos;
+	struct ocfs2_path *path = NULL;
+	struct ocfs2_extent_tree et;
+	struct ocfs2_refcount_block *rb =
+		(struct ocfs2_refcount_block *)ref_root_bh->b_data;
+	struct ocfs2_extent_list *el;
+
+	if (!(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL))
+		goto out;
+
+	rb = (struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+	old_cpos = le32_to_cpu(rb->rf_cpos);
+	new_cpos = le64_to_cpu(rec->r_cpos) & OCFS2_32BIT_POS_MASK;
+	if (old_cpos <= new_cpos)
+		goto out;
+
+	ocfs2_init_refcount_extent_tree(&et, ci, ref_root_bh);
+
+	path = ocfs2_new_path_from_et(&et);
+	if (!path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_find_path(ci, path, old_cpos);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * 2 more credits, one for the leaf refcount block, one for
+	 * the extent block contains the extent rec.
+	 */
+	ret = ocfs2_extend_trans(handle, handle->h_buffer_credits + 2);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_rb(handle, ci, ref_leaf_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_eb(handle, ci, path_leaf_bh(path),
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/* change the leaf extent block first. */
+	el = path_leaf_el(path);
+
+	for (i = 0; i < le16_to_cpu(el->l_next_free_rec); i++)
+		if (le32_to_cpu(el->l_recs[i].e_cpos) == old_cpos)
+			break;
+
+	BUG_ON(i == le16_to_cpu(el->l_next_free_rec));
+
+	el->l_recs[i].e_cpos = cpu_to_le32(new_cpos);
+
+	/* change the r_cpos in the leaf block. */
+	rb->rf_cpos = cpu_to_le32(new_cpos);
+
+	ocfs2_journal_dirty(handle, path_leaf_bh(path));
+	ocfs2_journal_dirty(handle, ref_leaf_bh);
+
+out:
+	ocfs2_free_path(path);
+	return ret;
+}
+
+static int ocfs2_insert_refcount_rec(handle_t *handle,
+				     struct ocfs2_caching_info *ci,
+				     struct buffer_head *ref_root_bh,
+				     struct buffer_head *ref_leaf_bh,
+				     struct ocfs2_refcount_rec *rec,
+				     int index,
+				     struct ocfs2_alloc_context *meta_ac)
+{
+	int ret;
+	struct ocfs2_refcount_block *rb =
+			(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+	struct ocfs2_refcount_list *rf_list = &rb->rf_records;
+	struct buffer_head *new_bh = NULL;
+
+	BUG_ON(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL);
+
+	if (rf_list->rl_used == rf_list->rl_count) {
+		u64 cpos = le64_to_cpu(rec->r_cpos);
+		u32 len = le32_to_cpu(rec->r_clusters);
+
+		ret = ocfs2_expand_refcount_tree(handle, ci, ref_root_bh,
+						 ref_leaf_bh, meta_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_get_refcount_rec(ci, ref_root_bh,
+					     cpos, len, NULL, &index,
+					     &new_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ref_leaf_bh = new_bh;
+		rb = (struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+		rf_list = &rb->rf_records;
+	}
+
+	ret = ocfs2_journal_access_rb(handle, ci, ref_leaf_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (index < le16_to_cpu(rf_list->rl_used))
+		memmove(&rf_list->rl_recs[index + 1],
+			&rf_list->rl_recs[index],
+			(le16_to_cpu(rf_list->rl_used) - index) *
+			 sizeof(struct ocfs2_refcount_rec));
+
+	mlog(0, "insert refcount record start %llu, len %u, count %u "
+	     "to leaf block %llu at index %d\n",
+	     (unsigned long long)le64_to_cpu(rec->r_cpos),
+	     le32_to_cpu(rec->r_clusters), le32_to_cpu(rec->r_refcount),
+	     (unsigned long long)ref_leaf_bh->b_blocknr, index);
+
+	rf_list->rl_recs[index] = *rec;
+
+	le16_add_cpu(&rf_list->rl_used, 1);
+
+	ocfs2_refcount_rec_merge(rb, index);
+
+	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (index == 0) {
+		ret = ocfs2_adjust_refcount_rec(handle, ci,
+						ref_root_bh,
+						ref_leaf_bh, rec);
+		if (ret)
+			mlog_errno(ret);
+	}
+out:
+	brelse(new_bh);
+	return ret;
+}
+
+/*
+ * Split the refcount_rec indexed by "index" in ref_leaf_bh.
+ * This is much simple than our b-tree code.
+ * split_rec is the new refcount rec we want to insert.
+ * If split_rec->r_refcount > 0, we are changing the refcount(in case we
+ * increase refcount or decrease a refcount to non-zero).
+ * If split_rec->r_refcount == 0, we are punching a hole in current refcount
+ * rec( in case we decrease a refcount to zero).
+ */
+static int ocfs2_split_refcount_rec(handle_t *handle,
+				    struct ocfs2_caching_info *ci,
+				    struct buffer_head *ref_root_bh,
+				    struct buffer_head *ref_leaf_bh,
+				    struct ocfs2_refcount_rec *split_rec,
+				    int index,
+				    struct ocfs2_alloc_context *meta_ac,
+				    struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret, recs_need;
+	u32 len;
+	struct ocfs2_refcount_block *rb =
+			(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+	struct ocfs2_refcount_list *rf_list = &rb->rf_records;
+	struct ocfs2_refcount_rec *orig_rec = &rf_list->rl_recs[index];
+	struct ocfs2_refcount_rec *tail_rec = NULL;
+	struct buffer_head *new_bh = NULL;
+
+	BUG_ON(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL);
+
+	mlog(0, "original r_pos %llu, cluster %u, split %llu, cluster %u\n",
+	     le64_to_cpu(orig_rec->r_cpos), le32_to_cpu(orig_rec->r_clusters),
+	     le64_to_cpu(split_rec->r_cpos),
+	     le32_to_cpu(split_rec->r_clusters));
+
+	/*
+	 * If we just need to split the header or tail clusters,
+	 * no more recs are needed, just split is OK.
+	 * Otherwise we at least need one new recs.
+	 */
+	if (!split_rec->r_refcount &&
+	    (split_rec->r_cpos == orig_rec->r_cpos ||
+	     le64_to_cpu(split_rec->r_cpos) +
+	     le32_to_cpu(split_rec->r_clusters) ==
+	     le64_to_cpu(orig_rec->r_cpos) + le32_to_cpu(orig_rec->r_clusters)))
+		recs_need = 0;
+	else
+		recs_need = 1;
+
+	/*
+	 * We need one more rec if we split in the middle and the new rec have
+	 * some refcount in it.
+	 */
+	if (split_rec->r_refcount &&
+	    (split_rec->r_cpos != orig_rec->r_cpos &&
+	     le64_to_cpu(split_rec->r_cpos) +
+	     le32_to_cpu(split_rec->r_clusters) !=
+	     le64_to_cpu(orig_rec->r_cpos) + le32_to_cpu(orig_rec->r_clusters)))
+		recs_need++;
+
+	/* If the leaf block don't have enough record, expand it. */
+	if (le16_to_cpu(rf_list->rl_used) + recs_need > rf_list->rl_count) {
+		struct ocfs2_refcount_rec tmp_rec;
+		u64 cpos = le64_to_cpu(orig_rec->r_cpos);
+		len = le32_to_cpu(orig_rec->r_clusters);
+		ret = ocfs2_expand_refcount_tree(handle, ci, ref_root_bh,
+						 ref_leaf_bh, meta_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/*
+		 * We have to re-get it since now cpos may be moved to
+		 * another leaf block.
+		 */
+		ret = ocfs2_get_refcount_rec(ci, ref_root_bh,
+					     cpos, len, &tmp_rec, &index,
+					     &new_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ref_leaf_bh = new_bh;
+		rb = (struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+		rf_list = &rb->rf_records;
+		orig_rec = &rf_list->rl_recs[index];
+	}
+
+	ret = ocfs2_journal_access_rb(handle, ci, ref_leaf_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * We have calculated out how many new records we need and store
+	 * in recs_need, so spare enough space first by moving the records
+	 * after "index" to the end.
+	 */
+	if (index != le16_to_cpu(rf_list->rl_used) - 1)
+		memmove(&rf_list->rl_recs[index + 1 + recs_need],
+			&rf_list->rl_recs[index + 1],
+			(le16_to_cpu(rf_list->rl_used) - index - 1) *
+			 sizeof(struct ocfs2_refcount_rec));
+
+	len = (le64_to_cpu(orig_rec->r_cpos) +
+	      le32_to_cpu(orig_rec->r_clusters)) -
+	      (le64_to_cpu(split_rec->r_cpos) +
+	      le32_to_cpu(split_rec->r_clusters));
+
+	/*
+	 * If we have "len", the we will split in the tail and move it
+	 * to the end of the space we have just spared.
+	 */
+	if (len) {
+		tail_rec = &rf_list->rl_recs[index + recs_need];
+
+		memcpy(tail_rec, orig_rec, sizeof(struct ocfs2_refcount_rec));
+		le64_add_cpu(&tail_rec->r_cpos,
+			     le32_to_cpu(tail_rec->r_clusters) - len);
+		tail_rec->r_clusters = le32_to_cpu(len);
+	}
+
+	/*
+	 * If the split pos isn't the same as the original one, we need to
+	 * split in the head.
+	 *
+	 * Note: We have the chance that split_rec.r_refcount = 0,
+	 * recs_need = 0 and len > 0, which means we just cut the head from
+	 * the orig_rec and in that case we have done some modification in
+	 * orig_rec above, so the check for r_cpos is faked.
+	 */
+	if (split_rec->r_cpos != orig_rec->r_cpos && tail_rec != orig_rec) {
+		len = le64_to_cpu(split_rec->r_cpos) -
+		      le64_to_cpu(orig_rec->r_cpos);
+		orig_rec->r_clusters = cpu_to_le32(len);
+		index++;
+	}
+
+	le16_add_cpu(&rf_list->rl_used, recs_need);
+
+	if (split_rec->r_refcount) {
+		rf_list->rl_recs[index] = *split_rec;
+		mlog(0, "insert refcount record start %llu, len %u, count %u "
+		     "to leaf block %llu at index %d\n",
+		     (unsigned long long)le64_to_cpu(split_rec->r_cpos),
+		     le32_to_cpu(split_rec->r_clusters),
+		     le32_to_cpu(split_rec->r_refcount),
+		     (unsigned long long)ref_leaf_bh->b_blocknr, index);
+
+		ocfs2_refcount_rec_merge(rb, index);
+	}
+
+	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	brelse(new_bh);
+	return ret;
+}
+
+static int __ocfs2_increase_refcount(handle_t *handle,
+				     struct ocfs2_caching_info *ci,
+				     struct buffer_head *ref_root_bh,
+				     u64 cpos, u32 len,
+				     struct ocfs2_alloc_context *meta_ac,
+				     struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret = 0, index;
+	struct buffer_head *ref_leaf_bh = NULL;
+	struct ocfs2_refcount_rec rec;
+	unsigned int set_len = 0;
+
+	mlog(0, "Tree owner %llu, add refcount start %llu, len %u\n",
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
+		set_len = le32_to_cpu(rec.r_clusters);
+
+		/*
+		 * Here we may meet with 3 situations:
+		 *
+		 * 1. If we find an already existing record, and the length
+		 *    is the same, cool, we just need to increase the r_refcount
+		 *    and it is OK.
+		 * 2. If we find a hole, just insert it with r_refcount = 1.
+		 * 3. If we are in the middle of one extent record, split
+		 *    it.
+		 */
+		if (rec.r_refcount && le64_to_cpu(rec.r_cpos) == cpos &&
+		    set_len <= len) {
+			mlog(0, "increase refcount rec, start %llu, len %u, "
+			     "count %u\n", (unsigned long long)cpos, set_len,
+			     le32_to_cpu(rec.r_refcount));
+			ret = ocfs2_change_refcount_rec(handle, ci,
+							ref_leaf_bh, index, 1);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		} else if (!rec.r_refcount) {
+			rec.r_refcount = cpu_to_le32(1);
+
+			mlog(0, "insert refcount rec, start %llu, len %u\n",
+			     (unsigned long long)le64_to_cpu(rec.r_cpos),
+			     set_len);
+			ret = ocfs2_insert_refcount_rec(handle, ci, ref_root_bh,
+							ref_leaf_bh,
+							&rec, index, meta_ac);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		} else  {
+			set_len = min((u64)(cpos + len),
+				      le64_to_cpu(rec.r_cpos) + set_len) - cpos;
+			rec.r_cpos = cpu_to_le64(cpos);
+			rec.r_clusters = cpu_to_le32(set_len);
+			le32_add_cpu(&rec.r_refcount, 1);
+
+			mlog(0, "split refcount rec, start %llu, "
+			     "len %u, count %u\n",
+			     (unsigned long long)le64_to_cpu(rec.r_cpos),
+			     set_len, le32_to_cpu(rec.r_refcount));
+			ret = ocfs2_split_refcount_rec(handle, ci,
+						       ref_root_bh, ref_leaf_bh,
+						       &rec, index,
+						       meta_ac, dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		}
+
+		cpos += set_len;
+		len -= set_len;
+		brelse(ref_leaf_bh);
+		ref_leaf_bh = NULL;
+	}
+
+out:
+	brelse(ref_leaf_bh);
+	return ret;
+}
-- 
1.6.2.rc2.16.gf474c
