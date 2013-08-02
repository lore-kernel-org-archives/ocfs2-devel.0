From: Younger Liu <younger.liu@huawei.com>
Date: Fri, 2 Aug 2013 17:14:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: free path in ocfs2_remove_inode_range()
Message-ID: <51FB7876.1010506@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_remove_inode_range(), there is a memory leak.
The variable path has allocated memory with ocfs2_new_path_from_et(), 
but it is not free.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
---
 fs/ocfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 833a09b..2d1a227 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1796,6 +1796,7 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	ocfs2_truncate_cluster_pages(inode, byte_start, byte_len);
 
 out:
+	ocfs2_free_path(path);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &dealloc);
 
-- 
1.7.9.7
