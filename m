From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:23:59 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Enable quota accounting on mount,
	disable on umount
In-Reply-To: y
References: y
Message-ID: <12245234432502-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Enable quota usage tracking on mount and disable it on umount. Also
add support for quota on and quota off quotactls and usrquota and
grpquota mount options.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/ocfs2.h |    2 +
 fs/ocfs2/super.c |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 193 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7f625f2..d1b8a9e 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -184,6 +184,8 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_ERRORS_PANIC = 1 << 3, /* Panic on errors */
 	OCFS2_MOUNT_DATA_WRITEBACK = 1 << 4, /* No data ordering */
 	OCFS2_MOUNT_LOCALFLOCKS = 1 << 5, /* No cluster aware user file locks */
+	OCFS2_MOUNT_USRQUOTA = 1 << 6, /* We support user quotas */
+	OCFS2_MOUNT_GRPQUOTA = 1 << 7, /* We support group quotas */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index e043814..c8281c9 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -41,6 +41,7 @@
 #include <linux/debugfs.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -126,6 +127,8 @@ static int ocfs2_get_sector(struct super_block *sb,
 static void ocfs2_write_super(struct super_block *sb);
 static struct inode *ocfs2_alloc_inode(struct super_block *sb);
 static void ocfs2_destroy_inode(struct inode *inode);
+static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
+static void ocfs2_disable_quotas(struct ocfs2_super *osb);
 
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
@@ -159,6 +162,8 @@ enum {
 	Opt_localalloc,
 	Opt_localflocks,
 	Opt_stack,
+	Opt_usrquota,
+	Opt_grpquota,
 	Opt_err,
 };
 
@@ -178,6 +183,8 @@ static match_table_t tokens = {
 	{Opt_localalloc, "localalloc=%d"},
 	{Opt_localflocks, "localflocks"},
 	{Opt_stack, "cluster_stack=%s"},
+	{Opt_usrquota, "usrquota"},
+	{Opt_grpquota, "grpquota"},
 	{Opt_err, NULL}
 };
 
@@ -430,6 +437,9 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 
 	/* We're going to/from readonly mode. */
 	if ((*flags & MS_RDONLY) != (sb->s_flags & MS_RDONLY)) {
+		/* Disable quota accounting before remounting RO */
+		if (*flags & MS_RDONLY)
+			ocfs2_susp_quotas(osb, 0);
 		/* Lock here so the check of HARD_RO and the potential
 		 * setting of SOFT_RO is atomic. */
 		spin_lock(&osb->osb_lock);
@@ -465,6 +475,9 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		}
 unlock_osb:
 		spin_unlock(&osb->osb_lock);
+		/* Enable quota accounting after remounting RW */
+		if (!ret && !(*flags & MS_RDONLY))
+			ocfs2_susp_quotas(osb, 1);
 	}
 
 	if (!ret) {
@@ -623,6 +636,131 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
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
@@ -660,6 +798,22 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->preferred_slot = parsed_options.slot;
 	osb->osb_commit_interval = parsed_options.commit_interval;
 	osb->local_alloc_size = parsed_options.localalloc_opt;
+	if (osb->s_mount_opt & OCFS2_MOUNT_USRQUOTA &&
+	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+					 OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
+		status = -EINVAL;
+		mlog(ML_ERROR, "User quota requested but filesystem feature "
+			       "is not set\n");
+		goto read_super_error;
+	}
+	if (osb->s_mount_opt & OCFS2_MOUNT_GRPQUOTA &&
+	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+					 OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+		status = -EINVAL;
+		mlog(ML_ERROR, "Group quota requested but filesystem feature "
+			       "is not set\n");
+		goto read_super_error;
+	}
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
@@ -745,6 +899,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_root = root;
 
+	/* Initialize quotas before we start truncation log recovery */
+	status = ocfs2_enable_quotas(osb);
+	if (status < 0) {
+		mlog_errno(status);
+		goto read_super_error;
+	}
+
 	ocfs2_complete_mount_recovery(osb);
 
 	if (ocfs2_mount_local(osb))
@@ -940,6 +1101,28 @@ static int ocfs2_parse_options(struct super_block *sb,
 			       OCFS2_STACK_LABEL_LEN);
 			mopt->cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
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
@@ -1001,6 +1184,10 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (osb->osb_cluster_stack[0])
 		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
 			   osb->osb_cluster_stack);
+	if (opts & OCFS2_MOUNT_USRQUOTA)
+		seq_printf(s, ",usrquota");
+	if (opts & OCFS2_MOUNT_GRPQUOTA)
+		seq_printf(s, ",grpquota");
 
 	return 0;
 }
@@ -1313,6 +1500,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	osb = OCFS2_SB(sb);
 	BUG_ON(!osb);
 
+	ocfs2_disable_quotas(osb);
+
 	ocfs2_shutdown_local_alloc(osb);
 
 	ocfs2_truncate_log_shutdown(osb);
@@ -1423,6 +1612,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
 	sb->s_export_op = &ocfs2_export_ops;
+	sb->s_qcop = &ocfs2_quotactl_ops;
+	sb->dq_op = &ocfs2_quota_operations;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
 	/* this is needed to support O_LARGEFILE */
-- 
1.5.2.4
