From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:58 -0800
Subject: [Ocfs2-devel] [PATCH 11/40] ocfs2: Pass ocfs2_extent_tree to
	ocfs2_unlink_path()
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-12-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_unlink_path() doesn't need struct inode, so let's pass it struct
ocfs2_extent_tree.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index cf6c7e4..c478e2a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2381,7 +2381,8 @@ static void ocfs2_update_edge_lengths(struct inode *inode, handle_t *handle,
 	}
 }
 
-static void ocfs2_unlink_path(struct inode *inode, handle_t *handle,
+static void ocfs2_unlink_path(handle_t *handle,
+			      struct ocfs2_extent_tree *et,
 			      struct ocfs2_cached_dealloc_ctxt *dealloc,
 			      struct ocfs2_path *path, int unlink_start)
 {
@@ -2403,12 +2404,12 @@ static void ocfs2_unlink_path(struct inode *inode, handle_t *handle,
 			mlog(ML_ERROR,
 			     "Inode %llu, attempted to remove extent block "
 			     "%llu with %u records\n",
-			     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 			     (unsigned long long)le64_to_cpu(eb->h_blkno),
 			     le16_to_cpu(el->l_next_free_rec));
 
 			ocfs2_journal_dirty(handle, bh);
-			ocfs2_remove_from_cache(INODE_CACHE(inode), bh);
+			ocfs2_remove_from_cache(et->et_ci, bh);
 			continue;
 		}
 
@@ -2421,11 +2422,12 @@ static void ocfs2_unlink_path(struct inode *inode, handle_t *handle,
 		if (ret)
 			mlog_errno(ret);
 
-		ocfs2_remove_from_cache(INODE_CACHE(inode), bh);
+		ocfs2_remove_from_cache(et->et_ci, bh);
 	}
 }
 
-static void ocfs2_unlink_subtree(struct inode *inode, handle_t *handle,
+static void ocfs2_unlink_subtree(handle_t *handle,
+				 struct ocfs2_extent_tree *et,
 				 struct ocfs2_path *left_path,
 				 struct ocfs2_path *right_path,
 				 int subtree_index,
@@ -2456,7 +2458,7 @@ static void ocfs2_unlink_subtree(struct inode *inode, handle_t *handle,
 	ocfs2_journal_dirty(handle, root_bh);
 	ocfs2_journal_dirty(handle, path_leaf_bh(left_path));
 
-	ocfs2_unlink_path(inode, handle, dealloc, right_path,
+	ocfs2_unlink_path(handle, et, dealloc, right_path,
 			  subtree_index + 1);
 }
 
@@ -2589,7 +2591,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 		mlog_errno(ret);
 
 	if (del_right_subtree) {
-		ocfs2_unlink_subtree(inode, handle, left_path, right_path,
+		ocfs2_unlink_subtree(handle, et, left_path, right_path,
 				     subtree_index, dealloc);
 		ocfs2_update_edge_lengths(inode, handle, left_path);
 
@@ -2907,7 +2909,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 
 		subtree_index = ocfs2_find_subtree_root(inode, left_path, path);
 
-		ocfs2_unlink_subtree(inode, handle, left_path, path,
+		ocfs2_unlink_subtree(handle, et, left_path, path,
 				     subtree_index, dealloc);
 		ocfs2_update_edge_lengths(inode, handle, left_path);
 
@@ -2921,7 +2923,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 		 * revert the inode back to having extents
 		 * in-line.
 		 */
-		ocfs2_unlink_path(inode, handle, dealloc, path, 1);
+		ocfs2_unlink_path(handle, et, dealloc, path, 1);
 
 		el = et->et_root_el;
 		el->l_tree_depth = 0;
-- 
1.5.6.5
