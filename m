From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 18 Mar 2011 14:35:29 +0800
Subject: [Ocfs2-devel] [PATCH 02/16] Ocfs2/refcounttree: Publicate couple of
	funcs from refcounttree.c
In-Reply-To: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
References: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1300430143-23909-3-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The original goal of commonizing these funcs is to benefit defraging/extent_moving
codes in the future,  based on the fact that reflink and defragmentation having
the same Copy-On-Wrtie mechanism.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/refcounttree.c |   58 +++++++++++++++++++++++-----------------------
 fs/ocfs2/refcounttree.h |   11 +++++++++
 2 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 19ebc5a..bd4ca78 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -66,7 +66,7 @@ struct ocfs2_cow_context {
 			    u32 *num_clusters,
 			    unsigned int *extent_flags);
 	int (*cow_duplicate_clusters)(handle_t *handle,
-				      struct ocfs2_cow_context *context,
+				      struct file *file,
 				      u32 cpos, u32 old_cluster,
 				      u32 new_cluster, u32 new_len);
 };
@@ -2922,20 +2922,21 @@ static int ocfs2_clear_cow_buffer(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
-static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
-					    struct ocfs2_cow_context *context,
-					    u32 cpos, u32 old_cluster,
-					    u32 new_cluster, u32 new_len)
+int ocfs2_duplicate_clusters_by_page(handle_t *handle,
+				     struct file *file,
+				     u32 cpos, u32 old_cluster,
+				     u32 new_cluster, u32 new_len)
 {
 	int ret = 0, partial;
-	struct ocfs2_caching_info *ci = context->data_et.et_ci;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct ocfs2_caching_info *ci = INODE_CACHE(inode);
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
 	struct page *page;
 	pgoff_t page_index;
 	unsigned int from, to, readahead_pages;
 	loff_t offset, end, map_end;
-	struct address_space *mapping = context->inode->i_mapping;
+	struct address_space *mapping = inode->i_mapping;
 
 	mlog(0, "old_cluster %u, new %u, len %u at offset %u\n", old_cluster,
 	     new_cluster, new_len, cpos);
@@ -2949,8 +2950,8 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 	 * We only duplicate pages until we reach the page contains i_size - 1.
 	 * So trim 'end' to i_size.
 	 */
-	if (end > i_size_read(context->inode))
-		end = i_size_read(context->inode);
+	if (end > i_size_read(inode))
+		end = i_size_read(inode);
 
 	while (offset < end) {
 		page_index = offset >> PAGE_CACHE_SHIFT;
@@ -2973,10 +2974,9 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 		if (PAGE_CACHE_SIZE <= OCFS2_SB(sb)->s_clustersize)
 			BUG_ON(PageDirty(page));
 
-		if (PageReadahead(page) && context->file) {
+		if (PageReadahead(page) && file) {
 			page_cache_async_readahead(mapping,
-						   &context->file->f_ra,
-						   context->file,
+						   &file->f_ra, file,
 						   page, page_index,
 						   readahead_pages);
 		}
@@ -3000,8 +3000,7 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 			}
 		}
 
-		ocfs2_map_and_dirty_page(context->inode,
-					 handle, from, to,
+		ocfs2_map_and_dirty_page(inode, handle, from, to,
 					 page, 0, &new_block);
 		mark_page_accessed(page);
 unlock:
@@ -3016,14 +3015,15 @@ unlock:
 	return ret;
 }
 
-static int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
-					   struct ocfs2_cow_context *context,
-					   u32 cpos, u32 old_cluster,
-					   u32 new_cluster, u32 new_len)
+int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
+				    struct file *file,
+				    u32 cpos, u32 old_cluster,
+				    u32 new_cluster, u32 new_len)
 {
 	int ret = 0;
-	struct super_block *sb = context->inode->i_sb;
-	struct ocfs2_caching_info *ci = context->data_et.et_ci;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct ocfs2_caching_info *ci = INODE_CACHE(inode);
 	int i, blocks = ocfs2_clusters_to_blocks(sb, new_len);
 	u64 old_block = ocfs2_clusters_to_blocks(sb, old_cluster);
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
@@ -3146,8 +3146,8 @@ static int ocfs2_replace_clusters(handle_t *handle,
 
 	/*If the old clusters is unwritten, no need to duplicate. */
 	if (!(ext_flags & OCFS2_EXT_UNWRITTEN)) {
-		ret = context->cow_duplicate_clusters(handle, context, cpos,
-						      old, new, len);
+		ret = context->cow_duplicate_clusters(handle, context->file,
+						      cpos, old, new, len);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3163,22 +3163,22 @@ out:
 	return ret;
 }
 
-static int ocfs2_cow_sync_writeback(struct super_block *sb,
-				    struct ocfs2_cow_context *context,
-				    u32 cpos, u32 num_clusters)
+int ocfs2_cow_sync_writeback(struct super_block *sb,
+			     struct inode *inode,
+			     u32 cpos, u32 num_clusters)
 {
 	int ret = 0;
 	loff_t offset, end, map_end;
 	pgoff_t page_index;
 	struct page *page;
 
-	if (ocfs2_should_order_data(context->inode))
+	if (ocfs2_should_order_data(inode))
 		return 0;
 
 	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
 	end = offset + (num_clusters << OCFS2_SB(sb)->s_clustersize_bits);
 
-	ret = filemap_fdatawrite_range(context->inode->i_mapping,
+	ret = filemap_fdatawrite_range(inode->i_mapping,
 				       offset, end - 1);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -3191,7 +3191,7 @@ static int ocfs2_cow_sync_writeback(struct super_block *sb,
 		if (map_end > end)
 			map_end = end;
 
-		page = find_or_create_page(context->inode->i_mapping,
+		page = find_or_create_page(inode->i_mapping,
 					   page_index, GFP_NOFS);
 		BUG_ON(!page);
 
@@ -3350,7 +3350,7 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 	 * in write-back mode.
 	 */
 	if (context->get_clusters == ocfs2_di_get_clusters) {
-		ret = ocfs2_cow_sync_writeback(sb, context, cpos,
+		ret = ocfs2_cow_sync_writeback(sb, context->inode, cpos,
 					       orig_num_clusters);
 		if (ret)
 			mlog_errno(ret);
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index c8ce46f..7754608 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -84,6 +84,17 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
 			     struct buffer_head *ref_root_bh,
 			     u32 cpos, u32 write_len,
 			     struct ocfs2_post_refcount *post);
+int ocfs2_duplicate_clusters_by_page(handle_t *handle,
+				     struct file *file,
+				     u32 cpos, u32 old_cluster,
+				     u32 new_cluster, u32 new_len);
+int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
+				    struct file *file,
+				    u32 cpos, u32 old_cluster,
+				    u32 new_cluster, u32 new_len);
+int ocfs2_cow_sync_writeback(struct super_block *sb,
+			     struct inode *inode,
+			     u32 cpos, u32 num_clusters);
 int ocfs2_add_refcount_flag(struct inode *inode,
 			    struct ocfs2_extent_tree *data_et,
 			    struct ocfs2_caching_info *ref_ci,
-- 
1.5.5
