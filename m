From: Jan Kara <jack@suse.cz>
Date: Mon, 26 Jan 2015 15:34:24 +0100
Subject: [Ocfs2-devel] [PATCH 07/16] quota: Remove quota_on_meta callback
In-Reply-To: <1422282873-3381-1-git-send-email-jack@suse.cz>
References: <1422282873-3381-1-git-send-email-jack@suse.cz>
Message-ID: <1422282873-3381-8-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

There are no more users for quota_on_meta callback. Just remove it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c      | 5 +----
 include/linux/quota.h | 1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index ce78a70a596f..d14a799c7785 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -82,11 +82,8 @@ unsigned int qtype_enforce_flag(int type)
 static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
 		         struct path *path)
 {
-	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_on_meta &&
-	    !sb->s_qcop->quota_enable)
+	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_enable)
 		return -ENOSYS;
-	if (sb->s_qcop->quota_on_meta)
-		return sb->s_qcop->quota_on_meta(sb, type, id);
 	if (sb->s_qcop->quota_enable)
 		return sb->s_qcop->quota_enable(sb, qtype_enforce_flag(type));
 	if (IS_ERR(path))
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 4da497b807c4..0938159d65c8 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -369,7 +369,6 @@ struct qc_dqblk {
 /* Operations handling requests from userspace */
 struct quotactl_ops {
 	int (*quota_on)(struct super_block *, int, int, struct path *);
-	int (*quota_on_meta)(struct super_block *, int, int);
 	int (*quota_off)(struct super_block *, int);
 	int (*quota_enable)(struct super_block *, unsigned int);
 	int (*quota_disable)(struct super_block *, unsigned int);
-- 
2.1.2
