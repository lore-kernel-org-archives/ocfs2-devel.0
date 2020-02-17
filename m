From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 17 Feb 2020 10:45:46 -0800
Subject: [Ocfs2-devel] [PATCH v6 04/16] mm: Tweak readahead loop slightly
In-Reply-To: <20200217184613.19668-1-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
Message-ID: <20200217184613.19668-6-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Eliminate the page_offset variable which was just confusing;
record the start of each consecutive run of pages in the
readahead_control, and move the 'kick off a fresh batch' code to
the end of the function for easier use in the next patch.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/readahead.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 15329309231f..74791b96013f 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -154,7 +154,6 @@ void __do_page_cache_readahead(struct address_space *mapping,
 		unsigned long lookahead_size)
 {
 	struct inode *inode = mapping->host;
-	struct page *page;
 	unsigned long end_index;	/* The last page we want to read */
 	LIST_HEAD(page_pool);
 	int page_idx;
@@ -163,6 +162,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	struct readahead_control rac = {
 		.mapping = mapping,
 		.file = filp,
+		._start = offset,
 		._nr_pages = 0,
 	};
 
@@ -175,32 +175,39 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	 * Preallocate as many pages as we will need.
 	 */
 	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
-		pgoff_t page_offset = offset + page_idx;
+		struct page *page;
 
-		if (page_offset > end_index)
+		if (offset > end_index)
 			break;
 
-		page = xa_load(&mapping->i_pages, page_offset);
+		page = xa_load(&mapping->i_pages, offset);
 		if (page && !xa_is_value(page)) {
 			/*
-			 * Page already present?  Kick off the current batch of
-			 * contiguous pages before continuing with the next
-			 * batch.
+			 * Page already present?  Kick off the current batch
+			 * of contiguous pages before continuing with the
+			 * next batch.  This page may be the one we would
+			 * have intended to mark as Readahead, but we don't
+			 * have a stable reference to this page, and it's
+			 * not worth getting one just for that.
 			 */
-			if (readahead_count(&rac))
-				read_pages(&rac, &page_pool, gfp_mask);
-			rac._nr_pages = 0;
-			continue;
+			goto read;
 		}
 
 		page = __page_cache_alloc(gfp_mask);
 		if (!page)
 			break;
-		page->index = page_offset;
+		page->index = offset;
 		list_add(&page->lru, &page_pool);
 		if (page_idx == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
 		rac._nr_pages++;
+		offset++;
+		continue;
+read:
+		if (readahead_count(&rac))
+			read_pages(&rac, &page_pool, gfp_mask);
+		rac._nr_pages = 0;
+		rac._start = ++offset;
 	}
 
 	/*
-- 
2.25.0
