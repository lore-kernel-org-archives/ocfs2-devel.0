From: Guozhonghua <guozhonghua@h3c.com>
Date: Mon, 28 Nov 2016 09:05:03 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Optimization of code while free dead
 locks, changed for reviews.
Message-ID: <71604351584F6A4EBAE558C676F37CA4C4AE05D3@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Changed the free order and code styles with reviews. Based on Linux-4.9-rc6. Thanks.

Signed-off-by: guozhonghua <guozhonghua@h3c.com>

diff -uprN ocfs2.orig/dlm/dlmrecovery.c ocfs2/dlm/dlmrecovery.c
--- ocfs2.orig/dlm/dlmrecovery.c        2016-11-28 16:26:45.890934481 +0800
+++ ocfs2/dlm/dlmrecovery.c     2016-11-28 16:32:04.982940629 +0800
@@ -2268,6 +2268,9 @@ static void dlm_free_dead_locks(struct d
 {
        struct dlm_lock *lock, *next;
        unsigned int freed = 0;
+       struct list_head *queue = NULL;
+       int i;
+

        /* this node is the lockres master:
         * 1) remove any stale locks for the dead node
@@ -2280,33 +2283,19 @@ static void dlm_free_dead_locks(struct d
         * to force the DLM_UNLOCK_FREE_LOCK action so as to free the locks */

        /* TODO: check pending_asts, pending_basts here */
-       list_for_each_entry_safe(lock, next, &res->granted, list) {
-               if (lock->ml.node == dead_node) {
-                       list_del_init(&lock->list);
-                       dlm_lock_put(lock);
-                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
-                       dlm_lock_put(lock);
-                       freed++;
-               }
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
+       for (i = DLM_GRANTED_LIST; i <= DLM_BLOCKED_LIST; i++) {
+               queue = dlm_list_idx_to_ptr(res, i);
+               list_for_each_entry_safe(lock, next, queue, list) {
+                       if (lock->ml.node == dead_node) {
+                               list_del_init(&lock->list);
+                               dlm_lock_put(lock);
+
+                               /* Can't schedule DLM_UNLOCK_FREE_LOCK
+                                * - do manually
+                                */
+                               dlm_lock_put(lock);
+                               freed++;
+                       }
+               }
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
