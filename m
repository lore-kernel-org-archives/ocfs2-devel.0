From: Christoph Hellwig <hch@lst.de>
Date: Thu Jun  3 06:00:29 2004
Subject: [Ocfs2-devel] [PATCH] provide io_schedule for 2.4
Message-ID: <20040603110021.GB13534@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

(vs format-changes branch)


--- src/inc/ocfs_compat.h	(revision 994)
+++ src/inc/ocfs_compat.h	(working copy)
@@ -52,6 +70,8 @@
 #define unlock_page(p)         UnlockPage(p)
 #define Page_Uptodate(p)       PageUptodate(p)
 
+#define io_schedule		schedule
+
 #else /* LINUX_VERSION_CODE < 2.6 */
 
 #define OCFS_GENERIC_SB_MEMBER(sb)  ((sb)->s_fs_info)
--- src/hash.c	(revision 994)
+++ src/hash.c	(working copy)
@@ -536,11 +536,7 @@
 #endif
 		if (!do_timeout) {
 			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 			io_schedule();
-#else
-			schedule();
-#endif
 		} else {
 			do_timeout = 0;
 			set_task_state(tsk, TASK_INTERRUPTIBLE);
