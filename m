From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 25 Feb 2010 15:27:30 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Use a separate masklog for AST and
	BASTs
In-Reply-To: <1267140451-21243-1-git-send-email-sunil.mushran@oracle.com>
References: <1267140451-21243-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1267140451-21243-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds a new masklog and uses it allow tracing ASTs and BASTs
in the dlmglue layer. This has been found to be very useful in debugging
cluster locking issues.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/masklog.c |    1 +
 fs/ocfs2/cluster/masklog.h |    1 +
 fs/ocfs2/dlmglue.c         |   90 +++++++++++++++++++++++++++++++------------
 3 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 9cc14d9..3afe237 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -112,6 +112,7 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(XATTR),
 	define_mask(QUOTA),
 	define_mask(REFCOUNT),
+	define_mask(BASTS),
 	define_mask(ERROR),
 	define_mask(NOTICE),
 	define_mask(KTHREAD),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 1ef480d..b7f6821 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -114,6 +114,7 @@
 #define ML_XATTR	0x0000000020000000ULL /* ocfs2 extended attributes */
 #define ML_QUOTA	0x0000000040000000ULL /* ocfs2 quota operations */
 #define ML_REFCOUNT	0x0000000080000000ULL /* refcount tree operations */
+#define ML_BASTS	0x0000001000000000ULL /* dlmglue asts and basts */
 /* bits that are infrequently given and frequently matched in the high word */
 #define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
 #define ML_NOTICE	0x0000000200000000ULL /* setn to KERN_NOTICE */
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index d32937d..2cbf324 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -934,6 +934,10 @@ static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
 		lockres->l_blocking = level;
 	}
 
+	mlog(ML_BASTS, "lockres %s, block %d, level %d, l_block %d, dwn %d\n",
+	     lockres->l_name, level, lockres->l_level, lockres->l_blocking,
+	     needs_downconvert);
+
 	if (needs_downconvert)
 		lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
 
@@ -1057,8 +1061,8 @@ static void ocfs2_blocking_ast(void *opaque, int level)
 
 	BUG_ON(level <= DLM_LOCK_NL);
 
-	mlog(0, "BAST fired for lockres %s, blocking %d, level %d type %s\n",
-	     lockres->l_name, level, lockres->l_level,
+	mlog(ML_BASTS, "BAST fired for lockres %s, blocking %d, level %d, "
+	     "type %s\n", lockres->l_name, level, lockres->l_level,
 	     ocfs2_lock_type_string(lockres->l_type));
 
 	/*
@@ -1102,6 +1106,10 @@ static void ocfs2_locking_ast(void *opaque)
 		return;
 	}
 
+	mlog(ML_BASTS, "AST fired for lockres %s, action %d, unlock %d, "
+	     "level %d => %d\n", lockres->l_name, lockres->l_action,
+	     lockres->l_unlock_action, lockres->l_level, lockres->l_requested);
+
 	switch(lockres->l_action) {
 	case OCFS2_AST_ATTACH:
 		ocfs2_generic_handle_attach_action(lockres);
@@ -1114,8 +1122,8 @@ static void ocfs2_locking_ast(void *opaque)
 		ocfs2_generic_handle_downconvert_action(lockres);
 		break;
 	default:
-		mlog(ML_ERROR, "lockres %s: ast fired with invalid action: %u "
-		     "lockres flags = 0x%lx, unlock action: %u\n",
+		mlog(ML_ERROR, "lockres %s: AST fired with invalid action: %u, "
+		     "flags 0x%lx, unlock: %u\n",
 		     lockres->l_name, lockres->l_action, lockres->l_flags,
 		     lockres->l_unlock_action);
 		BUG();
@@ -1419,7 +1427,7 @@ again:
 		BUG_ON(level == DLM_LOCK_IV);
 		BUG_ON(level == DLM_LOCK_NL);
 
-		mlog(0, "lock %s, convert from %d to level = %d\n",
+		mlog(ML_BASTS, "lockres %s, convert from %d to %d\n",
 		     lockres->l_name, lockres->l_level, level);
 
 		/* call dlm_lock to upgrade lock now */
@@ -3074,8 +3082,8 @@ static void ocfs2_unlock_ast(void *opaque, int error)
 
 	mlog_entry_void();
 
-	mlog(0, "UNLOCK AST called on lock %s, action = %d\n", lockres->l_name,
-	     lockres->l_unlock_action);
+	mlog(ML_BASTS, "UNLOCK AST fired for lockres %s, action = %d\n",
+	     lockres->l_name, lockres->l_unlock_action);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	if (error) {
@@ -3287,13 +3295,20 @@ static unsigned int ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
 	BUG_ON(lockres->l_blocking <= DLM_LOCK_NL);
 
 	if (lockres->l_level <= new_level) {
-		mlog(ML_ERROR, "lockres->l_level (%d) <= new_level (%d)\n",
-		     lockres->l_level, new_level);
+		mlog(ML_ERROR, "lockres %s, lvl %d <= %d, blcklst %d, mask %d, "
+		     "type %d, flags 0x%lx, hold %d %d, act %d %d, req %d, "
+		     "block %d, pgen %d\n", lockres->l_name, lockres->l_level,
+		     new_level, list_empty(&lockres->l_blocked_list),
+		     list_empty(&lockres->l_mask_waiters), lockres->l_type,
+		     lockres->l_flags, lockres->l_ro_holders,
+		     lockres->l_ex_holders, lockres->l_action,
+		     lockres->l_unlock_action, lockres->l_requested,
+		     lockres->l_blocking, lockres->l_pending_gen);
 		BUG();
 	}
 
-	mlog(0, "lock %s, new_level = %d, l_blocking = %d\n",
-	     lockres->l_name, new_level, lockres->l_blocking);
+	mlog(ML_BASTS, "lockres %s, level %d => %d, blocking %d\n",
+	     lockres->l_name, lockres->l_level, new_level, lockres->l_blocking);
 
 	lockres->l_action = OCFS2_AST_DOWNCONVERT;
 	lockres->l_requested = new_level;
@@ -3312,6 +3327,9 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 
 	mlog_entry_void();
 
+	mlog(ML_BASTS, "lockres %s, level %d => %d\n", lockres->l_name,
+	     lockres->l_level, new_level);
+
 	if (lvb)
 		dlm_flags |= DLM_LKF_VALBLK;
 
@@ -3342,14 +3360,12 @@ static int ocfs2_prepare_cancel_convert(struct ocfs2_super *osb,
 	assert_spin_locked(&lockres->l_lock);
 
 	mlog_entry_void();
-	mlog(0, "lock %s\n", lockres->l_name);
 
 	if (lockres->l_unlock_action == OCFS2_UNLOCK_CANCEL_CONVERT) {
 		/* If we're already trying to cancel a lock conversion
 		 * then just drop the spinlock and allow the caller to
 		 * requeue this lock. */
-
-		mlog(0, "Lockres %s, skip convert\n", lockres->l_name);
+		mlog(ML_BASTS, "lockres %s, skip convert\n", lockres->l_name);
 		return 0;
 	}
 
@@ -3364,6 +3380,8 @@ static int ocfs2_prepare_cancel_convert(struct ocfs2_super *osb,
 			"lock %s, invalid flags: 0x%lx\n",
 			lockres->l_name, lockres->l_flags);
 
+	mlog(ML_BASTS, "lockres %s\n", lockres->l_name);
+
 	return 1;
 }
 
@@ -3373,7 +3391,6 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 	int ret;
 
 	mlog_entry_void();
-	mlog(0, "lock %s\n", lockres->l_name);
 
 	ret = ocfs2_dlm_unlock(osb->cconn, &lockres->l_lksb,
 			       DLM_LKF_CANCEL, lockres);
@@ -3382,7 +3399,7 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 		ocfs2_recover_from_dlm_error(lockres, 0);
 	}
 
-	mlog(0, "lock %s return from ocfs2_dlm_unlock\n", lockres->l_name);
+	mlog(ML_BASTS, "lockres %s\n", lockres->l_name);
 
 	mlog_exit(ret);
 	return ret;
@@ -3439,8 +3456,11 @@ recheck:
 		 * at the same time they set OCFS2_DLM_BUSY.  They must
 		 * clear OCFS2_DLM_PENDING after dlm_lock() returns.
 		 */
-		if (lockres->l_flags & OCFS2_LOCK_PENDING)
+		if (lockres->l_flags & OCFS2_LOCK_PENDING) {
+			mlog(ML_BASTS, "lockres %s, ReQ: Pending\n",
+			     lockres->l_name);
 			goto leave_requeue;
+		}
 
 		ctl->requeue = 1;
 		ret = ocfs2_prepare_cancel_convert(osb, lockres);
@@ -3472,6 +3492,7 @@ recheck:
 	 */
 	if (lockres->l_level == DLM_LOCK_NL) {
 		BUG_ON(lockres->l_ex_holders || lockres->l_ro_holders);
+		mlog(ML_BASTS, "lockres %s, Aborting dc\n", lockres->l_name);
 		lockres->l_blocking = DLM_LOCK_NL;
 		lockres_clear_flags(lockres, OCFS2_LOCK_BLOCKED);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
@@ -3481,28 +3502,41 @@ recheck:
 	/* if we're blocking an exclusive and we have *any* holders,
 	 * then requeue. */
 	if ((lockres->l_blocking == DLM_LOCK_EX)
-	    && (lockres->l_ex_holders || lockres->l_ro_holders))
+	    && (lockres->l_ex_holders || lockres->l_ro_holders)) {
+		mlog(ML_BASTS, "lockres %s, ReQ: EX/PR Holders %u,%u\n",
+		     lockres->l_name, lockres->l_ex_holders,
+		     lockres->l_ro_holders);
 		goto leave_requeue;
+	}
 
 	/* If it's a PR we're blocking, then only
 	 * requeue if we've got any EX holders */
 	if (lockres->l_blocking == DLM_LOCK_PR &&
-	    lockres->l_ex_holders)
+	    lockres->l_ex_holders) {
+		mlog(ML_BASTS, "lockres %s, ReQ: EX Holders %u\n",
+		     lockres->l_name, lockres->l_ex_holders);
 		goto leave_requeue;
+	}
 
 	/*
 	 * Can we get a lock in this state if the holder counts are
 	 * zero? The meta data unblock code used to check this.
 	 */
 	if ((lockres->l_ops->flags & LOCK_TYPE_REQUIRES_REFRESH)
-	    && (lockres->l_flags & OCFS2_LOCK_REFRESHING))
+	    && (lockres->l_flags & OCFS2_LOCK_REFRESHING)) {
+		mlog(ML_BASTS, "lockres %s, ReQ: Lock Refreshing\n",
+		     lockres->l_name);
 		goto leave_requeue;
+	}
 
 	new_level = ocfs2_highest_compat_lock_level(lockres->l_blocking);
 
 	if (lockres->l_ops->check_downconvert
-	    && !lockres->l_ops->check_downconvert(lockres, new_level))
+	    && !lockres->l_ops->check_downconvert(lockres, new_level)) {
+		mlog(ML_BASTS, "lockres %s, ReQ: Checkpointing\n",
+		     lockres->l_name);
 		goto leave_requeue;
+	}
 
 	/* If we get here, then we know that there are no more
 	 * incompatible holders (and anyone asking for an incompatible
@@ -3520,13 +3554,19 @@ recheck:
 
 	ctl->unblock_action = lockres->l_ops->downconvert_worker(lockres, blocking);
 
-	if (ctl->unblock_action == UNBLOCK_STOP_POST)
+	if (ctl->unblock_action == UNBLOCK_STOP_POST) {
+		mlog(ML_BASTS, "lockres %s, UNBLOCK_STOP_POST\n",
+		     lockres->l_name);
 		goto leave;
+	}
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	if ((blocking != lockres->l_blocking) || (level != lockres->l_level)) {
 		/* If this changed underneath us, then we can't drop
 		 * it just yet. */
+		mlog(ML_BASTS, "lockres %s, block=%d:%d, level=%d:%d, "
+		     "Recheck\n", lockres->l_name, blocking,
+		     lockres->l_blocking, level, lockres->l_level);
 		goto recheck;
 	}
 
@@ -3978,7 +4018,7 @@ static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
 	BUG_ON(!lockres);
 	BUG_ON(!lockres->l_ops);
 
-	mlog(0, "lockres %s blocked.\n", lockres->l_name);
+	mlog(ML_BASTS, "lockres %s blocked\n", lockres->l_name);
 
 	/* Detect whether a lock has been marked as going away while
 	 * the downconvert thread was processing other things. A lock can
@@ -4001,7 +4041,7 @@ unqueue:
 	} else
 		ocfs2_schedule_blocked_lock(osb, lockres);
 
-	mlog(0, "lockres %s, requeue = %s.\n", lockres->l_name,
+	mlog(ML_BASTS, "lockres %s, requeue = %s.\n", lockres->l_name,
 	     ctl.requeue ? "yes" : "no");
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
@@ -4023,7 +4063,7 @@ static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
 		/* Do not schedule a lock for downconvert when it's on
 		 * the way to destruction - any nodes wanting access
 		 * to the resource will get it soon. */
-		mlog(0, "Lockres %s won't be scheduled: flags 0x%lx\n",
+		mlog(ML_BASTS, "lockres %s won't be scheduled: flags 0x%lx\n",
 		     lockres->l_name, lockres->l_flags);
 		return;
 	}
-- 
1.6.3.3
