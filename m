From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Jul 2009 13:17:21 +0200
Subject: [Ocfs2-devel] [PATCH 7/7] ocfs2: Define credit counts for quota
	operations
In-Reply-To: <1248261441-29384-1-git-send-email-jack@suse.cz>
References: <1248261441-29384-1-git-send-email-jack@suse.cz>
Message-ID: <1248261441-29384-8-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Numbers of needed credits for some quota operations were written
as raw numbers. Create appropriate defines instead.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.h      |   13 ++++++++++---
 fs/ocfs2/quota_global.c |   18 +++++++++++++-----
 fs/ocfs2/quota_local.c  |   16 ++++++++++++----
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 5432c7f..edb8088 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -329,20 +329,27 @@ int                  ocfs2_journal_dirty(handle_t *handle,
 /* extended attribute block update */
 #define OCFS2_XATTR_BLOCK_UPDATE_CREDITS 1
 
+/* Update of a single quota block */
+#define OCFS2_QUOTA_BLOCK_UPDATE_CREDITS 1
+
 /* global quotafile inode update, data block */
-#define OCFS2_QINFO_WRITE_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 1)
+#define OCFS2_QINFO_WRITE_CREDITS (OCFS2_INODE_UPDATE_CREDITS + \
+				   OCFS2_QUOTA_BLOCK_UPDATE_CREDITS)
 
+#define OCFS2_LOCAL_QINFO_WRITE_CREDITS OCFS2_QUOTA_BLOCK_UPDATE_CREDITS
 /*
  * The two writes below can accidentally see global info dirty due
  * to set_info() quotactl so make them prepared for the writes.
  */
 /* quota data block, global info */
 /* Write to local quota file */
-#define OCFS2_QWRITE_CREDITS (OCFS2_QINFO_WRITE_CREDITS + 1)
+#define OCFS2_QWRITE_CREDITS (OCFS2_QINFO_WRITE_CREDITS + \
+			      OCFS2_QUOTA_BLOCK_UPDATE_CREDITS)
 
 /* global quota data block, local quota data block, global quota inode,
  * global quota info */
-#define OCFS2_QSYNC_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 3)
+#define OCFS2_QSYNC_CREDITS (OCFS2_QINFO_WRITE_CREDITS + \
+			     2 * OCFS2_QUOTA_BLOCK_UPDATE_CREDITS)
 
 static inline int ocfs2_quota_trans_credits(struct super_block *sb)
 {
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index dab4546..cc8785c 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -648,10 +648,15 @@ int ocfs2_calc_qdel_credits(struct super_block *sb, int type)
 		return 0;
 
 	oinfo = sb_dqinfo(sb, type)->dqi_priv;
-	/* We modify tree, leaf block, global info, local chunk header,
-	 * global and local inode */
-	return oinfo->dqi_gi.dqi_qtree_depth + 2 + 1 +
-	       2 * OCFS2_INODE_UPDATE_CREDITS;
+	/*
+	 * We modify tree, leaf block, global info, local chunk header,
+	 * global and local inode; OCFS2_QINFO_WRITE_CREDITS already
+	 * accounts for inode update
+	 */
+	return oinfo->dqi_gi.dqi_qtree_depth +
+	       OCFS2_QINFO_WRITE_CREDITS +
+	       2 * OCFS2_QUOTA_BLOCK_UPDATE_CREDITS +
+	       OCFS2_INODE_UPDATE_CREDITS;
 }
 
 static int ocfs2_release_dquot(struct dquot *dquot)
@@ -701,7 +706,10 @@ int ocfs2_calc_qinit_credits(struct super_block *sb, int type)
 	 * global file we can modify info, tree and leaf block */
 	return ocfs2_calc_extend_credits(sb, &lfe->id2.i_list, 0) +
 	       ocfs2_calc_extend_credits(sb, &gfe->id2.i_list, 0) +
-	       3 + oinfo->dqi_gi.dqi_qtree_depth + 2;
+	       OCFS2_LOCAL_QINFO_WRITE_CREDITS +
+	       2 * OCFS2_QUOTA_BLOCK_UPDATE_CREDITS +
+	       oinfo->dqi_gi.dqi_qtree_depth +
+	       2 * OCFS2_QUOTA_BLOCK_UPDATE_CREDITS;
 }
 
 static int ocfs2_acquire_dquot(struct dquot *dquot)
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 9d2993d..bdb09cb 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -101,7 +101,8 @@ static int ocfs2_modify_bh(struct inode *inode, struct buffer_head *bh,
 	handle_t *handle;
 	int status;
 
-	handle = ocfs2_start_trans(OCFS2_SB(sb), 1);
+	handle = ocfs2_start_trans(OCFS2_SB(sb),
+				   OCFS2_QUOTA_BLOCK_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
@@ -611,7 +612,8 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			goto out_bh;
 		/* Mark quota file as clean if we are recovering quota file of
 		 * some other node. */
-		handle = ocfs2_start_trans(osb, 1);
+		handle = ocfs2_start_trans(osb,
+					   OCFS2_LOCAL_QINFO_WRITE_CREDITS);
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
 			mlog_errno(status);
@@ -965,7 +967,10 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 		mlog_errno(status);
 		goto out;
 	}
-	handle = ocfs2_start_trans(OCFS2_SB(sb), 3);
+	/* Local quota info and two new blocks we initialize */
+	handle = ocfs2_start_trans(OCFS2_SB(sb),
+			OCFS2_LOCAL_QINFO_WRITE_CREDITS +
+			2 * OCFS2_QUOTA_BLOCK_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
@@ -1128,7 +1133,10 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 	}
 	ocfs2_set_new_buffer_uptodate(lqinode, bh);
 
-	handle = ocfs2_start_trans(OCFS2_SB(sb), 3);
+	/* Local quota info, chunk header and the new block we initialize */
+	handle = ocfs2_start_trans(OCFS2_SB(sb),
+			OCFS2_LOCAL_QINFO_WRITE_CREDITS +
+			2 * OCFS2_QUOTA_BLOCK_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
-- 
1.6.0.2
