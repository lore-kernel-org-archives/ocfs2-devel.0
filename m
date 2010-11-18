From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 18 Nov 2010 23:52:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: lock the page in
	__ocfs2_page_mkwrite() -v2
Message-ID: <201011181554.oAIFs5a5031128@rcsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Lock the page in __ocfs2_page_mkwrite(). Or we may get -EINVAL error
from ocfs2_grab_pages_for_write() if the page(page cache) gets truncated
while someone is flushing the pagecache. In the original code, we are
checking mapping earlier in __ocfs2_page_mkwrite() but we don't lock it.
so the mapping can change during flushing pagecache.


Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/aops.c |   10 +++++++---
 fs/ocfs2/mmap.c |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f1e962c..6b7e1f2 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1130,14 +1130,18 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 
 		if (index == target_index && mmap_page) {
 			/*
-			 * ocfs2_pagemkwrite() is a little different
+			 * ocfs2_page_mkwrite() is a little different
 			 * and wants us to directly use the page
 			 * passed in.
+			 * So far, only __ocfs2_page_mkwrite() passes in a
+			 * non-NULL page. And we locked the page there, so we
+			 * just assert the page is locked. If another path will
+			 * be passing in a non-NULL page in future, the locking
+			 * should be well considered.
 			 */
-			lock_page(mmap_page);
+			BUG_ON(!PageLocked(mmap_page));
 
 			if (mmap_page->mapping != mapping) {
-				unlock_page(mmap_page);
 				/*
 				 * Sanity check - the locking in
 				 * ocfs2_pagemkwrite() should ensure
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 7e32db9..bb29335 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -79,9 +79,10 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 	 * from do_generic_file_read.
 	 */
 	last_index = (size - 1) >> PAGE_CACHE_SHIFT;
+	lock_page(page);
 	if (unlikely(!size || page->index > last_index)) {
 		ret = -EINVAL;
-		goto out;
+		goto out_unlock;
 	}
 
 	/*
@@ -96,7 +97,7 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 		 * So return 0 here and let VFS retry.
 		 */
 		ret = 0;
-		goto out;
+		goto out_unlock;
 	}
 
 	/*
@@ -117,7 +118,7 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
-		goto out;
+		goto out_unlock;
 	}
 
 	ret = ocfs2_write_end_nolock(mapping, pos, len, len, locked_page,
@@ -128,6 +129,9 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 	}
 	BUG_ON(ret != len);
 	ret = 0;
+	goto out;
+out_unlock:
+	unlock_page(page);
 out:
 	return ret;
 }
-- 
1.7.2.3
