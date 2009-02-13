From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:59 -0800
Subject: [Ocfs2-devel] [PATCH 12/40] ocfs2: ocfs2_complete_edge_insert()
	doesn't need struct inode at all.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-13-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Completely unused argument.  Get rid of it.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c478e2a..7209463 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1853,7 +1853,7 @@ static void ocfs2_adjust_root_records(struct ocfs2_extent_list *root_el,
  *   - When we've adjusted the last extent record in the left path leaf and the
  *     1st extent record in the right path leaf during cross extent block merge.
  */
-static void ocfs2_complete_edge_insert(struct inode *inode, handle_t *handle,
+static void ocfs2_complete_edge_insert(handle_t *handle,
 				       struct ocfs2_path *left_path,
 				       struct ocfs2_path *right_path,
 				       int subtree_index)
@@ -2030,8 +2030,8 @@ static int ocfs2_rotate_subtree_right(struct inode *inode,
 		goto out;
 	}
 
-	ocfs2_complete_edge_insert(inode, handle, left_path, right_path,
-				subtree_index);
+	ocfs2_complete_edge_insert(handle, left_path, right_path,
+				   subtree_index);
 
 out:
 	return ret;
@@ -2612,7 +2612,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 
 		*deleted = 1;
 	} else
-		ocfs2_complete_edge_insert(inode, handle, left_path, right_path,
+		ocfs2_complete_edge_insert(handle, left_path, right_path,
 					   subtree_index);
 
 out:
@@ -3265,8 +3265,8 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 		if (ret)
 			mlog_errno(ret);
 
-		ocfs2_complete_edge_insert(inode, handle, left_path,
-					   right_path, subtree_index);
+		ocfs2_complete_edge_insert(handle, left_path, right_path,
+					   subtree_index);
 	}
 out:
 	if (right_path)
@@ -3464,7 +3464,7 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 			ocfs2_mv_path(right_path, left_path);
 			left_path = NULL;
 		} else
-			ocfs2_complete_edge_insert(inode, handle, left_path,
+			ocfs2_complete_edge_insert(handle, left_path,
 						   right_path, subtree_index);
 	}
 out:
@@ -4030,8 +4030,8 @@ static int ocfs2_insert_path(struct inode *inode,
 		 */
 		subtree_index = ocfs2_find_subtree_root(inode, left_path,
 							right_path);
-		ocfs2_complete_edge_insert(inode, handle, left_path,
-					   right_path, subtree_index);
+		ocfs2_complete_edge_insert(handle, left_path, right_path,
+					   subtree_index);
 	}
 
 	ret = 0;
@@ -5207,7 +5207,7 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 		int subtree_index;
 
 		subtree_index = ocfs2_find_subtree_root(inode, left_path, path);
-		ocfs2_complete_edge_insert(inode, handle, left_path, path,
+		ocfs2_complete_edge_insert(handle, left_path, path,
 					   subtree_index);
 	}
 
-- 
1.5.6.5
