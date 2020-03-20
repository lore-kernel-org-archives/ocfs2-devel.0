From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 20 Mar 2020 07:22:24 -0700
Subject: [Ocfs2-devel] [PATCH v9 18/25] erofs: Convert uncompressed files
	from readpages to readahead
In-Reply-To: <20200320142231.2402-1-willy@infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
Message-ID: <20200320142231.2402-19-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Use the new readahead operation in erofs

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
---
 fs/erofs/data.c              | 39 +++++++++++++-----------------------
 fs/erofs/zdata.c             |  2 +-
 include/trace/events/erofs.h |  6 +++---
 3 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index fc3a8d8064f8..d0542151e8c4 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -280,47 +280,36 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 	return 0;
 }
 
-static int erofs_raw_access_readpages(struct file *filp,
-				      struct address_space *mapping,
-				      struct list_head *pages,
-				      unsigned int nr_pages)
+static void erofs_raw_access_readahead(struct readahead_control *rac)
 {
 	erofs_off_t last_block;
 	struct bio *bio = NULL;
-	gfp_t gfp = readahead_gfp_mask(mapping);
-	struct page *page = list_last_entry(pages, struct page, lru);
-
-	trace_erofs_readpages(mapping->host, page, nr_pages, true);
+	struct page *page;
 
-	for (; nr_pages; --nr_pages) {
-		page = list_entry(pages->prev, struct page, lru);
+	trace_erofs_readpages(rac->mapping->host, readahead_index(rac),
+			readahead_count(rac), true);
 
+	while ((page = readahead_page(rac))) {
 		prefetchw(&page->flags);
-		list_del(&page->lru);
 
-		if (!add_to_page_cache_lru(page, mapping, page->index, gfp)) {
-			bio = erofs_read_raw_page(bio, mapping, page,
-						  &last_block, nr_pages, true);
+		bio = erofs_read_raw_page(bio, rac->mapping, page, &last_block,
+				readahead_count(rac), true);
 
-			/* all the page errors are ignored when readahead */
-			if (IS_ERR(bio)) {
-				pr_err("%s, readahead error at page %lu of nid %llu\n",
-				       __func__, page->index,
-				       EROFS_I(mapping->host)->nid);
+		/* all the page errors are ignored when readahead */
+		if (IS_ERR(bio)) {
+			pr_err("%s, readahead error at page %lu of nid %llu\n",
+			       __func__, page->index,
+			       EROFS_I(rac->mapping->host)->nid);
 
-				bio = NULL;
-			}
+			bio = NULL;
 		}
 
-		/* pages could still be locked */
 		put_page(page);
 	}
-	DBG_BUGON(!list_empty(pages));
 
 	/* the rare case (end in gaps) */
 	if (bio)
 		submit_bio(bio);
-	return 0;
 }
 
 static int erofs_get_block(struct inode *inode, sector_t iblock,
@@ -358,7 +347,7 @@ static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
 /* for uncompressed (aligned) files and raw access for other files */
 const struct address_space_operations erofs_raw_access_aops = {
 	.readpage = erofs_raw_access_readpage,
-	.readpages = erofs_raw_access_readpages,
+	.readahead = erofs_raw_access_readahead,
 	.bmap = erofs_bmap,
 };
 
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 80e47f07d946..17f45fcb8c5c 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1315,7 +1315,7 @@ static int z_erofs_readpages(struct file *filp, struct address_space *mapping,
 	struct page *head = NULL;
 	LIST_HEAD(pagepool);
 
-	trace_erofs_readpages(mapping->host, lru_to_page(pages),
+	trace_erofs_readpages(mapping->host, lru_to_page(pages)->index,
 			      nr_pages, false);
 
 	f.headoffset = (erofs_off_t)lru_to_page(pages)->index << PAGE_SHIFT;
diff --git a/include/trace/events/erofs.h b/include/trace/events/erofs.h
index 27f5caa6299a..bf9806fd1306 100644
--- a/include/trace/events/erofs.h
+++ b/include/trace/events/erofs.h
@@ -113,10 +113,10 @@ TRACE_EVENT(erofs_readpage,
 
 TRACE_EVENT(erofs_readpages,
 
-	TP_PROTO(struct inode *inode, struct page *page, unsigned int nrpage,
+	TP_PROTO(struct inode *inode, pgoff_t start, unsigned int nrpage,
 		bool raw),
 
-	TP_ARGS(inode, page, nrpage, raw),
+	TP_ARGS(inode, start, nrpage, raw),
 
 	TP_STRUCT__entry(
 		__field(dev_t,		dev	)
@@ -129,7 +129,7 @@ TRACE_EVENT(erofs_readpages,
 	TP_fast_assign(
 		__entry->dev	= inode->i_sb->s_dev;
 		__entry->nid	= EROFS_I(inode)->nid;
-		__entry->start	= page->index;
+		__entry->start	= start;
 		__entry->nrpage	= nrpage;
 		__entry->raw	= raw;
 	),
-- 
2.25.1
