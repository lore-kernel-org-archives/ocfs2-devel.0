From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 11 May 2010 17:54:44 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] Ocfs2: Make
	ocfs2_find_cpos_for_left_leaf() public.
In-Reply-To: <1273571685-28000-1-git-send-email-tristan.ye@oracle.com>
References: <1273571685-28000-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1273571685-28000-4-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The original idea to pull ocfs2_find_cpos_for_left_leaf() out of
alloc.c is to benefit punching-holes optimization patch, it however,
can also be referred by other funcs in the future who want to do the
same job.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/alloc.c |    4 ++--
 fs/ocfs2/alloc.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 0cb4248..7e9cb75 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2209,8 +2209,8 @@ out:
  *
  * Will return zero if the path passed in is already the leftmost path.
  */
-static int ocfs2_find_cpos_for_left_leaf(struct super_block *sb,
-					 struct ocfs2_path *path, u32 *cpos)
+int ocfs2_find_cpos_for_left_leaf(struct super_block *sb,
+				  struct ocfs2_path *path, u32 *cpos)
 {
 	int i, j, ret = 0;
 	u64 blkno;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 4fb9882..a55a27b 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -319,6 +319,8 @@ int ocfs2_journal_access_path(struct ocfs2_caching_info *ci,
 			      struct ocfs2_path *path);
 int ocfs2_find_cpos_for_right_leaf(struct super_block *sb,
 				   struct ocfs2_path *path, u32 *cpos);
+int ocfs2_find_cpos_for_left_leaf(struct super_block *sb,
+				  struct ocfs2_path *path, u32 *cpos);
 int ocfs2_find_subtree_root(struct ocfs2_extent_tree *et,
 			    struct ocfs2_path *left,
 			    struct ocfs2_path *right);
-- 
1.5.5
