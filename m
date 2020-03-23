From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 23 Mar 2020 13:22:40 -0700
Subject: [Ocfs2-devel] [PATCH v10 06/25] mm: Use readahead_control to pass
	arguments
In-Reply-To: <20200323202259.13363-1-willy@infradead.org>
References: <20200323202259.13363-1-willy@infradead.org>
Message-ID: <20200323202259.13363-7-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In this patch, only between __do_page_cache_readahead() and read_pages(),
but it will be extended in upcoming patches.  The read_pages() function
becomes aops centric, as this makes the most sense by the end of the
patchset.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
---
 mm/readahead.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 9fcd4e32b62d..9d9aa4ffc7d4 100644
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
@@ -160,9 +164,12 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	unsigned long end_index;	/* The last page we want to read */
 	LIST_HEAD(page_pool);
 	int page_idx;
-	unsigned int nr_pages = 0;
 	loff_t isize = i_size_read(inode);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
+	struct readahead_control rac = {
+		.mapping = mapping,
+		.file = filp,
+	};
 
 	if (isize == 0)
 		return;
@@ -185,9 +192,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 			 * contiguous pages before continuing with the next
 			 * batch.
 			 */
-			read_pages(mapping, filp, &page_pool, nr_pages,
-						gfp_mask);
-			nr_pages = 0;
+			read_pages(&rac, &page_pool, gfp_mask);
 			continue;
 		}
 
@@ -198,7 +203,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 		list_add(&page->lru, &page_pool);
 		if (page_idx == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
-		nr_pages++;
+		rac._nr_pages++;
 	}
 
 	/*
@@ -206,7 +211,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	 * uptodate then the caller will launch readpage again, and
 	 * will then handle the error.
 	 */
-	read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
+	read_pages(&rac, &page_pool, gfp_mask);
 }
 
 /*
-- 
2.25.1
