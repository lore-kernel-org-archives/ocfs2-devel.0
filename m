From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Jan 2015 19:27:10 +0100
Subject: [Ocfs2-devel] [PATCH 3/4] quota: Cleanup flags definitions
In-Reply-To: <1421260031-3355-1-git-send-email-jack@suse.cz>
References: <1421260031-3355-1-git-send-email-jack@suse.cz>
Message-ID: <1421260031-3355-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>

Currently all quota flags were defined just in kernel-private headers.
Export flags readable / writeable from userspace to userspace via
include/uapi/linux/quota.h.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c           |  2 +-
 include/linux/dqblk_v1.h   |  3 ---
 include/linux/quota.h      | 14 ++++++++------
 include/uapi/linux/quota.h | 14 +++++++++++++-
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 8f0acef3d184..f8be368b9086 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1248,7 +1248,7 @@ static int ignore_hardlimit(struct dquot *dquot)
 
 	return capable(CAP_SYS_RESOURCE) &&
 	       (info->dqi_format->qf_fmt_id != QFMT_VFS_OLD ||
-		!(info->dqi_flags & V1_DQF_RSQUASH));
+		!(info->dqi_flags & DQF_ROOT_SQUASH));
 }
 
 /* needs dq_data_lock */
diff --git a/include/linux/dqblk_v1.h b/include/linux/dqblk_v1.h
index 3713a7232dd8..c0d4d1e2a45c 100644
--- a/include/linux/dqblk_v1.h
+++ b/include/linux/dqblk_v1.h
@@ -5,9 +5,6 @@
 #ifndef _LINUX_DQBLK_V1_H
 #define _LINUX_DQBLK_V1_H
 
-/* Root squash turned on */
-#define V1_DQF_RSQUASH 1
-
 /* Numbers of blocks needed for updates */
 #define V1_INIT_ALLOC 1
 #define V1_INIT_REWRITE 1
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 50978b781a19..0c42113607ce 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -223,12 +223,14 @@ struct mem_dqinfo {
 
 struct super_block;
 
-#define DQF_MASK 0xffff		/* Mask for format specific flags */
-#define DQF_GETINFO_MASK 0x1ffff	/* Mask for flags passed to userspace */
-#define DQF_SETINFO_MASK 0xffff		/* Mask for flags modifiable from userspace */
-#define DQF_SYS_FILE_B		16
-#define DQF_SYS_FILE (1 << DQF_SYS_FILE_B)	/* Quota file stored as system file */
-#define DQF_INFO_DIRTY_B	31
+/* Mask for flags passed to userspace */
+#define DQF_GETINFO_MASK (DQF_ROOT_SQUASH | DQF_SYS_FILE)
+/* Mask for flags modifiable from userspace */
+#define DQF_SETINFO_MASK DQF_ROOT_SQUASH
+
+enum {
+	DQF_INFO_DIRTY_B = DQF_PRIVATE,
+};
 #define DQF_INFO_DIRTY (1 << DQF_INFO_DIRTY_B)	/* Is info dirty? */
 
 extern void mark_info_dirty(struct super_block *sb, int type);
diff --git a/include/uapi/linux/quota.h b/include/uapi/linux/quota.h
index 3b6cfbeb086d..1f49b8341c99 100644
--- a/include/uapi/linux/quota.h
+++ b/include/uapi/linux/quota.h
@@ -126,10 +126,22 @@ struct if_dqblk {
 #define IIF_FLAGS	4
 #define IIF_ALL		(IIF_BGRACE | IIF_IGRACE | IIF_FLAGS)
 
+enum {
+	DQF_ROOT_SQUASH_B = 0,
+	DQF_SYS_FILE_B = 16,
+	/* Kernel internal flags invisible to userspace */
+	DQF_PRIVATE
+};
+
+/* Root squash enabled (for v1 quota format) */
+#define DQF_ROOT_SQUASH	(1 << DQF_ROOT_SQUASH_B)
+/* Quota stored in a system file */
+#define DQF_SYS_FILE	(1 << DQF_SYS_FILE_B)
+
 struct if_dqinfo {
 	__u64 dqi_bgrace;
 	__u64 dqi_igrace;
-	__u32 dqi_flags;
+	__u32 dqi_flags;	/* DFQ_* */
 	__u32 dqi_valid;
 };
 
-- 
2.1.2
