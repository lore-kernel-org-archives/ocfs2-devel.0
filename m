From: Sonic Zhang <sonic.zhang@intel.com>
Date: Thu Mar 25 03:26:00 2004
Subject: [Ocfs2-devel] About Mark's advice on bug 48
Message-ID: <4062A5B5.3000205@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

    I change a little to your patch. I remove the signal prcess code, 
because kernel thread doesn't receive signals by default. This patch 
fixes the halt problem in thread ocfs_submit_thread(). But, there is 
another dead lock on osb->publish_lock in thread  ocfs_volume_thread() 
and routine ocfs_journal_set_unmounted(). I am tracking this problem now.

Following is the revised patch for journal.c
--------------------------------------------------------------
--- journal.c.old    2004-03-25 10:44:20.000000000 +0800
+++ journal.c    2004-03-25 10:57:53.000000000 +0800
@@ -1765,7 +1765,10 @@
                 LOG_TRACE_STR("FLUSH_EVENT: timed out");
                 break;
             case -EINTR:
-                finish = 1;
+                /* journal shutdown has asked me to do
+                 * one last commit cache and then exit */
+                if (journal->state == OCFS_JOURNAL_IN_SHUTDOWN)
+                    finish = 1;
                 LOG_TRACE_STR("FLUSH_EVENT: interrupted");
                 break;
             case 0:
@@ -1778,7 +1781,7 @@
 
         if ((OcfsGlobalCtxt.flags & OCFS_FLAG_SHUTDOWN_VOL_THREAD) ||
             (osb->osb_flags & OCFS_OSB_FLAGS_BEING_DISMOUNTED))
-            break;
+            finish = 1;
 
         //if (!osb->needs_flush && status != 0)
         //    continue;
@@ -1788,18 +1791,13 @@
 
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
