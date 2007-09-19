From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:21 2007
Subject: [Ocfs2-devel] [PATCH 02/15] ocfs2: Small refactor of truncate
	zeroing code
Message-ID: <200709192012.l8JKCF5w029275@rgmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We'll want to reuse most of this when pushing inline data back out to an
extent. Keeping this part as a seperate patch helps to keep the upcoming
changes for write support uncluttered.

The core portion of ocfs2_zero_cluster_pages() responsible for making sure a
page is mapped and properly dirtied is abstracted out into it's own
function, ocfs2_map_and_dirty_page(). Actual functionality doesn't change,
though zeroing becomes optional.

We also turn part of ocfs2_free_write_ctxt() into  a common function for
unlocking and freeing a page array. This operation is very common (and
uniform) for Ocfs2 cluster sizes greater than page size, so it makes sense
to keep the code in one place.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/alloc.c |  151 ++++++++++++++++++++++++++----------------------------
 fs/ocfs2/aops.c  |   20 ++++---
 fs/ocfs2/aops.h  |    2 +
 3 files changed, 86 insertions(+), 87 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4f51766..46a0bc5 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5664,12 +5664,50 @@ static int ocfs2_ordered_zero_func(handle_t *handle, struct buffer_head *bh)
 	return ocfs2_journal_dirty_data(handle, bh);
 }
 
+static void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
+				     unsigned int from, unsigned int to,
+				     struct page *page, int zero, u64 *phys)
+{
+	int ret, partial = 0;
+
+	ret = ocfs2_map_page_blocks(page, phys, inode, from, to, 0);
+	if (ret)
+		mlog_errno(ret);
+
+	if (zero)
+		zero_user_page(page, from, to - from, KM_USER0);
+
+	/*
+	 * Need to set the buffers we zero'd into uptodate
+	 * here if they aren't - ocfs2_map_page_blocks()
+	 * might've skipped some
+	 */
+	if (ocfs2_should_order_data(inode)) {
+		ret = walk_page_buffers(handle,
+					page_buffers(page),
+					from, to, &partial,
+					ocfs2_ordered_zero_func);
+		if (ret < 0)
+			mlog_errno(ret);
+	} else {
+		ret = walk_page_buffers(handle, page_buffers(page),
+					from, to, &partial,
+					ocfs2_writeback_zero_func);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+	if (!partial)
+		SetPageUptodate(page);
+
+	flush_dcache_page(page);
+}
+
 static void ocfs2_zero_cluster_pages(struct inode *inode, loff_t start,
 				     loff_t end, struct page **pages,
 				     int numpages, u64 phys, handle_t *handle)
 {
-	int i, ret, partial = 0;
-	void *kaddr;
+	int i;
 	struct page *page;
 	unsigned int from, to = PAGE_CACHE_SIZE;
 	struct super_block *sb = inode->i_sb;
@@ -5690,87 +5728,31 @@ static void ocfs2_zero_cluster_pages(struct inode *inode, loff_t start,
 		BUG_ON(from > PAGE_CACHE_SIZE);
 		BUG_ON(to > PAGE_CACHE_SIZE);
 
-		ret = ocfs2_map_page_blocks(page, &phys, inode, from, to, 0);
-		if (ret)
-			mlog_errno(ret);
-
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + from, 0, to - from);
-		kunmap_atomic(kaddr, KM_USER0);
-
-		/*
-		 * Need to set the buffers we zero'd into uptodate
-		 * here if they aren't - ocfs2_map_page_blocks()
-		 * might've skipped some
-		 */
-		if (ocfs2_should_order_data(inode)) {
-			ret = walk_page_buffers(handle,
-						page_buffers(page),
-						from, to, &partial,
-						ocfs2_ordered_zero_func);
-			if (ret < 0)
-				mlog_errno(ret);
-		} else {
-			ret = walk_page_buffers(handle, page_buffers(page),
-						from, to, &partial,
-						ocfs2_writeback_zero_func);
-			if (ret < 0)
-				mlog_errno(ret);
-		}
-
-		if (!partial)
-			SetPageUptodate(page);
-
-		flush_dcache_page(page);
+		ocfs2_map_and_dirty_page(inode, handle, from, to, page, 1,
+					 &phys);
 
 		start = (page->index + 1) << PAGE_CACHE_SHIFT;
 	}
 out:
-	if (pages) {
-		for (i = 0; i < numpages; i++) {
-			page = pages[i];
-			unlock_page(page);
-			mark_page_accessed(page);
-			page_cache_release(page);
-		}
-	}
+	if (pages)
+		ocfs2_unlock_and_free_pages(pages, numpages);
 }
 
 static int ocfs2_grab_eof_pages(struct inode *inode, loff_t start, loff_t end,
-				struct page **pages, int *num, u64 *phys)
+				struct page **pages, int *num)
 {
-	int i, numpages = 0, ret = 0;
-	unsigned int ext_flags;
+	int numpages, ret = 0;
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	unsigned long index;
 	loff_t last_page_bytes;
 
-	BUG_ON(!ocfs2_sparse_alloc(OCFS2_SB(sb)));
 	BUG_ON(start > end);
 
-	if (start == end)
-		goto out;
-
 	BUG_ON(start >> OCFS2_SB(sb)->s_clustersize_bits !=
 	       (end - 1) >> OCFS2_SB(sb)->s_clustersize_bits);
 
-	ret = ocfs2_extent_map_get_blocks(inode, start >> sb->s_blocksize_bits,
-					  phys, NULL, &ext_flags);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	/* Tail is a hole. */
-	if (*phys == 0)
-		goto out;
-
-	/* Tail is marked as unwritten, we can count on write to zero
-	 * in that case. */
-	if (ext_flags & OCFS2_EXT_UNWRITTEN)
-		goto out;
-
+	numpages = 0;
 	last_page_bytes = PAGE_ALIGN(end);
 	index = start >> PAGE_CACHE_SHIFT;
 	do {
@@ -5787,14 +5769,8 @@ static int ocfs2_grab_eof_pages(struct inode *inode, loff_t start, loff_t end,
 
 out:
 	if (ret != 0) {
-		if (pages) {
-			for (i = 0; i < numpages; i++) {
-				if (pages[i]) {
-					unlock_page(pages[i]);
-					page_cache_release(pages[i]);
-				}
-			}
-		}
+		if (pages)
+			ocfs2_unlock_and_free_pages(pages, numpages);
 		numpages = 0;
 	}
 
@@ -5815,18 +5791,20 @@ out:
 int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 				  u64 range_start, u64 range_end)
 {
-	int ret, numpages;
+	int ret = 0, numpages;
 	struct page **pages = NULL;
 	u64 phys;
+	unsigned int ext_flags;
+	struct super_block *sb = inode->i_sb;
 
 	/*
 	 * File systems which don't support sparse files zero on every
 	 * extend.
 	 */
-	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+	if (!ocfs2_sparse_alloc(OCFS2_SB(sb)))
 		return 0;
 
-	pages = kcalloc(ocfs2_pages_per_cluster(inode->i_sb),
+	pages = kcalloc(ocfs2_pages_per_cluster(sb),
 			sizeof(struct page *), GFP_NOFS);
 	if (pages == NULL) {
 		ret = -ENOMEM;
@@ -5834,15 +5812,30 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_grab_eof_pages(inode, range_start, range_end, pages,
-				   &numpages, &phys);
+	if (range_start == range_end)
+		goto out;
+
+	ret = ocfs2_extent_map_get_blocks(inode,
+					  range_start >> sb->s_blocksize_bits,
+					  &phys, NULL, &ext_flags);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	if (numpages == 0)
+	/*
+	 * Tail is a hole, or is marked unwritten. In either case, we
+	 * can count on read and write to return/push zero's.
+	 */
+	if (phys == 0 || ext_flags & OCFS2_EXT_UNWRITTEN)
+		goto out;
+
+	ret = ocfs2_grab_eof_pages(inode, range_start, range_end, pages,
+				   &numpages);
+	if (ret) {
+		mlog_errno(ret);
 		goto out;
+	}
 
 	ocfs2_zero_cluster_pages(inode, range_start, range_end, pages,
 				 numpages, phys, handle);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 97394c5..57fc7e3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -830,18 +830,22 @@ struct ocfs2_write_ctxt {
 	struct ocfs2_cached_dealloc_ctxt w_dealloc;
 };
 
-static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 {
 	int i;
 
-	for(i = 0; i < wc->w_num_pages; i++) {
-		if (wc->w_pages[i] == NULL)
-			continue;
-
-		unlock_page(wc->w_pages[i]);
-		mark_page_accessed(wc->w_pages[i]);
-		page_cache_release(wc->w_pages[i]);
+	for(i = 0; i < num_pages; i++) {
+		if (pages[i]) {
+			unlock_page(pages[i]);
+			mark_page_accessed(pages[i]);
+			page_cache_release(pages[i]);
+		}
 	}
+}
+
+static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+{
+	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
 
 	brelse(wc->w_di_bh);
 	kfree(wc);
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 389579b..b4fa37d 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -34,6 +34,8 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new);
 
+void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages);
+
 int walk_page_buffers(	handle_t *handle,
 			struct buffer_head *head,
 			unsigned from,
-- 
1.5.0.6
