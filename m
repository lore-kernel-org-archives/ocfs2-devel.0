From: Sonic Zhang <sonic.zhang@intel.com>
Date: Fri Mar 26 02:27:28 2004
Subject: [Ocfs2-devel] About Mark's advice on bug 48
In-Reply-To: <4063DB4B.6060000@intel.com>
References: <4063DB4B.6060000@intel.com>
Message-ID: <4063E97B.7020100@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

Yes, I find the code in ocfs_daemonize() to allow kernel thread to 
receive signals. So, I change the signal process code to make it 
compilable under kernel 2.6. Please check my revise.

Thank you.

This patch is for journal.c.
------------------------------------------------------------------
--- ocfs2.old/src/journal.c.old    2004-03-25 10:44:20.000000000 +0800
+++ ocfs2/src/journal.c    2004-03-26 16:08:19.526750568 +0800
@@ -1745,6 +1745,7 @@
     ocfs_commit_task *commit = osb->commit;
     char name[16];
     ocfs_journal * journal = &osb->journal;
+    siginfo_t info;
 
     sprintf (name, "ocfs2cmt-%d", osb->osb_id);
     ocfs_daemonize (name, strlen(name));
@@ -1765,7 +1766,21 @@
                 LOG_TRACE_STR("FLUSH_EVENT: timed out");
                 break;
             case -EINTR:
-                finish = 1;
+                /* journal shutdown has asked me to do
+                 * one last commit cache and then exit */
+                if (journal->state == OCFS_JOURNAL_IN_SHUTDOWN)
+                    finish = 1;
+                if (signal_pending(current)) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+                    /* ignore the actual signal */
+                    dequeue_signal_lock(current, &current->blocked, &info);
+#else
+                    spin_lock_irq(&current->sigmask_lock);
+                    /* ignore the actual signal */
+                    dequeue_signal(&current->blocked, &info);
+                    spin_unlock_irq(&current->sigmask_lock);
+#endif
+                }
                 LOG_TRACE_STR("FLUSH_EVENT: interrupted");
                 break;
             case 0:
@@ -1778,7 +1793,7 @@
 
         if ((OcfsGlobalCtxt.flags & OCFS_FLAG_SHUTDOWN_VOL_THREAD) ||
             (osb->osb_flags & OCFS_OSB_FLAGS_BEING_DISMOUNTED))
-            break;
+            finish = 1;
 
         //if (!osb->needs_flush && status != 0)
         //    continue;
@@ -1788,18 +1803,13 @@
 
         if (down_trylock(&osb->trans_lock) != 0) {
             LOG_TRACE_ARGS("commit thread: trylock failed, miss=%d\n", 
misses);
-            if (++misses < OCFS_COMMIT_MISS_MAX)
+            if (++misses < OCFS_COMMIT_MISS_MAX && finish == 0)
                 continue;
             LOG_TRACE_ARGS("commit thread: about to down\n");
             down(&osb->trans_lock);
             misses = 0;
         }
 
-        /* journal shutdown has asked me to do one last commit cache */
-        /* this commit cache will leave trans lock held! */
-        if (journal->state == OCFS_JOURNAL_IN_SHUTDOWN)
-            finish = 1;
-
         status = ocfs_commit_cache (osb, false);
         if (status < 0)
             LOG_ERROR_STATUS(status);
