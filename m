From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Fri Mar 26 23:17:04 2004
Subject: [Ocfs2-devel] [PATCH] correctly set inode->i_rdev
Message-ID: <200403270516.i2R5Gpac012997@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following minimal patch fixes bug #52.  For some reason we were
always setting the inode->i_rdev to the super block's dev while 
populating the inode.

    --rusty

Index: src/inode.c
===================================================================
--- src/inode.c	(revision 813)
+++ src/inode.c	(working copy)
@@ -260,7 +260,7 @@
 		goto bail;
 	}
 	
-	OCFS_SET_INODE_DEV(sb, inode);
+	inode->i_rdev = MKDEV (fe->dev_major, fe->dev_minor);
 	inode->i_mode = mode;
 	inode->i_uid = fe->uid;
 	inode->i_gid = fe->gid;
