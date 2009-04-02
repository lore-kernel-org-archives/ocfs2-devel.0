From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:52 +0800
Subject: [Ocfs2-devel] [PATCH 13/42] ocfs2: Add support for incrementing
	refcount in the tree.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-13-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/extent_map.c   |   15 ++--
 fs/ocfs2/extent_map.h   |    5 +
 fs/ocfs2/refcounttree.c |  195 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+), 7 deletions(-)

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
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index ced1050..3b6f327 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -29,6 +29,7 @@
 #include "refcounttree.h"
 #include "sysfile.h"
 #include "dlmglue.h"
+#include "extent_map.h"
 
 static int ocfs2_validate_refcount_block(struct super_block *sb,
 					 struct buffer_head *bh)
@@ -368,3 +369,197 @@ out:
 
 	return ret;
 }
+
+/*
+ * Given a cpos and len, try to find the refcount record which contains cpos.
+ * 1. If cpos can be found in one refcount record, return the record.
+ * 2. If cpos can't be found, return a fake record which start from cpos
+ *    and end at a small value between cpos+len and start of the next record.
+ *    This fake record has r_count = 0.
+ */
+static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
+				  struct ocfs2_path *path,
+				  u32 cpos, unsigned int len,
+				  struct ocfs2_extent_rec *ret_rec,
+				  int *index)
+{
+	u32 hole_len;
+	int i, ret = 0;
+	struct ocfs2_extent_list *el;
+	struct ocfs2_extent_rec *rec;
+	struct buffer_head *eb_bh = NULL;
+
+	memset(ret_rec, 0, sizeof(*ret_rec));
+
+	ret = ocfs2_find_path(ci, path, cpos);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	el = path_leaf_el(path);
+
+	for (i = 0; i < le16_to_cpu(el->l_next_free_rec); i++) {
+		rec = &el->l_recs[i];
+
+		if (ocfs2_is_empty_extent(rec)) {
+			mlog_bug_on_msg(i != 0, "Refcount tree %llu "
+					"has empty record in "
+					"block %llu, index %d\n",
+					(unsigned long long)
+					ocfs2_metadata_cache_owner(ci),
+					(unsigned long long)
+					path_leaf_bh(path)->b_blocknr, i);
+			continue;
+		}
+
+		if (le32_to_cpu(rec->e_cpos) +
+		    le16_to_cpu(rec->e_leaf_clusters) <= cpos)
+			continue;
+		else if (le32_to_cpu(rec->e_cpos) > cpos)
+			break;
+
+		/* ok, cpos fail in this rec. Just return. */
+		*ret_rec = *rec;
+		*index = i;
+		goto out;
+	}
+
+	/* We meet with a hole here. */
+	if (path->p_tree_depth)
+		eb_bh = path_leaf_bh(path);
+	ret = ocfs2_figure_hole_clusters(ci, el, eb_bh, cpos, &hole_len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (hole_len > UINT_MAX)
+		hole_len = UINT_MAX;
+	else if (hole_len > len)
+		hole_len = len;
+
+	ret_rec->e_cpos = cpu_to_le32(cpos);
+	ret_rec->e_leaf_clusters = cpu_to_le16(hole_len);
+	ret_rec->e_refcount = 0;
+
+out:
+	return ret;
+}
+
+static int ocfs2_incre_refcount_rec(handle_t *handle,
+				    struct ocfs2_caching_info *ci,
+				    struct ocfs2_path *path, int index)
+{
+	int ret;
+	struct ocfs2_extent_list *el = path_leaf_el(path);
+	struct ocfs2_extent_rec *rec = &el->l_recs[index];
+
+	ret = ocfs2_path_bh_journal_access(handle, ci, path,
+					   path_num_items(path) - 1);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	le32_add_cpu(&rec->e_refcount, 1);
+
+	ret = ocfs2_journal_dirty(handle, path_leaf_bh(path));
+	if (ret)
+		mlog_errno(ret);
+out:
+	return ret;
+}
+
+static int __ocfs2_increase_refcount(handle_t *handle,
+				     struct ocfs2_extent_tree *et,
+				     u32 cpos, u32 len,
+				     struct ocfs2_alloc_context *meta_ac,
+				     struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret = 0, index;
+	struct ocfs2_extent_rec rec;
+	unsigned int set_len = 0;
+	struct ocfs2_path *path = NULL;
+
+	path = ocfs2_new_path_from_et(et);
+	if (!path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "Tree owner %llu, add refcount start %u, len %u\n",
+	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+	     cpos, len);
+
+	while (len) {
+		ret = ocfs2_get_refcount_rec(et->et_ci, path, cpos, len,
+					     &rec, &index);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		set_len = le16_to_cpu(rec.e_leaf_clusters);
+
+		/*
+		 * Here we may meet with 3 situations:
+		 *
+		 * 1. If we find an already existing record, and the length
+		 *    is the same, cool, we just need to increase the r_count
+		 *    and it is OK.
+		 * 2. If we find a hole, just insert it with r_count = 1.
+		 * 3. If we are in the middle of one extent record, split
+		 *    it.
+		 */
+		if (rec.e_refcount && le32_to_cpu(rec.e_cpos) == cpos &&
+		    set_len <= len) {
+			mlog(0, "increase refcount rec, start %u, len %u, "
+			     "count %u\n", cpos, set_len,
+			     le32_to_cpu(rec.e_refcount));
+			ret = ocfs2_incre_refcount_rec(handle, et->et_ci,
+						       path, index);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		} else if (!rec.e_refcount) {
+			rec.e_refcount = cpu_to_le32(1);
+			rec.e_flags = OCFS2_EXT_REFCOUNT_RECORD;
+
+			mlog(0, "insert refcount rec, start %u, len %u\n",
+			     le32_to_cpu(rec.e_cpos), set_len);
+			ret = ocfs2_insert_extent(handle, et, &rec, meta_ac);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		} else  {
+			set_len = min((u32)(cpos + len),
+				      le32_to_cpu(rec.e_cpos) + set_len) - cpos;
+			rec.e_cpos = cpu_to_le32(cpos);
+			rec.e_leaf_clusters = cpu_to_le16(set_len);
+			le32_add_cpu(&rec.e_refcount, 1);
+
+			mlog(0, "split efcount rec, start %u, len %u, "
+			     "count %u\n", le32_to_cpu(rec.e_cpos),
+			     set_len, le32_to_cpu(rec.e_refcount));
+			ret = ocfs2_split_extent(handle, et,
+						 path, index,
+						 &rec, meta_ac, dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		}
+
+		cpos += set_len;
+		len -= set_len;
+		ocfs2_reinit_path(path, 1);
+	}
+
+out:
+	ocfs2_free_path(path);
+	return ret;
+}
-- 
1.6.2.rc2.16.gf474c
