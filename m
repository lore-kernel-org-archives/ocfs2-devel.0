From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 14 Sep 2016 02:30:44 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: oldmle should be put while -EEXIST
 returned, and the new mle should not be get once at that time.
Message-ID: <71604351584F6A4EBAE558C676F37CA4A3D35566@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


In the function dlm_migrate_lockres, while calling dlm_add_migration_mle, and the ret is --EEXIST.
At this time, the oldmle should be put one time for it had been get once in dlm_find_mle.
And the new mle should not get once for it had not been initialized before goto fail.

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>

--- ocfs2.orig/dlm/dlmmaster.c  2016-09-13 15:18:13.602684325 +0800
+++ ocfs2/dlm/dlmmaster.c       2016-09-14 10:15:10.496873879 +0800
@@ -2573,8 +2573,6 @@ static int dlm_is_lockres_migrateable(st
 /*
  * DLM_MIGRATE_LOCKRES
  */
-
-
 static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
                               struct dlm_lock_resource *res, u8 target)
 {
@@ -2621,20 +2619,26 @@ static int dlm_migrate_lockres(struct dl
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
