From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 14 Jul 2010 15:53:19 +0800
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: pass struct file* to
	ocfs2_write_begin_nolock.
In-Reply-To: <4C3D6CBA.10401@oracle.com>
References: <4C3D6CBA.10401@oracle.com>
Message-ID: <1279094003-10209-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

struct file * has file_ra_state to store the readahead state
and data. So pass this to ocfs2_write_begin_nolock so that
it can be used in ocfs2_refcount_cow.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c |    5 +++--
 fs/ocfs2/aops.h |    3 ++-
 fs/ocfs2/mmap.c |    7 ++++---
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 3623ca2..13a41ef 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1644,7 +1644,8 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
 	return ret;
 }
 
-int ocfs2_write_begin_nolock(struct address_space *mapping,
+int ocfs2_write_begin_nolock(struct file *filp,
+			     struct address_space *mapping,
 			     loff_t pos, unsigned len, unsigned flags,
 			     struct page **pagep, void **fsdata,
 			     struct buffer_head *di_bh, struct page *mmap_page)
@@ -1852,7 +1853,7 @@ static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = ocfs2_write_begin_nolock(mapping, pos, len, flags, pagep,
+	ret = ocfs2_write_begin_nolock(file, mapping, pos, len, flags, pagep,
 				       fsdata, di_bh, NULL);
 	if (ret) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index c48e93f..7606f66 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -48,7 +48,8 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 			   loff_t pos, unsigned len, unsigned copied,
 			   struct page *page, void *fsdata);
 
-int ocfs2_write_begin_nolock(struct address_space *mapping,
+int ocfs2_write_begin_nolock(struct file *filp,
+			     struct address_space *mapping,
 			     loff_t pos, unsigned len, unsigned flags,
 			     struct page **pagep, void **fsdata,
 			     struct buffer_head *di_bh, struct page *mmap_page);
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index af2b8fe..b04d696 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -59,10 +59,11 @@ static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 	return ret;
 }
 
-static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
+static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 				struct page *page)
 {
 	int ret;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
 	loff_t pos = page_offset(page);
 	unsigned int len = PAGE_CACHE_SIZE;
@@ -109,7 +110,7 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 	if (page->index == last_index)
 		len = size & ~PAGE_CACHE_MASK;
 
-	ret = ocfs2_write_begin_nolock(mapping, pos, len, 0, &locked_page,
+	ret = ocfs2_write_begin_nolock(file, mapping, pos, len, 0, &locked_page,
 				       &fsdata, di_bh, page);
 	if (ret) {
 		if (ret != -ENOSPC)
@@ -157,7 +158,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = __ocfs2_page_mkwrite(inode, di_bh, page);
+	ret = __ocfs2_page_mkwrite(vma->vm_file, di_bh, page);
 
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-- 
1.7.1.GIT
