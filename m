From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 29 Jun 2010 16:35:41 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: make mmap CoW work with readahead.
In-Reply-To: <4C29AE6C.1050205@oracle.com>
References: <4C29AE6C.1050205@oracle.com>
Message-ID: <1277800541-6844-4-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

refcount_cow need file * to do the readahead.
So we just add 'struct file *' to ocfs2_write_begin_nolock
and __ocfs2_page_mkwrite and let them pass this parameter
to ocfs2_refcount_cow.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c |    7 ++++---
 fs/ocfs2/aops.h |    3 ++-
 fs/ocfs2/mmap.c |    8 ++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 5f94923..337e874 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1645,7 +1645,8 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
 	return ret;
 }
 
-int ocfs2_write_begin_nolock(struct address_space *mapping,
+int ocfs2_write_begin_nolock(struct file *file,
+			     struct address_space *mapping,
 			     loff_t pos, unsigned len, unsigned flags,
 			     struct page **pagep, void **fsdata,
 			     struct buffer_head *di_bh, struct page *mmap_page)
@@ -1691,7 +1692,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		mlog_errno(ret);
 		goto out;
 	} else if (ret == 1) {
-		ret = ocfs2_refcount_cow(inode, NULL, di_bh,
+		ret = ocfs2_refcount_cow(inode, file, di_bh,
 					 wc->w_cpos, wc->w_clen, UINT_MAX);
 		if (ret) {
 			mlog_errno(ret);
@@ -1853,7 +1854,7 @@ static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = ocfs2_write_begin_nolock(mapping, pos, len, flags, pagep,
+	ret = ocfs2_write_begin_nolock(file, mapping, pos, len, flags, pagep,
 				       fsdata, di_bh, NULL);
 	if (ret) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index c48e93f..e99ac0f 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -48,7 +48,8 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 			   loff_t pos, unsigned len, unsigned copied,
 			   struct page *page, void *fsdata);
 
-int ocfs2_write_begin_nolock(struct address_space *mapping,
+int ocfs2_write_begin_nolock(struct file *file,
+			     struct address_space *mapping,
 			     loff_t pos, unsigned len, unsigned flags,
 			     struct page **pagep, void **fsdata,
 			     struct buffer_head *di_bh, struct page *mmap_page);
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index af2b8fe..7fcb107 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -59,8 +59,8 @@ static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 	return ret;
 }
 
-static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
-				struct page *page)
+static int __ocfs2_page_mkwrite(struct file *file, struct inode *inode,
+				struct buffer_head *di_bh, struct page *page)
 {
 	int ret;
 	struct address_space *mapping = inode->i_mapping;
@@ -109,7 +109,7 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 	if (page->index == last_index)
 		len = size & ~PAGE_CACHE_MASK;
 
-	ret = ocfs2_write_begin_nolock(mapping, pos, len, 0, &locked_page,
+	ret = ocfs2_write_begin_nolock(file, mapping, pos, len, 0, &locked_page,
 				       &fsdata, di_bh, page);
 	if (ret) {
 		if (ret != -ENOSPC)
@@ -157,7 +157,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = __ocfs2_page_mkwrite(inode, di_bh, page);
+	ret = __ocfs2_page_mkwrite(vma->vm_file, inode, di_bh, page);
 
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-- 
1.7.1.GIT
