From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 17 Feb 2020 10:45:55 -0800
Subject: [Ocfs2-devel] [PATCH v6 09/16] btrfs: Convert from readpages to
	readahead
In-Reply-To: <20200217184613.19668-1-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
Message-ID: <20200217184613.19668-15-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Use the new readahead operation in btrfs.  Add a
readahead_for_each_batch() iterator to optimise the loop in the XArray.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/extent_io.c    | 48 ++++++++++++++---------------------------
 fs/btrfs/extent_io.h    |  3 +--
 fs/btrfs/inode.c        | 16 ++++++--------
 include/linux/pagemap.h | 27 +++++++++++++++++++++++
 4 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c0f202741e09..d9f66058e0a7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4278,52 +4278,36 @@ int extent_writepages(struct address_space *mapping,
 	return ret;
 }
 
-int extent_readpages(struct address_space *mapping, struct list_head *pages,
-		     unsigned nr_pages)
+void extent_readahead(struct readahead_control *rac)
 {
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
 	struct page *pagepool[16];
 	struct extent_map *em_cached = NULL;
-	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
-	int nr = 0;
+	struct extent_io_tree *tree = &BTRFS_I(rac->mapping->host)->io_tree;
 	u64 prev_em_start = (u64)-1;
+	int nr;
 
-	while (!list_empty(pages)) {
-		u64 contig_end = 0;
-
-		for (nr = 0; nr < ARRAY_SIZE(pagepool) && !list_empty(pages);) {
-			struct page *page = lru_to_page(pages);
-
-			prefetchw(&page->flags);
-			list_del(&page->lru);
-			if (add_to_page_cache_lru(page, mapping, page->index,
-						readahead_gfp_mask(mapping))) {
-				put_page(page);
-				break;
-			}
-
-			pagepool[nr++] = page;
-			contig_end = page_offset(page) + PAGE_SIZE - 1;
-		}
-
-		if (nr) {
-			u64 contig_start = page_offset(pagepool[0]);
+	readahead_for_each_batch(rac, pagepool, ARRAY_SIZE(pagepool), nr) {
+		u64 contig_start = page_offset(pagepool[0]);
+		u64 contig_end = page_offset(pagepool[nr - 1]) + PAGE_SIZE - 1;
 
-			ASSERT(contig_start + nr * PAGE_SIZE - 1 == contig_end);
+		ASSERT(contig_start + nr * PAGE_SIZE - 1 == contig_end);
 
-			contiguous_readpages(tree, pagepool, nr, contig_start,
-				     contig_end, &em_cached, &bio, &bio_flags,
-				     &prev_em_start);
-		}
+		contiguous_readpages(tree, pagepool, nr, contig_start,
+				contig_end, &em_cached, &bio, &bio_flags,
+				&prev_em_start);
 	}
 
 	if (em_cached)
 		free_extent_map(em_cached);
 
-	if (bio)
-		return submit_one_bio(bio, 0, bio_flags);
-	return 0;
+	if (bio) {
+		int ret = submit_one_bio(bio, 0, bio_flags);
+		if (ret < 0) {
+			/* XXX: unlock the pages here? */
+		}
+	}
 }
 
 /*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5d205bbaafdc..bddac32948c7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -198,8 +198,7 @@ int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc);
 int btree_write_cache_pages(struct address_space *mapping,
 			    struct writeback_control *wbc);
-int extent_readpages(struct address_space *mapping, struct list_head *pages,
-		     unsigned nr_pages);
+void extent_readahead(struct readahead_control *rac);
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len);
 void set_page_extent_mapped(struct page *page);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5b3ec93ff911..d964b2a78ed8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4794,8 +4794,8 @@ static void evict_inode_truncate_pages(struct inode *inode)
 
 	/*
 	 * Keep looping until we have no more ranges in the io tree.
-	 * We can have ongoing bios started by readpages (called from readahead)
-	 * that have their endio callback (extent_io.c:end_bio_extent_readpage)
+	 * We can have ongoing bios started by readahead that have
+	 * their endio callback (extent_io.c:end_bio_extent_readpage)
 	 * still in progress (unlocked the pages in the bio but did not yet
 	 * unlocked the ranges in the io tree). Therefore this means some
 	 * ranges can still be locked and eviction started because before
@@ -6996,11 +6996,11 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 			 * for it to complete) and then invalidate the pages for
 			 * this range (through invalidate_inode_pages2_range()),
 			 * but that can lead us to a deadlock with a concurrent
-			 * call to readpages() (a buffered read or a defrag call
+			 * call to readahead (a buffered read or a defrag call
 			 * triggered a readahead) on a page lock due to an
 			 * ordered dio extent we created before but did not have
 			 * yet a corresponding bio submitted (whence it can not
-			 * complete), which makes readpages() wait for that
+			 * complete), which makes readahead wait for that
 			 * ordered extent to complete while holding a lock on
 			 * that page.
 			 */
@@ -8239,11 +8239,9 @@ static int btrfs_writepages(struct address_space *mapping,
 	return extent_writepages(mapping, wbc);
 }
 
-static int
-btrfs_readpages(struct file *file, struct address_space *mapping,
-		struct list_head *pages, unsigned nr_pages)
+static void btrfs_readahead(struct readahead_control *rac)
 {
-	return extent_readpages(mapping, pages, nr_pages);
+	extent_readahead(rac);
 }
 
 static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
@@ -10448,7 +10446,7 @@ static const struct address_space_operations btrfs_aops = {
 	.readpage	= btrfs_readpage,
 	.writepage	= btrfs_writepage,
 	.writepages	= btrfs_writepages,
-	.readpages	= btrfs_readpages,
+	.readahead	= btrfs_readahead,
 	.direct_IO	= btrfs_direct_IO,
 	.invalidatepage = btrfs_invalidatepage,
 	.releasepage	= btrfs_releasepage,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 4f36c06d064d..1bbb60a0bf16 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -669,6 +669,33 @@ static inline void readahead_next(struct readahead_control *rac)
 #define readahead_for_each(rac, page)					\
 	for (; (page = readahead_page(rac)); readahead_next(rac))
 
+static inline unsigned int readahead_page_batch(struct readahead_control *rac,
+		struct page **array, unsigned int size)
+{
+	unsigned int batch = 0;
+	XA_STATE(xas, &rac->mapping->i_pages, rac->_start);
+	struct page *page;
+
+	rac->_batch_count = 0;
+	xas_for_each(&xas, page, rac->_start + rac->_nr_pages - 1) {
+		VM_BUG_ON_PAGE(!PageLocked(page), page);
+		VM_BUG_ON_PAGE(PageTail(page), page);
+		array[batch++] = page;
+		rac->_batch_count += hpage_nr_pages(page);
+		if (PageHead(page))
+			xas_set(&xas, rac->_start + rac->_batch_count);
+
+		if (batch == size)
+			break;
+	}
+
+	return batch;
+}
+
+#define readahead_for_each_batch(rac, array, size, nr)			\
+	for (; (nr = readahead_page_batch(rac, array, size));		\
+			readahead_next(rac))
+
 /* The byte offset into the file of this readahead block */
 static inline loff_t readahead_offset(struct readahead_control *rac)
 {
-- 
2.25.0
