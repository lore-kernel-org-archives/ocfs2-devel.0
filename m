From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:16 -0800
Subject: [Ocfs2-devel] [PATCH 29/40] ocfs2: ocfs2_do_insert_extent() and
	ocfs2_insert_path() no longer need an inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-30-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

They aren't using it, so remove it from their parameter lists.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 5a50032..7f1a6bc 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3946,8 +3946,7 @@ static void ocfs2_split_record(struct ocfs2_extent_tree *et,
  * in. left_path should only be passed in if we need to update that
  * portion of the tree after an edge insert.
  */
-static int ocfs2_insert_path(struct inode *inode,
-			     handle_t *handle,
+static int ocfs2_insert_path(handle_t *handle,
 			     struct ocfs2_extent_tree *et,
 			     struct ocfs2_path *left_path,
 			     struct ocfs2_path *right_path,
@@ -4036,8 +4035,7 @@ out:
 	return ret;
 }
 
-static int ocfs2_do_insert_extent(struct inode *inode,
-				  handle_t *handle,
+static int ocfs2_do_insert_extent(handle_t *handle,
 				  struct ocfs2_extent_tree *et,
 				  struct ocfs2_extent_rec *insert_rec,
 				  struct ocfs2_insert_type *type)
@@ -4128,7 +4126,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_insert_path(inode, handle, et, left_path, right_path,
+	ret = ocfs2_insert_path(handle, et, left_path, right_path,
 				insert_rec, type);
 	if (ret) {
 		mlog_errno(ret);
@@ -4556,7 +4554,7 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	}
 
 	/* Finally, we can add clusters. This might rotate the tree for us. */
-	status = ocfs2_do_insert_extent(inode, handle, et, &rec, &insert);
+	status = ocfs2_do_insert_extent(handle, et, &rec, &insert);
 	if (status < 0)
 		mlog_errno(status);
 	else if (et->et_ops == &ocfs2_dinode_et_ops)
@@ -4771,7 +4769,7 @@ leftright:
 		do_leftright = 1;
 	}
 
-	ret = ocfs2_do_insert_extent(inode, handle, et, &split_rec, &insert);
+	ret = ocfs2_do_insert_extent(handle, et, &split_rec, &insert);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -5050,7 +5048,7 @@ static int ocfs2_split_tree(struct inode *inode, struct ocfs2_extent_tree *et,
 	insert.ins_split = SPLIT_RIGHT;
 	insert.ins_tree_depth = depth;
 
-	ret = ocfs2_do_insert_extent(inode, handle, et, &split_rec, &insert);
+	ret = ocfs2_do_insert_extent(handle, et, &split_rec, &insert);
 	if (ret)
 		mlog_errno(ret);
 
-- 
1.5.6.5
