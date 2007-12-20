From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Dec 20 16:55:54 2007
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: add flock lock type
Message-ID: <20071221005542.GK13821@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This adds a new dlmglue lock type which is intended to back flock()
requests.

Since these locks are driven from userspace, usage rules are much more
liberal than the typical Ocfs2 internal cluster lock. As a result, we can't
make use of most dlmglue features - lock caching and lock level
optimizations in particular. Additionally, userspace is free to deadlock
itself, so we have to deal with that in the same way as the rest of the
kernel - by allowing a signal to abort a lock request.

In order to keep ocfs2_cluster_lock() complexity down, ocfs2_file_lock()
does it's own dlm coordination. We still use the same helper functions
though, so duplicated code is kept to a minimum.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c      |  267 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlmglue.h      |    5 +
 fs/ocfs2/file.h         |    6 +
 fs/ocfs2/ocfs2.h        |    1 +
 fs/ocfs2/ocfs2_lockid.h |    5 +
 5 files changed, 284 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4e97dcc..2a17305 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -69,6 +69,7 @@ struct ocfs2_mask_waiter {
 
 static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_inode_osb(struct ocfs2_lock_res *lockres);
+static struct ocfs2_super *ocfs2_get_file_osb(struct ocfs2_lock_res *lockres);
 
 /*
  * Return value from ->downconvert_worker functions.
@@ -258,6 +259,11 @@ static struct ocfs2_lock_res_ops ocfs2_inode_open_lops = {
 	.flags		= 0,
 };
 
+static struct ocfs2_lock_res_ops ocfs2_flock_lops = {
+	.get_osb	= ocfs2_get_file_osb,
+	.flags		= 0,
+};
+
 static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
 {
 	return lockres->l_type == OCFS2_LOCK_TYPE_META ||
@@ -316,6 +322,17 @@ static int ocfs2_meta_lock_update(struct inode *inode,
 				  struct buffer_head **bh);
 static void ocfs2_drop_osb_locks(struct ocfs2_super *osb);
 static inline int ocfs2_highest_compat_lock_level(int level);
+static void ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
+				      int new_level);
+static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
+				  struct ocfs2_lock_res *lockres,
+				  int new_level,
+				  int lvb);
+static int ocfs2_prepare_cancel_convert(struct ocfs2_super *osb,
+				        struct ocfs2_lock_res *lockres);
+static int ocfs2_cancel_convert(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres);
+
 
 static void ocfs2_build_lock_name(enum ocfs2_lock_type type,
 				  u64 blkno,
@@ -428,6 +445,13 @@ static struct ocfs2_super *ocfs2_get_inode_osb(struct ocfs2_lock_res *lockres)
 	return OCFS2_SB(inode->i_sb);
 }
 
+static struct ocfs2_super *ocfs2_get_file_osb(struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_file_private *fp = lockres->l_priv;
+
+	return OCFS2_SB(fp->fp_file->f_mapping->host->i_sb);
+}
+
 static __u64 ocfs2_get_dentry_lock_ino(struct ocfs2_lock_res *lockres)
 {
 	__be64 inode_blkno_be;
@@ -508,6 +532,21 @@ static void ocfs2_rename_lock_res_init(struct ocfs2_lock_res *res,
 				   &ocfs2_rename_lops, osb);
 }
 
+void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
+			      struct ocfs2_file_private *fp)
+{
+	struct inode *inode = fp->fp_file->f_mapping->host;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+
+	ocfs2_lock_res_init_once(lockres);
+	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_FLOCK, oi->ip_blkno,
+			      inode->i_generation, lockres->l_name);
+	ocfs2_lock_res_init_common(OCFS2_SB(inode->i_sb), lockres,
+				   OCFS2_LOCK_TYPE_FLOCK, &ocfs2_flock_lops,
+				   fp);
+	lockres->l_flags |= OCFS2_LOCK_NOCACHE;
+}
+
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 {
 	mlog_entry_void();
@@ -724,6 +763,13 @@ static void ocfs2_blocking_ast(void *opaque, int level)
 	     lockres->l_name, level, lockres->l_level,
 	     ocfs2_lock_type_string(lockres->l_type));
 
+	/*
+	 * We can skip the bast for locks which don't enable caching -
+	 * they'll be dropped at the earliest possible time anyway.
+	 */
+	if (lockres->l_flags & OCFS2_LOCK_NOCACHE)
+		return;
+
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	needs_downconvert = ocfs2_generic_handle_bast(lockres, level);
 	if (needs_downconvert)
@@ -935,6 +981,21 @@ static int lockres_remove_mask_waiter(struct ocfs2_lock_res *lockres,
 
 }
 
+static int ocfs2_wait_for_mask_interruptible(struct ocfs2_mask_waiter *mw,
+					     struct ocfs2_lock_res *lockres)
+{
+	int ret;
+
+	ret = wait_for_completion_interruptible(&mw->mw_complete);
+	if (ret)
+		lockres_remove_mask_waiter(lockres, mw);
+	else
+		ret = mw->mw_status;
+	/* Re-arm the completion in case we want to wait on it again */
+	INIT_COMPLETION(mw->mw_complete);
+	return ret;
+}
+
 static int ocfs2_cluster_lock(struct ocfs2_super *osb,
 			      struct ocfs2_lock_res *lockres,
 			      int level,
@@ -1372,6 +1433,212 @@ int ocfs2_data_lock_with_page(struct inode *inode,
 	return ret;
 }
 
+static int ocfs2_flock_handle_signal(struct ocfs2_lock_res *lockres,
+				     int level)
+{
+	int ret;
+	struct ocfs2_super *osb = ocfs2_get_lockres_osb(lockres);
+	unsigned long flags;
+	struct ocfs2_mask_waiter mw;
+
+	ocfs2_init_mask_waiter(&mw);
+
+retry_cancel:
+	spin_lock_irqsave(&lockres->l_lock, flags);
+	if (lockres->l_flags & OCFS2_LOCK_BUSY) {
+		ret = ocfs2_prepare_cancel_convert(osb, lockres);
+		if (ret) {
+			spin_unlock_irqrestore(&lockres->l_lock, flags);
+			ret = ocfs2_cancel_convert(osb, lockres);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto out;
+			}
+			goto retry_cancel;
+		}
+		lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
+		spin_unlock_irqrestore(&lockres->l_lock, flags);
+
+		ocfs2_wait_for_mask(&mw);
+		goto retry_cancel;
+	}
+
+	ret = -ERESTARTSYS;
+	/*
+	 * We may still have gotten the lock, in which case there's no
+	 * point to restarting the syscall.
+	 */
+	if (lockres->l_level == level)
+		ret = 0;
+
+	mlog(0, "Cancel returning %d. flags: 0x%lx, level: %d, act: %d\n", ret,
+	     lockres->l_flags, lockres->l_level, lockres->l_action);
+
+	spin_unlock_irqrestore(&lockres->l_lock, flags);
+
+out:
+	return ret;
+}
+
+/*
+ * ocfs2_file_lock() and ocfs2_file_unlock() map to a single pair of
+ * flock() calls. The locking approach this requires is sufficiently
+ * different from all other cluster lock types that we implement a
+ * seperate path to the "low-level" dlm calls. In particular:
+ *
+ * - No optimization of lock levels is done - we take at exactly
+ *   what's been requested.
+ *
+ * - No lock caching is employed. We immediately downconvert to
+ *   no-lock at unlock time. This also means flock locks never go on
+ *   the blocking list).
+ *
+ * - Since userspace can trivially deadlock itself with flock, we make
+ *   sure to allow cancellation of a misbehaving applications flock()
+ *   request.
+ *
+ * - Access to any flock lockres doesn't require concurrency, so we
+ *   can simplify the code by requiring the caller to guarantee
+ *   serialization of dlmglue flock calls.
+ */
+int ocfs2_file_lock(struct file *file, int ex, int trylock)
+{
+	int ret, level = ex ? LKM_EXMODE : LKM_PRMODE;
+	unsigned int lkm_flags = trylock ? LKM_NOQUEUE : 0;
+	unsigned long flags;
+	struct ocfs2_file_private *fp = file->private_data;
+	struct ocfs2_lock_res *lockres = &fp->fp_flock;
+	struct ocfs2_super *osb = OCFS2_SB(file->f_mapping->host->i_sb);
+	struct ocfs2_mask_waiter mw;
+
+	ocfs2_init_mask_waiter(&mw);
+
+	if ((lockres->l_flags & OCFS2_LOCK_BUSY) ||
+	    (lockres->l_level > LKM_NLMODE)) {
+		mlog(ML_ERROR,
+		     "File lock \"%s\" has busy or locked state: flags: 0x%lx, "
+		     "level: %u\n", lockres->l_name, lockres->l_flags,
+		     lockres->l_level);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&lockres->l_lock, flags);
+	if (!(lockres->l_flags & OCFS2_LOCK_ATTACHED)) {
+		lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
+		spin_unlock_irqrestore(&lockres->l_lock, flags);
+
+		/*
+		 * Get the lock at NLMODE to start - that way we
+		 * can cancel the upconvert request if need be.
+		 */
+		ret = ocfs2_lock_create(osb, lockres, LKM_NLMODE, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_wait_for_mask(&mw);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+		spin_lock_irqsave(&lockres->l_lock, flags);
+	}
+
+	lockres->l_action = OCFS2_AST_CONVERT;
+	lkm_flags |= LKM_CONVERT;
+	lockres->l_requested = level;
+	lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
+
+	lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
+	spin_unlock_irqrestore(&lockres->l_lock, flags);
+
+	ret = dlmlock(osb->dlm, level, &lockres->l_lksb, lkm_flags,
+		      lockres->l_name, OCFS2_LOCK_ID_MAX_LEN - 1,
+		      ocfs2_locking_ast, lockres, ocfs2_blocking_ast);
+	if (ret != DLM_NORMAL) {
+		if (trylock && ret == DLM_NOTQUEUED)
+			ret = -EAGAIN;
+		else {
+			ocfs2_log_dlm_error("dlmlock", ret, lockres);
+			ret = -EINVAL;
+		}
+
+		ocfs2_recover_from_dlm_error(lockres, 1);
+		lockres_remove_mask_waiter(lockres, &mw);
+		goto out;
+	}
+
+	ret = ocfs2_wait_for_mask_interruptible(&mw, lockres);
+	if (ret == -ERESTARTSYS) {
+		/*
+		 * Userspace can cause deadlock itself with
+		 * flock(). Current behavior locally is to allow the
+		 * deadlock, but abort the system call if a signal is
+		 * received. We follow this example, otherwise a
+		 * poorly written program could sit in kernel until
+		 * reboot.
+		 *
+		 * Handling this is a bit more complicated for Ocfs2
+		 * though. We can't exit this function with an
+		 * outstanding lock request, so a cancel convert is
+		 * required. We intentionally overwrite 'ret' - if the
+		 * cancel fails and the lock was granted, it's easier
+		 * to just bubble sucess back up to the user.
+		 */
+		ret = ocfs2_flock_handle_signal(lockres, level);
+	}
+
+out:
+
+	mlog(0, "Lock: \"%s\" ex: %d, trylock: %d, returns: %d\n",
+	     lockres->l_name, ex, trylock, ret);
+	return ret;
+}
+
+void ocfs2_file_unlock(struct file *file)
+{
+	int ret;
+	unsigned long flags;
+	struct ocfs2_file_private *fp = file->private_data;
+	struct ocfs2_lock_res *lockres = &fp->fp_flock;
+	struct ocfs2_super *osb = OCFS2_SB(file->f_mapping->host->i_sb);
+	struct ocfs2_mask_waiter mw;
+
+	ocfs2_init_mask_waiter(&mw);
+
+	if (!(lockres->l_flags & OCFS2_LOCK_ATTACHED))
+		return;
+
+	if (lockres->l_level == LKM_NLMODE)
+		return;
+
+	mlog(0, "Unlock: \"%s\" flags: 0x%lx, level: %d, act: %d\n",
+	     lockres->l_name, lockres->l_flags, lockres->l_level,
+	     lockres->l_action);
+
+	spin_lock_irqsave(&lockres->l_lock, flags);
+	/*
+	 * Fake a blocking ast for the downconvert code.
+	 */
+	lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
+	lockres->l_blocking = LKM_EXMODE;
+
+	ocfs2_prepare_downconvert(lockres, LKM_NLMODE);
+	lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
+	spin_unlock_irqrestore(&lockres->l_lock, flags);
+
+	ret = ocfs2_downconvert_lock(osb, lockres, LKM_NLMODE, 0);
+	if (ret) {
+		mlog_errno(ret);
+		return;
+	}
+
+	ret = ocfs2_wait_for_mask(&mw);
+	if (ret)
+		mlog_errno(ret);
+}
+
 static void ocfs2_vote_on_unlock(struct ocfs2_super *osb,
 				 struct ocfs2_lock_res *lockres)
 {
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 87a785e..5a58f8b 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -66,6 +66,9 @@ void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
 			       struct inode *inode);
 void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
 				u64 parent, struct inode *inode);
+struct ocfs2_file_private;
+void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
+			      struct ocfs2_file_private *fp);
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res);
 int ocfs2_create_new_inode_locks(struct inode *inode);
 int ocfs2_drop_inode_locks(struct inode *inode);
@@ -107,6 +110,8 @@ int ocfs2_rename_lock(struct ocfs2_super *osb);
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
 int ocfs2_dentry_lock(struct dentry *dentry, int ex);
 void ocfs2_dentry_unlock(struct dentry *dentry, int ex);
+int ocfs2_file_lock(struct file *file, int ex, int trylock);
+void ocfs2_file_unlock(struct file *file);
 
 void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
 void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 066f14a..048ddca 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -32,6 +32,12 @@ extern const struct inode_operations ocfs2_file_iops;
 extern const struct inode_operations ocfs2_special_file_iops;
 struct ocfs2_alloc_context;
 
+struct ocfs2_file_private {
+	struct file		*fp_file;
+	struct mutex		fp_mutex;
+	struct ocfs2_lock_res	fp_flock;
+};
+
 enum ocfs2_alloc_restarted {
 	RESTART_NONE = 0,
 	RESTART_TRANS,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 60a23e1..9c34b83 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -101,6 +101,7 @@ enum ocfs2_unlock_action {
 					       * about to be
 					       * dropped. */
 #define OCFS2_LOCK_QUEUED        (0x00000100) /* queued for downconvert */
+#define OCFS2_LOCK_NOCACHE       (0x00000200) /* don't use a holder count */
 
 struct ocfs2_lock_res_ops;
 
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index 4ca02b1..86f3e37 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -45,6 +45,7 @@ enum ocfs2_lock_type {
 	OCFS2_LOCK_TYPE_RW,
 	OCFS2_LOCK_TYPE_DENTRY,
 	OCFS2_LOCK_TYPE_OPEN,
+	OCFS2_LOCK_TYPE_FLOCK,
 	OCFS2_NUM_LOCK_TYPES
 };
 
@@ -73,6 +74,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
 		case OCFS2_LOCK_TYPE_OPEN:
 			c = 'O';
 			break;
+		case OCFS2_LOCK_TYPE_FLOCK:
+			c = 'F';
+			break;
 		default:
 			c = '\0';
 	}
@@ -90,6 +94,7 @@ static char *ocfs2_lock_type_strings[] = {
 	[OCFS2_LOCK_TYPE_RW] = "Write/Read",
 	[OCFS2_LOCK_TYPE_DENTRY] = "Dentry",
 	[OCFS2_LOCK_TYPE_OPEN] = "Open",
+	[OCFS2_LOCK_TYPE_FLOCK] = "Flock",
 };
 
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
-- 
1.5.3.6
