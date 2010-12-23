From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:54 +0800
Subject: [Ocfs2-devel] [PATCH 11/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/aops.c
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-11-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

Remove all the "mlog(0," in fs/ocfs2/aops.c.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c        |   55 ++++++++--------
 fs/ocfs2/ocfs2_trace.h |  168 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 197 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 177b8b4..e6153cb 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -29,7 +29,6 @@
 #include <linux/mpage.h>
 #include <linux/quotaops.h>
 
-#define MLOG_MASK_PREFIX ML_FILE_IO
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -45,6 +44,7 @@
 #include "super.h"
 #include "symlink.h"
 #include "refcounttree.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -59,8 +59,9 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	void *kaddr;
 
-	mlog(0, "(0x%p, %llu, 0x%p, %d)\n", inode,
-	     (unsigned long long)iblock, bh_result, create);
+	trace_ocfs2_symlink_get_block(
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			(unsigned long long)iblock, bh_result, create);
 
 	BUG_ON(ocfs2_inode_is_fast_symlink(inode));
 
@@ -135,8 +136,8 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
 	u64 p_blkno, count, past_eof;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog(0, "(0x%p, %llu, 0x%p, %d)\n", inode,
-	     (unsigned long long)iblock, bh_result, create);
+	trace_ocfs2_get_block((unsigned long long)OCFS2_I(inode)->ip_blkno,
+			      (unsigned long long)iblock, bh_result, create);
 
 	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
 		mlog(ML_NOTICE, "get_block on system inode 0x%p (%lu)\n",
@@ -198,8 +199,9 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
 	}
 
 	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
-	mlog(0, "Inode %lu, past_eof = %llu\n", inode->i_ino,
-	     (unsigned long long)past_eof);
+
+	trace_ocfs2_get_block_end((unsigned long long)OCFS2_I(inode)->ip_blkno,
+				  (unsigned long long)past_eof);
 	if (create && (iblock >= past_eof))
 		set_buffer_new(bh_result);
 
@@ -276,7 +278,8 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 	loff_t start = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	int ret, unlock = 1;
 
-	mlog(0, "(0x%p, %lu)\n", file, (page ? page->index : 0));
+	trace_ocfs2_readpage((unsigned long long)oi->ip_blkno,
+			     (page ? page->index : 0));
 
 	ret = ocfs2_inode_lock_with_page(inode, NULL, 0, page);
 	if (ret != 0) {
@@ -393,13 +396,11 @@ out_unlock:
  */
 static int ocfs2_writepage(struct page *page, struct writeback_control *wbc)
 {
-	int ret;
-
-	mlog(0, "(0x%p)\n", page);
-
-	ret = block_write_full_page(page, ocfs2_get_block, wbc);
+	trace_ocfs2_writepage(
+		(unsigned long long)OCFS2_I(page->mapping->host)->ip_blkno,
+		page->index);
 
-	return ret;
+	return block_write_full_page(page, ocfs2_get_block, wbc);
 }
 
 /* Taken from ext3. We don't necessarily need the full blown
@@ -445,7 +446,8 @@ static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 	int err = 0;
 	struct inode *inode = mapping->host;
 
-	mlog(0, "(block = %llu)\n", (unsigned long long)block);
+	trace_ocfs2_bmap((unsigned long long)OCFS2_I(inode)->ip_blkno,
+			 (unsigned long long)block);
 
 	/* We don't need to lock journal system files, since they aren't
 	 * accessed concurrently from multiple nodes.
@@ -1518,9 +1520,9 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = NULL;
 
-	mlog(0, "Inode %llu, write of %u bytes at off %llu. features: 0x%x\n",
-	     (unsigned long long)oi->ip_blkno, len, (unsigned long long)pos,
-	     oi->ip_dyn_features);
+	trace_ocfs2_try_to_write_inline_data((unsigned long long)oi->ip_blkno,
+					     len, (unsigned long long)pos,
+					     oi->ip_dyn_features);
 
 	/*
 	 * Handle inodes which already have inline data 1st.
@@ -1682,6 +1684,13 @@ int ocfs2_write_begin_nolock(struct file *filp,
 
 	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 
+	trace_ocfs2_write_begin_nolock(
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			(long long)i_size_read(inode),
+			le32_to_cpu(di->i_clusters),
+			pos, len, flags, mmap_page,
+			clusters_to_alloc, extents_to_split);
+
 	/*
 	 * We set w_target_from, w_target_to here so that
 	 * ocfs2_write_end() knows which range in the target page to
@@ -1694,12 +1703,6 @@ int ocfs2_write_begin_nolock(struct file *filp,
 		 * ocfs2_lock_allocators(). It greatly over-estimates
 		 * the work to be done.
 		 */
-		mlog(0, "extend inode %llu, i_size = %lld, di->i_clusters = %u,"
-		     " clusters_to_add = %u, extents_to_split = %u\n",
-		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-		     (long long)i_size_read(inode), le32_to_cpu(di->i_clusters),
-		     clusters_to_alloc, extents_to_split);
-
 		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
 					      wc->w_di_bh);
 		ret = ocfs2_lock_allocators(inode, &et,
@@ -1865,8 +1868,8 @@ static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
 	memcpy(di->id2.i_data.id_data + pos, kaddr + pos, *copied);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	mlog(0, "Data written to inode at offset %llu. "
-	     "id_count = %u, copied = %u, i_dyn_features = 0x%x\n",
+	trace_ocfs2_write_end_inline(
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     (unsigned long long)pos, *copied,
 	     le16_to_cpu(di->id2.i_data.id_count),
 	     le16_to_cpu(di->i_dyn_features));
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 3671151..26d9a05 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1462,6 +1462,174 @@ TRACE_EVENT(ocfs2_refcount_cow_hunk,
 );
 
 /* End of trace events for fs/ocfs2/refcounttree.c. */
+
+/* Trace events for fs/ocfs2/aops.c. */
+DECLARE_EVENT_CLASS(ocfs2__get_block,
+
+	TP_PROTO(unsigned long long ino, unsigned long long iblock,
+		 void *bh_result, int create),
+
+	TP_ARGS(ino, iblock, bh_result, create),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned long long,	iblock		)
+		__field(	void *,			bh_result	)
+		__field(	int,			create		)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->iblock		= iblock;
+		__entry->bh_result	= bh_result;
+		__entry->create		= create;
+	),
+
+	TP_printk("%llu %llu %p %d",
+		  __entry->ino, __entry->iblock,
+		  __entry->bh_result, __entry->create)
+);
+
+DEFINE_EVENT(ocfs2__get_block, ocfs2_symlink_get_block,
+
+	TP_PROTO(unsigned long long ino, unsigned long long iblock,
+		 void *bh_result, int create),
+
+	TP_ARGS(ino, iblock, bh_result, create)
+);
+
+DEFINE_EVENT(ocfs2__get_block, ocfs2_get_block,
+
+	TP_PROTO(unsigned long long ino, unsigned long long iblock,
+		 void *bh_result, int create),
+
+	TP_ARGS(ino, iblock, bh_result, create)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_get_block_end,
+
+	TP_PROTO(unsigned long long ino, unsigned long long pass_eof),
+
+	TP_ARGS(ino, pass_eof)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_readpage,
+
+	TP_PROTO(unsigned long long ino, unsigned long long page_index),
+
+	TP_ARGS(ino, page_index)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_writepage,
+
+	TP_PROTO(unsigned long long ino, unsigned long long page_index),
+
+	TP_ARGS(ino, page_index)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_bmap,
+
+	TP_PROTO(unsigned long long ino, unsigned long long block),
+
+	TP_ARGS(ino, block)
+);
+
+TRACE_EVENT(ocfs2_try_to_write_inline_data,
+
+	TP_PROTO(unsigned long long ino, unsigned int len,
+		 unsigned long long pos, unsigned int flags),
+
+	TP_ARGS(ino, len, pos, flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		len		)
+		__field(	unsigned long long,	pos		)
+		__field(	unsigned int,		flags		)
+	),
+
+	TP_fast_assign(
+		__entry->ino	= ino;
+		__entry->len	= len;
+		__entry->pos	= pos;
+		__entry->flags	= flags;
+	),
+
+	TP_printk("%llu %u %llu 0x%x",
+		  __entry->ino, __entry->len, __entry->pos, __entry->flags)
+);
+
+TRACE_EVENT(ocfs2_write_begin_nolock,
+
+	TP_PROTO(unsigned long long ino,
+		 long long i_size, unsigned int i_clusters,
+		 unsigned long long pos, unsigned int len,
+		 unsigned int flags, void *page,
+		 unsigned int clusters, unsigned int extents_to_split),
+
+	TP_ARGS(ino, i_size, i_clusters, pos, len, flags,
+		page, clusters, extents_to_split),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	long long,		i_size		)
+		__field(	unsigned int,		i_clusters	)
+		__field(	unsigned long long,	pos		)
+		__field(	unsigned int,		len		)
+		__field(	unsigned int,		flags		)
+		__field(	void *,			page		)
+		__field(	unsigned int,		clusters	)
+		__field(	unsigned int,		extents_to_split)
+	),
+
+	TP_fast_assign(
+		__entry->ino			= ino;
+		__entry->i_size			= i_size;
+		__entry->i_clusters		= i_clusters;
+		__entry->pos			= pos;
+		__entry->len			= len;
+		__entry->flags			= flags;
+		__entry->page			= page;
+		__entry->clusters		= clusters;
+		__entry->extents_to_split	= extents_to_split;
+	),
+
+	TP_printk("%llu %lld %u %llu %u %u %p %u %u",
+		  __entry->ino, __entry->i_size, __entry->i_clusters,
+		  __entry->pos, __entry->len,
+		  __entry->flags, __entry->page, __entry->clusters,
+		  __entry->extents_to_split)
+);
+
+TRACE_EVENT(ocfs2_write_end_inline,
+
+	TP_PROTO(unsigned long long ino,
+		 unsigned long long pos, unsigned int copied,
+		 unsigned int id_count, unsigned int features),
+
+	TP_ARGS(ino, pos, copied, id_count, features),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned long long,	pos		)
+		__field(	unsigned int,		copied		)
+		__field(	unsigned int,		id_count	)
+		__field(	unsigned int,		features	)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->pos		= pos;
+		__entry->copied		= copied;
+		__entry->id_count	= id_count;
+		__entry->features	= features;
+	),
+
+	TP_printk("%llu %llu %u %u %u",
+		  __entry->ino, __entry->pos, __entry->copied,
+		  __entry->id_count, __entry->features)
+);
+/* End of trace events for fs/ocfs2/aops.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
