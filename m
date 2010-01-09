From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Sun, 10 Jan 2010 02:00:44 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
Message-ID: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

adds freeze_fs()/unfreeze_fs() for ocfs2 so that it supports freeze/thaw.

Authored-by: Tiger Yang <tiger.yang@oracle.com>
Authored-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/dlmglue.h |    1 +
 fs/ocfs2/journal.c |    1 +
 fs/ocfs2/ocfs2.h   |    5 ++
 fs/ocfs2/super.c   |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 231 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index cf88af2..b1b8690 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3928,10 +3928,116 @@ void ocfs2_set_locking_protocol(void)
 	ocfs2_stack_glue_set_locking_protocol(&lproto);
 }
 
+/*
+ * This is only ever run on behalf of another node.
+ */
+void ocfs2_freeze_worker(struct work_struct *work)
+{
+	struct super_block *sb;
+	int err = 0, err2;
+	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
+					       osb_freeze_work);
+
+	mlog(0, "flags=0x%lx, frozen=%d\n", osb->osb_flags, osb->sb->s_frozen);
+
+	sb = freeze_bdev(osb->sb->s_bdev);
+	if (IS_ERR(sb)) {
+		/* the error is returned by ocfs2_freeze_fs() */
+		err = PTR_ERR(sb);
+		if (err == -ENOTSUPP) {
+			/* we got freeze request but we don't support it */
+			BUG();
+		} else {
+			/* we don't issue cluster lock in ocfs2_freeze_fs() for
+			 * a freeze request(from other node). no other error
+			 * should be returned.
+			 */
+			BUG();
+		}
+	}
+
+	osb->frozen_by_master = 1;
+	spin_lock(&osb->osb_lock);
+	osb->osb_flags &= ~OCFS2_OSB_FREEZE_INPROG;
+	spin_unlock(&osb->osb_lock);
+
+	/* kick downconvert thread */
+	ocfs2_wake_downconvert_thread(osb);
+
+	/* waiting for THAW */
+	err = ocfs2_freeze_lock(osb, 0);
+	if (err)
+		mlog(ML_ERROR, "getting PR on freeze_lock failed,"
+		     "but going to thaw block device %s\n",  osb->dev_str);
+
+	err2 = thaw_bdev(osb->sb->s_bdev, osb->sb);
+	if (err2) {
+		if (err2 == -ENOTSUPP) {
+			/* we got freeze request but we don't support it */
+			BUG();
+		}
+		printk(KERN_WARNING "ocfs2: Thawing %s failed\n", osb->dev_str);
+	}
+
+	osb->frozen_by_master = 0;
+
+	if (!err)
+		ocfs2_freeze_unlock(osb, 0);
+}
+	
+static void ocfs2_queue_freeze_worker(struct ocfs2_super *osb)
+{
+	spin_lock(&osb->osb_lock);
+	if (!(osb->osb_flags & OCFS2_OSB_FREEZE_INPROG)) {
+		osb->osb_flags |= OCFS2_OSB_FREEZE_INPROG;
+		queue_work(ocfs2_wq, &osb->osb_freeze_work);
+	}
+	spin_unlock(&osb->osb_lock);
+}
+
 static int ocfs2_check_freeze_downconvert(struct ocfs2_lock_res *lockres,
 					  int new_level)
 {
-	return 1; //change me
+	struct ocfs2_super *osb = ocfs2_get_lockres_osb(lockres);
+	struct super_block *sb = osb->sb;
+
+	mlog(0, "flags=0x%lx, frozen=%d, level=%d, newlevel=%d\n",
+	     osb->osb_flags, sb->s_frozen, lockres->l_level, new_level);
+
+	if (new_level == LKM_PRMODE) {
+		/* other node is during mount or is waiting for THAW */
+		if (sb->s_frozen) {
+			/* this node didn't thaw yet, try later */
+			return 0;
+		} else {
+			/* this node has unlocked freeze_locky, it's ok to
+			 * downconvert it.
+			 */
+			return 1;
+		}
+	}
+
+	/* now new_level is NL. other node wants to freeze cluster.
+	 * the request shouldn't come when this node is still holding freeze_lock
+	 */
+	BUG_ON(lockres->l_ex_holders);
+
+	/* now this node is holding PR or is caching PR */
+	if (lockres->l_ro_holders) {
+		/* this node is during mount or is thawing, try later */
+		return 0;
+	}
+
+	/* now this node is caching PR, it's Ok to freeze for the request */
+	if (sb->s_frozen &&
+	    !(osb->osb_flags & OCFS2_OSB_FREEZE_INPROG)) {
+		/* ok, this node is frozen for the request */
+		return 1;
+	}
+
+	/* queue a work to do freeze for the request */
+	ocfs2_queue_freeze_worker(osb);
+	return 0;
 }
 
 static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 8687b81..96e0dae 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -168,6 +168,7 @@ void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb);
 struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
 void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 
+void ocfs2_freeze_worker(struct work_struct *work);
 /* To set the locking protocol on module initialization */
 void ocfs2_set_locking_protocol(void);
 #endif	/* DLMGLUE_H */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index bf34c49..45c5bfe 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -355,6 +355,7 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 	if (ocfs2_is_hard_readonly(osb))
 		return ERR_PTR(-EROFS);
 
+	vfs_check_frozen(osb->sb, SB_FREEZE_TRANS);
 	BUG_ON(osb->journal->j_state == OCFS2_JOURNAL_FREE);
 	BUG_ON(max_buffs <= 0);
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index bf66978..62e1819 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -254,6 +254,7 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_HARD_RO			0x0002
 #define OCFS2_OSB_ERROR_FS			0x0004
 #define OCFS2_OSB_DROP_DENTRY_LOCK_IMMED	0x0008
+#define OCFS2_OSB_FREEZE_INPROG			0x0010
 
 #define OCFS2_DEFAULT_ATIME_QUANTUM		60
 
@@ -356,6 +357,8 @@ struct ocfs2_super
 	struct ocfs2_lock_res osb_rename_lockres;
 	struct ocfs2_lock_res osb_nfs_sync_lockres;
 	struct ocfs2_lock_res osb_freeze_lockres;
+	int frozen_by_master;		/* a flag. 1 if FS is frozen on behalf
+					 * of another node */
 	struct ocfs2_dlm_debug *osb_dlm_debug;
 
 	struct dentry *osb_debug_root;
@@ -394,6 +397,8 @@ struct ocfs2_super
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
 
+	/* osb_freeze_work is protected by osb->s_bdev->bd_fsfreeze_mutex */
+	struct work_struct		osb_freeze_work;
 	struct ocfs2_orphan_scan	osb_orphan_scan;
 
 	/* used to protect metaecc calculation check of xattr. */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 9127760..4493163 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -135,6 +135,10 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
 static int ocfs2_freeze_lock_supported(struct ocfs2_super *osb);
+static int is_kernel_thread(void);
+static int ocfs2_freeze_fs(struct super_block *sb);
+static int is_freeze_master(struct ocfs2_super *osb);
+static int ocfs2_unfreeze_fs(struct super_block *sb);
 
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
@@ -149,6 +153,8 @@ static const struct super_operations ocfs2_sops = {
 	.show_options   = ocfs2_show_options,
 	.quota_read	= ocfs2_quota_read,
 	.quota_write	= ocfs2_quota_write,
+	.freeze_fs	= ocfs2_freeze_fs,
+	.unfreeze_fs	= ocfs2_unfreeze_fs,
 };
 
 enum {
@@ -2167,6 +2173,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	INIT_WORK(&osb->dentry_lock_work, ocfs2_drop_dl_inodes);
 	osb->dentry_lock_list = NULL;
 
+	INIT_WORK(&osb->osb_freeze_work, ocfs2_freeze_worker);
+
 	/* get some pseudo constants for clustersize bits */
 	osb->s_clustersize_bits =
 		le32_to_cpu(di->id2.i_super.s_clustersize_bits);
@@ -2525,5 +2533,114 @@ void __ocfs2_abort(struct super_block* sb,
 	ocfs2_handle_error(sb);
 }
 
+static int is_kernel_thread()
+{
+	if (current->flags & PF_KTHREAD)
+		return 1;
+	return 0;
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
+	if (!ocfs2_freeze_lock_supported(osb)) {
+		return -ENOTSUPP;
+	}
+
+	printk(KERN_INFO "ocfs2: Request to freeze block device (%s)\n",
+	       osb->dev_str);
+
+	/* cluster lock is issued only when this is the IOCTL process.(other
+	 * case ocfs2_freeze_fs() is called in ocfs2_wq thread)
+	 */
+
+	if (!is_kernel_thread()) {
+		/* this is ioctl thread, issues cluster lock */
+		ret = ocfs2_freeze_lock(osb, 1);
+		if (ret) {
+			mlog_errno(ret);
+		} else {
+			printk(KERN_INFO "ocfs2: Block device (%s) frozen by local\n",
+			       osb->dev_str);
+		}
+	} else {
+		/* this is ocfs2_wq kernel thread. we do freeze on behalf of
+		 * the requesting node, don't issue cluster lock again.
+		 */
+		printk(KERN_INFO "ocfs2: Block device (%s) frozen by remote\n",
+		       osb->dev_str);
+	}
+
+	return ret;
+}
+
+static int is_freeze_master(struct ocfs2_super *osb)
+{
+	BUG_ON(osb->osb_freeze_lockres.l_ex_holders > 1);
+
+	if (osb->osb_freeze_lockres.l_ex_holders)
+		return 1;
+
+	return 0;
+}
+
+static int ocfs2_unfreeze_fs(struct super_block *sb)
+{
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+
+	mlog(0, "flags=0x%lx, frozen=%d\n", osb->osb_flags, osb->sb->s_frozen);
+
+	if (!ocfs2_freeze_lock_supported(osb))
+		return -ENOTSUPP;
+
+	if (!is_kernel_thread()) {
+		/* this is the ioctl user thread. */
+		if (!is_freeze_master(osb)) {
+			/* THAW ioctl on a node other than the one on with cluster
+			 * is frozen. don't thaw in the case. returns -EINVAL so
+			 * that osb->sb->s_bdev->bd_fsfreeze_count can be decreased.
+			 */
+
+			if (!osb->frozen_by_master) {
+				/* this is from a nested cross cluster thaw
+				 * case:
+				 * frozen from another node(node A)
+				 * frozen from this node(not suppored though)
+				 * thawed from node A
+				 * thawed from this node(coming here)
+				 *
+				 * thaw this node only.
+				 */
+				printk(KERN_INFO "ocfs2: Block device (%s) thawed"
+				       " by local\n", osb->dev_str);
+				goto bail;
+			}
+
+			/* now the cluster still frozen by another node,
+			 * fails this request
+			 */
+			printk(KERN_INFO "ocfs2: thawing %s on invalid node\n",
+			       osb->dev_str);
+			return -EINVAL;
+		}
+		ocfs2_freeze_unlock(osb, 1);
+		printk(KERN_INFO "ocfs2: Block device (%s) thawed by local\n", osb->dev_str);
+	} else {
+		/* this is ocfs2_wq kernel thread. nothing to do. */
+		printk(KERN_INFO "ocfs2: Block device (%s) thawed by remote\n", osb->dev_str);
+	}
+bail:
+	return 0;
+}
+
+
 module_init(ocfs2_init);
 module_exit(ocfs2_exit);
-- 
1.6.5.2
