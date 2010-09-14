From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:39 -0700
Subject: [Ocfs2-devel] [PATCH 03/20] ocfs2: Add support for heartbeat=global
	mount option
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Adds support for heartbeat=global mount option. It ensures that the heartbeat
mode passed matches the one enabled on disk.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    4 ++-
 fs/ocfs2/ocfs2_fs.h |    1 +
 fs/ocfs2/super.c    |   55 ++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index d5496a7..481387b 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -243,7 +243,7 @@ enum ocfs2_local_alloc_state
 
 enum ocfs2_mount_options
 {
-	OCFS2_MOUNT_HB_LOCAL   = 1 << 0, /* Heartbeat started in local mode */
+	OCFS2_MOUNT_HB_LOCAL = 1 << 0, /* Local heartbeat */
 	OCFS2_MOUNT_BARRIER = 1 << 1,	/* Use block barriers */
 	OCFS2_MOUNT_NOINTR  = 1 << 2,   /* Don't catch signals */
 	OCFS2_MOUNT_ERRORS_PANIC = 1 << 3, /* Panic on errors */
@@ -256,6 +256,8 @@ enum ocfs2_mount_options
 						   control lists */
 	OCFS2_MOUNT_USRQUOTA = 1 << 10, /* We support user quotas */
 	OCFS2_MOUNT_GRPQUOTA = 1 << 11, /* We support group quotas */
+	OCFS2_MOUNT_HB_NONE = 1 << 12, /* No heartbeat */
+	OCFS2_MOUNT_HB_GLOBAL = 1 << 13, /* Global heartbeat */
 };
 
 #define OCFS2_OSB_SOFT_RO			0x0001
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index abe048e..4eeeccd 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -363,6 +363,7 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 /* Parameter passed from mount.ocfs2 to module */
 #define OCFS2_HB_NONE			"heartbeat=none"
 #define OCFS2_HB_LOCAL			"heartbeat=local"
+#define OCFS2_HB_GLOBAL			"heartbeat=global"
 
 /*
  * OCFS2 directory file types.  Only the low 3 bits are used.  The
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7554317..00d842c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -162,6 +162,7 @@ enum {
 	Opt_nointr,
 	Opt_hb_none,
 	Opt_hb_local,
+	Opt_hb_global,
 	Opt_data_ordered,
 	Opt_data_writeback,
 	Opt_atime_quantum,
@@ -190,6 +191,7 @@ static const match_table_t tokens = {
 	{Opt_nointr, "nointr"},
 	{Opt_hb_none, OCFS2_HB_NONE},
 	{Opt_hb_local, OCFS2_HB_LOCAL},
+	{Opt_hb_global, OCFS2_HB_GLOBAL},
 	{Opt_data_ordered, "data=ordered"},
 	{Opt_data_writeback, "data=writeback"},
 	{Opt_atime_quantum, "atime_quantum=%u"},
@@ -608,6 +610,7 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 	int ret = 0;
 	struct mount_options parsed_options;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
+	u32 tmp;
 
 	lock_kernel();
 
@@ -617,8 +620,9 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		goto out;
 	}
 
-	if ((osb->s_mount_opt & OCFS2_MOUNT_HB_LOCAL) !=
-	    (parsed_options.mount_opt & OCFS2_MOUNT_HB_LOCAL)) {
+	tmp = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
+		OCFS2_MOUNT_HB_NONE;
+	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
 		ret = -EINVAL;
 		mlog(ML_ERROR, "Cannot change heartbeat mode on remount\n");
 		goto out;
@@ -809,23 +813,29 @@ bail:
 
 static int ocfs2_verify_heartbeat(struct ocfs2_super *osb)
 {
-	if (ocfs2_mount_local(osb)) {
-		if (osb->s_mount_opt & OCFS2_MOUNT_HB_LOCAL) {
+	u32 hb_enabled = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL;
+
+	if (osb->s_mount_opt & hb_enabled) {
+		if (ocfs2_mount_local(osb)) {
 			mlog(ML_ERROR, "Cannot heartbeat on a locally "
 			     "mounted device.\n");
 			return -EINVAL;
 		}
-	}
-
-	if (ocfs2_userspace_stack(osb)) {
-		if (osb->s_mount_opt & OCFS2_MOUNT_HB_LOCAL) {
+		if (ocfs2_userspace_stack(osb)) {
 			mlog(ML_ERROR, "Userspace stack expected, but "
 			     "o2cb heartbeat arguments passed to mount\n");
 			return -EINVAL;
 		}
+		if (((osb->s_mount_opt & OCFS2_MOUNT_HB_GLOBAL) &&
+		     !ocfs2_cluster_o2cb_global_heartbeat(osb)) ||
+		    ((osb->s_mount_opt & OCFS2_MOUNT_HB_LOCAL) &&
+		     ocfs2_cluster_o2cb_global_heartbeat(osb))) {
+			mlog(ML_ERROR, "Mismatching o2cb heartbeat modes\n");
+			return -EINVAL;
+		}
 	}
 
-	if (!(osb->s_mount_opt & OCFS2_MOUNT_HB_LOCAL)) {
+	if (!(osb->s_mount_opt & hb_enabled)) {
 		if (!ocfs2_mount_local(osb) && !ocfs2_is_hard_readonly(osb) &&
 		    !ocfs2_userspace_stack(osb)) {
 			mlog(ML_ERROR, "Heartbeat has to be started to mount "
@@ -1291,6 +1301,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 {
 	int status;
 	char *p;
+	u32 tmp;
 
 	mlog_entry("remount: %d, options: \"%s\"\n", is_remount,
 		   options ? options : "(none)");
@@ -1322,7 +1333,10 @@ static int ocfs2_parse_options(struct super_block *sb,
 			mopt->mount_opt |= OCFS2_MOUNT_HB_LOCAL;
 			break;
 		case Opt_hb_none:
-			mopt->mount_opt &= ~OCFS2_MOUNT_HB_LOCAL;
+			mopt->mount_opt |= OCFS2_MOUNT_HB_NONE;
+			break;
+		case Opt_hb_global:
+			mopt->mount_opt |= OCFS2_MOUNT_HB_GLOBAL;
 			break;
 		case Opt_barrier:
 			if (match_int(&args[0], &option)) {
@@ -1477,6 +1491,15 @@ static int ocfs2_parse_options(struct super_block *sb,
 		}
 	}
 
+	/* Ensure only one heartbeat mode */
+	tmp = mopt->mount_opt & (OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
+				 OCFS2_MOUNT_HB_NONE);
+	if (hweight32(tmp) != 1) {
+		mlog(ML_ERROR, "Invalid heartbeat mount option: %s\n", options);
+		status = 0;
+		goto bail;
+	}
+
 	status = 1;
 
 bail:
@@ -1490,10 +1513,14 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	unsigned long opts = osb->s_mount_opt;
 	unsigned int local_alloc_megs;
 
-	if (opts & OCFS2_MOUNT_HB_LOCAL)
-		seq_printf(s, ",_netdev,heartbeat=local");
-	else
-		seq_printf(s, ",heartbeat=none");
+	if (opts & (OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL)) {
+		seq_printf(s, ",_netdev");
+		if (opts & OCFS2_MOUNT_HB_LOCAL)
+			seq_printf(s, ",%s", OCFS2_HB_LOCAL);
+		else
+			seq_printf(s, ",%s", OCFS2_HB_GLOBAL);
+	} else
+		seq_printf(s, ",%s", OCFS2_HB_NONE);
 
 	if (opts & OCFS2_MOUNT_NOINTR)
 		seq_printf(s, ",nointr");
-- 
1.7.0.4
