From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:26 -0700
Subject: [Ocfs2-devel] [PATCH 16/62] ocfs2: Remove CANCELGRANT from the view
	of dlmglue.
In-Reply-To: <12071673492775-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
Message-ID: <12071673511262-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

o2dlm has the non-standard behavior of providing a cancel callback
(unlock_ast) even when the cancel has failed (the locking operation
succeeded without canceling).  This is called CANCELGRANT after the
status code sent to the callback.  fs/dlm does not provide this
callback, so dlmglue must be changed to live without it.
o2dlm_unlock_ast_wrapper() in stackglue now ignores CANCELGRANT calls.

Because dlmglue no longer sees CANCELGRANT, ocfs2_unlock_ast() no longer
needs to check for it.  ocfs2_locking_ast() must catch that a cancel was
tried and clear the cancel state.

Making these changes opens up a locking race.  dlmglue uses the the
OCFS2_LOCK_BUSY flag to ensure only one thread is calling the dlm at any
one time.  But dlmglue must unlock the lockres before calling into the
dlm.  In the small window of time between unlocking the lockres and
calling the dlm, the downconvert thread can try to cancel the lock.  The
downconvert thread is checking the OCFS2_LOCK_BUSY flag - it doesn't
know that ocfs2_dlm_lock() has not yet been called.

Because ocfs2_dlm_lock() has not yet been called, the cancel operation
will just be a no-op.  There's nothing to cancel.  With CANCELGRANT,
dlmglue uses the CANCELGRANT callback to clear up the cancel state.
When it comes around again, it will retry the cancel.  Eventually, the
first thread will have called into ocfs2_dlm_lock(), and either the
lock or the cancel will succeed.  The downconvert thread can then do its
downconvert.

Without CANCELGRANT, there is nothing to clean up the cancellation
state.  The downconvert thread does not know to retry its operations.
More importantly, the original lock may be blocking on the other node
that is trying to cancel us.  With neither able to make progress, the
ast is never called and the cancellation state is never cleaned up that
way.  dlmglue is deadlocked.

The OCFS2_LOCK_PENDING flag is introduced to remedy this window.  It is
set at the same time OCFS2_LOCK_BUSY is.  Thus, the downconvert thread
can check whether the lock is cancelable.  If not, it just loops around
to try again.  Once ocfs2_dlm_lock() is called, the thread then clears
OCFS2_LOCK_PENDING and wakes the downconvert thread.  Now, if the
downconvert thread finds the lock BUSY, it can safely try to cancel it.
Whether the cancel works or not, the state will be properly set and the
lock processing can continue.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c   |  199 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/ocfs2.h     |    4 +
 fs/ocfs2/stackglue.c |   40 +++-------
 3 files changed, 188 insertions(+), 55 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index c7653bb..295c47f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -311,12 +311,13 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 				  struct buffer_head **bh);
 static void ocfs2_drop_osb_locks(struct ocfs2_super *osb);
 static inline int ocfs2_highest_compat_lock_level(int level);
-static void ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
-				      int new_level);
+static unsigned int ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
+					      int new_level);
 static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 				  struct ocfs2_lock_res *lockres,
 				  int new_level,
-				  int lvb);
+				  int lvb,
+				  unsigned int generation);
 static int ocfs2_prepare_cancel_convert(struct ocfs2_super *osb,
 				        struct ocfs2_lock_res *lockres);
 static int ocfs2_cancel_convert(struct ocfs2_super *osb,
@@ -736,6 +737,113 @@ static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
 	return needs_downconvert;
 }
 
+/*
+ * OCFS2_LOCK_PENDING and l_pending_gen.
+ *
+ * Why does OCFS2_LOCK_PENDING exist?  To close a race between setting
+ * OCFS2_LOCK_BUSY and calling ocfs2_dlm_lock().  See ocfs2_unblock_lock()
+ * for more details on the race.
+ *
+ * OCFS2_LOCK_PENDING closes the race quite nicely.  However, it introduces
+ * a race on itself.  In o2dlm, we can get the ast before ocfs2_dlm_lock()
+ * returns.  The ast clears OCFS2_LOCK_BUSY, and must therefore clear
+ * OCFS2_LOCK_PENDING at the same time.  When ocfs2_dlm_lock() returns,
+ * the caller is going to try to clear PENDING again.  If nothing else is
+ * happening, __lockres_clear_pending() sees PENDING is unset and does
+ * nothing.
+ *
+ * But what if another path (eg downconvert thread) has just started a
+ * new locking action?  The other path has re-set PENDING.  Our path
+ * cannot clear PENDING, because that will re-open the original race
+ * window.
+ *
+ * [Example]
+ *
+ * ocfs2_meta_lock()
+ *  ocfs2_cluster_lock()
+ *   set BUSY
+ *   set PENDING
+ *   drop l_lock
+ *   ocfs2_dlm_lock()
+ *    ocfs2_locking_ast()		ocfs2_downconvert_thread()
+ *     clear PENDING			 ocfs2_unblock_lock()
+ *					  take_l_lock
+ *					  !BUSY
+ *					  ocfs2_prepare_downconvert()
+ *					   set BUSY
+ *					   set PENDING
+ *					  drop l_lock
+ *   take l_lock
+ *   clear PENDING
+ *   drop l_lock
+ *			<window>
+ *					  ocfs2_dlm_lock()
+ *
+ * So as you can see, we now have a window where l_lock is not held,
+ * PENDING is not set, and ocfs2_dlm_lock() has not been called.
+ *
+ * The core problem is that ocfs2_cluster_lock() has cleared the PENDING
+ * set by ocfs2_prepare_downconvert().  That wasn't nice.
+ *
+ * To solve this we introduce l_pending_gen.  A call to
+ * lockres_clear_pending() will only do so when it is passed a generation
+ * number that matches the lockres.  lockres_set_pending() will return the
+ * current generation number.  When ocfs2_cluster_lock() goes to clear
+ * PENDING, it passes the generation it got from set_pending().  In our
+ * example above, the generation numbers will *not* match.  Thus,
+ * ocfs2_cluster_lock() will not clear the PENDING set by
+ * ocfs2_prepare_downconvert().
+ */
+
+/* Unlocked version for ocfs2_locking_ast() */
+static void __lockres_clear_pending(struct ocfs2_lock_res *lockres,
+				    unsigned int generation,
+				    struct ocfs2_super *osb)
+{
+	assert_spin_locked(&lockres->l_lock);
+
+	/*
+	 * The ast and locking functions can race us here.  The winner
+	 * will clear pending, the loser will not.
+	 */
+	if (!(lockres->l_flags & OCFS2_LOCK_PENDING) ||
+	    (lockres->l_pending_gen != generation))
+		return;
+
+	lockres_clear_flags(lockres, OCFS2_LOCK_PENDING);
+	lockres->l_pending_gen++;
+
+	/*
+	 * The downconvert thread may have skipped us because we
+	 * were PENDING.  Wake it up.
+	 */
+	if (lockres->l_flags & OCFS2_LOCK_BLOCKED)
+		ocfs2_wake_downconvert_thread(osb);
+}
+
+/* Locked version for callers of ocfs2_dlm_lock() */
+static void lockres_clear_pending(struct ocfs2_lock_res *lockres,
+				  unsigned int generation,
+				  struct ocfs2_super *osb)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lockres->l_lock, flags);
+	__lockres_clear_pending(lockres, generation, osb);
+	spin_unlock_irqrestore(&lockres->l_lock, flags);
+}
+
+static unsigned int lockres_set_pending(struct ocfs2_lock_res *lockres)
+{
+	assert_spin_locked(&lockres->l_lock);
+	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BUSY));
+
+	lockres_or_flags(lockres, OCFS2_LOCK_PENDING);
+
+	return lockres->l_pending_gen;
+}
+
+
 static void ocfs2_blocking_ast(void *opaque, int level)
 {
 	struct ocfs2_lock_res *lockres = opaque;
@@ -770,6 +878,7 @@ static void ocfs2_blocking_ast(void *opaque, int level)
 static void ocfs2_locking_ast(void *opaque)
 {
 	struct ocfs2_lock_res *lockres = opaque;
+	struct ocfs2_super *osb = ocfs2_get_lockres_osb(lockres);
 	unsigned long flags;
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
@@ -805,6 +914,18 @@ static void ocfs2_locking_ast(void *opaque)
 	 * can catch it. */
 	lockres->l_action = OCFS2_AST_INVALID;
 
+	/* Did we try to cancel this lock?  Clear that state */
+	if (lockres->l_unlock_action == OCFS2_UNLOCK_CANCEL_CONVERT)
+		lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
+
+	/*
+	 * We may have beaten the locking functions here.  We certainly
+	 * know that dlm_lock() has been called :-)
+	 * Because we can't have two lock calls in flight at once, we
+	 * can use lockres->l_pending_gen.
+	 */
+	__lockres_clear_pending(lockres, lockres->l_pending_gen,  osb);
+
 	wake_up(&lockres->l_event);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 }
@@ -838,6 +959,7 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 {
 	int ret = 0;
 	unsigned long flags;
+	unsigned int gen;
 
 	mlog_entry_void();
 
@@ -854,6 +976,7 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 	lockres->l_action = OCFS2_AST_ATTACH;
 	lockres->l_requested = level;
 	lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
+	gen = lockres_set_pending(lockres);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	ret = ocfs2_dlm_lock(osb->cconn,
@@ -863,6 +986,7 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 			     lockres->l_name,
 			     OCFS2_LOCK_ID_MAX_LEN - 1,
 			     lockres);
+	lockres_clear_pending(lockres, gen, osb);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
 		ocfs2_recover_from_dlm_error(lockres, 1);
@@ -988,6 +1112,7 @@ static int ocfs2_cluster_lock(struct ocfs2_super *osb,
 	int wait, catch_signals = !(osb->s_mount_opt & OCFS2_MOUNT_NOINTR);
 	int ret = 0; /* gcc doesn't realize wait = 1 guarantees ret is set */
 	unsigned long flags;
+	unsigned int gen;
 
 	mlog_entry_void();
 
@@ -1046,6 +1171,7 @@ again:
 
 		lockres->l_requested = level;
 		lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
+		gen = lockres_set_pending(lockres);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 		BUG_ON(level == DLM_LOCK_IV);
@@ -1062,6 +1188,7 @@ again:
 				     lockres->l_name,
 				     OCFS2_LOCK_ID_MAX_LEN - 1,
 				     lockres);
+		lockres_clear_pending(lockres, gen, osb);
 		if (ret) {
 			if (!(lkm_flags & DLM_LKF_NOQUEUE) ||
 			    (ret != -EAGAIN)) {
@@ -1506,6 +1633,7 @@ out:
 void ocfs2_file_unlock(struct file *file)
 {
 	int ret;
+	unsigned int gen;
 	unsigned long flags;
 	struct ocfs2_file_private *fp = file->private_data;
 	struct ocfs2_lock_res *lockres = &fp->fp_flock;
@@ -1531,11 +1659,11 @@ void ocfs2_file_unlock(struct file *file)
 	lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
 	lockres->l_blocking = DLM_LOCK_EX;
 
-	ocfs2_prepare_downconvert(lockres, LKM_NLMODE);
+	gen = ocfs2_prepare_downconvert(lockres, LKM_NLMODE);
 	lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
-	ret = ocfs2_downconvert_lock(osb, lockres, LKM_NLMODE, 0);
+	ret = ocfs2_downconvert_lock(osb, lockres, LKM_NLMODE, 0, gen);
 	if (ret) {
 		mlog_errno(ret);
 		return;
@@ -2555,23 +2683,7 @@ static void ocfs2_unlock_ast(void *opaque, int error)
 	     lockres->l_unlock_action);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
-	/* We tried to cancel a convert request, but it was already
-	 * granted. All we want to do here is clear our unlock
-	 * state. The wake_up call done at the bottom is redundant
-	 * (ocfs2_prepare_cancel_convert doesn't sleep on this) but doesn't
-	 * hurt anything anyway */
-	if (error == -DLM_ECANCEL &&
-	    lockres->l_unlock_action == OCFS2_UNLOCK_CANCEL_CONVERT) {
-		mlog(0, "Got cancelgrant for %s\n", lockres->l_name);
-
-		/* We don't clear the busy flag in this case as it
-		 * should have been cleared by the ast which the dlm
-		 * has called. */
-		goto complete_unlock;
-	}
-
-	/* DLM_EUNLOCK is the success code for unlock */
-	if (error != -DLM_EUNLOCK) {
+	if (error) {
 		mlog(ML_ERROR, "Dlm passes error %d for lock %s, "
 		     "unlock_action %d\n", error, lockres->l_name,
 		     lockres->l_unlock_action);
@@ -2592,7 +2704,6 @@ static void ocfs2_unlock_ast(void *opaque, int error)
 	}
 
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
-complete_unlock:
 	lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
@@ -2768,8 +2879,8 @@ int ocfs2_drop_inode_locks(struct inode *inode)
 	return status;
 }
 
-static void ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
-				      int new_level)
+static unsigned int ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
+					      int new_level)
 {
 	assert_spin_locked(&lockres->l_lock);
 
@@ -2787,12 +2898,14 @@ static void ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
 	lockres->l_action = OCFS2_AST_DOWNCONVERT;
 	lockres->l_requested = new_level;
 	lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
+	return lockres_set_pending(lockres);
 }
 
 static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 				  struct ocfs2_lock_res *lockres,
 				  int new_level,
-				  int lvb)
+				  int lvb,
+				  unsigned int generation)
 {
 	int ret;
 	u32 dlm_flags = DLM_LKF_CONVERT;
@@ -2809,6 +2922,7 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 			     lockres->l_name,
 			     OCFS2_LOCK_ID_MAX_LEN - 1,
 			     lockres);
+	lockres_clear_pending(lockres, generation, osb);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
 		ocfs2_recover_from_dlm_error(lockres, 1);
@@ -2883,6 +2997,7 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
 	int new_level;
 	int ret = 0;
 	int set_lvb = 0;
+	unsigned int gen;
 
 	mlog_entry_void();
 
@@ -2892,6 +3007,32 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
 
 recheck:
 	if (lockres->l_flags & OCFS2_LOCK_BUSY) {
+		/* XXX
+		 * This is a *big* race.  The OCFS2_LOCK_PENDING flag
+		 * exists entirely for one reason - another thread has set
+		 * OCFS2_LOCK_BUSY, but has *NOT* yet called dlm_lock().
+		 *
+		 * If we do ocfs2_cancel_convert() before the other thread
+		 * calls dlm_lock(), our cancel will do nothing.  We will
+		 * get no ast, and we will have no way of knowing the
+		 * cancel failed.  Meanwhile, the other thread will call
+		 * into dlm_lock() and wait...forever.
+		 *
+		 * Why forever?  Because another node has asked for the
+		 * lock first; that's why we're here in unblock_lock().
+		 *
+		 * The solution is OCFS2_LOCK_PENDING.  When PENDING is
+		 * set, we just requeue the unblock.  Only when the other
+		 * thread has called dlm_lock() and cleared PENDING will
+		 * we then cancel their request.
+		 *
+		 * All callers of dlm_lock() must set OCFS2_DLM_PENDING
+		 * at the same time they set OCFS2_DLM_BUSY.  They must
+		 * clear OCFS2_DLM_PENDING after dlm_lock() returns.
+		 */
+		if (lockres->l_flags & OCFS2_LOCK_PENDING)
+			goto leave_requeue;
+
 		ctl->requeue = 1;
 		ret = ocfs2_prepare_cancel_convert(osb, lockres);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
@@ -2971,9 +3112,11 @@ downconvert:
 			lockres->l_ops->set_lvb(lockres);
 	}
 
-	ocfs2_prepare_downconvert(lockres, new_level);
+	gen = ocfs2_prepare_downconvert(lockres, new_level);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
-	ret = ocfs2_downconvert_lock(osb, lockres, new_level, set_lvb);
+	ret = ocfs2_downconvert_lock(osb, lockres, new_level, set_lvb,
+				     gen);
+
 leave:
 	mlog_exit(ret);
 	return ret;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 31dc28b..af929ec 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -98,6 +98,9 @@ enum ocfs2_unlock_action {
 					       * dropped. */
 #define OCFS2_LOCK_QUEUED        (0x00000100) /* queued for downconvert */
 #define OCFS2_LOCK_NOCACHE       (0x00000200) /* don't use a holder count */
+#define OCFS2_LOCK_PENDING       (0x00000400) /* This lockres is pending a
+						 call to dlm_lock.  Only
+						 exists with BUSY set. */
 
 struct ocfs2_lock_res_ops;
 
@@ -124,6 +127,7 @@ struct ocfs2_lock_res {
 	enum ocfs2_unlock_action l_unlock_action;
 	int                      l_requested;
 	int                      l_blocking;
+	unsigned int             l_pending_gen;
 
 	wait_queue_head_t        l_event;
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 670fa94..abdb9f6 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -104,8 +104,8 @@ static int flags_to_o2dlm(u32 flags)
  *
  * DLM_NORMAL:		0
  * DLM_NOTQUEUED:	-EAGAIN
- * DLM_CANCELGRANT:	-DLM_ECANCEL
- * DLM_CANCEL:		-DLM_EUNLOCK
+ * DLM_CANCELGRANT:	-EBUSY
+ * DLM_CANCEL:		-DLM_ECANCEL
  */
 /* Keep in sync with dlmapi.h */
 static int status_map[] = {
@@ -113,13 +113,13 @@ static int status_map[] = {
 	[DLM_GRANTED]			= -EINVAL,
 	[DLM_DENIED]			= -EACCES,
 	[DLM_DENIED_NOLOCKS]		= -EACCES,
-	[DLM_WORKING]			= -EBUSY,
+	[DLM_WORKING]			= -EACCES,
 	[DLM_BLOCKED]			= -EINVAL,
 	[DLM_BLOCKED_ORPHAN]		= -EINVAL,
 	[DLM_DENIED_GRACE_PERIOD]	= -EACCES,
 	[DLM_SYSERR]			= -ENOMEM,	/* It is what it is */
 	[DLM_NOSUPPORT]			= -EPROTO,
-	[DLM_CANCELGRANT]		= -DLM_ECANCEL, /* Cancel after grant */
+	[DLM_CANCELGRANT]		= -EBUSY,	/* Cancel after grant */
 	[DLM_IVLOCKID]			= -EINVAL,
 	[DLM_SYNC]			= -EINVAL,
 	[DLM_BADTYPE]			= -EINVAL,
@@ -137,7 +137,7 @@ static int status_map[] = {
 	[DLM_VALNOTVALID]		= -EINVAL,
 	[DLM_REJECTED]			= -EPERM,
 	[DLM_ABORT]			= -EINVAL,
-	[DLM_CANCEL]			= -DLM_EUNLOCK,	/* Successful cancel */
+	[DLM_CANCEL]			= -DLM_ECANCEL,	/* Successful cancel */
 	[DLM_IVRESHANDLE]		= -EINVAL,
 	[DLM_DEADLOCK]			= -EDEADLK,
 	[DLM_DENIED_NOASTS]		= -EINVAL,
@@ -152,6 +152,7 @@ static int status_map[] = {
 	[DLM_MIGRATING]			= -ERESTART,
 	[DLM_MAXSTATS]			= -EINVAL,
 };
+
 static int dlm_status_to_errno(enum dlm_status status)
 {
 	BUG_ON(status > (sizeof(status_map) / sizeof(status_map[0])));
@@ -175,38 +176,23 @@ static void o2dlm_blocking_ast_wrapper(void *astarg, int level)
 
 static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 {
-	int error;
+	int error = dlm_status_to_errno(status);
 
 	BUG_ON(lproto == NULL);
 
 	/*
-	 * XXX: CANCEL values are sketchy.
-	 *
-	 * Currently we have preserved the o2dlm paradigm.  You can get
-	 * unlock_ast() whether the cancel succeded or not.
-	 *
-	 * First, we're going to pass DLM_EUNLOCK just like fs/dlm does for
-	 * successful unlocks.  That is a clean behavior.
-	 *
 	 * In o2dlm, you can get both the lock_ast() for the lock being
 	 * granted and the unlock_ast() for the CANCEL failing.  A
 	 * successful cancel sends DLM_NORMAL here.  If the
 	 * lock grant happened before the cancel arrived, you get
-	 * DLM_CANCELGRANT.  For now, we'll use DLM_ECANCEL to signify
-	 * CANCELGRANT - the CANCEL was supposed to happen but didn't.  We
-	 * can then use DLM_EUNLOCK to signify a successful CANCEL -
-	 * effectively, the CANCEL caused the lock to roll back.
+	 * DLM_CANCELGRANT.
 	 *
-	 * In the future, we will likely move the o2dlm to send only one
-	 * ast - either unlock_ast() for a successful CANCEL or lock_ast()
-	 * when the grant succeeds.  At that point, we'll send DLM_ECANCEL
-	 * for all cancel results (CANCELGRANT will no longer exist).
+	 * There's no need for the double-ast.  If we see DLM_CANCELGRANT,
+	 * we just ignore it.  We expect the lock_ast() to handle the
+	 * granted lock.
 	 */
-	error = dlm_status_to_errno(status);
-
-	/* Successful unlock is DLM_EUNLOCK */
-	if (!error)
-		error = -DLM_EUNLOCK;
+	if (status == DLM_CANCELGRANT)
+		return;
 
 	lproto->lp_unlock_ast(astarg, error);
 }
-- 
1.5.4.1
