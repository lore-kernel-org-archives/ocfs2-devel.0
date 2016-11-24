From: Jan Kara <jack@suse.cz>
Date: Thu, 24 Nov 2016 09:12:37 +0100
Subject: [Ocfs2-devel] [PATCH 2/7] quota: Hold s_umount in exclusive mode
	when enabling / disabling quotas
In-Reply-To: <1479975162-24060-1-git-send-email-jack@suse.cz>
References: <1479975162-24060-1-git-send-email-jack@suse.cz>
Message-ID: <1479975162-24060-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, mfasheh@versity.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Currently we hold s_umount semaphore only in shared mode when enabling
or disabling quotas and use dqonoff_mutex for serializing quota state
changes on a filesystem and also quota state changes with other places
depending on current quota state. Using dedicated mutex for this causes
possible deadlocks during filesystem freezing (see following commit for
details) so we transition to using s_umount semaphore for the necessary
synchronization whose lock ordering is properly handled by the
filesystem freezing code. As a start grab s_umount in exclusive mode
when enabling / disabling quotas.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 11 +++++++++++
 fs/quota/quota.c | 15 +++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 1bfac28b7e7d..047afb966420 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2107,6 +2107,10 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 	struct quota_info *dqopt = sb_dqopt(sb);
 	struct inode *toputinode[MAXQUOTAS];
 
+	/* s_umount should be held in exclusive mode */
+	if (WARN_ON_ONCE(down_read_trylock(&sb->s_umount)))
+		up_read(&sb->s_umount);
+
 	/* Cannot turn off usage accounting without turning off limits, or
 	 * suspend quotas and simultaneously turn quotas off. */
 	if ((flags & DQUOT_USAGE_ENABLED && !(flags & DQUOT_LIMITS_ENABLED))
@@ -2371,6 +2375,10 @@ int dquot_resume(struct super_block *sb, int type)
 	int ret = 0, cnt;
 	unsigned int flags;
 
+	/* s_umount should be held in exclusive mode */
+	if (WARN_ON_ONCE(down_read_trylock(&sb->s_umount)))
+		up_read(&sb->s_umount);
+
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
@@ -2430,6 +2438,9 @@ int dquot_enable(struct inode *inode, int type, int format_id,
 
 	/* Just unsuspend quotas? */
 	BUG_ON(flags & DQUOT_SUSPENDED);
+	/* s_umount should be held in exclusive mode */
+	if (WARN_ON_ONCE(down_read_trylock(&sb->s_umount)))
+		up_read(&sb->s_umount);
 
 	if (!flags)
 		return 0;
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 2d445425aad7..790c61abc663 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -790,6 +790,12 @@ static int quotactl_cmd_write(int cmd)
 	return 1;
 }
 
+/* Return true if quotactl command is manipulating quota on/off state */
+static bool quotactl_cmd_onoff(int cmd)
+{
+	return (cmd == Q_QUOTAON) || (cmd == Q_QUOTAOFF);
+}
+
 #endif /* CONFIG_BLOCK */
 
 /*
@@ -809,7 +815,9 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 	putname(tmp);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
-	if (quotactl_cmd_write(cmd))
+	if (quotactl_cmd_onoff(cmd))
+		sb = get_super_exclusive_thawed(bdev);
+	else if (quotactl_cmd_write(cmd))
 		sb = get_super_thawed(bdev);
 	else
 		sb = get_super(bdev);
@@ -872,7 +880,10 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
 
 	ret = do_quotactl(sb, type, cmds, id, addr, pathp);
 
-	drop_super(sb);
+	if (!quotactl_cmd_onoff(cmds))
+		drop_super(sb);
+	else
+		drop_super_exclusive(sb);
 out:
 	if (pathp && !IS_ERR(pathp))
 		path_put(pathp);
-- 
2.6.6
