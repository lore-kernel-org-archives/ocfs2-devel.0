From: Jan Kara <jack@suse.cz>
Date: Fri, 16 Jan 2015 13:47:50 +0100
Subject: [Ocfs2-devel] [PATCH 16/17] xfs: Add support for Q_SETINFO
In-Reply-To: <1421412471-4747-1-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
Message-ID: <1421412471-4747-17-git-send-email-jack@suse.cz>
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
 fs/xfs/xfs_qm.h          |  2 ++
 fs/xfs/xfs_qm_syscalls.c | 25 +++++++++++++++++++++++++
 fs/xfs/xfs_quotaops.c    | 16 ++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index d308e9610548..c1a9761d37db 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -170,6 +170,8 @@ extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
 					struct qc_dqblk *);
 extern int		xfs_qm_scall_getstate(struct xfs_mount *,
 					struct qc_state *);
+extern int		xfs_qm_scall_setinfo(struct xfs_mount *, uint,
+					struct qc_info *);
 extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5ccafb4c7e79..9ede1ffec8d8 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -451,6 +451,31 @@ int xfs_qm_scall_getstate(struct xfs_mount *mp, struct qc_state *state)
 	return 0;
 }
 
+#define XFS_QC_SETINFO_MASK (QC_TIMER_MASK | QC_WARNS_MASK)
+
+/*
+ * Adjust quota timers & warnings
+ */
+int xfs_qm_scall_setinfo(struct xfs_mount *mp, uint type, struct qc_info *info)
+{
+	struct qc_dqblk newlim;
+
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
+	return xfs_qm_scall_setqlim(mp, 0, type, &newlim);
+}
+
 #define XFS_QC_MASK \
 	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
 
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 698e6faac519..a25f482955a7 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -45,6 +45,21 @@ static int xfs_fs_get_quota_state(struct super_block *sb, struct qc_state *s)
 	return xfs_qm_scall_getstate(XFS_M(sb), s);
 }
 
+static int xfs_fs_set_info(struct super_block *sb, int type,
+			   struct qc_info *info)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return -ESRCH;
+
+	return xfs_qm_scall_setinfo(mp, xfs_quota_type(type), info);
+}
+
 static unsigned int xfs_quota_flags(unsigned int uflags)
 {
 	unsigned int flags = 0;
@@ -159,6 +174,7 @@ xfs_fs_set_dqblk(
 
 const struct quotactl_ops xfs_quotactl_operations = {
 	.get_state		= xfs_fs_get_quota_state,
+	.set_info		= xfs_fs_set_info,
 	.quota_enable		= xfs_quota_enable,
 	.quota_disable		= xfs_quota_disable,
 	.rm_xquota		= xfs_fs_rm_xquota,
-- 
2.1.2
