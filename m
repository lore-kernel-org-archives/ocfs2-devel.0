From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Feb 24 10:29:46 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in hash.c
Message-ID: <200402241629.i1OGTUxx023956@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I still have a few items missing to enable a clean compile against
a 2.6 kernel.  The following is a patch to hash.c that:

* kicks off the block-io run queues in the new non-task_queue 
  oriented way
* utilizes the new io_schedule() method

Index: src/hash.c
===================================================================
--- src/hash.c	(revision 34)
+++ src/hash.c	(working copy)
@@ -1104,10 +1104,18 @@
 		if (!buffer_modified(bh) ||
 		    sem->s_pid == current->pid)
 			break;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+		blk_run_queues();
+#else
 		run_task_queue(&tq_disk);
+#endif
 		if (!do_timeout) {
 			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+			io_schedule();
+#else
 			schedule();
+#endif
 		} else {
 			do_timeout = 0;
 			set_task_state(tsk, TASK_INTERRUPTIBLE);
