From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:14 2008
Subject: [Ocfs2-devel] [PATCH 19/20] ocfs2: Re-journal buffers after
	transaction extend
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-20-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e8aed3450c0afd6fdb79ec233f806e3e69454dfe
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 3 Dec 2007 16:43:01 -0800

ocfs2_extend_trans() might call journal_restart() which will commit dirty
buffers and then restart the transaction. This means that any buffers which
still need changes should be passed to journal_access() again. Some paths
during extend weren't doing this right.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/alloc.c   |   66 +++++++++++++++++++++++++++++++++++----------------
 fs/ocfs2/journal.c |    6 ++++
 2 files changed, 51 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 5714618..cdbb607 100644
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
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9988abc..051ffd5 100644
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
-- 
1.5.3.4
