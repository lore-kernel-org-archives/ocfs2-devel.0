From: WeiWei Wang <wangww631@huawei.com>
Date: Tue, 23 Sep 2014 17:14:37 +0800
Subject: [Ocfs2-devel] [PATCH 6/7 v2] ocfs2: do not fallback to buffer I/O
 write if appending
Message-ID: <542139FD.7010801@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

After enable block allocation in direct-io write now, we don't fallback to buffer I/O
write in append write sitiaion any more. If the O_DIRECT flag is taken, we use direct-io.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
---
 fs/ocfs2/aops.c |  4 ----
 fs/ocfs2/file.c | 11 -----------
 2 files changed, 15 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1e6de00..859dd7f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -663,10 +663,6 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;

-	/* Fallback to buffered I/O if we are appending. */
-	if (i_size_read(inode) <= offset)
-		return 0;
-
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
 		/*
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 964d442..a3b0efb 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2193,17 +2193,6 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		}

 		/*
-		 * Allowing concurrent direct writes means
-		 * i_size changes wouldn't be synchronized, so
-		 * one node could wind up truncating another
-		 * nodes writes.
-		 */
-		if (end > i_size_read(inode)) {
-			*direct_io = 0;
-			break;
-		}
-
-		/*
 		 * We don't fill holes during direct io, so
 		 * check for them here. If any are found, the
 		 * caller will have to retake some cluster
-- 1.8.4.3
