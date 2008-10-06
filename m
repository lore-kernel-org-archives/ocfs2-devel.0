From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  6 Oct 2008 16:59:55 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/mmap: return 0 in page_mkwrite to let
	VFS retry.
Message-ID: <1223283595-4316-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_page_mkwrite, we return -EINVAL when we found the page mapping
isn't updated, and it will cause the user space program get SIGBUS and
exit. The reason is that during race writeable mmap, we will do
unmap_mapping_range in ocfs2_data_downconvert_worker. The good thing is
that if we reuturn 0 in page_mkwrite, VFS will retry fault and then
call page_mkwrite again, so it is safe to return 0 here.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/mmap.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 3dc18d6..eea1d24 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -113,7 +113,11 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 	 * ocfs2_write_begin_nolock().
 	 */
 	if (!PageUptodate(page) || page->mapping != inode->i_mapping) {
-		ret = -EINVAL;
+		/*
+		 * the page has been umapped in ocfs2_data_downconvert_worker.
+		 * So return 0 here and let VFS retry.
+		 */
+		ret = 0;
 		goto out;
 	}
 
-- 
1.5.3.6.861.gd794-dirty
