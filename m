From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:40 -0800
Subject: [Ocfs2-devel] [PATCH 21/45] ocfs2: turn
	__ocfs2_remove_inode_range() into ocfs2_remove_btree_range()
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-22-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

This patch genericizes the high level handling of extent removal.
ocfs2_remove_btree_range() is nearly identical to
__ocfs2_remove_inode_range(), except that extent tree operations have been
used where necessary. We update ocfs2_remove_inode_range() to use the
generic helper. Now extent tree based structures have an easy way to
truncate ranges.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   72 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h |    5 +++
 fs/ocfs2/file.c  |   85 +++--------------------------------------------------
 3 files changed, 82 insertions(+), 80 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4614614..5592a2f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5255,6 +5255,78 @@ out:
 	return ret;
 }
 
+int ocfs2_remove_btree_range(struct inode *inode,
+			     struct ocfs2_extent_tree *et,
+			     u32 cpos, u32 phys_cpos, u32 len,
+			     struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *tl_inode = osb->osb_tl_inode;
+	handle_t *handle;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+
+	ret = ocfs2_lock_allocators(inode, et, 0, 1, NULL, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	mutex_lock(&tl_inode->i_mutex);
+
+	if (ocfs2_truncate_log_needs_flush(osb)) {
+		ret = __ocfs2_flush_truncate_log(osb);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, et->et_root_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_remove_extent(inode, et, cpos, len, handle, meta_ac,
+				  dealloc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ocfs2_et_update_clusters(inode, et, -len);
+
+	ret = ocfs2_journal_dirty(handle, et->et_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_truncate_log_append(osb, handle, phys_blkno, len);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	mutex_unlock(&tl_inode->i_mutex);
+
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+
+	return ret;
+}
+
 int ocfs2_truncate_log_needs_flush(struct ocfs2_super *osb)
 {
 	struct buffer_head *tl_bh = osb->osb_tl_bh;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 3eb735e..0fbf8fc 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -110,6 +110,11 @@ int ocfs2_remove_extent(struct inode *inode,
 			u32 cpos, u32 len, handle_t *handle,
 			struct ocfs2_alloc_context *meta_ac,
 			struct ocfs2_cached_dealloc_ctxt *dealloc);
+int ocfs2_remove_btree_range(struct inode *inode,
+			     struct ocfs2_extent_tree *et,
+			     u32 cpos, u32 phys_cpos, u32 len,
+			     struct ocfs2_cached_dealloc_ctxt *dealloc);
+
 int ocfs2_num_free_extents(struct ocfs2_super *osb,
 			   struct inode *inode,
 			   struct ocfs2_extent_tree *et);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e2570a3..3605491 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1226,83 +1226,6 @@ out:
 	return ret;
 }
 
-static int __ocfs2_remove_inode_range(struct inode *inode,
-				      struct buffer_head *di_bh,
-				      u32 cpos, u32 phys_cpos, u32 len,
-				      struct ocfs2_cached_dealloc_ctxt *dealloc)
-{
-	int ret;
-	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct inode *tl_inode = osb->osb_tl_inode;
-	handle_t *handle;
-	struct ocfs2_alloc_context *meta_ac = NULL;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
-	struct ocfs2_extent_tree et;
-
-	ocfs2_init_dinode_extent_tree(&et, inode, di_bh);
-
-	ret = ocfs2_lock_allocators(inode, &et, 0, 1, NULL, &meta_ac);
-	if (ret) {
-		mlog_errno(ret);
-		return ret;
-	}
-
-	mutex_lock(&tl_inode->i_mutex);
-
-	if (ocfs2_truncate_log_needs_flush(osb)) {
-		ret = __ocfs2_flush_truncate_log(osb);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
-
-	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_journal_access(handle, inode, di_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, meta_ac,
-				  dealloc);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
-
-	OCFS2_I(inode)->ip_clusters -= len;
-	di->i_clusters = cpu_to_le32(OCFS2_I(inode)->ip_clusters);
-
-	ret = ocfs2_journal_dirty(handle, di_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
-
-	ret = ocfs2_truncate_log_append(osb, handle, phys_blkno, len);
-	if (ret)
-		mlog_errno(ret);
-
-out_commit:
-	ocfs2_commit_trans(osb, handle);
-out:
-	mutex_unlock(&tl_inode->i_mutex);
-
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
-
-	return ret;
-}
-
 /*
  * Truncate a byte range, avoiding pages within partial clusters. This
  * preserves those pages for the zeroing code to write to.
@@ -1402,7 +1325,9 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct address_space *mapping = inode->i_mapping;
+	struct ocfs2_extent_tree et;
 
+	ocfs2_init_dinode_extent_tree(&et, inode, di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
 	if (byte_len == 0)
@@ -1458,9 +1383,9 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 
 		/* Only do work for non-holes */
 		if (phys_cpos != 0) {
-			ret = __ocfs2_remove_inode_range(inode, di_bh, cpos,
-							 phys_cpos, alloc_size,
-							 &dealloc);
+			ret = ocfs2_remove_btree_range(inode, &et, cpos,
+						       phys_cpos, alloc_size,
+						       &dealloc);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
-- 
1.5.6
