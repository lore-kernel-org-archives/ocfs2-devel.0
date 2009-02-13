From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:09 -0800
Subject: [Ocfs2-devel] [PATCH 22/40] ocfs2: ocfs2_try_to_merge_extent()
	doesn't need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-23-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's not using it, so remove it from the parameter list.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c43243b..c3b7850 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3460,15 +3460,13 @@ out:
 	return ret;
 }
 
-static int ocfs2_try_to_merge_extent(struct inode *inode,
-				     handle_t *handle,
+static int ocfs2_try_to_merge_extent(handle_t *handle,
+				     struct ocfs2_extent_tree *et,
 				     struct ocfs2_path *path,
 				     int split_index,
 				     struct ocfs2_extent_rec *split_rec,
 				     struct ocfs2_cached_dealloc_ctxt *dealloc,
-				     struct ocfs2_merge_ctxt *ctxt,
-				     struct ocfs2_extent_tree *et)
-
+				     struct ocfs2_merge_ctxt *ctxt)
 {
 	int ret = 0;
 	struct ocfs2_extent_list *el = path_leaf_el(path);
@@ -4881,9 +4879,9 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 		if (ret)
 			mlog_errno(ret);
 	} else {
-		ret = ocfs2_try_to_merge_extent(inode, handle, path,
+		ret = ocfs2_try_to_merge_extent(handle, et, path,
 						split_index, split_rec,
-						dealloc, &ctxt, et);
+						dealloc, &ctxt);
 		if (ret)
 			mlog_errno(ret);
 	}
-- 
1.5.6.5
