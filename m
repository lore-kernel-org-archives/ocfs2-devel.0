From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 14 Jul 2010 22:38:21 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove BUG_ON in a rare case
Message-ID: <201007141440.o6EEeWod016015@rcsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

For migration, we are waiting for DLM_LOCK_RES_MIGRATING flag to be set
before sending DLM_MIG_LOCKRES_MSG message to the target. We are using
dlm_migration_can_proceed() for that purpose. while, dlm_migration_can_proceed()
also returns "go ahead" if target node is down. In this rare case, the
DLM_LOCK_RES_MIGRATING maybe is not set yet. Remove the BUG_ON() in this case.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 4a7506a..94b97fc 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2808,14 +2808,8 @@ again:
 		mlog(0, "trying again...\n");
 		goto again;
 	}
-	/* now that we are sure the MIGRATING state is there, drop
-	 * the unneded state which blocked threads trying to DIRTY */
-	spin_lock(&res->spinlock);
-	BUG_ON(!(res->state & DLM_LOCK_RES_BLOCK_DIRTY));
-	BUG_ON(!(res->state & DLM_LOCK_RES_MIGRATING));
-	res->state &= ~DLM_LOCK_RES_BLOCK_DIRTY;
-	spin_unlock(&res->spinlock);
 
+	ret = 0;
 	/* did the target go down or die? */
 	spin_lock(&dlm->spinlock);
 	if (!test_bit(target, dlm->domain_map)) {
@@ -2826,9 +2820,21 @@ again:
 	spin_unlock(&dlm->spinlock);
 
 	/*
+	 * if target is down, we need to clear DLM_LOCK_RES_BLOCK_DIRTY for
+	 * another try; otherwise, we are sure the MIGRATING state is there,
+	 * drop the unneded state which blocked threads trying to DIRTY
+	 */
+	spin_lock(&res->spinlock);
+	BUG_ON(!(res->state & DLM_LOCK_RES_BLOCK_DIRTY));
+	res->state &= ~DLM_LOCK_RES_BLOCK_DIRTY;
+	if (!ret)
+		BUG_ON(!(res->state & DLM_LOCK_RES_MIGRATING));
+	spin_unlock(&res->spinlock);
+
+	/*
 	 * at this point:
 	 *
-	 *   o the DLM_LOCK_RES_MIGRATING flag is set
+	 *   o the DLM_LOCK_RES_MIGRATING flag is set if target not down
 	 *   o there are no pending asts on this lockres
 	 *   o all processes trying to reserve an ast on this
 	 *     lockres must wait for the MIGRATING flag to clear
-- 
1.6.6.1
