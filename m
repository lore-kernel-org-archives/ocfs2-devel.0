From: Sonic Zhang <sonic.zhang@intel.com>
Date: Thu Apr  1 02:35:32 2004
Subject: [Ocfs2-devel] A patch to remove compile warnings in file inode.c
Message-ID: <406BD458.3060203@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

    This is a patch to remove compile warnings in file inode.c.

/root/projects/ocfs2/src/inode.c: In function `ocfs_find_actor':
/root/projects/ocfs2/src/inode.c:562: warning: `args' might be used 
uninitialized in this function

See the attachment.

--------------------------------------------------
--- src/inode.c.old    2004-04-01 16:27:32.683665136 +0800
+++ src/inode.c    2004-04-01 16:29:49.864810432 +0800
@@ -559,7 +559,7 @@
  */
 int ocfs_find_actor (struct inode *inode, void *opaque)
 {
-    ocfs_find_inode_args *args;
+    ocfs_find_inode_args *args = NULL;
     int ret = 0;
     __u64 fileOff;
     ocfs_file_entry *fe = NULL;

-------------- next part --------------
--- src/inode.c.old	2004-04-01 16:27:32.683665136 +0800
+++ src/inode.c	2004-04-01 16:29:49.864810432 +0800
@@ -559,7 +559,7 @@
  */
 int ocfs_find_actor (struct inode *inode, void *opaque)
 {
-	ocfs_find_inode_args *args;
+	ocfs_find_inode_args *args = NULL;
 	int ret = 0;
 	__u64 fileOff;
 	ocfs_file_entry *fe = NULL;
