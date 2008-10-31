From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:39:00 +0100
Subject: [Ocfs2-devel] [PATCH 10/27] quota: Introduce DQUOT_QUOTA_SYS_FILE
	flag
In-Reply-To: <12254351582523-git-send-email-jack@suse.cz>
References: y <12254351572189-git-send-email-jack@suse.cz>
	<12254351571914-git-send-email-jack@suse.cz>
	<1225435157625-git-send-email-jack@suse.cz>
	<1225435157218-git-send-email-jack@suse.cz>
	<12254351571677-git-send-email-jack@suse.cz>
	<1225435157894-git-send-email-jack@suse.cz>
	<12254351582004-git-send-email-jack@suse.cz>
	<12254351581363-git-send-email-jack@suse.cz>
	<12254351582759-git-send-email-jack@suse.cz>
	<12254351582523-git-send-email-jack@suse.cz>
Message-ID: <12254351583984-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If filesystem can handle quota files as system files hidden from users, we can
skip a lot of cache invalidation, syncing, inode flags setting etc. when
turning quotas on, off and quota_sync. Allow filesystem to indicate that it is
hiding quota files from users by DQUOT_QUOTA_SYS_FILE flag.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c            |   45 ++++++++++++++++++++++++++++++---------------
 fs/quota.c            |    3 +++
 include/linux/quota.h |    7 +++++++
 3 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index adf59ce..f4d6f7e 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1631,6 +1631,11 @@ int vfs_quota_disable(struct super_block *sb, int type, unsigned int flags)
 		dqopt->ops[cnt] = NULL;
 	}
 	mutex_unlock(&dqopt->dqonoff_mutex);
+
+	/* Skip syncing and setting flags if quota files are hidden */
+	if (dqopt->flags & DQUOT_QUOTA_SYS_FILE)
+		goto put_inodes;
+
 	/* Sync the superblock so that buffers with quota data are written to
 	 * disk (and so userspace sees correct data afterwards). */
 	if (sb->s_op->sync_fs)
@@ -1655,6 +1660,12 @@ int vfs_quota_disable(struct super_block *sb, int type, unsigned int flags)
 				mark_inode_dirty(toputinode[cnt]);
 			}
 			mutex_unlock(&dqopt->dqonoff_mutex);
+		}
+	if (sb->s_bdev)
+		invalidate_bdev(sb->s_bdev);
+put_inodes:
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+		if (toputinode[cnt]) {
 			/* On remount RO, we keep the inode pointer so that we
 			 * can reenable quota on the subsequent remount RW. We
 			 * have to check 'flags' variable and not use sb_has_
@@ -1667,8 +1678,6 @@ int vfs_quota_disable(struct super_block *sb, int type, unsigned int flags)
 			else if (!toputinode[cnt]->i_nlink)
 				ret = -EBUSY;
 		}
-	if (sb->s_bdev)
-		invalidate_bdev(sb->s_bdev);
 	return ret;
 }
 
@@ -1715,25 +1724,31 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		goto out_fmt;
 	}
 
-	/* As we bypass the pagecache we must now flush the inode so that
-	 * we see all the changes from userspace... */
-	write_inode_now(inode, 1);
-	/* And now flush the block cache so that kernel sees the changes */
-	invalidate_bdev(sb->s_bdev);
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE)) {
+		/* As we bypass the pagecache we must now flush the inode so
+		 * that we see all the changes from userspace... */
+		write_inode_now(inode, 1);
+		/* And now flush the block cache so that kernel sees the
+		 * changes */
+		invalidate_bdev(sb->s_bdev);
+	}
 	mutex_lock(&inode->i_mutex);
 	mutex_lock(&dqopt->dqonoff_mutex);
 	if (sb_has_quota_loaded(sb, type)) {
 		error = -EBUSY;
 		goto out_lock;
 	}
-	/* We don't want quota and atime on quota files (deadlocks possible)
-	 * Also nobody should write to the file - we use special IO operations
-	 * which ignore the immutable bit. */
-	down_write(&dqopt->dqptr_sem);
-	oldflags = inode->i_flags & (S_NOATIME | S_IMMUTABLE | S_NOQUOTA);
-	inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
-	up_write(&dqopt->dqptr_sem);
-	sb->dq_op->drop(inode);
+
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE)) {
+		/* We don't want quota and atime on quota files (deadlocks
+		 * possible) Also nobody should write to the file - we use
+		 * special IO operations which ignore the immutable bit. */
+		down_write(&dqopt->dqptr_sem);
+		oldflags = inode->i_flags & (S_NOATIME | S_IMMUTABLE | S_NOQUOTA);
+		inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
+		up_write(&dqopt->dqptr_sem);
+		sb->dq_op->drop(inode);
+	}
 
 	error = -EIO;
 	dqopt->files[type] = igrab(inode);
diff --git a/fs/quota.c b/fs/quota.c
index a8026f1..2c6ea78 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -160,6 +160,9 @@ static void quota_sync_sb(struct super_block *sb, int type)
 	int cnt;
 
 	sb->s_qcop->quota_sync(sb, type);
+
+	if (sb_dqopt(sb)->flags & DQUOT_QUOTA_SYS_FILE)
+		return;
 	/* This is not very clever (and fast) but currently I don't know about
 	 * any other simple way of getting quota data to disk and we must get
 	 * them there for userspace to be visible... */
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 93717ab..80b8807 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -332,6 +332,13 @@ enum {
 #define DQUOT_SUSPENDED		(1 << _DQUOT_SUSPENDED)
 #define DQUOT_STATE_FLAGS	(DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED | \
 				 DQUOT_SUSPENDED)
+/* Other quota flags */
+#define DQUOT_QUOTA_SYS_FILE	(1 << 6)	/* Quota file is a special
+						 * system file and user cannot
+						 * touch it. Filesystem is
+						 * responsible for setting
+						 * S_NOQUOTA, S_NOATIME flags
+						 */
 
 static inline unsigned int dquot_state_flag(unsigned int flags, int type)
 {
-- 
1.5.2.4
