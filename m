From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:27 -0800
Subject: [Ocfs2-devel] [PATCH 40/40] ocfs2: Pass ocfs2_caching_info into
	ocfs_init_*_extent_tree().
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-41-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

With this commit, extent tree operations are divorced from inodes and
rely on ocfs2_caching_info.  Phew!

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   18 +++++++++---------
 fs/ocfs2/alloc.h |    6 +++---
 fs/ocfs2/aops.c  |    6 ++++--
 fs/ocfs2/dir.c   |    5 +++--
 fs/ocfs2/file.c  |    6 +++---
 fs/ocfs2/xattr.c |    8 ++++----
 6 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c7aaec8..1df036a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -319,7 +319,7 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 };
 
 static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
-				     struct inode *inode,
+				     struct ocfs2_caching_info *ci,
 				     struct buffer_head *bh,
 				     ocfs2_journal_access_func access,
 				     void *obj,
@@ -327,7 +327,7 @@ static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 {
 	et->et_ops = ops;
 	et->et_root_bh = bh;
-	et->et_ci = INODE_CACHE(inode);
+	et->et_ci = ci;
 	et->et_root_journal_access = access;
 	if (!obj)
 		obj = (void *)bh->b_data;
@@ -341,26 +341,26 @@ static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 }
 
 void ocfs2_init_dinode_extent_tree(struct ocfs2_extent_tree *et,
-				   struct inode *inode,
+				   struct ocfs2_caching_info *ci,
 				   struct buffer_head *bh)
 {
-	__ocfs2_init_extent_tree(et, inode, bh, ocfs2_journal_access_di,
+	__ocfs2_init_extent_tree(et, ci, bh, ocfs2_journal_access_di,
 				 NULL, &ocfs2_dinode_et_ops);
 }
 
 void ocfs2_init_xattr_tree_extent_tree(struct ocfs2_extent_tree *et,
-				       struct inode *inode,
+				       struct ocfs2_caching_info *ci,
 				       struct buffer_head *bh)
 {
-	__ocfs2_init_extent_tree(et, inode, bh, ocfs2_journal_access_xb,
+	__ocfs2_init_extent_tree(et, ci, bh, ocfs2_journal_access_xb,
 				 NULL, &ocfs2_xattr_tree_et_ops);
 }
 
 void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
-					struct inode *inode,
+					struct ocfs2_caching_info *ci,
 					struct ocfs2_xattr_value_buf *vb)
 {
-	__ocfs2_init_extent_tree(et, inode, vb->vb_bh, vb->vb_access, vb,
+	__ocfs2_init_extent_tree(et, ci, vb->vb_bh, vb->vb_access, vb,
 				 &ocfs2_xattr_value_et_ops);
 }
 
@@ -7055,7 +7055,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		 * this proves to be false, we could always re-build
 		 * the in-inode data from our pages.
 		 */
-		ocfs2_init_dinode_extent_tree(&et, inode, di_bh);
+		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 		ret = ocfs2_insert_extent(handle, &et, 0, block, 1, 0, NULL);
 		if (ret) {
 			mlog_errno(ret);
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 2e2996b..07f6315 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -68,14 +68,14 @@ struct ocfs2_extent_tree {
  * specified object buffer.
  */
 void ocfs2_init_dinode_extent_tree(struct ocfs2_extent_tree *et,
-				   struct inode *inode,
+				   struct ocfs2_caching_info *ci,
 				   struct buffer_head *bh);
 void ocfs2_init_xattr_tree_extent_tree(struct ocfs2_extent_tree *et,
-				       struct inode *inode,
+				       struct ocfs2_caching_info *ci,
 				       struct buffer_head *bh);
 struct ocfs2_xattr_value_buf;
 void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
-					struct inode *inode,
+					struct ocfs2_caching_info *ci,
 					struct ocfs2_xattr_value_buf *vb);
 
 /*
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c3bb78a..2e71729 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1260,7 +1260,8 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 			goto out;
 		}
 	} else if (unwritten) {
-		ocfs2_init_dinode_extent_tree(&et, inode, wc->w_di_bh);
+		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
+					      wc->w_di_bh);
 		ret = ocfs2_mark_extent_written(inode, &et,
 						wc->w_handle, cpos, 1, phys,
 						meta_ac, &wc->w_dealloc);
@@ -1704,7 +1705,8 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		     (long long)i_size_read(inode), le32_to_cpu(di->i_clusters),
 		     clusters_to_alloc, extents_to_split);
 
-		ocfs2_init_dinode_extent_tree(&et, inode, wc->w_di_bh);
+		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
+					      wc->w_di_bh);
 		ret = ocfs2_lock_allocators(inode, &et,
 					    clusters_to_alloc, extents_to_split,
 					    &data_ac, &meta_ac);
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 2684c99..b361bfb 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1414,7 +1414,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	struct ocfs2_extent_tree et;
 	int did_quota = 0;
 
-	ocfs2_init_dinode_extent_tree(&et, dir, di_bh);
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(dir), di_bh);
 
 	alloc = ocfs2_clusters_for_bytes(sb, bytes);
 
@@ -1723,7 +1723,8 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 	spin_lock(&OCFS2_I(dir)->ip_lock);
 	if (dir_i_size == ocfs2_clusters_to_bytes(sb, OCFS2_I(dir)->ip_clusters)) {
 		spin_unlock(&OCFS2_I(dir)->ip_lock);
-		ocfs2_init_dinode_extent_tree(&et, dir, parent_fe_bh);
+		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(dir),
+					      parent_fe_bh);
 		num_free_extents = ocfs2_num_free_extents(osb, &et);
 		if (num_free_extents < 0) {
 			status = num_free_extents;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1d0de23..796be27 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -512,7 +512,7 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
 	int ret;
 	struct ocfs2_extent_tree et;
 
-	ocfs2_init_dinode_extent_tree(&et, inode, fe_bh);
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
 	ret = ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
 					  clusters_to_add, mark_unwritten,
 					  data_ac, meta_ac, reason_ret);
@@ -560,7 +560,7 @@ restart_all:
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     (long long)i_size_read(inode), le32_to_cpu(fe->i_clusters),
 	     clusters_to_add);
-	ocfs2_init_dinode_extent_tree(&et, inode, bh);
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), bh);
 	status = ocfs2_lock_allocators(inode, &et, clusters_to_add, 0,
 				       &data_ac, &meta_ac);
 	if (status) {
@@ -1384,7 +1384,7 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	struct address_space *mapping = inode->i_mapping;
 	struct ocfs2_extent_tree et;
 
-	ocfs2_init_dinode_extent_tree(&et, inode, di_bh);
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
 	if (byte_len == 0)
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0970089..197f10d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -597,7 +597,7 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 
 	mlog(0, "(clusters_to_add for xattr= %u)\n", clusters_to_add);
 
-	ocfs2_init_xattr_value_extent_tree(&et, inode, vb);
+	ocfs2_init_xattr_value_extent_tree(&et, INODE_CACHE(inode), vb);
 
 	status = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
 			      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -649,7 +649,7 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 	handle_t *handle = ctxt->handle;
 	struct ocfs2_extent_tree et;
 
-	ocfs2_init_xattr_value_extent_tree(&et, inode, vb);
+	ocfs2_init_xattr_value_extent_tree(&et, INODE_CACHE(inode), vb);
 
 	ret = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
 			    OCFS2_JOURNAL_ACCESS_WRITE);
@@ -4259,7 +4259,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     prev_cpos, (unsigned long long)bucket_blkno(first));
 
-	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
+	ocfs2_init_xattr_tree_extent_tree(&et, INODE_CACHE(inode), root_bh);
 
 	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode), root_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -4820,7 +4820,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct ocfs2_extent_tree et;
 
-	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
+	ocfs2_init_xattr_tree_extent_tree(&et, INODE_CACHE(inode), root_bh);
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
-- 
1.5.6.5
