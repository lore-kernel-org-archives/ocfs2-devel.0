From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:53 -0800
Subject: [Ocfs2-devel] [PATCH 06/40] ocfs2: Pass struct ocfs2_caching_info
	to the journal functions.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-7-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The next step in divorcing metadata I/O management from struct inode is
to pass struct ocfs2_caching_info to the journal functions.  Thus the
journal locks a metadata cache with the cache io_lock function.  It also
can compare ci_last_trans and ci_created_trans directly.

This is a large patch because of all the places we change
ocfs2_journal_access..(handle, inode, ...) to
ocfs2_journal_access..(handle, INODE_CACHE(inode), ...).

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c        |   97 ++++++++++++++++++++++++-----------------------
 fs/ocfs2/aops.c         |    4 +-
 fs/ocfs2/dir.c          |   21 ++++++----
 fs/ocfs2/dlmglue.c      |    2 +-
 fs/ocfs2/file.c         |    8 ++--
 fs/ocfs2/inode.c        |    7 ++-
 fs/ocfs2/journal.c      |   49 ++++++++++++-----------
 fs/ocfs2/journal.h      |   71 +++++++++++++++++++---------------
 fs/ocfs2/localalloc.c   |   10 +++--
 fs/ocfs2/namei.c        |   32 ++++++++++-----
 fs/ocfs2/ocfs2.h        |    8 +++-
 fs/ocfs2/quota_global.c |    3 +-
 fs/ocfs2/quota_local.c  |   16 +++++---
 fs/ocfs2/resize.c       |   14 +++---
 fs/ocfs2/suballoc.c     |   29 +++++++-------
 fs/ocfs2/uptodate.h     |    1 -
 fs/ocfs2/xattr.c        |   34 +++++++++-------
 17 files changed, 225 insertions(+), 181 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 2ce2158..84ecf90 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -357,11 +357,11 @@ static inline void ocfs2_et_update_clusters(struct inode *inode,
 }
 
 static inline int ocfs2_et_root_journal_access(handle_t *handle,
-					       struct inode *inode,
+					       struct ocfs2_caching_info *ci,
 					       struct ocfs2_extent_tree *et,
 					       int type)
 {
-	return et->et_root_journal_access(handle, inode, et->et_root_bh,
+	return et->et_root_journal_access(handle, ci, et->et_root_bh,
 					  type);
 }
 
@@ -569,7 +569,7 @@ static struct ocfs2_path *ocfs2_new_path_from_et(struct ocfs2_extent_tree *et)
  * ocfs2_journal_access_path(), but I don't have a better one.
  */
 static int ocfs2_path_bh_journal_access(handle_t *handle,
-					struct inode *inode,
+					struct ocfs2_caching_info *ci,
 					struct ocfs2_path *path,
 					int idx)
 {
@@ -581,14 +581,15 @@ static int ocfs2_path_bh_journal_access(handle_t *handle,
 	if (idx)
 		access = ocfs2_journal_access_eb;
 
-	return access(handle, inode, path->p_node[idx].bh,
+	return access(handle, ci, path->p_node[idx].bh,
 		      OCFS2_JOURNAL_ACCESS_WRITE);
 }
 
 /*
  * Convenience function to journal all components in a path.
  */
-static int ocfs2_journal_access_path(struct inode *inode, handle_t *handle,
+static int ocfs2_journal_access_path(struct ocfs2_caching_info *ci,
+				     handle_t *handle,
 				     struct ocfs2_path *path)
 {
 	int i, ret = 0;
@@ -597,7 +598,7 @@ static int ocfs2_journal_access_path(struct inode *inode, handle_t *handle,
 		goto out;
 
 	for(i = 0; i < path_num_items(path); i++) {
-		ret = ocfs2_path_bh_journal_access(handle, inode, path, i);
+		ret = ocfs2_path_bh_journal_access(handle, ci, path, i);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -888,7 +889,7 @@ static int ocfs2_create_new_meta_bhs(struct ocfs2_super *osb,
 			ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode),
 						      bhs[i]);
 
-			status = ocfs2_journal_access_eb(handle, inode, bhs[i],
+			status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), bhs[i],
 							 OCFS2_JOURNAL_ACCESS_CREATE);
 			if (status < 0) {
 				mlog_errno(status);
@@ -1032,7 +1033,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 		BUG_ON(!OCFS2_IS_VALID_EXTENT_BLOCK(eb));
 		eb_el = &eb->h_list;
 
-		status = ocfs2_journal_access_eb(handle, inode, bh,
+		status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), bh,
 						 OCFS2_JOURNAL_ACCESS_CREATE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1072,20 +1073,20 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 	 * journal_dirty erroring as it won't unless we've aborted the
 	 * handle (in which case we would never be here) so reserving
 	 * the write with journal_access is all we need to do. */
-	status = ocfs2_journal_access_eb(handle, inode, *last_eb_bh,
+	status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), *last_eb_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
-	status = ocfs2_et_root_journal_access(handle, inode, et,
+	status = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 	if (eb_bh) {
-		status = ocfs2_journal_access_eb(handle, inode, eb_bh,
+		status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), eb_bh,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1175,7 +1176,7 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 	eb_el = &eb->h_list;
 	root_el = et->et_root_el;
 
-	status = ocfs2_journal_access_eb(handle, inode, new_eb_bh,
+	status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), new_eb_bh,
 					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1194,7 +1195,7 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_et_root_journal_access(handle, inode, et,
+	status = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1964,7 +1965,7 @@ static int ocfs2_rotate_subtree_right(struct inode *inode,
 	root_bh = left_path->p_node[subtree_index].bh;
 	BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
 
-	ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
 					   subtree_index);
 	if (ret) {
 		mlog_errno(ret);
@@ -1972,14 +1973,14 @@ static int ocfs2_rotate_subtree_right(struct inode *inode,
 	}
 
 	for(i = subtree_index + 1; i < path_num_items(right_path); i++) {
-		ret = ocfs2_path_bh_journal_access(handle, inode,
+		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
 						   right_path, i);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 
-		ret = ocfs2_path_bh_journal_access(handle, inode,
+		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
 						   left_path, i);
 		if (ret) {
 			mlog_errno(ret);
@@ -2499,7 +2500,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 			return -EAGAIN;
 
 		if (le16_to_cpu(right_leaf_el->l_next_free_rec) > 1) {
-			ret = ocfs2_journal_access_eb(handle, inode,
+			ret = ocfs2_journal_access_eb(handle, INODE_CACHE(inode),
 						      path_leaf_bh(right_path),
 						      OCFS2_JOURNAL_ACCESS_WRITE);
 			if (ret) {
@@ -2518,7 +2519,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 		 * We have to update i_last_eb_blk during the meta
 		 * data delete.
 		 */
-		ret = ocfs2_et_root_journal_access(handle, inode, et,
+		ret = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
 						   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
@@ -2534,7 +2535,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 	 */
 	BUG_ON(right_has_empty && !del_right_subtree);
 
-	ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
 					   subtree_index);
 	if (ret) {
 		mlog_errno(ret);
@@ -2542,14 +2543,14 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 	}
 
 	for(i = subtree_index + 1; i < path_num_items(right_path); i++) {
-		ret = ocfs2_path_bh_journal_access(handle, inode,
+		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
 						   right_path, i);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 
-		ret = ocfs2_path_bh_journal_access(handle, inode,
+		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
 						   left_path, i);
 		if (ret) {
 			mlog_errno(ret);
@@ -2704,7 +2705,7 @@ static int ocfs2_rotate_rightmost_leaf_left(struct inode *inode,
 	if (!ocfs2_is_empty_extent(&el->l_recs[0]))
 		return 0;
 
-	ret = ocfs2_path_bh_journal_access(handle, inode, path,
+	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), path,
 					   path_num_items(path) - 1);
 	if (ret) {
 		mlog_errno(ret);
@@ -2787,7 +2788,7 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 		 * Caller might still want to make changes to the
 		 * tree root, so re-add it to the journal here.
 		 */
-		ret = ocfs2_path_bh_journal_access(handle, inode,
+		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
 						   left_path, 0);
 		if (ret) {
 			mlog_errno(ret);
@@ -2865,7 +2866,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_path(inode, handle, path);
+	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, path);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2895,7 +2896,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 			goto out;
 		}
 
-		ret = ocfs2_journal_access_path(inode, handle, left_path);
+		ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, left_path);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3205,7 +3206,7 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 		root_bh = left_path->p_node[subtree_index].bh;
 		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
 
-		ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
 						   subtree_index);
 		if (ret) {
 			mlog_errno(ret);
@@ -3214,14 +3215,14 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 
 		for (i = subtree_index + 1;
 		     i < path_num_items(right_path); i++) {
-			ret = ocfs2_path_bh_journal_access(handle, inode,
+			ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
 							   right_path, i);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
 			}
 
-			ret = ocfs2_path_bh_journal_access(handle, inode,
+			ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
 							   left_path, i);
 			if (ret) {
 				mlog_errno(ret);
@@ -3234,7 +3235,7 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 		right_rec = &el->l_recs[index + 1];
 	}
 
-	ret = ocfs2_path_bh_journal_access(handle, inode, left_path,
+	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), left_path,
 					   path_num_items(left_path) - 1);
 	if (ret) {
 		mlog_errno(ret);
@@ -3374,7 +3375,7 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 		root_bh = left_path->p_node[subtree_index].bh;
 		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
 
-		ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
 						   subtree_index);
 		if (ret) {
 			mlog_errno(ret);
@@ -3383,14 +3384,14 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 
 		for (i = subtree_index + 1;
 		     i < path_num_items(right_path); i++) {
-			ret = ocfs2_path_bh_journal_access(handle, inode,
+			ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
 							   right_path, i);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
 			}
 
-			ret = ocfs2_path_bh_journal_access(handle, inode,
+			ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
 							   left_path, i);
 			if (ret) {
 				mlog_errno(ret);
@@ -3403,7 +3404,7 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 			has_empty_extent = 1;
 	}
 
-	ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
 					   path_num_items(right_path) - 1);
 	if (ret) {
 		mlog_errno(ret);
@@ -3841,7 +3842,7 @@ static int ocfs2_append_rec_to_path(struct inode *inode, handle_t *handle,
 		}
 	}
 
-	ret = ocfs2_journal_access_path(inode, handle, right_path);
+	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, right_path);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3970,7 +3971,7 @@ static int ocfs2_insert_path(struct inode *inode,
 			goto out;
 		}
 
-		ret = ocfs2_journal_access_path(inode, handle, left_path);
+		ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, left_path);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -3981,7 +3982,7 @@ static int ocfs2_insert_path(struct inode *inode,
 	 * Pass both paths to the journal. The majority of inserts
 	 * will be touching all components anyway.
 	 */
-	ret = ocfs2_journal_access_path(inode, handle, right_path);
+	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, right_path);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -4046,7 +4047,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 
 	el = et->et_root_el;
 
-	ret = ocfs2_et_root_journal_access(handle, inode, et,
+	ret = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -4108,7 +4109,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		 * ocfs2_rotate_tree_right() might have extended the
 		 * transaction without re-journaling our tree root.
 		 */
-		ret = ocfs2_et_root_journal_access(handle, inode, et,
+		ret = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
 						   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
@@ -4631,7 +4632,7 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
 	BUG_ON(num_bits > clusters_to_add);
 
 	/* reserve our write early -- insert_extent may update the tree root */
-	status = ocfs2_et_root_journal_access(handle, inode, et,
+	status = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -5143,13 +5144,13 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_path(inode, handle, path);
+	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, path);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_path(inode, handle, left_path);
+	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, left_path);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -5384,7 +5385,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_et_root_journal_access(handle, inode, et,
+	ret = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -5501,7 +5502,7 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_journal_access_di(handle, tl_inode, tl_bh,
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(tl_inode), tl_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -5563,7 +5564,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 	while (i >= 0) {
 		/* Caller has given us at least enough credits to
 		 * update the truncate log dinode */
-		status = ocfs2_journal_access_di(handle, tl_inode, tl_bh,
+		status = ocfs2_journal_access_di(handle, INODE_CACHE(tl_inode), tl_bh,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -6580,14 +6581,14 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	 * Each component will be touched, so we might as well journal
 	 * here to avoid having to handle errors later.
 	 */
-	status = ocfs2_journal_access_path(inode, handle, path);
+	status = ocfs2_journal_access_path(INODE_CACHE(inode), handle, path);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
 	if (last_eb_bh) {
-		status = ocfs2_journal_access_eb(handle, inode, last_eb_bh,
+		status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), last_eb_bh,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -6949,7 +6950,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		goto out_unlock;
 	}
 
-	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -7318,7 +7319,7 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index a067a6c..c3bb78a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1512,7 +1512,7 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_di(handle, inode, wc->w_di_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		ocfs2_commit_trans(osb, handle);
@@ -1740,7 +1740,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	 * We don't want this to fail in ocfs2_write_end(), so do it
 	 * here.
 	 */
-	ret = ocfs2_journal_access_di(handle, inode, wc->w_di_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index ee9d3a8..efdc153 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -523,7 +523,8 @@ int ocfs2_update_entry(struct inode *dir, handle_t *handle,
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		access = ocfs2_journal_access_di;
 
-	ret = access(handle, dir, de_bh, OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = access(handle, INODE_CACHE(dir), de_bh,
+		     OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -562,7 +563,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 			goto bail;
 		}
 		if (de == de_del)  {
-			status = access(handle, dir, bh,
+			status = access(handle, INODE_CACHE(dir), bh,
 					OCFS2_JOURNAL_ACCESS_WRITE);
 			if (status < 0) {
 				status = -EIO;
@@ -734,11 +735,13 @@ int __ocfs2_add_entry(handle_t *handle,
 			}
 
 			if (insert_bh == parent_fe_bh)
-				status = ocfs2_journal_access_di(handle, dir,
+				status = ocfs2_journal_access_di(handle,
+								 INODE_CACHE(dir),
 								 insert_bh,
 								 OCFS2_JOURNAL_ACCESS_WRITE);
 			else
-				status = ocfs2_journal_access_db(handle, dir,
+				status = ocfs2_journal_access_db(handle,
+								 INODE_CACHE(dir),
 								 insert_bh,
 								 OCFS2_JOURNAL_ACCESS_WRITE);
 			/* By now the buffer is marked for journaling */
@@ -1248,7 +1251,7 @@ static int ocfs2_fill_new_dir_id(struct ocfs2_super *osb,
 	struct ocfs2_inline_data *data = &di->id2.i_data;
 	unsigned int size = le16_to_cpu(data->id_count);
 
-	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -1301,7 +1304,7 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 
 	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
 
-	status = ocfs2_journal_access_db(handle, inode, new_bh,
+	status = ocfs2_journal_access_db(handle, INODE_CACHE(inode), new_bh,
 					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1479,7 +1482,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 
 	ocfs2_set_new_buffer_uptodate(INODE_CACHE(dir), dirdata_bh);
 
-	ret = ocfs2_journal_access_db(handle, dir, dirdata_bh,
+	ret = ocfs2_journal_access_db(handle, INODE_CACHE(dir), dirdata_bh,
 				      OCFS2_JOURNAL_ACCESS_CREATE);
 	if (ret) {
 		mlog_errno(ret);
@@ -1507,7 +1510,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * We let the later dirent insert modify c/mtime - to the user
 	 * the data hasn't changed.
 	 */
-	ret = ocfs2_journal_access_di(handle, dir, di_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(dir), di_bh,
 				      OCFS2_JOURNAL_ACCESS_CREATE);
 	if (ret) {
 		mlog_errno(ret);
@@ -1771,7 +1774,7 @@ do_extend:
 
 	ocfs2_set_new_buffer_uptodate(INODE_CACHE(dir), new_bh);
 
-	status = ocfs2_journal_access_db(handle, dir, new_bh,
+	status = ocfs2_journal_access_db(handle, INODE_CACHE(dir), new_bh,
 					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 5c48b44..8c280f0 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3341,7 +3341,7 @@ static int ocfs2_check_meta_downconvert(struct ocfs2_lock_res *lockres,
 					int new_level)
 {
 	struct inode *inode = ocfs2_lock_res_inode(lockres);
-	int checkpointed = ocfs2_inode_fully_checkpointed(inode);
+	int checkpointed = ocfs2_ci_fully_checkpointed(INODE_CACHE(inode));
 
 	BUG_ON(new_level != DLM_LOCK_NL && new_level != DLM_LOCK_PR);
 	BUG_ON(lockres->l_level != DLM_LOCK_EX && !checkpointed);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a5887df..67acf0b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -256,7 +256,7 @@ int ocfs2_update_inode_atime(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_di(handle, inode, bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -353,7 +353,7 @@ static int ocfs2_orphan_for_truncate(struct ocfs2_super *osb,
 		goto out;
 	}
 
-	status = ocfs2_journal_access_di(handle, inode, fe_bh,
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), fe_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -590,7 +590,7 @@ restarted_transaction:
 	/* reserve a write to the file entry early on - that we if we
 	 * run out of credits in the allocation path, we can still
 	 * update i_size. */
-	status = ocfs2_journal_access_di(handle, inode, bh,
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1121,7 +1121,7 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_di(handle, inode, bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7c3a380..b9cf212 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -537,7 +537,8 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
 			goto out;
 		}
 
-		status = ocfs2_journal_access_di(handle, inode, fe_bh,
+		status = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
+						 fe_bh,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -621,7 +622,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 	}
 
 	/* set the inodes dtime */
-	status = ocfs2_journal_access_di(handle, inode, di_bh,
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1190,7 +1191,7 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 	mlog_entry("(inode %llu)\n",
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	status = ocfs2_journal_access_di(handle, inode, bh,
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 25d1905..e2c2d0a 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -46,6 +46,7 @@
 #include "slot_map.h"
 #include "super.h"
 #include "sysfile.h"
+#include "uptodate.h"
 #include "quota.h"
 
 #include "buffer_head_io.h"
@@ -497,14 +498,16 @@ static struct ocfs2_triggers dq_triggers = {
 };
 
 static int __ocfs2_journal_access(handle_t *handle,
-				  struct inode *inode,
+				  struct ocfs2_caching_info *ci,
 				  struct buffer_head *bh,
 				  struct ocfs2_triggers *triggers,
 				  int type)
 {
 	int status;
+	struct ocfs2_super *osb =
+		OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	BUG_ON(!inode);
+	BUG_ON(!ci || !ci->ci_ops);
 	BUG_ON(!handle);
 	BUG_ON(!bh);
 
@@ -523,15 +526,15 @@ static int __ocfs2_journal_access(handle_t *handle,
 		BUG();
 	}
 
-	/* Set the current transaction information on the inode so
+	/* Set the current transaction information on the ci so
 	 * that the locking code knows whether it can drop it's locks
-	 * on this inode or not. We're protected from the commit
+	 * on this ci or not. We're protected from the commit
 	 * thread updating the current transaction id until
 	 * ocfs2_commit_trans() because ocfs2_start_trans() took
 	 * j_trans_barrier for us. */
-	ocfs2_set_inode_lock_trans(OCFS2_SB(inode->i_sb)->journal, inode);
+	ocfs2_set_ci_lock_trans(osb->journal, ci);
 
-	mutex_lock(&OCFS2_I(inode)->ip_io_mutex);
+	ocfs2_metadata_cache_io_lock(ci);
 	switch (type) {
 	case OCFS2_JOURNAL_ACCESS_CREATE:
 	case OCFS2_JOURNAL_ACCESS_WRITE:
@@ -546,9 +549,9 @@ static int __ocfs2_journal_access(handle_t *handle,
 		status = -EINVAL;
 		mlog(ML_ERROR, "Uknown access type!\n");
 	}
-	if (!status && ocfs2_meta_ecc(OCFS2_SB(inode->i_sb)) && triggers)
+	if (!status && ocfs2_meta_ecc(osb) && triggers)
 		jbd2_journal_set_triggers(bh, &triggers->ot_triggers);
-	mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
+	ocfs2_metadata_cache_io_unlock(ci);
 
 	if (status < 0)
 		mlog(ML_ERROR, "Error %d getting %d access to buffer!\n",
@@ -558,52 +561,52 @@ static int __ocfs2_journal_access(handle_t *handle,
 	return status;
 }
 
-int ocfs2_journal_access_di(handle_t *handle, struct inode *inode,
-			       struct buffer_head *bh, int type)
+int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
+			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, inode, bh, &di_triggers,
+	return __ocfs2_journal_access(handle, ci, bh, &di_triggers,
 				      type);
 }
 
-int ocfs2_journal_access_eb(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, inode, bh, &eb_triggers,
+	return __ocfs2_journal_access(handle, ci, bh, &eb_triggers,
 				      type);
 }
 
-int ocfs2_journal_access_gd(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_gd(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, inode, bh, &gd_triggers,
+	return __ocfs2_journal_access(handle, ci, bh, &gd_triggers,
 				      type);
 }
 
-int ocfs2_journal_access_db(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_db(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, inode, bh, &db_triggers,
+	return __ocfs2_journal_access(handle, ci, bh, &db_triggers,
 				      type);
 }
 
-int ocfs2_journal_access_xb(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_xb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, inode, bh, &xb_triggers,
+	return __ocfs2_journal_access(handle, ci, bh, &xb_triggers,
 				      type);
 }
 
-int ocfs2_journal_access_dq(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_dq(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, inode, bh, &dq_triggers,
+	return __ocfs2_journal_access(handle, ci, bh, &dq_triggers,
 				      type);
 }
 
-int ocfs2_journal_access(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access(handle_t *handle, struct ocfs2_caching_info *ci,
 			 struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, inode, bh, NULL, type);
+	return __ocfs2_journal_access(handle, ci, bh, NULL, type);
 }
 
 int ocfs2_journal_dirty(handle_t *handle,
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index ff4b526..3c08d69 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -79,57 +79,66 @@ static inline unsigned long ocfs2_inc_trans_id(struct ocfs2_journal *j)
 	return old_id;
 }
 
-static inline void ocfs2_set_inode_lock_trans(struct ocfs2_journal *journal,
-					      struct inode *inode)
+static inline void ocfs2_set_ci_lock_trans(struct ocfs2_journal *journal,
+					   struct ocfs2_caching_info *ci)
 {
 	spin_lock(&trans_inc_lock);
-	INODE_CACHE(inode)->ci_last_trans = journal->j_trans_id;
+	ci->ci_last_trans = journal->j_trans_id;
 	spin_unlock(&trans_inc_lock);
 }
 
 /* Used to figure out whether it's safe to drop a metadata lock on an
- * inode. Returns true if all the inodes changes have been
+ * cached object. Returns true if all the object's changes have been
  * checkpointed to disk. You should be holding the spinlock on the
  * metadata lock while calling this to be sure that nobody can take
  * the lock and put it on another transaction. */
-static inline int ocfs2_inode_fully_checkpointed(struct inode *inode)
+static inline int ocfs2_ci_fully_checkpointed(struct ocfs2_caching_info *ci)
 {
 	int ret;
-	struct ocfs2_journal *journal = OCFS2_SB(inode->i_sb)->journal;
+	struct ocfs2_journal *journal =
+		OCFS2_SB(ocfs2_metadata_cache_get_super(ci))->journal;
 
 	spin_lock(&trans_inc_lock);
-	ret = time_after(journal->j_trans_id,
-			 INODE_CACHE(inode)->ci_last_trans);
+	ret = time_after(journal->j_trans_id, ci->ci_last_trans);
 	spin_unlock(&trans_inc_lock);
 	return ret;
 }
 
-/* convenience function to check if an inode is still new (has never
- * hit disk) Will do you a favor and set created_trans = 0 when you've
- * been checkpointed.  returns '1' if the inode is still new. */
-static inline int ocfs2_inode_is_new(struct inode *inode)
+/* convenience function to check if an object backed by struct
+ * ocfs2_caching_info  is still new (has never hit disk) Will do you a
+ * favor and set created_trans = 0 when you've
+ * been checkpointed.  returns '1' if the ci is still new. */
+static inline int ocfs2_ci_is_new(struct ocfs2_caching_info *ci)
 {
 	int ret;
+	struct ocfs2_journal *journal =
+		OCFS2_SB(ocfs2_metadata_cache_get_super(ci))->journal;
+
+	spin_lock(&trans_inc_lock);
+	ret = !(time_after(journal->j_trans_id, ci->ci_created_trans));
+	if (!ret)
+		ci->ci_created_trans = 0;
+	spin_unlock(&trans_inc_lock);
+	return ret;
+}
 
+/* Wrapper for inodes so we can check system files */
+static inline int ocfs2_inode_is_new(struct inode *inode)
+{
 	/* System files are never "new" as they're written out by
 	 * mkfs. This helps us early during mount, before we have the
 	 * journal open and j_trans_id could be junk. */
 	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
 		return 0;
-	spin_lock(&trans_inc_lock);
-	ret = !(time_after(OCFS2_SB(inode->i_sb)->journal->j_trans_id,
-			   INODE_CACHE(inode)->ci_created_trans));
-	if (!ret)
-		INODE_CACHE(inode)->ci_created_trans = 0;
-	spin_unlock(&trans_inc_lock);
-	return ret;
+
+	return ocfs2_ci_is_new(INODE_CACHE(inode));
 }
 
-static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
-				       struct inode *inode)
+static inline void ocfs2_ci_set_new(struct ocfs2_super *osb,
+				    struct ocfs2_caching_info *ci)
 {
 	spin_lock(&trans_inc_lock);
-	INODE_CACHE(inode)->ci_created_trans = osb->journal->j_trans_id;
+	ci->ci_created_trans = osb->journal->j_trans_id;
 	spin_unlock(&trans_inc_lock);
 }
 
@@ -184,7 +193,7 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
 	if (ocfs2_mount_local(osb))
 		return;
 
-	if (!ocfs2_inode_fully_checkpointed(inode)) {
+	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
 		/* WARNING: This only kicks off a single
 		 * checkpoint. If someone races you and adds more
 		 * metadata to the journal, you won't know, and will
@@ -194,7 +203,7 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
 		ocfs2_start_checkpoint(osb);
 
 		wait_event(osb->journal->j_checkpointed,
-			   ocfs2_inode_fully_checkpointed(inode));
+			   ocfs2_ci_fully_checkpointed(INODE_CACHE(inode)));
 	}
 }
 
@@ -250,25 +259,25 @@ int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
 
 
 /* ocfs2_inode */
-int ocfs2_journal_access_di(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type);
 /* ocfs2_extent_block */
-int ocfs2_journal_access_eb(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type);
 /* ocfs2_group_desc */
-int ocfs2_journal_access_gd(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_gd(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type);
 /* ocfs2_xattr_block */
-int ocfs2_journal_access_xb(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_xb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type);
 /* quota blocks */
-int ocfs2_journal_access_dq(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_dq(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type);
 /* dirblock */
-int ocfs2_journal_access_db(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access_db(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type);
 /* Anything that has no ecc */
-int ocfs2_journal_access(handle_t *handle, struct inode *inode,
+int ocfs2_journal_access(handle_t *handle, struct ocfs2_caching_info *ci,
 			 struct buffer_head *bh, int type);
 
 /*
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 62a7f92..2ada879 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -383,8 +383,8 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	}
 	memcpy(alloc_copy, alloc, bh->b_size);
 
-	status = ocfs2_journal_access_di(handle, local_alloc_inode, bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(local_alloc_inode),
+					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_commit;
@@ -764,7 +764,8 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 	 * delete bits from it! */
 	*num_bits = bits_wanted;
 
-	status = ocfs2_journal_access_di(handle, local_alloc_inode,
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(local_alloc_inode),
 					 osb->local_alloc_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
@@ -1242,7 +1243,8 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 	}
 	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
 
-	status = ocfs2_journal_access_di(handle, local_alloc_inode,
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(local_alloc_inode),
 					 osb->local_alloc_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6475006..2615cb9 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -361,7 +361,8 @@ static int ocfs2_mknod(struct inode *dir,
 			goto leave;
 		}
 
-		status = ocfs2_journal_access_di(handle, dir, parent_fe_bh,
+		status = ocfs2_journal_access_di(handle, INODE_CACHE(dir),
+						 parent_fe_bh,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -493,7 +494,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	}
 	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), *new_fe_bh);
 
-	status = ocfs2_journal_access_di(handle, inode, *new_fe_bh,
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
+					 *new_fe_bh,
 					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -547,7 +549,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	}
 
 	ocfs2_populate_inode(inode, fe, 1);
-	ocfs2_inode_set_new(osb, inode);
+	ocfs2_ci_set_new(osb, INODE_CACHE(inode));
 	if (!ocfs2_mount_local(osb)) {
 		status = ocfs2_create_new_inode_locks(inode);
 		if (status < 0)
@@ -664,7 +666,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out_unlock_inode;
 	}
 
-	err = ocfs2_journal_access_di(handle, inode, fe_bh,
+	err = ocfs2_journal_access_di(handle, INODE_CACHE(inode), fe_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (err < 0) {
 		mlog_errno(err);
@@ -851,7 +853,7 @@ static int ocfs2_unlink(struct inode *dir,
 		goto leave;
 	}
 
-	status = ocfs2_journal_access_di(handle, inode, fe_bh,
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), fe_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1265,7 +1267,8 @@ static int ocfs2_rename(struct inode *old_dir,
 				goto bail;
 			}
 		}
-		status = ocfs2_journal_access_di(handle, new_inode, newfe_bh,
+		status = ocfs2_journal_access_di(handle, INODE_CACHE(new_inode),
+						 newfe_bh,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1312,7 +1315,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	old_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(old_inode);
 
-	status = ocfs2_journal_access_di(handle, old_inode, old_inode_bh,
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(old_inode),
+					 old_inode_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status >= 0) {
 		old_di = (struct ocfs2_dinode *) old_inode_bh->b_data;
@@ -1389,7 +1393,8 @@ static int ocfs2_rename(struct inode *old_dir,
 			     (int)old_dir_nlink, old_dir->i_nlink);
 		} else {
 			struct ocfs2_dinode *fe;
-			status = ocfs2_journal_access_di(handle, old_dir,
+			status = ocfs2_journal_access_di(handle,
+							 INODE_CACHE(old_dir),
 							 old_dir_bh,
 							 OCFS2_JOURNAL_ACCESS_WRITE);
 			fe = (struct ocfs2_dinode *) old_dir_bh->b_data;
@@ -1511,7 +1516,8 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 		ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode),
 					      bhs[virtual]);
 
-		status = ocfs2_journal_access(handle, inode, bhs[virtual],
+		status = ocfs2_journal_access(handle, INODE_CACHE(inode),
+					      bhs[virtual],
 					      OCFS2_JOURNAL_ACCESS_CREATE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1899,7 +1905,9 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	status = ocfs2_journal_access_di(handle, orphan_dir_inode, orphan_dir_bh,
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(orphan_dir_inode),
+					 orphan_dir_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1987,7 +1995,9 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	status = ocfs2_journal_access_di(handle,orphan_dir_inode,  orphan_dir_bh,
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(orphan_dir_inode),
+					 orphan_dir_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 049ba23..8374b6b 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -87,6 +87,11 @@ struct ocfs2_caching_info {
 		struct rb_root	ci_tree;
 	} ci_cache;
 };
+/*
+ * Need this prototype here instead of in uptodate.h because journal.h
+ * uses it.
+ */
+struct super_block *ocfs2_metadata_cache_get_super(struct ocfs2_caching_info *ci);
 
 /* this limits us to 256 nodes
  * if we need more, we can do a kmalloc for the map */
@@ -372,7 +377,8 @@ struct ocfs2_super
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
 
 /* Useful typedef for passing around journal access functions */
-typedef int (*ocfs2_journal_access_func)(handle_t *handle, struct inode *inode,
+typedef int (*ocfs2_journal_access_func)(handle_t *handle,
+					 struct ocfs2_caching_info *ci,
 					 struct buffer_head *bh, int type);
 
 static inline int ocfs2_should_order_data(struct inode *inode)
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index d36326b..e0aa5b6 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -244,7 +244,8 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 	ocfs2_set_buffer_uptodate(INODE_CACHE(gqinode), bh);
-	err = ocfs2_journal_access_dq(handle, gqinode, bh, ja_type);
+	err = ocfs2_journal_access_dq(handle, INODE_CACHE(gqinode), bh,
+				      ja_type);
 	if (err < 0) {
 		brelse(bh);
 		goto out;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 07deec5..acb812c 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -106,7 +106,7 @@ static int ocfs2_modify_bh(struct inode *inode, struct buffer_head *bh,
 		mlog_errno(status);
 		return status;
 	}
-	status = ocfs2_journal_access_dq(handle, inode, bh,
+	status = ocfs2_journal_access_dq(handle, INODE_CACHE(inode), bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -506,7 +506,8 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 				goto out_commit;
 			}
 			/* Release local quota file entry */
-			status = ocfs2_journal_access_dq(handle, lqinode,
+			status = ocfs2_journal_access_dq(handle,
+					INODE_CACHE(lqinode),
 					qbh, OCFS2_JOURNAL_ACCESS_WRITE);
 			if (status < 0) {
 				mlog_errno(status);
@@ -614,7 +615,8 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			mlog_errno(status);
 			goto out_bh;
 		}
-		status = ocfs2_journal_access_dq(handle, lqinode, bh,
+		status = ocfs2_journal_access_dq(handle, INODE_CACHE(lqinode),
+						 bh,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -981,7 +983,7 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 		goto out;
 	}
 
-	status = ocfs2_journal_access_dq(handle, lqinode, bh,
+	status = ocfs2_journal_access_dq(handle, INODE_CACHE(lqinode), bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1074,7 +1076,8 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 		mlog_errno(status);
 		goto out;
 	}
-	status = ocfs2_journal_access_dq(handle, lqinode, chunk->qc_headerbh,
+	status = ocfs2_journal_access_dq(handle, INODE_CACHE(lqinode),
+				 chunk->qc_headerbh,
 				 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1207,7 +1210,8 @@ static int ocfs2_local_release_dquot(struct dquot *dquot)
 		goto out;
 	}
 
-	status = ocfs2_journal_access_dq(handle, sb_dqopt(sb)->files[type],
+	status = ocfs2_journal_access_dq(handle,
+			INODE_CACHE(sb_dqopt(sb)->files[type]),
 			od->dq_chunk->qc_headerbh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 7465f0f..3c3d673 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -106,8 +106,8 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	mlog_entry("(new_clusters=%d, first_new_cluster = %u)\n",
 		   new_clusters, first_new_cluster);
 
-	ret = ocfs2_journal_access_gd(handle, bm_inode, group_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_gd(handle, INODE_CACHE(bm_inode),
+				      group_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -141,7 +141,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	}
 
 	/* update the inode accordingly. */
-	ret = ocfs2_journal_access_di(handle, bm_inode, bm_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(bm_inode), bm_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -536,8 +536,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	cl = &fe->id2.i_chain;
 	cr = &cl->cl_recs[input->chain];
 
-	ret = ocfs2_journal_access_gd(handle, main_bm_inode, group_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_gd(handle, INODE_CACHE(main_bm_inode),
+				      group_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -552,8 +552,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		goto out_commit;
 	}
 
-	ret = ocfs2_journal_access_di(handle, main_bm_inode, main_bm_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(main_bm_inode),
+				      main_bm_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_commit;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index cd0b5c4..81a784f 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -348,7 +348,7 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	}
 
 	status = ocfs2_journal_access_gd(handle,
-					 alloc_inode,
+					 INODE_CACHE(alloc_inode),
 					 bg_bh,
 					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
@@ -480,7 +480,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 
 	bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 
-	status = ocfs2_journal_access_di(handle, alloc_inode,
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
 					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -991,7 +991,7 @@ static inline int ocfs2_block_group_set_bits(handle_t *handle,
 		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
 
 	status = ocfs2_journal_access_gd(handle,
-					 alloc_inode,
+					 INODE_CACHE(alloc_inode),
 					 group_bh,
 					 journal_type);
 	if (status < 0) {
@@ -1064,7 +1064,8 @@ static int ocfs2_relink_block_group(handle_t *handle,
 	bg_ptr = le64_to_cpu(bg->bg_next_group);
 	prev_bg_ptr = le64_to_cpu(prev_bg->bg_next_group);
 
-	status = ocfs2_journal_access_gd(handle, alloc_inode, prev_bg_bh,
+	status = ocfs2_journal_access_gd(handle, INODE_CACHE(alloc_inode),
+					 prev_bg_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1079,8 +1080,8 @@ static int ocfs2_relink_block_group(handle_t *handle,
 		goto out_rollback;
 	}
 
-	status = ocfs2_journal_access_gd(handle, alloc_inode, bg_bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_gd(handle, INODE_CACHE(alloc_inode),
+					 bg_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_rollback;
@@ -1094,8 +1095,8 @@ static int ocfs2_relink_block_group(handle_t *handle,
 		goto out_rollback;
 	}
 
-	status = ocfs2_journal_access_di(handle, alloc_inode, fe_bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
+					 fe_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_rollback;
@@ -1246,7 +1247,7 @@ static int ocfs2_alloc_dinode_update_counts(struct inode *inode,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
 	struct ocfs2_chain_list *cl = (struct ocfs2_chain_list *) &di->id2.i_chain;
 
-	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -1419,7 +1420,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	/* Ok, claim our bits now: set the info on dinode, chainlist
 	 * and then the group */
 	status = ocfs2_journal_access_di(handle,
-					 alloc_inode,
+					 INODE_CACHE(alloc_inode),
 					 ac->ac_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
@@ -1828,8 +1829,8 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 	if (ocfs2_is_cluster_bitmap(alloc_inode))
 		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
 
-	status = ocfs2_journal_access_gd(handle, alloc_inode, group_bh,
-					 journal_type);
+	status = ocfs2_journal_access_gd(handle, INODE_CACHE(alloc_inode),
+					 group_bh, journal_type);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1904,8 +1905,8 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 		goto bail;
 	}
 
-	status = ocfs2_journal_access_di(handle, alloc_inode, alloc_bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
+					 alloc_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/uptodate.h b/fs/ocfs2/uptodate.h
index 80dbb1d..0d826fe 100644
--- a/fs/ocfs2/uptodate.h
+++ b/fs/ocfs2/uptodate.h
@@ -64,7 +64,6 @@ void ocfs2_metadata_cache_purge(struct ocfs2_caching_info *ci);
 void ocfs2_metadata_cache_exit(struct ocfs2_caching_info *ci);
 
 u64 ocfs2_metadata_cache_owner(struct ocfs2_caching_info *ci);
-struct super_block *ocfs2_metadata_cache_get_super(struct ocfs2_caching_info *ci);
 void ocfs2_metadata_cache_io_lock(struct ocfs2_caching_info *ci);
 void ocfs2_metadata_cache_io_unlock(struct ocfs2_caching_info *ci);
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a79a6a9..86ed848 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -294,7 +294,8 @@ static int ocfs2_xattr_bucket_journal_access(handle_t *handle,
 	int i, rc = 0;
 
 	for (i = 0; i < bucket->bu_blocks; i++) {
-		rc = ocfs2_journal_access(handle, bucket->bu_inode,
+		rc = ocfs2_journal_access(handle,
+					  INODE_CACHE(bucket->bu_inode),
 					  bucket->bu_bhs[i], type);
 		if (rc) {
 			mlog_errno(rc);
@@ -599,7 +600,7 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 
 	ocfs2_init_xattr_value_extent_tree(&et, inode, vb);
 
-	status = vb->vb_access(handle, inode, vb->vb_bh,
+	status = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
 			      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -653,7 +654,7 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 
 	ocfs2_init_xattr_value_extent_tree(&et, inode, vb);
 
-	ret = vb->vb_access(handle, inode, vb->vb_bh,
+	ret = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
 			    OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -1211,7 +1212,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 			}
 
 			ret = ocfs2_journal_access(handle,
-						   inode,
+						   INODE_CACHE(inode),
 						   bh,
 						   OCFS2_JOURNAL_ACCESS_WRITE);
 			if (ret < 0) {
@@ -1262,7 +1263,7 @@ static int ocfs2_xattr_cleanup(struct inode *inode,
 	void *val = xs->base + offs;
 	size_t size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
 
-	ret = vb->vb_access(handle, inode, vb->vb_bh,
+	ret = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
 			    OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -1290,7 +1291,7 @@ static int ocfs2_xattr_update_entry(struct inode *inode,
 {
 	int ret;
 
-	ret = vb->vb_access(handle, inode, vb->vb_bh,
+	ret = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
 			    OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -1611,7 +1612,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_journal_access_di(handle, inode, xs->inode_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), xs->inode_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -1619,7 +1620,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	}
 
 	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
-		ret = vb.vb_access(handle, inode, vb.vb_bh,
+		ret = vb.vb_access(handle, INODE_CACHE(inode), vb.vb_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
@@ -1892,7 +1893,7 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 		mlog_errno(ret);
 		goto out;
 	}
-	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -2101,7 +2102,8 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 	int ret;
 
 	if (!xs->xattr_bh) {
-		ret = ocfs2_journal_access_di(handle, inode, xs->inode_bh,
+		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
+					      xs->inode_bh,
 					      OCFS2_JOURNAL_ACCESS_CREATE);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2119,7 +2121,8 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		new_bh = sb_getblk(inode->i_sb, first_blkno);
 		ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
 
-		ret = ocfs2_journal_access_xb(handle, inode, new_bh,
+		ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode),
+					      new_bh,
 					      OCFS2_JOURNAL_ACCESS_CREATE);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2594,7 +2597,8 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 
 	if (!ret) {
 		/* Update inode ctime. */
-		ret = ocfs2_journal_access(ctxt->handle, inode, xis->inode_bh,
+		ret = ocfs2_journal_access(ctxt->handle, INODE_CACHE(inode),
+					   xis->inode_bh,
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
@@ -3420,7 +3424,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	 */
 	down_write(&oi->ip_alloc_sem);
 
-	ret = ocfs2_journal_access_xb(handle, inode, xb_bh,
+	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode), xb_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -4259,7 +4263,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 
 	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
 
-	ret = ocfs2_journal_access_xb(handle, inode, root_bh,
+	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode), root_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -4851,7 +4855,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_xb(handle, inode, root_bh,
+	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode), root_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-- 
1.5.6.5
