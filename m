From: Sonic Zhang <sonic.zhang@intel.com>
Date: Fri Mar 26 01:26:59 2004
Subject: [Ocfs2-devel] About Mark's advice on bug 48
Message-ID: <4063DB4B.6060000@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

Finally, I found the second halt is caused by starvation when routine 
ocfs_joutnal_set_unmounted() acquiring the lock osb->publish_lock. In 
thread ocfs_volume_thread(), the delta jiffies to sleep between up() and 
down() in schedule_timeout() is too short. Routine 
ocfs_joutnal_set_unmounted() has no chance to check if lock 
osb->publish_lock is released  between it is releases and reacquired by 
thread ocfs_volume_thread. So routine ocfs_journal_set_unmounted() 
always waits in loop. After I change the delta jiffies from 50 to 500, 
kernel 2.6 won't halt when it reboots after  a OCFS volume is mounted.

I also add a line to release the lock in a branch to  symbol "finally". 
 This may remove latent dead lock. In addition, I clear the reference 
point OcfsIpcCtxt.task before thread ocfs_recv_thread() exits. This 
prevents invalid access to the task structure in routine 
ocfs_dismount_volume() when rebooting.

Here is my patch to file nm.c.
-------------------------------------------------------------------
--- ocfs2.old/src/nm.c.old    2004-03-26 15:21:32.000000000 +0800
+++ ocfs2/src/nm.c    2004-03-26 15:21:06.000000000 +0800
@@ -119,6 +119,8 @@
         OcfsIpcCtxt.recv_sock = NULL;
     }
 
+    OcfsIpcCtxt.task = NULL;
+   
     /* signal main thread of ipcdlm's exit */
     complete (&(OcfsIpcCtxt.complete));
 
@@ -227,6 +229,12 @@
 //#define OCFS_BH_SEM_PRUNE_LIMIT   60   // prune everything each 30 
seconds
 #define OCFS_BH_SEM_PRUNE_LIMIT   60000  // 8 hours :)
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+#define OCFS_SCHEDULE_TIMEOUT_JIFFIES    500
+#else
+#define OCFS_SCHEDULE_TIMEOUT_JIFFIES    50
+#endif
+
 /*
  * ocfs_volume_thread()
  *
@@ -409,6 +417,7 @@
                 OCFS_BH_PUT_DATA(bh);
                 status = ocfs_write_bh(osb, bh, 0, NULL);
                 if (status < 0) {
+                    up(&(osb->publish_lock));
                     LOG_ERROR_STATUS (status);
                     goto finally;
                 }
@@ -425,7 +434,7 @@
                 goto finally;
             }
         }
-        osb->hbt = 50 + jiffies;
+        osb->hbt = OCFS_SCHEDULE_TIMEOUT_JIFFIES + jiffies;
 
 finally:
         status = 0;
@@ -435,7 +444,7 @@
             break;
         j = jiffies;
         if (time_after (j, (unsigned long) (osb->hbt))) {
-            osb->hbt = 50 + j;
+            osb->hbt = OCFS_SCHEDULE_TIMEOUT_JIFFIES + j;
         }
         set_current_state (TASK_INTERRUPTIBLE);
         schedule_timeout (osb->hbt - j);
