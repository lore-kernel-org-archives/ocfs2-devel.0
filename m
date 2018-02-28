From: Jan Kara <jack@suse.cz>
Date: Wed, 28 Feb 2018 12:18:01 +0100
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2: Fix quota recovery for read-only
	mounts
In-Reply-To: <20180228111802.23967-1-jack@suse.cz>
References: <20180228111802.23967-1-jack@suse.cz>
Message-ID: <20180228111802.23967-6-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently quotas are either disabled or suspended when the filesystem
is mounted read only. This results in quota recovery failing when in
happens on such mount and as a result quota accounting is wrong. Fix the
problem by enabling quotas even for read-only mounts. We just don't
start periodic flushing of our local changes to the global quota file
since that is pointless for read-only mounts.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/super.c | 99 +++++++++++++++++++++++++-------------------------------
 1 file changed, 44 insertions(+), 55 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 39b62569e7ff..af4481b98c65 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -135,7 +135,8 @@ static int ocfs2_get_sector(struct super_block *sb,
 			    int sect_size);
 static struct inode *ocfs2_alloc_inode(struct super_block *sb);
 static void ocfs2_destroy_inode(struct inode *inode);
-static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
+static void ocfs2_enable_quota_sync(struct ocfs2_super *osb);
+static void ocfs2_disable_quota_sync(struct ocfs2_super *osb);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
 
@@ -675,12 +676,9 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 
 	/* We're going to/from readonly mode. */
 	if ((bool)(*flags & SB_RDONLY) != sb_rdonly(sb)) {
-		/* Disable quota accounting before remounting RO */
-		if (*flags & SB_RDONLY) {
-			ret = ocfs2_susp_quotas(osb, 0);
-			if (ret < 0)
-				goto out;
-		}
+		/* Disable quota syncing before remounting RO */
+		if (*flags & SB_RDONLY)
+			ocfs2_disable_quota_sync(osb);
 		/* Lock here so the check of HARD_RO and the potential
 		 * setting of SOFT_RO is atomic. */
 		spin_lock(&osb->osb_lock);
@@ -714,21 +712,9 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		trace_ocfs2_remount(sb->s_flags, osb->osb_flags, *flags);
 unlock_osb:
 		spin_unlock(&osb->osb_lock);
-		/* Enable quota accounting after remounting RW */
-		if (!ret && !(*flags & SB_RDONLY)) {
-			if (sb_any_quota_suspended(sb))
-				ret = ocfs2_susp_quotas(osb, 1);
-			else
-				ret = ocfs2_enable_quotas(osb);
-			if (ret < 0) {
-				/* Return back changes... */
-				spin_lock(&osb->osb_lock);
-				sb->s_flags |= SB_RDONLY;
-				osb->osb_flags |= OCFS2_OSB_SOFT_RO;
-				spin_unlock(&osb->osb_lock);
-				goto out;
-			}
-		}
+		/* Enable quota syncing after remounting RW */
+		if (!ret && !(*flags & SB_RDONLY))
+			ocfs2_enable_quota_sync(osb);
 	}
 
 	if (!ret) {
@@ -902,38 +888,33 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
 	return 0;
 }
 
-static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend)
+static void ocfs2_enable_quota_sync(struct ocfs2_super *osb)
 {
 	int type;
 	struct super_block *sb = osb->sb;
-	unsigned int feature[OCFS2_MAXQUOTAS] = {
-					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
-					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
-	int status = 0;
 	struct ocfs2_mem_dqinfo *oinfo;
 
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
-		if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
+		if (!sb_has_quota_active(sb, type))
 			continue;
 		oinfo = sb_dqinfo(sb, type)->dqi_priv;
-		if (unsuspend) {
-			status = dquot_resume(sb, type);
-			if (status < 0)
-				break;
-			schedule_delayed_work(&oinfo->dqi_sync_work,
-					msecs_to_jiffies(oinfo->dqi_syncms));
-		} else {
-			/* Cancel periodic syncing before suspending */
-			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
-			status = dquot_suspend(sb, type);
-			if (status < 0)
-				break;
-		}
+		schedule_delayed_work(&oinfo->dqi_sync_work,
+				      msecs_to_jiffies(oinfo->dqi_syncms));
+	}
+}
+
+static void ocfs2_disable_quota_sync(struct ocfs2_super *osb)
+{
+	int type;
+	struct super_block *sb = osb->sb;
+	struct ocfs2_mem_dqinfo *oinfo;
+
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
+		if (!sb_has_quota_active(sb, type))
+			continue;
+		oinfo = sb_dqinfo(sb, type)->dqi_priv;
+		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 	}
-	if (status < 0)
-		mlog(ML_ERROR, "Failed to suspend/unsuspend quotas on "
-		     "remount (error = %d).\n", status);
-	return status;
 }
 
 static int ocfs2_enable_quotas(struct ocfs2_super *osb)
@@ -946,11 +927,18 @@ static int ocfs2_enable_quotas(struct ocfs2_super *osb)
 	unsigned int ino[OCFS2_MAXQUOTAS] = {
 					LOCAL_USER_QUOTA_SYSTEM_INODE,
 					LOCAL_GROUP_QUOTA_SYSTEM_INODE };
-	struct ocfs2_mem_dqinfo *oinfo;
 	int status;
 	int type;
+	bool ro;
 
 	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE | DQUOT_NEGATIVE_USAGE;
+	/*
+	 * We temporarily switch sb to read-write to allow quota setup to pass
+ 	 * cleanly
+	 */
+	ro = sb_rdonly(sb);
+	if (ro)
+		sb->s_flags &= ~SB_RDONLY;
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
 			continue;
@@ -964,16 +952,19 @@ static int ocfs2_enable_quotas(struct ocfs2_super *osb)
 				      DQUOT_USAGE_ENABLED);
 		if (status < 0)
 			goto out_quota_off;
-		oinfo = sb_dqinfo(sb, type)->dqi_priv;
-		schedule_delayed_work(&oinfo->dqi_sync_work,
-				      msecs_to_jiffies(oinfo->dqi_syncms));
 	}
 
+	if (!ro)
+		ocfs2_enable_quota_sync(osb);
+	else
+		sb->s_flags |= SB_RDONLY;
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++)
 		iput(inode[type]);
 	return 0;
 out_quota_off:
 	ocfs2_disable_quotas(osb);
+	if (ro)
+		sb->s_flags |= SB_RDONLY;
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++)
 		iput(inode[type]);
 	mlog_errno(status);
@@ -985,15 +976,13 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
 	int type;
 	struct inode *inode;
 	struct super_block *sb = osb->sb;
-	struct ocfs2_mem_dqinfo *oinfo;
 
 	/* We mostly ignore errors in this function because there's not much
 	 * we can do when we see them */
+	ocfs2_disable_quota_sync(osb);
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!sb_has_quota_loaded(sb, type))
 			continue;
-		oinfo = sb_dqinfo(sb, type)->dqi_priv;
-		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 		inode = igrab(sb->s_dquot.files[type]);
 		/* Turn off quotas. This will remove all dquot structures from
 		 * memory and so they will be automatically synced to global
@@ -1185,7 +1174,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	/* Now we can initialize quotas because we can afford to wait
 	 * for cluster locks recovery now. That also means that truncation
 	 * log recovery can happen but that waits for proper quota setup */
-	if (!sb_rdonly(sb)) {
+	if (!ocfs2_is_hard_readonly(osb)) {
 		status = ocfs2_enable_quotas(osb);
 		if (status < 0) {
 			/* We have to err-out specially here because
@@ -1195,9 +1184,9 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			wake_up(&osb->osb_mount_event);
 			return status;
 		}
-	}
 
-	ocfs2_complete_quota_recovery(osb);
+		ocfs2_complete_quota_recovery(osb);
+	}
 
 	/* Now we wake up again for processes waiting for quotas */
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED_QUOTAS);
-- 
2.13.6
