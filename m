From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 19 22:13:12 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in dcache.c
Message-ID: <200402200413.i1K4D0D5004243@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is a minimal patch that fixes a compile warning when building
with a 2.6 kernel, and also switches over another #if LINUX_2_5 to
the normal #if LINUX_VERSION_CODE ...

    --rusty

Index: src/dcache.c
===================================================================
--- src/dcache.c	(revision 32)
+++ src/dcache.c	(working copy)
@@ -43,10 +43,12 @@
 	ocfs_inode *oin;
 	ocfs_super *osb;
 	__u64 off;
-	ocfs_find_inode_args args;
         struct qstr q;
 	struct buffer_head *fe_bh = NULL;
 	int needs_trunc;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+	ocfs_find_inode_args args;
+#endif
 
         LOG_ENTRY_ARGS ("(0x%08x, %d, '%*s')\n", dentry, flags,
                         dentry->d_name.len, dentry->d_name.name);
@@ -127,7 +129,7 @@
                 LOG_TRACE_STR("found the file entry, but it has been deleted or renamed!");
                 ret = 0;  /* it is now officially stale :) */
         } else {
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 		ocfs_read_locked_inode (inode, fe);
 #else
 		args.offset = fe->this_sector;
