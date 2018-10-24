From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 24 Oct 2018 13:05:31 +0300
Subject: [Ocfs2-devel] [PATCH RESEND] ocfs2: clean up some data_ac usage
Message-ID: <20181024100531.wxdstp77isbyo4rk@kili.mountain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I started looking at this code because of a Smatch false positive:

    fs/ocfs2/move_extents.c:347 ocfs2_defrag_extent()
    warn: variable dereferenced before check 'context->data_ac' (see line 304)

context->data_ac can't be NULL so I removed the check.  I changed the
next lines to use "data_ac" instead of "context->data_ac" for
consistency.  And we don't need to pass "data_ac" to
ocfs2_lock_meta_allocator_move_extents() any more so I removed that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
It should apply now.

 fs/ocfs2/move_extents.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 099016c9644e..9ee89d6816bc 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -160,15 +160,12 @@ static int __ocfs2_move_extent(handle_t *handle,
  * lock allocators, and reserving appropriate number of bits for
  * meta blocks and data clusters.
  *
- * in some cases, we don't need to reserve clusters, just let data_ac
- * be NULL.
  */
 static int ocfs2_lock_meta_allocator_move_extents(struct inode *inode,
 					struct ocfs2_extent_tree *et,
 					u32 clusters_to_move,
 					u32 extents_to_split,
 					struct ocfs2_alloc_context **meta_ac,
-					struct ocfs2_alloc_context **data_ac,
 					int extra_blocks,
 					int *credits)
 {
@@ -255,7 +252,6 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 	ret = ocfs2_lock_meta_allocator_move_extents(inode, &context->et,
 						*len, 1,
 						&context->meta_ac,
-						&context->data_ac,
 						extra_blocks, &credits);
 	if (ret) {
 		mlog_errno(ret);
@@ -344,10 +340,10 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 		mlog_errno(ret);
 
 out_commit:
-	if (need_free && context->data_ac) {
+	if (need_free) {
 		struct ocfs2_alloc_context *data_ac = context->data_ac;
 
-		if (context->data_ac->ac_which == OCFS2_AC_USE_LOCAL)
+		if (data_ac->ac_which == OCFS2_AC_USE_LOCAL)
 			ocfs2_free_local_alloc_bits(osb, handle, data_ac,
 					new_phys_cpos, new_len);
 		else
@@ -629,7 +625,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	ret = ocfs2_lock_meta_allocator_move_extents(inode, &context->et,
 						len, 1,
 						&context->meta_ac,
-						NULL, extra_blocks, &credits);
+						extra_blocks, &credits);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
-- 
2.11.0
