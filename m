From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 11 May 2010 16:10:46 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] Ocfs2: Optimize truncting codes for ocfs2
	to use ocfs2_remove_btree_range instead.
In-Reply-To: <1273565449-24747-1-git-send-email-tristan.ye@oracle.com>
References: <1273565449-24747-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1273565449-24747-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As we known, truncate is just a special case of punching holes(from new i_size
to end), we therefore could take advantage of existing ocfs2_remove_btree_range()
codes to reduce the comlexity and redundancy in alloc.c, the goal here is to make
truncate codes more generic and straightforward.

Several former functions only used by ocfs2_commit_truncate() will be simply wiped off.

ocfs2_remove_btree_range() was originally used by punching holes codes, which didn't
take refcount into account(definitely it's a BUG), we therefore need to change that
func a bit to handle refcount treee lock, calculate and reserve block for refcount
tree changes, also decrease refcount at the end, to move these logics in, we needs
to replace the ocfs2_lock_allocators() by adding a new func ocfs2_reserve_blocks_for_rec_trunc()
which accepts some extra blocks to reserve. such changes will not hurt any other codes
who're using ocfs2_remove_btree_range(such as dir truncate and punching holes), actually
punching holes codes do benefit from this.

I merge the following steps into one patch since they may be logically doing one thing,
Though I knew it looks a little bit fat to review.

1). Remove redundant codes used by ocfs2_commit_truncate before, since we're moving to
    ocfs2_remove_btree_range anyway.

2). Add a new func ocfs2_reserve_blocks_for_rec_trunc() for purpose of accepting  some
    extra blocks to reserve.

3). Change ocfs2_prepare_refcount_change_for_del() a bit to fit our needs, it's safe to
    do this since it's only being called by truncating codes.

4). Change ocfs2_remove_btree_range() a bit to take refcount case into account.

5). Finally, we change ocfs2_commit_truncate() to call ocfs2_remove_btree_range() in
    a proper way.

The patch has been tested normally for sanity check, stress tests with heavier workload
will be expected.

Based on this patch, our fixing to punching holes bug will be fairly easy.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/alloc.c        |  685 +++++++++++------------------------------------
 fs/ocfs2/alloc.h        |    8 +-
 fs/ocfs2/dir.c          |    4 +-
 fs/ocfs2/file.c         |   11 +-
 fs/ocfs2/inode.c        |    9 +-
 fs/ocfs2/refcounttree.c |   29 +--
 fs/ocfs2/refcounttree.h |    4 +-
 7 files changed, 178 insertions(+), 572 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 0cb2945..0cb4248 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5587,19 +5587,97 @@ out:
 	return ret;
 }
 
+/*
+ * ocfs2_reserve_blocks_for_rec_trunc() would look basically the
+ * same as ocfs2_lock_alloctors(), except for it accepts a blocks
+ * number to reserve some extra blocks, and it only handles meta
+ * data allocations.
+ *
+ * Currently, only ocfs2_remove_btree_range() uses it for truncating
+ * and punching holes.
+ */
+static int ocfs2_reserve_blocks_for_rec_trunc(struct inode *inode,
+					      struct ocfs2_extent_tree *et,
+					      u32 extents_to_split,
+					      struct ocfs2_alloc_context **ac,
+					      int extra_blocks)
+{
+	int ret = 0, num_free_extents;
+	unsigned int max_recs_needed = 2 * extents_to_split;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	*ac = NULL;
+
+	num_free_extents = ocfs2_num_free_extents(osb, et);
+	if (num_free_extents < 0) {
+		ret = num_free_extents;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (!num_free_extents ||
+	    (ocfs2_sparse_alloc(osb) && num_free_extents < max_recs_needed))
+		extra_blocks += ocfs2_extend_meta_needed(et->et_root_el);
+
+	if (extra_blocks) {
+		ret = ocfs2_reserve_new_metadata_blocks(osb, extra_blocks, ac);
+		if (ret < 0) {
+			if (ret != -ENOSPC)
+				mlog_errno(ret);
+			goto out;
+		}
+	}
+
+out:
+	if (ret) {
+		if (*ac) {
+			ocfs2_free_alloc_context(*ac);
+			*ac = NULL;
+		}
+	}
+
+	return ret;
+}
+
 int ocfs2_remove_btree_range(struct inode *inode,
 			     struct ocfs2_extent_tree *et,
-			     u32 cpos, u32 phys_cpos, u32 len,
-			     struct ocfs2_cached_dealloc_ctxt *dealloc)
+			     u32 cpos, u32 phys_cpos, u32 len, int flags,
+			     struct ocfs2_cached_dealloc_ctxt *dealloc,
+			     u64 refcount_loc)
 {
-	int ret;
+	int ret, credits = 0, extra_blocks = 0;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct inode *tl_inode = osb->osb_tl_inode;
 	handle_t *handle;
 	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
+
+	if ((flags & OCFS2_EXT_REFCOUNTED) && len) {
+		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
+			 OCFS2_HAS_REFCOUNT_FL));
+
+		ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
+					       &ref_tree, NULL);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_prepare_refcount_change_for_del(inode,
+							    refcount_loc,
+							    phys_blkno,
+							    len,
+							    &credits,
+							    &extra_blocks);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
 
-	ret = ocfs2_lock_allocators(inode, et, 0, 1, NULL, &meta_ac);
+	ret = ocfs2_reserve_blocks_for_rec_trunc(inode, et, 1, &meta_ac,
+						 extra_blocks);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
@@ -5615,7 +5693,8 @@ int ocfs2_remove_btree_range(struct inode *inode,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, ocfs2_remove_extent_credits(osb->sb));
+	handle = ocfs2_start_trans(osb,
+			ocfs2_remove_extent_credits(osb->sb) + credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
@@ -5642,9 +5721,20 @@ int ocfs2_remove_btree_range(struct inode *inode,
 
 	ocfs2_journal_dirty(handle, et->et_root_bh);
 
-	ret = ocfs2_truncate_log_append(osb, handle, phys_blkno, len);
-	if (ret)
-		mlog_errno(ret);
+	if (phys_blkno) {
+		if (flags & OCFS2_EXT_REFCOUNTED)
+			ret = ocfs2_decrease_refcount(inode, handle,
+					ocfs2_blocks_to_clusters(osb->sb,
+								 phys_blkno),
+					len, meta_ac,
+					dealloc, 1);
+		else
+			ret = ocfs2_truncate_log_append(osb, handle,
+							phys_blkno, len);
+		if (ret)
+			mlog_errno(ret);
+
+	}
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
@@ -5654,6 +5744,9 @@ out:
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+
 	return ret;
 }
 
@@ -6481,417 +6574,6 @@ static int ocfs2_cache_extent_block_free(struct ocfs2_cached_dealloc_ctxt *ctxt,
 					 le16_to_cpu(eb->h_suballoc_bit));
 }
 
-/* This function will figure out whether the currently last extent
- * block will be deleted, and if it will, what the new last extent
- * block will be so we can update his h_next_leaf_blk field, as well
- * as the dinodes i_last_eb_blk */
-static int ocfs2_find_new_last_ext_blk(struct inode *inode,
-				       unsigned int clusters_to_del,
-				       struct ocfs2_path *path,
-				       struct buffer_head **new_last_eb)
-{
-	int next_free, ret = 0;
-	u32 cpos;
-	struct ocfs2_extent_rec *rec;
-	struct ocfs2_extent_block *eb;
-	struct ocfs2_extent_list *el;
-	struct buffer_head *bh = NULL;
-
-	*new_last_eb = NULL;
-
-	/* we have no tree, so of course, no last_eb. */
-	if (!path->p_tree_depth)
-		goto out;
-
-	/* trunc to zero special case - this makes tree_depth = 0
-	 * regardless of what it is.  */
-	if (OCFS2_I(inode)->ip_clusters == clusters_to_del)
-		goto out;
-
-	el = path_leaf_el(path);
-	BUG_ON(!el->l_next_free_rec);
-
-	/*
-	 * Make sure that this extent list will actually be empty
-	 * after we clear away the data. We can shortcut out if
-	 * there's more than one non-empty extent in the
-	 * list. Otherwise, a check of the remaining extent is
-	 * necessary.
-	 */
-	next_free = le16_to_cpu(el->l_next_free_rec);
-	rec = NULL;
-	if (ocfs2_is_empty_extent(&el->l_recs[0])) {
-		if (next_free > 2)
-			goto out;
-
-		/* We may have a valid extent in index 1, check it. */
-		if (next_free == 2)
-			rec = &el->l_recs[1];
-
-		/*
-		 * Fall through - no more nonempty extents, so we want
-		 * to delete this leaf.
-		 */
-	} else {
-		if (next_free > 1)
-			goto out;
-
-		rec = &el->l_recs[0];
-	}
-
-	if (rec) {
-		/*
-		 * Check it we'll only be trimming off the end of this
-		 * cluster.
-		 */
-		if (le16_to_cpu(rec->e_leaf_clusters) > clusters_to_del)
-			goto out;
-	}
-
-	ret = ocfs2_find_cpos_for_left_leaf(inode->i_sb, path, &cpos);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_find_leaf(INODE_CACHE(inode), path_root_el(path), cpos, &bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	eb = (struct ocfs2_extent_block *) bh->b_data;
-	el = &eb->h_list;
-
-	/* ocfs2_find_leaf() gets the eb from ocfs2_read_extent_block().
-	 * Any corruption is a code bug. */
-	BUG_ON(!OCFS2_IS_VALID_EXTENT_BLOCK(eb));
-
-	*new_last_eb = bh;
-	get_bh(*new_last_eb);
-	mlog(0, "returning block %llu, (cpos: %u)\n",
-	     (unsigned long long)le64_to_cpu(eb->h_blkno), cpos);
-out:
-	brelse(bh);
-
-	return ret;
-}
-
-/*
- * Trim some clusters off the rightmost edge of a tree. Only called
- * during truncate.
- *
- * The caller needs to:
- *   - start journaling of each path component.
- *   - compute and fully set up any new last ext block
- */
-static int ocfs2_trim_tree(struct inode *inode, struct ocfs2_path *path,
-			   handle_t *handle, struct ocfs2_truncate_context *tc,
-			   u32 clusters_to_del, u64 *delete_start, u8 *flags)
-{
-	int ret, i, index = path->p_tree_depth;
-	u32 new_edge = 0;
-	u64 deleted_eb = 0;
-	struct buffer_head *bh;
-	struct ocfs2_extent_list *el;
-	struct ocfs2_extent_rec *rec;
-
-	*delete_start = 0;
-	*flags = 0;
-
-	while (index >= 0) {
-		bh = path->p_node[index].bh;
-		el = path->p_node[index].el;
-
-		mlog(0, "traveling tree (index = %d, block = %llu)\n",
-		     index,  (unsigned long long)bh->b_blocknr);
-
-		BUG_ON(le16_to_cpu(el->l_next_free_rec) == 0);
-
-		if (index !=
-		    (path->p_tree_depth - le16_to_cpu(el->l_tree_depth))) {
-			ocfs2_error(inode->i_sb,
-				    "Inode %lu has invalid ext. block %llu",
-				    inode->i_ino,
-				    (unsigned long long)bh->b_blocknr);
-			ret = -EROFS;
-			goto out;
-		}
-
-find_tail_record:
-		i = le16_to_cpu(el->l_next_free_rec) - 1;
-		rec = &el->l_recs[i];
-
-		mlog(0, "Extent list before: record %d: (%u, %u, %llu), "
-		     "next = %u\n", i, le32_to_cpu(rec->e_cpos),
-		     ocfs2_rec_clusters(el, rec),
-		     (unsigned long long)le64_to_cpu(rec->e_blkno),
-		     le16_to_cpu(el->l_next_free_rec));
-
-		BUG_ON(ocfs2_rec_clusters(el, rec) < clusters_to_del);
-
-		if (le16_to_cpu(el->l_tree_depth) == 0) {
-			/*
-			 * If the leaf block contains a single empty
-			 * extent and no records, we can just remove
-			 * the block.
-			 */
-			if (i == 0 && ocfs2_is_empty_extent(rec)) {
-				memset(rec, 0,
-				       sizeof(struct ocfs2_extent_rec));
-				el->l_next_free_rec = cpu_to_le16(0);
-
-				goto delete;
-			}
-
-			/*
-			 * Remove any empty extents by shifting things
-			 * left. That should make life much easier on
-			 * the code below. This condition is rare
-			 * enough that we shouldn't see a performance
-			 * hit.
-			 */
-			if (ocfs2_is_empty_extent(&el->l_recs[0])) {
-				le16_add_cpu(&el->l_next_free_rec, -1);
-
-				for(i = 0;
-				    i < le16_to_cpu(el->l_next_free_rec); i++)
-					el->l_recs[i] = el->l_recs[i + 1];
-
-				memset(&el->l_recs[i], 0,
-				       sizeof(struct ocfs2_extent_rec));
-
-				/*
-				 * We've modified our extent list. The
-				 * simplest way to handle this change
-				 * is to being the search from the
-				 * start again.
-				 */
-				goto find_tail_record;
-			}
-
-			le16_add_cpu(&rec->e_leaf_clusters, -clusters_to_del);
-
-			/*
-			 * We'll use "new_edge" on our way back up the
-			 * tree to know what our rightmost cpos is.
-			 */
-			new_edge = le16_to_cpu(rec->e_leaf_clusters);
-			new_edge += le32_to_cpu(rec->e_cpos);
-
-			/*
-			 * The caller will use this to delete data blocks.
-			 */
-			*delete_start = le64_to_cpu(rec->e_blkno)
-				+ ocfs2_clusters_to_blocks(inode->i_sb,
-					le16_to_cpu(rec->e_leaf_clusters));
-			*flags = rec->e_flags;
-
-			/*
-			 * If it's now empty, remove this record.
-			 */
-			if (le16_to_cpu(rec->e_leaf_clusters) == 0) {
-				memset(rec, 0,
-				       sizeof(struct ocfs2_extent_rec));
-				le16_add_cpu(&el->l_next_free_rec, -1);
-			}
-		} else {
-			if (le64_to_cpu(rec->e_blkno) == deleted_eb) {
-				memset(rec, 0,
-				       sizeof(struct ocfs2_extent_rec));
-				le16_add_cpu(&el->l_next_free_rec, -1);
-
-				goto delete;
-			}
-
-			/* Can this actually happen? */
-			if (le16_to_cpu(el->l_next_free_rec) == 0)
-				goto delete;
-
-			/*
-			 * We never actually deleted any clusters
-			 * because our leaf was empty. There's no
-			 * reason to adjust the rightmost edge then.
-			 */
-			if (new_edge == 0)
-				goto delete;
-
-			rec->e_int_clusters = cpu_to_le32(new_edge);
-			le32_add_cpu(&rec->e_int_clusters,
-				     -le32_to_cpu(rec->e_cpos));
-
-			 /*
-			  * A deleted child record should have been
-			  * caught above.
-			  */
-			 BUG_ON(le32_to_cpu(rec->e_int_clusters) == 0);
-		}
-
-delete:
-		ocfs2_journal_dirty(handle, bh);
-
-		mlog(0, "extent list container %llu, after: record %d: "
-		     "(%u, %u, %llu), next = %u.\n",
-		     (unsigned long long)bh->b_blocknr, i,
-		     le32_to_cpu(rec->e_cpos), ocfs2_rec_clusters(el, rec),
-		     (unsigned long long)le64_to_cpu(rec->e_blkno),
-		     le16_to_cpu(el->l_next_free_rec));
-
-		/*
-		 * We must be careful to only attempt delete of an
-		 * extent block (and not the root inode block).
-		 */
-		if (index > 0 && le16_to_cpu(el->l_next_free_rec) == 0) {
-			struct ocfs2_extent_block *eb =
-				(struct ocfs2_extent_block *)bh->b_data;
-
-			/*
-			 * Save this for use when processing the
-			 * parent block.
-			 */
-			deleted_eb = le64_to_cpu(eb->h_blkno);
-
-			mlog(0, "deleting this extent block.\n");
-
-			ocfs2_remove_from_cache(INODE_CACHE(inode), bh);
-
-			BUG_ON(ocfs2_rec_clusters(el, &el->l_recs[0]));
-			BUG_ON(le32_to_cpu(el->l_recs[0].e_cpos));
-			BUG_ON(le64_to_cpu(el->l_recs[0].e_blkno));
-
-			ret = ocfs2_cache_extent_block_free(&tc->tc_dealloc, eb);
-			/* An error here is not fatal. */
-			if (ret < 0)
-				mlog_errno(ret);
-		} else {
-			deleted_eb = 0;
-		}
-
-		index--;
-	}
-
-	ret = 0;
-out:
-	return ret;
-}
-
-static int ocfs2_do_truncate(struct ocfs2_super *osb,
-			     unsigned int clusters_to_del,
-			     struct inode *inode,
-			     struct buffer_head *fe_bh,
-			     handle_t *handle,
-			     struct ocfs2_truncate_context *tc,
-			     struct ocfs2_path *path,
-			     struct ocfs2_alloc_context *meta_ac)
-{
-	int status;
-	struct ocfs2_dinode *fe;
-	struct ocfs2_extent_block *last_eb = NULL;
-	struct ocfs2_extent_list *el;
-	struct buffer_head *last_eb_bh = NULL;
-	u64 delete_blk = 0;
-	u8 rec_flags;
-
-	fe = (struct ocfs2_dinode *) fe_bh->b_data;
-
-	status = ocfs2_find_new_last_ext_blk(inode, clusters_to_del,
-					     path, &last_eb_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	/*
-	 * Each component will be touched, so we might as well journal
-	 * here to avoid having to handle errors later.
-	 */
-	status = ocfs2_journal_access_path(INODE_CACHE(inode), handle, path);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	if (last_eb_bh) {
-		status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), last_eb_bh,
-						 OCFS2_JOURNAL_ACCESS_WRITE);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
-
-		last_eb = (struct ocfs2_extent_block *) last_eb_bh->b_data;
-	}
-
-	el = &(fe->id2.i_list);
-
-	/*
-	 * Lower levels depend on this never happening, but it's best
-	 * to check it up here before changing the tree.
-	 */
-	if (el->l_tree_depth && el->l_recs[0].e_int_clusters == 0) {
-		ocfs2_error(inode->i_sb,
-			    "Inode %lu has an empty extent record, depth %u\n",
-			    inode->i_ino, le16_to_cpu(el->l_tree_depth));
-		status = -EROFS;
-		goto bail;
-	}
-
-	dquot_free_space_nodirty(inode,
-			ocfs2_clusters_to_bytes(osb->sb, clusters_to_del));
-	spin_lock(&OCFS2_I(inode)->ip_lock);
-	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters) -
-				      clusters_to_del;
-	spin_unlock(&OCFS2_I(inode)->ip_lock);
-	le32_add_cpu(&fe->i_clusters, -clusters_to_del);
-	inode->i_blocks = ocfs2_inode_sector_count(inode);
-
-	status = ocfs2_trim_tree(inode, path, handle, tc,
-				 clusters_to_del, &delete_blk, &rec_flags);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	if (le32_to_cpu(fe->i_clusters) == 0) {
-		/* trunc to zero is a special case. */
-		el->l_tree_depth = 0;
-		fe->i_last_eb_blk = 0;
-	} else if (last_eb)
-		fe->i_last_eb_blk = last_eb->h_blkno;
-
-	ocfs2_journal_dirty(handle, fe_bh);
-
-	if (last_eb) {
-		/* If there will be a new last extent block, then by
-		 * definition, there cannot be any leaves to the right of
-		 * him. */
-		last_eb->h_next_leaf_blk = 0;
-		ocfs2_journal_dirty(handle, last_eb_bh);
-	}
-
-	if (delete_blk) {
-		if (rec_flags & OCFS2_EXT_REFCOUNTED)
-			status = ocfs2_decrease_refcount(inode, handle,
-					ocfs2_blocks_to_clusters(osb->sb,
-								 delete_blk),
-					clusters_to_del, meta_ac,
-					&tc->tc_dealloc, 1);
-		else
-			status = ocfs2_truncate_log_append(osb, handle,
-							   delete_blk,
-							   clusters_to_del);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
-	}
-	status = 0;
-bail:
-	brelse(last_eb_bh);
-	mlog_exit(status);
-	return status;
-}
-
 static int ocfs2_zero_func(handle_t *handle, struct buffer_head *bh)
 {
 	set_buffer_uptodate(bh);
@@ -7300,26 +6982,29 @@ out:
  */
 int ocfs2_commit_truncate(struct ocfs2_super *osb,
 			  struct inode *inode,
-			  struct buffer_head *fe_bh,
-			  struct ocfs2_truncate_context *tc)
+			  struct buffer_head *di_bh)
 {
-	int status, i, credits, tl_sem = 0;
-	u32 clusters_to_del, new_highest_cpos, range;
+	int status = 0, i, flags = 0;
+	u32 new_highest_cpos, range, trunc_cpos, trunc_len, phys_cpos, coff;
 	u64 blkno = 0;
 	struct ocfs2_extent_list *el;
-	handle_t *handle = NULL;
-	struct inode *tl_inode = osb->osb_tl_inode;
+	struct ocfs2_extent_rec *rec;
 	struct ocfs2_path *path = NULL;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
-	struct ocfs2_alloc_context *meta_ac = NULL;
-	struct ocfs2_refcount_tree *ref_tree = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_extent_list *root_el = &(di->id2.i_list);
+	u64 refcount_loc = le64_to_cpu(di->i_refcount_loc);
+	struct ocfs2_extent_tree et;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
 
 	mlog_entry_void();
 
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
 	new_highest_cpos = ocfs2_clusters_for_bytes(osb->sb,
 						     i_size_read(inode));
 
-	path = ocfs2_new_path(fe_bh, &di->id2.i_list,
+	path = ocfs2_new_path(di_bh, &di->id2.i_list,
 			      ocfs2_journal_access_di);
 	if (!path) {
 		status = -ENOMEM;
@@ -7338,8 +7023,6 @@ start:
 		goto bail;
 	}
 
-	credits = 0;
-
 	/*
 	 * Truncate always works against the rightmost tree branch.
 	 */
@@ -7374,101 +7057,62 @@ start:
 	}
 
 	i = le16_to_cpu(el->l_next_free_rec) - 1;
-	range = le32_to_cpu(el->l_recs[i].e_cpos) +
-		ocfs2_rec_clusters(el, &el->l_recs[i]);
-	if (i == 0 && ocfs2_is_empty_extent(&el->l_recs[i])) {
-		clusters_to_del = 0;
-	} else if (le32_to_cpu(el->l_recs[i].e_cpos) >= new_highest_cpos) {
-		clusters_to_del = ocfs2_rec_clusters(el, &el->l_recs[i]);
-		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
+	rec = &el->l_recs[i];
+	flags = rec->e_flags;
+	range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
+
+	if (i == 0 && ocfs2_is_empty_extent(rec)) {
+		/*
+		 * Lower levels depend on this never happening, but it's best
+		 * to check it up here before changing the tree.
+		*/
+		if (root_el->l_tree_depth && rec->e_int_clusters == 0) {
+			ocfs2_error(inode->i_sb, "Inode %lu has an empty "
+				    "extent record, depth %u\n", inode->i_ino,
+				    le16_to_cpu(root_el->l_tree_depth));
+			status = -EROFS;
+			goto bail;
+		}
+		trunc_cpos = le32_to_cpu(rec->e_cpos);
+		trunc_len = 0;
+		blkno = 0;
+	} else if (le32_to_cpu(rec->e_cpos) >= new_highest_cpos) {
+		/*
+		 * Truncate entire record.
+		 */
+		trunc_cpos = le32_to_cpu(rec->e_cpos);
+		trunc_len = ocfs2_rec_clusters(el, rec);
+		blkno = le64_to_cpu(rec->e_blkno);
 	} else if (range > new_highest_cpos) {
-		clusters_to_del = (ocfs2_rec_clusters(el, &el->l_recs[i]) +
-				   le32_to_cpu(el->l_recs[i].e_cpos)) -
-				  new_highest_cpos;
-		blkno = le64_to_cpu(el->l_recs[i].e_blkno) +
-			ocfs2_clusters_to_blocks(inode->i_sb,
-				ocfs2_rec_clusters(el, &el->l_recs[i]) -
-				clusters_to_del);
+		/*
+		 * Partial truncate. it also should be
+		 * the last truncate we're doing.
+		 */
+		trunc_cpos = new_highest_cpos;
+		trunc_len = range - new_highest_cpos;
+		coff = new_highest_cpos - le32_to_cpu(rec->e_cpos);
+		blkno = le64_to_cpu(rec->e_blkno) +
+				ocfs2_clusters_to_blocks(inode->i_sb, coff);
 	} else {
+		/*
+		 * Truncate completed, leave happily.
+		 */
 		status = 0;
 		goto bail;
 	}
 
-	mlog(0, "clusters_to_del = %u in this pass, tail blk=%llu\n",
-	     clusters_to_del, (unsigned long long)path_leaf_bh(path)->b_blocknr);
-
-	if (el->l_recs[i].e_flags & OCFS2_EXT_REFCOUNTED && clusters_to_del) {
-		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
-			 OCFS2_HAS_REFCOUNT_FL));
-
-		status = ocfs2_lock_refcount_tree(osb,
-						le64_to_cpu(di->i_refcount_loc),
-						1, &ref_tree, NULL);
-		if (status) {
-			mlog_errno(status);
-			goto bail;
-		}
-
-		status = ocfs2_prepare_refcount_change_for_del(inode, fe_bh,
-							       blkno,
-							       clusters_to_del,
-							       &credits,
-							       &meta_ac);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
-	}
-
-	mutex_lock(&tl_inode->i_mutex);
-	tl_sem = 1;
-	/* ocfs2_truncate_log_needs_flush guarantees us at least one
-	 * record is free for use. If there isn't any, we flush to get
-	 * an empty truncate log.  */
-	if (ocfs2_truncate_log_needs_flush(osb)) {
-		status = __ocfs2_flush_truncate_log(osb);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
-	}
-
-	credits += ocfs2_calc_tree_trunc_credits(osb->sb, clusters_to_del,
-						(struct ocfs2_dinode *)fe_bh->b_data,
-						el);
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		handle = NULL;
-		mlog_errno(status);
-		goto bail;
-	}
+	phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
 
-	status = ocfs2_do_truncate(osb, clusters_to_del, inode, fe_bh, handle,
-				   tc, path, meta_ac);
+	status = ocfs2_remove_btree_range(inode, &et, trunc_cpos,
+					  phys_cpos, trunc_len, flags, &dealloc,
+					  refcount_loc);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	mutex_unlock(&tl_inode->i_mutex);
-	tl_sem = 0;
-
-	ocfs2_commit_trans(osb, handle);
-	handle = NULL;
-
 	ocfs2_reinit_path(path, 1);
 
-	if (meta_ac) {
-		ocfs2_free_alloc_context(meta_ac);
-		meta_ac = NULL;
-	}
-
-	if (ref_tree) {
-		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
-		ref_tree = NULL;
-	}
-
 	/*
 	 * The check above will catch the case where we've truncated
 	 * away all allocation.
@@ -7479,25 +7123,10 @@ bail:
 
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 
-	if (tl_sem)
-		mutex_unlock(&tl_inode->i_mutex);
-
-	if (handle)
-		ocfs2_commit_trans(osb, handle);
-
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
-
-	if (ref_tree)
-		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
-
-	ocfs2_run_deallocs(osb, &tc->tc_dealloc);
+	ocfs2_run_deallocs(osb, &dealloc);
 
 	ocfs2_free_path(path);
 
-	/* This will drop the ext_alloc cluster lock for us */
-	ocfs2_free_truncate_context(tc);
-
 	mlog_exit(status);
 	return status;
 }
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 1db4359..4fb9882 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -140,8 +140,9 @@ int ocfs2_remove_extent(handle_t *handle, struct ocfs2_extent_tree *et,
 			struct ocfs2_cached_dealloc_ctxt *dealloc);
 int ocfs2_remove_btree_range(struct inode *inode,
 			     struct ocfs2_extent_tree *et,
-			     u32 cpos, u32 phys_cpos, u32 len,
-			     struct ocfs2_cached_dealloc_ctxt *dealloc);
+			     u32 cpos, u32 phys_cpos, u32 len, int flags,
+			     struct ocfs2_cached_dealloc_ctxt *dealloc,
+			     u64 refcount_loc);
 
 int ocfs2_num_free_extents(struct ocfs2_super *osb,
 			   struct ocfs2_extent_tree *et);
@@ -233,8 +234,7 @@ int ocfs2_prepare_truncate(struct ocfs2_super *osb,
 			   struct ocfs2_truncate_context **tc);
 int ocfs2_commit_truncate(struct ocfs2_super *osb,
 			  struct inode *inode,
-			  struct buffer_head *fe_bh,
-			  struct ocfs2_truncate_context *tc);
+			  struct buffer_head *di_bh);
 int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 			  unsigned int start, unsigned int end, int trunc);
 
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 6c9a28a..4a75c2e 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -4526,8 +4526,8 @@ int ocfs2_dx_dir_truncate(struct inode *dir, struct buffer_head *di_bh)
 
 		p_cpos = ocfs2_blocks_to_clusters(dir->i_sb, blkno);
 
-		ret = ocfs2_remove_btree_range(dir, &et, cpos, p_cpos, clen,
-					       &dealloc);
+		ret = ocfs2_remove_btree_range(dir, &et, cpos, p_cpos, clen, 0,
+					       &dealloc, 0);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 19d16f2..4c7a4d8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -444,7 +444,6 @@ static int ocfs2_truncate_file(struct inode *inode,
 	int status = 0;
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_truncate_context *tc = NULL;
 
 	mlog_entry("(inode = %llu, new_i_size = %llu\n",
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -515,13 +514,7 @@ static int ocfs2_truncate_file(struct inode *inode,
 		goto bail_unlock_sem;
 	}
 
-	status = ocfs2_prepare_truncate(osb, inode, di_bh, &tc);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail_unlock_sem;
-	}
-
-	status = ocfs2_commit_truncate(osb, inode, di_bh, tc);
+	status = ocfs2_commit_truncate(osb, inode, di_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail_unlock_sem;
@@ -1494,7 +1487,7 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 		if (phys_cpos != 0) {
 			ret = ocfs2_remove_btree_range(inode, &et, cpos,
 						       phys_cpos, alloc_size,
-						       &dealloc);
+						       0, &dealloc, 0);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9ee13f7..053765c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -544,7 +544,6 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
 				     struct buffer_head *fe_bh)
 {
 	int status = 0;
-	struct ocfs2_truncate_context *tc = NULL;
 	struct ocfs2_dinode *fe;
 	handle_t *handle = NULL;
 
@@ -586,13 +585,7 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
 		ocfs2_commit_trans(osb, handle);
 		handle = NULL;
 
-		status = ocfs2_prepare_truncate(osb, inode, fe_bh, &tc);
-		if (status < 0) {
-			mlog_errno(status);
-			goto out;
-		}
-
-		status = ocfs2_commit_truncate(osb, inode, fe_bh, tc);
+		status = ocfs2_commit_truncate(osb, inode, fe_bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto out;
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 33dd2a1..6fab289 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2509,20 +2509,19 @@ out:
  *
  * Normally the refcount blocks store these refcount should be
  * contiguous also, so that we can get the number easily.
- * As for meta_ac, we will at most add split 2 refcount record and
- * 2 more refcount block, so just check it in a rough way.
+ * We will@most add split 2 refcount records and 2 more
+ * refcount blocks, so just check it in a rough way.
  *
  * Caller must hold refcount tree lock.
  */
 int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
-					  struct buffer_head *di_bh,
+					  u64 refcount_loc,
 					  u64 phys_blkno,
 					  u32 clusters,
 					  int *credits,
-					  struct ocfs2_alloc_context **meta_ac)
+					  int *ref_blocks)
 {
-	int ret, ref_blocks = 0;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	int ret;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_tree *tree;
@@ -2539,14 +2538,13 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
 
 	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb),
-				      le64_to_cpu(di->i_refcount_loc), &tree);
+				      refcount_loc, &tree);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_read_refcount_block(&tree->rf_ci,
-					le64_to_cpu(di->i_refcount_loc),
+	ret = ocfs2_read_refcount_block(&tree->rf_ci, refcount_loc,
 					&ref_root_bh);
 	if (ret) {
 		mlog_errno(ret);
@@ -2557,21 +2555,14 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					       &tree->rf_ci,
 					       ref_root_bh,
 					       start_cpos, clusters,
-					       &ref_blocks, credits);
+					       ref_blocks, credits);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	mlog(0, "reserve new metadata %d, credits = %d\n",
-	     ref_blocks, *credits);
-
-	if (ref_blocks) {
-		ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
-							ref_blocks, meta_ac);
-		if (ret)
-			mlog_errno(ret);
-	}
+	mlog(0, "reserve new metadata %d blocks, credits = %d\n",
+	     *ref_blocks, *credits);
 
 out:
 	brelse(ref_root_bh);
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index c1d19b1..9983ba1 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -47,11 +47,11 @@ int ocfs2_decrease_refcount(struct inode *inode,
 			    struct ocfs2_cached_dealloc_ctxt *dealloc,
 			    int delete);
 int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
-					  struct buffer_head *di_bh,
+					  u64 refcount_loc,
 					  u64 phys_blkno,
 					  u32 clusters,
 					  int *credits,
-					  struct ocfs2_alloc_context **meta_ac);
+					  int *ref_blocks);
 int ocfs2_refcount_cow(struct inode *inode, struct buffer_head *di_bh,
 		       u32 cpos, u32 write_len, u32 max_cpos);
 
-- 
1.5.5
