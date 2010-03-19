From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 14:17:47 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Make ocfs2_journal_dirty() void.
Message-ID: <20100319211747.GB15539@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

jbd[2]_journal_dirty_metadata() only returns 0.  It's been returning 0
since before the kernel moved to git.  There is no point in checking
this error.

ocfs2_journal_dirty() has been faithfully returning the status since the
beginning.  All over ocfs2, we have blocks of code checking this can't
fail status.  In the past few years, we've tried to avoid adding these
checks, because they are pointless.  But anyone who looks at our code
assumes they are needed.

Finally, ocfs2_journal_dirty() is made a void function.  All error
checking is removed from other files.  We'll BUG_ON() the status of
jbd2_journal_dirty_metadata() just in case they change it someday.  They
won't.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c        |  162 ++++++++++-------------------------------------
 fs/ocfs2/dir.c          |   48 +++-----------
 fs/ocfs2/file.c         |   19 +-----
 fs/ocfs2/inode.c        |   14 +----
 fs/ocfs2/journal.c      |   11 +---
 fs/ocfs2/journal.h      |    3 +-
 fs/ocfs2/localalloc.c   |   23 +------
 fs/ocfs2/namei.c        |   62 +++---------------
 fs/ocfs2/quota_global.c |    4 +-
 fs/ocfs2/quota_local.c  |   50 ++++-----------
 fs/ocfs2/refcounttree.c |   20 +-----
 fs/ocfs2/resize.c       |   13 +---
 fs/ocfs2/suballoc.c     |   64 +++----------------
 fs/ocfs2/xattr.c        |   38 ++---------
 14 files changed, 101 insertions(+), 430 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 9f8bd91..32caf02 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1061,11 +1061,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 
 			/* We'll also be dirtied by the caller, so
 			 * this isn't absolutely necessary. */
-			status = ocfs2_journal_dirty(handle, bhs[i]);
-			if (status < 0) {
-				mlog_errno(status);
-				goto bail;
-			}
+			ocfs2_journal_dirty(handle, bhs[i]);
 		}
 
 		count += num_got;
@@ -1270,12 +1266,7 @@ static int ocfs2_add_branch(handle_t *handle,
 		if (!eb_el->l_tree_depth)
 			new_last_eb_blk = le64_to_cpu(eb->h_blkno);
 
-		status = ocfs2_journal_dirty(handle, bh);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
-
+		ocfs2_journal_dirty(handle, bh);
 		next_blkno = le64_to_cpu(eb->h_blkno);
 	}
 
@@ -1321,17 +1312,10 @@ static int ocfs2_add_branch(handle_t *handle,
 	eb = (struct ocfs2_extent_block *) (*last_eb_bh)->b_data;
 	eb->h_next_leaf_blk = cpu_to_le64(new_last_eb_blk);
 
-	status = ocfs2_journal_dirty(handle, *last_eb_bh);
-	if (status < 0)
-		mlog_errno(status);
-	status = ocfs2_journal_dirty(handle, et->et_root_bh);
-	if (status < 0)
-		mlog_errno(status);
-	if (eb_bh) {
-		status = ocfs2_journal_dirty(handle, eb_bh);
-		if (status < 0)
-			mlog_errno(status);
-	}
+	ocfs2_journal_dirty(handle, *last_eb_bh);
+	ocfs2_journal_dirty(handle, et->et_root_bh);
+	if (eb_bh)
+		ocfs2_journal_dirty(handle, eb_bh);
 
 	/*
 	 * Some callers want to track the rightmost leaf so pass it
@@ -1399,11 +1383,7 @@ static int ocfs2_shift_tree_depth(handle_t *handle,
 	for (i = 0; i < le16_to_cpu(root_el->l_next_free_rec); i++)
 		eb_el->l_recs[i] = root_el->l_recs[i];
 
-	status = ocfs2_journal_dirty(handle, new_eb_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, new_eb_bh);
 
 	status = ocfs2_et_root_journal_access(handle, et,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1428,11 +1408,7 @@ static int ocfs2_shift_tree_depth(handle_t *handle,
 	if (root_el->l_tree_depth == cpu_to_le16(1))
 		ocfs2_et_set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
 
-	status = ocfs2_journal_dirty(handle, et->et_root_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, et->et_root_bh);
 
 	*ret_new_eb_bh = new_eb_bh;
 	new_eb_bh = NULL;
@@ -2102,13 +2078,8 @@ static void ocfs2_complete_edge_insert(handle_t *handle,
 		ocfs2_adjust_adjacent_records(left_rec, left_el, right_rec,
 					      right_el);
 
-		ret = ocfs2_journal_dirty(handle, left_path->p_node[i].bh);
-		if (ret)
-			mlog_errno(ret);
-
-		ret = ocfs2_journal_dirty(handle, right_path->p_node[i].bh);
-		if (ret)
-			mlog_errno(ret);
+		ocfs2_journal_dirty(handle, left_path->p_node[i].bh);
+		ocfs2_journal_dirty(handle, right_path->p_node[i].bh);
 
 		/*
 		 * Setup our list pointers now so that the current
@@ -2132,9 +2103,7 @@ static void ocfs2_complete_edge_insert(handle_t *handle,
 
 	root_bh = left_path->p_node[subtree_index].bh;
 
-	ret = ocfs2_journal_dirty(handle, root_bh);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, root_bh);
 }
 
 static int ocfs2_rotate_subtree_right(handle_t *handle,
@@ -2207,11 +2176,7 @@ static int ocfs2_rotate_subtree_right(handle_t *handle,
 
 	ocfs2_create_empty_extent(right_el);
 
-	ret = ocfs2_journal_dirty(handle, right_leaf_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
+	ocfs2_journal_dirty(handle, right_leaf_bh);
 
 	/* Do the copy now. */
 	i = le16_to_cpu(left_el->l_next_free_rec) - 1;
@@ -2230,11 +2195,7 @@ static int ocfs2_rotate_subtree_right(handle_t *handle,
 	memset(&left_el->l_recs[0], 0, sizeof(struct ocfs2_extent_rec));
 	le16_add_cpu(&left_el->l_next_free_rec, 1);
 
-	ret = ocfs2_journal_dirty(handle, left_leaf_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
+	ocfs2_journal_dirty(handle, left_leaf_bh);
 
 	ocfs2_complete_edge_insert(handle, left_path, right_path,
 				   subtree_index);
@@ -2823,12 +2784,8 @@ static int ocfs2_rotate_subtree_left(handle_t *handle,
 		ocfs2_remove_empty_extent(right_leaf_el);
 	}
 
-	ret = ocfs2_journal_dirty(handle, path_leaf_bh(left_path));
-	if (ret)
-		mlog_errno(ret);
-	ret = ocfs2_journal_dirty(handle, path_leaf_bh(right_path));
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, path_leaf_bh(left_path));
+	ocfs2_journal_dirty(handle, path_leaf_bh(right_path));
 
 	if (del_right_subtree) {
 		ocfs2_unlink_subtree(handle, et, left_path, right_path,
@@ -2851,9 +2808,7 @@ static int ocfs2_rotate_subtree_left(handle_t *handle,
 		if (right_has_empty)
 			ocfs2_remove_empty_extent(left_leaf_el);
 
-		ret = ocfs2_journal_dirty(handle, et_root_bh);
-		if (ret)
-			mlog_errno(ret);
+		ocfs2_journal_dirty(handle, et_root_bh);
 
 		*deleted = 1;
 	} else
@@ -2962,10 +2917,7 @@ static int ocfs2_rotate_rightmost_leaf_left(handle_t *handle,
 	}
 
 	ocfs2_remove_empty_extent(el);
-
-	ret = ocfs2_journal_dirty(handle, bh);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, bh);
 
 out:
 	return ret;
@@ -3506,15 +3458,9 @@ static int ocfs2_merge_rec_right(struct ocfs2_path *left_path,
 
 	ocfs2_cleanup_merge(el, index);
 
-	ret = ocfs2_journal_dirty(handle, bh);
-	if (ret)
-		mlog_errno(ret);
-
+	ocfs2_journal_dirty(handle, bh);
 	if (right_path) {
-		ret = ocfs2_journal_dirty(handle, path_leaf_bh(right_path));
-		if (ret)
-			mlog_errno(ret);
-
+		ocfs2_journal_dirty(handle, path_leaf_bh(right_path));
 		ocfs2_complete_edge_insert(handle, left_path, right_path,
 					   subtree_index);
 	}
@@ -3683,14 +3629,9 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 
 	ocfs2_cleanup_merge(el, index);
 
-	ret = ocfs2_journal_dirty(handle, bh);
-	if (ret)
-		mlog_errno(ret);
-
+	ocfs2_journal_dirty(handle, bh);
 	if (left_path) {
-		ret = ocfs2_journal_dirty(handle, path_leaf_bh(left_path));
-		if (ret)
-			mlog_errno(ret);
+		ocfs2_journal_dirty(handle, path_leaf_bh(left_path));
 
 		/*
 		 * In the situation that the right_rec is empty and the extent
@@ -4016,10 +3957,7 @@ static void ocfs2_adjust_rightmost_records(handle_t *handle,
 		le32_add_cpu(&rec->e_int_clusters,
 			     -le32_to_cpu(rec->e_cpos));
 
-		ret = ocfs2_journal_dirty(handle, bh);
-		if (ret)
-			mlog_errno(ret);
-
+		ocfs2_journal_dirty(handle, bh);
 	}
 }
 
@@ -4251,17 +4189,13 @@ static int ocfs2_insert_path(handle_t *handle,
 		 * dirty this for us.
 		 */
 		if (left_path)
-			ret = ocfs2_journal_dirty(handle,
-						  path_leaf_bh(left_path));
-			if (ret)
-				mlog_errno(ret);
+			ocfs2_journal_dirty(handle,
+					    path_leaf_bh(left_path));
 	} else
 		ocfs2_insert_at_leaf(et, insert_rec, path_leaf_el(right_path),
 				     insert);
 
-	ret = ocfs2_journal_dirty(handle, leaf_bh);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, leaf_bh);
 
 	if (left_path) {
 		/*
@@ -4384,9 +4318,7 @@ out_update_clusters:
 		ocfs2_et_update_clusters(et,
 					 le16_to_cpu(insert_rec->e_leaf_clusters));
 
-	ret = ocfs2_journal_dirty(handle, et->et_root_bh);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, et->et_root_bh);
 
 out:
 	ocfs2_free_path(left_path);
@@ -4895,11 +4827,7 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 		goto leave;
 	}
 
-	status = ocfs2_journal_dirty(handle, et->et_root_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_journal_dirty(handle, et->et_root_bh);
 
 	clusters_to_add -= num_bits;
 	*logical_offset += num_bits;
@@ -5724,11 +5652,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 
 	ocfs2_et_update_clusters(et, -len);
 
-	ret = ocfs2_journal_dirty(handle, et->et_root_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
+	ocfs2_journal_dirty(handle, et->et_root_bh);
 
 	ret = ocfs2_truncate_log_append(osb, handle, phys_blkno, len);
 	if (ret)
@@ -5850,11 +5774,7 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 	}
 	tl->tl_recs[index].t_clusters = cpu_to_le32(num_clusters);
 
-	status = ocfs2_journal_dirty(handle, tl_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, tl_bh);
 
 bail:
 	mlog_exit(status);
@@ -5893,11 +5813,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 
 		tl->tl_used = cpu_to_le16(i);
 
-		status = ocfs2_journal_dirty(handle, tl_bh);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
+		ocfs2_journal_dirty(handle, tl_bh);
 
 		/* TODO: Perhaps we can calculate the bulk of the
 		 * credits up front rather than extending like
@@ -6824,11 +6740,7 @@ find_tail_record:
 		}
 
 delete:
-		ret = ocfs2_journal_dirty(handle, bh);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
+		ocfs2_journal_dirty(handle, bh);
 
 		mlog(0, "extent list container %llu, after: record %d: "
 		     "(%u, %u, %llu), next = %u.\n",
@@ -6959,22 +6871,14 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	} else if (last_eb)
 		fe->i_last_eb_blk = last_eb->h_blkno;
 
-	status = ocfs2_journal_dirty(handle, fe_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, fe_bh);
 
 	if (last_eb) {
 		/* If there will be a new last extent block, then by
 		 * definition, there cannot be any leaves to the right of
 		 * him. */
 		last_eb->h_next_leaf_blk = 0;
-		status = ocfs2_journal_dirty(handle, last_eb_bh);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
+		ocfs2_journal_dirty(handle, last_eb_bh);
 	}
 
 	if (delete_blk) {
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index efd77d0..6d83248 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1194,7 +1194,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 			else
 				de->inode = 0;
 			dir->i_version++;
-			status = ocfs2_journal_dirty(handle, bh);
+			ocfs2_journal_dirty(handle, bh);
 			goto bail;
 		}
 		i += le16_to_cpu(de->rec_len);
@@ -1752,7 +1752,7 @@ int __ocfs2_add_entry(handle_t *handle,
 				ocfs2_recalc_free_list(dir, handle, lookup);
 
 			dir->i_version++;
-			status = ocfs2_journal_dirty(handle, insert_bh);
+			ocfs2_journal_dirty(handle, insert_bh);
 			retval = 0;
 			goto bail;
 		}
@@ -2297,12 +2297,7 @@ static int ocfs2_fill_new_dir_id(struct ocfs2_super *osb,
 	}
 
 	ocfs2_fill_initial_dirents(inode, parent, data->id_data, size);
-
 	ocfs2_journal_dirty(handle, di_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
 
 	i_size_write(inode, size);
 	inode->i_nlink = 2;
@@ -2366,11 +2361,7 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 		ocfs2_init_dir_trailer(inode, new_bh, size);
 	}
 
-	status = ocfs2_journal_dirty(handle, new_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, new_bh);
 
 	i_size_write(inode, inode->i_sb->s_blocksize);
 	inode->i_nlink = 2;
@@ -2458,10 +2449,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 		dx_root->dr_list.l_count =
 			cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
 	}
-
-	ret = ocfs2_journal_dirty(handle, dx_root_bh);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, dx_root_bh);
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(dir), di_bh,
 				      OCFS2_JOURNAL_ACCESS_CREATE);
@@ -2475,9 +2463,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	OCFS2_I(dir)->ip_dyn_features |= OCFS2_INDEXED_DIR_FL;
 	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
 
-	ret = ocfs2_journal_dirty(handle, di_bh);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, di_bh);
 
 	*ret_dx_root_bh = dx_root_bh;
 	dx_root_bh = NULL;
@@ -3034,11 +3020,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		ocfs2_init_dir_trailer(dir, dirdata_bh, i);
 	}
 
-	ret = ocfs2_journal_dirty(handle, dirdata_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
+	ocfs2_journal_dirty(handle, dirdata_bh);
 
 	if (ocfs2_supports_indexed_dirs(osb) && !dx_inline) {
 		/*
@@ -3104,11 +3086,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 */
 	dir->i_blocks = ocfs2_inode_sector_count(dir);
 
-	ret = ocfs2_journal_dirty(handle, di_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
+	ocfs2_journal_dirty(handle, di_bh);
 
 	if (ocfs2_supports_indexed_dirs(osb)) {
 		ret = ocfs2_dx_dir_attach_index(osb, handle, dir, di_bh,
@@ -3423,11 +3401,7 @@ do_extend:
 	} else {
 		de->rec_len = cpu_to_le16(sb->s_blocksize);
 	}
-	status = ocfs2_journal_dirty(handle, new_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, new_bh);
 
 	dir_i_size += dir->i_sb->s_blocksize;
 	i_size_write(dir, dir_i_size);
@@ -3906,11 +3880,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
 	     sizeof(struct ocfs2_dx_entry), dx_leaf_sort_cmp,
 	     dx_leaf_sort_swap);
 
-	ret = ocfs2_journal_dirty(handle, dx_leaf_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
+	ocfs2_journal_dirty(handle, dx_leaf_bh);
 
 	ret = ocfs2_dx_dir_find_leaf_split(dx_leaf, leaf_cpos, insert_hash,
 					   &split_hash);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 17947dc..e6e8281 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -278,10 +278,7 @@ int ocfs2_update_inode_atime(struct inode *inode,
 	inode->i_atime = CURRENT_TIME;
 	di->i_atime = cpu_to_le64(inode->i_atime.tv_sec);
 	di->i_atime_nsec = cpu_to_le32(inode->i_atime.tv_nsec);
-
-	ret = ocfs2_journal_dirty(handle, bh);
-	if (ret < 0)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, bh);
 
 out_commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
@@ -430,9 +427,7 @@ static int ocfs2_orphan_for_truncate(struct ocfs2_super *osb,
 	di->i_ctime = di->i_mtime = cpu_to_le64(inode->i_ctime.tv_sec);
 	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
 
-	status = ocfs2_journal_dirty(handle, fe_bh);
-	if (status < 0)
-		mlog_errno(status);
+	ocfs2_journal_dirty(handle, fe_bh);
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
@@ -666,11 +661,7 @@ restarted_transaction:
 		goto leave;
 	}
 
-	status = ocfs2_journal_dirty(handle, bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_journal_dirty(handle, bh);
 
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 	clusters_to_add -= (OCFS2_I(inode)->ip_clusters - prev_clusters);
@@ -1194,9 +1185,7 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 	di = (struct ocfs2_dinode *) bh->b_data;
 	di->i_mode = cpu_to_le16(inode->i_mode);
 
-	ret = ocfs2_journal_dirty(handle, bh);
-	if (ret < 0)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, bh);
 
 out_trans:
 	ocfs2_commit_trans(osb, handle);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 278a223..7cc0b46 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -657,12 +657,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 
 	di->i_dtime = cpu_to_le64(CURRENT_TIME.tv_sec);
 	di->i_flags &= cpu_to_le32(~(OCFS2_VALID_FL | OCFS2_ORPHANED_FL));
-
-	status = ocfs2_journal_dirty(handle, di_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail_commit;
-	}
+	ocfs2_journal_dirty(handle, di_bh);
 
 	ocfs2_remove_from_cache(INODE_CACHE(inode), di_bh);
 	dquot_free_inode(inode);
@@ -1276,13 +1271,8 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 	fe->i_mtime = cpu_to_le64(inode->i_mtime.tv_sec);
 	fe->i_mtime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
 
-	status = ocfs2_journal_dirty(handle, bh);
-	if (status < 0)
-		mlog_errno(status);
-
-	status = 0;
+	ocfs2_journal_dirty(handle, bh);
 leave:
-
 	mlog_exit(status);
 	return status;
 }
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9336c60..cfd271c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -734,8 +734,7 @@ int ocfs2_journal_access(handle_t *handle, struct ocfs2_caching_info *ci,
 	return __ocfs2_journal_access(handle, ci, bh, NULL, type);
 }
 
-int ocfs2_journal_dirty(handle_t *handle,
-			struct buffer_head *bh)
+void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
 {
 	int status;
 
@@ -743,13 +742,9 @@ int ocfs2_journal_dirty(handle_t *handle,
 		   (unsigned long long)bh->b_blocknr);
 
 	status = jbd2_journal_dirty_metadata(handle, bh);
-	if (status < 0)
-		mlog(ML_ERROR, "Could not dirty metadata buffer. "
-		     "(bh->b_blocknr=%llu)\n",
-		     (unsigned long long)bh->b_blocknr);
+	BUG_ON(status);
 
-	mlog_exit(status);
-	return status;
+	mlog_exit_void();
 }
 
 #define OCFS2_DEFAULT_COMMIT_INTERVAL	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 3f74e09..7dc5656 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -325,8 +325,7 @@ int ocfs2_journal_access(handle_t *handle, struct ocfs2_caching_info *ci,
  *	<modify the bh>
  * 	ocfs2_journal_dirty(handle, bh);
  */
-int                  ocfs2_journal_dirty(handle_t *handle,
-					 struct buffer_head *bh);
+void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh);
 
 /*
  *  Credit Macros:
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ca992d9..dc3454a 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -305,12 +305,7 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	}
 
 	ocfs2_clear_local_alloc(alloc);
-
-	status = ocfs2_journal_dirty(handle, bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_commit;
-	}
+	ocfs2_journal_dirty(handle, bh);
 
 	brelse(bh);
 	osb->local_alloc_bh = NULL;
@@ -691,14 +686,8 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 		ocfs2_set_bit(start++, bitmap);
 
 	le32_add_cpu(&alloc->id1.bitmap1.i_used, *num_bits);
+	ocfs2_journal_dirty(handle, osb->local_alloc_bh);
 
-	status = ocfs2_journal_dirty(handle, osb->local_alloc_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	status = 0;
 bail:
 	mlog_exit(status);
 	return status;
@@ -1167,12 +1156,7 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 	}
 
 	ocfs2_clear_local_alloc(alloc);
-
-	status = ocfs2_journal_dirty(handle, osb->local_alloc_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, osb->local_alloc_bh);
 
 	status = ocfs2_sync_local_to_main(osb, handle, alloc_copy,
 					  main_bm_inode, main_bm_bh);
@@ -1190,7 +1174,6 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 
 	atomic_inc(&osb->alloc_stats.moves);
 
-	status = 0;
 bail:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d9cd4e3..21d4a33 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -384,11 +384,7 @@ static int ocfs2_mknod(struct inode *dir,
 			goto leave;
 		}
 		ocfs2_add_links_count(dirfe, 1);
-		status = ocfs2_journal_dirty(handle, parent_fe_bh);
-		if (status < 0) {
-			mlog_errno(status);
-			goto leave;
-		}
+		ocfs2_journal_dirty(handle, parent_fe_bh);
 		inc_nlink(dir);
 	}
 
@@ -556,11 +552,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		fel->l_count = cpu_to_le16(ocfs2_extent_recs_per_inode(osb->sb));
 	}
 
-	status = ocfs2_journal_dirty(handle, *new_fe_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_journal_dirty(handle, *new_fe_bh);
 
 	ocfs2_populate_inode(inode, fe, 1);
 	ocfs2_ci_set_new(osb, INODE_CACHE(inode));
@@ -694,14 +686,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 	ocfs2_set_links_count(fe, inode->i_nlink);
 	fe->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
 	fe->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
-
-	err = ocfs2_journal_dirty(handle, fe_bh);
-	if (err < 0) {
-		ocfs2_add_links_count(fe, -1);
-		drop_nlink(inode);
-		mlog_errno(err);
-		goto out_commit;
-	}
+	ocfs2_journal_dirty(handle, fe_bh);
 
 	err = ocfs2_add_entry(handle, dentry, inode,
 			      OCFS2_I(inode)->ip_blkno,
@@ -898,12 +883,7 @@ static int ocfs2_unlink(struct inode *dir,
 		drop_nlink(inode);
 	drop_nlink(inode);
 	ocfs2_set_links_count(fe, inode->i_nlink);
-
-	status = ocfs2_journal_dirty(handle, fe_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_journal_dirty(handle, fe_bh);
 
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	if (S_ISDIR(inode->i_mode))
@@ -1321,12 +1301,7 @@ static int ocfs2_rename(struct inode *old_dir,
 			ocfs2_set_links_count(newfe, 0);
 		else
 			ocfs2_add_links_count(newfe, -1);
-
-		status = ocfs2_journal_dirty(handle, newfe_bh);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
+		ocfs2_journal_dirty(handle, newfe_bh);
 	} else {
 		/* if the name was not found in new_dir, add it now */
 		status = ocfs2_add_entry(handle, new_dentry, old_inode,
@@ -1345,10 +1320,7 @@ static int ocfs2_rename(struct inode *old_dir,
 
 		old_di->i_ctime = cpu_to_le64(old_inode->i_ctime.tv_sec);
 		old_di->i_ctime_nsec = cpu_to_le32(old_inode->i_ctime.tv_nsec);
-
-		status = ocfs2_journal_dirty(handle, old_inode_bh);
-		if (status < 0)
-			mlog_errno(status);
+		ocfs2_journal_dirty(handle, old_inode_bh);
 	} else
 		mlog_errno(status);
 
@@ -1420,7 +1392,7 @@ static int ocfs2_rename(struct inode *old_dir,
 							 OCFS2_JOURNAL_ACCESS_WRITE);
 			fe = (struct ocfs2_dinode *) old_dir_bh->b_data;
 			ocfs2_set_links_count(fe, old_dir->i_nlink);
-			status = ocfs2_journal_dirty(handle, old_dir_bh);
+			ocfs2_journal_dirty(handle, old_dir_bh);
 		}
 	}
 	ocfs2_dentry_move(old_dentry, new_dentry, old_dir, new_dir);
@@ -1552,11 +1524,7 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 		       (bytes_left > sb->s_blocksize) ? sb->s_blocksize :
 		       bytes_left);
 
-		status = ocfs2_journal_dirty(handle, bhs[virtual]);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
+		ocfs2_journal_dirty(handle, bhs[virtual]);
 
 		virtual++;
 		p_blkno++;
@@ -1943,12 +1911,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	if (S_ISDIR(inode->i_mode))
 		ocfs2_add_links_count(orphan_fe, 1);
 	orphan_dir_inode->i_nlink = ocfs2_read_links_count(orphan_fe);
-
-	status = ocfs2_journal_dirty(handle, orphan_dir_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_journal_dirty(handle, orphan_dir_bh);
 
 	status = __ocfs2_add_entry(handle, orphan_dir_inode, name,
 				   OCFS2_ORPHAN_NAMELEN, inode,
@@ -2029,12 +1992,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	if (S_ISDIR(inode->i_mode))
 		ocfs2_add_links_count(orphan_fe, -1);
 	orphan_dir_inode->i_nlink = ocfs2_read_links_count(orphan_fe);
-
-	status = ocfs2_journal_dirty(handle, orphan_dir_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_journal_dirty(handle, orphan_dir_bh);
 
 leave:
 	ocfs2_free_dir_lookup_result(&lookup);
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 355f41d..faaa4d0 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -260,10 +260,8 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 		brelse(bh);
 		goto out;
 	}
-	err = ocfs2_journal_dirty(handle, bh);
+	ocfs2_journal_dirty(handle, bh);
 	brelse(bh);
-	if (err < 0)
-		goto out;
 out:
 	if (err) {
 		mutex_unlock(&gqinode->i_mutex);
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index a6467f3..a8f4cea 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -118,12 +118,8 @@ static int ocfs2_modify_bh(struct inode *inode, struct buffer_head *bh,
 	lock_buffer(bh);
 	modify(bh, private);
 	unlock_buffer(bh);
-	status = ocfs2_journal_dirty(handle, bh);
-	if (status < 0) {
-		mlog_errno(status);
-		ocfs2_commit_trans(OCFS2_SB(sb), handle);
-		return status;
-	}
+	ocfs2_journal_dirty(handle, bh);
+
 	status = ocfs2_commit_trans(OCFS2_SB(sb), handle);
 	if (status < 0) {
 		mlog_errno(status);
@@ -522,9 +518,7 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 			ocfs2_clear_bit(bit, dchunk->dqc_bitmap);
 			le32_add_cpu(&dchunk->dqc_free, 1);
 			unlock_buffer(qbh);
-			status = ocfs2_journal_dirty(handle, qbh);
-			if (status < 0)
-				mlog_errno(status);
+			ocfs2_journal_dirty(handle, qbh);
 out_commit:
 			mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
 			ocfs2_commit_trans(OCFS2_SB(sb), handle);
@@ -630,9 +624,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 		lock_buffer(bh);
 		ldinfo->dqi_flags = cpu_to_le32(flags | OLQF_CLEAN);
 		unlock_buffer(bh);
-		status = ocfs2_journal_dirty(handle, bh);
-		if (status < 0)
-			mlog_errno(status);
+		ocfs2_journal_dirty(handle, bh);
 out_trans:
 		ocfs2_commit_trans(osb, handle);
 out_bh:
@@ -1008,11 +1000,7 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 	       sb->s_blocksize - sizeof(struct ocfs2_local_disk_chunk) -
 	       OCFS2_QBLK_RESERVED_SPACE);
 	unlock_buffer(bh);
-	status = ocfs2_journal_dirty(handle, bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_trans;
-	}
+	ocfs2_journal_dirty(handle, bh);
 
 	/* Initialize new block with structures */
 	down_read(&OCFS2_I(lqinode)->ip_alloc_sem);
@@ -1039,11 +1027,7 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 	lock_buffer(dbh);
 	memset(dbh->b_data, 0, sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE);
 	unlock_buffer(dbh);
-	status = ocfs2_journal_dirty(handle, dbh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_trans;
-	}
+	ocfs2_journal_dirty(handle, dbh);
 
 	/* Update local quotafile info */
 	oinfo->dqi_blocks += 2;
@@ -1154,11 +1138,8 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 	lock_buffer(bh);
 	memset(bh->b_data, 0, sb->s_blocksize);
 	unlock_buffer(bh);
-	status = ocfs2_journal_dirty(handle, bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_trans;
-	}
+	ocfs2_journal_dirty(handle, bh);
+
 	/* Update chunk header */
 	status = ocfs2_journal_access_dq(handle, INODE_CACHE(lqinode),
 					 chunk->qc_headerbh,
@@ -1172,11 +1153,8 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 	lock_buffer(chunk->qc_headerbh);
 	le32_add_cpu(&dchunk->dqc_free, ol_quota_entries_per_block(sb));
 	unlock_buffer(chunk->qc_headerbh);
-	status = ocfs2_journal_dirty(handle, chunk->qc_headerbh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_trans;
-	}
+	ocfs2_journal_dirty(handle, chunk->qc_headerbh);
+
 	/* Update file header */
 	oinfo->dqi_blocks++;
 	status = ocfs2_local_write_info(sb, type);
@@ -1311,12 +1289,8 @@ static int ocfs2_local_release_dquot(struct dquot *dquot)
 	ocfs2_clear_bit(offset, dchunk->dqc_bitmap);
 	le32_add_cpu(&dchunk->dqc_free, 1);
 	unlock_buffer(od->dq_chunk->qc_headerbh);
-	status = ocfs2_journal_dirty(handle, od->dq_chunk->qc_headerbh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out;
-	}
-	status = 0;
+	ocfs2_journal_dirty(handle, od->dq_chunk->qc_headerbh);
+
 out:
 	/* Clear the read bit so that next time someone uses this
 	 * dquot he reads fresh info from disk and allocates local
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 9e96921..44d3e1c 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1269,9 +1269,7 @@ static int ocfs2_change_refcount_rec(handle_t *handle,
 	} else if (merge)
 		ocfs2_refcount_rec_merge(rb, index);
 
-	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, ref_leaf_bh);
 out:
 	return ret;
 }
@@ -1803,11 +1801,7 @@ static int ocfs2_insert_refcount_rec(handle_t *handle,
 	if (merge)
 		ocfs2_refcount_rec_merge(rb, index);
 
-	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
+	ocfs2_journal_dirty(handle, ref_leaf_bh);
 
 	if (index == 0) {
 		ret = ocfs2_adjust_refcount_rec(handle, ci,
@@ -1978,9 +1972,7 @@ static int ocfs2_split_refcount_rec(handle_t *handle,
 			ocfs2_refcount_rec_merge(rb, index);
 	}
 
-	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, ref_leaf_bh);
 
 out:
 	brelse(new_bh);
@@ -3041,11 +3033,7 @@ static int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
 		}
 
 		memcpy(new_bh->b_data, old_bh->b_data, sb->s_blocksize);
-		ret = ocfs2_journal_dirty(handle, new_bh);
-		if (ret) {
-			mlog_errno(ret);
-			break;
-		}
+		ocfs2_journal_dirty(handle, new_bh);
 
 		brelse(new_bh);
 		brelse(old_bh);
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 3c3d673..a821f66 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -134,11 +134,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
 	}
 
-	ret = ocfs2_journal_dirty(handle, group_bh);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out_rollback;
-	}
+	ocfs2_journal_dirty(handle, group_bh);
 
 	/* update the inode accordingly. */
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(bm_inode), bm_bh,
@@ -545,12 +541,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 
 	group = (struct ocfs2_group_desc *)group_bh->b_data;
 	group->bg_next_group = cr->c_blkno;
-
-	ret = ocfs2_journal_dirty(handle, group_bh);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
+	ocfs2_journal_dirty(handle, group_bh);
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(main_bm_inode),
 				      main_bm_bh, OCFS2_JOURNAL_ACCESS_WRITE);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index c3c60bc..578dbf7 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -373,9 +373,7 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	ocfs2_set_bit(0, (unsigned long *)bg->bg_bitmap);
 	bg->bg_free_bits_count = cpu_to_le16(le16_to_cpu(bg->bg_bits) - 1);
 
-	status = ocfs2_journal_dirty(handle, bg_bh);
-	if (status < 0)
-		mlog_errno(status);
+	ocfs2_journal_dirty(handle, bg_bh);
 
 	/* There is no need to zero out or otherwise initialize the
 	 * other blocks in a group - All valid FS metadata in a block
@@ -510,11 +508,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	le32_add_cpu(&fe->id1.bitmap1.i_total, le16_to_cpu(bg->bg_bits));
 	le32_add_cpu(&fe->i_clusters, le16_to_cpu(cl->cl_cpg));
 
-	status = ocfs2_journal_dirty(handle, bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, bh);
 
 	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
 	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
@@ -1133,16 +1127,10 @@ static inline int ocfs2_block_group_set_bits(handle_t *handle,
 	}
 
 	le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
-
 	while(num_bits--)
 		ocfs2_set_bit(bit_off++, bitmap);
 
-	status = ocfs2_journal_dirty(handle,
-				     group_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, group_bh);
 
 bail:
 	mlog_exit(status);
@@ -1206,12 +1194,7 @@ static int ocfs2_relink_block_group(handle_t *handle,
 	}
 
 	prev_bg->bg_next_group = bg->bg_next_group;
-
-	status = ocfs2_journal_dirty(handle, prev_bg_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_rollback;
-	}
+	ocfs2_journal_dirty(handle, prev_bg_bh);
 
 	status = ocfs2_journal_access_gd(handle, INODE_CACHE(alloc_inode),
 					 bg_bh, OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1221,12 +1204,7 @@ static int ocfs2_relink_block_group(handle_t *handle,
 	}
 
 	bg->bg_next_group = fe->id2.i_chain.cl_recs[chain].c_blkno;
-
-	status = ocfs2_journal_dirty(handle, bg_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_rollback;
-	}
+	ocfs2_journal_dirty(handle, bg_bh);
 
 	status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
 					 fe_bh, OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1236,14 +1214,8 @@ static int ocfs2_relink_block_group(handle_t *handle,
 	}
 
 	fe->id2.i_chain.cl_recs[chain].c_blkno = bg->bg_blkno;
+	ocfs2_journal_dirty(handle, fe_bh);
 
-	status = ocfs2_journal_dirty(handle, fe_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_rollback;
-	}
-
-	status = 0;
 out_rollback:
 	if (status < 0) {
 		fe->id2.i_chain.cl_recs[chain].c_blkno = cpu_to_le64(fe_ptr);
@@ -1390,10 +1362,7 @@ static int ocfs2_alloc_dinode_update_counts(struct inode *inode,
 	tmp_used = le32_to_cpu(di->id1.bitmap1.i_used);
 	di->id1.bitmap1.i_used = cpu_to_le32(num_bits + tmp_used);
 	le32_add_cpu(&cl->cl_recs[chain].c_free, -num_bits);
-
-	ret = ocfs2_journal_dirty(handle, di_bh);
-	if (ret < 0)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, di_bh);
 
 out:
 	return ret;
@@ -1564,13 +1533,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
 	fe->id1.bitmap1.i_used = cpu_to_le32(*num_bits + tmp_used);
 	le32_add_cpu(&cl->cl_recs[chain].c_free, -(*num_bits));
-
-	status = ocfs2_journal_dirty(handle,
-				     ac->ac_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, ac->ac_bh);
 
 	status = ocfs2_block_group_set_bits(handle,
 					    alloc_inode,
@@ -2029,9 +1992,7 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 	if (cluster_bitmap)
 		jbd_unlock_bh_state(group_bh);
 
-	status = ocfs2_journal_dirty(handle, group_bh);
-	if (status < 0)
-		mlog_errno(status);
+	ocfs2_journal_dirty(handle, group_bh);
 bail:
 	return status;
 }
@@ -2096,12 +2057,7 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 		     count);
 	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
 	fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - count);
-
-	status = ocfs2_journal_dirty(handle, alloc_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_journal_dirty(handle, alloc_bh);
 
 bail:
 	brelse(group_bh);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d1b0d38..26f704c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -739,11 +739,7 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 		goto leave;
 	}
 
-	status = ocfs2_journal_dirty(handle, vb->vb_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_journal_dirty(handle, vb->vb_bh);
 
 	clusters_to_add -= le32_to_cpu(vb->vb_xv->xr_clusters) - prev_clusters;
 
@@ -786,12 +782,7 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 	}
 
 	le32_add_cpu(&vb->vb_xv->xr_clusters, -len);
-
-	ret = ocfs2_journal_dirty(handle, vb->vb_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
+	ocfs2_journal_dirty(handle, vb->vb_bh);
 
 	if (ext_flags & OCFS2_EXT_REFCOUNTED)
 		ret = ocfs2_decrease_refcount(inode, handle,
@@ -1374,11 +1365,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 				memset(bh->b_data + cp_len, 0,
 				       blocksize - cp_len);
 
-			ret = ocfs2_journal_dirty(handle, bh);
-			if (ret < 0) {
-				mlog_errno(ret);
-				goto out;
-			}
+			ocfs2_journal_dirty(handle, bh);
 			brelse(bh);
 			bh = NULL;
 
@@ -2594,9 +2581,7 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
 	spin_unlock(&oi->ip_lock);
 
-	ret = ocfs2_journal_dirty(handle, di_bh);
-	if (ret < 0)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, di_bh);
 out_commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
@@ -2724,9 +2709,7 @@ static int ocfs2_xattr_ibody_init(struct inode *inode,
 	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
 	spin_unlock(&oi->ip_lock);
 
-	ret = ocfs2_journal_dirty(ctxt->handle, di_bh);
-	if (ret < 0)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(ctxt->handle, di_bh);
 
 out:
 	return ret;
@@ -5153,9 +5136,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		goto leave;
 	}
 
-	ret = ocfs2_journal_dirty(handle, root_bh);
-	if (ret < 0)
-		mlog_errno(ret);
+	ocfs2_journal_dirty(handle, root_bh);
 
 leave:
 	return ret;
@@ -5477,12 +5458,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 	}
 
 	le32_add_cpu(&xb->xb_attrs.xb_root.xt_clusters, -len);
-
-	ret = ocfs2_journal_dirty(handle, root_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
+	ocfs2_journal_dirty(handle, root_bh);
 
 	ret = ocfs2_truncate_log_append(osb, handle, blkno, len);
 	if (ret)
-- 
1.7.0


-- 

"All alone at the end of the evening
 When the bright lights have faded to blue.
 I was thinking about a woman who had loved me
 And I never knew"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
