From: piaojun <piaojun@huawei.com>
Date: Sat, 19 Nov 2016 12:46:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up unused 'page' parameter in
 ocfs2_write_end_nolock()
Message-ID: <582FD91A.5000902@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

'page' parameter in ocfs2_write_end_nolock() is never used.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/aops.c | 7 +++----
 fs/ocfs2/aops.h | 3 +--
 fs/ocfs2/mmap.c | 3 +--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c5c5b97..9a88984 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1950,8 +1950,7 @@ static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
 }
 
 int ocfs2_write_end_nolock(struct address_space *mapping,
-			   loff_t pos, unsigned len, unsigned copied,
-			   struct page *page, void *fsdata)
+			   loff_t pos, unsigned len, unsigned copied, void *fsdata)
 {
 	int i, ret;
 	unsigned from, to, start = pos & (PAGE_SIZE - 1);
@@ -2064,7 +2063,7 @@ static int ocfs2_write_end(struct file *file, struct address_space *mapping,
 	int ret;
 	struct inode *inode = mapping->host;
 
-	ret = ocfs2_write_end_nolock(mapping, pos, len, copied, page, fsdata);
+	ret = ocfs2_write_end_nolock(mapping, pos, len, copied, fsdata);
 
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
@@ -2241,7 +2240,7 @@ static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
 		dwc->dw_zero_count++;
 	}
 
-	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, NULL, wc);
+	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
 	BUG_ON(ret != len);
 	ret = 0;
 unlock:
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index b1c9f28..8614ff0 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -44,8 +44,7 @@ int walk_page_buffers(	handle_t *handle,
 					struct buffer_head *bh));
 
 int ocfs2_write_end_nolock(struct address_space *mapping,
-			   loff_t pos, unsigned len, unsigned copied,
-			   struct page *page, void *fsdata);
+			   loff_t pos, unsigned len, unsigned copied, void *fsdata);
 
 typedef enum {
 	OCFS2_WRITE_BUFFER = 0,
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 71545ad..4290887 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -120,8 +120,7 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
-	ret = ocfs2_write_end_nolock(mapping, pos, len, len, locked_page,
-				     fsdata);
+	ret = ocfs2_write_end_nolock(mapping, pos, len, len, fsdata);
 	BUG_ON(ret != len);
 	ret = VM_FAULT_LOCKED;
 out:
-- 
1.9.5.msysgit.1
