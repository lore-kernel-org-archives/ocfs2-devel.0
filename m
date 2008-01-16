From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:13 2008
Subject: [Ocfs2-devel] [PATCH 20/20] ocfs2: Local alloc window size
	changeable via mount option
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-21-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e5b40f9bf0821554db41fd059a403b00fec955fc
Author: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 20 Dec 2007 14:50:26 -0800

Local alloc is a performance optimiztion in ocfs2 in which a node
takes a window of bits from the global bitmap and then uses that for
all small local allocations. This window size is fixed to 8MB currently.
This patch allows users to specify the window size in MB including
disabling it by passing in 0. If the number specified is too large,
the fs will use the default value of 8MB.

mount -o localalloc=X /dev/sdX /mntpoint

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/localalloc.c |   41 +++++++++++++++++++++++++++++------------
 fs/ocfs2/ocfs2.h      |    1 +
 fs/ocfs2/ocfs2_fs.h   |    8 ++++++++
 fs/ocfs2/suballoc.c   |    5 +++--
 fs/ocfs2/super.c      |   17 +++++++++++++++++
 5 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index e29328a..84ed678 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -75,18 +75,11 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 					  struct inode *local_alloc_inode);
 
-/*
- * Determine how large our local alloc window should be, in bits.
- *
- * These values (and the behavior in ocfs2_alloc_should_use_local) have
- * been chosen so that most allocations, including new block groups go
- * through local alloc.
- */
 static inline int ocfs2_local_alloc_window_bits(struct ocfs2_super *osb)
 {
-	BUG_ON(osb->s_clustersize_bits < 12);
+	BUG_ON(osb->s_clustersize_bits > 20);
 
-	return 2048 >> (osb->s_clustersize_bits - 12);
+	return osb->local_alloc_size << (20 - osb->s_clustersize_bits);
 }
 
 /*
@@ -96,18 +89,23 @@ static inline int ocfs2_local_alloc_window_bits(struct ocfs2_super *osb)
 int ocfs2_alloc_should_use_local(struct ocfs2_super *osb, u64 bits)
 {
 	int la_bits = ocfs2_local_alloc_window_bits(osb);
+	int ret = 0;
 
 	if (osb->local_alloc_state != OCFS2_LA_ENABLED)
-		return 0;
+		goto bail;
 
 	/* la_bits should be at least twice the size (in clusters) of
 	 * a new block group. We want to be sure block group
 	 * allocations go through the local alloc, so allow an
 	 * allocation to take up to half the bitmap. */
 	if (bits > (la_bits / 2))
-		return 0;
+		goto bail;
 
-	return 1;
+	ret = 1;
+bail:
+	mlog(0, "state=%d, bits=%llu, la_bits=%d, ret=%d\n",
+	     osb->local_alloc_state, (unsigned long long)bits, la_bits, ret);
+	return ret;
 }
 
 int ocfs2_load_local_alloc(struct ocfs2_super *osb)
@@ -121,6 +119,19 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 
 	mlog_entry_void();
 
+	if (ocfs2_mount_local(osb))
+		goto bail;
+
+	if (osb->local_alloc_size == 0)
+		goto bail;
+
+	if (ocfs2_local_alloc_window_bits(osb) >= osb->bitmap_cpg) {
+		mlog(ML_NOTICE, "Requested local alloc window %d is larger "
+		     "than max possible %u. Using defaults.\n",
+		     ocfs2_local_alloc_window_bits(osb), (osb->bitmap_cpg - 1));
+		osb->local_alloc_size = OCFS2_DEFAULT_LOCAL_ALLOC_SIZE;
+	}
+
 	/* read the alloc off disk */
 	inode = ocfs2_get_system_file_inode(osb, LOCAL_ALLOC_SYSTEM_INODE,
 					    osb->slot_num);
@@ -181,6 +192,9 @@ bail:
 	if (inode)
 		iput(inode);
 
+	mlog(0, "Local alloc window bits = %d\n",
+	     ocfs2_local_alloc_window_bits(osb));
+
 	mlog_exit(status);
 	return status;
 }
@@ -508,6 +522,9 @@ bail:
 		iput(local_alloc_inode);
 	}
 
+	mlog(0, "bits=%d, slot=%d, ret=%d\n", bits_wanted, osb->slot_num,
+	     status);
+
 	mlog_exit(status);
 	return status;
 }
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 60a23e1..df27b52 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -232,6 +232,7 @@ struct ocfs2_super
 	atomic_t needs_checkpoint;
 	struct ocfs2_journal *journal;
 
+	int local_alloc_size;
 	enum ocfs2_local_alloc_state local_alloc_state;
 	struct buffer_head *local_alloc_bh;
 	u64 la_last_gd;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 6ef8767..9687b43 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -256,6 +256,14 @@ struct ocfs2_space_resv {
 /* Journal limits (in bytes) */
 #define OCFS2_MIN_JOURNAL_SIZE		(4 * 1024 * 1024)
 
+/*
+ * Default local alloc size (in megabytes)
+ *
+ * The value chosen should be such that most allocations, including new
+ * block groups, use local alloc.
+ */
+#define OCFS2_DEFAULT_LOCAL_ALLOC_SIZE	8
+
 struct ocfs2_system_inode_info {
 	char	*si_name;
 	int	si_iflags;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8f09f52..4add3ee 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1519,8 +1519,9 @@ int __ocfs2_claim_clusters(struct ocfs2_super *osb,
 		if (min_clusters > (osb->bitmap_cpg - 1)) {
 			/* The only paths asking for contiguousness
 			 * should know about this already. */
-			mlog(ML_ERROR, "minimum allocation requested exceeds "
-				       "group bitmap size!");
+			mlog(ML_ERROR, "minimum allocation requested %u exceeds "
+			     "group bitmap size %u!\n", min_clusters,
+			     osb->bitmap_cpg);
 			status = -ENOSPC;
 			goto bail;
 		}
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 39cc000..dfb14d1 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -87,6 +87,7 @@ struct mount_options
 	unsigned long	mount_opt;
 	unsigned int	atime_quantum;
 	signed short	slot;
+	unsigned int	localalloc_opt;
 };
 
 static int ocfs2_parse_options(struct super_block *sb, char *options,
@@ -154,6 +155,7 @@ enum {
 	Opt_data_writeback,
 	Opt_atime_quantum,
 	Opt_slot,
+	Opt_localalloc,
 	Opt_err,
 };
 
@@ -169,6 +171,7 @@ static match_table_t tokens = {
 	{Opt_data_writeback, "data=writeback"},
 	{Opt_atime_quantum, "atime_quantum=%u"},
 	{Opt_slot, "preferred_slot=%u"},
+	{Opt_localalloc, "localalloc=%d"},
 	{Opt_err, NULL}
 };
 
@@ -601,6 +604,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
 	osb->preferred_slot = parsed_options.slot;
+	osb->local_alloc_size = parsed_options.localalloc_opt;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -754,6 +758,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 	mopt->mount_opt = 0;
 	mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
 	mopt->slot = OCFS2_INVALID_SLOT;
+	mopt->localalloc_opt = OCFS2_DEFAULT_LOCAL_ALLOC_SIZE;
 
 	if (!options) {
 		status = 1;
@@ -820,6 +825,15 @@ static int ocfs2_parse_options(struct super_block *sb,
 			if (option)
 				mopt->slot = (s16)option;
 			break;
+		case Opt_localalloc:
+			option = 0;
+			if (match_int(&args[0], &option)) {
+				status = 0;
+				goto bail;
+			}
+			if (option >= 0 && (option <= ocfs2_local_alloc_size(sb) * 8))
+				mopt->localalloc_opt = option;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -868,6 +882,9 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (osb->s_atime_quantum != OCFS2_DEFAULT_ATIME_QUANTUM)
 		seq_printf(s, ",atime_quantum=%u", osb->s_atime_quantum);
 
+	if (osb->local_alloc_size != OCFS2_DEFAULT_LOCAL_ALLOC_SIZE)
+		seq_printf(s, ",localalloc=%d", osb->local_alloc_size);
+
 	return 0;
 }
 
-- 
1.5.3.4
