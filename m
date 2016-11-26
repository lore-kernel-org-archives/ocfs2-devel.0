From: Guozhonghua <guozhonghua@h3c.com>
Date: Sat, 26 Nov 2016 12:15:54 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Optimization of code while free dead
	locks.
Message-ID: <71604351584F6A4EBAE558C676F37CA4C4AE0278@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


The three loops can be optimized into one loop and its sub loops, so as small code can do the same work.
The patch is based on the linux-4.9-rc6.

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>


--- ocfs2.orig/dlm/dlmrecovery.c        2016-11-26 19:13:04.833023242 +0800
+++ ocfs2/dlm/dlmrecovery.c     2016-11-26 19:24:03.982552497 +0800
@@ -2268,6 +2268,8 @@ static void dlm_free_dead_locks(struct d
 {
        struct dlm_lock *lock, *next;
        unsigned int freed = 0;
+       struct list_head *queue = NULL;
+       int i;

        /* this node is the lockres master:
         * 1) remove any stale locks for the dead node
@@ -2280,33 +2282,19 @@ static void dlm_free_dead_locks(struct d
         * to force the DLM_UNLOCK_FREE_LOCK action so as to free the locks */

        /* TODO: check pending_asts, pending_basts here */
-       list_for_each_entry_safe(lock, next, &res->granted, list) {
-               if (lock->ml.node == dead_node) {
-                       list_del_init(&lock->list);
-                       dlm_lock_put(lock);
-                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
-                       dlm_lock_put(lock);
-                       freed++;
+       for (i = DLM_BLOCKED_LIST; i >= DLM_GRANTED_LIST; i--) {
+               queue = dlm_list_idx_to_ptr(res, i);
+               list_for_each_entry_safe(lock, next, queue, list) {
+                       if (lock->ml.node == dead_node) {
+                               list_del_init(&lock->list);
+                               dlm_lock_put(lock);
+
+                               /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
+                               dlm_lock_put(lock);
+                               freed++;
+                       }
                }
-       }
-       list_for_each_entry_safe(lock, next, &res->converting, list) {
-               if (lock->ml.node == dead_node) {
-                       list_del_init(&lock->list);
-                       dlm_lock_put(lock);
-                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
-                       dlm_lock_put(lock);
-                       freed++;
-               }
-       }
-       list_for_each_entry_safe(lock, next, &res->blocked, list) {
-               if (lock->ml.node == dead_node) {
-                       list_del_init(&lock->list);
-                       dlm_lock_put(lock);
-                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
-                       dlm_lock_put(lock);
-                       freed++;
-               }
-       }
+       }

        if (freed) {
                mlog(0, "%s:%.*s: freed %u locks for dead node %u, "

-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
