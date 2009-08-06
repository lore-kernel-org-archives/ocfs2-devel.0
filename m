From: Jan Kara <jack@suse.cz>
Date: Thu,  6 Aug 2009 23:29:34 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix possible deadlock when extending
	quota file
Message-ID: <1249594174-1539-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In OCFS2, allocator locks rank above transaction start. Thus we
cannot extend quota file from inside a transaction less we could
deadlock.

We solve the problem by starting transaction not already in
ocfs2_acquire_dquot() but only in ocfs2_local_read_dquot() and
ocfs2_global_read_dquot() and we allocate blocks to quota files before starting
the transaction.  In case we crash, quota files will just have a few blocks
more but that's no problem since we just use them next time we extend the
quota file.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.h      |    5 --
 fs/ocfs2/quota_global.c |  115 +++++++++++++++++++++++------------------------
 2 files changed, 57 insertions(+), 63 deletions(-)

  Joel, could you please merge this fix? Thanks.

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 4a4d3b5..2c3222a 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -363,11 +363,6 @@ static inline int ocfs2_quota_trans_credits(struct super_block *sb)
 	return credits;
 }
 
-/* Number of credits needed for removing quota structure from file */
-int ocfs2_calc_qdel_credits(struct super_block *sb, int type);
-/* Number of credits needed for initialization of new quota structure */
-int ocfs2_calc_qinit_credits(struct super_block *sb, int type);
-
 /* group extend. inode update and last group update. */
 #define OCFS2_GROUP_EXTEND_CREDITS	(OCFS2_INODE_UPDATE_CREDITS + 1)
 
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 8988d8b..1e24a90 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -224,11 +224,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 		loff_t rounded_end =
 				ocfs2_align_bytes_to_blocks(sb, off + len);
 
-		down_write(&OCFS2_I(gqinode)->ip_alloc_sem);
-		err = ocfs2_extend_no_holes(gqinode, rounded_end, off);
-		up_write(&OCFS2_I(gqinode)->ip_alloc_sem);
-		if (err < 0)
-			goto out;
+		/* Space is already allocated in ocfs2_global_read_dquot() */
 		err = ocfs2_simple_size_update(gqinode,
 					       oinfo->dqi_gqi_bh,
 					       rounded_end);
@@ -414,13 +410,36 @@ int ocfs2_global_write_info(struct super_block *sb, int type)
 	return err;
 }
 
+static int ocfs2_global_qinit_alloc(struct super_block *sb, int type)
+{
+	struct ocfs2_mem_dqinfo *oinfo = sb_dqinfo(sb, type)->dqi_priv;
+
+	/*
+	 * We may need to allocate tree blocks and a leaf block but not the
+	 * root block
+	 */
+	return oinfo->dqi_gi.dqi_qtree_depth;
+}
+
+static int ocfs2_calc_global_qinit_credits(struct super_block *sb, int type)
+{
+	/* We modify all the allocated blocks, tree root, and info block */
+	return (ocfs2_global_qinit_alloc(sb, type) + 2) *
+			OCFS2_QUOTA_BLOCK_UPDATE_CREDITS;
+}
+
 /* Read in information from global quota file and acquire a reference to it.
  * dquot_acquire() has already started the transaction and locked quota file */
 int ocfs2_global_read_dquot(struct dquot *dquot)
 {
 	int err, err2, ex = 0;
-	struct ocfs2_mem_dqinfo *info =
-			sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv;
+	struct super_block *sb = dquot->dq_sb;
+	int type = dquot->dq_type;
+	struct ocfs2_mem_dqinfo *info = sb_dqinfo(sb, type)->dqi_priv;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	struct inode *gqinode = info->dqi_gqinode;
+	int need_alloc = ocfs2_global_qinit_alloc(sb, type);
+	handle_t *handle = NULL;
 
 	err = ocfs2_qinfo_lock(info, 0);
 	if (err < 0)
@@ -431,14 +450,33 @@ int ocfs2_global_read_dquot(struct dquot *dquot)
 	OCFS2_DQUOT(dquot)->dq_use_count++;
 	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
 	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
+	ocfs2_qinfo_unlock(info, 0);
+
 	if (!dquot->dq_off) {	/* No real quota entry? */
-		/* Upgrade to exclusive lock for allocation */
-		ocfs2_qinfo_unlock(info, 0);
-		err = ocfs2_qinfo_lock(info, 1);
-		if (err < 0)
-			goto out_qlock;
 		ex = 1;
+		/*
+		 * Add blocks to quota file before we start a transaction since
+		 * locking allocators ranks above a transaction start
+		 */
+		WARN_ON(journal_current_handle());
+		down_write(&OCFS2_I(gqinode)->ip_alloc_sem);
+		err = ocfs2_extend_no_holes(gqinode,
+			gqinode->i_size + (need_alloc << sb->s_blocksize_bits),
+			gqinode->i_size);
+		up_write(&OCFS2_I(gqinode)->ip_alloc_sem);
+		if (err < 0)
+			goto out;
+	}
+
+	handle = ocfs2_start_trans(osb,
+				   ocfs2_calc_global_qinit_credits(sb, type));
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out;
 	}
+	err = ocfs2_qinfo_lock(info, ex);
+	if (err < 0)
+		goto out_trans;
 	err = qtree_write_dquot(&info->dqi_gi, dquot);
 	if (ex && info_dirty(sb_dqinfo(dquot->dq_sb, dquot->dq_type))) {
 		err2 = __ocfs2_global_write_info(dquot->dq_sb, dquot->dq_type);
@@ -450,6 +488,9 @@ out_qlock:
 		ocfs2_qinfo_unlock(info, 1);
 	else
 		ocfs2_qinfo_unlock(info, 0);
+out_trans:
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
 out:
 	if (err < 0)
 		mlog_errno(err);
@@ -647,24 +688,17 @@ out:
 	return status;
 }
 
-int ocfs2_calc_qdel_credits(struct super_block *sb, int type)
+static int ocfs2_calc_qdel_credits(struct super_block *sb, int type)
 {
-	struct ocfs2_mem_dqinfo *oinfo;
-	int features[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
-				    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA };
-
-	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, features[type]))
-		return 0;
-
-	oinfo = sb_dqinfo(sb, type)->dqi_priv;
+	struct ocfs2_mem_dqinfo *oinfo = sb_dqinfo(sb, type)->dqi_priv;
 	/*
 	 * We modify tree, leaf block, global info, local chunk header,
 	 * global and local inode; OCFS2_QINFO_WRITE_CREDITS already
 	 * accounts for inode update
 	 */
-	return oinfo->dqi_gi.dqi_qtree_depth +
+	return (oinfo->dqi_gi.dqi_qtree_depth + 2) *
+	       OCFS2_QUOTA_BLOCK_UPDATE_CREDITS +
 	       OCFS2_QINFO_WRITE_CREDITS +
-	       2 * OCFS2_QUOTA_BLOCK_UPDATE_CREDITS +
 	       OCFS2_INODE_UPDATE_CREDITS;
 }
 
@@ -697,36 +731,10 @@ out:
 	return status;
 }
 
-int ocfs2_calc_qinit_credits(struct super_block *sb, int type)
-{
-	struct ocfs2_mem_dqinfo *oinfo;
-	int features[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
-				    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA };
-	struct ocfs2_dinode *lfe, *gfe;
-
-	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, features[type]))
-		return 0;
-
-	oinfo = sb_dqinfo(sb, type)->dqi_priv;
-	gfe = (struct ocfs2_dinode *)oinfo->dqi_gqi_bh->b_data;
-	lfe = (struct ocfs2_dinode *)oinfo->dqi_lqi_bh->b_data;
-	/* We can extend local file + global file. In local file we
-	 * can modify info, chunk header block and dquot block. In
-	 * global file we can modify info, tree and leaf block */
-	return ocfs2_calc_extend_credits(sb, &lfe->id2.i_list, 0) +
-	       ocfs2_calc_extend_credits(sb, &gfe->id2.i_list, 0) +
-	       OCFS2_LOCAL_QINFO_WRITE_CREDITS +
-	       2 * OCFS2_QUOTA_BLOCK_UPDATE_CREDITS +
-	       oinfo->dqi_gi.dqi_qtree_depth +
-	       2 * OCFS2_QUOTA_BLOCK_UPDATE_CREDITS;
-}
-
 static int ocfs2_acquire_dquot(struct dquot *dquot)
 {
-	handle_t *handle;
 	struct ocfs2_mem_dqinfo *oinfo =
 			sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv;
-	struct ocfs2_super *osb = OCFS2_SB(dquot->dq_sb);
 	int status = 0;
 
 	mlog_entry("id=%u, type=%d", dquot->dq_id, dquot->dq_type);
@@ -735,16 +743,7 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 	status = ocfs2_lock_global_qf(oinfo, 1);
 	if (status < 0)
 		goto out;
-	handle = ocfs2_start_trans(osb,
-		ocfs2_calc_qinit_credits(dquot->dq_sb, dquot->dq_type));
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		mlog_errno(status);
-		goto out_ilock;
-	}
 	status = dquot_acquire(dquot);
-	ocfs2_commit_trans(osb, handle);
-out_ilock:
 	ocfs2_unlock_global_qf(oinfo, 1);
 out:
 	mlog_exit(status);
-- 
1.6.0.2
