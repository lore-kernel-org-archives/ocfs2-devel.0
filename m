From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 17 Feb 2020 10:45:48 -0800
Subject: [Ocfs2-devel] [PATCH v6 05/19] mm: Remove 'page_offset' from
	readahead loop
In-Reply-To: <20200217184613.19668-1-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
Message-ID: <20200217184613.19668-8-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Eliminate the page_offset variable which was confusing with the
'offset' parameter and record the start of each consecutive run of
pages in the readahead_control.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/readahead.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 3eca59c43a45..74791b96013f 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -162,6 +162,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	struct readahead_control rac = {
 		.mapping = mapping,
 		.file = filp,
+		._start = offset,
 		._nr_pages = 0,
 	};
 
@@ -175,12 +176,11 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	 */
 	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
 		struct page *page;
-		pgoff_t page_offset = offset + page_idx;
 
-		if (page_offset > end_index)
+		if (offset > end_index)
 			break;
 
-		page = xa_load(&mapping->i_pages, page_offset);
+		page = xa_load(&mapping->i_pages, offset);
 		if (page && !xa_is_value(page)) {
 			/*
 			 * Page already present?  Kick off the current batch
@@ -196,16 +196,18 @@ void __do_page_cache_readahead(struct address_space *mapping,
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
 		continue;
 read:
 		if (readahead_count(&rac))
 			read_pages(&rac, &page_pool, gfp_mask);
 		rac._nr_pages = 0;
+		rac._start = ++offset;
 	}
 
 	/*
-- 
2.25.0
