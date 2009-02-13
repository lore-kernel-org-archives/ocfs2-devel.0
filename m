From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:24 -0800
Subject: [Ocfs2-devel] [PATCH 37/40] ocfs2: ocfs2_remove_extent() no longer
	needs struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-38-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

One more generic btree function that is isolated from struct inode.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   40 +++++++++++++++++++++-------------------
 fs/ocfs2/alloc.h |    5 ++---
 fs/ocfs2/xattr.c |    4 ++--
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 0f513af..e724fa8 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5011,8 +5011,8 @@ out:
 	return ret;
 }
 
-static int ocfs2_split_tree(struct inode *inode, struct ocfs2_extent_tree *et,
-			    handle_t *handle, struct ocfs2_path *path,
+static int ocfs2_split_tree(handle_t *handle, struct ocfs2_extent_tree *et,
+			    struct ocfs2_path *path,
 			    int index, u32 new_range,
 			    struct ocfs2_alloc_context *meta_ac)
 {
@@ -5029,7 +5029,8 @@ static int ocfs2_split_tree(struct inode *inode, struct ocfs2_extent_tree *et,
 	 */
 	el = path_leaf_el(path);
 	rec = &el->l_recs[index];
-	ocfs2_make_right_split_rec(inode->i_sb, &split_rec, new_range, rec);
+	ocfs2_make_right_split_rec(ocfs2_metadata_cache_get_super(et->et_ci),
+				   &split_rec, new_range, rec);
 
 	depth = path->p_tree_depth;
 	if (depth > 0) {
@@ -5237,9 +5238,9 @@ out:
 	return ret;
 }
 
-int ocfs2_remove_extent(struct inode *inode,
+int ocfs2_remove_extent(handle_t *handle,
 			struct ocfs2_extent_tree *et,
-			u32 cpos, u32 len, handle_t *handle,
+			u32 cpos, u32 len,
 			struct ocfs2_alloc_context *meta_ac,
 			struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
@@ -5271,10 +5272,11 @@ int ocfs2_remove_extent(struct inode *inode,
 	el = path_leaf_el(path);
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
-		ocfs2_error(inode->i_sb,
-			    "Inode %llu has an extent at cpos %u which can no "
+		ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+			    "Owner %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos);
+			    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+			    cpos);
 		ret = -EROFS;
 		goto out;
 	}
@@ -5301,9 +5303,10 @@ int ocfs2_remove_extent(struct inode *inode,
 
 	BUG_ON(cpos < le32_to_cpu(rec->e_cpos) || trunc_range > rec_range);
 
-	mlog(0, "Inode %llu, remove (cpos %u, len %u). Existing index %d "
+	mlog(0, "Owner %llu, remove (cpos %u, len %u). Existing index %d "
 	     "(cpos %u, len %u)\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos, len, index,
+	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+	     cpos, len, index,
 	     le32_to_cpu(rec->e_cpos), ocfs2_rec_clusters(el, rec));
 
 	if (le32_to_cpu(rec->e_cpos) == cpos || rec_range == trunc_range) {
@@ -5314,7 +5317,7 @@ int ocfs2_remove_extent(struct inode *inode,
 			goto out;
 		}
 	} else {
-		ret = ocfs2_split_tree(inode, et, handle, path, index,
+		ret = ocfs2_split_tree(handle, et, path, index,
 				       trunc_range, meta_ac);
 		if (ret) {
 			mlog_errno(ret);
@@ -5336,9 +5339,9 @@ int ocfs2_remove_extent(struct inode *inode,
 		el = path_leaf_el(path);
 		index = ocfs2_search_extent_list(el, cpos);
 		if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
-			ocfs2_error(inode->i_sb,
-				    "Inode %llu: split at cpos %u lost record.",
-				    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+				    "Owner %llu: split at cpos %u lost record.",
+				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 				    cpos);
 			ret = -EROFS;
 			goto out;
@@ -5352,10 +5355,10 @@ int ocfs2_remove_extent(struct inode *inode,
 		rec_range = le32_to_cpu(rec->e_cpos) +
 			ocfs2_rec_clusters(el, rec);
 		if (rec_range != trunc_range) {
-			ocfs2_error(inode->i_sb,
-				    "Inode %llu: error after split at cpos %u"
+			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+				    "Owner %llu: error after split at cpos %u"
 				    "trunc len %u, existing record is (%u,%u)",
-				    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 				    cpos, len, le32_to_cpu(rec->e_cpos),
 				    ocfs2_rec_clusters(el, rec));
 			ret = -EROFS;
@@ -5420,8 +5423,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 	vfs_dq_free_space_nodirty(inode,
 				  ocfs2_clusters_to_bytes(inode->i_sb, len));
 
-	ret = ocfs2_remove_extent(inode, et, cpos, len, handle, meta_ac,
-				  dealloc);
+	ret = ocfs2_remove_extent(handle, et, cpos, len, meta_ac, dealloc);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 380670f..2e2996b 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -114,9 +114,8 @@ int ocfs2_mark_extent_written(struct inode *inode,
 			      handle_t *handle, u32 cpos, u32 len, u32 phys,
 			      struct ocfs2_alloc_context *meta_ac,
 			      struct ocfs2_cached_dealloc_ctxt *dealloc);
-int ocfs2_remove_extent(struct inode *inode,
-			struct ocfs2_extent_tree *et,
-			u32 cpos, u32 len, handle_t *handle,
+int ocfs2_remove_extent(handle_t *handle, struct ocfs2_extent_tree *et,
+			u32 cpos, u32 len,
 			struct ocfs2_alloc_context *meta_ac,
 			struct ocfs2_cached_dealloc_ctxt *dealloc);
 int ocfs2_remove_btree_range(struct inode *inode,
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dba7d45..0970089 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -658,7 +658,7 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, ctxt->meta_ac,
+	ret = ocfs2_remove_extent(handle, &et, cpos, len, ctxt->meta_ac,
 				  &ctxt->dealloc);
 	if (ret) {
 		mlog_errno(ret);
@@ -4860,7 +4860,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, meta_ac,
+	ret = ocfs2_remove_extent(handle, &et, cpos, len, meta_ac,
 				  &dealloc);
 	if (ret) {
 		mlog_errno(ret);
-- 
1.5.6.5
