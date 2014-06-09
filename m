From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 09 Jun 2014 13:04:06 -0700
Subject: [Ocfs2-devel] [patch 7/8] ocfs2: do not return
	DLM_MIGRATE_RESPONSE_MASTERY_REF to avoid endless,
	loop during umount
Message-ID: <20140609200406.E45385A4A39@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: do not return DLM_MIGRATE_RESPONSE_MASTERY_REF to avoid endless,loop during umount

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

[akpm at linux-foundation.org: coding-style fixes]
Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Xue jiufei <xuejiufei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -3088,11 +3088,15 @@ static int dlm_add_migration_mle(struct
 			/* remove it so that only one mle will be found */
 			__dlm_unlink_mle(dlm, tmp);
 			__dlm_mle_detach_hb_events(dlm, tmp);
-			ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
-			mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
-			    "telling master to get ref for cleared out mle "
-			    "during migration\n", dlm->name, namelen, name,
-			    master, new_master);
+			if (tmp->type == DLM_MLE_MASTER) {
+				ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
+				mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
+						"telling master to get ref "
+						"for cleared out mle during "
+						"migration\n", dlm->name,
+						namelen, name, master,
+						new_master);
+			}
 		}
 		spin_unlock(&tmp->spinlock);
 	}
_
