From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Mar 11 17:00:06 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fix for revalidating an inode
Message-ID: <200403112259.i2BMxnsZ008760@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following minimal patch catches the case on a 2.6 system where
the passed in nameidata is null (which is a valid scenario.)

This is what is causing file deletion to crash.

    --rusty

Index: src/dcache.c
===================================================================
--- src/dcache.c	(revision 770)
+++ src/dcache.c	(working copy)
@@ -52,7 +52,7 @@
 	int needs_trunc;
 	ocfs_find_inode_args args;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	int flags = nd->flags;
+	int flags = nd ? nd->flags : 0;
 #endif
 
         LOG_ENTRY_ARGS ("(0x%08x, %d, '%*s')\n", dentry, flags,
