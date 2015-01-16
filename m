From: Jan Kara <jack@suse.cz>
Date: Fri, 16 Jan 2015 13:47:39 +0100
Subject: [Ocfs2-devel] [PATCH 05/17] ocfs2: Use generic helpers for quotaon
	and quotaoff
In-Reply-To: <1421412471-4747-1-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
Message-ID: <1421412471-4747-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Ocfs2 can just use the generic helpers provided by quota code for
turning quotas on and off when quota files are stored as system inodes.
The only difference is the feature test in ocfs2_quota_on() and that is
covered by dquot_quota_enable() checking whether usage tracking is
enabled (which can happen only if the filesystem has the quota feature
set).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/super.c | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 83723179e1ec..706c71c2955d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1000,36 +1000,6 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
 	}
 }
 
-/* Handle quota on quotactl */
-static int ocfs2_quota_on(struct super_block *sb, int type, int format_id)
-{
-	unsigned int feature[OCFS2_MAXQUOTAS] = {
-					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
-					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
-
-	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
-		return -EINVAL;
-
-	return dquot_enable(sb_dqopt(sb)->files[type], type,
-			    format_id, DQUOT_LIMITS_ENABLED);
-}
-
-/* Handle quota off quotactl */
-static int ocfs2_quota_off(struct super_block *sb, int type)
-{
-	return dquot_disable(sb, type, DQUOT_LIMITS_ENABLED);
-}
-
-static const struct quotactl_ops ocfs2_quotactl_ops = {
-	.quota_on_meta	= ocfs2_quota_on,
-	.quota_off	= ocfs2_quota_off,
-	.quota_sync	= dquot_quota_sync,
-	.get_info	= dquot_get_dqinfo,
-	.set_info	= dquot_set_dqinfo,
-	.get_dqblk	= dquot_get_dqblk,
-	.set_dqblk	= dquot_set_dqblk,
-};
-
 static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct dentry *root;
@@ -2079,7 +2049,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_op = &ocfs2_sops;
 	sb->s_d_op = &ocfs2_dentry_ops;
 	sb->s_export_op = &ocfs2_export_ops;
-	sb->s_qcop = &ocfs2_quotactl_ops;
+	sb->s_qcop = &dquot_quotactl_sysfile_ops;
 	sb->dq_op = &ocfs2_quota_operations;
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 	sb->s_xattr = ocfs2_xattr_handlers;
-- 
2.1.2
