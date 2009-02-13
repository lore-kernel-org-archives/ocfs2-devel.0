From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:55 -0800
Subject: [Ocfs2-devel] [PATCH 08/40] ocfs2: Pass ocfs2_caching_info to
	ocfs2_read_extent_block().
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-9-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

extent blocks belong to btrees on more than just inodes, so we want to
pass the ocfs2_caching_info structure directly to
ocfs2_read_extent_block().  A number of places in alloc.c can now drop
struct inode from their argument list.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c      |   38 ++++++++++++++++++++------------------
 fs/ocfs2/alloc.h      |    3 +--
 fs/ocfs2/dir.c        |    2 +-
 fs/ocfs2/extent_map.c |    4 ++--
 fs/ocfs2/suballoc.c   |    2 +-
 5 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 2c87173..787f35a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -790,13 +790,13 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
 	return 0;
 }
 
-int ocfs2_read_extent_block(struct inode *inode, u64 eb_blkno,
+int ocfs2_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
 			    struct buffer_head **bh)
 {
 	int rc;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_block(INODE_CACHE(inode), eb_blkno, &tmp,
+	rc = ocfs2_read_block(ci, eb_blkno, &tmp,
 			      ocfs2_validate_extent_block);
 
 	/* If ocfs2_read_block() got us a new bh, pass it up. */
@@ -811,7 +811,6 @@ int ocfs2_read_extent_block(struct inode *inode, u64 eb_blkno,
  * How many free extents have we got before we need more meta data?
  */
 int ocfs2_num_free_extents(struct ocfs2_super *osb,
-			   struct inode *inode,
 			   struct ocfs2_extent_tree *et)
 {
 	int retval;
@@ -826,7 +825,8 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 	last_eb_blk = ocfs2_et_get_last_eb_blk(et);
 
 	if (last_eb_blk) {
-		retval = ocfs2_read_extent_block(inode, last_eb_blk, &eb_bh);
+		retval = ocfs2_read_extent_block(et->et_ci, last_eb_blk,
+						 &eb_bh);
 		if (retval < 0) {
 			mlog_errno(retval);
 			goto bail;
@@ -1252,7 +1252,6 @@ bail:
  * return status < 0 indicates an error.
  */
 static int ocfs2_find_branch_target(struct ocfs2_super *osb,
-				    struct inode *inode,
 				    struct ocfs2_extent_tree *et,
 				    struct buffer_head **target_bh)
 {
@@ -1271,19 +1270,21 @@ static int ocfs2_find_branch_target(struct ocfs2_super *osb,
 
 	while(le16_to_cpu(el->l_tree_depth) > 1) {
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
-			ocfs2_error(inode->i_sb, "Dinode %llu has empty "
+			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+				    "Owner %llu has empty "
 				    "extent list (next_free_rec == 0)",
-				    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
 			status = -EIO;
 			goto bail;
 		}
 		i = le16_to_cpu(el->l_next_free_rec) - 1;
 		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
 		if (!blkno) {
-			ocfs2_error(inode->i_sb, "Dinode %llu has extent "
+			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+				    "Owner %llu has extent "
 				    "list where extent # %d has no physical "
 				    "block start",
-				    (unsigned long long)OCFS2_I(inode)->ip_blkno, i);
+				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci), i);
 			status = -EIO;
 			goto bail;
 		}
@@ -1291,7 +1292,7 @@ static int ocfs2_find_branch_target(struct ocfs2_super *osb,
 		brelse(bh);
 		bh = NULL;
 
-		status = ocfs2_read_extent_block(inode, blkno, &bh);
+		status = ocfs2_read_extent_block(et->et_ci, blkno, &bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1345,7 +1346,7 @@ static int ocfs2_grow_tree(struct inode *inode, handle_t *handle,
 
 	BUG_ON(meta_ac == NULL);
 
-	shift = ocfs2_find_branch_target(osb, inode, et, &bh);
+	shift = ocfs2_find_branch_target(osb, et, &bh);
 	if (shift < 0) {
 		ret = shift;
 		mlog_errno(ret);
@@ -1650,7 +1651,7 @@ static int __ocfs2_find_path(struct inode *inode,
 
 		brelse(bh);
 		bh = NULL;
-		ret = ocfs2_read_extent_block(inode, blkno, &bh);
+		ret = ocfs2_read_extent_block(INODE_CACHE(inode), blkno, &bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2872,7 +2873,8 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_find_cpos_for_left_leaf(inode->i_sb, path, &cpos);
+	ret = ocfs2_find_cpos_for_left_leaf(ocfs2_metadata_cache_get_super(et->et_ci),
+					    path, &cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4392,7 +4394,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		 * ocfs2_figure_insert_type() and ocfs2_add_branch()
 		 * may want it later.
 		 */
-		ret = ocfs2_read_extent_block(inode,
+		ret = ocfs2_read_extent_block(et->et_ci,
 					      ocfs2_et_get_last_eb_blk(et),
 					      &bh);
 		if (ret) {
@@ -4595,7 +4597,7 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
 	if (mark_unwritten)
 		flags = OCFS2_EXT_UNWRITTEN;
 
-	free_extents = ocfs2_num_free_extents(osb, inode, et);
+	free_extents = ocfs2_num_free_extents(osb, et);
 	if (free_extents < 0) {
 		status = free_extents;
 		mlog_errno(status);
@@ -4860,7 +4862,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 	if (path->p_tree_depth) {
 		struct ocfs2_extent_block *eb;
 
-		ret = ocfs2_read_extent_block(inode,
+		ret = ocfs2_read_extent_block(et->et_ci,
 					      ocfs2_et_get_last_eb_blk(et),
 					      &last_eb_bh);
 		if (ret) {
@@ -5013,7 +5015,7 @@ static int ocfs2_split_tree(struct inode *inode, struct ocfs2_extent_tree *et,
 
 	depth = path->p_tree_depth;
 	if (depth > 0) {
-		ret = ocfs2_read_extent_block(inode,
+		ret = ocfs2_read_extent_block(et->et_ci,
 					      ocfs2_et_get_last_eb_blk(et),
 					      &last_eb_bh);
 		if (ret < 0) {
@@ -7257,7 +7259,7 @@ int ocfs2_prepare_truncate(struct ocfs2_super *osb,
 	ocfs2_init_dealloc_ctxt(&(*tc)->tc_dealloc);
 
 	if (fe->id2.i_list.l_tree_depth) {
-		status = ocfs2_read_extent_block(inode,
+		status = ocfs2_read_extent_block(INODE_CACHE(inode),
 						 le64_to_cpu(fe->i_last_eb_blk),
 						 &last_eb_bh);
 		if (status < 0) {
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index b16e32c..cc45d12 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -83,7 +83,7 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
  * allocated.  This is a cached read.  The extent block will be validated
  * with ocfs2_validate_extent_block().
  */
-int ocfs2_read_extent_block(struct inode *inode, u64 eb_blkno,
+int ocfs2_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
 			    struct buffer_head **bh);
 
 struct ocfs2_alloc_context;
@@ -129,7 +129,6 @@ int ocfs2_remove_btree_range(struct inode *inode,
 			     struct ocfs2_cached_dealloc_ctxt *dealloc);
 
 int ocfs2_num_free_extents(struct ocfs2_super *osb,
-			   struct inode *inode,
 			   struct ocfs2_extent_tree *et);
 
 /*
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index efdc153..801e47c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1724,7 +1724,7 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 	if (dir_i_size == ocfs2_clusters_to_bytes(sb, OCFS2_I(dir)->ip_clusters)) {
 		spin_unlock(&OCFS2_I(dir)->ip_lock);
 		ocfs2_init_dinode_extent_tree(&et, dir, parent_fe_bh);
-		num_free_extents = ocfs2_num_free_extents(osb, dir, &et);
+		num_free_extents = ocfs2_num_free_extents(osb, &et);
 		if (num_free_extents < 0) {
 			status = num_free_extents;
 			mlog_errno(status);
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index dbd8a16..a5dc13e 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -293,7 +293,7 @@ static int ocfs2_last_eb_is_empty(struct inode *inode,
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
 
-	ret = ocfs2_read_extent_block(inode, last_eb_blk, &eb_bh);
+	ret = ocfs2_read_extent_block(INODE_CACHE(inode), last_eb_blk, &eb_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -375,7 +375,7 @@ static int ocfs2_figure_hole_clusters(struct inode *inode,
 		if (le64_to_cpu(eb->h_next_leaf_blk) == 0ULL)
 			goto no_more_extents;
 
-		ret = ocfs2_read_extent_block(inode,
+		ret = ocfs2_read_extent_block(INODE_CACHE(inode),
 					      le64_to_cpu(eb->h_next_leaf_blk),
 					      &next_eb_bh);
 		if (ret) {
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 81a784f..f6712ab 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2063,7 +2063,7 @@ int ocfs2_lock_allocators(struct inode *inode,
 
 	BUG_ON(clusters_to_add != 0 && data_ac == NULL);
 
-	num_free_extents = ocfs2_num_free_extents(osb, inode, et);
+	num_free_extents = ocfs2_num_free_extents(osb, et);
 	if (num_free_extents < 0) {
 		ret = num_free_extents;
 		mlog_errno(ret);
-- 
1.5.6.5
