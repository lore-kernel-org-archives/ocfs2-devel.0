From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Thu, 20 Aug 2009 13:43:19 -0500
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Wait on lockres instead of
	erroring cancel requests
Message-ID: <241c7a2b0908201143i3e9add05t87e2422465bc13b1@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In case a downconvert is queued, and a flock receives a signal,
BUG_ON(lockres->l_action != OCFS2_AST_INVALID) is triggered
because a lock cancel triggers a dlmunlock while an AST is
scheduled.

To avoid this, allow a LKM_CANCEL to pass through, and let it
wait on __dlm_wait_on_lockres().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index fcf879e..756f5b0 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -122,7 +122,7 @@ static enum dlm_status dlmunlock_common(struct
dlm_ctxt *dlm,
 	 * that still has AST's pending... */
 	in_use = !list_empty(&lock->ast_list);
 	spin_unlock(&dlm->ast_lock);
-	if (in_use) {
+	if (in_use && !(flags & LKM_CANCEL)) {
 	       mlog(ML_ERROR, "lockres %.*s: Someone is calling dlmunlock "
 		    "while waiting for an ast!", res->lockname.len,
 		    res->lockname.name);
@@ -131,7 +131,7 @@ static enum dlm_status dlmunlock_common(struct
dlm_ctxt *dlm,

 	spin_lock(&res->spinlock);
 	if (res->state & DLM_LOCK_RES_IN_PROGRESS) {
-		if (master_node) {
+		if (master_node && !(flags & LKM_CANCEL)) {
 			mlog(ML_ERROR, "lockres in progress!\n");
 			spin_unlock(&res->spinlock);
 			return DLM_FORWARD;
