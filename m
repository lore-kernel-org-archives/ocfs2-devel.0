From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 21 Jul 2009 15:42:05 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Add extra credits and access the
	modified bh in update_edge_lengths.
In-Reply-To: <4A656FC9.4010404@oracle.com>
References: <4A656FC9.4010404@oracle.com>
Message-ID: <1248162126-21507-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In normal tree rotation left process, we will never touch the tree
branch above subtree_index and ocfs2_extend_rotate_transaction doesn't
reserve the credits for them either.

But when we want to delete the rightmost extent block, we have to update
the rightmost records for all the rightmost branch(See
ocfs2_update_edge_lengths), so we have to allocate extra credits for them.
What's more, we have to access them also.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 9edcde4..11085af 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2476,15 +2476,37 @@ out_ret_path:
 	return ret;
 }
 
-static void ocfs2_update_edge_lengths(struct inode *inode, handle_t *handle,
-				      struct ocfs2_path *path)
+static int ocfs2_update_edge_lengths(struct inode *inode, handle_t *handle,
+				     int subtree_index, struct ocfs2_path *path)
 {
-	int i, idx;
+	int i, idx, ret;
 	struct ocfs2_extent_rec *rec;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_block *eb;
 	u32 range;
 
+	/*
+	 * In normal tree rotation process, we will never touch the
+	 * tree branch above subtree_index and ocfs2_extend_rotate_transaction
+	 * doesn't reserve the credits for them either.
+	 *
+	 * But we do have a special case here which will update the rightmost
+	 * records for all the bh in the path.
+	 * So we have to allocate extra credits and access them.
+	 */
+	ret = ocfs2_extend_trans(handle,
+				 handle->h_buffer_credits + subtree_index);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_path(inode, handle, path);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
 	/* Path should always be rightmost. */
 	eb = (struct ocfs2_extent_block *)path_leaf_bh(path)->b_data;
 	BUG_ON(eb->h_next_leaf_blk != 0ULL);
@@ -2505,6 +2527,8 @@ static void ocfs2_update_edge_lengths(struct inode *inode, handle_t *handle,
 
 		ocfs2_journal_dirty(handle, path->p_node[i].bh);
 	}
+out:
+	return ret;
 }
 
 static void ocfs2_unlink_path(struct inode *inode, handle_t *handle,
@@ -2717,7 +2741,12 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 	if (del_right_subtree) {
 		ocfs2_unlink_subtree(inode, handle, left_path, right_path,
 				     subtree_index, dealloc);
-		ocfs2_update_edge_lengths(inode, handle, left_path);
+		ret = ocfs2_update_edge_lengths(inode, handle, subtree_index,
+						left_path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 
 		eb = (struct ocfs2_extent_block *)path_leaf_bh(left_path)->b_data;
 		ocfs2_et_set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
@@ -3034,7 +3063,12 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 
 		ocfs2_unlink_subtree(inode, handle, left_path, path,
 				     subtree_index, dealloc);
-		ocfs2_update_edge_lengths(inode, handle, left_path);
+		ret = ocfs2_update_edge_lengths(inode, handle, subtree_index,
+						left_path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 
 		eb = (struct ocfs2_extent_block *)path_leaf_bh(left_path)->b_data;
 		ocfs2_et_set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
-- 
1.6.2.rc2.16.gf474c
