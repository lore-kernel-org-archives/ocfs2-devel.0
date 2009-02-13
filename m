From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:26 -0800
Subject: [Ocfs2-devel] [PATCH 39/40] ocfs2: __ocfs2_mark_extent_written()
	doesn't need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-40-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We only allow unwritten extents on data, so the toplevel
ocfs2_mark_extent_written() can use an inode all it wants.  But the
subfunction isn't even using the inode argument.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 37b1410..c7aaec8 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4841,9 +4841,8 @@ out:
  * have been brought into cache (and pinned via the journal), so the
  * extra overhead is not expressed in terms of disk reads.
  */
-static int __ocfs2_mark_extent_written(struct inode *inode,
+static int __ocfs2_mark_extent_written(handle_t *handle,
 				       struct ocfs2_extent_tree *et,
-				       handle_t *handle,
 				       struct ocfs2_path *path,
 				       int split_index,
 				       struct ocfs2_extent_rec *split_rec,
@@ -4877,7 +4876,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 
 	/*
 	 * The core merge / split code wants to know how much room is
-	 * left in this inodes allocation tree, so we pass the
+	 * left in this allocation tree, so we pass the
 	 * rightmost extent list.
 	 */
 	if (path->p_tree_depth) {
@@ -4999,7 +4998,7 @@ int ocfs2_mark_extent_written(struct inode *inode,
 	split_rec.e_flags = path_leaf_el(left_path)->l_recs[index].e_flags;
 	split_rec.e_flags &= ~OCFS2_EXT_UNWRITTEN;
 
-	ret = __ocfs2_mark_extent_written(inode, et, handle, left_path,
+	ret = __ocfs2_mark_extent_written(handle, et, left_path,
 					  index, &split_rec, meta_ac,
 					  dealloc);
 	if (ret)
-- 
1.5.6.5
