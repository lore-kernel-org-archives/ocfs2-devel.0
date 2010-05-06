From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu,  6 May 2010 14:50:17 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] Ocfs2: Make
	ocfs2_find_cpos_for_left_leaf() public.
In-Reply-To: <1273128618-4184-1-git-send-email-tristan.ye@oracle.com>
References: <1273128618-4184-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1273128618-4184-3-git-send-email-tristan.ye@oracle.com>
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
index e5516a4..c434e43 100644
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
index 2963ed7..d03f765 100644
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
