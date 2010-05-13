From: Jan Kara <jack@suse.cz>
Date: Thu, 13 May 2010 21:57:59 +0200
Subject: [Ocfs2-devel] [PATCH 3/7] ocfs2: Avoid unnecessary block mapping
	when refreshing quota info
In-Reply-To: <1273780683-3638-1-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
Message-ID: <1273780683-3638-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The position of global quota file info does not change. So do not have
to do logical -> physical block translation every time we reread it from
disk. Thus we can also avoid taking ip_alloc_sem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dlmglue.c      |    3 ++-
 fs/ocfs2/quota.h        |    3 ++-
 fs/ocfs2/quota_global.c |   15 +++++++++++++++
 fs/ocfs2/quota_local.c  |   10 +++++-----
 4 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 50c4ee8..39eb16a 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3897,7 +3897,8 @@ static int ocfs2_refresh_qinfo(struct ocfs2_mem_dqinfo *oinfo)
 		oinfo->dqi_gi.dqi_free_entry =
 					be32_to_cpu(lvb->lvb_free_entry);
 	} else {
-		status = ocfs2_read_quota_block(oinfo->dqi_gqinode, 0, &bh);
+		status = ocfs2_read_quota_phys_block(oinfo->dqi_gqinode,
+						     oinfo->dqi_giblk, &bh);
 		if (status) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index e22d293..c762343 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -52,8 +52,9 @@ struct ocfs2_mem_dqinfo {
 	struct ocfs2_lock_res dqi_gqlock;	/* Lock protecting quota information structure */
 	struct buffer_head *dqi_gqi_bh;	/* Buffer head with global quota file inode - set only if inode lock is obtained */
 	int dqi_gqi_count;		/* Number of holders of dqi_gqi_bh */
+	u64 dqi_giblk;			/* Number of block with global information header */
 	struct buffer_head *dqi_lqi_bh;	/* Buffer head with local quota file inode */
-	struct buffer_head *dqi_ibh;	/* Buffer with information header */
+	struct buffer_head *dqi_libh;	/* Buffer with local information header */
 	struct qtree_mem_dqinfo dqi_gi;	/* Info about global file */
 	struct delayed_work dqi_sync_work;	/* Work for syncing dquots */
 	struct ocfs2_quota_recovery *dqi_rec;	/* Pointer to recovery
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index e37833b..b571bf8 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -327,6 +327,7 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	struct ocfs2_global_disk_dqinfo dinfo;
 	struct mem_dqinfo *info = sb_dqinfo(sb, type);
 	struct ocfs2_mem_dqinfo *oinfo = info->dqi_priv;
+	u64 pcount;
 	int status;
 
 	mlog_entry_void();
@@ -353,9 +354,19 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 		mlog_errno(status);
 		goto out_err;
 	}
+
+	status = ocfs2_extent_map_get_blocks(gqinode, 0, &oinfo->dqi_giblk,
+					     &pcount, NULL);
+	if (status < 0)
+		goto out_unlock;
+
+	status = ocfs2_qinfo_lock(oinfo, 0);
+	if (status < 0)
+		goto out_unlock;
 	status = sb->s_op->quota_read(sb, type, (char *)&dinfo,
 				      sizeof(struct ocfs2_global_disk_dqinfo),
 				      OCFS2_GLOBAL_INFO_OFF);
+	ocfs2_qinfo_unlock(oinfo, 0);
 	ocfs2_unlock_global_qf(oinfo, 0);
 	if (status != sizeof(struct ocfs2_global_disk_dqinfo)) {
 		mlog(ML_ERROR, "Cannot read global quota info (%d).\n",
@@ -382,6 +393,10 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 out_err:
 	mlog_exit(status);
 	return status;
+out_unlock:
+	ocfs2_unlock_global_qf(oinfo, 0);
+	mlog_errno(status);
+	goto out_err;
 }
 
 /* Write information to global quota file. Expects exlusive lock on quota
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index dbfc8e3..97f2180 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -679,7 +679,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	INIT_LIST_HEAD(&oinfo->dqi_chunk);
 	oinfo->dqi_rec = NULL;
 	oinfo->dqi_lqi_bh = NULL;
-	oinfo->dqi_ibh = NULL;
+	oinfo->dqi_libh = NULL;
 
 	status = ocfs2_global_read_info(sb, type);
 	if (status < 0)
@@ -705,7 +705,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	info->dqi_flags = le32_to_cpu(ldinfo->dqi_flags);
 	oinfo->dqi_chunks = le32_to_cpu(ldinfo->dqi_chunks);
 	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
-	oinfo->dqi_ibh = bh;
+	oinfo->dqi_libh = bh;
 
 	/* We crashed when using local quota file? */
 	if (!(info->dqi_flags & OLQF_CLEAN)) {
@@ -767,7 +767,7 @@ static int ocfs2_local_write_info(struct super_block *sb, int type)
 {
 	struct mem_dqinfo *info = sb_dqinfo(sb, type);
 	struct buffer_head *bh = ((struct ocfs2_mem_dqinfo *)info->dqi_priv)
-						->dqi_ibh;
+						->dqi_libh;
 	int status;
 
 	status = ocfs2_modify_bh(sb_dqopt(sb)->files[type], bh, olq_update_info,
@@ -828,7 +828,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	/* Mark local file as clean */
 	info->dqi_flags |= OLQF_CLEAN;
 	status = ocfs2_modify_bh(sb_dqopt(sb)->files[type],
-				 oinfo->dqi_ibh,
+				 oinfo->dqi_libh,
 				 olq_update_info,
 				 info);
 	if (status < 0) {
@@ -838,7 +838,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 
 out:
 	ocfs2_inode_unlock(sb_dqopt(sb)->files[type], 1);
-	brelse(oinfo->dqi_ibh);
+	brelse(oinfo->dqi_libh);
 	brelse(oinfo->dqi_lqi_bh);
 	kfree(oinfo);
 	return 0;
-- 
1.6.4.2
