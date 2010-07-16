From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 16 Jul 2010 23:13:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix a dead lock
Message-ID: <201007161515.o6GFF20K015585@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we have to take both dlm->master_lock and lockres->spinlock,
take them in order

lockres->spinlock and then dlm->master_lock.

The patch fixes a violation of the rule.
We can simply move taking dlm->master_lock to where we have dropped res->spinlock
since when we access res->state and free mle memory we don't need master_lock's
protection.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 94b97fc..6d098b8 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -3050,8 +3050,6 @@ int dlm_migrate_request_handler(struct o2net_msg *msg, u32 len, void *data,
 	/* check for pre-existing lock */
 	spin_lock(&dlm->spinlock);
 	res = __dlm_lookup_lockres(dlm, name, namelen, hash);
-	spin_lock(&dlm->master_lock);
-
 	if (res) {
 		spin_lock(&res->spinlock);
 		if (res->state & DLM_LOCK_RES_RECOVERING) {
@@ -3069,14 +3067,15 @@ int dlm_migrate_request_handler(struct o2net_msg *msg, u32 len, void *data,
 		spin_unlock(&res->spinlock);
 	}
 
+	spin_lock(&dlm->master_lock);
 	/* ignore status.  only nonzero status would BUG. */
 	ret = dlm_add_migration_mle(dlm, res, mle, &oldmle,
 				    name, namelen,
 				    migrate->new_master,
 				    migrate->master);
 
-unlock:
 	spin_unlock(&dlm->master_lock);
+unlock:
 	spin_unlock(&dlm->spinlock);
 
 	if (oldmle) {
-- 
1.6.6.1
