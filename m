From: Jan Kara <jack@suse.cz>
Date: Thu, 24 Nov 2016 09:12:39 +0100
Subject: [Ocfs2-devel] [PATCH 4/7] ocfs2: Protect periodic quota syncing
	with s_umount semaphore
In-Reply-To: <1479975162-24060-1-git-send-email-jack@suse.cz>
References: <1479975162-24060-1-git-send-email-jack@suse.cz>
Message-ID: <1479975162-24060-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, mfasheh@versity.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

New quota locking rules will require s_umount semaphore for all quota
scanning functions. Add is for periodic quota syncing.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c | 10 +++++++++-
 fs/ocfs2/super.c        |  1 -
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 87e577a49b0d..cec495a921e3 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -634,7 +634,15 @@ static void qsync_work_fn(struct work_struct *work)
 						      dqi_sync_work.work);
 	struct super_block *sb = oinfo->dqi_gqinode->i_sb;
 
-	dquot_scan_active(sb, ocfs2_sync_dquot_helper, oinfo->dqi_type);
+	/*
+	 * We have to be careful here not to deadlock on s_umount as umount
+	 * disabling quotas may be in progress and it waits for this work to
+	 * complete. If trylock fails, we'll do the sync next time...
+	 */
+	if (down_read_trylock(&sb->s_umount)) {
+		dquot_scan_active(sb, ocfs2_sync_dquot_helper, oinfo->dqi_type);
+		up_read(&sb->s_umount);
+	}
 	schedule_delayed_work(&oinfo->dqi_sync_work,
 			      msecs_to_jiffies(oinfo->dqi_syncms));
 }
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f56fe39fab04..5b9c0dfdb541 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -985,7 +985,6 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!sb_has_quota_loaded(sb, type))
 			continue;
-		/* Cancel periodic syncing before we grab dqonoff_mutex */
 		oinfo = sb_dqinfo(sb, type)->dqi_priv;
 		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 		inode = igrab(sb->s_dquot.files[type]);
-- 
2.6.6
