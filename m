From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 25 Feb 2010 15:27:31 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/userdlm: Add tracing in userdlm
In-Reply-To: <1267140451-21243-1-git-send-email-sunil.mushran@oracle.com>
References: <1267140451-21243-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1267140451-21243-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Make use of the newly added BASTS masklog to trace ASTs and BASTs in userdlm.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/userdlm.c |   44 +++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/dlm/userdlm.c b/fs/ocfs2/dlm/userdlm.c
index 01a57c8..d4a16f2 100644
--- a/fs/ocfs2/dlm/userdlm.c
+++ b/fs/ocfs2/dlm/userdlm.c
@@ -127,8 +127,9 @@ static void user_ast(void *opaque)
 	struct user_lock_res *lockres = opaque;
 	struct dlm_lockstatus *lksb;
 
-	mlog(0, "AST fired for lockres %.*s\n", lockres->l_namelen,
-	     lockres->l_name);
+	mlog(ML_BASTS, "AST fired for lockres %.*s, level %d => %d\n",
+	     lockres->l_namelen, lockres->l_name, lockres->l_level,
+	     lockres->l_requested);
 
 	spin_lock(&lockres->l_lock);
 
@@ -214,8 +215,8 @@ static void user_bast(void *opaque, int level)
 {
 	struct user_lock_res *lockres = opaque;
 
-	mlog(0, "Blocking AST fired for lockres %.*s. Blocking level %d\n",
-	     lockres->l_namelen, lockres->l_name, level);
+	mlog(ML_BASTS, "BAST fired for lockres %.*s, blocking %d, level %d\n",
+	     lockres->l_namelen, lockres->l_name, level, lockres->l_level);
 
 	spin_lock(&lockres->l_lock);
 	lockres->l_flags |= USER_LOCK_BLOCKED;
@@ -232,8 +233,8 @@ static void user_unlock_ast(void *opaque, enum dlm_status status)
 {
 	struct user_lock_res *lockres = opaque;
 
-	mlog(0, "UNLOCK AST called on lock %.*s\n", lockres->l_namelen,
-	     lockres->l_name);
+	mlog(ML_BASTS, "UNLOCK AST fired for lockres %.*s, flags 0x%x\n",
+	     lockres->l_namelen, lockres->l_name, lockres->l_flags);
 
 	if (status != DLM_NORMAL && status != DLM_CANCELGRANT)
 		mlog(ML_ERROR, "Dlm returns status %d\n", status);
@@ -286,8 +287,7 @@ static void user_dlm_unblock_lock(kapi_work_struct_t *work)
 		work_to_object(work, struct user_lock_res, l_work);
 	struct dlm_ctxt *dlm = dlm_ctxt_from_user_lockres(lockres);
 
-	mlog(0, "processing lockres %.*s\n", lockres->l_namelen,
-	     lockres->l_name);
+	mlog(0, "lockres %.*s\n", lockres->l_namelen, lockres->l_name);
 
 	spin_lock(&lockres->l_lock);
 
@@ -305,17 +305,23 @@ static void user_dlm_unblock_lock(kapi_work_struct_t *work)
 	 * flag, and finally we might get another bast which re-queues
 	 * us before our ast for the downconvert is called. */
 	if (!(lockres->l_flags & USER_LOCK_BLOCKED)) {
+		mlog(ML_BASTS, "lockres %.*s USER_LOCK_BLOCKED\n",
+		     lockres->l_namelen, lockres->l_name);
 		spin_unlock(&lockres->l_lock);
 		goto drop_ref;
 	}
 
 	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
+		mlog(ML_BASTS, "lockres %.*s USER_LOCK_IN_TEARDOWN\n",
+		     lockres->l_namelen, lockres->l_name);
 		spin_unlock(&lockres->l_lock);
 		goto drop_ref;
 	}
 
 	if (lockres->l_flags & USER_LOCK_BUSY) {
 		if (lockres->l_flags & USER_LOCK_IN_CANCEL) {
+			mlog(ML_BASTS, "lockres %.*s USER_LOCK_IN_CANCEL\n",
+			     lockres->l_namelen, lockres->l_name);
 			spin_unlock(&lockres->l_lock);
 			goto drop_ref;
 		}
@@ -339,16 +345,18 @@ static void user_dlm_unblock_lock(kapi_work_struct_t *work)
 	if ((lockres->l_blocking == LKM_EXMODE)
 	    && (lockres->l_ex_holders || lockres->l_ro_holders)) {
 		spin_unlock(&lockres->l_lock);
-		mlog(0, "can't downconvert for ex: ro = %u, ex = %u\n",
-			lockres->l_ro_holders, lockres->l_ex_holders);
+		mlog(ML_BASTS, "lockres %.*s, EX/PR Holders %u,%u\n",
+		     lockres->l_namelen, lockres->l_name,
+		     lockres->l_ex_holders, lockres->l_ro_holders);
 		goto drop_ref;
 	}
 
 	if ((lockres->l_blocking == LKM_PRMODE)
 	    && lockres->l_ex_holders) {
 		spin_unlock(&lockres->l_lock);
-		mlog(0, "can't downconvert for pr: ex = %u\n",
-			lockres->l_ex_holders);
+		mlog(ML_BASTS, "lockres %.*s, EX Holders %u\n",
+		     lockres->l_namelen, lockres->l_name,
+		     lockres->l_ex_holders);
 		goto drop_ref;
 	}
 
@@ -356,8 +364,8 @@ static void user_dlm_unblock_lock(kapi_work_struct_t *work)
 	new_level = user_highest_compat_lock_level(lockres->l_blocking);
 	lockres->l_requested = new_level;
 	lockres->l_flags |= USER_LOCK_BUSY;
-	mlog(0, "Downconvert lock from %d to %d\n",
-		lockres->l_level, new_level);
+	mlog(ML_BASTS, "lockres %.*s, downconvert %d => %d\n",
+	     lockres->l_namelen, lockres->l_name, lockres->l_level, new_level);
 	spin_unlock(&lockres->l_lock);
 
 	/* need lock downconvert request now... */
@@ -421,10 +429,8 @@ int user_dlm_cluster_lock(struct user_lock_res *lockres,
 		goto bail;
 	}
 
-	mlog(0, "lockres %.*s: asking for %s lock, passed flags = 0x%x\n",
-	     lockres->l_namelen, lockres->l_name,
-	     (level == LKM_EXMODE) ? "LKM_EXMODE" : "LKM_PRMODE",
-	     lkm_flags);
+	mlog(ML_BASTS, "lockres %.*s, level %d, flags = 0x%x\n",
+	     lockres->l_namelen, lockres->l_name, level, lkm_flags);
 
 again:
 	if (signal_pending(current)) {
@@ -595,7 +601,7 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
 	int status = -EBUSY;
 	struct dlm_ctxt *dlm = dlm_ctxt_from_user_lockres(lockres);
 
-	mlog(0, "asked to destroy %.*s\n", lockres->l_namelen, lockres->l_name);
+	mlog(ML_BASTS, "lockres %.*s\n", lockres->l_namelen, lockres->l_name);
 
 	spin_lock(&lockres->l_lock);
 	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
-- 
1.6.3.3
