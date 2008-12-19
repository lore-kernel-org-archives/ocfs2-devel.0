From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:56 -0800
Subject: [Ocfs2-devel] [PATCH 37/45] ocfs2: Wrap extent block reads in a
	dedicated function.
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-38-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

We weren't consistently checking extent blocks after we read them.
Most places checked the signature, but none checked h_blkno or
h_fs_signature.  Create a toplevel ocfs2_read_extent_block() that does
the read and the validation.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c      |  151 ++++++++++++++++++++++++++++++++-----------------
 fs/ocfs2/alloc.h      |    8 +++
 fs/ocfs2/extent_map.c |   23 ++------
 fs/ocfs2/ocfs2.h      |    8 ---
 4 files changed, 111 insertions(+), 79 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 320545b..f430cc6 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -678,6 +678,66 @@ struct ocfs2_merge_ctxt {
 	int			c_split_covers_rec;
 };
 
+static int ocfs2_validate_extent_block(struct super_block *sb,
+				       struct buffer_head *bh)
+{
+	struct ocfs2_extent_block *eb =
+		(struct ocfs2_extent_block *)bh->b_data;
+
+	if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
+		ocfs2_error(sb,
+			    "Extent block #%llu has bad signature %.*s",
+			    (unsigned long long)bh->b_blocknr, 7,
+			    eb->h_signature);
+		return -EINVAL;
+	}
+
+	if (le64_to_cpu(eb->h_blkno) != bh->b_blocknr) {
+		ocfs2_error(sb,
+			    "Extent block #%llu has an invalid h_blkno "
+			    "of %llu",
+			    (unsigned long long)bh->b_blocknr,
+			    (unsigned long long)le64_to_cpu(eb->h_blkno));
+		return -EINVAL;
+	}
+
+	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+		ocfs2_error(sb,
+			    "Extent block #%llu has an invalid "
+			    "h_fs_generation of #%u",
+			    (unsigned long long)bh->b_blocknr,
+			    le32_to_cpu(eb->h_fs_generation));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int ocfs2_read_extent_block(struct inode *inode, u64 eb_blkno,
+			    struct buffer_head **bh)
+{
+	int rc;
+	struct buffer_head *tmp = *bh;
+
+	rc = ocfs2_read_block(inode, eb_blkno, &tmp);
+	if (rc)
+		goto out;
+
+	rc = ocfs2_validate_extent_block(inode->i_sb, tmp);
+	if (rc) {
+		brelse(tmp);
+		goto out;
+	}
+
+	/* If ocfs2_read_block() got us a new bh, pass it up. */
+	if (!*bh)
+		*bh = tmp;
+
+out:
+	return rc;
+}
+
+
 /*
  * How many free extents have we got before we need more meta data?
  */
@@ -697,8 +757,7 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 	last_eb_blk = ocfs2_et_get_last_eb_blk(et);
 
 	if (last_eb_blk) {
-		retval = ocfs2_read_block(inode, last_eb_blk,
-					  &eb_bh);
+		retval = ocfs2_read_extent_block(inode, last_eb_blk, &eb_bh);
 		if (retval < 0) {
 			mlog_errno(retval);
 			goto bail;
@@ -900,11 +959,8 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 	for(i = 0; i < new_blocks; i++) {
 		bh = new_eb_bhs[i];
 		eb = (struct ocfs2_extent_block *) bh->b_data;
-		if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
-			OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb, eb);
-			status = -EIO;
-			goto bail;
-		}
+		/* ocfs2_create_new_meta_bhs() should create it right! */
+		BUG_ON(!OCFS2_IS_VALID_EXTENT_BLOCK(eb));
 		eb_el = &eb->h_list;
 
 		status = ocfs2_journal_access(handle, inode, bh,
@@ -1044,11 +1100,8 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 	}
 
 	eb = (struct ocfs2_extent_block *) new_eb_bh->b_data;
-	if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
-		OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb, eb);
-		status = -EIO;
-		goto bail;
-	}
+	/* ocfs2_create_new_meta_bhs() should create it right! */
+	BUG_ON(!OCFS2_IS_VALID_EXTENT_BLOCK(eb));
 
 	eb_el = &eb->h_list;
 	root_el = et->et_root_el;
@@ -1168,18 +1221,13 @@ static int ocfs2_find_branch_target(struct ocfs2_super *osb,
 		brelse(bh);
 		bh = NULL;
 
-		status = ocfs2_read_block(inode, blkno, &bh);
+		status = ocfs2_read_extent_block(inode, blkno, &bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
 		}
 
 		eb = (struct ocfs2_extent_block *) bh->b_data;
-		if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
-			OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb, eb);
-			status = -EIO;
-			goto bail;
-		}
 		el = &eb->h_list;
 
 		if (le16_to_cpu(el->l_next_free_rec) <
@@ -1532,7 +1580,7 @@ static int __ocfs2_find_path(struct inode *inode,
 
 		brelse(bh);
 		bh = NULL;
-		ret = ocfs2_read_block(inode, blkno, &bh);
+		ret = ocfs2_read_extent_block(inode, blkno, &bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -1540,11 +1588,6 @@ static int __ocfs2_find_path(struct inode *inode,
 
 		eb = (struct ocfs2_extent_block *) bh->b_data;
 		el = &eb->h_list;
-		if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
-			OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb, eb);
-			ret = -EIO;
-			goto out;
-		}
 
 		if (le16_to_cpu(el->l_next_free_rec) >
 		    le16_to_cpu(el->l_count)) {
@@ -4089,8 +4132,15 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			    le16_to_cpu(new_el->l_count)) {
 				bh = path_leaf_bh(left_path);
 				eb = (struct ocfs2_extent_block *)bh->b_data;
-				OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb,
-								 eb);
+				ocfs2_error(inode->i_sb,
+					    "Extent block #%llu has an "
+					    "invalid l_next_free_rec of "
+					    "%d.  It should have "
+					    "matched the l_count of %d",
+					    (unsigned long long)le64_to_cpu(eb->h_blkno),
+					    le16_to_cpu(new_el->l_next_free_rec),
+					    le16_to_cpu(new_el->l_count));
+				status = -EINVAL;
 				goto out;
 			}
 			rec = &new_el->l_recs[
@@ -4139,8 +4189,12 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			if (le16_to_cpu(new_el->l_next_free_rec) <= 1) {
 				bh = path_leaf_bh(right_path);
 				eb = (struct ocfs2_extent_block *)bh->b_data;
-				OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb,
-								 eb);
+				ocfs2_error(inode->i_sb,
+					    "Extent block #%llu has an "
+					    "invalid l_next_free_rec of %d",
+					    (unsigned long long)le64_to_cpu(eb->h_blkno),
+					    le16_to_cpu(new_el->l_next_free_rec));
+				status = -EINVAL;
 				goto out;
 			}
 			rec = &new_el->l_recs[1];
@@ -4286,7 +4340,9 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		 * ocfs2_figure_insert_type() and ocfs2_add_branch()
 		 * may want it later.
 		 */
-		ret = ocfs2_read_block(inode, ocfs2_et_get_last_eb_blk(et), &bh);
+		ret = ocfs2_read_extent_block(inode,
+					      ocfs2_et_get_last_eb_blk(et),
+					      &bh);
 		if (ret) {
 			mlog_exit(ret);
 			goto out;
@@ -4752,20 +4808,15 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 	if (path->p_tree_depth) {
 		struct ocfs2_extent_block *eb;
 
-		ret = ocfs2_read_block(inode, ocfs2_et_get_last_eb_blk(et),
-				       &last_eb_bh);
+		ret = ocfs2_read_extent_block(inode,
+					      ocfs2_et_get_last_eb_blk(et),
+					      &last_eb_bh);
 		if (ret) {
 			mlog_exit(ret);
 			goto out;
 		}
 
 		eb = (struct ocfs2_extent_block *) last_eb_bh->b_data;
-		if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
-			OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb, eb);
-			ret = -EROFS;
-			goto out;
-		}
-
 		rightmost_el = &eb->h_list;
 	} else
 		rightmost_el = path_root_el(path);
@@ -4910,8 +4961,9 @@ static int ocfs2_split_tree(struct inode *inode, struct ocfs2_extent_tree *et,
 
 	depth = path->p_tree_depth;
 	if (depth > 0) {
-		ret = ocfs2_read_block(inode, ocfs2_et_get_last_eb_blk(et),
-				       &last_eb_bh);
+		ret = ocfs2_read_extent_block(inode,
+					      ocfs2_et_get_last_eb_blk(et),
+					      &last_eb_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -6231,11 +6283,10 @@ static int ocfs2_find_new_last_ext_blk(struct inode *inode,
 
 	eb = (struct ocfs2_extent_block *) bh->b_data;
 	el = &eb->h_list;
-	if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
-		OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb, eb);
-		ret = -EROFS;
-		goto out;
-	}
+
+	/* ocfs2_find_leaf() gets the eb from ocfs2_read_extent_block().
+	 * Any corruption is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_EXTENT_BLOCK(eb));
 
 	*new_last_eb = bh;
 	get_bh(*new_last_eb);
@@ -7140,20 +7191,14 @@ int ocfs2_prepare_truncate(struct ocfs2_super *osb,
 	ocfs2_init_dealloc_ctxt(&(*tc)->tc_dealloc);
 
 	if (fe->id2.i_list.l_tree_depth) {
-		status = ocfs2_read_block(inode, le64_to_cpu(fe->i_last_eb_blk),
-					  &last_eb_bh);
+		status = ocfs2_read_extent_block(inode,
+						 le64_to_cpu(fe->i_last_eb_blk),
+						 &last_eb_bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
 		}
 		eb = (struct ocfs2_extent_block *) last_eb_bh->b_data;
-		if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
-			OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb, eb);
-
-			brelse(last_eb_bh);
-			status = -EIO;
-			goto bail;
-		}
 	}
 
 	(*tc)->tc_last_eb_bh = last_eb_bh;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 0fbf8fc..59d37d1 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -73,6 +73,14 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 					struct buffer_head *bh,
 					struct ocfs2_xattr_value_root *xv);
 
+/*
+ * Read an extent block into *bh.  If *bh is NULL, a bh will be
+ * allocated.  This is a cached read.  The extent block will be validated
+ * with ocfs2_validate_extent_block().
+ */
+int ocfs2_read_extent_block(struct inode *inode, u64 eb_blkno,
+			    struct buffer_head **bh);
+
 struct ocfs2_alloc_context;
 int ocfs2_insert_extent(struct ocfs2_super *osb,
 			handle_t *handle,
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index b686b31..0bd9d96 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -293,7 +293,7 @@ static int ocfs2_last_eb_is_empty(struct inode *inode,
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
 
-	ret = ocfs2_read_block(inode, last_eb_blk, &eb_bh);
+	ret = ocfs2_read_extent_block(inode, last_eb_blk, &eb_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -302,12 +302,6 @@ static int ocfs2_last_eb_is_empty(struct inode *inode,
 	eb = (struct ocfs2_extent_block *) eb_bh->b_data;
 	el = &eb->h_list;
 
-	if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
-		ret = -EROFS;
-		OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb, eb);
-		goto out;
-	}
-
 	if (el->l_tree_depth) {
 		ocfs2_error(inode->i_sb,
 			    "Inode %lu has non zero tree depth in "
@@ -381,23 +375,16 @@ static int ocfs2_figure_hole_clusters(struct inode *inode,
 		if (le64_to_cpu(eb->h_next_leaf_blk) == 0ULL)
 			goto no_more_extents;
 
-		ret = ocfs2_read_block(inode,
-				       le64_to_cpu(eb->h_next_leaf_blk),
-				       &next_eb_bh);
+		ret = ocfs2_read_extent_block(inode,
+					      le64_to_cpu(eb->h_next_leaf_blk),
+					      &next_eb_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
-		next_eb = (struct ocfs2_extent_block *)next_eb_bh->b_data;
-
-		if (!OCFS2_IS_VALID_EXTENT_BLOCK(next_eb)) {
-			ret = -EROFS;
-			OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb, next_eb);
-			goto out;
-		}
 
+		next_eb = (struct ocfs2_extent_block *)next_eb_bh->b_data;
 		el = &next_eb->h_list;
-
 		i = ocfs2_search_for_hole_index(el, v_cluster);
 	}
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 82ba887..f04b229 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -447,14 +447,6 @@ static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
 #define OCFS2_IS_VALID_EXTENT_BLOCK(ptr)				\
 	(!strcmp((ptr)->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE))
 
-#define OCFS2_RO_ON_INVALID_EXTENT_BLOCK(__sb, __eb)	do {		\
-	typeof(__eb) ____eb = (__eb);					\
-	ocfs2_error((__sb), 						\
-		"Extent Block # %llu has bad signature %.*s",		\
-		(unsigned long long)le64_to_cpu((____eb)->h_blkno), 7,	\
-		(____eb)->h_signature);					\
-} while (0)
-
 #define OCFS2_IS_VALID_GROUP_DESC(ptr)					\
 	(!strcmp((ptr)->bg_signature, OCFS2_GROUP_DESC_SIGNATURE))
 
-- 
1.5.6
