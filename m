From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Fri Mar 19 12:55:35 2004
Subject: [Ocfs2-devel] Tiny fix to remove dead code
Message-ID: <405B4213.3090008@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since this section of code is wrapped in a
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
it seemed like this was redundant.

John

Index: src/file.c
===================================================================
--- src/file.c	(revision 791)
+++ src/file.c	(working copy)
@@ -1502,11 +1502,7 @@
  	stat->nlink = inode->i_nlink;
  	stat->uid = inode->i_uid;
  	stat->gid = inode->i_gid;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
  	stat->rdev = inode->i_rdev;
-#else
- 	stat->rdev = kdev_t_to_nr(inode->i_rdev);
-#endif
  	stat->atime = inode->i_atime;
  	stat->mtime = inode->i_mtime;
  	stat->ctime = inode->i_ctime;
