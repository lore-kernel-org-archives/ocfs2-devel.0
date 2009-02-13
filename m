From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:04 -0800
Subject: [Ocfs2-devel] [PATCH 17/40] ocfs2: ocfs2_update_edge_lengths()
	doesn't need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-18-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Unused parameter.  Remove it.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 449e89a..ada1049 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2337,7 +2337,7 @@ out_ret_path:
 	return ret;
 }
 
-static void ocfs2_update_edge_lengths(struct inode *inode, handle_t *handle,
+static void ocfs2_update_edge_lengths(handle_t *handle,
 				      struct ocfs2_path *path)
 {
 	int i, idx;
@@ -2580,7 +2580,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 	if (del_right_subtree) {
 		ocfs2_unlink_subtree(handle, et, left_path, right_path,
 				     subtree_index, dealloc);
-		ocfs2_update_edge_lengths(inode, handle, left_path);
+		ocfs2_update_edge_lengths(handle, left_path);
 
 		eb = (struct ocfs2_extent_block *)path_leaf_bh(left_path)->b_data;
 		ocfs2_et_set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
@@ -2898,7 +2898,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 
 		ocfs2_unlink_subtree(handle, et, left_path, path,
 				     subtree_index, dealloc);
-		ocfs2_update_edge_lengths(inode, handle, left_path);
+		ocfs2_update_edge_lengths(handle, left_path);
 
 		eb = (struct ocfs2_extent_block *)path_leaf_bh(left_path)->b_data;
 		ocfs2_et_set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
-- 
1.5.6.5
