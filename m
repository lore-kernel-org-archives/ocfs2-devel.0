From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:12 -0800
Subject: [Ocfs2-devel] [PATCH 25/40] ocfs2: ocfs2_truncate_rec() doesn't
	need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-26-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's not using it anymore.  Remove it from the parameter list.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index e2c4825..a722536 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5036,16 +5036,16 @@ out:
 	return ret;
 }
 
-static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
+static int ocfs2_truncate_rec(handle_t *handle,
+			      struct ocfs2_extent_tree *et,
 			      struct ocfs2_path *path, int index,
 			      struct ocfs2_cached_dealloc_ctxt *dealloc,
-			      u32 cpos, u32 len,
-			      struct ocfs2_extent_tree *et)
+			      u32 cpos, u32 len)
 {
 	int ret;
 	u32 left_cpos, rec_range, trunc_range;
 	int wants_rotate = 0, is_rightmost_tree_rec = 0;
-	struct super_block *sb = inode->i_sb;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
 	struct ocfs2_path *left_path = NULL;
 	struct ocfs2_extent_list *el = path_leaf_el(path);
 	struct ocfs2_extent_rec *rec;
@@ -5084,14 +5084,13 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 		 * by this leaf and the one to it's left.
 		 *
 		 * There are two cases we can skip:
-		 *   1) Path is the leftmost one in our inode tree.
+		 *   1) Path is the leftmost one in our btree.
 		 *   2) The leaf is rightmost and will be empty after
 		 *      we remove the extent record - the rotate code
 		 *      knows how to update the newly formed edge.
 		 */
 
-		ret = ocfs2_find_cpos_for_left_leaf(inode->i_sb, path,
-						    &left_cpos);
+		ret = ocfs2_find_cpos_for_left_leaf(sb, path, &left_cpos);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -5166,8 +5165,9 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 			ocfs2_adjust_rightmost_records(handle, et, path, rec);
 	} else {
 		/* Caller should have trapped this. */
-		mlog(ML_ERROR, "Inode %llu: Invalid record truncate: (%u, %u) "
-		     "(%u, %u)\n", (unsigned long long)OCFS2_I(inode)->ip_blkno,
+		mlog(ML_ERROR, "Owner %llu: Invalid record truncate: (%u, %u) "
+		     "(%u, %u)\n",
+		     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 		     le32_to_cpu(rec->e_cpos),
 		     le16_to_cpu(rec->e_leaf_clusters), cpos, len);
 		BUG();
@@ -5260,8 +5260,8 @@ int ocfs2_remove_extent(struct inode *inode,
 	     le32_to_cpu(rec->e_cpos), ocfs2_rec_clusters(el, rec));
 
 	if (le32_to_cpu(rec->e_cpos) == cpos || rec_range == trunc_range) {
-		ret = ocfs2_truncate_rec(inode, handle, path, index, dealloc,
-					 cpos, len, et);
+		ret = ocfs2_truncate_rec(handle, et, path, index, dealloc,
+					 cpos, len);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -5315,8 +5315,8 @@ int ocfs2_remove_extent(struct inode *inode,
 			goto out;
 		}
 
-		ret = ocfs2_truncate_rec(inode, handle, path, index, dealloc,
-					 cpos, len, et);
+		ret = ocfs2_truncate_rec(handle, et, path, index, dealloc,
+					 cpos, len);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
-- 
1.5.6.5
