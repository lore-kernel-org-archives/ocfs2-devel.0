From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 07 Apr 2015 14:55:54 -0700
Subject: [Ocfs2-devel] [patch 3/9] ocfs2: add errors=continue
Message-ID: <5524526a.11QmBGTg1SLI/q2g%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: add errors=continue

OCFS2 is often used in high-availaibility systems.  However, ocfs2
converts the filesystem to read-only at the drop of the hat.  This may not
be necessary, since turning the filesystem read-only would affect other
running processes as well, decreasing availability.

This attempt is to add errors=continue, which would return the EIO to the
calling process and terminate furhter processing so that the filesystem is
not corrupted further.  However, the filesystem is not converted to
read-only.

As a future plan, I intend to create a small utility or extend fsck.ocfs2
to fix small errors such as in the inode.  The input to the utility such
as the inode can come from the kernel logs so we don't have to schedule a
downtime for fixing small-enough errors.

The patch changes the ocfs2_error to return an error.  The error returned
depends on the mount option set.  If none is set, the default is to turn
the filesystem read-only.

Perhaps errors=continue is not the best option name.  Historically it is
used for making an attempt to progress in the current process itself. 
Should we call it errors=eio?  or errors=killproc?  Suggestions/Comments
welcome.

Sources are available at:
https://github.com/goldwynr/linux/tree/error-cont

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h |    2 +
 fs/ocfs2/super.c |   59 ++++++++++++++++++++++++++++++++-------------
 fs/ocfs2/super.h |    2 -
 3 files changed, 45 insertions(+), 18 deletions(-)

diff -puN fs/ocfs2/ocfs2.h~add-errors=continue fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~add-errors=continue
+++ a/fs/ocfs2/ocfs2.h
@@ -286,6 +286,8 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_HB_GLOBAL = 1 << 14, /* Global heartbeat */
 
 	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
+	OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
+	OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff -puN fs/ocfs2/super.c~add-errors=continue fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~add-errors=continue
+++ a/fs/ocfs2/super.c
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
 
@@ -1330,10 +1332,19 @@ static int ocfs2_parse_options(struct su
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
@@ -1530,6 +1541,8 @@ static int ocfs2_show_options(struct seq
 
 	if (opts & OCFS2_MOUNT_ERRORS_PANIC)
 		seq_printf(s, ",errors=panic");
+	else if (opts & OCFS2_MOUNT_ERRORS_CONT)
+		seq_printf(s, ",errors=continue");
 	else
 		seq_printf(s, ",errors=remount-ro");
 
@@ -2540,31 +2553,43 @@ static void ocfs2_delete_osb(struct ocfs
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
 
-	if (osb->s_mount_opt & OCFS2_MOUNT_ERRORS_PANIC)
+	if (osb->s_mount_opt & OCFS2_MOUNT_ERRORS_PANIC) {
 		panic("OCFS2: (device %s): panic forced after error\n",
 		      sb->s_id);
+	} else if (osb->s_mount_opt & OCFS2_MOUNT_ERRORS_CONT) {
+		pr_crit("OCFS2: Returning error to the calling process.\n");
+		rv = -EIO;
+	} else { /* default option */
+		rv = -EROFS;
+		if (sb->s_flags & MS_RDONLY &&
+				(ocfs2_is_soft_readonly(osb) ||
+				 ocfs2_is_hard_readonly(osb)))
+			return rv;
 
-	ocfs2_set_osb_flag(osb, OCFS2_OSB_ERROR_FS);
-
-	if (sb->s_flags & MS_RDONLY &&
-	    (ocfs2_is_soft_readonly(osb) ||
-	     ocfs2_is_hard_readonly(osb)))
-		return;
+		pr_crit("OCFS2: File system is now read-only.\n");
+		sb->s_flags |= MS_RDONLY;
+		ocfs2_set_ro_flag(osb, 0);
+	}
 
-	printk(KERN_CRIT "File system is now read-only due to the potential "
-	       "of on-disk corruption. Please run fsck.ocfs2 once the file "
-	       "system is unmounted.\n");
-	sb->s_flags |= MS_RDONLY;
-	ocfs2_set_ro_flag(osb, 0);
+	return rv;
 }
 
-void __ocfs2_error(struct super_block *sb, const char *function,
+int __ocfs2_error(struct super_block *sb, const char *function,
 		  const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -2581,7 +2606,7 @@ void __ocfs2_error(struct super_block *s
 
 	va_end(args);
 
-	ocfs2_handle_error(sb);
+	return ocfs2_handle_error(sb);
 }
 
 /* Handle critical errors. This is intentionally more drastic than
diff -puN fs/ocfs2/super.h~add-errors=continue fs/ocfs2/super.h
--- a/fs/ocfs2/super.h~add-errors=continue
+++ a/fs/ocfs2/super.h
@@ -32,7 +32,7 @@ int ocfs2_publish_get_mount_state(struct
 				  int node_num);
 
 __printf(3, 4)
-void __ocfs2_error(struct super_block *sb, const char *function,
+int __ocfs2_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
 
 #define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##args)
_
