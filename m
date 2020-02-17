From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 17 Feb 2020 10:46:02 -0800
Subject: [Ocfs2-devel] [PATCH v6 12/16] ext4: Convert from readpages to
	readahead
In-Reply-To: <20200217184613.19668-1-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
Message-ID: <20200217184613.19668-22-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Use the new readahead operation in ext4

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ext4/ext4.h     |  3 +--
 fs/ext4/inode.c    | 23 ++++++++++-------------
 fs/ext4/readpage.c | 22 ++++++++--------------
 3 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9a2ee2428ecc..3af755da101d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3276,8 +3276,7 @@ static inline void ext4_set_de_type(struct super_block *sb,
 
 /* readpages.c */
 extern int ext4_mpage_readpages(struct address_space *mapping,
-				struct list_head *pages, struct page *page,
-				unsigned nr_pages, bool is_readahead);
+		struct readahead_control *rac, struct page *page);
 extern int __init ext4_init_post_read_processing(void);
 extern void ext4_exit_post_read_processing(void);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1305b810c44a..7770e38e17e7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3218,7 +3218,7 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 static int ext4_readpage(struct file *file, struct page *page)
 {
 	int ret = -EAGAIN;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = file_inode(file);
 
 	trace_ext4_readpage(page);
 
@@ -3226,23 +3226,20 @@ static int ext4_readpage(struct file *file, struct page *page)
 		ret = ext4_readpage_inline(inode, page);
 
 	if (ret == -EAGAIN)
-		return ext4_mpage_readpages(page->mapping, NULL, page, 1,
-						false);
+		return ext4_mpage_readpages(page->mapping, NULL, page);
 
 	return ret;
 }
 
-static int
-ext4_readpages(struct file *file, struct address_space *mapping,
-		struct list_head *pages, unsigned nr_pages)
+static void ext4_readahead(struct readahead_control *rac)
 {
-	struct inode *inode = mapping->host;
+	struct inode *inode = rac->mapping->host;
 
-	/* If the file has inline data, no need to do readpages. */
+	/* If the file has inline data, no need to do readahead. */
 	if (ext4_has_inline_data(inode))
-		return 0;
+		return;
 
-	return ext4_mpage_readpages(mapping, pages, NULL, nr_pages, true);
+	ext4_mpage_readpages(rac->mapping, rac, NULL);
 }
 
 static void ext4_invalidatepage(struct page *page, unsigned int offset,
@@ -3587,7 +3584,7 @@ static int ext4_set_page_dirty(struct page *page)
 
 static const struct address_space_operations ext4_aops = {
 	.readpage		= ext4_readpage,
-	.readpages		= ext4_readpages,
+	.readahead		= ext4_readahead,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_writepages,
 	.write_begin		= ext4_write_begin,
@@ -3604,7 +3601,7 @@ static const struct address_space_operations ext4_aops = {
 
 static const struct address_space_operations ext4_journalled_aops = {
 	.readpage		= ext4_readpage,
-	.readpages		= ext4_readpages,
+	.readahead		= ext4_readahead,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_writepages,
 	.write_begin		= ext4_write_begin,
@@ -3620,7 +3617,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 
 static const struct address_space_operations ext4_da_aops = {
 	.readpage		= ext4_readpage,
-	.readpages		= ext4_readpages,
+	.readahead		= ext4_readahead,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_writepages,
 	.write_begin		= ext4_da_write_begin,
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index c1769afbf799..e14841ade612 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -7,8 +7,8 @@
  *
  * This was originally taken from fs/mpage.c
  *
- * The intent is the ext4_mpage_readpages() function here is intended
- * to replace mpage_readpages() in the general case, not just for
+ * The ext4_mpage_readahead() function here is intended to
+ * replace mpage_readahead() in the general case, not just for
  * encrypted files.  It has some limitations (see below), where it
  * will fall back to read_block_full_page(), but these limitations
  * should only be hit when page_size != block_size.
@@ -222,8 +222,7 @@ static inline loff_t ext4_readpage_limit(struct inode *inode)
 }
 
 int ext4_mpage_readpages(struct address_space *mapping,
-			 struct list_head *pages, struct page *page,
-			 unsigned nr_pages, bool is_readahead)
+		struct readahead_control *rac, struct page *page)
 {
 	struct bio *bio = NULL;
 	sector_t last_block_in_bio = 0;
@@ -241,6 +240,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 	int length;
 	unsigned relative_block = 0;
 	struct ext4_map_blocks map;
+	unsigned int nr_pages = rac ? readahead_count(rac) : 1;
 
 	map.m_pblk = 0;
 	map.m_lblk = 0;
@@ -251,14 +251,9 @@ int ext4_mpage_readpages(struct address_space *mapping,
 		int fully_mapped = 1;
 		unsigned first_hole = blocks_per_page;
 
-		if (pages) {
-			page = lru_to_page(pages);
-
+		if (rac) {
+			page = readahead_page(rac);
 			prefetchw(&page->flags);
-			list_del(&page->lru);
-			if (add_to_page_cache_lru(page, mapping, page->index,
-				  readahead_gfp_mask(mapping)))
-				goto next_page;
 		}
 
 		if (page_has_buffers(page))
@@ -381,7 +376,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 			bio->bi_end_io = mpage_end_io;
 			bio_set_op_attrs(bio, REQ_OP_READ,
-						is_readahead ? REQ_RAHEAD : 0);
+						rac ? REQ_RAHEAD : 0);
 		}
 
 		length = first_hole << blkbits;
@@ -406,10 +401,9 @@ int ext4_mpage_readpages(struct address_space *mapping,
 		else
 			unlock_page(page);
 	next_page:
-		if (pages)
+		if (rac)
 			put_page(page);
 	}
-	BUG_ON(pages && !list_empty(pages));
 	if (bio)
 		submit_bio(bio);
 	return 0;
-- 
2.25.0
