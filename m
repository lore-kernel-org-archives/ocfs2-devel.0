From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 19 22:13:34 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in io.c
Message-ID: <200402200413.i1K4DTiW004256@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch ports io.c to a 2.6 kernel by replacing
mark_buffer_clean() calls with clear_buffer_dirty().  As I 
commented below, I'm not sure this is the correct thing to 
do.

    --rusty

Index: src/io.c
===================================================================
--- src/io.c	(revision 32)
+++ src/io.c	(working copy)
@@ -277,7 +277,17 @@
 		set_buffer_uptodate(bh);
 
 		/* remove from dirty list before I/O. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)		
+		/*
+		 * mark_buffer_clean() doesn't exist in 2.6.x kernels.
+		 * Not many places actually used mark_buffer_clean, but
+		 * at least reiserfs uses clear_buffer_dirty() as
+		 * a replacment.
+		 */
+		clear_buffer_dirty(bh);
+#else
 		mark_buffer_clean(bh);
+#endif
 
 		bh->b_end_io = ocfs_end_buffer_io_sync;
 		submit_bh(WRITE, bh);
@@ -550,7 +560,17 @@
 
 		set_buffer_uptodate(bh);
 		/* remove from dirty list before I/O. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)		
+		/*
+		 * mark_buffer_clean() doesn't exist in 2.6.x kernels.
+		 * Not many places actually used mark_buffer_clean, but
+		 * at least reiserfs uses clear_buffer_dirty() as
+		 * a replacment.
+		 */
+		clear_buffer_dirty(bh);
+#else
 		mark_buffer_clean(bh);
+#endif
 
 		bh->b_end_io = ocfs_end_buffer_io_sync;
 		submit_bh(WRITE, bh);
