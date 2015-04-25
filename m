From: Xue jiufei <xuejiufei@huawei.com>
Date: Sat, 25 Apr 2015 18:54:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove BUG_ON(!empty_extent) in
	__ocfs2_rotate_tree_left
Message-ID: <553B7262.2050503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Function ocfs2_rotate_tree_left call __ocfs2_rotate_tree_left
for left rotation while non-rightmost path containing an empty
extent in the leaf block. __ocfs2_rotate_tree_left return -EAGAIN
if right subtree having an empty extent and pass the empty_extent_path
to caller. The caller ocfs2_rotate_tree_left will restart rotation from the
returned path.

It will trigger the BUG_ON(!ocfs2_is_empty_extent) when the et on disk
is as follows:
eb0 is the leaf block of path(say path_a) passed to ocfs2_rotate_tree_left,
which has an empty rec[0].
eb1 is the leaf block of path(say path_b) that just right to path_a, which
has no empty record.
eb2 is the leaf block of path(say path_c) that just right to path_b, which
has an empty rec[0]. And path_c is also the rightmost path.
Now we want to remove the empty rec[0] in eb0: 
ocfs2_rotate_tree_left:
  -> call __ocfs2_rotate_tree_left with path_a as its input *path*
    -> call ocfs2_rotate_subtree_left with path_a as its input
       *left_path* and path_b as its input *right_path*. it will move
       rec[0] in eb1 to eb0, and rec[0] in eb0 is not empty now.
    -> continue to call ocfs2_rotate_subtree_left with path_b as its
       input *left_path* and path_c as its input *right_path*, and
       return -EAGAIN because eb2 has an empty rec[0]
  -> call __ocfs2_rotate_tree_left with path_c as it input, rotate all
     records in eb2 to left and return 0.
  -> call __ocfs2_rotate_tree_left with path_a as its input, and triggers
     the BUG_ON(!ocfs2_is_empty_extent) as the rec[0] in eb0 is not empty.

So the BUG_ON() should be removed and return 0 if rec[0] is no longer
an empty extent.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ea4c822..5997c00 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2925,7 +2925,8 @@ static int __ocfs2_rotate_tree_left(handle_t *handle,
 	struct ocfs2_path *right_path = NULL;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
 
-	BUG_ON(!ocfs2_is_empty_extent(&(path_leaf_el(path)->l_recs[0])));
+	if (!ocfs2_is_empty_extent(&(path_leaf_el(path)->l_recs[0])))
+		return 0;
 
 	*empty_extent_path = NULL;
 
-- 
1.8.4.3
