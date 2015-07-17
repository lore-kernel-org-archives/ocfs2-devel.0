From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 17 Jul 2015 10:49:58 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up unused local variables in
	ocfs2_file_write_iter
Message-ID: <55A86D56.801@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since commit 86b9c6f3f891 removes filesize checks for sync I/O journal
commit, variables old_size and old_clusters are not actually used any
more. So clean them up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/file.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e71c623..2b802c4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2256,8 +2256,6 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	ssize_t written = 0;
 	ssize_t ret;
 	size_t count = iov_iter_count(from), orig_count;
-	loff_t old_size;
-	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -2361,13 +2359,6 @@ relock:
 		ocfs2_iocb_set_unaligned_aio(iocb);
 	}

-	/*
-	 * To later detect whether a journal commit for sync writes is
-	 * necessary, we sample i_size, and cluster count here.
-	 */
-	old_size = i_size_read(inode);
-	old_clusters = OCFS2_I(inode)->ip_clusters;
-
 	/* communicate with ocfs2_dio_end_io */
 	ocfs2_iocb_set_rw_locked(iocb, rw_level);

-- 
1.8.4.3
