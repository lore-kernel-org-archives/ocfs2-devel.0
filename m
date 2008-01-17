From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:36:39 2008
Subject: [Ocfs2-devel] [PATCH 16/30] ocfs2: Support commit= mount option
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-17-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

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
index e78abdc..b63bd2d 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -61,3 +61,14 @@ data=writeback		Data ordering is not preserved, data may be written
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
index 4f440a8..8b9ce2a 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -313,14 +313,18 @@ int ocfs2_journal_dirty_data(handle_t *handle,
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
index f8f8661..82802f5 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -229,6 +229,7 @@ struct ocfs2_super
 	wait_queue_head_t checkpoint_event;
 	atomic_t needs_checkpoint;
 	struct ocfs2_journal *journal;
+	unsigned long osb_commit_interval;
 
 	enum ocfs2_local_alloc_state local_alloc_state;
 	struct buffer_head *local_alloc_bh;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 479ac50..8044ed9 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -83,6 +83,7 @@ MODULE_LICENSE("GPL");
 
 struct mount_options
 {
+	unsigned long	commit_interval;
 	unsigned long	mount_opt;
 	unsigned int	atime_quantum;
 	signed short	slot;
@@ -149,6 +150,7 @@ enum {
 	Opt_data_writeback,
 	Opt_atime_quantum,
 	Opt_slot,
+	Opt_commit,
 	Opt_err,
 };
 
@@ -164,6 +166,7 @@ static match_table_t tokens = {
 	{Opt_data_writeback, "data=writeback"},
 	{Opt_atime_quantum, "atime_quantum=%u"},
 	{Opt_slot, "preferred_slot=%u"},
+	{Opt_commit, "commit=%u"},
 	{Opt_err, NULL}
 };
 
@@ -442,6 +445,8 @@ unlock_osb:
 		osb->s_mount_opt = parsed_options.mount_opt;
 		osb->s_atime_quantum = parsed_options.atime_quantum;
 		osb->preferred_slot = parsed_options.slot;
+		if (parsed_options.commit_interval)
+			osb->osb_commit_interval = parsed_options.commit_interval;
 
 		if (!ocfs2_is_hard_readonly(osb))
 			ocfs2_set_journal_params(osb);
@@ -596,6 +601,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
 	osb->preferred_slot = parsed_options.slot;
+	osb->osb_commit_interval = parsed_options.commit_interval;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -746,6 +752,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 	mlog_entry("remount: %d, options: \"%s\"\n", is_remount,
 		   options ? options : "(none)");
 
+	mopt->commit_interval = 0;
 	mopt->mount_opt = 0;
 	mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
 	mopt->slot = OCFS2_INVALID_SLOT;
@@ -815,6 +822,18 @@ static int ocfs2_parse_options(struct super_block *sb,
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
@@ -863,6 +882,10 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (osb->s_atime_quantum != OCFS2_DEFAULT_ATIME_QUANTUM)
 		seq_printf(s, ",atime_quantum=%u", osb->s_atime_quantum);
 
+	if (osb->osb_commit_interval)
+		seq_printf(s, ",commit=%u",
+			   (unsigned) (osb->osb_commit_interval / HZ));
+
 	return 0;
 }
 
-- 
1.5.3.6
