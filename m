From: Jan Kara <jack@suse.cz>
Date: Thu,  4 Feb 2016 15:28:07 +0100
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Implement get_next_id()
In-Reply-To: <1454596087-6814-1-git-send-email-jack@suse.cz>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
Message-ID: <1454596087-6814-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>

Implement get_next_id() callback to enable use of Q_GETNEXTQUOTA
quotactl for OCFS2.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/ocfs2_trace.h  |  2 ++
 fs/ocfs2/quota_global.c | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 6cb019b7c6a8..a52a2dbc064e 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2035,6 +2035,8 @@ DEFINE_OCFS2_UINT_INT_EVENT(ocfs2_release_dquot);
 
 DEFINE_OCFS2_UINT_INT_EVENT(ocfs2_acquire_dquot);
 
+DEFINE_OCFS2_UINT_INT_EVENT(ocfs2_get_next_id);
+
 DEFINE_OCFS2_UINT_INT_EVENT(ocfs2_mark_dquot_dirty);
 
 /* End of trace events for fs/ocfs2/quota_global.c. */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index fde9ef18cff3..8c903ce08e95 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -860,6 +860,30 @@ out:
 	return status;
 }
 
+static int ocfs2_get_next_id(struct super_block *sb, struct kqid *qid)
+{
+	int type = qid->type;
+	struct ocfs2_mem_dqinfo *info = sb_dqinfo(sb, type)->dqi_priv;
+	int status = 0;
+
+	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
+	status = ocfs2_lock_global_qf(info, 0);
+	if (status < 0)
+		goto out;
+	status = ocfs2_qinfo_lock(info, 0);
+	if (status < 0)
+		goto out_global;
+	status = qtree_get_next_id(&info->dqi_gi, qid);
+	ocfs2_qinfo_unlock(info, 0);
+out_global:
+	ocfs2_unlock_global_qf(info, 0);
+out:
+	/* Avoid logging ENOENT since it just means there isn't next ID */
+	if (status && status != -ENOENT)
+		mlog_errno(status);
+	return status;
+}
+
 static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
 {
 	unsigned long mask = (1 << (DQ_LASTSET_B + QIF_ILIMITS_B)) |
@@ -968,4 +992,5 @@ const struct dquot_operations ocfs2_quota_operations = {
 	.write_info	= ocfs2_write_info,
 	.alloc_dquot	= ocfs2_alloc_dquot,
 	.destroy_dquot	= ocfs2_destroy_dquot,
+	.get_next_id	= ocfs2_get_next_id,
 };
-- 
2.6.2
