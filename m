From: Matthew Wilcox <willy@infradead.org>
Date: Wed, 19 Feb 2020 13:00:48 -0800
Subject: [Ocfs2-devel] [PATCH v7 09/24] mm: Put readahead pages in cache
	earlier
In-Reply-To: <20200219210103.32400-1-willy@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
Message-ID: <20200219210103.32400-10-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

When populating the page cache for readahead, mappings that use
->readpages must populate the page cache themselves as the pages are
passed on a linked list which would normally be used for the page cache's
LRU.  For mappings that use ->readpage or the upcoming ->readahead method,
we can put the pages into the page cache as soon as they're allocated,
which solves a race between readahead and direct IO.  It also lets us
remove the gfp argument from read_pages().

Use the new readahead_page() API to implement the repeated calls to
->readpage(), just like most filesystems will.  This iterator also
supports huge pages, even though none of the filesystems have been
converted to use them yet.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 20 +++++++++++++++++
 mm/readahead.c          | 48 +++++++++++++++++++++++++----------------
 2 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 55fcea0249e6..4989d330fada 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -647,8 +647,28 @@ struct readahead_control {
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
 	unsigned int _nr_pages;
+	unsigned int _batch_count;
 };
 
+static inline struct page *readahead_page(struct readahead_control *rac)
+{
+	struct page *page;
+
+	BUG_ON(rac->_batch_count > rac->_nr_pages);
+	rac->_nr_pages -= rac->_batch_count;
+	rac->_index += rac->_batch_count;
+	rac->_batch_count = 0;
+
+	if (!rac->_nr_pages)
+		return NULL;
+
+	page = xa_load(&rac->mapping->i_pages, rac->_index);
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	rac->_batch_count = hpage_nr_pages(page);
+
+	return page;
+}
+
 /* The number of pages in this readahead block */
 static inline unsigned int readahead_count(struct readahead_control *rac)
 {
diff --git a/mm/readahead.c b/mm/readahead.c
index 83df5c061d33..aaa209559ba2 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -113,15 +113,14 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
 
 EXPORT_SYMBOL(read_cache_pages);
 
-static void read_pages(struct readahead_control *rac, struct list_head *pages,
-		gfp_t gfp)
+static void read_pages(struct readahead_control *rac, struct list_head *pages)
 {
 	const struct address_space_operations *aops = rac->mapping->a_ops;
+	struct page *page;
 	struct blk_plug plug;
-	unsigned page_idx;
 
 	if (!readahead_count(rac))
-		return;
+		goto out;
 
 	blk_start_plug(&plug);
 
@@ -130,23 +129,23 @@ static void read_pages(struct readahead_control *rac, struct list_head *pages,
 				readahead_count(rac));
 		/* Clean up the remaining pages */
 		put_pages_list(pages);
-		goto out;
-	}
-
-	for (page_idx = 0; page_idx < readahead_count(rac); page_idx++) {
-		struct page *page = lru_to_page(pages);
-		list_del(&page->lru);
-		if (!add_to_page_cache_lru(page, rac->mapping, page->index,
-				gfp))
+		rac->_index += rac->_nr_pages;
+		rac->_nr_pages = 0;
+	} else {
+		while ((page = readahead_page(rac))) {
 			aops->readpage(rac->file, page);
-		put_page(page);
+			put_page(page);
+		}
 	}
 
-out:
 	blk_finish_plug(&plug);
 
 	BUG_ON(!list_empty(pages));
-	rac->_nr_pages = 0;
+	BUG_ON(readahead_count(rac));
+
+out:
+	/* If we were called due to a conflicting page, skip over it */
+	rac->_index++;
 }
 
 /*
@@ -165,9 +164,11 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	LIST_HEAD(page_pool);
 	loff_t isize = i_size_read(inode);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
+	bool use_list = mapping->a_ops->readpages;
 	struct readahead_control rac = {
 		.mapping = mapping,
 		.file = filp,
+		._index = index,
 		._nr_pages = 0,
 	};
 	unsigned long i;
@@ -184,6 +185,8 @@ void __do_page_cache_readahead(struct address_space *mapping,
 		if (index + i > end_index)
 			break;
 
+		BUG_ON(index + i != rac._index + rac._nr_pages);
+
 		page = xa_load(&mapping->i_pages, index + i);
 		if (page && !xa_is_value(page)) {
 			/*
@@ -191,15 +194,22 @@ void __do_page_cache_readahead(struct address_space *mapping,
 			 * contiguous pages before continuing with the next
 			 * batch.
 			 */
-			read_pages(&rac, &page_pool, gfp_mask);
+			read_pages(&rac, &page_pool);
 			continue;
 		}
 
 		page = __page_cache_alloc(gfp_mask);
 		if (!page)
 			break;
-		page->index = index + i;
-		list_add(&page->lru, &page_pool);
+		if (use_list) {
+			page->index = index + i;
+			list_add(&page->lru, &page_pool);
+		} else if (add_to_page_cache_lru(page, mapping, index + i,
+					gfp_mask) < 0) {
+			put_page(page);
+			read_pages(&rac, &page_pool);
+			continue;
+		}
 		if (i == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
 		rac._nr_pages++;
@@ -210,7 +220,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	 * uptodate then the caller will launch readpage again, and
 	 * will then handle the error.
 	 */
-	read_pages(&rac, &page_pool, gfp_mask);
+	read_pages(&rac, &page_pool);
 }
 
 /*
-- 
2.25.0
