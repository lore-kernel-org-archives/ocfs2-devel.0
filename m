From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Jun 29 00:14:13 2004
Subject: [Ocfs2-devel] [Patch]  fix long delay  for first mount after reboot
Message-ID: <3ACA40606221794F80A5670F0AF15F8404BDFC8B@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


By print the jiffies in ocfs_volumn_thread() at first mount after
reboot, it is negative.(such as -253239)
so time_after(jiffies, 0) return false.  (because  ((long)(b) -
(long)(a) < 0) is true)
so first time, it goto finally.

-               if (!time_after (jiffies, (unsigned long) (osb->hbt)))
-                       goto finally;
then osb->hbt - j = 0 - jiffies = 0 - (-253239) = 253239
-  schedule_timeout (osb->hbt - j) will sleep about 253 seconds. 


The follows is a simple fix instead of fixing time_after.

Index: nm.c
===================================================================
--- nm.c    (revision 1217)
+++ nm.c    (working copy)
@@ -279,6 +279,7 @@

    osb->dlm_task = current;

+   osb->hbt = OCFS_HEARTBEAT_JIFFIES + jiffies;
    /* The delay changes based on multiplier */
    while (!(OcfsGlobalCtxt.flags & OCFS_FLAG_SHUTDOWN_VOL_THREAD) &&
           !(osb->osb_flags & OCFS_OSB_FLAGS_BEING_DISMOUNTED)) {
