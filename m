From: Christoph Hellwig <hch@lst.de>
Date: Wed Jun  2 13:10:23 2004
Subject: [Ocfs2-devel] [PATCH] kill 2.4 dev_t vs kdev_t crap
Message-ID: <20040602091402.GB22363@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The difference between kdev_t and dev_t in 2.4 is rather theoretical, no
need to clutter up the source for it.


Index: src/inode.c
===================================================================
--- src/inode.c	(revision 969)
+++ src/inode.c	(working copy)
@@ -1877,11 +1872,8 @@
 		case OCFS_ATTRIB_FIFO:
 		case OCFS_ATTRIB_SOCKET:
 		{
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 			dev_t dev;
-#else
-			kdev_t kdev;
-#endif
+
 			if (fe->attribs == OCFS_ATTRIB_CHAR)
 				inode->i_mode |= S_IFCHR;
 			else if (fe->attribs == OCFS_ATTRIB_BLOCK)
@@ -1892,18 +1884,8 @@
 				inode->i_mode |= S_IFSOCK;
 
 			inode->i_rdev = OCFS_NODEV;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-			dev = MKDEV (fe->dev_major, fe->dev_minor);
-#else
-			kdev = MKDEV (fe->dev_major, fe->dev_minor);
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-			init_special_inode (inode, inode->i_mode, dev);
-#else
-			init_special_inode (inode, inode->i_mode, 
-					    kdev_t_to_nr(kdev));
-#endif
+			init_special_inode (inode, inode->i_mode,
+					MKDEV(fe->dev_major, fe->dev_minor));
 			break;
 		}
 		default:
