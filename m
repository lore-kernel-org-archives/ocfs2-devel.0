From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 3 Mar 2015 12:08:30 -0600
Subject: [Ocfs2-devel] [PATCH 1/3] Add errors=continue
Message-ID: <20150303180829.GA13122@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2 is often used in high-availaibility systems. However, ocfs2
converts the filesystem to read-only at the drop of the hat. This
may not be necessary, since turning the filesystem read-only would
affect other running processes as well, decreasing availability.

This attempt is to add errors=continue, which would return the EIO
to the calling process and terminate furhter processing so that
the filesystem is not corrupted further. However, the filesystem
is not converted to read-only.

As a future plan, I intend to create a small utility or extend
fsck.ocfs2 to fix small errors such as in the inode. The input
to the utility such as the inode can come from the kernel logs
so we don't have to schedule a downtime for fixing small-enough
errors.

The patch changes the ocfs2_error to return an error. The error
returned depends on the mount option set. If none is set, the default
is to turn the filesystem read-only.

Perhaps errors=continue is not the best option name. Historically
it is used for making an attempt to progress in the current
process itself. Should we call it errors=eio? or errors=killproc?
Suggestions/Comments welcome.

Sources are available at:
https://github.com/goldwynr/linux/tree/error-cont

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/ocfs2.h |  2 ++
 fs/ocfs2/super.c | 57 +++++++++++++++++++++++++++++++++++++++++---------------
 fs/ocfs2/super.h |  2 +-
 3 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 8490c64..d690a59 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -286,6 +286,8 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_HB_GLOBAL = 1 << 14, /* Global heartbeat */
 
 	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
+	OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
+	OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2667518..088323e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -192,6 +192,7 @@ enum {
 	Opt_resv_level,
 	Opt_dir_resv_level,
 	Opt_journal_async_commit,
+	Opt_err_cont,
 	Opt_err,
 };
 
@@ -224,6 +225,7 @@ static const match_table_t tokens = {
 	{Opt_resv_level, "resv_level=%u"},
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_journal_async_commit, "journal_async_commit"},
+	{Opt_err_cont, "errors=continue"},
 	{Opt_err, NULL}
 };
 
@@ -1330,10 +1332,19 @@ static int ocfs2_parse_options(struct super_block *sb,
 			mopt->mount_opt |= OCFS2_MOUNT_NOINTR;
 			break;
 		case Opt_err_panic:
+			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_CONT;
+			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_ROFS;
 			mopt->mount_opt |= OCFS2_MOUNT_ERRORS_PANIC;
 			break;
 		case Opt_err_ro:
+			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_CONT;
 			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_PANIC;
+			mopt->mount_opt |= OCFS2_MOUNT_ERRORS_ROFS;
+			break;
+		case Opt_err_cont:
+			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_ROFS;
+			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_PANIC;
+			mopt->mount_opt |= OCFS2_MOUNT_ERRORS_CONT;
 			break;
 		case Opt_data_ordered:
 			mopt->mount_opt &= ~OCFS2_MOUNT_DATA_WRITEBACK;
@@ -1530,6 +1541,8 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 
 	if (opts & OCFS2_MOUNT_ERRORS_PANIC)
 		seq_printf(s, ",errors=panic");
+	else if (opts & OCFS2_MOUNT_ERRORS_CONT)
+		seq_printf(s, ",errors=continue");
 	else
 		seq_printf(s, ",errors=remount-ro");
 
@@ -2539,33 +2552,47 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 	memset(osb, 0, sizeof(struct ocfs2_super));
 }
 
-/* Put OCFS2 into a readonly state, or (if the user specifies it),
- * panic(). We do not support continue-on-error operation. */
-static void ocfs2_handle_error(struct super_block *sb)
+/* Depending on the mount option passed, perform one of the following:
+ * Put OCFS2 into a readonly state (default)
+ * Return EIO so that only the process errs
+ * Fix the error as if fsck.ocfs2 -y
+ * panic
+ */
+static int ocfs2_handle_error(struct super_block *sb)
 {
 	struct ocfs2_super *osb = OCFS2_SB(sb);
+	int rv = 0;
+
+	ocfs2_set_osb_flag(osb, OCFS2_OSB_ERROR_FS);
+	pr_crit("On-disk corruption discovered. "
+		"Please run fsck.ocfs2 once the filesystem is unmounted.\n");
 
 	if (osb->s_mount_opt & OCFS2_MOUNT_ERRORS_PANIC)
 		panic("OCFS2: (device %s): panic forced after error\n",
 		      sb->s_id);
+	else if (osb->s_mount_opt & OCFS2_MOUNT_ERRORS_CONT) {
+		pr_crit("OCFS2: Returning error to the calling process.\n");
+		rv = -EIO;
+	}
+	else { /* default option */
+		rv = -EROFS;
+		if (sb->s_flags & MS_RDONLY &&
+				(ocfs2_is_soft_readonly(osb) ||
+				 ocfs2_is_hard_readonly(osb)))
+			return rv;
 
-	ocfs2_set_osb_flag(osb, OCFS2_OSB_ERROR_FS);
+		pr_crit("OCFS2: File system is now read-only.\n");
+		sb->s_flags |= MS_RDONLY;
+		ocfs2_set_ro_flag(osb, 0);
+	}
 
-	if (sb->s_flags & MS_RDONLY &&
-	    (ocfs2_is_soft_readonly(osb) ||
-	     ocfs2_is_hard_readonly(osb)))
-		return;
+	return rv;
 
-	printk(KERN_CRIT "File system is now read-only due to the potential "
-	       "of on-disk corruption. Please run fsck.ocfs2 once the file "
-	       "system is unmounted.\n");
-	sb->s_flags |= MS_RDONLY;
-	ocfs2_set_ro_flag(osb, 0);
 }
 
 static char error_buf[1024];
 
-void __ocfs2_error(struct super_block *sb,
+int __ocfs2_error(struct super_block *sb,
 		   const char *function,
 		   const char *fmt, ...)
 {
@@ -2580,7 +2607,7 @@ void __ocfs2_error(struct super_block *sb,
 	printk(KERN_CRIT "OCFS2: ERROR (device %s): %s: %s\n",
 	       sb->s_id, function, error_buf);
 
-	ocfs2_handle_error(sb);
+	return ocfs2_handle_error(sb);
 }
 
 /* Handle critical errors. This is intentionally more drastic than
diff --git a/fs/ocfs2/super.h b/fs/ocfs2/super.h
index 74ff74c..c1c87d9 100644
--- a/fs/ocfs2/super.h
+++ b/fs/ocfs2/super.h
@@ -32,7 +32,7 @@ int ocfs2_publish_get_mount_state(struct ocfs2_super *osb,
 				  int node_num);
 
 __printf(3, 4)
-void __ocfs2_error(struct super_block *sb, const char *function,
+int __ocfs2_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
 
 #define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##args)
-- 
2.1.4
