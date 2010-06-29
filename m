From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 29 Jun 2010 16:35:40 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Add readhead during CoW.
In-Reply-To: <4C29AE6C.1050205@oracle.com>
References: <4C29AE6C.1050205@oracle.com>
Message-ID: <1277800541-6844-3-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In CoW, when we meet with a readahead page, we know
it is time to move the readahead window. So carry
out a new readahead.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 03ec6ac..df47182 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -49,6 +49,7 @@
 
 struct ocfs2_cow_context {
 	struct inode *inode;
+	struct file *file;
 	u32 cow_start;
 	u32 cow_len;
 	struct ocfs2_extent_tree data_et;
@@ -2922,13 +2923,16 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
 	struct page *page;
 	pgoff_t page_index;
-	unsigned int from, to;
+	unsigned int from, to, readahead_pages;
 	loff_t offset, end, map_end;
 	struct address_space *mapping = context->inode->i_mapping;
 
 	mlog(0, "old_cluster %u, new %u, len %u at offset %u\n", old_cluster,
 	     new_cluster, new_len, cpos);
 
+	readahead_pages =
+		(ocfs2_cow_contig_clusters(sb) <<
+		 OCFS2_SB(sb)->s_clustersize_bits) >> PAGE_CACHE_SHIFT;
 	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
 	end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
 
@@ -2953,6 +2957,14 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 		if (PAGE_CACHE_SIZE <= OCFS2_SB(sb)->s_clustersize)
 			BUG_ON(PageDirty(page));
 
+		if (PageReadahead(page) && context->file) {
+			page_cache_async_readahead(mapping,
+						   &context->file->f_ra,
+						   context->file,
+						   page, page_index,
+						   readahead_pages);
+		}
+
 		if (!PageUptodate(page)) {
 			ret = block_read_full_page(page, ocfs2_get_block);
 			if (ret) {
@@ -3472,6 +3484,7 @@ static int ocfs2_refcount_cow_hunk(struct inode *inode,
 	context->ref_root_bh = ref_root_bh;
 	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_page;
 	context->get_clusters = ocfs2_di_get_clusters;
+	context->file = file;
 
 	ocfs2_init_dinode_extent_tree(&context->data_et,
 				      INODE_CACHE(inode), di_bh);
-- 
1.7.1.GIT
