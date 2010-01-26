From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 25 Jan 2010 16:57:39 -0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2/dlm: Ignore LVBs of locks in the
	Blocked list
In-Reply-To: <1264467461-1881-1-git-send-email-sunil.mushran@oracle.com>
References: <1264467461-1881-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1264467461-1881-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During lock resource migration, o2dlm fills the packet with a LVB from the
first valid lock. For sanity, it ensures that the other valid locks have the
same LVB. If not, it BUGs.

The valid locks are ones that have granted EX or PR lock levels and are either
on the Granted or Converting lists. Locks in the Blocked list cannot have a
valid LVB.

This patch ensures that we skip the locks in the Blocked list.

Fixes oss bugzilla#1202
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1202

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   48 +++++++++++++++++++++++++++++++------------
 1 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 57736d3..9d67894 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1164,6 +1164,39 @@ static void dlm_init_migratable_lockres(struct dlm_migratable_lockres *mres,
 	mres->master = master;
 }
 
+static void dlm_prepare_lvb_for_migration(struct dlm_lock *lock,
+					  struct dlm_migratable_lockres *mres,
+					  int queue)
+{
+	if (!lock->lksb)
+	       return;
+
+	/* Ignore lvb in all locks in the blocked list */
+	if (queue == DLM_BLOCKED_LIST)
+		return;
+
+	/* Only consider lvbs in locks with granted EX or PR lock levels */
+	if (lock->ml.type != LKM_EXMODE && lock->ml.type != LKM_PRMODE)
+		return;
+
+	if (dlm_lvb_is_empty(mres->lvb)) {
+		memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
+		return;
+	}
+
+	/* Ensure the lvb copied for migration matches in other valid locks */
+	if (!memcmp(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN))
+		return;
+
+	mlog(ML_ERROR, "Mismatched lvb in lock cookie=%u:%llu, name=%.*s, "
+	     "node=%u\n",
+	     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
+	     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
+	     lock->lockres->lockname.len, lock->lockres->lockname.name,
+	     lock->ml.node);
+	dlm_print_one_lock_resource(lock->lockres);
+	BUG();
+}
 
 /* returns 1 if this lock fills the network structure,
  * 0 otherwise */
@@ -1181,20 +1214,7 @@ static int dlm_add_lock_to_array(struct dlm_lock *lock,
 	ml->list = queue;
 	if (lock->lksb) {
 		ml->flags = lock->lksb->flags;
-		/* send our current lvb */
-		if (ml->type == LKM_EXMODE ||
-		    ml->type == LKM_PRMODE) {
-			/* if it is already set, this had better be a PR
-			 * and it has to match */
-			if (!dlm_lvb_is_empty(mres->lvb) &&
-			    (ml->type == LKM_EXMODE ||
-			     memcmp(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN))) {
-				mlog(ML_ERROR, "mismatched lvbs!\n");
-				dlm_print_one_lock_resource(lock->lockres);
-				BUG();
-			}
-			memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
-		}
+		dlm_prepare_lvb_for_migration(lock, mres, queue);
 	}
 	ml->node = lock->ml.node;
 	mres->num_locks++;
-- 
1.5.6.5
