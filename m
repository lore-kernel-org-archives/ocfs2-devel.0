From: Ryan Ding <ryan.ding@oracle.com>
Date: Fri, 11 Sep 2015 16:19:12 +0800
Subject: [Ocfs2-devel] [PATCH 1/8] ocfs2: add ocfs2_write_type_t type to
	identify the caller of write
In-Reply-To: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
References: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
Message-ID: <1441959559-29947-2-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

Remove unused args filp & flags. Add new arg type. The type is one of
buffer/direct/mmap. Indicate 3 way to perform write. buffer/mmap type has
implemented. direct type will be implemented later.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
cc: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c |   20 ++++++++++++--------
 fs/ocfs2/aops.h |   11 ++++++++---
 fs/ocfs2/mmap.c |    4 ++--
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 64b11d9..b65ebb1 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1216,6 +1216,9 @@ struct ocfs2_write_ctxt {
 	/* First cluster allocated in a nonsparse extend */
 	u32				w_first_new_cpos;
 
+	/* Type of caller. Must be one of buffer, mmap, direct.  */
+	ocfs2_write_type_t		w_type;
+
 	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
 
 	/*
@@ -1311,7 +1314,8 @@ static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
 
 static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 				  struct ocfs2_super *osb, loff_t pos,
-				  unsigned len, struct buffer_head *di_bh)
+				  unsigned len, ocfs2_write_type_t type,
+				  struct buffer_head *di_bh)
 {
 	u32 cend;
 	struct ocfs2_write_ctxt *wc;
@@ -1326,6 +1330,7 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 	wc->w_clen = cend - wc->w_cpos + 1;
 	get_bh(di_bh);
 	wc->w_di_bh = di_bh;
+	wc->w_type = type;
 
 	if (unlikely(PAGE_CACHE_SHIFT > osb->s_clustersize_bits))
 		wc->w_large_pages = 1;
@@ -2069,9 +2074,8 @@ out:
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
@@ -2088,7 +2092,7 @@ int ocfs2_write_begin_nolock(struct file *filp,
 	int try_free = 1, ret1;
 
 try_again:
-	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, di_bh);
+	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, type, di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
@@ -2145,7 +2149,7 @@ try_again:
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
 			(long long)i_size_read(inode),
 			le32_to_cpu(di->i_clusters),
-			pos, len, flags, mmap_page,
+			pos, len, type, mmap_page,
 			clusters_to_alloc, extents_to_split);
 
 	/*
@@ -2315,8 +2319,8 @@ static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = ocfs2_write_begin_nolock(file, mapping, pos, len, flags, pagep,
-				       fsdata, di_bh, NULL);
+	ret = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_BUFFER,
+				       pagep, fsdata, di_bh, NULL);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_fail;
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 24e496d..d06b80f 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -47,9 +47,14 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
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
 
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 9581d19..a88707a 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -104,8 +104,8 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 	if (page->index == last_index)
 		len = ((size - 1) & ~PAGE_CACHE_MASK) + 1;
 
-	ret = ocfs2_write_begin_nolock(file, mapping, pos, len, 0, &locked_page,
-				       &fsdata, di_bh, page);
+	ret = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_MMAP,
+				       &locked_page, &fsdata, di_bh, page);
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
-- 
1.7.1
