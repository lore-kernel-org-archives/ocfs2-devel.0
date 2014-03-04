From: jiangyiwen <jiangyiwen@huawei.com>
Date: Tue, 4 Mar 2014 19:34:20 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: do not return
 DLM_MIGRATE_RESPONSE_MASTERY_REF to avoid endless, loop during umount
Message-ID: <5315BA3C.6040106@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following case may lead to endless loop during umount.

node A         node B               node C       node D
umount volume,
migrate lockres1
to B
                                                 want to lock lockres1,
                                                 send
                                                 MASTER_REQUEST_MSG
                                                 to C
                                    init block mle
               send
               MIGRATE_REQUEST_MSG
               to C
                                    find a block
                                    mle, and then
                                    return
                                    DLM_MIGRATE_RESPONSE_MASTERY_REF
                                    to B
               set C in refmap
                                    umount successfully
               try to umount, endless
               loop occurs when migrate
               lockres1 since C is in
               refmap

So we can fix this endless loop case by only returning
DLM_MIGRATE_RESPONSE_MASTERY_REF if it has a mastery mle when receiving
MIGRATE_REQUEST_MSG.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index af3f7aa..1b11a47 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -3084,11 +3084,15 @@ static int dlm_add_migration_mle(struct dlm_ctxt *dlm,
                        /* remove it so that only one mle will be found */
                        __dlm_unlink_mle(dlm, tmp);
                        __dlm_mle_detach_hb_events(dlm, tmp);
-                       ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
-                       mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
-                           "telling master to get ref for cleared out mle "
-                           "during migration\n", dlm->name, namelen, name,
-                           master, new_master);
+                       if (tmp->type == DLM_MLE_MASTER) {
+                               ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
+                               mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
+                                               "telling master to get ref "
+                                               "for cleared out mle during "
+                                               "migration\n", dlm->name,
+                                               namelen, name, master,
+                                               new_master);
+                       }
                }
                spin_unlock(&tmp->spinlock);
        }
--
1.8.4.3
