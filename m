From: xuejiufei <xuejiufei@huawei.com>
Date: Fri, 25 Dec 2015 16:34:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: do not insert a new mle when
 another process is already migrating
Message-ID: <567CFF92.3060105@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When two processes are migrating the same lockres,
dlm_add_migration_mle() return -EEXIST, but insert a new mle in
hash list. Function dlm_migrate_lockres will detach the ole mle
and free the new one which is already in hash list, that will
destroy the list.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 936e11b..753dd9c 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2544,7 +2544,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 	}

 fail:
-	if (oldmle) {
+	if (ret != -EEXIST && oldmle) {
 		/* master is known, detach if not already detached */
 		dlm_mle_detach_hb_events(dlm, oldmle);
 		dlm_put_mle(oldmle);
@@ -3141,7 +3141,8 @@ static int dlm_add_migration_mle(struct dlm_ctxt *dlm,
 				mlog(0, "tried to migrate %.*s, but some "
 				     "process beat me to it\n",
 				     namelen, name);
-				ret = -EEXIST;
+				spin_unlock(&tmp->spinlock);
+				return -EEXIST;
 			} else {
 				/* bad.  2 NODES are trying to migrate! */
 				mlog(ML_ERROR, "migration error  mle: "
-- 
1.8.4.3
