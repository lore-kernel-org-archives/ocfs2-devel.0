From: Li Dongyang <lidongyang@novell.com>
Date: Thu, 22 Apr 2010 16:11:29 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: use OCFS2_INODE_SKIP_ORPHAN_DIR in
	ocfs2_mknod error path
Message-ID: <201004221611.30029.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

mark the inode with flag OCFS2_INODE_SKIP_ORPHAN_DIR in ocfs2_mknod,
so we can kill the inode in case of error.

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/ocfs2/namei.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 4ce4416..f989823 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -447,11 +447,6 @@ leave:
 
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	if ((status < 0) && inode) {
-		clear_nlink(inode);
-		iput(inode);
-	}
-
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
 
@@ -461,6 +456,17 @@ leave:
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 
+	/*
+	We should call iput after the i_mutex of the bitmap
+	been unlocked in ocfs2_free_alloc_context, or the ocfs2_delete_inode
+	will mutex_lock again.
+	*/
+	if ((status < 0) && inode) {
+		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
+		clear_nlink(inode);
+		iput(inode);
+	}
+
 	mlog_exit(status);
 
 	return status;
-- 
1.6.4.2
