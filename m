From: Jan Kara <jack@suse.cz>
Date: Thu, 24 Nov 2016 09:12:38 +0100
Subject: [Ocfs2-devel] [PATCH 3/7] quota: Use s_umount protection for quota
	operations
In-Reply-To: <1479975162-24060-1-git-send-email-jack@suse.cz>
References: <1479975162-24060-1-git-send-email-jack@suse.cz>
Message-ID: <1479975162-24060-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, mfasheh@versity.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Writeback quota is protected by s_umount semaphore held for reading
because every writeback must be protected by that lock (grabbed either
by the generic writeback code or by quotactl handler). Getting next
available ID in quota file, querying quota state, setting quota
information, getting quota format are all quotactl operations protected
by s_umount semaphore held for reading grabbed in quotactl handler.

This also fixes lockdep splat about possible deadlock during filesystem
freezing where sync_filesystem() is called with page-faults already
blocked but sync_filesystem() calls into dquot_writeback_dquots() which
grabs dqonoff_mutex which ranks above i_mutex (vfs_load_quota_inode()
grabs i_mutex under dqonoff_mutex) which clearly ranks below page fault
freeze protection (e.g. via mmap_sem dependencies). The reported problem
is not a real deadlock possibility since during quota on we check
whether filesystem freezing is not in progress but still it is good to
have this fixed.

Reported-by: Ted Tso <tytso@mit.edu>
Reported-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 39 ++++++++++-----------------------------
 fs/quota/quota.c |  6 +-----
 2 files changed, 11 insertions(+), 34 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 047afb966420..2a9dc3fb491c 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -617,7 +617,8 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 	int cnt;
 	int err, ret = 0;
 
-	mutex_lock(&dqopt->dqonoff_mutex);
+	WARN_ON_ONCE(!rwsem_is_locked(&sb->s_umount));
+
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
@@ -653,7 +654,6 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 		    && info_dirty(&dqopt->info[cnt]))
 			sb->dq_op->write_info(sb, cnt);
 	dqstats_inc(DQST_SYNCS);
-	mutex_unlock(&dqopt->dqonoff_mutex);
 
 	return ret;
 }
@@ -683,7 +683,6 @@ int dquot_quota_sync(struct super_block *sb, int type)
 	 * Now when everything is written we can discard the pagecache so
 	 * that userspace sees the changes.
 	 */
-	mutex_lock(&dqopt->dqonoff_mutex);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
@@ -693,7 +692,6 @@ int dquot_quota_sync(struct super_block *sb, int type)
 		truncate_inode_pages(&dqopt->files[cnt]->i_data, 0);
 		inode_unlock(dqopt->files[cnt]);
 	}
-	mutex_unlock(&dqopt->dqonoff_mutex);
 
 	return 0;
 }
@@ -2050,21 +2048,13 @@ int dquot_get_next_id(struct super_block *sb, struct kqid *qid)
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int err;
 
-	mutex_lock(&dqopt->dqonoff_mutex);
-	if (!sb_has_quota_active(sb, qid->type)) {
-		err = -ESRCH;
-		goto out;
-	}
-	if (!dqopt->ops[qid->type]->get_next_id) {
-		err = -ENOSYS;
-		goto out;
-	}
+	if (!sb_has_quota_active(sb, qid->type))
+		return -ESRCH;
+	if (!dqopt->ops[qid->type]->get_next_id)
+		return -ENOSYS;
 	mutex_lock(&dqopt->dqio_mutex);
 	err = dqopt->ops[qid->type]->get_next_id(sb, qid);
 	mutex_unlock(&dqopt->dqio_mutex);
-out:
-	mutex_unlock(&dqopt->dqonoff_mutex);
-
 	return err;
 }
 EXPORT_SYMBOL(dquot_get_next_id);
@@ -2762,7 +2752,6 @@ int dquot_get_state(struct super_block *sb, struct qc_state *state)
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int type;
   
-	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
 	memset(state, 0, sizeof(*state));
 	for (type = 0; type < MAXQUOTAS; type++) {
 		if (!sb_has_quota_active(sb, type))
@@ -2784,7 +2773,6 @@ int dquot_get_state(struct super_block *sb, struct qc_state *state)
 		tstate->nextents = 1;	/* We don't know... */
 		spin_unlock(&dq_data_lock);
 	}
-	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
 EXPORT_SYMBOL(dquot_get_state);
@@ -2798,18 +2786,13 @@ int dquot_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii)
 	if ((ii->i_fieldmask & QC_WARNS_MASK) ||
 	    (ii->i_fieldmask & QC_RT_SPC_TIMER))
 		return -EINVAL;
-	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
-	if (!sb_has_quota_active(sb, type)) {
-		err = -ESRCH;
-		goto out;
-	}
+	if (!sb_has_quota_active(sb, type))
+		return -ESRCH;
 	mi = sb_dqopt(sb)->info + type;
 	if (ii->i_fieldmask & QC_FLAGS) {
 		if ((ii->i_flags & QCI_ROOT_SQUASH &&
-		     mi->dqi_format->qf_fmt_id != QFMT_VFS_OLD)) {
-			err = -EINVAL;
-			goto out;
-		}
+		     mi->dqi_format->qf_fmt_id != QFMT_VFS_OLD))
+			return -EINVAL;
 	}
 	spin_lock(&dq_data_lock);
 	if (ii->i_fieldmask & QC_SPC_TIMER)
@@ -2826,8 +2809,6 @@ int dquot_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii)
 	mark_info_dirty(sb, type);
 	/* Force write to disk */
 	sb->dq_op->write_info(sb, type);
-out:
-	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return err;
 }
 EXPORT_SYMBOL(dquot_set_dqinfo);
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 790c61abc663..0c8041688dcf 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -104,13 +104,9 @@ static int quota_getfmt(struct super_block *sb, int type, void __user *addr)
 {
 	__u32 fmt;
 
-	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
-	if (!sb_has_quota_active(sb, type)) {
-		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
+	if (!sb_has_quota_active(sb, type))
 		return -ESRCH;
-	}
 	fmt = sb_dqopt(sb)->info[type].dqi_format->qf_fmt_id;
-	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	if (copy_to_user(addr, &fmt, sizeof(fmt)))
 		return -EFAULT;
 	return 0;
-- 
2.6.6
