From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 14 Apr 2020 08:02:32 -0700
Subject: [Ocfs2-devel] [PATCH v11 24/25] fuse: Convert from readpages to
	readahead
In-Reply-To: <20200414150233.24495-1-willy@infradead.org>
References: <20200414150233.24495-1-willy@infradead.org>
Message-ID: <20200414150233.24495-25-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, William Kucharski <william.kucharski@oracle.com>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Implement the new readahead operation in fuse by using __readahead_batch()
to fill the array of pages in fuse_args_pages directly.  This lets us
inline fuse_readpages_fill() into fuse_readahead().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
---
 fs/fuse/file.c | 99 ++++++++++++++------------------------------------
 1 file changed, 27 insertions(+), 72 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9d67b830fb7a..db82fb29dd39 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -915,84 +915,39 @@ static void fuse_send_readpages(struct fuse_io_args *ia, struct file *file)
 	fuse_readpages_end(fc, &ap->args, err);
 }
 
-struct fuse_fill_data {
-	struct fuse_io_args *ia;
-	struct file *file;
-	struct inode *inode;
-	unsigned int nr_pages;
-	unsigned int max_pages;
-};
-
-static int fuse_readpages_fill(void *_data, struct page *page)
+static void fuse_readahead(struct readahead_control *rac)
 {
-	struct fuse_fill_data *data = _data;
-	struct fuse_io_args *ia = data->ia;
-	struct fuse_args_pages *ap = &ia->ap;
-	struct inode *inode = data->inode;
+	struct inode *inode = rac->mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	unsigned int i, max_pages, nr_pages = 0;
 
-	fuse_wait_on_page_writeback(inode, page->index);
-
-	if (ap->num_pages &&
-	    (ap->num_pages == fc->max_pages ||
-	     (ap->num_pages + 1) * PAGE_SIZE > fc->max_read ||
-	     ap->pages[ap->num_pages - 1]->index + 1 != page->index)) {
-		data->max_pages = min_t(unsigned int, data->nr_pages,
-					fc->max_pages);
-		fuse_send_readpages(ia, data->file);
-		data->ia = ia = fuse_io_alloc(NULL, data->max_pages);
-		if (!ia) {
-			unlock_page(page);
-			return -ENOMEM;
-		}
-		ap = &ia->ap;
-	}
-
-	if (WARN_ON(ap->num_pages >= data->max_pages)) {
-		unlock_page(page);
-		fuse_io_free(ia);
-		return -EIO;
-	}
-
-	get_page(page);
-	ap->pages[ap->num_pages] = page;
-	ap->descs[ap->num_pages].length = PAGE_SIZE;
-	ap->num_pages++;
-	data->nr_pages--;
-	return 0;
-}
-
-static int fuse_readpages(struct file *file, struct address_space *mapping,
-			  struct list_head *pages, unsigned nr_pages)
-{
-	struct inode *inode = mapping->host;
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_fill_data data;
-	int err;
-
-	err = -EIO;
 	if (is_bad_inode(inode))
-		goto out;
+		return;
 
-	data.file = file;
-	data.inode = inode;
-	data.nr_pages = nr_pages;
-	data.max_pages = min_t(unsigned int, nr_pages, fc->max_pages);
-;
-	data.ia = fuse_io_alloc(NULL, data.max_pages);
-	err = -ENOMEM;
-	if (!data.ia)
-		goto out;
+	max_pages = min(fc->max_pages, fc->max_read / PAGE_SIZE);
 
-	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
-	if (!err) {
-		if (data.ia->ap.num_pages)
-			fuse_send_readpages(data.ia, file);
-		else
-			fuse_io_free(data.ia);
+	for (;;) {
+		struct fuse_io_args *ia;
+		struct fuse_args_pages *ap;
+
+		nr_pages = readahead_count(rac) - nr_pages;
+		if (nr_pages > max_pages)
+			nr_pages = max_pages;
+		if (nr_pages == 0)
+			break;
+		ia = fuse_io_alloc(NULL, nr_pages);
+		if (!ia)
+			return;
+		ap = &ia->ap;
+		nr_pages = __readahead_batch(rac, ap->pages, nr_pages);
+		for (i = 0; i < nr_pages; i++) {
+			fuse_wait_on_page_writeback(inode,
+						    readahead_index(rac) + i);
+			ap->descs[i].length = PAGE_SIZE;
+		}
+		ap->num_pages = nr_pages;
+		fuse_send_readpages(ia, rac->file);
 	}
-out:
-	return err;
 }
 
 static ssize_t fuse_cache_read_iter(struct kiocb *iocb, struct iov_iter *to)
@@ -3373,10 +3328,10 @@ static const struct file_operations fuse_file_operations = {
 
 static const struct address_space_operations fuse_file_aops  = {
 	.readpage	= fuse_readpage,
+	.readahead	= fuse_readahead,
 	.writepage	= fuse_writepage,
 	.writepages	= fuse_writepages,
 	.launder_page	= fuse_launder_page,
-	.readpages	= fuse_readpages,
 	.set_page_dirty	= __set_page_dirty_nobuffers,
 	.bmap		= fuse_bmap,
 	.direct_IO	= fuse_direct_IO,
-- 
2.25.1
