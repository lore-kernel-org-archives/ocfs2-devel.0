From: Jan Kara <jack@suse.cz>
Date: Mon, 26 Jan 2015 15:34:32 +0100
Subject: [Ocfs2-devel] [PATCH 15/16] xfs: Add support for Q_SETINFO
In-Reply-To: <1422282873-3381-1-git-send-email-jack@suse.cz>
References: <1422282873-3381-1-git-send-email-jack@suse.cz>
Message-ID: <1422282873-3381-16-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Add support to XFS so that time limits can be set through Q_SETINFO
quotactl.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_quotaops.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index df9835396c4f..bbe8ddf1f700 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -111,6 +111,42 @@ xfs_quota_type(int type)
 	}
 }
 
+#define XFS_QC_SETINFO_MASK (QC_TIMER_MASK | QC_WARNS_MASK)
+
+/*
+ * Adjust quota timers & warnings
+ */
+static int
+xfs_fs_set_info(
+	struct super_block *sb,
+	int type,
+	struct qc_info *info)
+{
+	struct xfs_mount *mp = XFS_M(sb);
+	struct qc_dqblk newlim;
+
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return -ESRCH;
+	if (info->i_fieldmask & ~XFS_QC_SETINFO_MASK)
+		return -EINVAL;
+	if ((info->i_fieldmask & XFS_QC_SETINFO_MASK) == 0)
+		return 0;
+
+	newlim.d_fieldmask = info->i_fieldmask;
+	newlim.d_spc_timer = info->i_spc_timelimit;
+	newlim.d_ino_timer = info->i_ino_timelimit;
+	newlim.d_rt_spc_timer = info->i_rt_spc_timelimit;
+	newlim.d_ino_warns = info->i_ino_warnlimit;
+	newlim.d_spc_warns = info->i_spc_warnlimit;
+	newlim.d_rt_spc_warns = info->i_rt_spc_warnlimit;
+
+	return xfs_qm_scall_setqlim(mp, 0, xfs_quota_type(type), &newlim);
+}
+
 static unsigned int
 xfs_quota_flags(unsigned int uflags)
 {
@@ -226,6 +262,7 @@ xfs_fs_set_dqblk(
 
 const struct quotactl_ops xfs_quotactl_operations = {
 	.get_state		= xfs_fs_get_quota_state,
+	.set_info		= xfs_fs_set_info,
 	.quota_enable		= xfs_quota_enable,
 	.quota_disable		= xfs_quota_disable,
 	.rm_xquota		= xfs_fs_rm_xquota,
-- 
2.1.2
