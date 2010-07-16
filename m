From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 16 Jul 2010 22:21:00 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make __ocfs2_page_mkwrite handle file
	end properly.
Message-ID: <1279290060-2147-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

__ocfs2_page_mkwrite now is broken in handling file end.
1. the last page should be the page contains i_size - 1.
2. the len in the last page is also calculated wrong.
So change them accordingly.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/mmap.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index af2b8fe..4c18f4a 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -74,9 +74,11 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 	/*
 	 * Another node might have truncated while we were waiting on
 	 * cluster locks.
+	 * We don't check size == 0 before the shift. This is borrowed
+	 * from do_generic_file_read.
 	 */
-	last_index = size >> PAGE_CACHE_SHIFT;
-	if (page->index > last_index) {
+	last_index = (size - 1) >> PAGE_CACHE_SHIFT;
+	if (unlikely(!size || page->index > last_index)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -107,7 +109,7 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 	 * because the "write" would invalidate their data.
 	 */
 	if (page->index == last_index)
-		len = size & ~PAGE_CACHE_MASK;
+		len = ((size - 1) & ~PAGE_CACHE_MASK) + 1;
 
 	ret = ocfs2_write_begin_nolock(mapping, pos, len, 0, &locked_page,
 				       &fsdata, di_bh, page);
-- 
1.7.1.GIT
