From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 30 Mar 2010 12:29:29 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work -v4
Message-ID: <201003300431.o2U1vol8024322@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds freeze_fs()/unfreeze_fs() for ocfs2 so that it supports freeze/thaw.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c |  116 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/dlmglue.h |    2 +
 fs/ocfs2/journal.c |    1 +
 fs/ocfs2/ocfs2.h   |   12 +++++
 fs/ocfs2/super.c   |  130 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 259 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index d7a9330..455b16f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3761,10 +3761,124 @@ static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
 	ocfs2_dentry_lock_put(osb, dl);
 }
 
+/*
+ * This is only ever run on behalf of another node.
+ */
+void ocfs2_freeze_worker(struct work_struct *work)
+{
+	struct super_block *sb;
+	int ret, do_unlock = 0;
+	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
+					       osb_freeze_work);
+
+	mlog(0, "flags=0x%lx, frozen=%d\n", osb->osb_flags, osb->sb->s_frozen);
+
+	/* If umount is in progress, wait it to complete. */
+	ret = ocfs2_test_osb_flag(osb, OCFS2_OSB_UMOUNT_INPROG);
+	if (ret) {
+		mlog(0, "Unmount in progress, make the freeze request pending"
+		     "\n");
+		/* Leave FREEZE_INPROG there so not queue the worker again */
+		return;
+	}
+
+	sb = freeze_bdev(osb->sb->s_bdev);
+	if (IS_ERR(sb)) {
+		/* ocfs2_freeze_fs() shouldn't return any error in the remote
+		 * box. If it does it's a bug. But we deal with it gracefully.
+		 */
+		ret = PTR_ERR(sb);
+		mlog_errno(ret);
+		ocfs2_clear_osb_flag(osb, OCFS2_OSB_FREEZE_INPROG);
+		return;
+	}
+
+	spin_lock(&osb->osb_lock);
+	osb->osb_flags &= ~OCFS2_OSB_FREEZE_INPROG;
+	osb->osb_flags |= OCFS2_OSB_FROZEN_BY_REMOTE;
+	spin_unlock(&osb->osb_lock);
+
+	ocfs2_wake_downconvert_thread(osb);
+
+	/* Waits for thaw */
+wait_thaw:
+	/* thaws the fs if unmount is in progress. */
+	ret = ocfs2_test_osb_flag(osb, OCFS2_OSB_UMOUNT_INPROG);
+	if (ret) {
+		/* Leave FREEZE_INPROG there so not queue the worker again */
+		goto thaw_dev;
+
+	}
+
+	ret = ocfs2_freeze_lock(osb, 0);
+	if (ret == -EBUSY) {
+		/* We suppose when it returns -EBUSY when timeout is hit.
+		 * Change me if it's not.
+		 */
+		goto wait_thaw;
+	} else if (ret) {
+		mlog(ML_ERROR, "Getting PR on freeze_lock failed,"
+		     "but going to thaw block device %s\n",  osb->dev_str);
+	} else {
+		do_unlock = 1;
+	}
+
+thaw_dev:
+	ret = thaw_bdev(osb->sb->s_bdev, osb->sb);
+	if (ret) {
+		/* this shouldn't happen */
+		mlog_errno(ret);
+		printk(KERN_WARNING "ocfs2: Thawing %s failed\n", osb->dev_str);
+	}
+
+	ocfs2_clear_osb_flag(osb, OCFS2_OSB_FROZEN_BY_REMOTE);
+
+	if (do_unlock)
+		ocfs2_freeze_unlock(osb, 0);
+}
+
+static void ocfs2_queue_freeze_worker(struct ocfs2_super *osb)
+{
+	int queue_it = 0;
+
+	spin_lock(&osb->osb_lock);
+	if (!(osb->osb_flags & OCFS2_OSB_FREEZE_INPROG)) {
+		osb->osb_flags |= OCFS2_OSB_FREEZE_INPROG;
+		queue_it = 1;
+	}
+	spin_unlock(&osb->osb_lock);
+
+	if (queue_it)
+		queue_work(ocfs2_wq, &osb->osb_freeze_work);
+}
+
 static int ocfs2_check_freeze_downconvert(struct ocfs2_lock_res *lockres,
 					  int new_level)
 {
-	return 1; /* change me */
+	struct ocfs2_super *osb = ocfs2_get_lockres_osb(lockres);
+	struct super_block *sb = osb->sb;
+	int frozen_by_remote;
+
+	mlog(0, "flags=0x%lx, frozen=%d, level=%d, newlevel=%d\n",
+	     osb->osb_flags, sb->s_frozen, lockres->l_level, new_level);
+
+	if (new_level == LKM_PRMODE) {
+		/* other node is during mount or is waiting for thaw. */
+		if (sb->s_frozen)
+			return 0;
+		else
+			return 1;
+	}
+
+	/* now new_level is NL. other node wants to freeze cluster. */
+	frozen_by_remote = ocfs2_test_osb_flag(osb, OCFS2_OSB_FROZEN_BY_REMOTE);
+
+	/* ok, this node is frozen for the request. */
+	if (frozen_by_remote)
+		return 1;
+
+	ocfs2_queue_freeze_worker(osb);
+	return 0;
 }
 
 /*
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 297b3a9..c6da138 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -167,6 +167,8 @@ void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb);
 struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
 void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 
+void ocfs2_freeze_worker(struct work_struct *work);
+
 /* To set the locking protocol on module initialization */
 void ocfs2_set_locking_protocol(void);
 #endif	/* DLMGLUE_H */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9336c60..8f82525 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -355,6 +355,7 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 	if (ocfs2_is_hard_readonly(osb))
 		return ERR_PTR(-EROFS);
 
+	vfs_check_frozen(osb->sb, SB_FREEZE_TRANS);
 	BUG_ON(osb->journal->j_state == OCFS2_JOURNAL_FREE);
 	BUG_ON(max_buffs <= 0);
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7892738..ec751b9 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -261,6 +261,9 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_HARD_RO			0x0002
 #define OCFS2_OSB_ERROR_FS			0x0004
 #define OCFS2_OSB_DROP_DENTRY_LOCK_IMMED	0x0008
+#define OCFS2_OSB_FREEZE_INPROG			0x0010
+#define OCFS2_OSB_UMOUNT_INPROG			0x0020
+#define OCFS2_OSB_FROZEN_BY_REMOTE		0x0040	/* frozen by remote */
 
 #define OCFS2_DEFAULT_ATIME_QUANTUM		60
 
@@ -403,6 +406,8 @@ struct ocfs2_super
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
 
+	/* osb_freeze_work is protected by osb->s_bdev->bd_fsfreeze_mutex */
+	struct work_struct		osb_freeze_work;
 	struct ocfs2_orphan_scan	osb_orphan_scan;
 
 	/* used to protect metaecc calculation check of xattr. */
@@ -540,6 +545,13 @@ static inline void ocfs2_set_osb_flag(struct ocfs2_super *osb,
 	spin_unlock(&osb->osb_lock);
 }
 
+static inline void ocfs2_clear_osb_flag(struct ocfs2_super *osb,
+					unsigned long flag)
+{
+	spin_lock(&osb->osb_lock);
+	osb->osb_flags &= ~flag;
+	spin_unlock(&osb->osb_lock);
+}
 
 static inline unsigned long  ocfs2_test_osb_flag(struct ocfs2_super *osb,
 						 unsigned long flag)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 9464080..cc37127 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -138,6 +138,10 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
 static int ocfs2_freeze_lock_supported(struct ocfs2_super *osb);
+static int is_kernel_thread(void);
+static int ocfs2_freeze_fs(struct super_block *sb);
+static int is_freeze_master(struct ocfs2_super *osb);
+static int ocfs2_unfreeze_fs(struct super_block *sb);
 
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
@@ -152,6 +156,8 @@ static const struct super_operations ocfs2_sops = {
 	.show_options   = ocfs2_show_options,
 	.quota_read	= ocfs2_quota_read,
 	.quota_write	= ocfs2_quota_write,
+	.freeze_fs	= ocfs2_freeze_fs,
+	.unfreeze_fs	= ocfs2_unfreeze_fs,
 };
 
 enum {
@@ -389,7 +395,7 @@ static const struct file_operations ocfs2_osb_debug_fops = {
 
 static int ocfs2_sync_fs(struct super_block *sb, int wait)
 {
-	int status;
+	int status, flush_journal = 0;
 	tid_t target;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
@@ -410,6 +416,17 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
 			jbd2_log_wait_commit(OCFS2_SB(sb)->journal->j_journal,
 					     target);
 	}
+
+	flush_journal = ocfs2_test_osb_flag(osb, OCFS2_OSB_FREEZE_INPROG);
+
+	/* flushes journal when it's during freeze_bdev(). so that we need not
+	 * replay journal if this node crashes before thawed.
+	 */
+	if (unlikely(flush_journal)) {
+		status = jbd2_journal_flush(OCFS2_SB(sb)->journal->j_journal);
+		if (status)
+			mlog(ML_ERROR, "flushing journal failed %d\n", status);
+	}
 	return 0;
 }
 
@@ -1219,6 +1236,9 @@ static void ocfs2_kill_sb(struct super_block *sb)
 	if (!osb || atomic_read(&osb->vol_state) == VOLUME_DISABLED)
 		goto out;
 
+	up_write(&sb->s_umount);
+	ocfs2_set_osb_flag(osb, OCFS2_OSB_UMOUNT_INPROG);
+	down_write(&sb->s_umount);
 	/* Prevent further queueing of inode drop events */
 	spin_lock(&dentry_list_lock);
 	ocfs2_set_osb_flag(osb, OCFS2_OSB_DROP_DENTRY_LOCK_IMMED);
@@ -2176,6 +2196,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	INIT_WORK(&osb->dentry_lock_work, ocfs2_drop_dl_inodes);
 	osb->dentry_lock_list = NULL;
 
+	INIT_WORK(&osb->osb_freeze_work, ocfs2_freeze_worker);
+
 	/* get some pseudo constants for clustersize bits */
 	osb->s_clustersize_bits =
 		le32_to_cpu(di->id2.i_super.s_clustersize_bits);
@@ -2534,5 +2556,111 @@ void __ocfs2_abort(struct super_block* sb,
 	ocfs2_handle_error(sb);
 }
 
+static inline int is_kernel_thread()
+{
+	return current->flags & PF_KTHREAD;
+}
+
+/* ocfs2_freeze_fs()/ocfs2_unfreeze_fs() are always called by freeze_bdev()/
+ * thaw_bdev(). bdev->bd_fsfreeze_mutex is used for synchronization. an extra
+ * ocfs2 mutex is not needed.
+ */
+static int ocfs2_freeze_fs(struct super_block *sb)
+{
+	int ret = 0;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+
+	mlog(0, "flags=0x%lx, frozen=%d\n", osb->osb_flags, osb->sb->s_frozen);
+
+	/* cluster lock is issued only when this is the IOCTL process.(other
+	 * case ocfs2_freeze_fs() is called in ocfs2_wq thread)
+	 */
+
+	if (is_kernel_thread()) {
+		BUG_ON(!ocfs2_freeze_lock_supported(osb));
+
+		/* this is ocfs2_wq kernel thread. we do freeze on behalf of
+		 * the requesting node, don't issue cluster lock again.
+		 */
+		printk(KERN_INFO "ocfs2: Block device (%s) frozen by remote\n",
+		       osb->dev_str);
+		return 0;
+	}
+
+	/* this is ioctl thread, issues cluster lock */
+
+	if (!ocfs2_freeze_lock_supported(osb))
+		return -ENOTSUPP;
+
+	ret = ocfs2_freeze_lock(osb, 1);
+	if (ret) {
+		mlog_errno(ret);
+	} else {
+		printk(KERN_INFO "ocfs2: Block device (%s) frozen by local\n",
+		       osb->dev_str);
+	}
+
+	return ret;
+}
+
+static int is_freeze_master(struct ocfs2_super *osb)
+{
+	BUG_ON(osb->osb_freeze_lockres.l_ex_holders > 1);
+	return osb->osb_freeze_lockres.l_ex_holders;
+}
+
+static int ocfs2_unfreeze_fs(struct super_block *sb)
+{
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+
+	mlog(0, "flags=0x%lx, frozen=%d\n", osb->osb_flags, osb->sb->s_frozen);
+
+	if (is_kernel_thread()) {
+		/* this is ocfs2_wq kernel thread. nothing to do. */
+		BUG_ON(!ocfs2_freeze_lock_supported(osb));
+		printk(KERN_INFO "ocfs2: Block device (%s) thawed by remote\n",
+		       osb->dev_str);
+		return 0;
+	}
+
+	/* this is the ioctl user thread. */
+
+	if (!ocfs2_freeze_lock_supported(osb))
+		return -ENOTSUPP;
+
+	if (!is_freeze_master(osb)) {
+		/* THAW ioctl on a node other than the one on with cluster is
+		 * frozen. don't thaw in the case. returns -EINVAL so that
+		 * osb->sb->s_bdev->bd_fsfreeze_count can be decreased.
+		 */
+
+		if (!ocfs2_test_osb_flag(osb, OCFS2_OSB_FROZEN_BY_REMOTE)) {
+			/* this is from a nested cross cluster thaw
+			 * case:
+			 * frozen from another node(node A)
+			 * frozen from this node(not suppored though)
+			 * thawed from node A
+			 * thawed from this node(coming here)
+			 *
+			 * thaw this node only.
+			 */
+			printk(KERN_INFO "ocfs2: Block device (%s) thawed by "
+			       "local\n", osb->dev_str);
+			return 0;
+		}
+
+		/* now the cluster still frozen by another node, fails this
+		 * request.
+		 */
+		return -EINVAL;
+	}
+
+	ocfs2_freeze_unlock(osb, 1);
+
+	printk(KERN_INFO "ocfs2: Block device (%s) thawed by local\n",
+	       osb->dev_str);
+	return 0;
+}
+
 module_init(ocfs2_init);
 module_exit(ocfs2_exit);
-- 
1.6.6.1
