From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 3 Apr 2018 13:42:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clean up unused variable in
	dlm_process_recovery_data
Message-ID: <1522734135-7933-1-git-send-email-ge.changwei@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index ec8f758..be6b067 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1807,7 +1807,6 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 	int i, j, bad;
 	struct dlm_lock *lock;
 	u8 from = O2NM_MAX_NODES;
-	unsigned int added = 0;
 	__be64 c;
 
 	mlog(0, "running %d locks for this lockres\n", mres->num_locks);
@@ -1823,7 +1822,6 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			spin_lock(&res->spinlock);
 			dlm_lockres_set_refmap_bit(dlm, res, from);
 			spin_unlock(&res->spinlock);
-			added++;
 			break;
 		}
 		BUG_ON(ml->highest_blocked != LKM_IVMODE);
@@ -1911,7 +1909,6 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			/* do not alter lock refcount.  switching lists. */
 			list_move_tail(&lock->list, queue);
 			spin_unlock(&res->spinlock);
-			added++;
 
 			mlog(0, "just reordered a local lock!\n");
 			continue;
@@ -2037,7 +2034,6 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			     "setting refmap bit\n", dlm->name,
 			     res->lockname.len, res->lockname.name, ml->node);
 			dlm_lockres_set_refmap_bit(dlm, res, ml->node);
-			added++;
 		}
 		spin_unlock(&res->spinlock);
 	}
-- 
2.7.4
