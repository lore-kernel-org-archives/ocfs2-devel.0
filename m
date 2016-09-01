From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 1 Sep 2016 11:15:39 +0000
Subject: [Ocfs2-devel] MLE process bugs and its patch for review.
Message-ID: <71604351584F6A4EBAE558C676F37CA4A3D3226D@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, All

In the function dlm_migrate_lockres, as the return value is -EEXIST, the mle should not be added because it had not been initialized. And the oldmle should be put.
Same as in function dlm_migrate_request_handler, when the return val is -EEIST, the mle should cache freed, otherwise memory lead may be occurred.


*** ocfs2.org/dlm/dlmmaster.c   2016-09-01 15:46:16.163140295 +0800
--- ocfs2/dlm/dlmmaster.c       2016-09-01 18:56:21.211442107 +0800
*************** static int dlm_is_lockres_migrateable(st
*** 2592,2599 ****
  /*
   * DLM_MIGRATE_LOCKRES
   */
-
-
  static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
                               struct dlm_lock_resource *res, u8 target)
  {
--- 2592,2597 ----
*************** static int dlm_migrate_lockres(struct dl
*** 2640,2645 ****
--- 2638,2654 ----
        spin_lock(&dlm->master_lock);
        ret = dlm_add_migration_mle(dlm, res, mle, &oldmle, name,
                                    namelen, target, dlm->node_num);
+
+       if (ret == -EEXIST) {
+               if(oldmle)
+                       dlm_put_mle(oldmle);
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
*************** static int dlm_migrate_lockres(struct dl
*** 2648,2657 ****
        spin_unlock(&dlm->master_lock);
        spin_unlock(&dlm->spinlock);

-       if (ret == -EEXIST) {
-               mlog(0, "another process is already migrating it\n");
-               goto fail;
-       }
        mle_added = 1;

        /*
--- 2657,2662 ----
*************** int dlm_migrate_request_handler(struct o
*** 3206,3211 ****
--- 3211,3218 ----
                                    name, namelen,
                                    migrate->new_master,
                                    migrate->master);
+       if (ret < 0)
+               kmem_cache_free(dlm_mle_cache, mle);

        spin_unlock(&dlm->master_lock);
  unlock:
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
