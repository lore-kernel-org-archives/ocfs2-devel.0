From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 19 17:58:12 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in oin.c
Message-ID: <200402192358.i1JNw43I025405@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following is a small 2.6 port patch to oin.c that replaces
the LINUX_2_5 conditionals with the normal LINUX_VERSION_CODE,
and changes an assignment of NODEV to OCFS_NODEV along with a fix
in ocfs.h that makes the OCFS_NODEV correct for 2.6 kernels.

    --rusty

Index: src/oin.c
===================================================================
--- src/oin.c	(revision 32)
+++ src/oin.c	(working copy)
@@ -154,7 +154,7 @@
 			    case OCFS_ATTRIB_FIFO:
 			    case OCFS_ATTRIB_SOCKET:
 			    {
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 				    dev_t dev;
 #else
 				    kdev_t kdev;
@@ -168,14 +168,14 @@
 				    else if (fe->attribs == OCFS_ATTRIB_SOCKET)
 					    inode->i_mode |= S_IFSOCK;
 
-				    inode->i_rdev = NODEV;
-#ifdef LINUX_2_5
+				    inode->i_rdev = OCFS_NODEV;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 				    dev = MKDEV (fe->dev_major, fe->dev_minor);
 #else
 				    kdev = MKDEV (fe->dev_major, fe->dev_minor);
 #endif
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 				    init_special_inode (inode, inode->i_mode,
 							dev);
 #else
