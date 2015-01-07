From: alex chen <alex.chen@huawei.com>
Date: Wed, 7 Jan 2015 12:01:41 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: add a mount option
 journal_async_commit on ocfs2 filesystem
Message-ID: <54ACAFA5.3080508@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add a mount option to support JBD2 feature:
JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT. When this feature is opened,
journal commit block can be written to disk without waiting for
descriptor blocks, which can improve journal commit performance. This
option will enable 'journal_checksum' internally.

Using the fs_mark benchmark, using journal_async_commit shows a 50%
improvement, the files per second go up from 215.2 to 317.5.

test script:
fs_mark  -d  /mnt/ocfs2/  -s  10240  -n  1000

default:
FSUse%        Count         Size    Files/sec     App Overhead
     0         1000        10240        215.2            17878

with journal_async_commit option:
FSUse%        Count         Size    Files/sec     App Overhead
     0         1000        10240        317.5            17881

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Signed-off-by: Weiwei Wang <wangww631@huawei.comm>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 Documentation/filesystems/ocfs2.txt |  4 ++++
 fs/ocfs2/ocfs2.h                    |  2 ++
 fs/ocfs2/super.c                    | 17 +++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 7618a28..28f8c08 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -100,3 +100,7 @@ coherency=full  (*)	Disallow concurrent O_DIRECT writes, cluster inode
 coherency=buffered	Allow concurrent O_DIRECT writes without EX lock among
 			nodes, which gains high performance at risk of getting
 			stale data on other nodes.
+journal_async_commit	Commit block can be written to disk without waiting
+			for descriptor blocks. If enabled older kernels cannot
+			mount the device. This will enable 'journal_checksum'
+			internally.
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 131cc1c..7e39cd6 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -284,6 +284,8 @@ enum ocfs2_mount_options
 						     writes */
 	OCFS2_MOUNT_HB_NONE = 1 << 13, /* No heartbeat */
 	OCFS2_MOUNT_HB_GLOBAL = 1 << 14, /* Global heartbeat */
+
+	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
 };

 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 04ee6d1..cdf5e28 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -191,6 +191,7 @@ enum {
 	Opt_coherency_full,
 	Opt_resv_level,
 	Opt_dir_resv_level,
+	Opt_journal_async_commit,
 	Opt_err,
 };

@@ -222,6 +223,7 @@ static const match_table_t tokens = {
 	{Opt_coherency_full, "coherency=full"},
 	{Opt_resv_level, "resv_level=%u"},
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
+	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_err, NULL}
 };

@@ -1500,6 +1502,9 @@ static int ocfs2_parse_options(struct super_block *sb,
 			    option < OCFS2_MAX_RESV_LEVEL)
 				mopt->dir_resv_level = option;
 			break;
+		case Opt_journal_async_commit:
+			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1606,6 +1611,9 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 	if (osb->osb_dir_resv_level != osb->osb_resv_level)
 		seq_printf(s, ",dir_resv_level=%d", osb->osb_resv_level);

+	if (opts & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
+		seq_printf(s, ",journal_async_commit");
+
 	return 0;
 }

@@ -2477,6 +2485,15 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 		goto finally;
 	}

+	if (osb->s_mount_opt & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
+		jbd2_journal_set_features(osb->journal->j_journal,
+				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
+				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
+	else
+		jbd2_journal_clear_features(osb->journal->j_journal,
+				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
+				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
+
 	if (dirty) {
 		/* recover my local alloc if we didn't unmount cleanly. */
 		status = ocfs2_begin_local_alloc_recovery(osb,
-- 
1.8.4.3
