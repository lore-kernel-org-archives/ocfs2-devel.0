From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 19 18:12:00 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in oin.c
In-Reply-To: <200402192358.i1JNw43I025405@penguin.co.intel.com>
References: <200402192358.i1JNw43I025405@penguin.co.intel.com>
Message-ID: <20040220001149.GA26928@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 19, 2004 at 03:58:04PM -0800, Rusty Lynch wrote:
> The following is a small 2.6 port patch to oin.c that replaces
> the LINUX_2_5 conditionals with the normal LINUX_VERSION_CODE,
> and changes an assignment of NODEV to OCFS_NODEV along with a fix
> in ocfs.h that makes the OCFS_NODEV correct for 2.6 kernels.
> 
>     --rusty

#@#$#!!! here is a version that also includes changes to ocfs.h

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
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 32)
+++ src/inc/ocfs.h	(working copy)
@@ -1136,7 +1136,7 @@
 #define OCFS_SET_INODE_DEV(sb, inode)   (inode->i_rdev = sb->sdev)
 typedef struct block_device * ocfs_blockdev;
 typedef dev_t ocfs_dev;
-#define OCFS_NODEV     NODEV.value
+#define OCFS_NODEV     0
 #define OCFS_GET_BLOCKDEV(sb)   ((sb)->s_bdev)
 #else /* 2.4 kernel */
 #define OCFS_SET_INODE_DEV(sb, inode)   (inode->i_dev = sb->s_dev)
