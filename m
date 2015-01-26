From: Jan Kara <jack@suse.cz>
Date: Mon, 26 Jan 2015 15:34:21 +0100
Subject: [Ocfs2-devel] [PATCH 04/16] quota: Add ->quota_{enable,
	disable} callbacks for VFS quotas
In-Reply-To: <1422282873-3381-1-git-send-email-jack@suse.cz>
References: <1422282873-3381-1-git-send-email-jack@suse.cz>
Message-ID: <1422282873-3381-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Add functions which translate ->quota_enable / ->quota_disable calls
into appropriate changes in VFS quota. This will enable filesystems
supporting VFS quota files in system inodes to be controlled via
Q_XQUOTA[ON|OFF] quotactls for better userspace compatibility.

Also provide a vector for quotactl using these functions which can be
used by filesystems with quota files stored in hidden system files.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         | 91 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/quotaops.h |  1 +
 2 files changed, 92 insertions(+)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 29eb9dc5728a..b47d0c17ea6f 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2385,6 +2385,86 @@ out:
 }
 EXPORT_SYMBOL(dquot_quota_on_mount);
 
+static int dquot_quota_enable(struct super_block *sb, unsigned int flags)
+{
+	int ret;
+	int type;
+	struct quota_info *dqopt = sb_dqopt(sb);
+
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE))
+		return -ENOSYS;
+	/* Accounting cannot be turned on while fs is mounted */
+	flags &= ~(FS_QUOTA_UDQ_ACCT | FS_QUOTA_GDQ_ACCT | FS_QUOTA_PDQ_ACCT);
+	if (!flags)
+		return -EINVAL;
+	for (type = 0; type < MAXQUOTAS; type++) {
+		if (!(flags & qtype_enforce_flag(type)))
+			continue;
+		/* Can't enforce without accounting */
+		if (!sb_has_quota_usage_enabled(sb, type))
+			return -EINVAL;
+		ret = dquot_enable(dqopt->files[type], type,
+				   dqopt->info[type].dqi_fmt_id,
+				   DQUOT_LIMITS_ENABLED);
+		if (ret < 0)
+			goto out_err;
+	}
+	return 0;
+out_err:
+	/* Backout enforcement enablement we already did */
+	for (type--; type >= 0; type--)  {
+		if (flags & qtype_enforce_flag(type))
+			dquot_disable(sb, type, DQUOT_LIMITS_ENABLED);
+	}
+	/* Error code translation for better compatibility with XFS */
+	if (ret == -EBUSY)
+		ret = -EEXIST;
+	return ret;
+}
+
+static int dquot_quota_disable(struct super_block *sb, unsigned int flags)
+{
+	int ret;
+	int type;
+	struct quota_info *dqopt = sb_dqopt(sb);
+
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE))
+		return -ENOSYS;
+	/*
+	 * We don't support turning off accounting via quotactl. In principle
+	 * quota infrastructure can do this but filesystems don't expect
+	 * userspace to be able to do it.
+	 */
+	if (flags &
+		  (FS_QUOTA_UDQ_ACCT | FS_QUOTA_GDQ_ACCT | FS_QUOTA_PDQ_ACCT))
+		return -EOPNOTSUPP;
+
+	/* Filter out limits not enabled */
+	for (type = 0; type < MAXQUOTAS; type++)
+		if (!sb_has_quota_limits_enabled(sb, type))
+			flags &= ~qtype_enforce_flag(type);
+	/* Nothing left? */
+	if (!flags)
+		return -EEXIST;
+	for (type = 0; type < MAXQUOTAS; type++) {
+		if (flags & qtype_enforce_flag(type)) {
+			ret = dquot_disable(sb, type, DQUOT_LIMITS_ENABLED);
+			if (ret < 0)
+				goto out_err;
+		}
+	}
+	return 0;
+out_err:
+	/* Backout enforcement disabling we already did */
+	for (type--; type >= 0; type--)  {
+		if (flags & qtype_enforce_flag(type))
+			dquot_enable(dqopt->files[type], type,
+				     dqopt->info[type].dqi_fmt_id,
+				     DQUOT_LIMITS_ENABLED);
+	}
+	return ret;
+}
+
 static inline qsize_t qbtos(qsize_t blocks)
 {
 	return blocks << QIF_DQBLKSIZE_BITS;
@@ -2614,6 +2694,17 @@ const struct quotactl_ops dquot_quotactl_ops = {
 };
 EXPORT_SYMBOL(dquot_quotactl_ops);
 
+const struct quotactl_ops dquot_quotactl_sysfile_ops = {
+	.quota_enable	= dquot_quota_enable,
+	.quota_disable	= dquot_quota_disable,
+	.quota_sync	= dquot_quota_sync,
+	.get_info	= dquot_get_dqinfo,
+	.set_info	= dquot_set_dqinfo,
+	.get_dqblk	= dquot_get_dqblk,
+	.set_dqblk	= dquot_set_dqblk
+};
+EXPORT_SYMBOL(dquot_quotactl_sysfile_ops);
+
 static int do_proc_dqstats(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index ff0b665591d0..df73258cca47 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -166,6 +166,7 @@ static inline bool sb_has_quota_active(struct super_block *sb, int type)
  */
 extern const struct dquot_operations dquot_operations;
 extern const struct quotactl_ops dquot_quotactl_ops;
+extern const struct quotactl_ops dquot_quotactl_sysfile_ops;
 
 #else
 
-- 
2.1.2
