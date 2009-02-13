From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:03 -0800
Subject: [Ocfs2-devel] [PATCH 16/40] ocfs2: ocfs2_rotate_tree_right()
	doesn't need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-17-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We don't need struct inode in ocfs2_rotate_tree_right() anymore.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 06aae9f..449e89a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2180,7 +2180,7 @@ static int ocfs2_leftmost_rec_contains(struct ocfs2_extent_list *el, u32 cpos)
  *   *ret_left_path will contain a valid path which can be passed to
  *   ocfs2_insert_path().
  */
-static int ocfs2_rotate_tree_right(struct inode *inode, handle_t *handle,
+static int ocfs2_rotate_tree_right(handle_t *handle,
 				   struct ocfs2_extent_tree *et,
 				   enum ocfs2_split_type split,
 				   u32 insert_cpos,
@@ -4092,7 +4092,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 	 * can wind up skipping both of these two special cases...
 	 */
 	if (rotate) {
-		ret = ocfs2_rotate_tree_right(inode, handle, et, type->ins_split,
+		ret = ocfs2_rotate_tree_right(handle, et, type->ins_split,
 					      le32_to_cpu(insert_rec->e_cpos),
 					      right_path, &left_path);
 		if (ret) {
-- 
1.5.6.5
