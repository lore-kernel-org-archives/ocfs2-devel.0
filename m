From: Joe Perches <joe@perches.com>
Date: Thu, 26 Mar 2015 20:07:08 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Neaten do_error,
	ocfs2_error and ocfs2_abort
In-Reply-To: <cover.1427425496.git.joe@perches.com>
References: <cover.1427425496.git.joe@perches.com>
Message-ID: <e05a1f6d65f0d6ff7f070f8dcb434129001986cf.1427425496.git.joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

These uses sometimes do and sometimes don't have '\n' terminations.
Make the uses consistently use '\n' terminations and remove the
newline from the functions.

Miscellanea:

o Coalesce formats
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/alloc.c        | 90 +++++++++++++++++++------------------------------
 fs/ocfs2/aops.c         |  4 +--
 fs/ocfs2/dir.c          | 49 +++++++++++++--------------
 fs/ocfs2/extent_map.c   | 22 ++++++------
 fs/ocfs2/inode.c        | 18 +++++-----
 fs/ocfs2/journal.c      |  2 +-
 fs/ocfs2/localalloc.c   |  3 +-
 fs/ocfs2/move_extents.c |  5 ++-
 fs/ocfs2/quota_local.c  |  3 +-
 fs/ocfs2/refcounttree.c | 53 +++++++++++++----------------
 fs/ocfs2/suballoc.c     | 75 +++++++++++++++++++----------------------
 fs/ocfs2/super.c        |  4 +--
 fs/ocfs2/super.h        |  6 ++--
 fs/ocfs2/xattr.c        | 35 +++++++++----------
 14 files changed, 165 insertions(+), 204 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 2b0aaa6..5483f0b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -909,27 +909,25 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
 
 	if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
 		rc = ocfs2_error(sb,
-			    "Extent block #%llu has bad signature %.*s",
-			    (unsigned long long)bh->b_blocknr, 7,
-			    eb->h_signature);
+				 "Extent block #%llu has bad signature %.*s\n",
+				 (unsigned long long)bh->b_blocknr, 7,
+				 eb->h_signature);
 		goto bail;
 	}
 
 	if (le64_to_cpu(eb->h_blkno) != bh->b_blocknr) {
 		rc = ocfs2_error(sb,
-			    "Extent block #%llu has an invalid h_blkno "
-			    "of %llu",
-			    (unsigned long long)bh->b_blocknr,
-			    (unsigned long long)le64_to_cpu(eb->h_blkno));
+				 "Extent block #%llu has an invalid h_blkno of %llu\n",
+				 (unsigned long long)bh->b_blocknr,
+				 (unsigned long long)le64_to_cpu(eb->h_blkno));
 		goto bail;
 	}
 
 	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation) {
 		rc = ocfs2_error(sb,
-			    "Extent block #%llu has an invalid "
-			    "h_fs_generation of #%u",
-			    (unsigned long long)bh->b_blocknr,
-			    le32_to_cpu(eb->h_fs_generation));
+				 "Extent block #%llu has an invalid h_fs_generation of #%u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le32_to_cpu(eb->h_fs_generation));
 		goto bail;
 	}
 bail:
@@ -1446,8 +1444,7 @@ static int ocfs2_find_branch_target(struct ocfs2_extent_tree *et,
 	while(le16_to_cpu(el->l_tree_depth) > 1) {
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu has empty "
-				    "extent list (next_free_rec == 0)",
+				    "Owner %llu has empty extent list (next_free_rec == 0)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
 			status = -EIO;
 			goto bail;
@@ -1456,9 +1453,7 @@ static int ocfs2_find_branch_target(struct ocfs2_extent_tree *et,
 		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
 		if (!blkno) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu has extent "
-				    "list where extent # %d has no physical "
-				    "block start",
+				    "Owner %llu has extent list where extent # %d has no physical block start\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci), i);
 			status = -EIO;
 			goto bail;
@@ -1788,8 +1783,7 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 	while (el->l_tree_depth) {
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has empty extent list at "
-				    "depth %u\n",
+				    "Owner %llu has empty extent list at depth %u\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
 				    le16_to_cpu(el->l_tree_depth));
 			ret = -EROFS;
@@ -1814,8 +1808,7 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
 		if (blkno == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has bad blkno in extent list "
-				    "at depth %u (index %d)\n",
+				    "Owner %llu has bad blkno in extent list at depth %u (index %d)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
 				    le16_to_cpu(el->l_tree_depth), i);
 			ret = -EROFS;
@@ -1836,8 +1829,7 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 		if (le16_to_cpu(el->l_next_free_rec) >
 		    le16_to_cpu(el->l_count)) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has bad count in extent list "
-				    "at block %llu (next free=%u, count=%u)\n",
+				    "Owner %llu has bad count in extent list at block %llu (next free=%u, count=%u)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
 				    (unsigned long long)bh->b_blocknr,
 				    le16_to_cpu(el->l_next_free_rec),
@@ -2116,8 +2108,7 @@ static int ocfs2_rotate_subtree_right(handle_t *handle,
 
 	if (left_el->l_next_free_rec != left_el->l_count) {
 		ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-			    "Inode %llu has non-full interior leaf node %llu"
-			    "(next free = %u)",
+			    "Inode %llu has non-full interior leaf node %llu (next free = %u)\n",
 			    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 			    (unsigned long long)left_leaf_bh->b_blocknr,
 			    le16_to_cpu(left_el->l_next_free_rec));
@@ -2256,8 +2247,7 @@ int ocfs2_find_cpos_for_left_leaf(struct super_block *sb,
 		 * If we got here, we never found a valid node where
 		 * the tree indicated one should be.
 		 */
-		ocfs2_error(sb,
-			    "Invalid extent tree at extent block %llu\n",
+		ocfs2_error(sb, "Invalid extent tree at extent block %llu\n",
 			    (unsigned long long)blkno);
 		ret = -EROFS;
 		goto out;
@@ -2872,8 +2862,7 @@ int ocfs2_find_cpos_for_right_leaf(struct super_block *sb,
 		 * If we got here, we never found a valid node where
 		 * the tree indicated one should be.
 		 */
-		ocfs2_error(sb,
-			    "Invalid extent tree at extent block %llu\n",
+		ocfs2_error(sb, "Invalid extent tree at extent block %llu\n",
 			    (unsigned long long)blkno);
 		ret = -EROFS;
 		goto out;
@@ -3199,7 +3188,7 @@ rightmost_no_delete:
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ret = -EIO;
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu has empty extent block at %llu",
+				    "Owner %llu has empty extent block at %llu\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 				    (unsigned long long)le64_to_cpu(eb->h_blkno));
 			goto out;
@@ -3929,7 +3918,7 @@ static void ocfs2_adjust_rightmost_records(handle_t *handle,
 		next_free = le16_to_cpu(el->l_next_free_rec);
 		if (next_free == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu has a bad extent list",
+				    "Owner %llu has a bad extent list\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
 			ret = -EIO;
 			return;
@@ -4351,10 +4340,7 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 				bh = path_leaf_bh(left_path);
 				eb = (struct ocfs2_extent_block *)bh->b_data;
 				ocfs2_error(sb,
-					    "Extent block #%llu has an "
-					    "invalid l_next_free_rec of "
-					    "%d.  It should have "
-					    "matched the l_count of %d",
+					    "Extent block #%llu has an invalid l_next_free_rec of %d.  It should have matched the l_count of %d\n",
 					    (unsigned long long)le64_to_cpu(eb->h_blkno),
 					    le16_to_cpu(new_el->l_next_free_rec),
 					    le16_to_cpu(new_el->l_count));
@@ -4406,8 +4392,7 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 				bh = path_leaf_bh(right_path);
 				eb = (struct ocfs2_extent_block *)bh->b_data;
 				ocfs2_error(sb,
-					    "Extent block #%llu has an "
-					    "invalid l_next_free_rec of %d",
+					    "Extent block #%llu has an invalid l_next_free_rec of %d\n",
 					    (unsigned long long)le64_to_cpu(eb->h_blkno),
 					    le16_to_cpu(new_el->l_next_free_rec));
 				status = -EINVAL;
@@ -4960,10 +4945,9 @@ leftright:
 		split_index = ocfs2_search_extent_list(el, cpos);
 		if (split_index == -1) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-					"Owner %llu has an extent at cpos %u "
-					"which can no longer be found.\n",
-					(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
-					cpos);
+				    "Owner %llu has an extent at cpos %u which can no longer be found\n",
+				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+				    cpos);
 			ret = -EROFS;
 			goto out;
 		}
@@ -5143,10 +5127,9 @@ int ocfs2_change_extent_flag(handle_t *handle,
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1) {
 		ocfs2_error(sb,
-			    "Owner %llu has an extent at cpos %u which can no "
-			    "longer be found.\n",
-			     (unsigned long long)
-			     ocfs2_metadata_cache_owner(et->et_ci), cpos);
+			    "Owner %llu has an extent at cpos %u which can no longer be found\n",
+			    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+			    cpos);
 		ret = -EROFS;
 		goto out;
 	}
@@ -5213,9 +5196,7 @@ int ocfs2_mark_extent_written(struct inode *inode,
 		cpos, len, phys);
 
 	if (!ocfs2_writes_unwritten_extents(OCFS2_SB(inode->i_sb))) {
-		ocfs2_error(inode->i_sb, "Inode %llu has unwritten extents "
-			    "that are being written to, but the feature bit "
-			    "is not set in the super block.",
+		ocfs2_error(inode->i_sb, "Inode %llu has unwritten extents that are being written to, but the feature bit is not set in the super block\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
 		ret = -EROFS;
 		goto out;
@@ -5499,8 +5480,7 @@ int ocfs2_remove_extent(handle_t *handle,
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1) {
 		ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-			    "Owner %llu has an extent at cpos %u which can no "
-			    "longer be found.\n",
+			    "Owner %llu has an extent at cpos %u which can no longer be found\n",
 			    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 			    cpos);
 		ret = -EROFS;
@@ -5565,7 +5545,7 @@ int ocfs2_remove_extent(handle_t *handle,
 		index = ocfs2_search_extent_list(el, cpos);
 		if (index == -1) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu: split at cpos %u lost record.",
+				    "Owner %llu: split at cpos %u lost record\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 				    cpos);
 			ret = -EROFS;
@@ -5581,8 +5561,7 @@ int ocfs2_remove_extent(handle_t *handle,
 			ocfs2_rec_clusters(el, rec);
 		if (rec_range != trunc_range) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu: error after split at cpos %u"
-				    "trunc len %u, existing record is (%u,%u)",
+				    "Owner %llu: error after split at cpos %u trunc len %u, existing record is (%u,%u)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 				    cpos, len, le32_to_cpu(rec->e_cpos),
 				    ocfs2_rec_clusters(el, rec));
@@ -7093,8 +7072,8 @@ start:
 		 * to check it up here before changing the tree.
 		*/
 		if (root_el->l_tree_depth && rec->e_int_clusters == 0) {
-			ocfs2_error(inode->i_sb, "Inode %lu has an empty "
-				    "extent record, depth %u\n", inode->i_ino,
+			ocfs2_error(inode->i_sb, "Inode %lu has an empty extent record, depth %u\n",
+				    inode->i_ino,
 				    le16_to_cpu(root_el->l_tree_depth));
 			status = -EROFS;
 			goto bail;
@@ -7189,8 +7168,7 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
 	    !ocfs2_supports_inline_data(osb)) {
 		ocfs2_error(inode->i_sb,
-			    "Inline data flags for inode %llu don't agree! "
-			    "Disk: 0x%x, Memory: 0x%x, Superblock: 0x%x\n",
+			    "Inline data flags for inode %llu don't agree! Disk: 0x%x, Memory: 0x%x, Superblock: 0x%x\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    le16_to_cpu(di->i_dyn_features),
 			    OCFS2_I(inode)->ip_dyn_features,
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 27ffd4b..d0d1a92 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -227,7 +227,7 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)) {
-		ocfs2_error(inode->i_sb, "Inode %llu lost inline data flag",
+		ocfs2_error(inode->i_sb, "Inode %llu lost inline data flag\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
 		return -EROFS;
 	}
@@ -237,7 +237,7 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 	if (size > PAGE_CACHE_SIZE ||
 	    size > ocfs2_max_inline_data_with_xattr(inode->i_sb, di)) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %llu has with inline data has bad size: %Lu",
+			    "Inode %llu has with inline data has bad size: %Lu\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    (unsigned long long)size);
 		return -EROFS;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 52b9a06..990e8f7 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -481,29 +481,25 @@ static int ocfs2_check_dir_trailer(struct inode *dir, struct buffer_head *bh)
 	trailer = ocfs2_trailer_from_bh(bh, dir->i_sb);
 	if (!OCFS2_IS_VALID_DIR_TRAILER(trailer)) {
 		rc = ocfs2_error(dir->i_sb,
-			    "Invalid dirblock #%llu: "
-			    "signature = %.*s\n",
-			    (unsigned long long)bh->b_blocknr, 7,
-			    trailer->db_signature);
+				 "Invalid dirblock #%llu: signature = %.*s\n",
+				 (unsigned long long)bh->b_blocknr, 7,
+				 trailer->db_signature);
 		goto out;
 	}
 	if (le64_to_cpu(trailer->db_blkno) != bh->b_blocknr) {
 		rc = ocfs2_error(dir->i_sb,
-			    "Directory block #%llu has an invalid "
-			    "db_blkno of %llu",
-			    (unsigned long long)bh->b_blocknr,
-			    (unsigned long long)le64_to_cpu(trailer->db_blkno));
+				 "Directory block #%llu has an invalid db_blkno of %llu\n",
+				 (unsigned long long)bh->b_blocknr,
+				 (unsigned long long)le64_to_cpu(trailer->db_blkno));
 		goto out;
 	}
 	if (le64_to_cpu(trailer->db_parent_dinode) !=
 	    OCFS2_I(dir)->ip_blkno) {
 		rc = ocfs2_error(dir->i_sb,
-			    "Directory block #%llu on dinode "
-			    "#%llu has an invalid parent_dinode "
-			    "of %llu",
-			    (unsigned long long)bh->b_blocknr,
-			    (unsigned long long)OCFS2_I(dir)->ip_blkno,
-			    (unsigned long long)le64_to_cpu(trailer->db_blkno));
+				 "Directory block #%llu on dinode #%llu has an invalid parent_dinode of %llu\n",
+				 (unsigned long long)bh->b_blocknr,
+				 (unsigned long long)OCFS2_I(dir)->ip_blkno,
+				 (unsigned long long)le64_to_cpu(trailer->db_blkno));
 		goto out;
 	}
 out:
@@ -602,9 +598,9 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 
 	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
 		ret = ocfs2_error(sb,
-			    "Dir Index Root # %llu has bad signature %.*s",
-			    (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
-			    7, dx_root->dr_signature);
+				  "Dir Index Root # %llu has bad signature %.*s\n",
+				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+				  7, dx_root->dr_signature);
 	}
 
 	return ret;
@@ -644,8 +640,8 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
 	}
 
 	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
-		ret = ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s",
-			    7, dx_leaf->dl_signature);
+		ret = ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
+				  7, dx_leaf->dl_signature);
 	}
 
 	return ret;
@@ -808,9 +804,9 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in "
-				    "btree tree block %llu\n", inode->i_ino,
-				    (unsigned long long)eb_bh->b_blocknr);
+					  "Inode %lu has non zero tree depth in btree tree block %llu\n",
+					  inode->i_ino,
+					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
 		}
 	}
@@ -826,10 +822,11 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	}
 
 	if (!found) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
-			    "record (%u, %u, 0) in btree", inode->i_ino,
-			    le32_to_cpu(rec->e_cpos),
-			    ocfs2_rec_clusters(el, rec));
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
+				  inode->i_ino,
+				  le32_to_cpu(rec->e_cpos),
+				  ocfs2_rec_clusters(el, rec));
 		goto out;
 	}
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 767370b..e4719e0 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -305,8 +305,8 @@ static int ocfs2_last_eb_is_empty(struct inode *inode,
 
 	if (el->l_tree_depth) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %lu has non zero tree depth in "
-			    "leaf block %llu\n", inode->i_ino,
+			    "Inode %lu has non zero tree depth in leaf block %llu\n",
+			    inode->i_ino,
 			    (unsigned long long)eb_bh->b_blocknr);
 		ret = -EROFS;
 		goto out;
@@ -441,8 +441,8 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in "
-				    "leaf block %llu\n", inode->i_ino,
+				    "Inode %lu has non zero tree depth in leaf block %llu\n",
+				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
 			goto out;
@@ -475,8 +475,9 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 	BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos));
 
 	if (!rec->e_blkno) {
-		ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
-			    "record (%u, %u, 0)", inode->i_ino,
+		ocfs2_error(inode->i_sb,
+			    "Inode %lu has bad extent record (%u, %u, 0)\n",
+			    inode->i_ino,
 			    le32_to_cpu(rec->e_cpos),
 			    ocfs2_rec_clusters(el, rec));
 		ret = -EROFS;
@@ -564,8 +565,8 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in "
-				    "xattr leaf block %llu\n", inode->i_ino,
+				    "Inode %lu has non zero tree depth in xattr leaf block %llu\n",
+				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
 			goto out;
@@ -582,8 +583,9 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 		BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos));
 
 		if (!rec->e_blkno) {
-			ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
-				    "record (%u, %u, 0) in xattr", inode->i_ino,
+			ocfs2_error(inode->i_sb,
+				    "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
+				    inode->i_ino,
 				    le32_to_cpu(rec->e_cpos),
 				    ocfs2_rec_clusters(el, rec));
 			ret = -EROFS;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index d608b0d..4399de3c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1353,31 +1353,31 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 
 	if (!OCFS2_IS_VALID_DINODE(di)) {
 		rc = ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
-			    (unsigned long long)bh->b_blocknr, 7,
-			    di->i_signature);
+				 (unsigned long long)bh->b_blocknr, 7,
+				 di->i_signature);
 		goto bail;
 	}
 
 	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
 		rc = ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
-			    (unsigned long long)bh->b_blocknr,
-			    (unsigned long long)le64_to_cpu(di->i_blkno));
+				 (unsigned long long)bh->b_blocknr,
+				 (unsigned long long)le64_to_cpu(di->i_blkno));
 		goto bail;
 	}
 
 	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
 		rc = ocfs2_error(sb,
-			    "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
-			    (unsigned long long)bh->b_blocknr);
+				 "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
+				 (unsigned long long)bh->b_blocknr);
 		goto bail;
 	}
 
 	if (le32_to_cpu(di->i_fs_generation) !=
 	    OCFS2_SB(sb)->fs_generation) {
 		rc = ocfs2_error(sb,
-			    "Invalid dinode #%llu: fs_generation is %u\n",
-			    (unsigned long long)bh->b_blocknr,
-			    le32_to_cpu(di->i_fs_generation));
+				 "Invalid dinode #%llu: fs_generation is %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le32_to_cpu(di->i_fs_generation));
 		goto bail;
 	}
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ff53192..489da528 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -374,7 +374,7 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 		mlog_errno(PTR_ERR(handle));
 
 		if (is_journal_aborted(journal)) {
-			ocfs2_abort(osb->sb, "Detected aborted journal");
+			ocfs2_abort(osb->sb, "Detected aborted journal\n");
 			handle = ERR_PTR(-EROFS);
 		}
 	} else {
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 857bbbc..0a4457f 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -665,8 +665,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 #ifdef CONFIG_OCFS2_DEBUG_FS
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
 	    ocfs2_local_alloc_count_bits(alloc)) {
-		ocfs2_error(osb->sb, "local alloc inode %llu says it has "
-			    "%u used bits, but a count shows %u",
+		ocfs2_error(osb->sb, "local alloc inode %llu says it has %u used bits, but a count shows %u\n",
 			    (unsigned long long)le64_to_cpu(alloc->i_blkno),
 			    le32_to_cpu(alloc->id1.bitmap1.i_used),
 			    ocfs2_local_alloc_count_bits(alloc));
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 70dd0ec..124471d 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -100,9 +100,8 @@ static int __ocfs2_move_extent(handle_t *handle,
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1) {
 		ret = ocfs2_error(inode->i_sb,
-			    "Inode %llu has an extent at cpos %u which can no "
-			    "longer be found.\n",
-			    (unsigned long long)ino, cpos);
+				  "Inode %llu has an extent at cpos %u which can no longer be found\n",
+				  (unsigned long long)ino, cpos);
 		goto out;
 	}
 
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 3d0b63d..964b727 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -138,8 +138,7 @@ static int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 
 	if (i_size_read(inode) >> inode->i_sb->s_blocksize_bits <= v_block) {
 		ocfs2_error(inode->i_sb,
-			    "Quota file %llu is probably corrupted! Requested "
-			    "to read block %Lu but file has size only %Lu\n",
+			    "Quota file %llu is probably corrupted! Requested to read block %Lu but file has size only %Lu\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    (unsigned long long)v_block,
 			    (unsigned long long)i_size_read(inode));
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index b001516..259e52d 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -103,27 +103,25 @@ static int ocfs2_validate_refcount_block(struct super_block *sb,
 
 	if (!OCFS2_IS_VALID_REFCOUNT_BLOCK(rb)) {
 		rc = ocfs2_error(sb,
-			    "Refcount block #%llu has bad signature %.*s",
-			    (unsigned long long)bh->b_blocknr, 7,
-			    rb->rf_signature);
+				 "Refcount block #%llu has bad signature %.*s\n",
+				 (unsigned long long)bh->b_blocknr, 7,
+				 rb->rf_signature);
 		goto out;
 	}
 
 	if (le64_to_cpu(rb->rf_blkno) != bh->b_blocknr) {
 		rc = ocfs2_error(sb,
-			    "Refcount block #%llu has an invalid rf_blkno "
-			    "of %llu",
-			    (unsigned long long)bh->b_blocknr,
-			    (unsigned long long)le64_to_cpu(rb->rf_blkno));
+				 "Refcount block #%llu has an invalid rf_blkno of %llu\n",
+				 (unsigned long long)bh->b_blocknr,
+				 (unsigned long long)le64_to_cpu(rb->rf_blkno));
 		goto out;
 	}
 
 	if (le32_to_cpu(rb->rf_fs_generation) != OCFS2_SB(sb)->fs_generation) {
 		rc = ocfs2_error(sb,
-			    "Refcount block #%llu has an invalid "
-			    "rf_fs_generation of #%u",
-			    (unsigned long long)bh->b_blocknr,
-			    le32_to_cpu(rb->rf_fs_generation));
+				 "Refcount block #%llu has an invalid rf_fs_generation of #%u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le32_to_cpu(rb->rf_fs_generation));
 		goto out;
 	}
 out:
@@ -1103,10 +1101,9 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(sb,
-				"refcount tree %llu has non zero tree "
-				"depth in leaf btree tree block %llu\n",
-				(unsigned long long)ocfs2_metadata_cache_owner(ci),
-				(unsigned long long)eb_bh->b_blocknr);
+					  "refcount tree %llu has non zero tree depth in leaf btree tree block %llu\n",
+					  (unsigned long long)ocfs2_metadata_cache_owner(ci),
+					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
 		}
 	}
@@ -2360,9 +2357,8 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
 					   cpos, len, phys);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
-			    "tree, but the feature bit is not set in the "
-			    "super block.", inode->i_ino);
+		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
+				  inode->i_ino);
 		goto out;
 	}
 
@@ -2545,9 +2541,8 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
-			    "tree, but the feature bit is not set in the "
-			    "super block.", inode->i_ino);
+		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
+				  inode->i_ino);
 		goto out;
 	}
 
@@ -2672,9 +2667,9 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in "
-				    "leaf block %llu\n", inode->i_ino,
-				    (unsigned long long)eb_bh->b_blocknr);
+					  "Inode %lu has non zero tree depth in leaf block %llu\n",
+					  inode->i_ino,
+					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
 		}
 	}
@@ -3105,9 +3100,8 @@ static int ocfs2_clear_ext_refcount(handle_t *handle,
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1) {
 		ret = ocfs2_error(sb,
-			    "Inode %llu has an extent at cpos %u which can no "
-			    "longer be found.\n",
-			    (unsigned long long)ino, cpos);
+				  "Inode %llu has an extent at cpos %u which can no longer be found\n",
+				  (unsigned long long)ino, cpos);
 		goto out;
 	}
 
@@ -3373,9 +3367,8 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		return ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
-			    "tree, but the feature bit is not set in the "
-			    "super block.", inode->i_ino);
+		return ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
+				   inode->i_ino);
 	}
 
 	ocfs2_init_dealloc_ctxt(&context->dealloc);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index e4bb001..0456ae3 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -167,12 +167,12 @@ static u32 ocfs2_bits_per_group(struct ocfs2_chain_list *cl)
 }
 
 #define do_error(fmt, ...)						\
-	do{								\
-		if (resize)					\
-			mlog(ML_ERROR, fmt "\n", ##__VA_ARGS__);	\
-		else							\
-			return ocfs2_error(sb, fmt, ##__VA_ARGS__);		\
-	} while (0)
+do {									\
+	if (resize)							\
+		mlog(ML_ERROR, fmt, ##__VA_ARGS__);			\
+	else								\
+		return ocfs2_error(sb, fmt, ##__VA_ARGS__);		\
+} while (0)
 
 static int ocfs2_validate_gd_self(struct super_block *sb,
 				  struct buffer_head *bh,
@@ -181,36 +181,32 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
 	if (!OCFS2_IS_VALID_GROUP_DESC(gd)) {
-		do_error("Group descriptor #%llu has bad signature %.*s",
+		do_error("Group descriptor #%llu has bad signature %.*s\n",
 			 (unsigned long long)bh->b_blocknr, 7,
 			 gd->bg_signature);
 	}
 
 	if (le64_to_cpu(gd->bg_blkno) != bh->b_blocknr) {
-		do_error("Group descriptor #%llu has an invalid bg_blkno "
-			 "of %llu",
+		do_error("Group descriptor #%llu has an invalid bg_blkno of %llu\n",
 			 (unsigned long long)bh->b_blocknr,
 			 (unsigned long long)le64_to_cpu(gd->bg_blkno));
 	}
 
 	if (le32_to_cpu(gd->bg_generation) != OCFS2_SB(sb)->fs_generation) {
-		do_error("Group descriptor #%llu has an invalid "
-			 "fs_generation of #%u",
+		do_error("Group descriptor #%llu has an invalid fs_generation of #%u\n",
 			 (unsigned long long)bh->b_blocknr,
 			 le32_to_cpu(gd->bg_generation));
 	}
 
 	if (le16_to_cpu(gd->bg_free_bits_count) > le16_to_cpu(gd->bg_bits)) {
-		do_error("Group descriptor #%llu has bit count %u but "
-			 "claims that %u are free",
+		do_error("Group descriptor #%llu has bit count %u but claims that %u are free\n",
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits),
 			 le16_to_cpu(gd->bg_free_bits_count));
 	}
 
 	if (le16_to_cpu(gd->bg_bits) > (8 * le16_to_cpu(gd->bg_size))) {
-		do_error("Group descriptor #%llu has bit count %u but "
-			 "max bitmap bits of %u",
+		do_error("Group descriptor #%llu has bit count %u but max bitmap bits of %u\n",
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits),
 			 8 * le16_to_cpu(gd->bg_size));
@@ -228,8 +224,7 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
 	if (di->i_blkno != gd->bg_parent_dinode) {
-		do_error("Group descriptor #%llu has bad parent "
-			 "pointer (%llu, expected %llu)",
+		do_error("Group descriptor #%llu has bad parent pointer (%llu, expected %llu)\n",
 			 (unsigned long long)bh->b_blocknr,
 			 (unsigned long long)le64_to_cpu(gd->bg_parent_dinode),
 			 (unsigned long long)le64_to_cpu(di->i_blkno));
@@ -237,7 +232,7 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
 
 	max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) * le16_to_cpu(di->id2.i_chain.cl_bpc);
 	if (le16_to_cpu(gd->bg_bits) > max_bits) {
-		do_error("Group descriptor #%llu has bit count of %u",
+		do_error("Group descriptor #%llu has bit count of %u\n",
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits));
 	}
@@ -247,7 +242,7 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
 	     le16_to_cpu(di->id2.i_chain.cl_next_free_rec)) ||
 	    ((le16_to_cpu(gd->bg_chain) ==
 	     le16_to_cpu(di->id2.i_chain.cl_next_free_rec)) && !resize)) {
-		do_error("Group descriptor #%llu has bad chain %u",
+		do_error("Group descriptor #%llu has bad chain %u\n",
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_chain));
 	}
@@ -376,10 +371,10 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	struct super_block * sb = alloc_inode->i_sb;
 
 	if (((unsigned long long) bg_bh->b_blocknr) != group_blkno) {
-		status = ocfs2_error(alloc_inode->i_sb, "group block (%llu) != "
-			    "b_blocknr (%llu)",
-			    (unsigned long long)group_blkno,
-			    (unsigned long long) bg_bh->b_blocknr);
+		status = ocfs2_error(alloc_inode->i_sb,
+				     "group block (%llu) != b_blocknr (%llu)\n",
+				     (unsigned long long)group_blkno,
+				     (unsigned long long) bg_bh->b_blocknr);
 		goto bail;
 	}
 
@@ -825,8 +820,9 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
 
 	if (!(fe->i_flags & cpu_to_le32(OCFS2_CHAIN_FL))) {
-		status = ocfs2_error(alloc_inode->i_sb, "Invalid chain allocator %llu",
-			    (unsigned long long)le64_to_cpu(fe->i_blkno));
+		status = ocfs2_error(alloc_inode->i_sb,
+				     "Invalid chain allocator %llu\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno));
 		goto bail;
 	}
 
@@ -1360,11 +1356,11 @@ int ocfs2_block_group_set_bits(handle_t *handle,
 
 	le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
 	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
-		return ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
-			    " count %u but claims %u are freed. num_bits %d",
-			    (unsigned long long)le64_to_cpu(bg->bg_blkno),
-			    le16_to_cpu(bg->bg_bits),
-			    le16_to_cpu(bg->bg_free_bits_count), num_bits);
+		return ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit count %u but claims %u are freed. num_bits %d\n",
+				   (unsigned long long)le64_to_cpu(bg->bg_blkno),
+				   le16_to_cpu(bg->bg_bits),
+				   le16_to_cpu(bg->bg_free_bits_count),
+				   num_bits);
 	}
 	while(num_bits--)
 		ocfs2_set_bit(bit_off++, bitmap);
@@ -1895,11 +1891,10 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	if (le32_to_cpu(fe->id1.bitmap1.i_used) >=
 	    le32_to_cpu(fe->id1.bitmap1.i_total)) {
 		status = ocfs2_error(ac->ac_inode->i_sb,
-			    "Chain allocator dinode %llu has %u used "
-			    "bits but only %u total.",
-			    (unsigned long long)le64_to_cpu(fe->i_blkno),
-			    le32_to_cpu(fe->id1.bitmap1.i_used),
-			    le32_to_cpu(fe->id1.bitmap1.i_total));
+				     "Chain allocator dinode %llu has %u used bits but only %u total\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno),
+				     le32_to_cpu(fe->id1.bitmap1.i_used),
+				     le32_to_cpu(fe->id1.bitmap1.i_total));
 		goto bail;
 	}
 
@@ -2417,11 +2412,11 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 	}
 	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
 	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
-		return ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
-			    " count %u but claims %u are freed. num_bits %d",
-			    (unsigned long long)le64_to_cpu(bg->bg_blkno),
-			    le16_to_cpu(bg->bg_bits),
-			    le16_to_cpu(bg->bg_free_bits_count), num_bits);
+		return ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit count %u but claims %u are freed. num_bits %d\n",
+				   (unsigned long long)le64_to_cpu(bg->bg_blkno),
+				   le16_to_cpu(bg->bg_bits),
+				   le16_to_cpu(bg->bg_free_bits_count),
+				   num_bits);
 	}
 
 	if (undo_fn)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 3ee15b3..6088435 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2606,7 +2606,7 @@ int __ocfs2_error(struct super_block *sb, const char *function,
 
 	/* Not using mlog here because we want to show the actual
 	 * function the error came from. */
-	printk(KERN_CRIT "OCFS2: ERROR (device %s): %s: %pV\n",
+	printk(KERN_CRIT "OCFS2: ERROR (device %s): %s: %pV",
 	       sb->s_id, function, &vaf);
 
 	va_end(args);
@@ -2628,7 +2628,7 @@ void __ocfs2_abort(struct super_block *sb, const char *function,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk(KERN_CRIT "OCFS2: abort (device %s): %s: %pV\n",
+	printk(KERN_CRIT "OCFS2: abort (device %s): %s: %pV",
 	       sb->s_id, function, &vaf);
 
 	va_end(args);
diff --git a/fs/ocfs2/super.h b/fs/ocfs2/super.h
index c1c87d9..b477d0b 100644
--- a/fs/ocfs2/super.h
+++ b/fs/ocfs2/super.h
@@ -35,13 +35,15 @@ __printf(3, 4)
 int __ocfs2_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
 
-#define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##args)
+#define ocfs2_error(sb, fmt, ...)					\
+	__ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##__VA_ARGS__)
 
 __printf(3, 4)
 void __ocfs2_abort(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
 
-#define ocfs2_abort(sb, fmt, args...) __ocfs2_abort(sb, __PRETTY_FUNCTION__, fmt, ##args)
+#define ocfs2_abort(sb, fmt, ...)					\
+	__ocfs2_abort(sb, __PRETTY_FUNCTION__, fmt, ##__VA_ARGS__)
 
 /*
  * Void signal blockers, because in-kernel sigprocmask() only fails
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index aabccb1..ba4318e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -500,26 +500,23 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 
 	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
 		return ocfs2_error(sb,
-			    "Extended attribute block #%llu has bad "
-			    "signature %.*s",
-			    (unsigned long long)bh->b_blocknr, 7,
-			    xb->xb_signature);
+				   "Extended attribute block #%llu has bad signature %.*s\n",
+				   (unsigned long long)bh->b_blocknr, 7,
+				   xb->xb_signature);
 	}
 
 	if (le64_to_cpu(xb->xb_blkno) != bh->b_blocknr) {
 		return ocfs2_error(sb,
-			    "Extended attribute block #%llu has an "
-			    "invalid xb_blkno of %llu",
-			    (unsigned long long)bh->b_blocknr,
-			    (unsigned long long)le64_to_cpu(xb->xb_blkno));
+				   "Extended attribute block #%llu has an invalid xb_blkno of %llu\n",
+				   (unsigned long long)bh->b_blocknr,
+				   (unsigned long long)le64_to_cpu(xb->xb_blkno));
 	}
 
 	if (le32_to_cpu(xb->xb_fs_generation) != OCFS2_SB(sb)->fs_generation) {
 		return ocfs2_error(sb,
-			    "Extended attribute block #%llu has an invalid "
-			    "xb_fs_generation of #%u",
-			    (unsigned long long)bh->b_blocknr,
-			    le32_to_cpu(xb->xb_fs_generation));
+				   "Extended attribute block #%llu has an invalid xb_fs_generation of #%u\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le32_to_cpu(xb->xb_fs_generation));
 	}
 
 	return 0;
@@ -3692,9 +3689,9 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in "
-				    "xattr tree block %llu\n", inode->i_ino,
-				    (unsigned long long)eb_bh->b_blocknr);
+					  "Inode %lu has non zero tree depth in xattr tree block %llu\n",
+					  inode->i_ino,
+					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
 		}
 	}
@@ -3709,10 +3706,10 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 	}
 
 	if (!e_blkno) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
-			    "record (%u, %u, 0) in xattr", inode->i_ino,
-			    le32_to_cpu(rec->e_cpos),
-			    ocfs2_rec_clusters(el, rec));
+		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
+				  inode->i_ino,
+				  le32_to_cpu(rec->e_cpos),
+				  ocfs2_rec_clusters(el, rec));
 		goto out;
 	}
 
-- 
2.1.2
