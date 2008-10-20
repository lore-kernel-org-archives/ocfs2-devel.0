From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:24:00 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Implement quota syncing thread
In-Reply-To: y
References: y
Message-ID: <12245234442314-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch implements functions and timer setup which handles periodic
syncing of locally cached quota information to global quota file.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota.h        |    3 ++
 fs/ocfs2/quota_global.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/quota_local.c  |    4 +++
 3 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index 33b47eb..f837265 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -14,6 +14,7 @@
 #include <linux/quota.h>
 #include <linux/list.h>
 #include <linux/dqblk_qtree.h>
+#include <linux/timer.h>
 
 #include "ocfs2.h"
 
@@ -67,6 +68,7 @@ struct ocfs2_mem_dqinfo {
 	unsigned int dqi_chunks;	/* Number of chunks in local quota file */
 	unsigned int dqi_blocks;	/* Number of blocks allocated for local quota file */
 	unsigned int dqi_syncms;	/* How often should we sync with other nodes */
+	unsigned int dqi_syncjiff;	/* Precomputed dqi_syncms in jiffies */
 	struct list_head dqi_chunk;	/* List of chunks */
 	struct inode *dqi_gqinode;	/* Global quota file inode */
 	struct ocfs2_lock_res dqi_gqlock;	/* Lock protecting quota information structure */
@@ -74,6 +76,7 @@ struct ocfs2_mem_dqinfo {
 	struct buffer_head *dqi_lqi_bh;	/* Buffer head with local quota file inode */
 	struct buffer_head *dqi_ibh;	/* Buffer with information header */
 	struct qtree_mem_dqinfo dqi_gi;	/* Info about global file */
+	struct timer_list dqi_sync_timer;	/* Timer for syncing dquots */
 };
 
 static inline struct ocfs2_dquot *OCFS2_DQUOT(struct dquot *dquot)
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index c4424fd..be1d436 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -1,10 +1,14 @@
 /*
  *  Implementation of operations over global quota file
  */
+#include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/quota.h>
 #include <linux/quotaops.h>
 #include <linux/dqblk_qtree.h>
+#include <linux/jiffies.h>
+#include <linux/timer.h>
+#include <linux/writeback.h>
 
 #define MLOG_MASK_PREFIX ML_QUOTA
 #include <cluster/masklog.h>
@@ -19,6 +23,8 @@
 #include "dlmglue.h"
 #include "quota.h"
 
+static void qsync_timer_fn(unsigned long oinfo_ptr);
+
 static void ocfs2_global_disk2memdqb(struct dquot *dquot, void *dp)
 {
 	struct ocfs2_global_disk_dqblk *d = dp;
@@ -236,11 +242,17 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
 	oinfo->dqi_syncms = le32_to_cpu(dinfo.dqi_syncms);
+	oinfo->dqi_syncjiff = msecs_to_jiffies(oinfo->dqi_syncms);
 	oinfo->dqi_gi.dqi_blocks = le32_to_cpu(dinfo.dqi_blocks);
 	oinfo->dqi_gi.dqi_free_blk = le32_to_cpu(dinfo.dqi_free_blk);
 	oinfo->dqi_gi.dqi_free_entry = le32_to_cpu(dinfo.dqi_free_entry);
 	oinfo->dqi_gi.dqi_blocksize_bits =
 				le32_to_cpu(dinfo.dqi_blocksize_bits);
+
+	setup_timer(&oinfo->dqi_sync_timer, qsync_timer_fn,
+		    (unsigned long)oinfo);
+	mod_timer(&oinfo->dqi_sync_timer,
+		  round_jiffies(jiffies + oinfo->dqi_syncjiff));
 out_err:
 	mlog_exit(status);
 	return status;
@@ -427,6 +439,60 @@ out:
 }
 
 /*
+ *  Functions for periodic syncing of dquots with global file
+ */
+static int ocfs2_sync_dquot_helper(struct dquot *dquot, unsigned long type)
+{
+	handle_t *handle;
+	struct super_block *sb = dquot->dq_sb;
+	struct ocfs2_mem_dqinfo *oinfo = sb_dqinfo(sb, type)->dqi_priv;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	int status = 0;
+
+	mlog_entry("id=%u qtype=%u type=%lu device=%s\n", dquot->dq_id,
+		   dquot->dq_type, type, sb->s_id);
+	if (type != dquot->dq_type)
+		goto out;
+	status = ocfs2_inode_lock(oinfo->dqi_gqinode, &oinfo->dqi_gqi_bh, 1);
+	if (status < 0)
+		goto out;
+
+	handle = ocfs2_start_trans(osb, OCFS2_QSYNC_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		mlog_errno(status);
+		goto out_ilock;
+	}
+	/* This also removes dquot from the list */
+	ocfs2_sync_dquot(dquot);
+	ocfs2_commit_trans(osb, handle);
+out_ilock:
+	brelse(oinfo->dqi_gqi_bh);
+	oinfo->dqi_gqi_bh = NULL;
+	ocfs2_inode_unlock(oinfo->dqi_gqinode, 1);
+out:
+	mlog_exit(status);
+	return status;
+}
+
+static void ocfs2_do_qsync(unsigned long oinfo_ptr)
+{
+	struct ocfs2_mem_dqinfo *oinfo = (struct ocfs2_mem_dqinfo *)oinfo_ptr;
+	struct super_block *sb = oinfo->dqi_gqinode->i_sb;
+
+	dquot_scan_active(sb, ocfs2_sync_dquot_helper, oinfo->dqi_type);
+}
+
+static void qsync_timer_fn(unsigned long oinfo_ptr)
+{
+	struct ocfs2_mem_dqinfo *oinfo = (struct ocfs2_mem_dqinfo *)oinfo_ptr;
+
+	pdflush_operation(ocfs2_do_qsync, oinfo_ptr);
+	mod_timer(&oinfo->dqi_sync_timer,
+		  round_jiffies(jiffies + oinfo->dqi_syncjiff));
+}
+
+/*
  *  Wrappers for generic quota functions
  */
 
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 719659b..17509bd 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -367,6 +367,10 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	int mark_clean = 1, len;
 	int status;
 
+	/* At this point we know there are no more dquots and thus
+	 * even if there's some sync in the pdflush queue, it won't
+	 * find any dquots and return without doing anything */
+	del_timer_sync(&oinfo->dqi_sync_timer);
 	iput(oinfo->dqi_gqinode);
 	ocfs2_simple_drop_lockres(OCFS2_SB(sb), &oinfo->dqi_gqlock);
 	ocfs2_lock_res_free(&oinfo->dqi_gqlock);
-- 
1.5.2.4
