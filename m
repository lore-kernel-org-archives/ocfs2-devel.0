From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:11:46 -0700
Subject: [Ocfs2-devel] [patch 01/25] ocfs2: add ocfs2_write_type_t type to
 identify the caller of write
Message-ID: <56f2f882.v6hC9yKo/HpZwdgS%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: add ocfs2_write_type_t type to identify the caller of write

Patchset: fix ocfs2 direct io code patch to support sparse file and data
ordering semantics

The idea is to use buffer io(more precisely use the interface
ocfs2_write_begin_nolock & ocfs2_write_end_nolock) to do the zero work
beyond block size.  And clear UNWRITTEN flag until direct io data has been
written to disk, which can prevent data corruption when system crashed
during direct write.

And we will also archive a better performance:
eg. dd direct write new file with block size 4KB:
before this patchset:
2.5 MB/s
after this patchset:
66.4 MB/s


This patch (of 8):


To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

Remove unused args filp & flags.  Add new arg type.  The type is one of
buffer/direct/mmap.  Indicate 3 way to perform write.  buffer/mmap type
has implemented.  direct type will be implemented later.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   20 ++++++++++++--------
 fs/ocfs2/aops.h |   11 ++++++++---
 fs/ocfs2/mmap.c |    4 ++--
 3 files changed, 22 insertions(+), 13 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write
+++ a/fs/ocfs2/aops.c
@@ -1224,6 +1224,9 @@ struct ocfs2_write_ctxt {
 	/* First cluster allocated in a nonsparse extend */
 	u32				w_first_new_cpos;
 
+	/* Type of caller. Must be one of buffer, mmap, direct.  */
+	ocfs2_write_type_t		w_type;
+
 	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
 
 	/*
@@ -1319,7 +1322,8 @@ static void ocfs2_free_write_ctxt(struct
 
 static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 				  struct ocfs2_super *osb, loff_t pos,
-				  unsigned len, struct buffer_head *di_bh)
+				  unsigned len, ocfs2_write_type_t type,
+				  struct buffer_head *di_bh)
 {
 	u32 cend;
 	struct ocfs2_write_ctxt *wc;
@@ -1334,6 +1338,7 @@ static int ocfs2_alloc_write_ctxt(struct
 	wc->w_clen = cend - wc->w_cpos + 1;
 	get_bh(di_bh);
 	wc->w_di_bh = di_bh;
+	wc->w_type = type;
 
 	if (unlikely(PAGE_CACHE_SHIFT > osb->s_clustersize_bits))
 		wc->w_large_pages = 1;
@@ -2077,9 +2082,8 @@ out:
 	return ret;
 }
 
-int ocfs2_write_begin_nolock(struct file *filp,
-			     struct address_space *mapping,
-			     loff_t pos, unsigned len, unsigned flags,
+int ocfs2_write_begin_nolock(struct address_space *mapping,
+			     loff_t pos, unsigned len, ocfs2_write_type_t type,
 			     struct page **pagep, void **fsdata,
 			     struct buffer_head *di_bh, struct page *mmap_page)
 {
@@ -2096,7 +2100,7 @@ int ocfs2_write_begin_nolock(struct file
 	int try_free = 1, ret1;
 
 try_again:
-	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, di_bh);
+	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, type, di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
@@ -2153,7 +2157,7 @@ try_again:
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
 			(long long)i_size_read(inode),
 			le32_to_cpu(di->i_clusters),
-			pos, len, flags, mmap_page,
+			pos, len, type, mmap_page,
 			clusters_to_alloc, extents_to_split);
 
 	/*
@@ -2323,8 +2327,8 @@ static int ocfs2_write_begin(struct file
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = ocfs2_write_begin_nolock(file, mapping, pos, len, flags, pagep,
-				       fsdata, di_bh, NULL);
+	ret = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_BUFFER,
+				       pagep, fsdata, di_bh, NULL);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_fail;
diff -puN fs/ocfs2/aops.h~ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write
+++ a/fs/ocfs2/aops.h
@@ -47,9 +47,14 @@ int ocfs2_write_end_nolock(struct addres
 			   loff_t pos, unsigned len, unsigned copied,
 			   struct page *page, void *fsdata);
 
-int ocfs2_write_begin_nolock(struct file *filp,
-			     struct address_space *mapping,
-			     loff_t pos, unsigned len, unsigned flags,
+typedef enum {
+	OCFS2_WRITE_BUFFER = 0,
+	OCFS2_WRITE_DIRECT,
+	OCFS2_WRITE_MMAP,
+} ocfs2_write_type_t;
+
+int ocfs2_write_begin_nolock(struct address_space *mapping,
+			     loff_t pos, unsigned len, ocfs2_write_type_t type,
 			     struct page **pagep, void **fsdata,
 			     struct buffer_head *di_bh, struct page *mmap_page);
 
diff -puN fs/ocfs2/mmap.c~ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write fs/ocfs2/mmap.c
--- a/fs/ocfs2/mmap.c~ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write
+++ a/fs/ocfs2/mmap.c
@@ -104,8 +104,8 @@ static int __ocfs2_page_mkwrite(struct f
 	if (page->index == last_index)
 		len = ((size - 1) & ~PAGE_CACHE_MASK) + 1;
 
-	ret = ocfs2_write_begin_nolock(file, mapping, pos, len, 0, &locked_page,
-				       &fsdata, di_bh, page);
+	ret = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_MMAP,
+				       &locked_page, &fsdata, di_bh, page);
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
_
