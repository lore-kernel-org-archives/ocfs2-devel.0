From: Jan Kara <jack@suse.cz>
Date: Wed, 15 Jul 2009 17:55:04 +0200
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: Remove syncjiff field from quota
	info
In-Reply-To: <1247673304-31080-1-git-send-email-jack@suse.cz>
References: <1247673304-31080-1-git-send-email-jack@suse.cz>
Message-ID: <1247673304-31080-7-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

syncjiff is just a converted value of syncms. Some places which
are updating syncms forgot to update syncjiff as well. Since the
conversion is just a simple division / multiplication and it does
not happen frequently, just remove the syncjiff field to avoid
forgotten conversions.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c         |    4 +++-
 fs/ocfs2/quota.h        |    1 -
 fs/ocfs2/quota_global.c |    5 ++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b2c52b3..eaa268f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -138,9 +138,11 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
 	mlog_entry("(0x%p, %llu, 0x%p, %d)\n", inode,
 		   (unsigned long long)iblock, bh_result, create);
 
-	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
+	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
 		mlog(ML_NOTICE, "get_block on system inode 0x%p (%lu)\n",
 		     inode, inode->i_ino);
+		dump_stack();
+	}
 
 	if (S_ISLNK(inode->i_mode)) {
 		/* this always does I/O for some reason. */
diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index 7365e2e..3fb96fc 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -50,7 +50,6 @@ struct ocfs2_mem_dqinfo {
 	unsigned int dqi_chunks;	/* Number of chunks in local quota file */
 	unsigned int dqi_blocks;	/* Number of blocks allocated for local quota file */
 	unsigned int dqi_syncms;	/* How often should we sync with other nodes */
-	unsigned int dqi_syncjiff;	/* Precomputed dqi_syncms in jiffies */
 	struct list_head dqi_chunk;	/* List of chunks */
 	struct inode *dqi_gqinode;	/* Global quota file inode */
 	struct ocfs2_lock_res dqi_gqlock;	/* Lock protecting quota information structure */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 8437c6b..c9bb9c7 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -345,7 +345,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
 	oinfo->dqi_syncms = le32_to_cpu(dinfo.dqi_syncms);
-	oinfo->dqi_syncjiff = msecs_to_jiffies(oinfo->dqi_syncms);
 	oinfo->dqi_gi.dqi_blocks = le32_to_cpu(dinfo.dqi_blocks);
 	oinfo->dqi_gi.dqi_free_blk = le32_to_cpu(dinfo.dqi_free_blk);
 	oinfo->dqi_gi.dqi_free_entry = le32_to_cpu(dinfo.dqi_free_entry);
@@ -355,7 +354,7 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	oinfo->dqi_gi.dqi_qtree_depth = qtree_depth(&oinfo->dqi_gi);
 	INIT_DELAYED_WORK(&oinfo->dqi_sync_work, qsync_work_fn);
 	queue_delayed_work(ocfs2_quota_wq, &oinfo->dqi_sync_work,
-			   oinfo->dqi_syncjiff);
+			   msecs_to_jiffies(oinfo->dqi_syncms));
 
 out_err:
 	mlog_exit(status);
@@ -610,7 +609,7 @@ static void qsync_work_fn(struct work_struct *work)
 
 	dquot_scan_active(sb, ocfs2_sync_dquot_helper, oinfo->dqi_type);
 	queue_delayed_work(ocfs2_quota_wq, &oinfo->dqi_sync_work,
-			   oinfo->dqi_syncjiff);
+			   msecs_to_jiffies(oinfo->dqi_syncms));
 }
 
 /*
-- 
1.6.0.2
