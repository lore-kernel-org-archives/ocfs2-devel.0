From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Fri Mar 26 19:42:36 2004
Subject: [Ocfs2-devel] New patch to solve starvation problem in bug 48
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E48@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

	I found a new solution to fix the starvation problem in bug 48
instead of changed the delta jiffies to schedule_timeout(). I just add
several lines of signal process code, which makes the thread
ocfs_volume_thread() really go to thread after receive the SIGTERM
signal. It also gives routine ocfs_journal_set_unmounted() a chance to
run and check the lock status before thread ocfs_volume_thread() wakes
up.

I generate the patch for nm.c again. Please check.
----------------------------------------------------------------
--- ocfs2.old/src/nm.c.old	2004-03-26 15:21:32.000000000 +0800
+++ ocfs2/src/nm.c	2004-03-27 09:22:06.176266560 +0800
@@ -119,6 +119,8 @@
 		OcfsIpcCtxt.recv_sock = NULL;
 	}
 
+	OcfsIpcCtxt.task = NULL;
+	
 	/* signal main thread of ipcdlm's exit */
 	complete (&(OcfsIpcCtxt.complete));
 
@@ -250,6 +252,7 @@
 	__u64 cfg_seq_num;
 	int which, pruned, prune_iters = 0;
 	struct buffer_head *bh = NULL;
+	siginfo_t info;
 
 	LOG_ENTRY ();
 
@@ -409,6 +412,7 @@
 				OCFS_BH_PUT_DATA(bh);
 				status = ocfs_write_bh(osb, bh, 0,
NULL);
 				if (status < 0) {
+					up(&(osb->publish_lock));
 					LOG_ERROR_STATUS (status);
 					goto finally;
 				}
@@ -439,6 +443,18 @@
 		}
 		set_current_state (TASK_INTERRUPTIBLE);
 		schedule_timeout (osb->hbt - j);
+
+		if (signal_pending(current)) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+			/* ignore the actual signal */
+			dequeue_signal_lock(current, &current->blocked,
&info);
+#else
+			spin_lock_irq(&current->sigmask_lock);
+			/* ignore the actual signal */
+			dequeue_signal(&current->blocked, &info);
+			spin_unlock_irq(&current->sigmask_lock);
+#endif
+		}
 	}
 
         /* Flush all scheduled tasks */



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
