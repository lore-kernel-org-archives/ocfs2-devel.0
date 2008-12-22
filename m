From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:47:46 -0800
Subject: [Ocfs2-devel] [PATCH 05/56] quota: Allow to separately enable quota
	accounting and enforcing limits
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-6-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

Split DQUOT_USR_ENABLED (and DQUOT_GRP_ENABLED) into DQUOT_USR_USAGE_ENABLED
and DQUOT_USR_LIMITS_ENABLED. This way we are able to separately enable /
disable whether we should:
1) ignore quotas completely
2) just keep uptodate information about usage
3) actually enforce quota limits

This is going to be useful when quota is treated as filesystem metadata - we
then want to keep quota information uptodate all the time and just enable /
disable limits enforcement.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/dquot.c               |  222 ++++++++++++++++++++++++++++-----------------
 fs/quota.c               |    8 +-
 include/linux/quota.h    |   30 ++++++-
 include/linux/quotaops.h |   91 +++++++++++++++----
 4 files changed, 239 insertions(+), 112 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 1f9f1f1..adf59ce 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -489,7 +489,7 @@ int vfs_quota_sync(struct super_block *sb, int type)
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
-		if (!sb_has_quota_enabled(sb, cnt))
+		if (!sb_has_quota_active(sb, cnt))
 			continue;
 		spin_lock(&dq_list_lock);
 		dirty = &dqopt->info[cnt].dqi_dirty_list;
@@ -514,8 +514,8 @@ int vfs_quota_sync(struct super_block *sb, int type)
 	}
 
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		if ((cnt == type || type == -1) && sb_has_quota_enabled(sb, cnt)
-			&& info_dirty(&dqopt->info[cnt]))
+		if ((cnt == type || type == -1) && sb_has_quota_active(sb, cnt)
+		    && info_dirty(&dqopt->info[cnt]))
 			sb->dq_op->write_info(sb, cnt);
 	spin_lock(&dq_list_lock);
 	dqstats.syncs++;
@@ -594,7 +594,7 @@ we_slept:
 		/* We have more than one user... nothing to do */
 		atomic_dec(&dquot->dq_count);
 		/* Releasing dquot during quotaoff phase? */
-		if (!sb_has_quota_enabled(dquot->dq_sb, dquot->dq_type) &&
+		if (!sb_has_quota_active(dquot->dq_sb, dquot->dq_type) &&
 		    atomic_read(&dquot->dq_count) == 1)
 			wake_up(&dquot->dq_wait_unused);
 		spin_unlock(&dq_list_lock);
@@ -670,7 +670,7 @@ static struct dquot *dqget(struct super_block *sb, unsigned int id, int type)
 	unsigned int hashent = hashfn(sb, id, type);
 	struct dquot *dquot, *empty = NODQUOT;
 
-        if (!sb_has_quota_enabled(sb, type))
+        if (!sb_has_quota_active(sb, type))
 		return NODQUOT;
 we_slept:
 	spin_lock(&dq_list_lock);
@@ -1041,7 +1041,8 @@ static inline char ignore_hardlimit(struct dquot *dquot)
 static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (!sb_has_quota_limits_enabled(dquot->dq_sb, dquot->dq_type) ||
+	    test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_ihardlimit &&
@@ -1073,7 +1074,8 @@ static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (!sb_has_quota_limits_enabled(dquot->dq_sb, dquot->dq_type) ||
+	    test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_bhardlimit &&
@@ -1114,7 +1116,8 @@ static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *war
 static int info_idq_free(struct dquot *dquot, qsize_t inodes)
 {
 	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
-	    dquot->dq_dqb.dqb_curinodes <= dquot->dq_dqb.dqb_isoftlimit)
+	    dquot->dq_dqb.dqb_curinodes <= dquot->dq_dqb.dqb_isoftlimit ||
+	    !sb_has_quota_limits_enabled(dquot->dq_sb, dquot->dq_type))
 		return QUOTA_NL_NOWARN;
 
 	if (dquot->dq_dqb.dqb_curinodes - inodes <= dquot->dq_dqb.dqb_isoftlimit)
@@ -1508,7 +1511,7 @@ warn_put_all:
 /* Wrapper for transferring ownership of an inode */
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
 {
-	if (sb_any_quota_enabled(inode->i_sb) && !IS_NOQUOTA(inode)) {
+	if (sb_any_quota_active(inode->i_sb) && !IS_NOQUOTA(inode)) {
 		vfs_dq_init(inode);
 		if (inode->i_sb->dq_op->transfer(inode, iattr) == NO_QUOTA)
 			return 1;
@@ -1551,53 +1554,22 @@ struct dquot_operations dquot_operations = {
 	.destroy_dquot	= dquot_destroy,
 };
 
-static inline void set_enable_flags(struct quota_info *dqopt, int type)
-{
-	switch (type) {
-		case USRQUOTA:
-			dqopt->flags |= DQUOT_USR_ENABLED;
-			dqopt->flags &= ~DQUOT_USR_SUSPENDED;
-			break;
-		case GRPQUOTA:
-			dqopt->flags |= DQUOT_GRP_ENABLED;
-			dqopt->flags &= ~DQUOT_GRP_SUSPENDED;
-			break;
-	}
-}
-
-static inline void reset_enable_flags(struct quota_info *dqopt, int type,
-				      int remount)
-{
-	switch (type) {
-		case USRQUOTA:
-			if (remount)
-				dqopt->flags |= DQUOT_USR_SUSPENDED;
-			else {
-				dqopt->flags &= ~DQUOT_USR_ENABLED;
-				dqopt->flags &= ~DQUOT_USR_SUSPENDED;
-			}
-			break;
-		case GRPQUOTA:
-			if (remount)
-				dqopt->flags |= DQUOT_GRP_SUSPENDED;
-			else {
-				dqopt->flags &= ~DQUOT_GRP_ENABLED;
-				dqopt->flags &= ~DQUOT_GRP_SUSPENDED;
-			}
-			break;
-	}
-}
-
-
 /*
  * Turn quota off on a device. type == -1 ==> quotaoff for all types (umount)
  */
-int vfs_quota_off(struct super_block *sb, int type, int remount)
+int vfs_quota_disable(struct super_block *sb, int type, unsigned int flags)
 {
 	int cnt, ret = 0;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	struct inode *toputinode[MAXQUOTAS];
 
+	/* Cannot turn off usage accounting without turning off limits, or
+	 * suspend quotas and simultaneously turn quotas off. */
+	if ((flags & DQUOT_USAGE_ENABLED && !(flags & DQUOT_LIMITS_ENABLED))
+	    || (flags & DQUOT_SUSPENDED && flags & (DQUOT_LIMITS_ENABLED |
+	    DQUOT_USAGE_ENABLED)))
+		return -EINVAL;
+
 	/* We need to serialize quota_off() for device */
 	mutex_lock(&dqopt->dqonoff_mutex);
 
@@ -1606,7 +1578,7 @@ int vfs_quota_off(struct super_block *sb, int type, int remount)
 	 * sometimes we are called when fill_super() failed and calling
 	 * sync_fs() in such cases does no good.
 	 */
-	if (!sb_any_quota_enabled(sb) && !sb_any_quota_suspended(sb)) {
+	if (!sb_any_quota_loaded(sb)) {
 		mutex_unlock(&dqopt->dqonoff_mutex);
 		return 0;
 	}
@@ -1614,17 +1586,28 @@ int vfs_quota_off(struct super_block *sb, int type, int remount)
 		toputinode[cnt] = NULL;
 		if (type != -1 && cnt != type)
 			continue;
-		/* If we keep inodes of quota files after remount and quotaoff
-		 * is called, drop kept inodes. */
-		if (!remount && sb_has_quota_suspended(sb, cnt)) {
-			iput(dqopt->files[cnt]);
-			dqopt->files[cnt] = NULL;
-			reset_enable_flags(dqopt, cnt, 0);
+		if (!sb_has_quota_loaded(sb, cnt))
 			continue;
+
+		if (flags & DQUOT_SUSPENDED) {
+			dqopt->flags |=
+				dquot_state_flag(DQUOT_SUSPENDED, cnt);
+		} else {
+			dqopt->flags &= ~dquot_state_flag(flags, cnt);
+			/* Turning off suspended quotas? */
+			if (!sb_has_quota_loaded(sb, cnt) &&
+			    sb_has_quota_suspended(sb, cnt)) {
+				dqopt->flags &=	~dquot_state_flag(
+							DQUOT_SUSPENDED, cnt);
+				iput(dqopt->files[cnt]);
+				dqopt->files[cnt] = NULL;
+				continue;
+			}
 		}
-		if (!sb_has_quota_enabled(sb, cnt))
+
+		/* We still have to keep quota loaded? */
+		if (sb_has_quota_loaded(sb, cnt) && !(flags & DQUOT_SUSPENDED))
 			continue;
-		reset_enable_flags(dqopt, cnt, remount);
 
 		/* Note: these are blocking operations */
 		drop_dquot_ref(sb, cnt);
@@ -1640,7 +1623,7 @@ int vfs_quota_off(struct super_block *sb, int type, int remount)
 		put_quota_format(dqopt->info[cnt].dqi_format);
 
 		toputinode[cnt] = dqopt->files[cnt];
-		if (!remount)
+		if (!sb_has_quota_loaded(sb, cnt))
 			dqopt->files[cnt] = NULL;
 		dqopt->info[cnt].dqi_flags = 0;
 		dqopt->info[cnt].dqi_igrace = 0;
@@ -1663,7 +1646,7 @@ int vfs_quota_off(struct super_block *sb, int type, int remount)
 			mutex_lock(&dqopt->dqonoff_mutex);
 			/* If quota was reenabled in the meantime, we have
 			 * nothing to do */
-			if (!sb_has_quota_enabled(sb, cnt)) {
+			if (!sb_has_quota_loaded(sb, cnt)) {
 				mutex_lock_nested(&toputinode[cnt]->i_mutex, I_MUTEX_QUOTA);
 				toputinode[cnt]->i_flags &= ~(S_IMMUTABLE |
 				  S_NOATIME | S_NOQUOTA);
@@ -1673,10 +1656,13 @@ int vfs_quota_off(struct super_block *sb, int type, int remount)
 			}
 			mutex_unlock(&dqopt->dqonoff_mutex);
 			/* On remount RO, we keep the inode pointer so that we
-			 * can reenable quota on the subsequent remount RW.
-			 * But we have better not keep inode pointer when there
-			 * is pending delete on the quota file... */
-			if (!remount)
+			 * can reenable quota on the subsequent remount RW. We
+			 * have to check 'flags' variable and not use sb_has_
+			 * function because another quotaon / quotaoff could
+			 * change global state before we got here. We refuse
+			 * to suspend quotas when there is pending delete on
+			 * the quota file... */
+			if (!(flags & DQUOT_SUSPENDED))
 				iput(toputinode[cnt]);
 			else if (!toputinode[cnt]->i_nlink)
 				ret = -EBUSY;
@@ -1686,12 +1672,22 @@ int vfs_quota_off(struct super_block *sb, int type, int remount)
 	return ret;
 }
 
+int vfs_quota_off(struct super_block *sb, int type, int remount)
+{
+	return vfs_quota_disable(sb, type, remount ? DQUOT_SUSPENDED :
+				 (DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED));
+}
+
 /*
  *	Turn quotas on on a device
  */
 
-/* Helper function when we already have the inode */
-static int vfs_quota_on_inode(struct inode *inode, int type, int format_id)
+/*
+ * Helper function to turn quotas on when we already have the inode of
+ * quota file and no quota information is loaded.
+ */
+static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
+	unsigned int flags)
 {
 	struct quota_format_type *fmt = find_quota_format(format_id);
 	struct super_block *sb = inode->i_sb;
@@ -1713,6 +1709,11 @@ static int vfs_quota_on_inode(struct inode *inode, int type, int format_id)
 		error = -EINVAL;
 		goto out_fmt;
 	}
+	/* Usage always has to be set... */
+	if (!(flags & DQUOT_USAGE_ENABLED)) {
+		error = -EINVAL;
+		goto out_fmt;
+	}
 
 	/* As we bypass the pagecache we must now flush the inode so that
 	 * we see all the changes from userspace... */
@@ -1721,8 +1722,7 @@ static int vfs_quota_on_inode(struct inode *inode, int type, int format_id)
 	invalidate_bdev(sb->s_bdev);
 	mutex_lock(&inode->i_mutex);
 	mutex_lock(&dqopt->dqonoff_mutex);
-	if (sb_has_quota_enabled(sb, type) ||
-			sb_has_quota_suspended(sb, type)) {
+	if (sb_has_quota_loaded(sb, type)) {
 		error = -EBUSY;
 		goto out_lock;
 	}
@@ -1754,7 +1754,7 @@ static int vfs_quota_on_inode(struct inode *inode, int type, int format_id)
 	}
 	mutex_unlock(&dqopt->dqio_mutex);
 	mutex_unlock(&inode->i_mutex);
-	set_enable_flags(dqopt, type);
+	dqopt->flags |= dquot_state_flag(flags, type);
 
 	add_dquot_ref(sb, type);
 	mutex_unlock(&dqopt->dqonoff_mutex);
@@ -1787,20 +1787,23 @@ static int vfs_quota_on_remount(struct super_block *sb, int type)
 	struct quota_info *dqopt = sb_dqopt(sb);
 	struct inode *inode;
 	int ret;
+	unsigned int flags;
 
 	mutex_lock(&dqopt->dqonoff_mutex);
 	if (!sb_has_quota_suspended(sb, type)) {
 		mutex_unlock(&dqopt->dqonoff_mutex);
 		return 0;
 	}
-	BUG_ON(sb_has_quota_enabled(sb, type));
-
 	inode = dqopt->files[type];
 	dqopt->files[type] = NULL;
-	reset_enable_flags(dqopt, type, 0);
+	flags = dqopt->flags & dquot_state_flag(DQUOT_USAGE_ENABLED |
+						DQUOT_LIMITS_ENABLED, type);
+	dqopt->flags &= ~dquot_state_flag(DQUOT_STATE_FLAGS, type);
 	mutex_unlock(&dqopt->dqonoff_mutex);
 
-	ret = vfs_quota_on_inode(inode, type, dqopt->info[type].dqi_fmt_id);
+	flags = dquot_generic_flag(flags, type);
+	ret = vfs_load_quota_inode(inode, type, dqopt->info[type].dqi_fmt_id,
+				   flags);
 	iput(inode);
 
 	return ret;
@@ -1816,12 +1819,12 @@ int vfs_quota_on_path(struct super_block *sb, int type, int format_id,
 	if (path->mnt->mnt_sb != sb)
 		error = -EXDEV;
 	else
-		error = vfs_quota_on_inode(path->dentry->d_inode, type,
-					   format_id);
+		error = vfs_load_quota_inode(path->dentry->d_inode, type,
+					     format_id, DQUOT_USAGE_ENABLED |
+					     DQUOT_LIMITS_ENABLED);
 	return error;
 }
 
-/* Actual function called from quotactl() */
 int vfs_quota_on(struct super_block *sb, int type, int format_id, char *name,
 		 int remount)
 {
@@ -1840,6 +1843,50 @@ int vfs_quota_on(struct super_block *sb, int type, int format_id, char *name,
 }
 
 /*
+ * More powerful function for turning on quotas allowing setting
+ * of individual quota flags
+ */
+int vfs_quota_enable(struct inode *inode, int type, int format_id,
+		unsigned int flags)
+{
+	int ret = 0;
+	struct super_block *sb = inode->i_sb;
+	struct quota_info *dqopt = sb_dqopt(sb);
+
+	/* Just unsuspend quotas? */
+	if (flags & DQUOT_SUSPENDED)
+		return vfs_quota_on_remount(sb, type);
+	if (!flags)
+		return 0;
+	/* Just updating flags needed? */
+	if (sb_has_quota_loaded(sb, type)) {
+		mutex_lock(&dqopt->dqonoff_mutex);
+		/* Now do a reliable test... */
+		if (!sb_has_quota_loaded(sb, type)) {
+			mutex_unlock(&dqopt->dqonoff_mutex);
+			goto load_quota;
+		}
+		if (flags & DQUOT_USAGE_ENABLED &&
+		    sb_has_quota_usage_enabled(sb, type)) {
+			ret = -EBUSY;
+			goto out_lock;
+		}
+		if (flags & DQUOT_LIMITS_ENABLED &&
+		    sb_has_quota_limits_enabled(sb, type)) {
+			ret = -EBUSY;
+			goto out_lock;
+		}
+		sb_dqopt(sb)->flags |= dquot_state_flag(flags, type);
+out_lock:
+		mutex_unlock(&dqopt->dqonoff_mutex);
+		return ret;
+	}
+
+load_quota:
+	return vfs_load_quota_inode(inode, type, format_id, flags);
+}
+
+/*
  * This function is used when filesystem needs to initialize quotas
  * during mount time.
  */
@@ -1860,7 +1907,8 @@ int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
 
 	error = security_quota_on(dentry);
 	if (!error)
-		error = vfs_quota_on_inode(dentry->d_inode, type, format_id);
+		error = vfs_load_quota_inode(dentry->d_inode, type, format_id,
+				DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
 out:
 	dput(dentry);
@@ -1997,12 +2045,14 @@ int vfs_set_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *d
 	int rc;
 
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
-	if (!(dquot = dqget(sb, id, type))) {
-		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
-		return -ESRCH;
+	dquot = dqget(sb, id, type);
+	if (!dquot) {
+		rc = -ESRCH;
+		goto out;
 	}
 	rc = do_set_dqblk(dquot, di);
 	dqput(dquot);
+out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return rc;
 }
@@ -2013,7 +2063,7 @@ int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
 	struct mem_dqinfo *mi;
   
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
-	if (!sb_has_quota_enabled(sb, type)) {
+	if (!sb_has_quota_active(sb, type)) {
 		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 		return -ESRCH;
 	}
@@ -2032,11 +2082,12 @@ int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
 int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
 {
 	struct mem_dqinfo *mi;
+	int err = 0;
 
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
-	if (!sb_has_quota_enabled(sb, type)) {
-		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
-		return -ESRCH;
+	if (!sb_has_quota_active(sb, type)) {
+		err = -ESRCH;
+		goto out;
 	}
 	mi = sb_dqopt(sb)->info + type;
 	spin_lock(&dq_data_lock);
@@ -2050,8 +2101,9 @@ int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
 	mark_info_dirty(sb, type);
 	/* Force write to disk */
 	sb->dq_op->write_info(sb, type);
+out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
-	return 0;
+	return err;
 }
 
 struct quotactl_ops vfs_quotactl_ops = {
@@ -2213,9 +2265,11 @@ EXPORT_SYMBOL(register_quota_format);
 EXPORT_SYMBOL(unregister_quota_format);
 EXPORT_SYMBOL(dqstats);
 EXPORT_SYMBOL(dq_data_lock);
+EXPORT_SYMBOL(vfs_quota_enable);
 EXPORT_SYMBOL(vfs_quota_on);
 EXPORT_SYMBOL(vfs_quota_on_path);
 EXPORT_SYMBOL(vfs_quota_on_mount);
+EXPORT_SYMBOL(vfs_quota_disable);
 EXPORT_SYMBOL(vfs_quota_off);
 EXPORT_SYMBOL(vfs_quota_sync);
 EXPORT_SYMBOL(vfs_get_dqinfo);
diff --git a/fs/quota.c b/fs/quota.c
index 7f4386e..a8026f1 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -73,7 +73,7 @@ static int generic_quotactl_valid(struct super_block *sb, int type, int cmd, qid
 		case Q_SETQUOTA:
 		case Q_GETQUOTA:
 			/* This is just informative test so we are satisfied without a lock */
-			if (!sb_has_quota_enabled(sb, type))
+			if (!sb_has_quota_active(sb, type))
 				return -ESRCH;
 	}
 
@@ -175,7 +175,7 @@ static void quota_sync_sb(struct super_block *sb, int type)
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
-		if (!sb_has_quota_enabled(sb, cnt))
+		if (!sb_has_quota_active(sb, cnt))
 			continue;
 		mutex_lock_nested(&sb_dqopt(sb)->files[cnt]->i_mutex, I_MUTEX_QUOTA);
 		truncate_inode_pages(&sb_dqopt(sb)->files[cnt]->i_data, 0);
@@ -201,7 +201,7 @@ restart:
 		for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 			if (type != -1 && type != cnt)
 				continue;
-			if (!sb_has_quota_enabled(sb, cnt))
+			if (!sb_has_quota_active(sb, cnt))
 				continue;
 			if (!info_dirty(&sb_dqopt(sb)->info[cnt]) &&
 			    list_empty(&sb_dqopt(sb)->info[cnt].dqi_dirty_list))
@@ -245,7 +245,7 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id, void
 			__u32 fmt;
 
 			down_read(&sb_dqopt(sb)->dqptr_sem);
-			if (!sb_has_quota_enabled(sb, type)) {
+			if (!sb_has_quota_active(sb, type)) {
 				up_read(&sb_dqopt(sb)->dqptr_sem);
 				return -ESRCH;
 			}
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 9ea4683..93717ab 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -318,12 +318,34 @@ struct quota_format_type {
 	struct quota_format_type *qf_next;
 };
 
-#define DQUOT_USR_ENABLED	0x01		/* User diskquotas enabled */
-#define DQUOT_GRP_ENABLED	0x02		/* Group diskquotas enabled */
-#define DQUOT_USR_SUSPENDED	0x04		/* User diskquotas are off, but
+/* Quota state flags - they actually come in two flavors - for users and groups */
+enum {
+	_DQUOT_USAGE_ENABLED = 0,		/* Track disk usage for users */
+	_DQUOT_LIMITS_ENABLED,			/* Enforce quota limits for users */
+	_DQUOT_SUSPENDED,			/* User diskquotas are off, but
 						 * we have necessary info in
 						 * memory to turn them on */
-#define DQUOT_GRP_SUSPENDED	0x08		/* The same for group quotas */
+	_DQUOT_STATE_FLAGS
+};
+#define DQUOT_USAGE_ENABLED	(1 << _DQUOT_USAGE_ENABLED)
+#define DQUOT_LIMITS_ENABLED	(1 << _DQUOT_LIMITS_ENABLED)
+#define DQUOT_SUSPENDED		(1 << _DQUOT_SUSPENDED)
+#define DQUOT_STATE_FLAGS	(DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED | \
+				 DQUOT_SUSPENDED)
+
+static inline unsigned int dquot_state_flag(unsigned int flags, int type)
+{
+	if (type == USRQUOTA)
+		return flags;
+	return flags << _DQUOT_STATE_FLAGS;
+}
+
+static inline unsigned int dquot_generic_flag(unsigned int flags, int type)
+{
+	if (type == USRQUOTA)
+		return flags;
+	return flags >> _DQUOT_STATE_FLAGS;
+}
 
 struct quota_info {
 	unsigned int flags;			/* Flags for diskquotas on this device */
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index ffd9707..3b3346f 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -40,11 +40,14 @@ int dquot_mark_dquot_dirty(struct dquot *dquot);
 
 int vfs_quota_on(struct super_block *sb, int type, int format_id,
  	char *path, int remount);
+int vfs_quota_enable(struct inode *inode, int type, int format_id,
+	unsigned int flags);
 int vfs_quota_on_path(struct super_block *sb, int type, int format_id,
  	struct path *path);
 int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
  	int format_id, int type);
 int vfs_quota_off(struct super_block *sb, int type, int remount);
+int vfs_quota_disable(struct super_block *sb, int type, unsigned int flags);
 int vfs_quota_sync(struct super_block *sb, int type);
 int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
 int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
@@ -64,26 +67,22 @@ static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
  * Functions for checking status of quota
  */
 
-static inline int sb_has_quota_enabled(struct super_block *sb, int type)
+static inline int sb_has_quota_usage_enabled(struct super_block *sb, int type)
 {
-	if (type == USRQUOTA)
-		return (sb_dqopt(sb)->flags & DQUOT_USR_ENABLED)
-			&& !(sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED);
-	return (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED)
-		&& !(sb_dqopt(sb)->flags & DQUOT_GROUP_SUSPENDED);
+	return sb_dqopt(sb)->flags &
+				dquot_state_flag(DQUOT_USAGE_ENABLED, type);
 }
 
-static inline int sb_any_quota_enabled(struct super_block *sb)
+static inline int sb_has_quota_limits_enabled(struct super_block *sb, int type)
 {
-	return sb_has_quota_enabled(sb, USRQUOTA) ||
-		sb_has_quota_enabled(sb, GRPQUOTA);
+	return sb_dqopt(sb)->flags &
+				dquot_state_flag(DQUOT_LIMITS_ENABLED, type);
 }
 
 static inline int sb_has_quota_suspended(struct super_block *sb, int type)
 {
-	if (type == USRQUOTA)
-		return sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED;
-	return sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED;
+	return sb_dqopt(sb)->flags &
+				dquot_state_flag(DQUOT_SUSPENDED, type);
 }
 
 static inline int sb_any_quota_suspended(struct super_block *sb)
@@ -92,6 +91,34 @@ static inline int sb_any_quota_suspended(struct super_block *sb)
 		sb_has_quota_suspended(sb, GRPQUOTA);
 }
 
+/* Does kernel know about any quota information for given sb + type? */
+static inline int sb_has_quota_loaded(struct super_block *sb, int type)
+{
+	/* Currently if anything is on, then quota usage is on as well */
+	return sb_has_quota_usage_enabled(sb, type);
+}
+
+static inline int sb_any_quota_loaded(struct super_block *sb)
+{
+	return sb_has_quota_loaded(sb, USRQUOTA) ||
+		sb_has_quota_loaded(sb, GRPQUOTA);
+}
+
+static inline int sb_has_quota_active(struct super_block *sb, int type)
+{
+	return sb_has_quota_loaded(sb, type) &&
+	       !sb_has_quota_suspended(sb, type);
+}
+
+static inline int sb_any_quota_active(struct super_block *sb)
+{
+	return sb_has_quota_active(sb, USRQUOTA) ||
+	       sb_has_quota_active(sb, GRPQUOTA);
+}
+
+/* For backward compatibility until we remove all users */
+#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
+
 /*
  * Operations supported for diskquotas.
  */
@@ -106,7 +133,7 @@ extern struct quotactl_ops vfs_quotactl_ops;
 static inline void vfs_dq_init(struct inode *inode)
 {
 	BUG_ON(!inode->i_sb);
-	if (sb_any_quota_enabled(inode->i_sb) && !IS_NOQUOTA(inode))
+	if (sb_any_quota_active(inode->i_sb) && !IS_NOQUOTA(inode))
 		inode->i_sb->dq_op->initialize(inode, -1);
 }
 
@@ -114,7 +141,7 @@ static inline void vfs_dq_init(struct inode *inode)
  * a transaction (deadlocks possible otherwise) */
 static inline int vfs_dq_prealloc_space_nodirty(struct inode *inode, qsize_t nr)
 {
-	if (sb_any_quota_enabled(inode->i_sb)) {
+	if (sb_any_quota_active(inode->i_sb)) {
 		/* Used space is updated in alloc_space() */
 		if (inode->i_sb->dq_op->alloc_space(inode, nr, 1) == NO_QUOTA)
 			return 1;
@@ -134,7 +161,7 @@ static inline int vfs_dq_prealloc_space(struct inode *inode, qsize_t nr)
 
 static inline int vfs_dq_alloc_space_nodirty(struct inode *inode, qsize_t nr)
 {
-	if (sb_any_quota_enabled(inode->i_sb)) {
+	if (sb_any_quota_active(inode->i_sb)) {
 		/* Used space is updated in alloc_space() */
 		if (inode->i_sb->dq_op->alloc_space(inode, nr, 0) == NO_QUOTA)
 			return 1;
@@ -154,7 +181,7 @@ static inline int vfs_dq_alloc_space(struct inode *inode, qsize_t nr)
 
 static inline int vfs_dq_alloc_inode(struct inode *inode)
 {
-	if (sb_any_quota_enabled(inode->i_sb)) {
+	if (sb_any_quota_active(inode->i_sb)) {
 		vfs_dq_init(inode);
 		if (inode->i_sb->dq_op->alloc_inode(inode, 1) == NO_QUOTA)
 			return 1;
@@ -164,7 +191,7 @@ static inline int vfs_dq_alloc_inode(struct inode *inode)
 
 static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
 {
-	if (sb_any_quota_enabled(inode->i_sb))
+	if (sb_any_quota_active(inode->i_sb))
 		inode->i_sb->dq_op->free_space(inode, nr);
 	else
 		inode_sub_bytes(inode, nr);
@@ -178,7 +205,7 @@ static inline void vfs_dq_free_space(struct inode *inode, qsize_t nr)
 
 static inline void vfs_dq_free_inode(struct inode *inode)
 {
-	if (sb_any_quota_enabled(inode->i_sb))
+	if (sb_any_quota_active(inode->i_sb))
 		inode->i_sb->dq_op->free_inode(inode, 1);
 }
 
@@ -199,12 +226,12 @@ static inline int vfs_dq_off(struct super_block *sb, int remount)
 
 #else
 
-static inline int sb_has_quota_enabled(struct super_block *sb, int type)
+static inline int sb_has_quota_usage_enabled(struct super_block *sb, int type)
 {
 	return 0;
 }
 
-static inline int sb_any_quota_enabled(struct super_block *sb)
+static inline int sb_has_quota_limits_enabled(struct super_block *sb, int type)
 {
 	return 0;
 }
@@ -219,6 +246,30 @@ static inline int sb_any_quota_suspended(struct super_block *sb)
 	return 0;
 }
 
+/* Does kernel know about any quota information for given sb + type? */
+static inline int sb_has_quota_loaded(struct super_block *sb, int type)
+{
+	return 0;
+}
+
+static inline int sb_any_quota_loaded(struct super_block *sb)
+{
+	return 0;
+}
+
+static inline int sb_has_quota_active(struct super_block *sb, int type)
+{
+	return 0;
+}
+
+static inline int sb_any_quota_active(struct super_block *sb)
+{
+	return 0;
+}
+
+/* For backward compatibility until we remove all users */
+#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
+
 /*
  * NO-OP when quota not configured.
  */
-- 
1.5.6
