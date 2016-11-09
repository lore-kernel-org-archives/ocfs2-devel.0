From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 9 Nov 2016 00:29:17 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: old mle put and release after the
 function dlm_add_migration_mle called.
Message-ID: <71604351584F6A4EBAE558C676F37CA4A3D4B7FE@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


If the old mle is found after the dlm_add_migration_mle called, it should be put once.
If the return value is not - EEXIST and its type is BLOCK, it should be put again to release it to avoid memory leak, for it had been unhashed from the map.

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>

--- ocfs2.orig/dlm/dlmmaster.c  2016-11-08 16:58:30.233592715 +0800
+++ ocfs2/dlm/dlmmaster.c       2016-11-08 17:37:00.157673017 +0800
@@ -2621,20 +2621,45 @@ static int dlm_migrate_lockres(struct dl
        spin_lock(&dlm->master_lock);
        ret = dlm_add_migration_mle(dlm, res, mle, &oldmle, name,
                                    namelen, target, dlm->node_num);
+       if (ret == -EEXIST) {
+               if(oldmle)
+                       __dlm_put_mle(oldmle);
+
+               spin_unlock(&dlm->master_lock);
+               spin_unlock(&dlm->spinlock);
+               mlog(0, "another process is already migrating it\n");
+               goto fail;
+       }
+
+       /* If an old one mle found, it should be put. if its type is BLOCK,
+        * it should be put again. Because it had been unhasded from the map
+        * in the function dlm_add_migration_mle.
+        * otherwise the memory will be leaked. It will not found it again from
+        * the hash map.
+        */
+       if (oldmle) {
+               /* master is known, detach if not already detached */
+               __dlm_mle_detach_hb_events(dlm, oldmle);
+               __dlm_put_mle(oldmle);
+
+               /* if the type of the mle is BLOCK, should put it once for release.
+                * otherwise memory leak may be caused because oldmle had been unhashed
+                * from the hash map, it will not be found anymore.
+                */
+               if (oldmle->type == DLM_MLE_BLOCK)
+                       __dlm_put_mle(oldmle);
+       }
+
        /* get an extra reference on the mle.
         * otherwise the assert_master from the new
         * master will destroy this.
         */
        dlm_get_mle_inuse(mle);
+       mle_added = 1;
+
        spin_unlock(&dlm->master_lock);
        spin_unlock(&dlm->spinlock);

-       if (ret == -EEXIST) {
-               mlog(0, "another process is already migrating it\n");
-               goto fail;
-       }
-       mle_added = 1;
-
        /*
         * set the MIGRATING flag and flush asts
         * if we fail after this we need to re-dirty the lockres
@@ -2651,12 +2676,6 @@ static int dlm_migrate_lockres(struct dl
        }

 fail:
-       if (ret != -EEXIST && oldmle) {
-               /* master is known, detach if not already detached */
-               dlm_mle_detach_hb_events(dlm, oldmle);
-               dlm_put_mle(oldmle);
-       }
-
        if (ret < 0) {
                if (mle_added) {
                        dlm_mle_detach_hb_events(dlm, mle);
@@ -3191,16 +3210,23 @@ int dlm_migrate_request_handler(struct o
        if (ret < 0)
                kmem_cache_free(dlm_mle_cache, mle);

+       /* If an old one mle found, it should be put. if its type is BLOCK,
+        * it should be put again. Because it had been unhasded from the map
+        * in the function dlm_add_migration_mle.
+        * otherwise the memory will be leaked. It will not found it again from
+        * the hash map.
+        */
+       if (oldmle) {
+               __dlm_mle_detach_hb_events(dlm, oldmle);
+               __dlm_put_mle(oldmle);
+               if (ret >= 0 && oldmle->type == DLM_MLE_BLOCK)
+                       __dlm_put_mle(oldmle);
+       }
+
        spin_unlock(&dlm->master_lock);
 unlock:
        spin_unlock(&dlm->spinlock);

-       if (oldmle) {
-               /* master is known, detach if not already detached */
-               dlm_mle_detach_hb_events(dlm, oldmle);
-               dlm_put_mle(oldmle);
-       }
-
        if (res)
                dlm_lockres_put(res);
 leave:
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
