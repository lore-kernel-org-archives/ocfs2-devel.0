From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 28 Dec 2010 19:40:43 +0800
Subject: [Ocfs2-devel] [PATCH 3/8] Ocfs2: Duplicate old clusters into new
	blk_offset by dirty and remap pages.
In-Reply-To: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
References: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1293536448-20516-4-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Most of codes for duplicating clusters into new_blkoffset where extent will
be moved, were copid from refcounttree's CoW logics, the intention of making
an exact copy here is to make extents moving codes work at the very beginning
,and also avoid interfering refcounttree's codes at most.

Final version will be using some common funcs with refcounttree part.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index f5bbb28..3601545 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -49,6 +49,113 @@ struct ocfs2_move_extents_context {
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 };
 
+static int ocfs2_clear_cow_buffer(handle_t *handle, struct buffer_head *bh)
+{
+	BUG_ON(buffer_dirty(bh));
+
+	clear_buffer_mapped(bh);
+
+	return 0;
+}
+
+#define MAX_CONTIG_BYTES        1048576
+
+static inline unsigned int ocfs2_cow_contig_clusters(struct super_block *sb)
+{
+	return ocfs2_clusters_for_bytes(sb, MAX_CONTIG_BYTES);
+}
+
+/*
+ * Duplicate clusters into new blk_offset, following codes were almost taken
+ * from refcounttree.c on CoW.
+ */
+int ocfs2_duplicate_clusters_by_page(handle_t *handle,
+				     struct ocfs2_move_extents_context *context,
+				     u32 cpos, u32 old_cluster,
+				     u32 new_cluster, u32 len)
+{
+	int ret = 0, partial;
+	struct inode *inode = context->inode;
+	struct ocfs2_caching_info *ci = INODE_CACHE(inode);
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
+	struct page *page;
+	pgoff_t page_index;
+	unsigned int from, to, readahead_pages;
+	loff_t offset, end, map_end;
+	struct address_space *mapping = inode->i_mapping;
+
+	mlog(0, "old_cluster %u, new %u, len %u at offset %u\n", old_cluster,
+	     new_cluster, len, cpos);
+
+	readahead_pages =
+		(ocfs2_cow_contig_clusters(sb) <<
+		 OCFS2_SB(sb)->s_clustersize_bits) >> PAGE_CACHE_SHIFT;
+	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
+	end = offset + (len << OCFS2_SB(sb)->s_clustersize_bits);
+
+	if (end > i_size_read(inode))
+		end = i_size_read(inode);
+
+	while (offset < end) {
+		page_index = offset >> PAGE_CACHE_SHIFT;
+		map_end = ((loff_t)page_index + 1) << PAGE_CACHE_SHIFT;
+		if (map_end > end)
+			map_end = end;
+
+		from = offset & (PAGE_CACHE_SIZE - 1);
+		to = PAGE_CACHE_SIZE;
+		if (map_end & (PAGE_CACHE_SIZE - 1))
+			to = map_end & (PAGE_CACHE_SIZE - 1);
+
+		page = find_or_create_page(mapping, page_index, GFP_NOFS);
+
+		if (PAGE_CACHE_SIZE <= OCFS2_SB(sb)->s_clustersize)
+			BUG_ON(PageDirty(page));
+
+		if (PageReadahead(page) && context->file) {
+			page_cache_async_readahead(mapping,
+						   &context->file->f_ra,
+						   context->file,
+						   page, page_index,
+						   readahead_pages);
+		}
+
+		if (!PageUptodate(page)) {
+			ret = block_read_full_page(page, ocfs2_get_block);
+			if (ret) {
+				mlog_errno(ret);
+				goto unlock;
+			}
+			lock_page(page);
+		}
+
+		if (page_has_buffers(page)) {
+			ret = walk_page_buffers(handle, page_buffers(page),
+						from, to, &partial,
+						ocfs2_clear_cow_buffer);
+			if (ret) {
+				mlog_errno(ret);
+				goto unlock;
+			}
+		}
+
+		ocfs2_map_and_dirty_page(inode,
+					 handle, from, to,
+					 page, 0, &new_block);
+		mark_page_accessed(page);
+unlock:
+		unlock_page(page);
+		page_cache_release(page);
+		page = NULL;
+		offset = map_end;
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
 static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 {
 	int status;
-- 
1.5.5
