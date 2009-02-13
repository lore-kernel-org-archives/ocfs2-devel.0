From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:56 -0800
Subject: [Ocfs2-devel] [PATCH 09/40] ocfs2: ocfs2_find_path() only needs the
	caching info
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-10-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_find_path and ocfs2_find_leaf() walk our btrees, reading extent
blocks.  They need struct ocfs2_caching_info for that, but not struct
inode.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c      |   73 +++++++++++++++++++++++++-----------------------
 fs/ocfs2/alloc.h      |    5 ++-
 fs/ocfs2/extent_map.c |    6 +++-
 fs/ocfs2/xattr.c      |    3 +-
 4 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 787f35a..40fa2d9 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1598,7 +1598,7 @@ typedef void (path_insert_t)(void *, struct buffer_head *);
  * This code can be called with a cpos larger than the tree, in which
  * case it will return the rightmost path.
  */
-static int __ocfs2_find_path(struct inode *inode,
+static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 			     struct ocfs2_extent_list *root_el, u32 cpos,
 			     path_insert_t *func, void *data)
 {
@@ -1609,15 +1609,14 @@ static int __ocfs2_find_path(struct inode *inode,
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_rec *rec;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	el = root_el;
 	while (el->l_tree_depth) {
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
-			ocfs2_error(inode->i_sb,
-				    "Inode %llu has empty extent list at "
+			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
+				    "Owner %llu has empty extent list at "
 				    "depth %u\n",
-				    (unsigned long long)oi->ip_blkno,
+				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
 				    le16_to_cpu(el->l_tree_depth));
 			ret = -EROFS;
 			goto out;
@@ -1640,10 +1639,10 @@ static int __ocfs2_find_path(struct inode *inode,
 
 		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
 		if (blkno == 0) {
-			ocfs2_error(inode->i_sb,
-				    "Inode %llu has bad blkno in extent list "
+			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
+				    "Owner %llu has bad blkno in extent list "
 				    "at depth %u (index %d)\n",
-				    (unsigned long long)oi->ip_blkno,
+				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
 				    le16_to_cpu(el->l_tree_depth), i);
 			ret = -EROFS;
 			goto out;
@@ -1651,7 +1650,7 @@ static int __ocfs2_find_path(struct inode *inode,
 
 		brelse(bh);
 		bh = NULL;
-		ret = ocfs2_read_extent_block(INODE_CACHE(inode), blkno, &bh);
+		ret = ocfs2_read_extent_block(ci, blkno, &bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -1662,10 +1661,10 @@ static int __ocfs2_find_path(struct inode *inode,
 
 		if (le16_to_cpu(el->l_next_free_rec) >
 		    le16_to_cpu(el->l_count)) {
-			ocfs2_error(inode->i_sb,
-				    "Inode %llu has bad count in extent list "
+			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
+				    "Owner %llu has bad count in extent list "
 				    "at block %llu (next free=%u, count=%u)\n",
-				    (unsigned long long)oi->ip_blkno,
+				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
 				    (unsigned long long)bh->b_blocknr,
 				    le16_to_cpu(el->l_next_free_rec),
 				    le16_to_cpu(el->l_count));
@@ -1709,14 +1708,14 @@ static void find_path_ins(void *data, struct buffer_head *bh)
 	ocfs2_path_insert_eb(fp->path, fp->index, bh);
 	fp->index++;
 }
-static int ocfs2_find_path(struct inode *inode, struct ocfs2_path *path,
-			   u32 cpos)
+static int ocfs2_find_path(struct ocfs2_caching_info *ci,
+			   struct ocfs2_path *path, u32 cpos)
 {
 	struct find_path_data data;
 
 	data.index = 1;
 	data.path = path;
-	return __ocfs2_find_path(inode, path_root_el(path), cpos,
+	return __ocfs2_find_path(ci, path_root_el(path), cpos,
 				 find_path_ins, &data);
 }
 
@@ -1741,13 +1740,14 @@ static void find_leaf_ins(void *data, struct buffer_head *bh)
  *
  * This function doesn't handle non btree extent lists.
  */
-int ocfs2_find_leaf(struct inode *inode, struct ocfs2_extent_list *root_el,
-		    u32 cpos, struct buffer_head **leaf_bh)
+int ocfs2_find_leaf(struct ocfs2_caching_info *ci,
+		    struct ocfs2_extent_list *root_el, u32 cpos,
+		    struct buffer_head **leaf_bh)
 {
 	int ret;
 	struct buffer_head *bh = NULL;
 
-	ret = __ocfs2_find_path(inode, root_el, cpos, find_leaf_ins, &bh);
+	ret = __ocfs2_find_path(ci, root_el, cpos, find_leaf_ins, &bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2251,7 +2251,7 @@ static int ocfs2_rotate_tree_right(struct inode *inode,
 		mlog(0, "Rotating a tree: ins. cpos: %u, left path cpos: %u\n",
 		     insert_cpos, cpos);
 
-		ret = ocfs2_find_path(inode, left_path, cpos);
+		ret = ocfs2_find_path(INODE_CACHE(inode), left_path, cpos);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2763,7 +2763,7 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 	}
 
 	while (right_cpos) {
-		ret = ocfs2_find_path(inode, right_path, right_cpos);
+		ret = ocfs2_find_path(et->et_ci, right_path, right_cpos);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2892,7 +2892,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 			goto out;
 		}
 
-		ret = ocfs2_find_path(inode, left_path, cpos);
+		ret = ocfs2_find_path(et->et_ci, left_path, cpos);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3132,7 +3132,7 @@ static int ocfs2_get_right_path(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_find_path(inode, right_path, right_cpos);
+	ret = ocfs2_find_path(INODE_CACHE(inode), right_path, right_cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3301,7 +3301,7 @@ static int ocfs2_get_left_path(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_find_path(inode, left_path, left_cpos);
+	ret = ocfs2_find_path(INODE_CACHE(inode), left_path, left_cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3831,7 +3831,8 @@ static int ocfs2_append_rec_to_path(struct inode *inode, handle_t *handle,
 				goto out;
 			}
 
-			ret = ocfs2_find_path(inode, left_path, left_cpos);
+			ret = ocfs2_find_path(INODE_CACHE(inode), left_path,
+					      left_cpos);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -4080,7 +4081,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		cpos = UINT_MAX;
 	}
 
-	ret = ocfs2_find_path(inode, right_path, cpos);
+	ret = ocfs2_find_path(et->et_ci, right_path, cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4177,7 +4178,8 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			if (!left_path)
 				goto out;
 
-			status = ocfs2_find_path(inode, left_path, left_cpos);
+			status = ocfs2_find_path(INODE_CACHE(inode),
+						 left_path, left_cpos);
 			if (status)
 				goto out;
 
@@ -4233,7 +4235,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 		if (!right_path)
 			goto out;
 
-		status = ocfs2_find_path(inode, right_path, right_cpos);
+		status = ocfs2_find_path(INODE_CACHE(inode), right_path, right_cpos);
 		if (status)
 			goto out;
 
@@ -4435,7 +4437,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 	 * us the rightmost tree path. This is accounted for below in
 	 * the appending code.
 	 */
-	ret = ocfs2_find_path(inode, path, le32_to_cpu(insert_rec->e_cpos));
+	ret = ocfs2_find_path(et->et_ci, path, le32_to_cpu(insert_rec->e_cpos));
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4785,7 +4787,7 @@ leftright:
 		ocfs2_reinit_path(path, 1);
 
 		cpos = le32_to_cpu(split_rec.e_cpos);
-		ret = ocfs2_find_path(inode, path, cpos);
+		ret = ocfs2_find_path(et->et_ci, path, cpos);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4958,7 +4960,7 @@ int ocfs2_mark_extent_written(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_find_path(inode, left_path, cpos);
+	ret = ocfs2_find_path(et->et_ci, left_path, cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -5130,7 +5132,8 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 				goto out;
 			}
 
-			ret = ocfs2_find_path(inode, left_path, left_cpos);
+			ret = ocfs2_find_path(et->et_ci, left_path,
+					      left_cpos);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -5239,7 +5242,7 @@ int ocfs2_remove_extent(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_find_path(inode, path, cpos);
+	ret = ocfs2_find_path(et->et_ci, path, cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -5304,7 +5307,7 @@ int ocfs2_remove_extent(struct inode *inode,
 		 */
 		ocfs2_reinit_path(path, 1);
 
-		ret = ocfs2_find_path(inode, path, cpos);
+		ret = ocfs2_find_path(et->et_ci, path, cpos);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -6332,7 +6335,7 @@ static int ocfs2_find_new_last_ext_blk(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_find_leaf(inode, path_root_el(path), cpos, &bh);
+	ret = ocfs2_find_leaf(INODE_CACHE(inode), path_root_el(path), cpos, &bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -7109,7 +7112,7 @@ start:
 	/*
 	 * Truncate always works against the rightmost tree branch.
 	 */
-	status = ocfs2_find_path(inode, path, UINT_MAX);
+	status = ocfs2_find_path(INODE_CACHE(inode), path, UINT_MAX);
 	if (status) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index cc45d12..480e332 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -220,8 +220,9 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 			  unsigned int start, unsigned int end, int trunc);
 
-int ocfs2_find_leaf(struct inode *inode, struct ocfs2_extent_list *root_el,
-		    u32 cpos, struct buffer_head **leaf_bh);
+int ocfs2_find_leaf(struct ocfs2_caching_info *ci,
+		    struct ocfs2_extent_list *root_el, u32 cpos,
+		    struct buffer_head **leaf_bh);
 int ocfs2_search_extent_list(struct ocfs2_extent_list *el, u32 v_cluster);
 
 /*
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index a5dc13e..dc9482c 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -428,7 +428,8 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 	tree_height = le16_to_cpu(el->l_tree_depth);
 
 	if (tree_height > 0) {
-		ret = ocfs2_find_leaf(inode, el, v_cluster, &eb_bh);
+		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, v_cluster,
+				      &eb_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -548,7 +549,8 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 	u32 coff;
 
 	if (el->l_tree_depth) {
-		ret = ocfs2_find_leaf(inode, el, v_cluster, &eb_bh);
+		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, v_cluster,
+				      &eb_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 86ed848..d65742e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2848,7 +2848,8 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 	u64 e_blkno = 0;
 
 	if (el->l_tree_depth) {
-		ret = ocfs2_find_leaf(inode, el, name_hash, &eb_bh);
+		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, name_hash,
+				      &eb_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
-- 
1.5.6.5
