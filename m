From: Jan Kara <jack@suse.cz>
Date: Wed, 28 Feb 2018 12:18:00 +0100
Subject: [Ocfs2-devel] [PATCH 4/6] ocfs2: Move scheduling of dqi_sync_work
	up in call stack
In-Reply-To: <20180228111802.23967-1-jack@suse.cz>
References: <20180228111802.23967-1-jack@suse.cz>
Message-ID: <20180228111802.23967-5-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Move scheduling of dqi_sync_work up in the call stack to
ocfs2_enable_quotas() and ocfs2_susp_quotas(). This will later allow us
to not schedule this work when quotas are enabled on read-only
filesystem and also makes scheduling & canceling of dqi_sync_work more
symmetric.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |  3 ---
 fs/ocfs2/super.c        | 21 ++++++++++++++-------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 7a922190a8c7..0098914dde88 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -401,9 +401,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 						OCFS2_QBLK_RESERVED_SPACE;
 	oinfo->dqi_gi.dqi_qtree_depth = qtree_depth(&oinfo->dqi_gi);
 	INIT_DELAYED_WORK(&oinfo->dqi_sync_work, qsync_work_fn);
-	schedule_delayed_work(&oinfo->dqi_sync_work,
-			      msecs_to_jiffies(oinfo->dqi_syncms));
-
 out_err:
 	return status;
 out_unlock:
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 14c3d5ee6e24..39b62569e7ff 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -910,22 +910,25 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend)
 					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
 					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
 	int status = 0;
+	struct ocfs2_mem_dqinfo *oinfo;
 
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
 			continue;
-		if (unsuspend)
+		oinfo = sb_dqinfo(sb, type)->dqi_priv;
+		if (unsuspend) {
 			status = dquot_resume(sb, type);
-		else {
-			struct ocfs2_mem_dqinfo *oinfo;
-
+			if (status < 0)
+				break;
+			schedule_delayed_work(&oinfo->dqi_sync_work,
+					msecs_to_jiffies(oinfo->dqi_syncms));
+		} else {
 			/* Cancel periodic syncing before suspending */
-			oinfo = sb_dqinfo(sb, type)->dqi_priv;
 			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 			status = dquot_suspend(sb, type);
+			if (status < 0)
+				break;
 		}
-		if (status < 0)
-			break;
 	}
 	if (status < 0)
 		mlog(ML_ERROR, "Failed to suspend/unsuspend quotas on "
@@ -943,6 +946,7 @@ static int ocfs2_enable_quotas(struct ocfs2_super *osb)
 	unsigned int ino[OCFS2_MAXQUOTAS] = {
 					LOCAL_USER_QUOTA_SYSTEM_INODE,
 					LOCAL_GROUP_QUOTA_SYSTEM_INODE };
+	struct ocfs2_mem_dqinfo *oinfo;
 	int status;
 	int type;
 
@@ -960,6 +964,9 @@ static int ocfs2_enable_quotas(struct ocfs2_super *osb)
 				      DQUOT_USAGE_ENABLED);
 		if (status < 0)
 			goto out_quota_off;
+		oinfo = sb_dqinfo(sb, type)->dqi_priv;
+		schedule_delayed_work(&oinfo->dqi_sync_work,
+				      msecs_to_jiffies(oinfo->dqi_syncms));
 	}
 
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++)
-- 
2.13.6
