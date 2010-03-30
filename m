From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 30 Mar 2010 13:21:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2_dlmfs: User DLM_* when decoding file
	open flags.
Message-ID: <1269926491-11646-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In commit 0016eedc4185a3cd7e578b027a6e69001b85d6c4, we have
changed dlmfs to use stackglue. So when use DLM* when we
decode dlm flags from open level.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dlmfs/dlmfs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 1b0de15..a99d1ea 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -112,20 +112,20 @@ MODULE_PARM_DESC(capabilities, DLMFS_CAPABILITIES);
  * O_RDONLY -> PRMODE level
  * O_WRONLY -> EXMODE level
  *
- * O_NONBLOCK -> LKM_NOQUEUE
+ * O_NONBLOCK -> NOQUEUE
  */
 static int dlmfs_decode_open_flags(int open_flags,
 				   int *level,
 				   int *flags)
 {
 	if (open_flags & (O_WRONLY|O_RDWR))
-		*level = LKM_EXMODE;
+		*level = DLM_LOCK_EX;
 	else
-		*level = LKM_PRMODE;
+		*level = DLM_LOCK_PR;
 
 	*flags = 0;
 	if (open_flags & O_NONBLOCK)
-		*flags |= LKM_NOQUEUE;
+		*flags |= DLM_LKF_NOQUEUE;
 
 	return 0;
 }
@@ -166,7 +166,7 @@ static int dlmfs_file_open(struct inode *inode,
 		 * to be able userspace to be able to distinguish a
 		 * valid lock request from one that simply couldn't be
 		 * granted. */
-		if (flags & LKM_NOQUEUE && status == -EAGAIN)
+		if (flags & DLM_LKF_NOQUEUE && status == -EAGAIN)
 			status = -ETXTBSY;
 		kfree(fp);
 		goto bail;
@@ -193,7 +193,7 @@ static int dlmfs_file_release(struct inode *inode,
 	status = 0;
 	if (fp) {
 		level = fp->fp_lock_level;
-		if (level != LKM_IVMODE)
+		if (level != DLM_LOCK_IV)
 			user_dlm_cluster_unlock(&ip->ip_lockres, level);
 
 		kfree(fp);
-- 
1.5.5
