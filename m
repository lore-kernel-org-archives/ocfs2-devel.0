From: Christoph Hellwig <hch@lst.de>
Date: Wed Jun  2 13:10:23 2004
Subject: [Ocfs2-devel] 2.6-style i_version handling is fine for 2.4 aswell
Message-ID: <20040602093528.GB23262@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/inode.c
===================================================================
--- src/inode.c	(revision 969)
+++ src/inode.c	(working copy)
@@ -376,10 +380,7 @@
 		goto bail;
 	}
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	inode->i_version = 1;
-#endif
-
 	inode->i_rdev = MKDEV (fe->dev_major, fe->dev_minor);
 	inode->i_mode = mode;
 	inode->i_uid = fe->uid;
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 969)
+++ src/namei.c	(working copy)
@@ -1134,11 +1131,7 @@
 		OCFS_BH_GET_DATA_WRITE(new_de_bh); /* write */
 		new_de->inode = le64_to_cpu(GET_INODE_FEOFF(old_inode));
 		new_de->file_type = old_de->file_type;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 		new_dir->i_version++;
-#else
-		new_dir->i_version = ++event;
-#endif
 		OCFS_BH_PUT_DATA(new_de_bh);
 		status = ocfs_journal_dirty(handle, new_de_bh);
 		if (status < 0) {
@@ -1556,11 +1549,7 @@
 			buf = NULL;
 
 			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 			dir->i_version++;
-#else
-			dir->i_version = ++event;
-#endif
 			status = ocfs_journal_dirty(handle, bh);
 			retval = 0;
 			goto bail;
@@ -1613,11 +1602,7 @@
 			else
 				de->inode = 0;
 			OCFS_BH_PUT_DATA(bh);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 			dir->i_version++;
-#else
-			dir->i_version = ++event;
-#endif
 			status = ocfs_journal_dirty(handle, bh);
 			goto bail;
 		}
