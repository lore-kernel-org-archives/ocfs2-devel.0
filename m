From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 10 Oct 2012 18:08:03 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix NULL pointer dereference in
	ocfs2_duplicate_clusters_by_page v2
Message-ID: <1349863683-19207-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since ocfs2_cow_file_pos will invoke ocfs2_refcount_cow with a NULL
as the struct file pointer, it finally result in a null pointer
dereference in ocfs2_duplicate_clusters_by_page.
This patch add checks of file pointer and parameter of inode pointer
in cow_duplicate_clusters to fix this issue.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/move_extents.c |    3 ++-
 fs/ocfs2/refcounttree.c |   16 +++++++++-------
 fs/ocfs2/refcounttree.h |    2 ++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 6083432..668b0d9 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -69,7 +69,8 @@ static int __ocfs2_move_extent(handle_t *handle,
 	u64 ino = ocfs2_metadata_cache_owner(context->et.et_ci);
 	u64 old_blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cpos);
 
-	ret = ocfs2_duplicate_clusters_by_page(handle, context->file, cpos,
+	ret = ocfs2_duplicate_clusters_by_page(handle, inode,
+					       context->file, cpos,
 					       p_cpos, new_p_cpos, len);
 	if (ret) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 30a0550..7269d09 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -66,6 +66,7 @@ struct ocfs2_cow_context {
 			    u32 *num_clusters,
 			    unsigned int *extent_flags);
 	int (*cow_duplicate_clusters)(handle_t *handle,
+				      struct inode *inode,
 				      struct file *file,
 				      u32 cpos, u32 old_cluster,
 				      u32 new_cluster, u32 new_len);
@@ -2922,14 +2923,13 @@ static int ocfs2_clear_cow_buffer(handle_t *handle, struct buffer_head *bh)
 }
 
 int ocfs2_duplicate_clusters_by_page(handle_t *handle,
+				     struct inode *inode,
 				     struct file *file,
 				     u32 cpos, u32 old_cluster,
 				     u32 new_cluster, u32 new_len)
 {
 	int ret = 0, partial;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct ocfs2_caching_info *ci = INODE_CACHE(inode);
-	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	struct super_block *sb = inode->i_sb;
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
 	struct page *page;
 	pgoff_t page_index;
@@ -2973,7 +2973,7 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 		if (PAGE_CACHE_SIZE <= OCFS2_SB(sb)->s_clustersize)
 			BUG_ON(PageDirty(page));
 
-		if (PageReadahead(page)) {
+		if (file && PageReadahead(page)) {
 			page_cache_async_readahead(mapping,
 						   &file->f_ra, file,
 						   page, page_index,
@@ -3015,12 +3015,12 @@ unlock:
 }
 
 int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
+				    struct inode *inode,
 				    struct file *file,
 				    u32 cpos, u32 old_cluster,
 				    u32 new_cluster, u32 new_len)
 {
 	int ret = 0;
-	struct inode *inode = file->f_path.dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
 	struct ocfs2_caching_info *ci = INODE_CACHE(inode);
 	int i, blocks = ocfs2_clusters_to_blocks(sb, new_len);
@@ -3145,7 +3145,8 @@ static int ocfs2_replace_clusters(handle_t *handle,
 
 	/*If the old clusters is unwritten, no need to duplicate. */
 	if (!(ext_flags & OCFS2_EXT_UNWRITTEN)) {
-		ret = context->cow_duplicate_clusters(handle, context->file,
+		ret = context->cow_duplicate_clusters(handle, context->inode,
+						      context->file,
 						      cpos, old, new, len);
 		if (ret) {
 			mlog_errno(ret);
@@ -3480,7 +3481,8 @@ static int ocfs2_refcount_cow_hunk(struct inode *inode,
 
 	BUG_ON(cow_len == 0);
 
-	ocfs2_readahead_for_cow(inode, file, cow_start, cow_len);
+	if (file)
+		ocfs2_readahead_for_cow(inode, file, cow_start, cow_len);
 
 	context = kzalloc(sizeof(struct ocfs2_cow_context), GFP_NOFS);
 	if (!context) {
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 7754608..e02aba8 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -85,10 +85,12 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
 			     u32 cpos, u32 write_len,
 			     struct ocfs2_post_refcount *post);
 int ocfs2_duplicate_clusters_by_page(handle_t *handle,
+				     struct inode *inode,
 				     struct file *file,
 				     u32 cpos, u32 old_cluster,
 				     u32 new_cluster, u32 new_len);
 int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
+				    struct inode *inode,
 				    struct file *file,
 				    u32 cpos, u32 old_cluster,
 				    u32 new_cluster, u32 new_len);
-- 
1.7.4.4
