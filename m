From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 3 Mar 2015 12:08:43 -0600
Subject: [Ocfs2-devel] [PATCH 2/3] Acknowledge return value of ocfs2_error
Message-ID: <20150303180842.GA13141@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Caveat: This may return -EROFS for a read case, which seems wrong.
This is happening even without this patch series though.
Should we convert EROFS to EIO?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/alloc.c        | 16 ++++++++--------
 fs/ocfs2/dir.c          | 25 +++++++++----------------
 fs/ocfs2/inode.c        |  8 ++++----
 fs/ocfs2/move_extents.c |  3 +--
 fs/ocfs2/refcounttree.c | 42 ++++++++++++++++++------------------------
 fs/ocfs2/suballoc.c     | 25 ++++++-------------------
 fs/ocfs2/xattr.c        | 15 +++++----------
 7 files changed, 51 insertions(+), 83 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 044158b..df64f76 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -908,32 +908,32 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
 	 */
 
 	if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
-		ocfs2_error(sb,
+		rc = ocfs2_error(sb,
 			    "Extent block #%llu has bad signature %.*s",
 			    (unsigned long long)bh->b_blocknr, 7,
 			    eb->h_signature);
-		return -EINVAL;
+		goto bail;
 	}
 
 	if (le64_to_cpu(eb->h_blkno) != bh->b_blocknr) {
-		ocfs2_error(sb,
+		rc = ocfs2_error(sb,
 			    "Extent block #%llu has an invalid h_blkno "
 			    "of %llu",
 			    (unsigned long long)bh->b_blocknr,
 			    (unsigned long long)le64_to_cpu(eb->h_blkno));
-		return -EINVAL;
+		goto bail;
 	}
 
 	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation) {
-		ocfs2_error(sb,
+		rc = ocfs2_error(sb,
 			    "Extent block #%llu has an invalid "
 			    "h_fs_generation of #%u",
 			    (unsigned long long)bh->b_blocknr,
 			    le32_to_cpu(eb->h_fs_generation));
-		return -EINVAL;
+		goto bail;
 	}
-
-	return 0;
+bail:
+	return rc;
 }
 
 int ocfs2_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index b08050b..c9c4715 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -480,8 +480,7 @@ static int ocfs2_check_dir_trailer(struct inode *dir, struct buffer_head *bh)
 
 	trailer = ocfs2_trailer_from_bh(bh, dir->i_sb);
 	if (!OCFS2_IS_VALID_DIR_TRAILER(trailer)) {
-		rc = -EINVAL;
-		ocfs2_error(dir->i_sb,
+		rc = ocfs2_error(dir->i_sb,
 			    "Invalid dirblock #%llu: "
 			    "signature = %.*s\n",
 			    (unsigned long long)bh->b_blocknr, 7,
@@ -489,8 +488,7 @@ static int ocfs2_check_dir_trailer(struct inode *dir, struct buffer_head *bh)
 		goto out;
 	}
 	if (le64_to_cpu(trailer->db_blkno) != bh->b_blocknr) {
-		rc = -EINVAL;
-		ocfs2_error(dir->i_sb,
+		rc = ocfs2_error(dir->i_sb,
 			    "Directory block #%llu has an invalid "
 			    "db_blkno of %llu",
 			    (unsigned long long)bh->b_blocknr,
@@ -499,8 +497,7 @@ static int ocfs2_check_dir_trailer(struct inode *dir, struct buffer_head *bh)
 	}
 	if (le64_to_cpu(trailer->db_parent_dinode) !=
 	    OCFS2_I(dir)->ip_blkno) {
-		rc = -EINVAL;
-		ocfs2_error(dir->i_sb,
+		rc = ocfs2_error(dir->i_sb,
 			    "Directory block #%llu on dinode "
 			    "#%llu has an invalid parent_dinode "
 			    "of %llu",
@@ -604,14 +601,13 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 	}
 
 	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
-		ocfs2_error(sb,
+		ret = ocfs2_error(sb,
 			    "Dir Index Root # %llu has bad signature %.*s",
 			    (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
 			    7, dx_root->dr_signature);
-		return -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int ocfs2_read_dx_root(struct inode *dir, struct ocfs2_dinode *di,
@@ -648,12 +644,11 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
 	}
 
 	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
-		ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s",
+		ret = ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s",
 			    7, dx_leaf->dl_signature);
-		return -EROFS;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int ocfs2_read_dx_leaf(struct inode *dir, u64 blkno,
@@ -812,11 +807,10 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 		el = &eb->h_list;
 
 		if (el->l_tree_depth) {
-			ocfs2_error(inode->i_sb,
+			ret = ocfs2_error(inode->i_sb,
 				    "Inode %lu has non zero tree depth in "
 				    "btree tree block %llu\n", inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
-			ret = -EROFS;
 			goto out;
 		}
 	}
@@ -832,11 +826,10 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	}
 
 	if (!found) {
-		ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
+		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
 			    "record (%u, %u, 0) in btree", inode->i_ino,
 			    le32_to_cpu(rec->e_cpos),
 			    ocfs2_rec_clusters(el, rec));
-		ret = -EROFS;
 		goto out;
 	}
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 3025c0d..0e908d1 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1350,21 +1350,21 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	rc = -EINVAL;
 
 	if (!OCFS2_IS_VALID_DINODE(di)) {
-		ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
+		rc = ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
 			    (unsigned long long)bh->b_blocknr, 7,
 			    di->i_signature);
 		goto bail;
 	}
 
 	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
-		ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
+		rc = ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
 			    (unsigned long long)bh->b_blocknr,
 			    (unsigned long long)le64_to_cpu(di->i_blkno));
 		goto bail;
 	}
 
 	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
-		ocfs2_error(sb,
+		rc = ocfs2_error(sb,
 			    "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
 			    (unsigned long long)bh->b_blocknr);
 		goto bail;
@@ -1372,7 +1372,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 
 	if (le32_to_cpu(di->i_fs_generation) !=
 	    OCFS2_SB(sb)->fs_generation) {
-		ocfs2_error(sb,
+		rc = ocfs2_error(sb,
 			    "Invalid dinode #%llu: fs_generation is %u\n",
 			    (unsigned long long)bh->b_blocknr,
 			    le32_to_cpu(di->i_fs_generation));
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 56a768d..70dd0ec 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -99,11 +99,10 @@ static int __ocfs2_move_extent(handle_t *handle,
 
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1) {
-		ocfs2_error(inode->i_sb,
+		ret = ocfs2_error(inode->i_sb,
 			    "Inode %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
 			    (unsigned long long)ino, cpos);
-		ret = -EROFS;
 		goto out;
 	}
 
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index ee541f9..204b448 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -102,32 +102,32 @@ static int ocfs2_validate_refcount_block(struct super_block *sb,
 
 
 	if (!OCFS2_IS_VALID_REFCOUNT_BLOCK(rb)) {
-		ocfs2_error(sb,
+		rc = ocfs2_error(sb,
 			    "Refcount block #%llu has bad signature %.*s",
 			    (unsigned long long)bh->b_blocknr, 7,
 			    rb->rf_signature);
-		return -EINVAL;
+		goto out;
 	}
 
 	if (le64_to_cpu(rb->rf_blkno) != bh->b_blocknr) {
-		ocfs2_error(sb,
+		rc = ocfs2_error(sb,
 			    "Refcount block #%llu has an invalid rf_blkno "
 			    "of %llu",
 			    (unsigned long long)bh->b_blocknr,
 			    (unsigned long long)le64_to_cpu(rb->rf_blkno));
-		return -EINVAL;
+		goto out;
 	}
 
 	if (le32_to_cpu(rb->rf_fs_generation) != OCFS2_SB(sb)->fs_generation) {
-		ocfs2_error(sb,
+		rc = ocfs2_error(sb,
 			    "Refcount block #%llu has an invalid "
 			    "rf_fs_generation of #%u",
 			    (unsigned long long)bh->b_blocknr,
 			    le32_to_cpu(rb->rf_fs_generation));
-		return -EINVAL;
+		goto out;
 	}
-
-	return 0;
+out:
+	return rc;
 }
 
 static int ocfs2_read_refcount_block(struct ocfs2_caching_info *ci,
@@ -1102,12 +1102,11 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
 		el = &eb->h_list;
 
 		if (el->l_tree_depth) {
-			ocfs2_error(sb,
-			"refcount tree %llu has non zero tree "
-			"depth in leaf btree tree block %llu\n",
-			(unsigned long long)ocfs2_metadata_cache_owner(ci),
-			(unsigned long long)eb_bh->b_blocknr);
-			ret = -EROFS;
+			ret = ocfs2_error(sb,
+				"refcount tree %llu has non zero tree "
+				"depth in leaf btree tree block %llu\n",
+				(unsigned long long)ocfs2_metadata_cache_owner(ci),
+				(unsigned long long)eb_bh->b_blocknr);
 			goto out;
 		}
 	}
@@ -2361,10 +2360,9 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
 					   cpos, len, phys);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
+		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
 			    "tree, but the feature bit is not set in the "
 			    "super block.", inode->i_ino);
-		ret = -EROFS;
 		goto out;
 	}
 
@@ -2547,10 +2545,9 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
+		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
 			    "tree, but the feature bit is not set in the "
 			    "super block.", inode->i_ino);
-		ret = -EROFS;
 		goto out;
 	}
 
@@ -2674,11 +2671,10 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 		el = &eb->h_list;
 
 		if (el->l_tree_depth) {
-			ocfs2_error(inode->i_sb,
+			ret = ocfs2_error(inode->i_sb,
 				    "Inode %lu has non zero tree depth in "
 				    "leaf block %llu\n", inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
-			ret = -EROFS;
 			goto out;
 		}
 	}
@@ -3108,11 +3104,10 @@ static int ocfs2_clear_ext_refcount(handle_t *handle,
 
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1) {
-		ocfs2_error(sb,
+		ret = ocfs2_error(sb,
 			    "Inode %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
 			    (unsigned long long)ino, cpos);
-		ret = -EROFS;
 		goto out;
 	}
 
@@ -3378,10 +3373,9 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
+		return ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
 			    "tree, but the feature bit is not set in the "
 			    "super block.", inode->i_ino);
-		return -EROFS;
 	}
 
 	ocfs2_init_dealloc_ctxt(&context->dealloc);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 0cb889a..6e47232 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -171,7 +171,7 @@ static u32 ocfs2_bits_per_group(struct ocfs2_chain_list *cl)
 		if (resize)					\
 			mlog(ML_ERROR, fmt "\n", ##__VA_ARGS__);	\
 		else							\
-			ocfs2_error(sb, fmt, ##__VA_ARGS__);		\
+			return ocfs2_error(sb, fmt, ##__VA_ARGS__);		\
 	} while (0)
 
 static int ocfs2_validate_gd_self(struct super_block *sb,
@@ -184,7 +184,6 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
 		do_error("Group descriptor #%llu has bad signature %.*s",
 			 (unsigned long long)bh->b_blocknr, 7,
 			 gd->bg_signature);
-		return -EINVAL;
 	}
 
 	if (le64_to_cpu(gd->bg_blkno) != bh->b_blocknr) {
@@ -192,7 +191,6 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
 			 "of %llu",
 			 (unsigned long long)bh->b_blocknr,
 			 (unsigned long long)le64_to_cpu(gd->bg_blkno));
-		return -EINVAL;
 	}
 
 	if (le32_to_cpu(gd->bg_generation) != OCFS2_SB(sb)->fs_generation) {
@@ -200,7 +198,6 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
 			 "fs_generation of #%u",
 			 (unsigned long long)bh->b_blocknr,
 			 le32_to_cpu(gd->bg_generation));
-		return -EINVAL;
 	}
 
 	if (le16_to_cpu(gd->bg_free_bits_count) > le16_to_cpu(gd->bg_bits)) {
@@ -209,7 +206,6 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits),
 			 le16_to_cpu(gd->bg_free_bits_count));
-		return -EINVAL;
 	}
 
 	if (le16_to_cpu(gd->bg_bits) > (8 * le16_to_cpu(gd->bg_size))) {
@@ -218,7 +214,6 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits),
 			 8 * le16_to_cpu(gd->bg_size));
-		return -EINVAL;
 	}
 
 	return 0;
@@ -238,7 +233,6 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
 			 (unsigned long long)bh->b_blocknr,
 			 (unsigned long long)le64_to_cpu(gd->bg_parent_dinode),
 			 (unsigned long long)le64_to_cpu(di->i_blkno));
-		return -EINVAL;
 	}
 
 	max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) * le16_to_cpu(di->id2.i_chain.cl_bpc);
@@ -246,7 +240,6 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
 		do_error("Group descriptor #%llu has bit count of %u",
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits));
-		return -EINVAL;
 	}
 
 	/* In resize, we may meet the case bg_chain == cl_next_free_rec. */
@@ -257,7 +250,6 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
 		do_error("Group descriptor #%llu has bad chain %u",
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_chain));
-		return -EINVAL;
 	}
 
 	return 0;
@@ -384,11 +376,10 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	struct super_block * sb = alloc_inode->i_sb;
 
 	if (((unsigned long long) bg_bh->b_blocknr) != group_blkno) {
-		ocfs2_error(alloc_inode->i_sb, "group block (%llu) != "
+		status = ocfs2_error(alloc_inode->i_sb, "group block (%llu) != "
 			    "b_blocknr (%llu)",
 			    (unsigned long long)group_blkno,
 			    (unsigned long long) bg_bh->b_blocknr);
-		status = -EIO;
 		goto bail;
 	}
 
@@ -834,9 +825,8 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
 
 	if (!(fe->i_flags & cpu_to_le32(OCFS2_CHAIN_FL))) {
-		ocfs2_error(alloc_inode->i_sb, "Invalid chain allocator %llu",
+		status = ocfs2_error(alloc_inode->i_sb, "Invalid chain allocator %llu",
 			    (unsigned long long)le64_to_cpu(fe->i_blkno));
-		status = -EIO;
 		goto bail;
 	}
 
@@ -1370,12 +1360,11 @@ int ocfs2_block_group_set_bits(handle_t *handle,
 
 	le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
 	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
-		ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
+		return ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
 			    " count %u but claims %u are freed. num_bits %d",
 			    (unsigned long long)le64_to_cpu(bg->bg_blkno),
 			    le16_to_cpu(bg->bg_bits),
 			    le16_to_cpu(bg->bg_free_bits_count), num_bits);
-		return -EROFS;
 	}
 	while(num_bits--)
 		ocfs2_set_bit(bit_off++, bitmap);
@@ -1905,13 +1894,12 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 
 	if (le32_to_cpu(fe->id1.bitmap1.i_used) >=
 	    le32_to_cpu(fe->id1.bitmap1.i_total)) {
-		ocfs2_error(ac->ac_inode->i_sb,
+		status = ocfs2_error(ac->ac_inode->i_sb,
 			    "Chain allocator dinode %llu has %u used "
 			    "bits but only %u total.",
 			    (unsigned long long)le64_to_cpu(fe->i_blkno),
 			    le32_to_cpu(fe->id1.bitmap1.i_used),
 			    le32_to_cpu(fe->id1.bitmap1.i_total));
-		status = -EIO;
 		goto bail;
 	}
 
@@ -2429,12 +2417,11 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 	}
 	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
 	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
-		ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
+		return ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
 			    " count %u but claims %u are freed. num_bits %d",
 			    (unsigned long long)le64_to_cpu(bg->bg_blkno),
 			    le16_to_cpu(bg->bg_bits),
 			    le16_to_cpu(bg->bg_free_bits_count), num_bits);
-		return -EROFS;
 	}
 
 	if (undo_fn)
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 85b190d..7987b40 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -499,30 +499,27 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 	 */
 
 	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
-		ocfs2_error(sb,
+		return ocfs2_error(sb,
 			    "Extended attribute block #%llu has bad "
 			    "signature %.*s",
 			    (unsigned long long)bh->b_blocknr, 7,
 			    xb->xb_signature);
-		return -EINVAL;
 	}
 
 	if (le64_to_cpu(xb->xb_blkno) != bh->b_blocknr) {
-		ocfs2_error(sb,
+		return ocfs2_error(sb,
 			    "Extended attribute block #%llu has an "
 			    "invalid xb_blkno of %llu",
 			    (unsigned long long)bh->b_blocknr,
 			    (unsigned long long)le64_to_cpu(xb->xb_blkno));
-		return -EINVAL;
 	}
 
 	if (le32_to_cpu(xb->xb_fs_generation) != OCFS2_SB(sb)->fs_generation) {
-		ocfs2_error(sb,
+		return ocfs2_error(sb,
 			    "Extended attribute block #%llu has an invalid "
 			    "xb_fs_generation of #%u",
 			    (unsigned long long)bh->b_blocknr,
 			    le32_to_cpu(xb->xb_fs_generation));
-		return -EINVAL;
 	}
 
 	return 0;
@@ -3690,11 +3687,10 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 		el = &eb->h_list;
 
 		if (el->l_tree_depth) {
-			ocfs2_error(inode->i_sb,
+			ret = ocfs2_error(inode->i_sb,
 				    "Inode %lu has non zero tree depth in "
 				    "xattr tree block %llu\n", inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
-			ret = -EROFS;
 			goto out;
 		}
 	}
@@ -3709,11 +3705,10 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 	}
 
 	if (!e_blkno) {
-		ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
+		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
 			    "record (%u, %u, 0) in xattr", inode->i_ino,
 			    le32_to_cpu(rec->e_cpos),
 			    ocfs2_rec_clusters(el, rec));
-		ret = -EROFS;
 		goto out;
 	}
 
-- 
2.1.4
