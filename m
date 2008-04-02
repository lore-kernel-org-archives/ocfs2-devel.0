From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:19 -0700
Subject: [Ocfs2-devel] [PATCH 09/62] ocfs2: Use global DLM_ constants in
	generic code.
In-Reply-To: <12071673341888-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
Message-ID: <12071673362069-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

The ocfs2 generic code should use the values in <linux/dlmconstants.h>.
stackglue.c will convert them to o2dlm values.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c   |  140 +++++++++++++++++++++++++-------------------------
 fs/ocfs2/stackglue.c |   71 +++++++++++++++++++++++---
 fs/ocfs2/stackglue.h |   13 +++++
 3 files changed, 147 insertions(+), 77 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index aea3bef..b8ac903 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -37,8 +37,6 @@
 #include <cluster/nodemanager.h>
 #include <cluster/tcp.h>
 
-#include <dlm/dlmapi.h>
-
 #define MLOG_MASK_PREFIX ML_DLM_GLUE
 #include <cluster/masklog.h>
 
@@ -317,7 +315,7 @@ static inline struct ocfs2_super *ocfs2_get_lockres_osb(struct ocfs2_lock_res *l
 static int ocfs2_lock_create(struct ocfs2_super *osb,
 			     struct ocfs2_lock_res *lockres,
 			     int level,
-			     int dlm_flags);
+			     u32 dlm_flags);
 static inline int ocfs2_may_continue_on_blocked_lock(struct ocfs2_lock_res *lockres,
 						     int wanted);
 static void ocfs2_cluster_unlock(struct ocfs2_super *osb,
@@ -407,9 +405,9 @@ static void ocfs2_lock_res_init_common(struct ocfs2_super *osb,
 	res->l_ops           = ops;
 	res->l_priv          = priv;
 
-	res->l_level         = LKM_IVMODE;
-	res->l_requested     = LKM_IVMODE;
-	res->l_blocking      = LKM_IVMODE;
+	res->l_level         = DLM_LOCK_IV;
+	res->l_requested     = DLM_LOCK_IV;
+	res->l_blocking      = DLM_LOCK_IV;
 	res->l_action        = OCFS2_AST_INVALID;
 	res->l_unlock_action = OCFS2_UNLOCK_INVALID;
 
@@ -605,10 +603,10 @@ static inline void ocfs2_inc_holders(struct ocfs2_lock_res *lockres,
 	BUG_ON(!lockres);
 
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
@@ -626,11 +624,11 @@ static inline void ocfs2_dec_holders(struct ocfs2_lock_res *lockres,
 	BUG_ON(!lockres);
 
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
@@ -645,12 +643,12 @@ static inline void ocfs2_dec_holders(struct ocfs2_lock_res *lockres,
  * lock types are added. */
 static inline int ocfs2_highest_compat_lock_level(int level)
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
 
@@ -689,12 +687,12 @@ static inline void ocfs2_generic_handle_downconvert_action(struct ocfs2_lock_res
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BUSY));
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_ATTACHED));
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BLOCKED));
-	BUG_ON(lockres->l_blocking <= LKM_NLMODE);
+	BUG_ON(lockres->l_blocking <= DLM_LOCK_NL);
 
 	lockres->l_level = lockres->l_requested;
 	if (lockres->l_level <=
 	    ocfs2_highest_compat_lock_level(lockres->l_blocking)) {
-		lockres->l_blocking = LKM_NLMODE;
+		lockres->l_blocking = DLM_LOCK_NL;
 		lockres_clear_flags(lockres, OCFS2_LOCK_BLOCKED);
 	}
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
@@ -713,7 +711,7 @@ static inline void ocfs2_generic_handle_convert_action(struct ocfs2_lock_res *lo
 	 * information is already up to data. Convert from NL to
 	 * *anything* however should mark ourselves as needing an
 	 * update */
-	if (lockres->l_level == LKM_NLMODE &&
+	if (lockres->l_level == DLM_LOCK_NL &&
 	    lockres->l_ops->flags & LOCK_TYPE_REQUIRES_REFRESH)
 		lockres_or_flags(lockres, OCFS2_LOCK_NEEDS_REFRESH);
 
@@ -730,7 +728,7 @@ static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *loc
 	BUG_ON((!(lockres->l_flags & OCFS2_LOCK_BUSY)));
 	BUG_ON(lockres->l_flags & OCFS2_LOCK_ATTACHED);
 
-	if (lockres->l_requested > LKM_NLMODE &&
+	if (lockres->l_requested > DLM_LOCK_NL &&
 	    !(lockres->l_flags & OCFS2_LOCK_LOCAL) &&
 	    lockres->l_ops->flags & LOCK_TYPE_REQUIRES_REFRESH)
 		lockres_or_flags(lockres, OCFS2_LOCK_NEEDS_REFRESH);
@@ -775,7 +773,7 @@ static void ocfs2_blocking_ast(void *opaque, int level)
 	int needs_downconvert;
 	unsigned long flags;
 
-	BUG_ON(level <= LKM_NLMODE);
+	BUG_ON(level <= DLM_LOCK_NL);
 
 	mlog(0, "BAST fired for lockres %s, blocking %d, level %d type %s\n",
 	     lockres->l_name, level, lockres->l_level,
@@ -866,7 +864,7 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 static int ocfs2_lock_create(struct ocfs2_super *osb,
 			     struct ocfs2_lock_res *lockres,
 			     int level,
-			     int dlm_flags)
+			     u32 dlm_flags)
 {
 	int ret = 0;
 	enum dlm_status status = DLM_NORMAL;
@@ -874,7 +872,7 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 
 	mlog_entry_void();
 
-	mlog(0, "lock %s, level = %d, flags = %d\n", lockres->l_name, level,
+	mlog(0, "lock %s, level = %d, flags = %u\n", lockres->l_name, level,
 	     dlm_flags);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
@@ -1016,7 +1014,7 @@ static int ocfs2_wait_for_mask_interruptible(struct ocfs2_mask_waiter *mw,
 static int ocfs2_cluster_lock(struct ocfs2_super *osb,
 			      struct ocfs2_lock_res *lockres,
 			      int level,
-			      int lkm_flags,
+			      u32 lkm_flags,
 			      int arg_flags)
 {
 	struct ocfs2_mask_waiter mw;
@@ -1030,7 +1028,7 @@ static int ocfs2_cluster_lock(struct ocfs2_super *osb,
 	ocfs2_init_mask_waiter(&mw);
 
 	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
-		lkm_flags |= LKM_VALBLK;
+		lkm_flags |= DLM_LKF_VALBLK;
 
 again:
 	wait = 0;
@@ -1074,18 +1072,18 @@ again:
 
 		if (!(lockres->l_flags & OCFS2_LOCK_ATTACHED)) {
 			lockres->l_action = OCFS2_AST_ATTACH;
-			lkm_flags &= ~LKM_CONVERT;
+			lkm_flags &= ~DLM_LKF_CONVERT;
 		} else {
 			lockres->l_action = OCFS2_AST_CONVERT;
-			lkm_flags |= LKM_CONVERT;
+			lkm_flags |= DLM_LKF_CONVERT;
 		}
 
 		lockres->l_requested = level;
 		lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
 
-		BUG_ON(level == LKM_IVMODE);
-		BUG_ON(level == LKM_NLMODE);
+		BUG_ON(level == DLM_LOCK_IV);
+		BUG_ON(level == DLM_LOCK_NL);
 
 		mlog(0, "lock %s, convert from %d to level = %d\n",
 		     lockres->l_name, lockres->l_level, level);
@@ -1099,7 +1097,7 @@ again:
 					OCFS2_LOCK_ID_MAX_LEN - 1,
 					lockres);
 		if (status != DLM_NORMAL) {
-			if ((lkm_flags & LKM_NOQUEUE) &&
+			if ((lkm_flags & DLM_LKF_NOQUEUE) &&
 			    (status == DLM_NOTQUEUED))
 				ret = -EAGAIN;
 			else {
@@ -1175,9 +1173,9 @@ static int ocfs2_create_new_lock(struct ocfs2_super *osb,
 				 int ex,
 				 int local)
 {
-	int level =  ex ? LKM_EXMODE : LKM_PRMODE;
+	int level =  ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	unsigned long flags;
-	int lkm_flags = local ? LKM_LOCAL : 0;
+	u32 lkm_flags = local ? DLM_LKF_LOCAL : 0;
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	BUG_ON(lockres->l_flags & OCFS2_LOCK_ATTACHED);
@@ -1220,7 +1218,7 @@ int ocfs2_create_new_inode_locks(struct inode *inode)
 	}
 
 	/*
-	 * We don't want to use LKM_LOCAL on a meta data lock as they
+	 * We don't want to use DLM_LKF_LOCAL on a meta data lock as they
 	 * don't use a generation in their lock names.
 	 */
 	ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_inode_lockres, 1, 0);
@@ -1259,7 +1257,7 @@ int ocfs2_rw_lock(struct inode *inode, int write)
 
 	lockres = &OCFS2_I(inode)->ip_rw_lockres;
 
-	level = write ? LKM_EXMODE : LKM_PRMODE;
+	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
 
 	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres, level, 0,
 				    0);
@@ -1272,7 +1270,7 @@ int ocfs2_rw_lock(struct inode *inode, int write)
 
 void ocfs2_rw_unlock(struct inode *inode, int write)
 {
-	int level = write ? LKM_EXMODE : LKM_PRMODE;
+	int level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
 	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_rw_lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
@@ -1310,7 +1308,7 @@ int ocfs2_open_lock(struct inode *inode)
 	lockres = &OCFS2_I(inode)->ip_open_lockres;
 
 	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
-				    LKM_PRMODE, 0, 0);
+				    DLM_LOCK_PR, 0, 0);
 	if (status < 0)
 		mlog_errno(status);
 
@@ -1338,16 +1336,16 @@ int ocfs2_try_open_lock(struct inode *inode, int write)
 
 	lockres = &OCFS2_I(inode)->ip_open_lockres;
 
-	level = write ? LKM_EXMODE : LKM_PRMODE;
+	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
 
 	/*
 	 * The file system may already holding a PRMODE/EXMODE open lock.
-	 * Since we pass LKM_NOQUEUE, the request won't block waiting on
+	 * Since we pass DLM_LKF_NOQUEUE, the request won't block waiting on
 	 * other nodes and the -EAGAIN will indicate to the caller that
 	 * this inode is still in use.
 	 */
 	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
-				    level, LKM_NOQUEUE, 0);
+				    level, DLM_LKF_NOQUEUE, 0);
 
 out:
 	mlog_exit(status);
@@ -1372,10 +1370,10 @@ void ocfs2_open_unlock(struct inode *inode)
 
 	if(lockres->l_ro_holders)
 		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
-				     LKM_PRMODE);
+				     DLM_LOCK_PR);
 	if(lockres->l_ex_holders)
 		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
-				     LKM_EXMODE);
+				     DLM_LOCK_EX);
 
 out:
 	mlog_exit_void();
@@ -1462,7 +1460,7 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 	ocfs2_init_mask_waiter(&mw);
 
 	if ((lockres->l_flags & OCFS2_LOCK_BUSY) ||
-	    (lockres->l_level > LKM_NLMODE)) {
+	    (lockres->l_level > DLM_LOCK_NL)) {
 		mlog(ML_ERROR,
 		     "File lock \"%s\" has busy or locked state: flags: 0x%lx, "
 		     "level: %u\n", lockres->l_name, lockres->l_flags,
@@ -1570,7 +1568,7 @@ void ocfs2_file_unlock(struct file *file)
 	 * Fake a blocking ast for the downconvert code.
 	 */
 	lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
-	lockres->l_blocking = LKM_EXMODE;
+	lockres->l_blocking = DLM_LOCK_EX;
 
 	ocfs2_prepare_downconvert(lockres, LKM_NLMODE);
 	lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
@@ -1599,11 +1597,11 @@ static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
 	 * condition. */
 	if (lockres->l_flags & OCFS2_LOCK_BLOCKED) {
 		switch(lockres->l_blocking) {
-		case LKM_EXMODE:
+		case DLM_LOCK_EX:
 			if (!lockres->l_ex_holders && !lockres->l_ro_holders)
 				kick = 1;
 			break;
-		case LKM_PRMODE:
+		case DLM_LOCK_PR:
 			if (!lockres->l_ex_holders)
 				kick = 1;
 			break;
@@ -1921,7 +1919,8 @@ int ocfs2_inode_lock_full(struct inode *inode,
 			 int ex,
 			 int arg_flags)
 {
-	int status, level, dlm_flags, acquired;
+	int status, level, acquired;
+	u32 dlm_flags;
 	struct ocfs2_lock_res *lockres = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *local_bh = NULL;
@@ -1951,10 +1950,10 @@ int ocfs2_inode_lock_full(struct inode *inode,
 		ocfs2_wait_for_recovery(osb);
 
 	lockres = &OCFS2_I(inode)->ip_inode_lockres;
-	level = ex ? LKM_EXMODE : LKM_PRMODE;
+	level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	dlm_flags = 0;
 	if (arg_flags & OCFS2_META_LOCK_NOQUEUE)
-		dlm_flags |= LKM_NOQUEUE;
+		dlm_flags |= DLM_LKF_NOQUEUE;
 
 	status = ocfs2_cluster_lock(osb, lockres, level, dlm_flags, arg_flags);
 	if (status < 0) {
@@ -2105,7 +2104,7 @@ int ocfs2_inode_lock_atime(struct inode *inode,
 void ocfs2_inode_unlock(struct inode *inode,
 		       int ex)
 {
-	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_inode_lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
@@ -2126,7 +2125,7 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 		     int ex)
 {
 	int status = 0;
-	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	struct ocfs2_lock_res *lockres = &osb->osb_super_lockres;
 
 	mlog_entry_void();
@@ -2168,7 +2167,7 @@ bail:
 void ocfs2_super_unlock(struct ocfs2_super *osb,
 			int ex)
 {
-	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	struct ocfs2_lock_res *lockres = &osb->osb_super_lockres;
 
 	if (!ocfs2_mount_local(osb))
@@ -2186,7 +2185,7 @@ int ocfs2_rename_lock(struct ocfs2_super *osb)
 	if (ocfs2_mount_local(osb))
 		return 0;
 
-	status = ocfs2_cluster_lock(osb, lockres, LKM_EXMODE, 0, 0);
+	status = ocfs2_cluster_lock(osb, lockres, DLM_LOCK_EX, 0, 0);
 	if (status < 0)
 		mlog_errno(status);
 
@@ -2198,13 +2197,13 @@ void ocfs2_rename_unlock(struct ocfs2_super *osb)
 	struct ocfs2_lock_res *lockres = &osb->osb_rename_lockres;
 
 	if (!ocfs2_mount_local(osb))
-		ocfs2_cluster_unlock(osb, lockres, LKM_EXMODE);
+		ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_EX);
 }
 
 int ocfs2_dentry_lock(struct dentry *dentry, int ex)
 {
 	int ret;
-	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
 	struct ocfs2_super *osb = OCFS2_SB(dentry->d_sb);
 
@@ -2225,7 +2224,7 @@ int ocfs2_dentry_lock(struct dentry *dentry, int ex)
 
 void ocfs2_dentry_unlock(struct dentry *dentry, int ex)
 {
-	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
 	struct ocfs2_super *osb = OCFS2_SB(dentry->d_sb);
 
@@ -2614,7 +2613,7 @@ static void ocfs2_unlock_ast(void *opaque, enum dlm_status status)
 		lockres->l_action = OCFS2_AST_INVALID;
 		break;
 	case OCFS2_UNLOCK_DROP_LOCK:
-		lockres->l_level = LKM_IVMODE;
+		lockres->l_level = DLM_LOCK_IV;
 		break;
 	default:
 		BUG();
@@ -2635,14 +2634,14 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 {
 	enum dlm_status status;
 	unsigned long flags;
-	int lkm_flags = 0;
+	u32 lkm_flags = 0;
 
 	/* We didn't get anywhere near actually using this lockres. */
 	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED))
 		goto out;
 
 	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
-		lkm_flags |= LKM_VALBLK;
+		lkm_flags |= DLM_LKF_VALBLK;
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 
@@ -2668,7 +2667,7 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 
 	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB) {
 		if (lockres->l_flags & OCFS2_LOCK_ATTACHED &&
-		    lockres->l_level == LKM_EXMODE &&
+		    lockres->l_level == DLM_LOCK_EX &&
 		    !(lockres->l_flags & OCFS2_LOCK_NEEDS_REFRESH))
 			lockres->l_ops->set_lvb(lockres);
 	}
@@ -2801,10 +2800,10 @@ static void ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
 {
 	assert_spin_locked(&lockres->l_lock);
 
-	BUG_ON(lockres->l_blocking <= LKM_NLMODE);
+	BUG_ON(lockres->l_blocking <= DLM_LOCK_NL);
 
 	if (lockres->l_level <= new_level) {
-		mlog(ML_ERROR, "lockres->l_level (%u) <= new_level (%u)\n",
+		mlog(ML_ERROR, "lockres->l_level (%d) <= new_level (%d)\n",
 		     lockres->l_level, new_level);
 		BUG();
 	}
@@ -2822,13 +2821,14 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 				  int new_level,
 				  int lvb)
 {
-	int ret, dlm_flags = LKM_CONVERT;
+	int ret;
+	u32 dlm_flags = DLM_LKF_CONVERT;
 	enum dlm_status status;
 
 	mlog_entry_void();
 
 	if (lvb)
-		dlm_flags |= LKM_VALBLK;
+		dlm_flags |= DLM_LKF_VALBLK;
 
 	status = ocfs2_dlm_lock(osb->dlm,
 				new_level,
@@ -2894,7 +2894,7 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 	ret = 0;
 	status = ocfs2_dlm_unlock(osb->dlm,
 				  &lockres->l_lksb,
-				  LKM_CANCEL,
+				  DLM_LKF_CANCEL,
 				  lockres);
 	if (status != DLM_NORMAL) {
 		ocfs2_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
@@ -2939,13 +2939,13 @@ recheck:
 
 	/* if we're blocking an exclusive and we have *any* holders,
 	 * then requeue. */
-	if ((lockres->l_blocking == LKM_EXMODE)
+	if ((lockres->l_blocking == DLM_LOCK_EX)
 	    && (lockres->l_ex_holders || lockres->l_ro_holders))
 		goto leave_requeue;
 
 	/* If it's a PR we're blocking, then only
 	 * requeue if we've got any EX holders */
-	if (lockres->l_blocking == LKM_PRMODE &&
+	if (lockres->l_blocking == DLM_LOCK_PR &&
 	    lockres->l_ex_holders)
 		goto leave_requeue;
 
@@ -2992,7 +2992,7 @@ downconvert:
 	ctl->requeue = 0;
 
 	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB) {
-		if (lockres->l_level == LKM_EXMODE)
+		if (lockres->l_level == DLM_LOCK_EX)
 			set_lvb = 1;
 
 		/*
@@ -3046,7 +3046,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 	}
 	sync_mapping_buffers(mapping);
-	if (blocking == LKM_EXMODE) {
+	if (blocking == DLM_LOCK_EX) {
 		truncate_inode_pages(mapping, 0);
 	} else {
 		/* We only need to wait on the I/O if we're not also
@@ -3067,8 +3067,8 @@ static int ocfs2_check_meta_downconvert(struct ocfs2_lock_res *lockres,
 	struct inode *inode = ocfs2_lock_res_inode(lockres);
 	int checkpointed = ocfs2_inode_fully_checkpointed(inode);
 
-	BUG_ON(new_level != LKM_NLMODE && new_level != LKM_PRMODE);
-	BUG_ON(lockres->l_level != LKM_EXMODE && !checkpointed);
+	BUG_ON(new_level != DLM_LOCK_NL && new_level != DLM_LOCK_PR);
+	BUG_ON(lockres->l_level != DLM_LOCK_EX && !checkpointed);
 
 	if (checkpointed)
 		return 1;
@@ -3132,7 +3132,7 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 	 * valid. The downconvert code will retain a PR for this node,
 	 * so there's no further work to do.
 	 */
-	if (blocking == LKM_PRMODE)
+	if (blocking == DLM_LOCK_PR)
 		return UNBLOCK_CONTINUE;
 
 	/*
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 4f44f23..9953804 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -18,15 +18,65 @@
  * General Public License for more details.
  */
 
-#include <linux/types.h>
-#include <linux/list.h>
-
-#include "dlm/dlmapi.h"
-
 #include "stackglue.h"
 
 static struct ocfs2_locking_protocol *lproto;
 
+/* These should be identical */
+#if (DLM_LOCK_IV != LKM_IVMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_NL != LKM_NLMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_CR != LKM_CRMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_CW != LKM_CWMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_PR != LKM_PRMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_PW != LKM_PWMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_EX != LKM_EXMODE)
+# error Lock modes do not match
+#endif
+static inline int mode_to_o2dlm(int mode)
+{
+	BUG_ON(mode > LKM_MAXMODE);
+
+	return mode;
+}
+
+#define map_flag(_generic, _o2dlm)		\
+	if (flags & (_generic)) {		\
+		flags &= ~(_generic);		\
+		o2dlm_flags |= (_o2dlm);	\
+	}
+static int flags_to_o2dlm(u32 flags)
+{
+	int o2dlm_flags = 0;
+
+	map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
+	map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
+	map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
+	map_flag(DLM_LKF_VALBLK, LKM_VALBLK);
+	map_flag(DLM_LKF_IVVALBLK, LKM_INVVALBLK);
+	map_flag(DLM_LKF_ORPHAN, LKM_ORPHAN);
+	map_flag(DLM_LKF_FORCEUNLOCK, LKM_FORCE);
+	map_flag(DLM_LKF_TIMEOUT, LKM_TIMEOUT);
+	map_flag(DLM_LKF_LOCAL, LKM_LOCAL);
+
+	/* map_flag() should have cleared every flag passed in */
+	BUG_ON(flags != 0);
+
+	return o2dlm_flags;
+}
+#undef map_flag
+
 enum dlm_status ocfs2_dlm_lock(struct dlm_ctxt *dlm,
 		   int mode,
 		   struct dlm_lockstatus *lksb,
@@ -35,8 +85,12 @@ enum dlm_status ocfs2_dlm_lock(struct dlm_ctxt *dlm,
 		   unsigned int namelen,
 		   void *astarg)
 {
+	int o2dlm_mode = mode_to_o2dlm(mode);
+	int o2dlm_flags = flags_to_o2dlm(flags);
+
 	BUG_ON(lproto == NULL);
-	return dlmlock(dlm, mode, lksb, flags, name, namelen,
+
+	return dlmlock(dlm, o2dlm_mode, lksb, o2dlm_flags, name, namelen,
 		       lproto->lp_lock_ast, astarg,
 		       lproto->lp_blocking_ast);
 }
@@ -46,9 +100,12 @@ enum dlm_status ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
 		     u32 flags,
 		     void *astarg)
 {
+	int o2dlm_flags = flags_to_o2dlm(flags);
+
 	BUG_ON(lproto == NULL);
 
-	return dlmunlock(dlm, lksb, flags, lproto->lp_unlock_ast, astarg);
+	return dlmunlock(dlm, lksb, o2dlm_flags,
+			 lproto->lp_unlock_ast, astarg);
 }
 
 
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 40a0024..986d059 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -21,6 +21,19 @@
 #ifndef STACKGLUE_H
 #define STACKGLUE_H
 
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/dlmconstants.h>
+
+/*
+ * dlmconstants.h does not have a LOCAL flag.  We hope to remove it
+ * some day, but right now we need it.  Let's fake it.  This value is larger
+ * than any flag in dlmconstants.h.
+ */
+#define DLM_LKF_LOCAL		0x00100000
+
+#include "dlm/dlmapi.h"
+
 struct ocfs2_locking_protocol {
 	void (*lp_lock_ast)(void *astarg);
 	void (*lp_blocking_ast)(void *astarg, int level);
-- 
1.5.4.1
