From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 17 11:00:07 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20071217185855.GA11448@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c   |   68 ++++++++++++++++++++++++++++++++++-----------------
 fs/ocfs2/journal.c |   13 +++++++++-
 2 files changed, 57 insertions(+), 24 deletions(-)

Mark Fasheh (4):
      ocfs2: fix exit-while-locked bug in ocfs2_queue_orphans()
      ocfs2: Don't panic when truncating an empty extent
      ocfs2: Allow for debugging of transaction extends
      ocfs2: Re-journal buffers after transaction extend

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ce62c15..23c8cda 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2389,6 +2389,18 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 			goto out;
 		}
 
+		/*
+		 * Caller might still want to make changes to the
+		 * tree root, so re-add it to the journal here.
+		 */
+		ret = ocfs2_journal_access(handle, inode,
+					   path_root_bh(left_path),
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
 		ret = ocfs2_rotate_subtree_left(inode, handle, left_path,
 						right_path, subtree_root,
 						dealloc, &deleted);
@@ -3289,16 +3301,6 @@ static int ocfs2_insert_path(struct inode *inode,
 	int ret, subtree_index;
 	struct buffer_head *leaf_bh = path_leaf_bh(right_path);
 
-	/*
-	 * Pass both paths to the journal. The majority of inserts
-	 * will be touching all components anyway.
-	 */
-	ret = ocfs2_journal_access_path(inode, handle, right_path);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	if (left_path) {
 		int credits = handle->h_buffer_credits;
 
@@ -3323,6 +3325,16 @@ static int ocfs2_insert_path(struct inode *inode,
 		}
 	}
 
+	/*
+	 * Pass both paths to the journal. The majority of inserts
+	 * will be touching all components anyway.
+	 */
+	ret = ocfs2_journal_access_path(inode, handle, right_path);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
 	if (insert->ins_split != SPLIT_NONE) {
 		/*
 		 * We could call ocfs2_insert_at_leaf() for some types
@@ -3331,6 +3343,17 @@ static int ocfs2_insert_path(struct inode *inode,
 		 */
 		ocfs2_split_record(inode, left_path, right_path,
 				   insert_rec, insert->ins_split);
+
+		/*
+		 * Split might have modified either leaf and we don't
+		 * have a guarantee that the later edge insert will
+		 * dirty this for us.
+		 */
+		if (left_path)
+			ret = ocfs2_journal_dirty(handle,
+						  path_leaf_bh(left_path));
+			if (ret)
+				mlog_errno(ret);
 	} else
 		ocfs2_insert_at_leaf(insert_rec, path_leaf_el(right_path),
 				     insert, inode);
@@ -3430,6 +3453,17 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 			mlog_errno(ret);
 			goto out;
 		}
+
+		/*
+		 * ocfs2_rotate_tree_right() might have extended the
+		 * transaction without re-journaling our tree root.
+		 */
+		ret = ocfs2_journal_access(handle, inode, di_bh,
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 	} else if (type->ins_appending == APPEND_TAIL
 		   && type->ins_contig != CONTIG_LEFT) {
 		ret = ocfs2_append_rec_to_path(inode, handle, insert_rec,
@@ -3941,7 +3975,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 {
 	int ret = 0;
 	struct ocfs2_extent_list *el = path_leaf_el(path);
-	struct buffer_head *eb_bh, *last_eb_bh = NULL;
+	struct buffer_head *last_eb_bh = NULL;
 	struct ocfs2_extent_rec *rec = &el->l_recs[split_index];
 	struct ocfs2_merge_ctxt ctxt;
 	struct ocfs2_extent_list *rightmost_el;
@@ -3960,14 +3994,6 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 		goto out;
 	}
 
-	eb_bh = path_leaf_bh(path);
-	ret = ocfs2_journal_access(handle, inode, eb_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ctxt.c_contig_type = ocfs2_figure_merge_contig_type(inode, el,
 							    split_index,
 							    split_rec);
@@ -4029,8 +4055,6 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 			mlog_errno(ret);
 	}
 
-	ocfs2_journal_dirty(handle, eb_bh);
-
 out:
 	brelse(last_eb_bh);
 	return ret;
@@ -6093,8 +6117,6 @@ start:
 	mlog(0, "clusters_to_del = %u in this pass, tail blk=%llu\n",
 	     clusters_to_del, (unsigned long long)path_leaf_bh(path)->b_blocknr);
 
-	BUG_ON(clusters_to_del == 0);
-
 	mutex_lock(&tl_inode->i_mutex);
 	tl_sem = 1;
 	/* ocfs2_truncate_log_needs_flush guarantees us at least one
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f9d01e2..8d81f6c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -174,6 +174,12 @@ int ocfs2_commit_trans(struct ocfs2_super *osb,
  * transaction. extend_trans will either extend the current handle by
  * nblocks, or commit it and start a new one with nblocks credits.
  *
+ * This might call journal_restart() which will commit dirty buffers
+ * and then restart the transaction. Before calling
+ * ocfs2_extend_trans(), any changed blocks should have been
+ * dirtied. After calling it, all blocks which need to be changed must
+ * go through another set of journal_access/journal_dirty calls.
+ *
  * WARNING: This will not release any semaphores or disk locks taken
  * during the transaction, so make sure they were taken *before*
  * start_trans or we'll have ordering deadlocks.
@@ -193,11 +199,15 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 
 	mlog(0, "Trying to extend transaction by %d blocks\n", nblocks);
 
+#ifdef OCFS2_DEBUG_FS
+	status = 1;
+#else
 	status = journal_extend(handle, nblocks);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
+#endif
 
 	if (status > 0) {
 		mlog(0, "journal_extend failed, trying journal_restart\n");
@@ -1277,11 +1287,12 @@ static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 				   ocfs2_orphan_filldir);
 	if (status) {
 		mlog_errno(status);
-		goto out;
+		goto out_cluster;
 	}
 
 	*head = priv.head;
 
+out_cluster:
 	ocfs2_meta_unlock(orphan_dir_inode, 0);
 out:
 	mutex_unlock(&orphan_dir_inode->i_mutex);
