From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Jul  6 21:54:58 2004
Subject: [Ocfs2-devel] [PATCH] add notify trunctpage to close file
Message-ID: <3ACA40606221794F80A5670F0AF15F8404D1BE82@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It is reasonable to notify other node when closing file.
It is reasonable to notify other node when closing file.
It ensures other node can get the newest data after the write finish, 

-------------------------------------------
Index: dlm.c
===================================================================
--- dlm.c	(revision 1242)
+++ dlm.c	(working copy)
@@ -732,7 +732,7 @@
  * ocfs_notify_truncate_on_wopen()
  * inode is definitely non NULL
  */
-int ocfs_notify_truncate_on_wopen (ocfs_super * osb, struct inode
*inode)
+int ocfs_notify_truncate_on_write (ocfs_super * osb, struct inode
*inode)
 {
 	int status = -EAGAIN;
 	int disk_vote = 0;
@@ -774,7 +774,7 @@
 bail:
 	LOG_EXIT_STATUS (status);
 	return status;
-}				/* ocfs_notify_truncate_on_wopen */
+}				/* ocfs_notify_truncate_on_write */
 
 enum {
 	invalid_path = 0,
Index: file.c
===================================================================
--- file.c	(revision 1242)
+++ file.c	(working copy)
@@ -341,6 +341,7 @@
 	struct dentry *dentry;
 	int last_close = 0;
 	int dec = 0;
+	int status;
 
 	LOG_SET_CONTEXT(RELEASE);
 
@@ -394,6 +395,13 @@
 		spin_unlock(&oin_num_ext_lock);
 		up(&recovery_list_sem);
 	}
+	if (file->f_flags & (O_WRONLY|O_RDWR) && !(file->f_flags &
O_DIRECT)) {
+		status = ocfs_notify_truncate_on_write(osb, inode);
+		if (status < 0) {
+			LOG_ERROR_STATUS(status);
+		}
+	}
+
 	up (&(OCFS_I(inode)->ip_sem));
 	ocfs_sync_inode(inode);
 
