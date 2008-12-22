From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:08 -0800
Subject: [Ocfs2-devel] [PATCH 27/56] ocfs2: Enable quota accounting on mount,
	disable on umount
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-28-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

Enable quota usage tracking on mount and disable it on umount. Also
add support for quota on and quota off quotactls and usrquota and
grpquota mount options. Add quota features among supported ones.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/journal.c  |   20 ++++-
 fs/ocfs2/ocfs2.h    |    3 +
 fs/ocfs2/ocfs2_fs.h |    4 +-
 fs/ocfs2/super.c    |  222 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 245 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index c602420..302f114 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -56,7 +56,7 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 			      int node_num, int slot_num);
 static int __ocfs2_recovery_thread(void *arg);
 static int ocfs2_commit_cache(struct ocfs2_super *osb);
-static int ocfs2_wait_on_mount(struct ocfs2_super *osb);
+static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota);
 static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 				      int dirty, int replayed);
 static int ocfs2_trylock_journal(struct ocfs2_super *osb,
@@ -65,6 +65,17 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 				 int slot);
 static int ocfs2_commit_thread(void *arg);
 
+static inline int ocfs2_wait_on_mount(struct ocfs2_super *osb)
+{
+	return __ocfs2_wait_on_mount(osb, 0);
+}
+
+static inline int ocfs2_wait_on_quotas(struct ocfs2_super *osb)
+{
+	return __ocfs2_wait_on_mount(osb, 1);
+}
+
+
 
 /*
  * The recovery_list is a simple linked list of node numbers to recover.
@@ -895,6 +906,8 @@ void ocfs2_complete_recovery(struct work_struct *work)
 
 		mlog(0, "Complete recovery for slot %d\n", item->lri_slot);
 
+		ocfs2_wait_on_quotas(osb);
+
 		la_dinode = item->lri_la_dinode;
 		if (la_dinode) {
 			mlog(0, "Clean up local alloc %llu\n",
@@ -1701,13 +1714,14 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 	return ret;
 }
 
-static int ocfs2_wait_on_mount(struct ocfs2_super *osb)
+static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota)
 {
 	/* This check is good because ocfs2 will wait on our recovery
 	 * thread before changing it to something other than MOUNTED
 	 * or DISABLED. */
 	wait_event(osb->osb_mount_event,
-		   atomic_read(&osb->vol_state) == VOLUME_MOUNTED ||
+		  (!quota && atomic_read(&osb->vol_state) == VOLUME_MOUNTED) ||
+		   atomic_read(&osb->vol_state) == VOLUME_MOUNTED_QUOTAS ||
 		   atomic_read(&osb->vol_state) == VOLUME_DISABLED);
 
 	/* If there's an error on mount, then we may never get to the
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6b25b4a..5c77798 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -161,6 +161,7 @@ enum ocfs2_vol_state
 {
 	VOLUME_INIT = 0,
 	VOLUME_MOUNTED,
+	VOLUME_MOUNTED_QUOTAS,
 	VOLUME_DISMOUNTED,
 	VOLUME_DISABLED
 };
@@ -196,6 +197,8 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_NOUSERXATTR = 1 << 6, /* No user xattr */
 	OCFS2_MOUNT_INODE64 = 1 << 7,	/* Allow inode numbers > 2^32 */
 	OCFS2_MOUNT_POSIX_ACL = 1 << 8,	/* POSIX access control lists */
+	OCFS2_MOUNT_USRQUOTA = 1 << 9, /* We support user quotas */
+	OCFS2_MOUNT_GRPQUOTA = 1 << 10, /* We support group quotas */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 0a5ac79..359732e 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -94,7 +94,9 @@
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
 					 | OCFS2_FEATURE_INCOMPAT_XATTR)
-#define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN)
+#define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
+					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
+					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
 
 /*
  * Heartbeat-only devices are missing journals and other files.  The
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7bb83e4..bc43138 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -41,6 +41,7 @@
 #include <linux/debugfs.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -127,6 +128,9 @@ static int ocfs2_get_sector(struct super_block *sb,
 static void ocfs2_write_super(struct super_block *sb);
 static struct inode *ocfs2_alloc_inode(struct super_block *sb);
 static void ocfs2_destroy_inode(struct inode *inode);
+static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
+static int ocfs2_enable_quotas(struct ocfs2_super *osb);
+static void ocfs2_disable_quotas(struct ocfs2_super *osb);
 
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
@@ -165,6 +169,8 @@ enum {
 	Opt_inode64,
 	Opt_acl,
 	Opt_noacl,
+	Opt_usrquota,
+	Opt_grpquota,
 	Opt_err,
 };
 
@@ -189,6 +195,8 @@ static const match_table_t tokens = {
 	{Opt_inode64, "inode64"},
 	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
+	{Opt_usrquota, "usrquota"},
+	{Opt_grpquota, "grpquota"},
 	{Opt_err, NULL}
 };
 
@@ -452,6 +460,12 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 
 	/* We're going to/from readonly mode. */
 	if ((*flags & MS_RDONLY) != (sb->s_flags & MS_RDONLY)) {
+		/* Disable quota accounting before remounting RO */
+		if (*flags & MS_RDONLY) {
+			ret = ocfs2_susp_quotas(osb, 0);
+			if (ret < 0)
+				goto out;
+		}
 		/* Lock here so the check of HARD_RO and the potential
 		 * setting of SOFT_RO is atomic. */
 		spin_lock(&osb->osb_lock);
@@ -487,6 +501,21 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		}
 unlock_osb:
 		spin_unlock(&osb->osb_lock);
+		/* Enable quota accounting after remounting RW */
+		if (!ret && !(*flags & MS_RDONLY)) {
+			if (sb_any_quota_suspended(sb))
+				ret = ocfs2_susp_quotas(osb, 1);
+			else
+				ret = ocfs2_enable_quotas(osb);
+			if (ret < 0) {
+				/* Return back changes... */
+				spin_lock(&osb->osb_lock);
+				sb->s_flags |= MS_RDONLY;
+				osb->osb_flags |= OCFS2_OSB_SOFT_RO;
+				spin_unlock(&osb->osb_lock);
+				goto out;
+			}
+		}
 	}
 
 	if (!ret) {
@@ -647,6 +676,131 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
 	return 0;
 }
 
+static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend)
+{
+	int type;
+	struct super_block *sb = osb->sb;
+	unsigned int feature[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
+					     OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
+	int status = 0;
+
+	for (type = 0; type < MAXQUOTAS; type++) {
+		if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
+			continue;
+		if (unsuspend)
+			status = vfs_quota_enable(
+					sb_dqopt(sb)->files[type],
+					type, QFMT_OCFS2,
+					DQUOT_SUSPENDED);
+		else
+			status = vfs_quota_disable(sb, type,
+						   DQUOT_SUSPENDED);
+		if (status < 0)
+			break;
+	}
+	if (status < 0)
+		mlog(ML_ERROR, "Failed to suspend/unsuspend quotas on "
+		     "remount (error = %d).\n", status);
+	return status;
+}
+
+static int ocfs2_enable_quotas(struct ocfs2_super *osb)
+{
+	struct inode *inode[MAXQUOTAS] = { NULL, NULL };
+	struct super_block *sb = osb->sb;
+	unsigned int feature[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
+					     OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
+	unsigned int ino[MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
+					LOCAL_GROUP_QUOTA_SYSTEM_INODE };
+	int status;
+	int type;
+
+	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE | DQUOT_NEGATIVE_USAGE;
+	for (type = 0; type < MAXQUOTAS; type++) {
+		if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
+			continue;
+		inode[type] = ocfs2_get_system_file_inode(osb, ino[type],
+							osb->slot_num);
+		if (!inode[type]) {
+			status = -ENOENT;
+			goto out_quota_off;
+		}
+		status = vfs_quota_enable(inode[type], type, QFMT_OCFS2,
+						DQUOT_USAGE_ENABLED);
+		if (status < 0)
+			goto out_quota_off;
+	}
+
+	for (type = 0; type < MAXQUOTAS; type++)
+		iput(inode[type]);
+	return 0;
+out_quota_off:
+	ocfs2_disable_quotas(osb);
+	for (type = 0; type < MAXQUOTAS; type++)
+		iput(inode[type]);
+	mlog_errno(status);
+	return status;
+}
+
+static void ocfs2_disable_quotas(struct ocfs2_super *osb)
+{
+	int type;
+	struct inode *inode;
+	struct super_block *sb = osb->sb;
+
+	/* We mostly ignore errors in this function because there's not much
+	 * we can do when we see them */
+	for (type = 0; type < MAXQUOTAS; type++) {
+		if (!sb_has_quota_loaded(sb, type))
+			continue;
+		inode = igrab(sb->s_dquot.files[type]);
+		/* Turn off quotas. This will remove all dquot structures from
+		 * memory and so they will be automatically synced to global
+		 * quota files */
+		vfs_quota_disable(sb, type, DQUOT_USAGE_ENABLED |
+					    DQUOT_LIMITS_ENABLED);
+		if (!inode)
+			continue;
+		iput(inode);
+	}
+}
+
+/* Handle quota on quotactl */
+static int ocfs2_quota_on(struct super_block *sb, int type, int format_id,
+			  char *path, int remount)
+{
+	unsigned int feature[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
+					     OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
+
+	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
+		return -EINVAL;
+
+	if (remount)
+		return 0;	/* Just ignore it has been handled in
+				 * ocfs2_remount() */
+	return vfs_quota_enable(sb_dqopt(sb)->files[type], type,
+				    format_id, DQUOT_LIMITS_ENABLED);
+}
+
+/* Handle quota off quotactl */
+static int ocfs2_quota_off(struct super_block *sb, int type, int remount)
+{
+	if (remount)
+		return 0;	/* Ignore now and handle later in
+				 * ocfs2_remount() */
+	return vfs_quota_disable(sb, type, DQUOT_LIMITS_ENABLED);
+}
+
+static struct quotactl_ops ocfs2_quotactl_ops = {
+	.quota_on	= ocfs2_quota_on,
+	.quota_off	= ocfs2_quota_off,
+	.quota_sync	= vfs_quota_sync,
+	.get_info	= vfs_get_dqinfo,
+	.set_info	= vfs_set_dqinfo,
+	.get_dqblk	= vfs_get_dqblk,
+	.set_dqblk	= vfs_set_dqblk,
+};
+
 static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct dentry *root;
@@ -689,6 +843,22 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->osb_commit_interval = parsed_options.commit_interval;
 	osb->local_alloc_default_bits = ocfs2_megabytes_to_clusters(sb, parsed_options.localalloc_opt);
 	osb->local_alloc_bits = osb->local_alloc_default_bits;
+	if (osb->s_mount_opt & OCFS2_MOUNT_USRQUOTA &&
+	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+					 OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
+		status = -EINVAL;
+		mlog(ML_ERROR, "User quotas were requested, but this "
+		     "filesystem does not have the feature enabled.\n");
+		goto read_super_error;
+	}
+	if (osb->s_mount_opt & OCFS2_MOUNT_GRPQUOTA &&
+	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+					 OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+		status = -EINVAL;
+		mlog(ML_ERROR, "Group quotas were requested, but this "
+		     "filesystem does not have the feature enabled.\n");
+		goto read_super_error;
+	}
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
@@ -793,6 +963,28 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
+	/* Now we can initialize quotas because we can afford to wait
+	 * for cluster locks recovery now. That also means that truncation
+	 * log recovery can happen but that waits for proper quota setup */
+	if (!(sb->s_flags & MS_RDONLY)) {
+		status = ocfs2_enable_quotas(osb);
+		if (status < 0) {
+			/* We have to err-out specially here because
+			 * s_root is already set */
+			mlog_errno(status);
+			atomic_set(&osb->vol_state, VOLUME_DISABLED);
+			wake_up(&osb->osb_mount_event);
+			mlog_exit(status);
+			return status;
+		}
+	}
+
+	ocfs2_complete_quota_recovery(osb);
+
+	/* Now we wake up again for processes waiting for quotas */
+	atomic_set(&osb->vol_state, VOLUME_MOUNTED_QUOTAS);
+	wake_up(&osb->osb_mount_event);
+
 	mlog_exit(status);
 	return status;
 
@@ -980,6 +1172,28 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_inode64:
 			mopt->mount_opt |= OCFS2_MOUNT_INODE64;
 			break;
+		case Opt_usrquota:
+			/* We check only on remount, otherwise features
+			 * aren't yet initialized. */
+			if (is_remount && !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+			    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
+				mlog(ML_ERROR, "User quota requested but "
+				     "filesystem feature is not set\n");
+				status = 0;
+				goto bail;
+			}
+			mopt->mount_opt |= OCFS2_MOUNT_USRQUOTA;
+			break;
+		case Opt_grpquota:
+			if (is_remount && !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+			    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+				mlog(ML_ERROR, "Group quota requested but "
+				     "filesystem feature is not set\n");
+				status = 0;
+				goto bail;
+			}
+			mopt->mount_opt |= OCFS2_MOUNT_GRPQUOTA;
+			break;
 #ifdef CONFIG_OCFS2_FS_POSIX_ACL
 		case Opt_acl:
 			mopt->mount_opt |= OCFS2_MOUNT_POSIX_ACL;
@@ -1056,6 +1270,10 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (osb->osb_cluster_stack[0])
 		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
 			   osb->osb_cluster_stack);
+	if (opts & OCFS2_MOUNT_USRQUOTA)
+		seq_printf(s, ",usrquota");
+	if (opts & OCFS2_MOUNT_GRPQUOTA)
+		seq_printf(s, ",grpquota");
 
 	if (opts & OCFS2_MOUNT_NOUSERXATTR)
 		seq_printf(s, ",nouser_xattr");
@@ -1387,6 +1605,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	osb = OCFS2_SB(sb);
 	BUG_ON(!osb);
 
+	ocfs2_disable_quotas(osb);
+
 	ocfs2_shutdown_local_alloc(osb);
 
 	ocfs2_truncate_log_shutdown(osb);
@@ -1497,6 +1717,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
 	sb->s_export_op = &ocfs2_export_ops;
+	sb->s_qcop = &ocfs2_quotactl_ops;
+	sb->dq_op = &ocfs2_quota_operations;
 	sb->s_xattr = ocfs2_xattr_handlers;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
-- 
1.5.6
