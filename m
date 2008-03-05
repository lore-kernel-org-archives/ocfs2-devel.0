From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 16:28:24 2008
Subject: [Ocfs2-devel] [PATCH 03/18] ocfs2: Use -errno instead of dlm_status
	for ocfs2_dlm_lock/unlock() API.
In-Reply-To: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
References: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204763261-28025-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mark.fasheh@oracle.com

Change the ocfs2_dlm_lock/unlock() functions to return -errno values.
This is the first step towards elminiating dlm_status in
fs/ocfs2/dlmglue.c.  The change also passes -errno values to
->unlock_ast().

[ Fix a return code in dlmglue.c and change the error translation table into
  an array of ints. --Mark ]

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c   |  116 ++++++++++++++++++-----------------------
 fs/ocfs2/stackglue.c |  142 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/stackglue.h |    6 +-
 3 files changed, 188 insertions(+), 76 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 5806d53..12a5213 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -329,10 +329,9 @@ static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
 					struct ocfs2_lock_res *lockres);
 static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 						int convert);
-#define ocfs2_log_dlm_error(_func, _stat, _lockres) do {	\
-	mlog(ML_ERROR, "Dlm error \"%s\" while calling %s on "	\
-		"resource %s: %s\n", dlm_errname(_stat), _func,	\
-		_lockres->l_name, dlm_errmsg(_stat));		\
+#define ocfs2_log_dlm_error(_func, _err, _lockres) do {			\
+	mlog(ML_ERROR, "DLM error %d while calling %s on resource %s\n", \
+	     _err, _func, _lockres->l_name);				\
 } while (0)
 static int ocfs2_downconvert_thread(void *arg);
 static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
@@ -867,7 +866,6 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 			     u32 dlm_flags)
 {
 	int ret = 0;
-	enum dlm_status status = DLM_NORMAL;
 	unsigned long flags;
 
 	mlog_entry_void();
@@ -887,21 +885,19 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 	lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
-	status = ocfs2_dlm_lock(osb->dlm,
-				level,
-				&lockres->l_lksb,
-				dlm_flags,
-				lockres->l_name,
-				OCFS2_LOCK_ID_MAX_LEN - 1,
-				lockres);
-	if (status != DLM_NORMAL) {
-		ocfs2_log_dlm_error("ocfs2_dlm_lock", status, lockres);
-		ret = -EINVAL;
+	ret = ocfs2_dlm_lock(osb->dlm,
+			     level,
+			     &lockres->l_lksb,
+			     dlm_flags,
+			     lockres->l_name,
+			     OCFS2_LOCK_ID_MAX_LEN - 1,
+			     lockres);
+	if (ret) {
+		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
 		ocfs2_recover_from_dlm_error(lockres, 1);
 	}
 
-	mlog(0, "lock %s, successfull return from ocfs2_dlm_lock\n",
-	     lockres->l_name);
+	mlog(0, "lock %s, return from ocfs2_dlm_lock\n", lockres->l_name);
 
 bail:
 	mlog_exit(ret);
@@ -1018,7 +1014,6 @@ static int ocfs2_cluster_lock(struct ocfs2_super *osb,
 			      int arg_flags)
 {
 	struct ocfs2_mask_waiter mw;
-	enum dlm_status status;
 	int wait, catch_signals = !(osb->s_mount_opt & OCFS2_MOUNT_NOINTR);
 	int ret = 0; /* gcc doesn't realize wait = 1 guarantees ret is set */
 	unsigned long flags;
@@ -1089,21 +1084,18 @@ again:
 		     lockres->l_name, lockres->l_level, level);
 
 		/* call dlm_lock to upgrade lock now */
-		status = ocfs2_dlm_lock(osb->dlm,
-					level,
-					&lockres->l_lksb,
-					lkm_flags,
-					lockres->l_name,
-					OCFS2_LOCK_ID_MAX_LEN - 1,
-					lockres);
-		if (status != DLM_NORMAL) {
-			if ((lkm_flags & DLM_LKF_NOQUEUE) &&
-			    (status == DLM_NOTQUEUED))
-				ret = -EAGAIN;
-			else {
+		ret = ocfs2_dlm_lock(osb->dlm,
+				     level,
+				     &lockres->l_lksb,
+				     lkm_flags,
+				     lockres->l_name,
+				     OCFS2_LOCK_ID_MAX_LEN - 1,
+				     lockres);
+		if (ret) {
+			if (!(lkm_flags & DLM_LKF_NOQUEUE) ||
+			    (ret != -EAGAIN)) {
 				ocfs2_log_dlm_error("ocfs2_dlm_lock",
-						    status, lockres);
-				ret = -EINVAL;
+						    ret, lockres);
 			}
 			ocfs2_recover_from_dlm_error(lockres, 1);
 			goto out;
@@ -1502,10 +1494,8 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 	ret = ocfs2_dlm_lock(osb->dlm, level, &lockres->l_lksb, lkm_flags,
 			     lockres->l_name, OCFS2_LOCK_ID_MAX_LEN - 1,
 			     lockres);
-	if (ret != DLM_NORMAL) {
-		if (trylock && ret == DLM_NOTQUEUED)
-			ret = -EAGAIN;
-		else {
+	if (ret) {
+		if (!trylock || (ret != -EAGAIN)) {
 			ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
 			ret = -EINVAL;
 		}
@@ -2573,7 +2563,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb)
 	mlog_exit_void();
 }
 
-static void ocfs2_unlock_ast(void *opaque, enum dlm_status status)
+static void ocfs2_unlock_ast(void *opaque, int error)
 {
 	struct ocfs2_lock_res *lockres = opaque;
 	unsigned long flags;
@@ -2589,7 +2579,7 @@ static void ocfs2_unlock_ast(void *opaque, enum dlm_status status)
 	 * state. The wake_up call done at the bottom is redundant
 	 * (ocfs2_prepare_cancel_convert doesn't sleep on this) but doesn't
 	 * hurt anything anyway */
-	if (status == DLM_CANCELGRANT &&
+	if (error == -DLM_ECANCEL &&
 	    lockres->l_unlock_action == OCFS2_UNLOCK_CANCEL_CONVERT) {
 		mlog(0, "Got cancelgrant for %s\n", lockres->l_name);
 
@@ -2599,9 +2589,10 @@ static void ocfs2_unlock_ast(void *opaque, enum dlm_status status)
 		goto complete_unlock;
 	}
 
-	if (status != DLM_NORMAL) {
-		mlog(ML_ERROR, "Dlm passes status %d for lock %s, "
-		     "unlock_action %d\n", status, lockres->l_name,
+	/* DLM_EUNLOCK is the success code for unlock */
+	if (error != -DLM_EUNLOCK) {
+		mlog(ML_ERROR, "Dlm passes error %d for lock %s, "
+		     "unlock_action %d\n", error, lockres->l_name,
 		     lockres->l_unlock_action);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
 		return;
@@ -2632,7 +2623,7 @@ complete_unlock:
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
 			   struct ocfs2_lock_res *lockres)
 {
-	enum dlm_status status;
+	int ret;
 	unsigned long flags;
 	u32 lkm_flags = 0;
 
@@ -2696,10 +2687,10 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 
 	mlog(0, "lock %s\n", lockres->l_name);
 
-	status = ocfs2_dlm_unlock(osb->dlm, &lockres->l_lksb, lkm_flags,
-				  lockres);
-	if (status != DLM_NORMAL) {
-		ocfs2_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
+	ret = ocfs2_dlm_unlock(osb->dlm, &lockres->l_lksb, lkm_flags,
+			       lockres);
+	if (ret) {
+		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
 		mlog(ML_ERROR, "lockres flags: %lu\n", lockres->l_flags);
 		dlm_print_one_lock(lockres->l_lksb.lockid);
 		BUG();
@@ -2823,23 +2814,21 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 {
 	int ret;
 	u32 dlm_flags = DLM_LKF_CONVERT;
-	enum dlm_status status;
 
 	mlog_entry_void();
 
 	if (lvb)
 		dlm_flags |= DLM_LKF_VALBLK;
 
-	status = ocfs2_dlm_lock(osb->dlm,
-				new_level,
-				&lockres->l_lksb,
-				dlm_flags,
-				lockres->l_name,
-				OCFS2_LOCK_ID_MAX_LEN - 1,
-				lockres);
-	if (status != DLM_NORMAL) {
-		ocfs2_log_dlm_error("ocfs2_dlm_lock", status, lockres);
-		ret = -EINVAL;
+	ret = ocfs2_dlm_lock(osb->dlm,
+			     new_level,
+			     &lockres->l_lksb,
+			     dlm_flags,
+			     lockres->l_name,
+			     OCFS2_LOCK_ID_MAX_LEN - 1,
+			     lockres);
+	if (ret) {
+		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
 		ocfs2_recover_from_dlm_error(lockres, 1);
 		goto bail;
 	}
@@ -2886,19 +2875,14 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 				struct ocfs2_lock_res *lockres)
 {
 	int ret;
-	enum dlm_status status;
 
 	mlog_entry_void();
 	mlog(0, "lock %s\n", lockres->l_name);
 
-	ret = 0;
-	status = ocfs2_dlm_unlock(osb->dlm,
-				  &lockres->l_lksb,
-				  DLM_LKF_CANCEL,
-				  lockres);
-	if (status != DLM_NORMAL) {
-		ocfs2_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
-		ret = -EINVAL;
+	ret = ocfs2_dlm_unlock(osb->dlm, &lockres->l_lksb,
+			       DLM_LKF_CANCEL, lockres);
+	if (ret) {
+		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
 		ocfs2_recover_from_dlm_error(lockres, 0);
 	}
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 9953804..0aec2fc 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -18,6 +18,7 @@
  * General Public License for more details.
  */
 
+#include "cluster/masklog.h"
 #include "stackglue.h"
 
 static struct ocfs2_locking_protocol *lproto;
@@ -77,7 +78,126 @@ static int flags_to_o2dlm(u32 flags)
 }
 #undef map_flag
 
-enum dlm_status ocfs2_dlm_lock(struct dlm_ctxt *dlm,
+/*
+ * Map an o2dlm status to standard errno values.
+ *
+ * o2dlm only uses a handful of these, and returns even fewer to the
+ * caller. Still, we try to assign sane values to each error.
+ *
+ * The following value pairs have special meanings to dlmglue, thus
+ * the right hand side needs to stay unique - never duplicate the
+ * mapping elsewhere in the table!
+ *
+ * DLM_NORMAL:		0
+ * DLM_NOTQUEUED:	-EAGAIN
+ * DLM_CANCELGRANT:	-DLM_ECANCEL
+ * DLM_CANCEL:		-DLM_EUNLOCK
+ */
+/* Keep in sync with dlmapi.h */
+static int status_map[] = {
+	[DLM_NORMAL]			= 0,		/* Success */
+	[DLM_GRANTED]			= -EINVAL,
+	[DLM_DENIED]			= -EACCES,
+	[DLM_DENIED_NOLOCKS]		= -EACCES,
+	[DLM_WORKING]			= -EBUSY,
+	[DLM_BLOCKED]			= -EINVAL,
+	[DLM_BLOCKED_ORPHAN]		= -EINVAL,
+	[DLM_DENIED_GRACE_PERIOD]	= -EACCES,
+	[DLM_SYSERR]			= -ENOMEM,	/* It is what it is */
+	[DLM_NOSUPPORT]			= -EPROTO,
+	[DLM_CANCELGRANT]		= -DLM_ECANCEL, /* Cancel after grant */
+	[DLM_IVLOCKID]			= -EINVAL,
+	[DLM_SYNC]			= -EINVAL,
+	[DLM_BADTYPE]			= -EINVAL,
+	[DLM_BADRESOURCE]		= -EINVAL,
+	[DLM_MAXHANDLES]		= -ENOMEM,
+	[DLM_NOCLINFO]			= -EINVAL,
+	[DLM_NOLOCKMGR]			= -EINVAL,
+	[DLM_NOPURGED]			= -EINVAL,
+	[DLM_BADARGS]			= -EINVAL,
+	[DLM_VOID]			= -EINVAL,
+	[DLM_NOTQUEUED]			= -EAGAIN,	/* Trylock failed */
+	[DLM_IVBUFLEN]			= -EINVAL,
+	[DLM_CVTUNGRANT]		= -EPERM,
+	[DLM_BADPARAM]			= -EINVAL,
+	[DLM_VALNOTVALID]		= -EINVAL,
+	[DLM_REJECTED]			= -EPERM,
+	[DLM_ABORT]			= -EINVAL,
+	[DLM_CANCEL]			= -DLM_EUNLOCK,	/* Successful cancel */
+	[DLM_IVRESHANDLE]		= -EINVAL,
+	[DLM_DEADLOCK]			= -EDEADLK,
+	[DLM_DENIED_NOASTS]		= -EINVAL,
+	[DLM_FORWARD]			= -EINVAL,
+	[DLM_TIMEOUT]			= -ETIMEDOUT,
+	[DLM_IVGROUPID]			= -EINVAL,
+	[DLM_VERS_CONFLICT]		= -EOPNOTSUPP,
+	[DLM_BAD_DEVICE_PATH]		= -ENOENT,
+	[DLM_NO_DEVICE_PERMISSION]	= -EPERM,
+	[DLM_NO_CONTROL_DEVICE]		= -ENOENT,
+	[DLM_RECOVERING]		= -ENOTCONN,
+	[DLM_MIGRATING]			= -ERESTART,
+	[DLM_MAXSTATS]			= -EINVAL,
+};
+static int dlm_status_to_errno(enum dlm_status status)
+{
+	BUG_ON(status > (sizeof(status_map) / sizeof(status_map[0])));
+
+	return status_map[status];
+}
+
+static void o2dlm_lock_ast_wrapper(void *astarg)
+{
+	BUG_ON(lproto == NULL);
+
+	lproto->lp_lock_ast(astarg);
+}
+
+static void o2dlm_blocking_ast_wrapper(void *astarg, int level)
+{
+	BUG_ON(lproto == NULL);
+
+	lproto->lp_blocking_ast(astarg, level);
+}
+
+static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
+{
+	int error;
+
+	BUG_ON(lproto == NULL);
+
+	/*
+	 * XXX: CANCEL values are sketchy.
+	 *
+	 * Currently we have preserved the o2dlm paradigm.  You can get
+	 * unlock_ast() whether the cancel succeded or not.
+	 *
+	 * First, we're going to pass DLM_EUNLOCK just like fs/dlm does for
+	 * successful unlocks.  That is a clean behavior.
+	 *
+	 * In o2dlm, you can get both the lock_ast() for the lock being
+	 * granted and the unlock_ast() for the CANCEL failing.  A
+	 * successful cancel sends DLM_NORMAL here.  If the
+	 * lock grant happened before the cancel arrived, you get
+	 * DLM_CANCELGRANT.  For now, we'll use DLM_ECANCEL to signify
+	 * CANCELGRANT - the CANCEL was supposed to happen but didn't.  We
+	 * can then use DLM_EUNLOCK to signify a successful CANCEL -
+	 * effectively, the CANCEL caused the lock to roll back.
+	 *
+	 * In the future, we will likely move the o2dlm to send only one
+	 * ast - either unlock_ast() for a successful CANCEL or lock_ast()
+	 * when the grant succeeds.  At that point, we'll send DLM_ECANCEL
+	 * for all cancel results (CANCELGRANT will no longer exist).
+	 */
+	error = dlm_status_to_errno(status);
+
+	/* Successful unlock is DLM_EUNLOCK */
+	if (!error)
+		error = -DLM_EUNLOCK;
+
+	lproto->lp_unlock_ast(astarg, error);
+}
+
+int ocfs2_dlm_lock(struct dlm_ctxt *dlm,
 		   int mode,
 		   struct dlm_lockstatus *lksb,
 		   u32 flags,
@@ -85,27 +205,35 @@ enum dlm_status ocfs2_dlm_lock(struct dlm_ctxt *dlm,
 		   unsigned int namelen,
 		   void *astarg)
 {
+	enum dlm_status status;
 	int o2dlm_mode = mode_to_o2dlm(mode);
 	int o2dlm_flags = flags_to_o2dlm(flags);
+	int ret;
 
 	BUG_ON(lproto == NULL);
 
-	return dlmlock(dlm, o2dlm_mode, lksb, o2dlm_flags, name, namelen,
-		       lproto->lp_lock_ast, astarg,
-		       lproto->lp_blocking_ast);
+	status = dlmlock(dlm, o2dlm_mode, lksb, o2dlm_flags, name, namelen,
+		       o2dlm_lock_ast_wrapper, astarg,
+		       o2dlm_blocking_ast_wrapper);
+	ret = dlm_status_to_errno(status);
+	return ret;
 }
 
-enum dlm_status ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
+int ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
 		     struct dlm_lockstatus *lksb,
 		     u32 flags,
 		     void *astarg)
 {
+	enum dlm_status status;
 	int o2dlm_flags = flags_to_o2dlm(flags);
+	int ret;
 
 	BUG_ON(lproto == NULL);
 
-	return dlmunlock(dlm, lksb, o2dlm_flags,
-			 lproto->lp_unlock_ast, astarg);
+	status = dlmunlock(dlm, lksb, o2dlm_flags,
+			 o2dlm_unlock_ast_wrapper, astarg);
+	ret = dlm_status_to_errno(status);
+	return ret;
 }
 
 
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 986d059..8ebcfba 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -37,17 +37,17 @@
 struct ocfs2_locking_protocol {
 	void (*lp_lock_ast)(void *astarg);
 	void (*lp_blocking_ast)(void *astarg, int level);
-	void (*lp_unlock_ast)(void *astarg, enum dlm_status status);
+	void (*lp_unlock_ast)(void *astarg, int error);
 };
 
-enum dlm_status ocfs2_dlm_lock(struct dlm_ctxt *dlm,
+int ocfs2_dlm_lock(struct dlm_ctxt *dlm,
 		   int mode,
 		   struct dlm_lockstatus *lksb,
 		   u32 flags,
 		   void *name,
 		   unsigned int namelen,
 		   void *astarg);
-enum dlm_status ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
+int ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
 		     struct dlm_lockstatus *lksb,
 		     u32 flags,
 		     void *astarg);
-- 
1.5.3.8
