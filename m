From: Jan Kara <jack@suse.cz>
Date: Thu, 13 May 2010 21:58:02 +0200
Subject: [Ocfs2-devel] [PATCH 6/7] ocfs2: Fix NULL pointer deref when
	writing local dquot
In-Reply-To: <1273780683-3638-1-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
Message-ID: <1273780683-3638-7-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

commit_dqblk() can write quota info to global file. That is actually a bad
thing to do because if we are just modifying local quota file, we are not
prepared (do not hold proper locks, do not have transaction credits) to do
a modification of the global quota file. So do not use commit_dqblk() and
instead call our writing function directly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota.h        |    1 +
 fs/ocfs2/quota_global.c |   20 ++++++++++----------
 fs/ocfs2/quota_local.c  |    3 +--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index 903ffa9..196fcb5 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -109,6 +109,7 @@ int ocfs2_read_quota_phys_block(struct inode *inode, u64 p_block,
 				struct buffer_head **bh);
 int ocfs2_create_local_dquot(struct dquot *dquot);
 int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot);
+int ocfs2_local_write_dquot(struct dquot *dquot);
 
 extern const struct dquot_operations ocfs2_quota_operations;
 extern struct quota_format_type ocfs2_quota_format;
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index f555652..745be37 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -614,14 +614,13 @@ static int ocfs2_sync_dquot_helper(struct dquot *dquot, unsigned long type)
 	}
 	mutex_lock(&sb_dqopt(sb)->dqio_mutex);
 	status = ocfs2_sync_dquot(dquot);
-	mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
 	if (status < 0)
 		mlog_errno(status);
 	/* We have to write local structure as well... */
-	dquot_mark_dquot_dirty(dquot);
-	status = dquot_commit(dquot);
+	status = ocfs2_local_write_dquot(dquot);
 	if (status < 0)
 		mlog_errno(status);
+	mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
 	ocfs2_commit_trans(osb, handle);
 out_ilock:
 	ocfs2_unlock_global_qf(oinfo, 1);
@@ -660,7 +659,9 @@ static int ocfs2_write_dquot(struct dquot *dquot)
 		mlog_errno(status);
 		goto out;
 	}
-	status = dquot_commit(dquot);
+	mutex_lock(&sb_dqopt(dquot->dq_sb)->dqio_mutex);
+	status = ocfs2_local_write_dquot(dquot);
+	mutex_unlock(&sb_dqopt(dquot->dq_sb)->dqio_mutex);
 	ocfs2_commit_trans(osb, handle);
 out:
 	mlog_exit(status);
@@ -833,7 +834,6 @@ static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	mlog_entry("id=%u, type=%d", dquot->dq_id, type);
-	dquot_mark_dquot_dirty(dquot);
 
 	/* In case user set some limits, sync dquot immediately to global
 	 * quota file so that information propagates quicker */
@@ -858,14 +858,14 @@ static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
 	}
 	mutex_lock(&sb_dqopt(sb)->dqio_mutex);
 	status = ocfs2_sync_dquot(dquot);
-	mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_trans;
+		goto out_dlock;
 	}
 	/* Now write updated local dquot structure */
-	status = dquot_commit(dquot);
-out_trans:
+	status = ocfs2_local_write_dquot(dquot);
+out_dlock:
+	mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
 	ocfs2_commit_trans(osb, handle);
 out_ilock:
 	ocfs2_unlock_global_qf(oinfo, 1);
@@ -917,7 +917,7 @@ static void ocfs2_destroy_dquot(struct dquot *dquot)
 }
 
 const struct dquot_operations ocfs2_quota_operations = {
-	.write_dquot	= ocfs2_write_dquot,
+	/* We never make dquot dirty so .write_dquot is never called */
 	.acquire_dquot	= ocfs2_acquire_dquot,
 	.release_dquot	= ocfs2_release_dquot,
 	.mark_dirty	= ocfs2_mark_dquot_dirty,
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 5e62e44..c24c7c5 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -900,7 +900,7 @@ static void olq_set_dquot(struct buffer_head *bh, void *private)
 }
 
 /* Write dquot to local quota file */
-static int ocfs2_local_write_dquot(struct dquot *dquot)
+int ocfs2_local_write_dquot(struct dquot *dquot)
 {
 	struct super_block *sb = dquot->dq_sb;
 	struct ocfs2_dquot *od = OCFS2_DQUOT(dquot);
@@ -1335,7 +1335,6 @@ static const struct quota_format_ops ocfs2_format_ops = {
 	.read_file_info		= ocfs2_local_read_info,
 	.write_file_info	= ocfs2_global_write_info,
 	.free_file_info		= ocfs2_local_free_info,
-	.commit_dqblk		= ocfs2_local_write_dquot,
 };
 
 struct quota_format_type ocfs2_quota_format = {
-- 
1.6.4.2
