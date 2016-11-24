From: Jan Kara <jack@suse.cz>
Date: Thu, 24 Nov 2016 09:12:42 +0100
Subject: [Ocfs2-devel] [PATCH 7/7] quota: Remove dqonoff_mutex
In-Reply-To: <1479975162-24060-1-git-send-email-jack@suse.cz>
References: <1479975162-24060-1-git-send-email-jack@suse.cz>
Message-ID: <1479975162-24060-8-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, mfasheh@versity.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

The only places that were grabbing dqonoff_mutex are functions turning
quotas on and off and these are properly serialized using s_umount
semaphore. Remove dqonoff_mutex.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c      | 78 +++++++++++++++------------------------------------
 fs/super.c            |  1 -
 include/linux/quota.h |  1 -
 3 files changed, 23 insertions(+), 57 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index d91aecc939c9..0d9dccac39a8 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -119,8 +119,7 @@
  * spinlock to internal buffers before writing.
  *
  * Lock ordering (including related VFS locks) is the following:
- *   dqonoff_mutex > i_mutex > journal_lock > dquot->dq_lock > dqio_mutex
- * dqonoff_mutex > i_mutex comes from dquot_quota_sync, dquot_enable, etc.
+ *   s_umount > i_mutex > journal_lock > dquot->dq_lock > dqio_mutex
  */
 
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_list_lock);
@@ -933,7 +932,7 @@ static int dqinit_needed(struct inode *inode, int type)
 	return 0;
 }
 
-/* This routine is guarded by dqonoff_mutex mutex */
+/* This routine is guarded by s_umount semaphore */
 static void add_dquot_ref(struct super_block *sb, int type)
 {
 	struct inode *inode, *old_inode = NULL;
@@ -2108,18 +2107,14 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 	    DQUOT_USAGE_ENABLED)))
 		return -EINVAL;
 
-	/* We need to serialize quota_off() for device */
-	mutex_lock(&dqopt->dqonoff_mutex);
-
 	/*
 	 * Skip everything if there's nothing to do. We have to do this because
 	 * sometimes we are called when fill_super() failed and calling
 	 * sync_fs() in such cases does no good.
 	 */
-	if (!sb_any_quota_loaded(sb)) {
-		mutex_unlock(&dqopt->dqonoff_mutex);
+	if (!sb_any_quota_loaded(sb))
 		return 0;
-	}
+
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		toputinode[cnt] = NULL;
 		if (type != -1 && cnt != type)
@@ -2173,7 +2168,6 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 		dqopt->info[cnt].dqi_bgrace = 0;
 		dqopt->ops[cnt] = NULL;
 	}
-	mutex_unlock(&dqopt->dqonoff_mutex);
 
 	/* Skip syncing and setting flags if quota files are hidden */
 	if (dqopt->flags & DQUOT_QUOTA_SYS_FILE)
@@ -2191,19 +2185,13 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 	 * changes done by userspace on the next quotaon() */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		if (toputinode[cnt]) {
-			mutex_lock(&dqopt->dqonoff_mutex);
-			/* If quota was reenabled in the meantime, we have
-			 * nothing to do */
-			if (!sb_has_quota_loaded(sb, cnt)) {
-				inode_lock(toputinode[cnt]);
-				toputinode[cnt]->i_flags &= ~(S_IMMUTABLE |
+			WARN_ON_ONCE(sb_has_quota_loaded(sb, cnt));
+			inode_lock(toputinode[cnt]);
+			toputinode[cnt]->i_flags &= ~(S_IMMUTABLE |
 				  S_NOATIME | S_NOQUOTA);
-				truncate_inode_pages(&toputinode[cnt]->i_data,
-						     0);
-				inode_unlock(toputinode[cnt]);
-				mark_inode_dirty_sync(toputinode[cnt]);
-			}
-			mutex_unlock(&dqopt->dqonoff_mutex);
+			truncate_inode_pages(&toputinode[cnt]->i_data, 0);
+			inode_unlock(toputinode[cnt]);
+			mark_inode_dirty_sync(toputinode[cnt]);
 		}
 	if (sb->s_bdev)
 		invalidate_bdev(sb->s_bdev);
@@ -2275,6 +2263,10 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		error = -EINVAL;
 		goto out_fmt;
 	}
+	if (sb_has_quota_loaded(sb, type)) {
+		error = -EBUSY;
+		goto out_fmt;
+	}
 
 	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE)) {
 		/* As we bypass the pagecache we must now flush all the
@@ -2286,11 +2278,6 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		sync_filesystem(sb);
 		invalidate_bdev(sb->s_bdev);
 	}
-	mutex_lock(&dqopt->dqonoff_mutex);
-	if (sb_has_quota_loaded(sb, type)) {
-		error = -EBUSY;
-		goto out_lock;
-	}
 
 	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE)) {
 		/* We don't want quota and atime on quota files (deadlocks
@@ -2311,7 +2298,7 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 	error = -EIO;
 	dqopt->files[type] = igrab(inode);
 	if (!dqopt->files[type])
-		goto out_lock;
+		goto out_file_flags;
 	error = -EINVAL;
 	if (!fmt->qf_ops->check_quota_file(sb, type))
 		goto out_file_init;
@@ -2334,14 +2321,13 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 	spin_unlock(&dq_state_lock);
 
 	add_dquot_ref(sb, type);
-	mutex_unlock(&dqopt->dqonoff_mutex);
 
 	return 0;
 
 out_file_init:
 	dqopt->files[type] = NULL;
 	iput(inode);
-out_lock:
+out_file_flags:
 	if (oldflags != -1) {
 		inode_lock(inode);
 		/* Set the flags back (in the case of accidental quotaon()
@@ -2350,7 +2336,6 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		inode->i_flags |= oldflags;
 		inode_unlock(inode);
 	}
-	mutex_unlock(&dqopt->dqonoff_mutex);
 out_fmt:
 	put_quota_format(fmt);
 
@@ -2372,12 +2357,9 @@ int dquot_resume(struct super_block *sb, int type)
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
-
-		mutex_lock(&dqopt->dqonoff_mutex);
-		if (!sb_has_quota_suspended(sb, cnt)) {
-			mutex_unlock(&dqopt->dqonoff_mutex);
+		if (!sb_has_quota_suspended(sb, cnt))
 			continue;
-		}
+
 		inode = dqopt->files[cnt];
 		dqopt->files[cnt] = NULL;
 		spin_lock(&dq_state_lock);
@@ -2386,7 +2368,6 @@ int dquot_resume(struct super_block *sb, int type)
 							cnt);
 		dqopt->flags &= ~dquot_state_flag(DQUOT_STATE_FLAGS, cnt);
 		spin_unlock(&dq_state_lock);
-		mutex_unlock(&dqopt->dqonoff_mutex);
 
 		flags = dquot_generic_flag(flags, cnt);
 		ret = vfs_load_quota_inode(inode, cnt,
@@ -2422,7 +2403,6 @@ EXPORT_SYMBOL(dquot_quota_on);
 int dquot_enable(struct inode *inode, int type, int format_id,
 		 unsigned int flags)
 {
-	int ret = 0;
 	struct super_block *sb = inode->i_sb;
 	struct quota_info *dqopt = sb_dqopt(sb);
 
@@ -2436,28 +2416,16 @@ int dquot_enable(struct inode *inode, int type, int format_id,
 		return 0;
 	/* Just updating flags needed? */
 	if (sb_has_quota_loaded(sb, type)) {
-		mutex_lock(&dqopt->dqonoff_mutex);
-		/* Now do a reliable test... */
-		if (!sb_has_quota_loaded(sb, type)) {
-			mutex_unlock(&dqopt->dqonoff_mutex);
-			goto load_quota;
-		}
 		if (flags & DQUOT_USAGE_ENABLED &&
-		    sb_has_quota_usage_enabled(sb, type)) {
-			ret = -EBUSY;
-			goto out_lock;
-		}
+		    sb_has_quota_usage_enabled(sb, type))
+			return -EBUSY;
 		if (flags & DQUOT_LIMITS_ENABLED &&
-		    sb_has_quota_limits_enabled(sb, type)) {
-			ret = -EBUSY;
-			goto out_lock;
-		}
+		    sb_has_quota_limits_enabled(sb, type))
+			return -EBUSY;
 		spin_lock(&dq_state_lock);
 		sb_dqopt(sb)->flags |= dquot_state_flag(flags, type);
 		spin_unlock(&dq_state_lock);
-out_lock:
-		mutex_unlock(&dqopt->dqonoff_mutex);
-		return ret;
+		return 0;
 	}
 
 load_quota:
diff --git a/fs/super.c b/fs/super.c
index f7f724230e2b..1709ed029a2c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -244,7 +244,6 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 	mutex_init(&s->s_vfs_rename_mutex);
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
 	mutex_init(&s->s_dquot.dqio_mutex);
-	mutex_init(&s->s_dquot.dqonoff_mutex);
 	s->s_maxbytes = MAX_NON_LFS;
 	s->s_op = &default_op;
 	s->s_time_gran = 1000000000;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 55107a8ff887..b281d198ee5b 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -520,7 +520,6 @@ static inline void quota_send_warning(struct kqid qid, dev_t dev,
 struct quota_info {
 	unsigned int flags;			/* Flags for diskquotas on this device */
 	struct mutex dqio_mutex;		/* lock device while I/O in progress */
-	struct mutex dqonoff_mutex;		/* Serialize quotaon & quotaoff */
 	struct inode *files[MAXQUOTAS];		/* inodes of quotafiles */
 	struct mem_dqinfo info[MAXQUOTAS];	/* Information for each quota type */
 	const struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
-- 
2.6.6
