From: Jan Kara <jack@suse.cz>
Date: Mon, 26 Jan 2015 15:34:30 +0100
Subject: [Ocfs2-devel] [PATCH 13/16] quota: Remove ->get_xstate and
	->get_xstatev callbacks
In-Reply-To: <1422282873-3381-1-git-send-email-jack@suse.cz>
References: <1422282873-3381-1-git-send-email-jack@suse.cz>
Message-ID: <1422282873-3381-14-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

These callbacks are now unused. Remove them.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c      | 14 ++++----------
 include/linux/quota.h |  2 --
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 83939ff4c444..20d11cd21247 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -350,12 +350,9 @@ static int quota_getxstate(struct super_block *sb, void __user *addr)
 	struct fs_quota_stat fqs;
 	int ret;
 
-	if (!sb->s_qcop->get_xstate && !sb->s_qcop->get_state)
+	if (!sb->s_qcop->get_state)
 		return -ENOSYS;
-	if (sb->s_qcop->get_state)
-		ret = quota_getstate(sb, &fqs);
-	else
-		ret = sb->s_qcop->get_xstate(sb, &fqs);
+	ret = quota_getstate(sb, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
 	return ret;
@@ -414,7 +411,7 @@ static int quota_getxstatev(struct super_block *sb, void __user *addr)
 	struct fs_quota_statv fqs;
 	int ret;
 
-	if (!sb->s_qcop->get_xstatev && !sb->s_qcop->get_state)
+	if (!sb->s_qcop->get_state)
 		return -ENOSYS;
 
 	memset(&fqs, 0, sizeof(fqs));
@@ -428,10 +425,7 @@ static int quota_getxstatev(struct super_block *sb, void __user *addr)
 	default:
 		return -EINVAL;
 	}
-	if (sb->s_qcop->get_state)
-		ret = quota_getstatev(sb, &fqs);
-	else
-		ret = sb->s_qcop->get_xstatev(sb, &fqs);
+	ret = quota_getstatev(sb, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
 	return ret;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 6ecac0f3b2ca..a07f2ed25284 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -408,8 +408,6 @@ struct quotactl_ops {
 	int (*get_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
 	int (*set_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
 	int (*get_state)(struct super_block *, struct qc_state *);
-	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
-	int (*get_xstatev)(struct super_block *, struct fs_quota_statv *);
 	int (*rm_xquota)(struct super_block *, unsigned int);
 };
 
-- 
2.1.2
