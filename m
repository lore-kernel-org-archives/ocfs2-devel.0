From: Coly Li <coyli@suse.de>
Date: Wed, 12 Nov 2008 17:26:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: replace obsoleted LKM_* dlm level with
 DLM_LOCK_* constants
Message-ID: <491AA140.3010104@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Current code still contains obsoleted LKM_* constants for dlm levels, the patch tries to replace the
obsoleted ones with DLM_LOCK_* constants which are from <linux/dlmconstants.h>.

Signed-off-by: Coly Li <coyli@suse.de>
---
 fs/ocfs2/dlm/dlmapi.h        |   11 -------
 fs/ocfs2/dlm/dlmast.c        |   16 +++++-----
 fs/ocfs2/dlm/dlmcommon.h     |   15 +++++----
 fs/ocfs2/dlm/dlmconvert.c    |   18 ++++++------
 fs/ocfs2/dlm/dlmfs.c         |    7 ++--
 fs/ocfs2/dlm/dlmlock.c       |    8 ++--
 fs/ocfs2/dlm/dlmrecovery.c   |   38 ++++++++++++------------
 fs/ocfs2/dlm/dlmthread.c     |   20 ++++++------
 fs/ocfs2/dlm/dlmunlock.c     |   12 ++++----
 fs/ocfs2/dlm/userdlm.c       |   64 +++++++++++++++++++++---------------------
 fs/ocfs2/dlmglue.c           |    4 +-
 fs/ocfs2/locks.c             |    4 +-
 fs/ocfs2/stack_o2cb.c        |   24 +---------------
 include/linux/dlmconstants.h |    1 +
 14 files changed, 106 insertions(+), 136 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmapi.h b/fs/ocfs2/dlm/dlmapi.h
index b5786a7..95838f0 100644
--- a/fs/ocfs2/dlm/dlmapi.h
+++ b/fs/ocfs2/dlm/dlmapi.h
@@ -115,17 +115,6 @@ struct dlm_lockstatus {
 	char lvb[DLM_LVB_LEN];
 };

-/* Valid lock modes. */
-#define LKM_IVMODE      (-1)            /* invalid mode */
-#define LKM_NLMODE      0               /* null lock */
-#define LKM_CRMODE      1               /* concurrent read    unsupported */
-#define LKM_CWMODE      2               /* concurrent write   unsupported */
-#define LKM_PRMODE      3               /* protected read */
-#define LKM_PWMODE      4               /* protected write    unsupported */
-#define LKM_EXMODE      5               /* exclusive */
-#define LKM_MAXMODE     5
-#define LKM_MODEMASK    0xff
-
 /* Flags passed to dlmlock and dlmunlock:
  * reserved: flags used by the "real" dlm
  * only a few are supported by this dlm
diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index 644bee5..3d85a6b 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -68,22 +68,22 @@ static int dlm_should_cancel_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 	assert_spin_locked(&dlm->ast_lock);
 	assert_spin_locked(&lock->spinlock);

-	if (lock->ml.highest_blocked == LKM_IVMODE)
+	if (lock->ml.highest_blocked == DLM_LOCK_IV)
 		return 0;
-	BUG_ON(lock->ml.highest_blocked == LKM_NLMODE);
+	BUG_ON(lock->ml.highest_blocked == DLM_LOCK_NL);

 	if (lock->bast_pending &&
 	    list_empty(&lock->bast_list))
 		/* old bast already sent, ok */
 		return 0;

-	if (lock->ml.type == LKM_EXMODE)
+	if (lock->ml.type == DLM_LOCK_EX)
 		/* EX blocks anything left, any bast still valid */
 		return 0;
-	else if (lock->ml.type == LKM_NLMODE)
+	else if (lock->ml.type == DLM_LOCK_NL)
 		/* NL blocks nothing, no reason to send any bast, cancel it */
 		return 1;
-	else if (lock->ml.highest_blocked != LKM_EXMODE)
+	else if (lock->ml.highest_blocked != DLM_LOCK_EX)
 		/* PR only blocks EX */
 		return 1;

@@ -118,7 +118,7 @@ static void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 		     dlm->name, res->lockname.len, res->lockname.name);
 		lock->bast_pending = 0;
 		list_del_init(&lock->bast_list);
-		lock->ml.highest_blocked = LKM_IVMODE;
+		lock->ml.highest_blocked = DLM_LOCK_IV;
 		/* removing lock from list, remove a ref.  guaranteed
 		 * this won't be the last ref because of the get above,
 		 * so res->spinlock will not be taken here */
@@ -385,9 +385,9 @@ do_ast:
 		list_move_tail(&lock->list, &res->granted);
 		mlog(0, "ast: adding to granted list... type=%d, "
 			  "convert_type=%d\n", lock->ml.type, lock->ml.convert_type);
-		if (lock->ml.convert_type != LKM_IVMODE) {
+		if (lock->ml.convert_type != DLM_LOCK_IV) {
 			lock->ml.type = lock->ml.convert_type;
-			lock->ml.convert_type = LKM_IVMODE;
+			lock->ml.convert_type = DLM_LOCK_IV;
 		} else {
 			// should already be there....
 		}
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index d5a86fb..59790a9 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -26,6 +26,7 @@
 #define DLMCOMMON_H

 #include <linux/kref.h>
+#include <linux/dlmconstants.h>

 #define DLM_HB_NODE_DOWN_PRI     (0xf000000)
 #define DLM_HB_NODE_UP_PRI       (0x8000000)
@@ -1027,11 +1028,11 @@ int __dlm_lockres_unused(struct dlm_lock_resource *res);
 static inline const char * dlm_lock_mode_name(int mode)
 {
 	switch (mode) {
-		case LKM_EXMODE:
+		case DLM_LOCK_EX:
 			return "EX";
-		case LKM_PRMODE:
+		case DLM_LOCK_PR:
 			return "PR";
-		case LKM_NLMODE:
+		case DLM_LOCK_NL:
 			return "NL";
 	}
 	return "UNKNOWN";
@@ -1041,16 +1042,16 @@ static inline const char * dlm_lock_mode_name(int mode)
 static inline int dlm_lock_compatible(int existing, int request)
 {
 	/* NO_LOCK compatible with all */
-	if (request == LKM_NLMODE ||
-	    existing == LKM_NLMODE)
+	if (request == DLM_LOCK_NL ||
+	    existing == DLM_LOCK_NL)
 		return 1;

 	/* EX incompatible with all non-NO_LOCK */
-	if (request == LKM_EXMODE)
+	if (request == DLM_LOCK_EX)
 		return 0;

 	/* request must be PR, which is compatible with PR */
-	if (existing == LKM_PRMODE)
+	if (existing == DLM_LOCK_PR)
 		return 1;

 	return 0;
diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index 75997b4..f117cf8 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -136,7 +136,7 @@ static enum dlm_status __dlmconvert_master(struct dlm_ctxt *dlm,
 	spin_lock(&lock->spinlock);

 	/* already converting? */
-	if (lock->ml.convert_type != LKM_IVMODE) {
+	if (lock->ml.convert_type != DLM_LOCK_IV) {
 		mlog(ML_ERROR, "attempted to convert a lock with a lock "
 		     "conversion pending\n");
 		status = DLM_DENIED;
@@ -153,17 +153,17 @@ static enum dlm_status __dlmconvert_master(struct dlm_ctxt *dlm,

 	if (flags & LKM_VALBLK) {
 		switch (lock->ml.type) {
-			case LKM_EXMODE:
+			case DLM_LOCK_EX:
 				/* EX + LKM_VALBLK + convert == set lvb */
 				mlog(0, "will set lvb: converting %s->%s\n",
 				     dlm_lock_mode_name(lock->ml.type),
 				     dlm_lock_mode_name(type));
 				lock->lksb->flags |= DLM_LKSB_PUT_LVB;
 				break;
-			case LKM_PRMODE:
-			case LKM_NLMODE:
+			case DLM_LOCK_PR:
+			case DLM_LOCK_NL:
 				/* refetch if new level is not NL */
-				if (type > LKM_NLMODE) {
+				if (type > DLM_LOCK_NL) {
 					mlog(0, "will fetch new value into "
 					     "lvb: converting %s->%s\n",
 					     dlm_lock_mode_name(lock->ml.type),
@@ -251,7 +251,7 @@ void dlm_revert_pending_convert(struct dlm_lock_resource *res,
 {
 	/* do not alter lock refcount.  switching lists. */
 	list_move_tail(&lock->list, &res->granted);
-	lock->ml.convert_type = LKM_IVMODE;
+	lock->ml.convert_type = DLM_LOCK_IV;
 	lock->lksb->flags &= ~(DLM_LKSB_GET_LVB|DLM_LKSB_PUT_LVB);
 }

@@ -282,7 +282,7 @@ enum dlm_status dlmconvert_remote(struct dlm_ctxt *dlm,
 	/* will exit this call with spinlock held */
 	__dlm_wait_on_lockres(res);

-	if (lock->ml.convert_type != LKM_IVMODE) {
+	if (lock->ml.convert_type != DLM_LOCK_IV) {
 		__dlm_print_one_lock_resource(res);
 		mlog(ML_ERROR, "converting a remote lock that is already "
 		     "converting! (cookie=%u:%llu, conv=%d)\n",
@@ -300,11 +300,11 @@ enum dlm_status dlmconvert_remote(struct dlm_ctxt *dlm,
 	lock->ml.convert_type = type;

 	if (flags & LKM_VALBLK) {
-		if (lock->ml.type == LKM_EXMODE) {
+		if (lock->ml.type == DLM_LOCK_EX) {
 			flags |= LKM_PUT_LVB;
 			lock->lksb->flags |= DLM_LKSB_PUT_LVB;
 		} else {
-			if (lock->ml.convert_type == LKM_NLMODE)
+			if (lock->ml.convert_type == DLM_LOCK_NL)
 				flags &= ~LKM_VALBLK;
 			else {
 				flags |= LKM_GET_LVB;
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 533a789..2aae623 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/backing-dev.h>
+#include <linux/dlmconstants.h>

 #include <asm/uaccess.h>

@@ -95,9 +96,9 @@ static int dlmfs_decode_open_flags(int open_flags,
 				   int *flags)
 {
 	if (open_flags & (O_WRONLY|O_RDWR))
-		*level = LKM_EXMODE;
+		*level = DLM_LOCK_EX;
 	else
-		*level = LKM_PRMODE;
+		*level = DLM_LOCK_PR;

 	*flags = 0;
 	if (open_flags & O_NONBLOCK)
@@ -169,7 +170,7 @@ static int dlmfs_file_release(struct inode *inode,
 	status = 0;
 	if (fp) {
 		level = fp->fp_lock_level;
-		if (level != LKM_IVMODE)
+		if (level != DLM_LOCK_IV)
 			user_dlm_cluster_unlock(&ip->ip_lockres, level);

 		kfree(fp);
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 83a9f29..b2e76ab 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -403,8 +403,8 @@ static void dlm_init_lock(struct dlm_lock *newlock, int type,
 	INIT_LIST_HEAD(&newlock->bast_list);
 	spin_lock_init(&newlock->spinlock);
 	newlock->ml.type = type;
-	newlock->ml.convert_type = LKM_IVMODE;
-	newlock->ml.highest_blocked = LKM_IVMODE;
+	newlock->ml.convert_type = DLM_LOCK_IV;
+	newlock->ml.highest_blocked = DLM_LOCK_IV;
 	newlock->ml.node = node;
 	newlock->ml.pad1 = 0;
 	newlock->ml.list = 0;
@@ -580,7 +580,7 @@ enum dlm_status dlmlock(struct dlm_ctxt *dlm, int mode,
 	}

 	status = DLM_BADPARAM;
-	if (mode != LKM_EXMODE && mode != LKM_PRMODE && mode != LKM_NLMODE) {
+	if (mode != DLM_LOCK_EX && mode != DLM_LOCK_PR && mode != DLM_LOCK_NL) {
 		dlm_error(status);
 		goto error;
 	}
@@ -703,7 +703,7 @@ retry_lock:

 			/* LVB requests for non PR, PW or EX locks are
 			 * ignored. */
-			if (mode < LKM_PRMODE)
+			if (mode < DLM_LOCK_PR)
 				flags &= ~LKM_VALBLK;
 			else {
 				flags |= LKM_GET_LVB;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index bcb9260..947f70c 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1183,12 +1183,12 @@ static int dlm_add_lock_to_array(struct dlm_lock *lock,
 	if (lock->lksb) {
 		ml->flags = lock->lksb->flags;
 		/* send our current lvb */
-		if (ml->type == LKM_EXMODE ||
-		    ml->type == LKM_PRMODE) {
+		if (ml->type == DLM_LOCK_EX ||
+		    ml->type == DLM_LOCK_PR) {
 			/* if it is already set, this had better be a PR
 			 * and it has to match */
 			if (!dlm_lvb_is_empty(mres->lvb) &&
-			    (ml->type == LKM_EXMODE ||
+			    (ml->type == DLM_LOCK_EX ||
 			     memcmp(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN))) {
 				mlog(ML_ERROR, "mismatched lvbs!\n");
 				dlm_print_one_lock_resource(lock->lockres);
@@ -1211,9 +1211,9 @@ static void dlm_add_dummy_lock(struct dlm_ctxt *dlm,
 	struct dlm_lock dummy;
 	memset(&dummy, 0, sizeof(dummy));
 	dummy.ml.cookie = 0;
-	dummy.ml.type = LKM_IVMODE;
-	dummy.ml.convert_type = LKM_IVMODE;
-	dummy.ml.highest_blocked = LKM_IVMODE;
+	dummy.ml.type = DLM_LOCK_IV;
+	dummy.ml.convert_type = DLM_LOCK_IV;
+	dummy.ml.highest_blocked = DLM_LOCK_IV;
 	dummy.lksb = NULL;
 	dummy.ml.node = dlm->node_num;
 	dlm_add_lock_to_array(&dummy, mres, DLM_BLOCKED_LIST);
@@ -1224,9 +1224,9 @@ static inline int dlm_is_dummy_lock(struct dlm_ctxt *dlm,
 				    u8 *nodenum)
 {
 	if (unlikely(ml->cookie == 0 &&
-	    ml->type == LKM_IVMODE &&
-	    ml->convert_type == LKM_IVMODE &&
-	    ml->highest_blocked == LKM_IVMODE &&
+	    ml->type == DLM_LOCK_IV &&
+	    ml->convert_type == DLM_LOCK_IV &&
+	    ml->highest_blocked == DLM_LOCK_IV &&
 	    ml->list == DLM_BLOCKED_LIST)) {
 		*nodenum = ml->node;
 		return 1;
@@ -1748,7 +1748,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			added++;
 			break;
 		}
-		BUG_ON(ml->highest_blocked != LKM_IVMODE);
+		BUG_ON(ml->highest_blocked != DLM_LOCK_IV);
 		newlock = NULL;
 		lksb = NULL;

@@ -1818,14 +1818,14 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 		lksb = newlock->lksb;
 		dlm_lock_attach_lockres(newlock, res);

-		if (ml->convert_type != LKM_IVMODE) {
+		if (ml->convert_type != DLM_LOCK_IV) {
 			BUG_ON(queue != &res->converting);
 			newlock->ml.convert_type = ml->convert_type;
 		}
 		lksb->flags |= (ml->flags &
 				(DLM_LKSB_PUT_LVB|DLM_LKSB_GET_LVB));

-		if (ml->type == LKM_NLMODE)
+		if (ml->type == DLM_LOCK_NL)
 			goto skip_lvb;

 		if (!dlm_lvb_is_empty(mres->lvb)) {
@@ -1842,10 +1842,10 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			} else {
 				/* otherwise, the node is sending its
 				 * most recent valid lvb info */
-				BUG_ON(ml->type != LKM_EXMODE &&
-				       ml->type != LKM_PRMODE);
+				BUG_ON(ml->type != DLM_LOCK_EX &&
+				       ml->type != DLM_LOCK_PR);
 				if (!dlm_lvb_is_empty(res->lvb) &&
- 				    (ml->type == LKM_EXMODE ||
+ 				    (ml->type == DLM_LOCK_EX ||
  				     memcmp(res->lvb, mres->lvb, DLM_LVB_LEN))) {
  					int i;
  					mlog(ML_ERROR, "%s:%.*s: received bad "
@@ -2094,10 +2094,10 @@ static void dlm_finish_local_lockres_recovery(struct dlm_ctxt *dlm,
 static inline int dlm_lvb_needs_invalidation(struct dlm_lock *lock, int local)
 {
 	if (local) {
-		if (lock->ml.type != LKM_EXMODE &&
-		    lock->ml.type != LKM_PRMODE)
+		if (lock->ml.type != DLM_LOCK_EX &&
+		    lock->ml.type != DLM_LOCK_PR)
 			return 1;
-	} else if (lock->ml.type == LKM_EXMODE)
+	} else if (lock->ml.type == DLM_LOCK_EX)
 		return 1;
 	return 0;
 }
@@ -2428,7 +2428,7 @@ static int dlm_pick_recovery_master(struct dlm_ctxt *dlm)
 again:	
 	memset(&lksb, 0, sizeof(lksb));

-	ret = dlmlock(dlm, LKM_EXMODE, &lksb, LKM_NOQUEUE|LKM_RECOVERY,
+	ret = dlmlock(dlm, DLM_LOCK_EX, &lksb, LKM_NOQUEUE|LKM_RECOVERY,
 		      DLM_RECOVERY_LOCK_NAME, DLM_RECOVERY_LOCK_NAME_LEN,
 		      dlm_reco_ast, dlm, dlm_reco_bast);

diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 4060bb3..80f1c29 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -303,7 +303,7 @@ converting:
 	     res->lockname.name);

 	target = list_entry(res->converting.next, struct dlm_lock, list);
-	if (target->ml.convert_type == LKM_IVMODE) {
+	if (target->ml.convert_type == DLM_LOCK_IV) {
 		mlog(ML_ERROR, "%.*s: converting a lock with no "
 		     "convert_type!\n", res->lockname.len, res->lockname.name);
 		BUG();
@@ -317,7 +317,7 @@ converting:
 					 target->ml.convert_type)) {
 			can_grant = 0;
 			/* queue the BAST if not already */
-			if (lock->ml.highest_blocked == LKM_IVMODE) {
+			if (lock->ml.highest_blocked == DLM_LOCK_IV) {
 				__dlm_lockres_reserve_ast(res);
 				dlm_queue_bast(dlm, lock);
 			}
@@ -335,7 +335,7 @@ converting:
 		if (!dlm_lock_compatible(lock->ml.type,
 					 target->ml.convert_type)) {
 			can_grant = 0;
-			if (lock->ml.highest_blocked == LKM_IVMODE) {
+			if (lock->ml.highest_blocked == DLM_LOCK_IV) {
 				__dlm_lockres_reserve_ast(res);
 				dlm_queue_bast(dlm, lock);
 			}
@@ -348,7 +348,7 @@ converting:
 	/* we can convert the lock */
 	if (can_grant) {
 		spin_lock(&target->spinlock);
-		BUG_ON(target->ml.highest_blocked != LKM_IVMODE);
+		BUG_ON(target->ml.highest_blocked != DLM_LOCK_IV);

 		mlog(0, "calling ast for converting lock: %.*s, have: %d, "
 		     "granting: %d, node: %u\n", res->lockname.len,
@@ -356,7 +356,7 @@ converting:
 		     target->ml.convert_type, target->ml.node);

 		target->ml.type = target->ml.convert_type;
-		target->ml.convert_type = LKM_IVMODE;
+		target->ml.convert_type = DLM_LOCK_IV;
 		list_move_tail(&target->list, &res->granted);

 		BUG_ON(!target->lksb);
@@ -382,7 +382,7 @@ blocked:
 			continue;
 		if (!dlm_lock_compatible(lock->ml.type, target->ml.type)) {
 			can_grant = 0;
-			if (lock->ml.highest_blocked == LKM_IVMODE) {
+			if (lock->ml.highest_blocked == DLM_LOCK_IV) {
 				__dlm_lockres_reserve_ast(res);
 				dlm_queue_bast(dlm, lock);
 			}
@@ -398,7 +398,7 @@ blocked:
 			continue;
 		if (!dlm_lock_compatible(lock->ml.type, target->ml.type)) {
 			can_grant = 0;
-			if (lock->ml.highest_blocked == LKM_IVMODE) {
+			if (lock->ml.highest_blocked == DLM_LOCK_IV) {
 				__dlm_lockres_reserve_ast(res);
 				dlm_queue_bast(dlm, lock);
 			}
@@ -411,7 +411,7 @@ blocked:
 	 * possible if converting list empty) */
 	if (can_grant) {
 		spin_lock(&target->spinlock);
-		BUG_ON(target->ml.highest_blocked != LKM_IVMODE);
+		BUG_ON(target->ml.highest_blocked != DLM_LOCK_IV);

 		mlog(0, "calling ast for blocked lock: %.*s, granting: %d, "
 		     "node: %u\n", res->lockname.len, res->lockname.name,
@@ -565,9 +565,9 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)

 		/* get the highest blocked lock, and reset */
 		spin_lock(&lock->spinlock);
-		BUG_ON(lock->ml.highest_blocked <= LKM_IVMODE);
+		BUG_ON(lock->ml.highest_blocked <= DLM_LOCK_IV);
 		hi = lock->ml.highest_blocked;
-		lock->ml.highest_blocked = LKM_IVMODE;
+		lock->ml.highest_blocked = DLM_LOCK_IV;
 		spin_unlock(&lock->spinlock);

 		/* remove from list (including ref) */
diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index 86ca085..940978a 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -227,7 +227,7 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 	if (actions & DLM_UNLOCK_CLEAR_CONVERT_TYPE) {
 		mlog(0, "clearing convert_type at %smaster node\n",
 		     master_node ? "" : "non-");
-		lock->ml.convert_type = LKM_IVMODE;
+		lock->ml.convert_type = DLM_LOCK_IV;
 	}

 	/* remove the extra ref on lock */
@@ -236,9 +236,9 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 leave:
 	res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
 	if (!dlm_lock_on_list(&res->converting, lock))
-		BUG_ON(lock->ml.convert_type != LKM_IVMODE);
+		BUG_ON(lock->ml.convert_type != DLM_LOCK_IV);
 	else
-		BUG_ON(lock->ml.convert_type == LKM_IVMODE);
+		BUG_ON(lock->ml.convert_type == DLM_LOCK_IV);
 	spin_unlock(&lock->spinlock);
 	spin_unlock(&res->spinlock);
 	wake_up(&res->wq);
@@ -275,7 +275,7 @@ void dlm_commit_pending_cancel(struct dlm_lock_resource *res,
 			       struct dlm_lock *lock)
 {
 	list_move_tail(&lock->list, &res->granted);
-	lock->ml.convert_type = LKM_IVMODE;
+	lock->ml.convert_type = DLM_LOCK_IV;
 }


@@ -482,7 +482,7 @@ int dlm_unlock_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 	/* lock was found on queue */
 	lksb = lock->lksb;
 	if (flags & (LKM_VALBLK|LKM_PUT_LVB) &&
-	    lock->ml.type != LKM_EXMODE)
+	    lock->ml.type != DLM_LOCK_EX)
 		flags &= ~(LKM_VALBLK|LKM_PUT_LVB);

 	/* unlockast only called on originating node */
@@ -625,7 +625,7 @@ retry:

 	spin_lock(&res->spinlock);
 	is_master = (res->owner == dlm->node_num);
-	if (flags & LKM_VALBLK && lock->ml.type != LKM_EXMODE)
+	if (flags & LKM_VALBLK && lock->ml.type != DLM_LOCK_EX)
 		flags &= ~LKM_VALBLK;
 	spin_unlock(&res->spinlock);

diff --git a/fs/ocfs2/dlm/userdlm.c b/fs/ocfs2/dlm/userdlm.c
index 4cb1d3d..6d0bd96 100644
--- a/fs/ocfs2/dlm/userdlm.c
+++ b/fs/ocfs2/dlm/userdlm.c
@@ -33,7 +33,7 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/crc32.h>
-
+#include <linux/dlmconstants.h>

 #include "cluster/nodemanager.h"
 #include "cluster/heartbeat.h"
@@ -113,12 +113,12 @@ static inline void user_recover_from_dlm_error(struct user_lock_res *lockres)
  * lock types are added. */
 static inline int user_highest_compat_lock_level(int level)
 {
-	int new_level = LKM_EXMODE;
+	int new_level = DLM_LOCK_EX;

-	if (level == LKM_EXMODE)
-		new_level = LKM_NLMODE;
-	else if (level == LKM_PRMODE)
-		new_level = LKM_PRMODE;
+	if (level == DLM_LOCK_EX)
+		new_level = DLM_LOCK_NL;
+	else if (level == DLM_LOCK_PR)
+		new_level = DLM_LOCK_PR;
 	return new_level;
 }

@@ -140,7 +140,7 @@ static void user_ast(void *opaque)
 		return;
 	}

-	mlog_bug_on_msg(lockres->l_requested == LKM_IVMODE,
+	mlog_bug_on_msg(lockres->l_requested == DLM_LOCK_IV,
 			"Lockres %.*s, requested ivmode. flags 0x%x\n",
 			lockres->l_namelen, lockres->l_name, lockres->l_flags);

@@ -148,13 +148,13 @@ static void user_ast(void *opaque)
 	if (lockres->l_requested < lockres->l_level) {
 		if (lockres->l_requested <=
 		    user_highest_compat_lock_level(lockres->l_blocking)) {
-			lockres->l_blocking = LKM_NLMODE;
+			lockres->l_blocking = DLM_LOCK_NL;
 			lockres->l_flags &= ~USER_LOCK_BLOCKED;
 		}
 	}

 	lockres->l_level = lockres->l_requested;
-	lockres->l_requested = LKM_IVMODE;
+	lockres->l_requested = DLM_LOCK_IV;
 	lockres->l_flags |= USER_LOCK_ATTACHED;
 	lockres->l_flags &= ~USER_LOCK_BUSY;

@@ -193,11 +193,11 @@ static void __user_dlm_cond_queue_lockres(struct user_lock_res *lockres)
 		return;

 	switch (lockres->l_blocking) {
-	case LKM_EXMODE:
+	case DLM_LOCK_EX:
 		if (!lockres->l_ex_holders && !lockres->l_ro_holders)
 			queue = 1;
 		break;
-	case LKM_PRMODE:
+	case DLM_LOCK_PR:
 		if (!lockres->l_ex_holders)
 			queue = 1;
 		break;
@@ -243,7 +243,7 @@ static void user_unlock_ast(void *opaque, enum dlm_status status)
 	 * for a concurrent cancel. */
 	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN
 	    && !(lockres->l_flags & USER_LOCK_IN_CANCEL)) {
-		lockres->l_level = LKM_IVMODE;
+		lockres->l_level = DLM_LOCK_IV;
 	} else if (status == DLM_CANCELGRANT) {
 		/* We tried to cancel a convert request, but it was
 		 * already granted. Don't clear the busy flag - the
@@ -254,7 +254,7 @@ static void user_unlock_ast(void *opaque, enum dlm_status status)
 	} else {
 		BUG_ON(!(lockres->l_flags & USER_LOCK_IN_CANCEL));
 		/* Cancel succeeded, we want to re-queue */
-		lockres->l_requested = LKM_IVMODE; /* cancel an
+		lockres->l_requested = DLM_LOCK_IV; /* cancel an
 						    * upconvert
 						    * request. */
 		lockres->l_flags &= ~USER_LOCK_IN_CANCEL;
@@ -335,7 +335,7 @@ static void user_dlm_unblock_lock(struct work_struct *work)
 	/* If there are still incompat holders, we can exit safely
 	 * without worrying about re-queueing this lock as that will
 	 * happen on the last call to user_cluster_unlock. */
-	if ((lockres->l_blocking == LKM_EXMODE)
+	if ((lockres->l_blocking == DLM_LOCK_EX)
 	    && (lockres->l_ex_holders || lockres->l_ro_holders)) {
 		spin_unlock(&lockres->l_lock);
 		mlog(0, "can't downconvert for ex: ro = %u, ex = %u\n",
@@ -343,7 +343,7 @@ static void user_dlm_unblock_lock(struct work_struct *work)
 		goto drop_ref;
 	}

-	if ((lockres->l_blocking == LKM_PRMODE)
+	if ((lockres->l_blocking == DLM_LOCK_PR)
 	    && lockres->l_ex_holders) {
 		spin_unlock(&lockres->l_lock);
 		mlog(0, "can't downconvert for pr: ex = %u\n",
@@ -382,10 +382,10 @@ static inline void user_dlm_inc_holders(struct user_lock_res *lockres,
 					int level)
 {
 	switch(level) {
-	case LKM_EXMODE:
+	case DLM_LOCK_EX:
 		lockres->l_ex_holders++;
 		break;
-	case LKM_PRMODE:
+	case DLM_LOCK_PR:
 		lockres->l_ro_holders++;
 		break;
 	default:
@@ -412,8 +412,8 @@ int user_dlm_cluster_lock(struct user_lock_res *lockres,
 	int status, local_flags;
 	struct dlm_ctxt *dlm = dlm_ctxt_from_user_lockres(lockres);

-	if (level != LKM_EXMODE &&
-	    level != LKM_PRMODE) {
+	if (level != DLM_LOCK_EX &&
+	    level != DLM_LOCK_PR) {
 		mlog(ML_ERROR, "lockres %.*s: invalid request!\n",
 		     lockres->l_namelen, lockres->l_name);
 		status = -EINVAL;
@@ -422,7 +422,7 @@ int user_dlm_cluster_lock(struct user_lock_res *lockres,

 	mlog(0, "lockres %.*s: asking for %s lock, passed flags = 0x%x\n",
 	     lockres->l_namelen, lockres->l_name,
-	     (level == LKM_EXMODE) ? "LKM_EXMODE" : "LKM_PRMODE",
+	     (level == DLM_LOCK_EX) ? "DLM_LOCK_EX" : "DLM_LOCK_PR",
 	     lkm_flags);

 again:
@@ -458,15 +458,15 @@ again:

 	if (level > lockres->l_level) {
 		local_flags = lkm_flags | LKM_VALBLK;
-		if (lockres->l_level != LKM_IVMODE)
+		if (lockres->l_level != DLM_LOCK_IV)
 			local_flags |= LKM_CONVERT;

 		lockres->l_requested = level;
 		lockres->l_flags |= USER_LOCK_BUSY;
 		spin_unlock(&lockres->l_lock);

-		BUG_ON(level == LKM_IVMODE);
-		BUG_ON(level == LKM_NLMODE);
+		BUG_ON(level == DLM_LOCK_IV);
+		BUG_ON(level == DLM_LOCK_NL);

 		/* call dlm_lock to upgrade lock now */
 		status = dlmlock(dlm,
@@ -506,11 +506,11 @@ static inline void user_dlm_dec_holders(struct user_lock_res *lockres,
 					int level)
 {
 	switch(level) {
-	case LKM_EXMODE:
+	case DLM_LOCK_EX:
 		BUG_ON(!lockres->l_ex_holders);
 		lockres->l_ex_holders--;
 		break;
-	case LKM_PRMODE:
+	case DLM_LOCK_PR:
 		BUG_ON(!lockres->l_ro_holders);
 		lockres->l_ro_holders--;
 		break;
@@ -522,8 +522,8 @@ static inline void user_dlm_dec_holders(struct user_lock_res *lockres,
 void user_dlm_cluster_unlock(struct user_lock_res *lockres,
 			     int level)
 {
-	if (level != LKM_EXMODE &&
-	    level != LKM_PRMODE) {
+	if (level != DLM_LOCK_EX &&
+	    level != DLM_LOCK_PR) {
 		mlog(ML_ERROR, "lockres %.*s: invalid request!\n",
 		     lockres->l_namelen, lockres->l_name);
 		return;
@@ -546,7 +546,7 @@ void user_dlm_write_lvb(struct inode *inode,

 	spin_lock(&lockres->l_lock);

-	BUG_ON(lockres->l_level < LKM_EXMODE);
+	BUG_ON(lockres->l_level < DLM_LOCK_EX);
 	memcpy(lvb, val, len);

 	spin_unlock(&lockres->l_lock);
@@ -563,7 +563,7 @@ void user_dlm_read_lvb(struct inode *inode,

 	spin_lock(&lockres->l_lock);

-	BUG_ON(lockres->l_level < LKM_PRMODE);
+	BUG_ON(lockres->l_level < DLM_LOCK_PR);
 	memcpy(val, lvb, len);

 	spin_unlock(&lockres->l_lock);
@@ -576,9 +576,9 @@ void user_dlm_lock_res_init(struct user_lock_res *lockres,

 	spin_lock_init(&lockres->l_lock);
 	init_waitqueue_head(&lockres->l_event);
-	lockres->l_level = LKM_IVMODE;
-	lockres->l_requested = LKM_IVMODE;
-	lockres->l_blocking = LKM_IVMODE;
+	lockres->l_level = DLM_LOCK_IV;
+	lockres->l_requested = DLM_LOCK_IV;
+	lockres->l_blocking = DLM_LOCK_IV;

 	/* should have been checked before getting here. */
 	BUG_ON(dentry->d_name.len >= USER_DLM_LOCK_ID_MAX_LEN);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index ec68442..b1b47bd 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -392,12 +392,12 @@ static void ocfs2_update_lock_stats(struct ocfs2_lock_res *res, int level,
 	struct timespec ts = current_kernel_time();
 	unsigned long long time = timespec_to_ns(&ts) - mw->mw_lock_start;

-	if (level == LKM_PRMODE) {
+	if (level == DLM_LOCK_PR) {
 		num = &res->l_lock_num_prmode;
 		sum = &res->l_lock_total_prmode;
 		max = &res->l_lock_max_prmode;
 		failed = &res->l_lock_num_prmode_failed;
-	} else if (level == LKM_EXMODE) {
+	} else if (level == DLM_LOCK_EX) {
 		num = &res->l_lock_num_exmode;
 		sum = &res->l_lock_total_exmode;
 		max = &res->l_lock_max_exmode;
diff --git a/fs/ocfs2/locks.c b/fs/ocfs2/locks.c
index 544ac62..eb0a42d 100644
--- a/fs/ocfs2/locks.c
+++ b/fs/ocfs2/locks.c
@@ -51,10 +51,10 @@ static int ocfs2_do_flock(struct file *file, struct inode *inode,
 	mutex_lock(&fp->fp_mutex);

 	if (lockres->l_flags & OCFS2_LOCK_ATTACHED &&
-	    lockres->l_level > LKM_NLMODE) {
+	    lockres->l_level > DLM_LOCK_NL) {
 		int old_level = 0;

-		if (lockres->l_level == LKM_EXMODE)
+		if (lockres->l_level == DLM_LOCK_EX)
 			old_level = 1;

 		if (level == old_level)
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index fcd120f..351a06f 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -35,31 +35,9 @@ struct o2dlm_private {

 static struct ocfs2_stack_plugin o2cb_stack;

-/* These should be identical */
-#if (DLM_LOCK_IV != LKM_IVMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_NL != LKM_NLMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_CR != LKM_CRMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_CW != LKM_CWMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_PR != LKM_PRMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_PW != LKM_PWMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_EX != LKM_EXMODE)
-# error Lock modes do not match
-#endif
 static inline int mode_to_o2dlm(int mode)
 {
-	BUG_ON(mode > LKM_MAXMODE);
+	BUG_ON(mode > DLM_LOCK_MAX);

 	return mode;
 }
diff --git a/include/linux/dlmconstants.h b/include/linux/dlmconstants.h
index 47bf08d..f87bbc1 100644
--- a/include/linux/dlmconstants.h
+++ b/include/linux/dlmconstants.h
@@ -33,6 +33,7 @@
 #define DLM_LOCK_PR		3	/* protected read */
 #define DLM_LOCK_PW		4	/* protected write */
 #define DLM_LOCK_EX		5	/* exclusive */
+#define DLM_LOCK_MAX		5


 /*
-- 
Coly Li
SuSE PRC Labs
