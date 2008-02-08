From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  8 10:50:12 2008
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Add datavolume mount option
In-Reply-To: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
References: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1202496577-21982-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is a forward port of the datavolume mount option in OCFS2 1.2.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/ocfs2.h |    3 +++
 fs/ocfs2/super.c |   40 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index d084805..b9eafc0 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -172,6 +172,9 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_ERRORS_PANIC = 1 << 3, /* Panic on errors */
 	OCFS2_MOUNT_DATA_WRITEBACK = 1 << 4, /* No data ordering */
 	OCFS2_MOUNT_LOCALFLOCKS = 1 << 5, /* No cluster aware user file locks */
+#ifdef OCFS2_ORACORE_WORKAROUNDS
+	OCFS2_MOUNT_COMPAT_OCFS = 1 << 30, /* ocfs1 compatibility mode */
+#endif
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 6791be8..d5e2644 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -143,6 +143,10 @@ static const struct super_operations ocfs2_sops = {
 	.show_options   = ocfs2_show_options,
 };
 
+#ifdef OCFS2_ORACORE_WORKAROUNDS
+# define OCFS_SUPER_MAGIC		0xa156f7eb
+#endif
+
 enum {
 	Opt_barrier,
 	Opt_err_panic,
@@ -158,6 +162,9 @@ enum {
 	Opt_commit,
 	Opt_localalloc,
 	Opt_localflocks,
+#ifdef OCFS2_ORACORE_WORKAROUNDS
+	Opt_datavolume,
+#endif
 	Opt_err,
 };
 
@@ -176,6 +183,9 @@ static match_table_t tokens = {
 	{Opt_commit, "commit=%u"},
 	{Opt_localalloc, "localalloc=%d"},
 	{Opt_localflocks, "localflocks"},
+#ifdef OCFS2_ORACORE_WORKAROUNDS
+	{Opt_datavolume, "datavolume"},
+#endif
 	{Opt_err, NULL}
 };
 
@@ -613,7 +623,12 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->osb_commit_interval = parsed_options.commit_interval;
 	osb->local_alloc_size = parsed_options.localalloc_opt;
 
-	sb->s_magic = OCFS2_SUPER_MAGIC;
+#ifdef OCFS2_ORACORE_WORKAROUNDS
+	if (osb->s_mount_opt & OCFS2_MOUNT_COMPAT_OCFS)
+		sb->s_magic = OCFS_SUPER_MAGIC;
+	else
+#endif
+		sb->s_magic = OCFS2_SUPER_MAGIC;
 
 	/* Hard readonly mode only if: bdev_read_only, MS_RDONLY,
 	 * heartbeat=none */
@@ -826,6 +841,17 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_data_writeback:
 			mopt->mount_opt |= OCFS2_MOUNT_DATA_WRITEBACK;
 			break;
+#ifdef OCFS2_ORACORE_WORKAROUNDS
+		case Opt_datavolume:
+			if (is_remount) {
+				mlog(ML_ERROR, "Cannot specify datavolume "
+				     "on remount.\n");
+				status = 0;
+				goto bail;
+			}
+			mopt->mount_opt |= OCFS2_MOUNT_COMPAT_OCFS;
+			break;
+#endif
 		case Opt_atime_quantum:
 			if (match_int(&args[0], &option)) {
 				status = 0;
@@ -920,6 +946,11 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	else
 		seq_printf(s, ",errors=remount-ro");
 
+#ifdef OCFS2_ORACORE_WORKAROUNDS
+	if (opts & OCFS2_MOUNT_COMPAT_OCFS)
+		seq_printf(s, ",datavolume");
+#endif
+
 	if (osb->preferred_slot != OCFS2_INVALID_SLOT)
 		seq_printf(s, ",preferred_slot=%d", osb->preferred_slot);
 
@@ -1048,7 +1079,12 @@ static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 	numbits = le32_to_cpu(bm_lock->id1.bitmap1.i_total);
 	freebits = numbits - le32_to_cpu(bm_lock->id1.bitmap1.i_used);
 
-	buf->f_type = OCFS2_SUPER_MAGIC;
+#ifdef OCFS2_ORACORE_WORKAROUNDS
+	if (osb->s_mount_opt & OCFS2_MOUNT_COMPAT_OCFS)
+		buf->f_type = OCFS_SUPER_MAGIC;
+	else
+#endif
+		buf->f_type = OCFS2_SUPER_MAGIC;
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	buf->f_namelen = OCFS2_MAX_FILENAME_LEN;
 	buf->f_blocks = ((sector_t) numbits) *
-- 
1.5.2.5
