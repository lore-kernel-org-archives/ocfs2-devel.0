From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 20 Mar 2020 07:22:17 -0700
Subject: [Ocfs2-devel] [PATCH v9 11/25] mm: Add readahead address space
	operation
In-Reply-To: <20200320142231.2402-1-willy@infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
Message-ID: <20200320142231.2402-12-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This replaces ->readpages with a saner interface:
 - Return void instead of an ignored error code.
 - Page cache is already populated with locked pages when ->readahead
   is called.
 - New arguments can be passed to the implementation without changing
   all the filesystems that use a common helper function like
   mpage_readahead().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
---
 Documentation/filesystems/locking.rst |  6 +++++-
 Documentation/filesystems/vfs.rst     | 15 +++++++++++++++
 include/linux/fs.h                    |  2 ++
 mm/readahead.c                        | 12 ++++++++++--
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 5057e4d9dcd1..0af2e0e11461 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -239,6 +239,7 @@ prototypes::
 	int (*readpage)(struct file *, struct page *);
 	int (*writepages)(struct address_space *, struct writeback_control *);
 	int (*set_page_dirty)(struct page *page);
+	void (*readahead)(struct readahead_control *);
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
 	int (*write_begin)(struct file *, struct address_space *mapping,
@@ -271,7 +272,8 @@ writepage:		yes, unlocks (see below)
 readpage:		yes, unlocks
 writepages:
 set_page_dirty		no
-readpages:
+readahead:		yes, unlocks
+readpages:		no
 write_begin:		locks the page		 exclusive
 write_end:		yes, unlocks		 exclusive
 bmap:
@@ -295,6 +297,8 @@ the request handler (/dev/loop).
 ->readpage() unlocks the page, either synchronously or via I/O
 completion.
 
+->readahead() unlocks the pages that I/O is attempted on like ->readpage().
+
 ->readpages() populates the pagecache with the passed pages and starts
 I/O against them.  They come unlocked upon I/O completion.
 
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 7d4d09dd5e6d..ed17771c212b 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -706,6 +706,7 @@ cache in your filesystem.  The following members are defined:
 		int (*readpage)(struct file *, struct page *);
 		int (*writepages)(struct address_space *, struct writeback_control *);
 		int (*set_page_dirty)(struct page *page);
+		void (*readahead)(struct readahead_control *);
 		int (*readpages)(struct file *filp, struct address_space *mapping,
 				 struct list_head *pages, unsigned nr_pages);
 		int (*write_begin)(struct file *, struct address_space *mapping,
@@ -781,12 +782,26 @@ cache in your filesystem.  The following members are defined:
 	If defined, it should set the PageDirty flag, and the
 	PAGECACHE_TAG_DIRTY tag in the radix tree.
 
+``readahead``
+	Called by the VM to read pages associated with the address_space
+	object.  The pages are consecutive in the page cache and are
+	locked.  The implementation should decrement the page refcount
+	after starting I/O on each page.  Usually the page will be
+	unlocked by the I/O completion handler.  If the filesystem decides
+	to stop attempting I/O before reaching the end of the readahead
+	window, it can simply return.  The caller will decrement the page
+	refcount and unlock the remaining pages for you.  Set PageUptodate
+	if the I/O completes successfully.  Setting PageError on any page
+	will be ignored; simply unlock the page if an I/O error occurs.
+
 ``readpages``
 	called by the VM to read pages associated with the address_space
 	object.  This is essentially just a vector version of readpage.
 	Instead of just one page, several pages are requested.
 	readpages is only used for read-ahead, so read errors are
 	ignored.  If anything goes wrong, feel free to give up.
+	This interface is deprecated and will be removed by the end of
+	2020; implement readahead instead.
 
 ``write_begin``
 	Called by the generic buffered write code to ask the filesystem
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3cd4fe6b845e..d4e2d2964346 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -292,6 +292,7 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct readahead_control;
 
 /*
  * Write life time hint values.
@@ -375,6 +376,7 @@ struct address_space_operations {
 	 */
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
+	void (*readahead)(struct readahead_control *);
 
 	int (*write_begin)(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
diff --git a/mm/readahead.c b/mm/readahead.c
index e52b3a7b9da5..d01531ef9f3c 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -125,7 +125,14 @@ static void read_pages(struct readahead_control *rac, struct list_head *pages,
 
 	blk_start_plug(&plug);
 
-	if (aops->readpages) {
+	if (aops->readahead) {
+		aops->readahead(rac);
+		/* Clean up the remaining pages */
+		while ((page = readahead_page(rac))) {
+			unlock_page(page);
+			put_page(page);
+		}
+	} else if (aops->readpages) {
 		aops->readpages(rac->file, rac->mapping, pages,
 				readahead_count(rac));
 		/* Clean up the remaining pages */
@@ -233,7 +240,8 @@ void force_page_cache_readahead(struct address_space *mapping,
 	struct file_ra_state *ra = &filp->f_ra;
 	unsigned long max_pages;
 
-	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
+	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages &&
+			!mapping->a_ops->readahead))
 		return;
 
 	/*
-- 
2.25.1
