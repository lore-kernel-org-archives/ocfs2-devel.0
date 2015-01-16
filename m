From: Jan Kara <jack@suse.cz>
Date: Fri, 16 Jan 2015 13:47:51 +0100
Subject: [Ocfs2-devel] [PATCH 17/17] quota: Hook up Q_XSETQLIM for id 0 to
	->set_info
In-Reply-To: <1421412471-4747-1-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
Message-ID: <1421412471-4747-18-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Setting timers or warning counts for id 0 via Q_XSETQLIM is used to
actually set time limits and warning limits for all users. Hook up
->set_info to this so that VFS quota time limits get set the same
way as XFS ones.

When doing this Q_XSETQLIM for XFS is effectively split into two
independent transactions - one for setting timers and warning limits and
one for setting space and inode limits. Although this is inefficient, it
is rare enough that it does not matter.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index f39bf4725184..813cb94fc81d 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -500,6 +500,30 @@ static void copy_from_xfs_dqblk(struct qc_dqblk *dst, struct fs_disk_quota *src)
 		dst->d_fieldmask |= QC_RT_SPACE;
 }
 
+static void copy_qcinfo_from_xfs_dqblk(struct qc_info *dst,
+				       struct fs_disk_quota *src)
+{
+	memset(dst, 0, sizeof(*dst));
+	dst->i_spc_timelimit = src->d_btimer;
+	dst->i_ino_timelimit = src->d_itimer;
+	dst->i_rt_spc_timelimit = src->d_rtbtimer;
+	dst->i_ino_warnlimit = src->d_iwarns;
+	dst->i_spc_warnlimit = src->d_bwarns;
+	dst->i_rt_spc_warnlimit = src->d_rtbwarns;
+	if (src->d_fieldmask & FS_DQ_BWARNS)
+		dst->i_fieldmask |= QC_SPC_WARNS;
+	if (src->d_fieldmask & FS_DQ_IWARNS)
+		dst->i_fieldmask |= QC_INO_WARNS;
+	if (src->d_fieldmask & FS_DQ_RTBWARNS)
+		dst->i_fieldmask |= QC_RT_SPC_WARNS;
+	if (src->d_fieldmask & FS_DQ_BTIMER)
+		dst->i_fieldmask |= QC_SPC_TIMER;
+	if (src->d_fieldmask & FS_DQ_ITIMER)
+		dst->i_fieldmask |= QC_INO_TIMER;
+	if (src->d_fieldmask & FS_DQ_RTBTIMER)
+		dst->i_fieldmask |= QC_RT_SPC_TIMER;
+}
+
 static int quota_setxquota(struct super_block *sb, int type, qid_t id,
 			   void __user *addr)
 {
@@ -514,6 +538,21 @@ static int quota_setxquota(struct super_block *sb, int type, qid_t id,
 	qid = make_kqid(current_user_ns(), type, id);
 	if (!qid_valid(qid))
 		return -EINVAL;
+	/* Are we actually setting timer / warning limits for all users? */
+	if (from_kqid(&init_user_ns, qid) == 0 &&
+	    fdq.d_fieldmask & (FS_DQ_WARNS_MASK | FS_DQ_TIMER_MASK)) {
+		struct qc_info qinfo;
+		int ret;
+
+		if (!sb->s_qcop->set_info)
+			return -EINVAL;
+		copy_qcinfo_from_xfs_dqblk(&qinfo, &fdq);
+		ret = sb->s_qcop->set_info(sb, type, &qinfo);
+		if (ret)
+			return ret;
+		/* These are already done */
+		fdq.d_fieldmask &= ~(FS_DQ_WARNS_MASK | FS_DQ_TIMER_MASK);
+	}
 	copy_from_xfs_dqblk(&qdq, &fdq);
 	return sb->s_qcop->set_dqblk(sb, qid, &qdq);
 }
-- 
2.1.2
