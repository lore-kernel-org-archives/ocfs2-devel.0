From: Sonic Zhang <sonic.zhang@intel.com>
Date: Tue Mar 23 21:05:22 2004
Subject: [Ocfs2-devel] 
 Bug 48 "[kernel 2.6 porting] System halt during reboot after mount
 an OCFS volume." in bugzilla is fixed.
Message-ID: <4060FB02.9090402@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

I successfully root cause and fix bug 48 "[kernel 2.6 porting] System halt 
during reboot after mount an OCFS volume.".

In current OCFS v2 driver, ocfs_volume_thread, ocfs_recv_thread and 
ocfs_commit_thread are assumed to be terminated by the ocfs_dismount_volume 
routine. But, if the system reboots, all processes and kernel threads will 
receive signal SIGTERM before ocfs_dismount_volume routine is called.  

These kernel threads don't exit correctly. For example, they don't know they 
should exit loop after received signal SIGTERM and clear their task_struct 
pointers in ocfs_super to indiate their status. That's the cause of the system 
halt in ocfs_dismount_volume routine when system reboots.

I attach a patch to fix this bug. Please review. 

Thank you

This patch is against svn version 807.
----------------------------------------------------------------
--- ocfs2.old/src/journal.c	2004-03-22 16:02:55.000000000 +0800
+++ ocfs2/src/journal.c	2004-03-22 16:09:57.000000000 +0800
@@ -1034,12 +1034,13 @@
 	/* The OCFS_JOURNAL_IN_SHUTDOWN will signal to commit_cache to not
 	 * drop the trans_lock (which we want to hold until we
 	 * completely destroy the journal. */
-	if (osb->commit && osb->commit->c_task) {
-		/* Wait for the commit thread */
-		LOG_TRACE_STR ("Waiting for ocfs2commit to exit....");
-		send_sig (SIGINT, osb->commit->c_task, 0);
-		wait_for_completion(&osb->commit->c_complete);
-		osb->commit->c_task = NULL;
+	if (osb->commit) {
+		if(osb->commit->c_task) {
+			/* Wait for the commit thread */
+			LOG_TRACE_STR ("Waiting for ocfs2commit to exit....");
+			send_sig (SIGINT, osb->commit->c_task, 0);
+			wait_for_completion(&osb->commit->c_complete);
+		}
 		ocfs_free(osb->commit);
 	}
 	
@@ -1808,7 +1809,7 @@
 			break;
 	}
 
-
+	commit->c_task = NULL;
 
         /* Flush all scheduled tasks */
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)


--- ocfs2.old/src/nm.c.old	2004-03-23 17:09:29.000000000 +0800
+++ ocfs2/src/nm.c	2004-03-24 10:18:35.000000000 +0800
@@ -118,6 +118,8 @@
 		OcfsIpcCtxt.recv_sock = NULL;
 	}
 
+	OcfsIpcCtxt.task = NULL;
+
 	/* signal main thread of ipcdlm's exit */
 	complete (&(OcfsIpcCtxt.complete));
 
@@ -249,6 +251,8 @@
 	__u64 cfg_seq_num;
 	int which, pruned, prune_iters = 0;
 	struct buffer_head *bh = NULL;
+	int signr;
+	siginfo_t info;
 
 	LOG_ENTRY ();
 
@@ -258,6 +262,7 @@
 
 	sprintf (proc, "ocfs2nm-%d", osb->osb_id);
 	ocfs_daemonize (proc, strlen(proc));
+	allow_signal(SIGTERM);
 
 	osb->dlm_task = current;
 
@@ -437,7 +442,11 @@
 			osb->hbt = 50 + j;
 		}
 		set_current_state (TASK_INTERRUPTIBLE);
-		schedule_timeout (osb->hbt - j);
+		if( schedule_timeout (osb->hbt - j) < osb->hbt -j ) {
+			signr = dequeue_signal_lock(current, &current->blocked, &info);
+			if(signr == SIGTERM)
+				OcfsGlobalCtxt.flags |= OCFS_FLAG_SHUTDOWN_VOL_THREAD;
+		}
 	}
 
         /* Flush all scheduled tasks */
@@ -447,6 +456,8 @@
         flush_scheduled_tasks ();
 #endif
 
+	osb->dlm_task = NULL;
+
 	complete (&(osb->dlm_complete));
 eek:
 	LOG_EXIT_LONG (0);
