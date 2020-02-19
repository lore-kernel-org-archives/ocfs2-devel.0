From: Matthew Wilcox <willy@infradead.org>
Date: Wed, 19 Feb 2020 13:00:44 -0800
Subject: [Ocfs2-devel] [PATCH v7 05/24] mm: Use readahead_control to pass
	arguments
In-Reply-To: <20200219210103.32400-1-willy@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
Message-ID: <20200219210103.32400-6-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In this patch, only between __do_page_cache_readahead() and
read_pages(), but it will be extended in upcoming patches.  Also add
the readahead_count() accessor.  The read_pages() function becomes aops
centric, as this makes the most sense by the end of the patchset.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
---
 include/linux/pagemap.h | 17 +++++++++++++++++
 mm/readahead.c          | 34 ++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 24894b9b90c9..55fcea0249e6 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -638,6 +638,23 @@ static inline int add_to_page_cache(struct page *page,
 	return error;
 }
 
+/*
+ * Readahead is of a block of consecutive pages.
+ */
+struct readahead_control {
+	struct file *file;
+	struct address_space *mapping;
+/* private: use the readahead_* accessors instead */
+	pgoff_t _index;
+	unsigned int _nr_pages;
+};
+
+/* The number of pages in this readahead block */
+static inline unsigned int readahead_count(struct readahead_control *rac)
+{
+	return rac->_nr_pages;
+}
+
 static inline unsigned long dir_pages(struct inode *inode)
 {
 	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
diff --git a/mm/readahead.c b/mm/readahead.c
index 9fcd4e32b62d..6a9d99229bd6 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -113,29 +113,32 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
 
 EXPORT_SYMBOL(read_cache_pages);
 
-static void read_pages(struct address_space *mapping, struct file *filp,
-		struct list_head *pages, unsigned int nr_pages, gfp_t gfp)
+static void read_pages(struct readahead_control *rac, struct list_head *pages,
+		gfp_t gfp)
 {
+	const struct address_space_operations *aops = rac->mapping->a_ops;
 	struct blk_plug plug;
 	unsigned page_idx;
 
-	if (!nr_pages)
+	if (!readahead_count(rac))
 		return;
 
 	blk_start_plug(&plug);
 
-	if (mapping->a_ops->readpages) {
-		mapping->a_ops->readpages(filp, mapping, pages, nr_pages);
+	if (aops->readpages) {
+		aops->readpages(rac->file, rac->mapping, pages,
+				readahead_count(rac));
 		/* Clean up the remaining pages */
 		put_pages_list(pages);
 		goto out;
 	}
 
-	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
+	for (page_idx = 0; page_idx < readahead_count(rac); page_idx++) {
 		struct page *page = lru_to_page(pages);
 		list_del(&page->lru);
-		if (!add_to_page_cache_lru(page, mapping, page->index, gfp))
-			mapping->a_ops->readpage(filp, page);
+		if (!add_to_page_cache_lru(page, rac->mapping, page->index,
+				gfp))
+			aops->readpage(rac->file, page);
 		put_page(page);
 	}
 
@@ -143,6 +146,7 @@ static void read_pages(struct address_space *mapping, struct file *filp,
 	blk_finish_plug(&plug);
 
 	BUG_ON(!list_empty(pages));
+	rac->_nr_pages = 0;
 }
 
 /*
@@ -160,9 +164,13 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	unsigned long end_index;	/* The last page we want to read */
 	LIST_HEAD(page_pool);
 	int page_idx;
-	unsigned int nr_pages = 0;
 	loff_t isize = i_size_read(inode);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
+	struct readahead_control rac = {
+		.mapping = mapping,
+		.file = filp,
+		._nr_pages = 0,
+	};
 
 	if (isize == 0)
 		return;
@@ -185,9 +193,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 			 * contiguous pages before continuing with the next
 			 * batch.
 			 */
-			read_pages(mapping, filp, &page_pool, nr_pages,
-						gfp_mask);
-			nr_pages = 0;
+			read_pages(&rac, &page_pool, gfp_mask);
 			continue;
 		}
 
@@ -198,7 +204,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 		list_add(&page->lru, &page_pool);
 		if (page_idx == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
-		nr_pages++;
+		rac._nr_pages++;
 	}
 
 	/*
@@ -206,7 +212,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	 * uptodate then the caller will launch readpage again, and
 	 * will then handle the error.
 	 */
-	read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
+	read_pages(&rac, &page_pool, gfp_mask);
 }
 
 /*
-- 
2.25.0
