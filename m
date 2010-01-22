From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 22 Jan 2010 16:15:07 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Treat ocfs2 truncate as a special
	case of punching holes v1.
Message-ID: <1264148107-9341-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As we known, truncate is just a special case of punching holes(from new i_size
to end), we therefore could take advantage of existing ocfs2_remove_extent() codes
to reduce the comlexity and redundancy in alloc.c, the goal here is to make truncate
codes more generic and straightforward.

Several former functions only used by ocfs2_commit_truncate() will be simply wiped off.
New logic for truncating will remove extents from truncate_size to file end one by one,
just like punching holes did.

v1 patch didn't include the codes for refcount supporting in truncate and holes punching,
it will be added in next series.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/alloc.c |  630 ++++--------------------------------------------------
 1 files changed, 40 insertions(+), 590 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 38a42f5..8598452 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6576,429 +6576,6 @@ static int ocfs2_cache_extent_block_free(struct ocfs2_cached_dealloc_ctxt *ctxt,
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
-		ret = ocfs2_journal_dirty(handle, bh);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
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
-	vfs_dq_free_space_nodirty(inode,
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
-	status = ocfs2_journal_dirty(handle, fe_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	if (last_eb) {
-		/* If there will be a new last extent block, then by
-		 * definition, there cannot be any leaves to the right of
-		 * him. */
-		last_eb->h_next_leaf_blk = 0;
-		status = ocfs2_journal_dirty(handle, last_eb_bh);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
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
@@ -7409,198 +6986,73 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 			  struct buffer_head *fe_bh,
 			  struct ocfs2_truncate_context *tc)
 {
-	int status, i, credits, tl_sem = 0;
-	u32 clusters_to_del, new_highest_cpos, range;
-	u64 blkno = 0;
-	struct ocfs2_extent_list *el;
-	handle_t *handle = NULL;
-	struct inode *tl_inode = osb->osb_tl_inode;
-	struct ocfs2_path *path = NULL;
+	int status, i;
+	u32 trunc_start, trunc_end, trunc_len, cpos, phys_cpos, alloc_size;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
-	struct ocfs2_alloc_context *meta_ac = NULL;
-	struct ocfs2_refcount_tree *ref_tree = NULL;
+	struct ocfs2_extent_tree et;
+	struct buffer_head *eb_bh;
+	struct ocfs2_extent_block *last_eb;
+	struct ocfs2_extent_list *el;
 
 	mlog_entry_void();
 
-	new_highest_cpos = ocfs2_clusters_for_bytes(osb->sb,
-						     i_size_read(inode));
-
-	path = ocfs2_new_path(fe_bh, &di->id2.i_list,
-			      ocfs2_journal_access_di);
-	if (!path) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		goto bail;
-	}
-
-	ocfs2_extent_map_trunc(inode, new_highest_cpos);
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
 
-start:
-	/*
-	 * Check that we still have allocation to delete.
-	 */
-	if (OCFS2_I(inode)->ip_clusters == 0) {
-		status = 0;
-		goto bail;
-	}
-
-	credits = 0;
-
-	/*
-	 * Truncate always works against the rightmost tree branch.
-	 */
-	status = ocfs2_find_path(INODE_CACHE(inode), path, UINT_MAX);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	mlog(0, "inode->ip_clusters = %u, tree_depth = %u\n",
-	     OCFS2_I(inode)->ip_clusters, path->p_tree_depth);
-
-	/*
-	 * By now, el will point to the extent list on the bottom most
-	 * portion of this tree. Only the tail record is considered in
-	 * each pass.
-	 *
-	 * We handle the following cases, in order:
-	 * - empty extent: delete the remaining branch
-	 * - remove the entire record
-	 * - remove a partial record
-	 * - no record needs to be removed (truncate has completed)
-	 */
-	el = path_leaf_el(path);
-	if (le16_to_cpu(el->l_next_free_rec) == 0) {
-		ocfs2_error(inode->i_sb,
-			    "Inode %llu has empty extent block at %llu\n",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			    (unsigned long long)path_leaf_bh(path)->b_blocknr);
-		status = -EROFS;
-		goto bail;
-	}
+	trunc_start = ocfs2_clusters_for_bytes(osb->sb, i_size_read(inode));
+	if (le64_to_cpu(di->i_last_eb_blk)) {
+		eb_bh = tc->tc_last_eb_bh;
+		last_eb = (struct ocfs2_extent_block *)eb_bh->b_data;
+		el = &last_eb->h_list;
+	} else
+		el = &di->id2.i_list;
 
 	i = le16_to_cpu(el->l_next_free_rec) - 1;
-	range = le32_to_cpu(el->l_recs[i].e_cpos) +
-		ocfs2_rec_clusters(el, &el->l_recs[i]);
-	if (i == 0 && ocfs2_is_empty_extent(&el->l_recs[i])) {
-		clusters_to_del = 0;
-	} else if (le32_to_cpu(el->l_recs[i].e_cpos) >= new_highest_cpos) {
-		clusters_to_del = ocfs2_rec_clusters(el, &el->l_recs[i]);
-		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
-	} else if (range > new_highest_cpos) {
-		clusters_to_del = (ocfs2_rec_clusters(el, &el->l_recs[i]) +
-				   le32_to_cpu(el->l_recs[i].e_cpos)) -
-				  new_highest_cpos;
-		blkno = le64_to_cpu(el->l_recs[i].e_blkno) +
-			ocfs2_clusters_to_blocks(inode->i_sb,
-				ocfs2_rec_clusters(el, &el->l_recs[i]) -
-				clusters_to_del);
-	} else {
-		status = 0;
-		goto bail;
-	}
 
-	mlog(0, "clusters_to_del = %u in this pass, tail blk=%llu\n",
-	     clusters_to_del, (unsigned long long)path_leaf_bh(path)->b_blocknr);
+	trunc_end = le32_to_cpu(el->l_recs[i].e_cpos) +
+			ocfs2_rec_clusters(el, &el->l_recs[i]);
 
-	if (el->l_recs[i].e_flags & OCFS2_EXT_REFCOUNTED && clusters_to_del) {
-		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
-			 OCFS2_HAS_REFCOUNT_FL));
+	if (trunc_end >= trunc_start)
+		trunc_len = trunc_end - trunc_start;
+	else
+		trunc_len = 0;
 
-		status = ocfs2_lock_refcount_tree(osb,
-						le64_to_cpu(di->i_refcount_loc),
-						1, &ref_tree, NULL);
-		if (status) {
-			mlog_errno(status);
-			goto bail;
-		}
+	cpos = trunc_start;
+	while (trunc_len) {
 
-		status = ocfs2_prepare_refcount_change_for_del(inode, fe_bh,
-							       blkno,
-							       clusters_to_del,
-							       &credits,
-							       &meta_ac);
-		if (status < 0) {
-			mlog_errno(status);
+		if (OCFS2_I(inode)->ip_clusters == 0) {
+			status = 0;
 			goto bail;
 		}
-	}
 
-	mutex_lock(&tl_inode->i_mutex);
-	tl_sem = 1;
-	/* ocfs2_truncate_log_needs_flush guarantees us at least one
-	 * record is free for use. If there isn't any, we flush to get
-	 * an empty truncate log.  */
-	if (ocfs2_truncate_log_needs_flush(osb)) {
-		status = __ocfs2_flush_truncate_log(osb);
-		if (status < 0) {
+		status = ocfs2_get_clusters(inode, cpos, &phys_cpos,
+					    &alloc_size, NULL);
+		if (status) {
 			mlog_errno(status);
 			goto bail;
 		}
-	}
 
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
+		if (alloc_size > trunc_len)
+			alloc_size = trunc_len;
 
-	status = ocfs2_do_truncate(osb, clusters_to_del, inode, fe_bh, handle,
-				   tc, path, meta_ac);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	mutex_unlock(&tl_inode->i_mutex);
-	tl_sem = 0;
-
-	ocfs2_commit_trans(osb, handle);
-	handle = NULL;
-
-	ocfs2_reinit_path(path, 1);
-
-	if (meta_ac) {
-		ocfs2_free_alloc_context(meta_ac);
-		meta_ac = NULL;
-	}
+		if (phys_cpos != 0) {
+			status = ocfs2_remove_btree_range(inode, &et, cpos,
+							  phys_cpos, alloc_size,
+							  &tc->tc_dealloc);
+			if (status) {
+				mlog_errno(status);
+				goto bail;
+			}
+		}
 
-	if (ref_tree) {
-		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
-		ref_tree = NULL;
+		cpos += alloc_size;
+		trunc_len -= alloc_size;
 	}
 
-	/*
-	 * The check above will catch the case where we've truncated
-	 * away all allocation.
-	 */
-	goto start;
-
 bail:
-
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
 	ocfs2_run_deallocs(osb, &tc->tc_dealloc);
 
-	ocfs2_free_path(path);
-
 	/* This will drop the ext_alloc cluster lock for us */
 	ocfs2_free_truncate_context(tc);
 
@@ -7619,7 +7071,6 @@ int ocfs2_prepare_truncate(struct ocfs2_super *osb,
 	int status;
 	unsigned int new_i_clusters;
 	struct ocfs2_dinode *fe;
-	struct ocfs2_extent_block *eb;
 	struct buffer_head *last_eb_bh = NULL;
 
 	mlog_entry_void();
@@ -7650,7 +7101,6 @@ int ocfs2_prepare_truncate(struct ocfs2_super *osb,
 			mlog_errno(status);
 			goto bail;
 		}
-		eb = (struct ocfs2_extent_block *) last_eb_bh->b_data;
 	}
 
 	(*tc)->tc_last_eb_bh = last_eb_bh;
-- 
1.5.5
