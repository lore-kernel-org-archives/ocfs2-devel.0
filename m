From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:39:17 +0100
Subject: [Ocfs2-devel] [PATCH 27/27] ocfs2: Enable quota accounting on mount,
	disable on umount
In-Reply-To: <12254351602435-git-send-email-jack@suse.cz>
References: y <12254351572189-git-send-email-jack@suse.cz>
	<12254351571914-git-send-email-jack@suse.cz>
	<1225435157625-git-send-email-jack@suse.cz>
	<1225435157218-git-send-email-jack@suse.cz>
	<12254351571677-git-send-email-jack@suse.cz>
	<1225435157894-git-send-email-jack@suse.cz>
	<12254351582004-git-send-email-jack@suse.cz>
	<12254351581363-git-send-email-jack@suse.cz>
	<12254351582759-git-send-email-jack@suse.cz>
	<12254351582523-git-send-email-jack@suse.cz>
	<12254351583984-git-send-email-jack@suse.cz>
	<12254351582475-git-send-email-jack@suse.cz>
	<12254351583997-git-send-email-jack@suse.cz>
	<122543515838-git-send-email-jack@suse.cz>
	<1225435158192-git-send-email-jack@suse.cz>
	<1225435158807-git-send-email-jack@suse.cz>
	<1225435159130-git-send-email-jack@suse.cz>
	<12254351592930-git-send-email-jack@suse.cz>
	<12254351592095-git-send-email-jack@suse.cz>
	<12254351592812-git-send-email-jack@suse.cz>
	<12254351592495-git-send-email-jack@suse.cz>
	<12254351591416-git-send-email-jack@suse.cz>
	<12254351593189-git-send-email-jack@suse.cz>
	<12254351592827-git-send-email-jack@suse.cz>
	<12254351592563-git-send-email-jack@suse.cz>
	<12254351592722-git-send-email-jack@suse.cz>
	<12254351602435-git-send-email-jack@suse.cz>
Message-ID: <12254351603317-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Enable quota usage tracking on mount and disable it on umount. Also
add support for quota on and quota off quotactls and usrquota and
grpquota mount options. Add quota features among supported ones.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.c  |   20 ++++-
 fs/ocfs2/ocfs2.h    |    3 +
 fs/ocfs2/ocfs2_fs.h |    4 +-
 fs/ocfs2/super.c    |  222 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 245 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index de7a731..a870cdf 100644
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
@@ -916,6 +927,8 @@ void ocfs2_complete_recovery(struct work_struct *work)
 
 		mlog(0, "Complete recovery for slot %d\n", item->lri_slot);
 
+		ocfs2_wait_on_quotas(osb);
+
 		la_dinode = item->lri_la_dinode;
 		if (la_dinode) {
 			mlog(0, "Clean up local alloc %llu\n",
@@ -1721,13 +1734,14 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
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
index bf6f9cd..f0c049a 100644
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
@@ -195,6 +196,8 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_LOCALFLOCKS = 1 << 5, /* No cluster aware user file locks */
 	OCFS2_MOUNT_NOUSERXATTR = 1 << 6, /* No user xattr */
 	OCFS2_MOUNT_INODE64 = 1 << 7,	/* Allow inode numbers > 2^32 */
+	OCFS2_MOUNT_USRQUOTA = 1 << 8, /* We support user quotas */
+	OCFS2_MOUNT_GRPQUOTA = 1 << 9, /* We support group quotas */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 46c9006..7504c16 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -93,7 +93,9 @@
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
index 92539fe..128c60c 100644
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
@@ -163,6 +167,8 @@ enum {
 	Opt_user_xattr,
 	Opt_nouser_xattr,
 	Opt_inode64,
+	Opt_usrquota,
+	Opt_grpquota,
 	Opt_err,
 };
 
@@ -185,6 +191,8 @@ static const match_table_t tokens = {
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_nouser_xattr, "nouser_xattr"},
 	{Opt_inode64, "inode64"},
+	{Opt_usrquota, "usrquota"},
+	{Opt_grpquota, "grpquota"},
 	{Opt_err, NULL}
 };
 
@@ -448,6 +456,12 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 
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
@@ -483,6 +497,21 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
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
@@ -641,6 +670,131 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
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
@@ -679,6 +833,22 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -780,6 +950,28 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
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
 
@@ -967,6 +1159,28 @@ static int ocfs2_parse_options(struct super_block *sb,
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
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1030,6 +1244,10 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (osb->osb_cluster_stack[0])
 		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
 			   osb->osb_cluster_stack);
+	if (opts & OCFS2_MOUNT_USRQUOTA)
+		seq_printf(s, ",usrquota");
+	if (opts & OCFS2_MOUNT_GRPQUOTA)
+		seq_printf(s, ",grpquota");
 
 	if (opts & OCFS2_MOUNT_NOUSERXATTR)
 		seq_printf(s, ",nouser_xattr");
@@ -1354,6 +1572,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	osb = OCFS2_SB(sb);
 	BUG_ON(!osb);
 
+	ocfs2_disable_quotas(osb);
+
 	ocfs2_shutdown_local_alloc(osb);
 
 	ocfs2_truncate_log_shutdown(osb);
@@ -1464,6 +1684,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
 	sb->s_export_op = &ocfs2_export_ops;
+	sb->s_qcop = &ocfs2_quotactl_ops;
+	sb->dq_op = &ocfs2_quota_operations;
 	sb->s_xattr = ocfs2_xattr_handlers;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
-- 
1.5.2.4
