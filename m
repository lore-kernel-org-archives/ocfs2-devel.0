From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 26 Feb 2010 19:42:45 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/userdlm: Add tracing in userdlm
In-Reply-To: <1267242165-30474-1-git-send-email-sunil.mushran@oracle.com>
References: <1267242165-30474-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1267242165-30474-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Make use of the newly added BASTS masklog to trace ASTs and BASTs in userdlm.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmfs/userdlm.c |   44 +++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
index 2858ee6..0499e3f 100644
--- a/fs/ocfs2/dlmfs/userdlm.c
+++ b/fs/ocfs2/dlmfs/userdlm.c
@@ -128,8 +128,9 @@ static void user_ast(struct ocfs2_dlm_lksb *lksb)
 	struct user_lock_res *lockres = user_lksb_to_lock_res(lksb);
 	int status;
 
-	mlog(0, "AST fired for lockres %.*s\n", lockres->l_namelen,
-	     lockres->l_name);
+	mlog(ML_BASTS, "AST fired for lockres %.*s, level %d => %d\n",
+	     lockres->l_namelen, lockres->l_name, lockres->l_level,
+	     lockres->l_requested);
 
 	spin_lock(&lockres->l_lock);
 
@@ -214,8 +215,8 @@ static void user_bast(struct ocfs2_dlm_lksb *lksb, int level)
 {
 	struct user_lock_res *lockres = user_lksb_to_lock_res(lksb);
 
-	mlog(0, "Blocking AST fired for lockres %.*s. Blocking level %d\n",
-	     lockres->l_namelen, lockres->l_name, level);
+	mlog(ML_BASTS, "BAST fired for lockres %.*s, blocking %d, level %d\n",
+	     lockres->l_namelen, lockres->l_name, level, lockres->l_level);
 
 	spin_lock(&lockres->l_lock);
 	lockres->l_flags |= USER_LOCK_BLOCKED;
@@ -232,8 +233,8 @@ static void user_unlock_ast(struct ocfs2_dlm_lksb *lksb, int status)
 {
 	struct user_lock_res *lockres = user_lksb_to_lock_res(lksb);
 
-	mlog(0, "UNLOCK AST called on lock %.*s\n", lockres->l_namelen,
-	     lockres->l_name);
+	mlog(ML_BASTS, "UNLOCK AST fired for lockres %.*s, flags 0x%x\n",
+	     lockres->l_namelen, lockres->l_name, lockres->l_flags);
 
 	if (status)
 		mlog(ML_ERROR, "dlm returns status %d\n", status);
@@ -302,8 +303,7 @@ static void user_dlm_unblock_lock(struct work_struct *work)
 	struct ocfs2_cluster_connection *conn =
 		cluster_connection_from_user_lockres(lockres);
 
-	mlog(0, "processing lockres %.*s\n", lockres->l_namelen,
-	     lockres->l_name);
+	mlog(0, "lockres %.*s\n", lockres->l_namelen, lockres->l_name);
 
 	spin_lock(&lockres->l_lock);
 
@@ -321,17 +321,23 @@ static void user_dlm_unblock_lock(struct work_struct *work)
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
@@ -352,16 +358,18 @@ static void user_dlm_unblock_lock(struct work_struct *work)
 	if ((lockres->l_blocking == DLM_LOCK_EX)
 	    && (lockres->l_ex_holders || lockres->l_ro_holders)) {
 		spin_unlock(&lockres->l_lock);
-		mlog(0, "can't downconvert for ex: ro = %u, ex = %u\n",
-			lockres->l_ro_holders, lockres->l_ex_holders);
+		mlog(ML_BASTS, "lockres %.*s, EX/PR Holders %u,%u\n",
+		     lockres->l_namelen, lockres->l_name,
+		     lockres->l_ex_holders, lockres->l_ro_holders);
 		goto drop_ref;
 	}
 
 	if ((lockres->l_blocking == DLM_LOCK_PR)
 	    && lockres->l_ex_holders) {
 		spin_unlock(&lockres->l_lock);
-		mlog(0, "can't downconvert for pr: ex = %u\n",
-			lockres->l_ex_holders);
+		mlog(ML_BASTS, "lockres %.*s, EX Holders %u\n",
+		     lockres->l_namelen, lockres->l_name,
+		     lockres->l_ex_holders);
 		goto drop_ref;
 	}
 
@@ -369,8 +377,8 @@ static void user_dlm_unblock_lock(struct work_struct *work)
 	new_level = user_highest_compat_lock_level(lockres->l_blocking);
 	lockres->l_requested = new_level;
 	lockres->l_flags |= USER_LOCK_BUSY;
-	mlog(0, "Downconvert lock from %d to %d\n",
-		lockres->l_level, new_level);
+	mlog(ML_BASTS, "lockres %.*s, downconvert %d => %d\n",
+	     lockres->l_namelen, lockres->l_name, lockres->l_level, new_level);
 	spin_unlock(&lockres->l_lock);
 
 	/* need lock downconvert request now... */
@@ -430,10 +438,8 @@ int user_dlm_cluster_lock(struct user_lock_res *lockres,
 		goto bail;
 	}
 
-	mlog(0, "lockres %.*s: asking for %s lock, passed flags = 0x%x\n",
-	     lockres->l_namelen, lockres->l_name,
-	     (level == DLM_LOCK_EX) ? "DLM_LOCK_EX" : "DLM_LOCK_PR",
-	     lkm_flags);
+	mlog(ML_BASTS, "lockres %.*s, level %d, flags = 0x%x\n",
+	     lockres->l_namelen, lockres->l_name, level, lkm_flags);
 
 again:
 	if (signal_pending(current)) {
@@ -603,7 +609,7 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
 	struct ocfs2_cluster_connection *conn =
 		cluster_connection_from_user_lockres(lockres);
 
-	mlog(0, "asked to destroy %.*s\n", lockres->l_namelen, lockres->l_name);
+	mlog(ML_BASTS, "lockres %.*s\n", lockres->l_namelen, lockres->l_name);
 
 	spin_lock(&lockres->l_lock);
 	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
-- 
1.6.3.3
