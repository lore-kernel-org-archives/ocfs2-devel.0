From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Nov  7 14:43:28 2007
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Support commit= mount option
Message-ID: <20071107224326.GF28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mostly taken from ext3. This allows the user to set the jbd commit interval,
in seconds. The default of 5 seconds stays the same, but now users can
easily increase the commit interval. Typically, this would be increased in
order to benefit performance at the expense of data-safety.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Documentation/filesystems/ocfs2.txt |   11 +++++++++++
 fs/ocfs2/journal.c                  |    8 ++++++--
 fs/ocfs2/ocfs2.h                    |    1 +
 fs/ocfs2/super.c                    |   23 +++++++++++++++++++++++
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index ed55238..09ff747 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -62,3 +62,14 @@ data=writeback		Data ordering is not preserved, data may be written
 preferred_slot=0(*)	During mount, try to use this filesystem slot first. If
 			it is in use by another node, the first empty one found
 			will be chosen. Invalid values will be ignored.
+commit=nrsec	(*)	Ocfs2 can be told to sync all its data and metadata
+			every 'nrsec' seconds. The default value is 5 seconds.
+			This means that if you lose your power, you will lose
+			as much as the latest 5 seconds of work (your
+			filesystem will not be damaged though, thanks to the
+			journaling).  This default value (or any low value)
+			will hurt performance, but it's good for data-safety.
+			Setting it to 0 will have the same effect as leaving
+			it at the default (5 seconds).
+			Setting it to very large values will improve
+			performance.
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f9d01e2..d9212ac 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -304,14 +304,18 @@ int ocfs2_journal_dirty_data(handle_t *handle,
 	return err;
 }
 
-#define OCFS2_DEFAULT_COMMIT_INTERVAL 	(HZ * 5)
+#define OCFS2_DEFAULT_COMMIT_INTERVAL 	(HZ * JBD_DEFAULT_MAX_COMMIT_AGE)
 
 void ocfs2_set_journal_params(struct ocfs2_super *osb)
 {
 	journal_t *journal = osb->journal->j_journal;
+	unsigned long commit_interval = OCFS2_DEFAULT_COMMIT_INTERVAL;
+
+	if (osb->osb_commit_interval)
+		commit_interval = osb->osb_commit_interval;
 
 	spin_lock(&journal->j_state_lock);
-	journal->j_commit_interval = OCFS2_DEFAULT_COMMIT_INTERVAL;
+	journal->j_commit_interval = commit_interval;
 	if (osb->s_mount_opt & OCFS2_MOUNT_BARRIER)
 		journal->j_flags |= JFS_BARRIER;
 	else
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 60a23e1..2a9e860 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -231,6 +231,7 @@ struct ocfs2_super
 	wait_queue_head_t checkpoint_event;
 	atomic_t needs_checkpoint;
 	struct ocfs2_journal *journal;
+	unsigned long osb_commit_interval;
 
 	enum ocfs2_local_alloc_state local_alloc_state;
 	struct buffer_head *local_alloc_bh;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5ee7754..23b0e4b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -84,6 +84,7 @@ MODULE_LICENSE("GPL");
 
 struct mount_options
 {
+	unsigned long	commit_interval;
 	unsigned long	mount_opt;
 	unsigned int	atime_quantum;
 	signed short	slot;
@@ -150,6 +151,7 @@ enum {
 	Opt_data_writeback,
 	Opt_atime_quantum,
 	Opt_slot,
+	Opt_commit,
 	Opt_err,
 };
 
@@ -165,6 +167,7 @@ static match_table_t tokens = {
 	{Opt_data_writeback, "data=writeback"},
 	{Opt_atime_quantum, "atime_quantum=%u"},
 	{Opt_slot, "preferred_slot=%u"},
+	{Opt_commit, "commit=%u"},
 	{Opt_err, NULL}
 };
 
@@ -443,6 +446,8 @@ unlock_osb:
 		osb->s_mount_opt = parsed_options.mount_opt;
 		osb->s_atime_quantum = parsed_options.atime_quantum;
 		osb->preferred_slot = parsed_options.slot;
+		if (parsed_options.commit_interval)
+			osb->osb_commit_interval = parsed_options.commit_interval;
 
 		if (!ocfs2_is_hard_readonly(osb))
 			ocfs2_set_journal_params(osb);
@@ -597,6 +602,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
 	osb->preferred_slot = parsed_options.slot;
+	osb->osb_commit_interval = parsed_options.commit_interval;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -747,6 +753,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 	mlog_entry("remount: %d, options: \"%s\"\n", is_remount,
 		   options ? options : "(none)");
 
+	mopt->commit_interval = 0;
 	mopt->mount_opt = 0;
 	mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
 	mopt->slot = OCFS2_INVALID_SLOT;
@@ -816,6 +823,18 @@ static int ocfs2_parse_options(struct super_block *sb,
 			if (option)
 				mopt->slot = (s16)option;
 			break;
+		case Opt_commit:
+			option = 0;
+			if (match_int(&args[0], &option)) {
+				status = 0;
+				goto bail;
+			}
+			if (option < 0)
+				return 0;
+			if (option == 0)
+				option = JBD_DEFAULT_MAX_COMMIT_AGE;
+			mopt->commit_interval = HZ * option;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -864,6 +883,10 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (osb->s_atime_quantum != OCFS2_DEFAULT_ATIME_QUANTUM)
 		seq_printf(s, ",atime_quantum=%u", osb->s_atime_quantum);
 
+	if (osb->osb_commit_interval)
+		seq_printf(s, ",commit=%u",
+			   (unsigned) (osb->osb_commit_interval / HZ));
+
 	return 0;
 }
 
-- 
1.5.0.6
