From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:08:20 +0200
Subject: [Ocfs2-devel] [PATCH 27/29] ocfs2: Implement quota syncing thread
In-Reply-To: <122488610212-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
Message-ID: <1224886104833-git-send-email-jack@suse.cz>
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
 fs/ocfs2/quota_global.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/quota_local.c  |    4 ++
 3 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index 87545ca..179c635 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -14,6 +14,7 @@
 #include <linux/quota.h>
 #include <linux/list.h>
 #include <linux/dqblk_qtree.h>
+#include <linux/timer.h>
 
 #include "ocfs2.h"
 
@@ -43,6 +44,7 @@ struct ocfs2_mem_dqinfo {
 	unsigned int dqi_chunks;	/* Number of chunks in local quota file */
 	unsigned int dqi_blocks;	/* Number of blocks allocated for local quota file */
 	unsigned int dqi_syncms;	/* How often should we sync with other nodes */
+	unsigned int dqi_syncjiff;	/* Precomputed dqi_syncms in jiffies */
 	struct list_head dqi_chunk;	/* List of chunks */
 	struct inode *dqi_gqinode;	/* Global quota file inode */
 	struct ocfs2_lock_res dqi_gqlock;	/* Lock protecting quota information structure */
@@ -51,6 +53,7 @@ struct ocfs2_mem_dqinfo {
 	struct buffer_head *dqi_lqi_bh;	/* Buffer head with local quota file inode */
 	struct buffer_head *dqi_ibh;	/* Buffer with information header */
 	struct qtree_mem_dqinfo dqi_gi;	/* Info about global file */
+	struct timer_list dqi_sync_timer;	/* Timer for syncing dquots */
 };
 
 static inline struct ocfs2_dquot *OCFS2_DQUOT(struct dquot *dquot)
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index b937f07..39b860f 100644
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
@@ -276,6 +282,7 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
 	oinfo->dqi_syncms = le32_to_cpu(dinfo.dqi_syncms);
+	oinfo->dqi_syncjiff = msecs_to_jiffies(oinfo->dqi_syncms);
 	oinfo->dqi_gi.dqi_blocks = le32_to_cpu(dinfo.dqi_blocks);
 	oinfo->dqi_gi.dqi_free_blk = le32_to_cpu(dinfo.dqi_free_blk);
 	oinfo->dqi_gi.dqi_free_entry = le32_to_cpu(dinfo.dqi_free_entry);
@@ -283,6 +290,10 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	oinfo->dqi_gi.dqi_usable_bs = sb->s_blocksize -
 						OCFS2_QBLK_RESERVED_SPACE;
 	oinfo->dqi_gi.dqi_qtree_depth = qtree_depth(&oinfo->dqi_gi);
+	setup_timer(&oinfo->dqi_sync_timer, qsync_timer_fn,
+		    (unsigned long)oinfo);
+	mod_timer(&oinfo->dqi_sync_timer,
+		  round_jiffies(jiffies + oinfo->dqi_syncjiff));
 out_err:
 	mlog_exit(status);
 	return status;
@@ -470,6 +481,66 @@ out:
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
+	status = ocfs2_lock_global_qf(oinfo, 1);
+	if (status < 0)
+		goto out;
+
+	handle = ocfs2_start_trans(osb, OCFS2_QSYNC_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		mlog_errno(status);
+		goto out_ilock;
+	}
+	mutex_lock(&sb_dqopt(sb)->dqio_mutex);
+	status = ocfs2_sync_dquot(dquot);
+	mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
+	if (status < 0)
+		mlog_errno(status);
+	/* We have to write local structure as well... */
+	dquot_mark_dquot_dirty(dquot);
+	status = dquot_commit(dquot);
+	if (status < 0)
+		mlog_errno(status);
+	ocfs2_commit_trans(osb, handle);
+out_ilock:
+	ocfs2_unlock_global_qf(oinfo, 1);
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
index 55c3f2f..1db7a16 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -368,6 +368,10 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
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
