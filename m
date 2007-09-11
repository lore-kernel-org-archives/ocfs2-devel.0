From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Sep 11 15:32:23 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20070911223219.GA21356@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

This includes a small doc update, which I missed earlier. It doesn't change
any code. The other three patches are real fixes.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 Documentation/filesystems/ocfs2.txt |   13 ++++--
 fs/Kconfig                          |    3 -
 fs/ocfs2/alloc.c                    |    1 
 fs/ocfs2/aops.c                     |    4 +-
 fs/ocfs2/file.c                     |    1 
 fs/ocfs2/super.c                    |   69 +++++++++++++++++++-----------------
 6 files changed, 50 insertions(+), 41 deletions(-)

Mark Fasheh (2):
      ocfs2: update docs for new features
      ocfs2: Fix calculation of i_blocks during truncate

Tiger Yang (1):
      ocfs2: fix mount option parsing

tao.ma@oracle.com (1):
      ocfs2: Fix a wrong cluster calculation.

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 8ccf0c1..ed55238 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -28,11 +28,7 @@ Manish Singh  <manish.singh@oracle.com>
 Caveats
 =======
 Features which OCFS2 does not support yet:
-	- sparse files
 	- extended attributes
-	- shared writable mmap
-	- loopback is supported, but data written will not
-	  be cluster coherent.
 	- quotas
 	- cluster aware flock
 	- cluster aware lockf
@@ -57,3 +53,12 @@ nointr			Do not allow signals to interrupt cluster
 atime_quantum=60(*)	OCFS2 will not update atime unless this number
 			of seconds has passed since the last update.
 			Set to zero to always update atime.
+data=ordered	(*)	All data are forced directly out to the main file
+			system prior to its metadata being committed to the
+			journal.
+data=writeback		Data ordering is not preserved, data may be written
+			into the main file system after its metadata has been
+			committed to the journal.
+preferred_slot=0(*)	During mount, try to use this filesystem slot first. If
+			it is in use by another node, the first empty one found
+			will be chosen. Invalid values will be ignored.
diff --git a/fs/Kconfig b/fs/Kconfig
index 58a0650..f9eed6d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -441,9 +441,6 @@ config OCFS2_FS
 
 	  Note: Features which OCFS2 does not support yet:
 	          - extended attributes
-		  - shared writeable mmap
-	          - loopback is supported, but data written will not
-	            be cluster coherent.
 	          - quotas
 	          - cluster aware flock
 	          - Directory change notification (F_NOTIFY)
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4f51766..778a850 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5602,6 +5602,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 				      clusters_to_del;
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 	le32_add_cpu(&fe->i_clusters, -clusters_to_del);
+	inode->i_blocks = ocfs2_inode_sector_count(inode);
 
 	status = ocfs2_trim_tree(inode, path, handle, tc,
 				 clusters_to_del, &delete_blk);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 460d440..50cd8a2 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -855,6 +855,7 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 				  struct ocfs2_super *osb, loff_t pos,
 				  unsigned len, struct buffer_head *di_bh)
 {
+	u32 cend;
 	struct ocfs2_write_ctxt *wc;
 
 	wc = kzalloc(sizeof(struct ocfs2_write_ctxt), GFP_NOFS);
@@ -862,7 +863,8 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 		return -ENOMEM;
 
 	wc->w_cpos = pos >> osb->s_clustersize_bits;
-	wc->w_clen = ocfs2_clusters_for_bytes(osb->sb, len);
+	cend = (pos + len - 1) >> osb->s_clustersize_bits;
+	wc->w_clen = cend - wc->w_cpos + 1;
 	get_bh(di_bh);
 	wc->w_di_bh = di_bh;
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4ffa715..7e34e66 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -314,7 +314,6 @@ static int ocfs2_orphan_for_truncate(struct ocfs2_super *osb,
 	}
 
 	i_size_write(inode, new_i_size);
-	inode->i_blocks = ocfs2_align_bytes_to_sectors(new_i_size);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 
 	di = (struct ocfs2_dinode *) fe_bh->b_data;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f2fc9a7..c034b51 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -81,8 +81,15 @@ static struct dentry *ocfs2_debugfs_root = NULL;
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
 
+struct mount_options
+{
+	unsigned long	mount_opt;
+	unsigned int	atime_quantum;
+	signed short	slot;
+};
+
 static int ocfs2_parse_options(struct super_block *sb, char *options,
-			       unsigned long *mount_opt, s16 *slot,
+			       struct mount_options *mopt,
 			       int is_remount);
 static void ocfs2_put_super(struct super_block *sb);
 static int ocfs2_mount_volume(struct super_block *sb);
@@ -367,24 +374,23 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 {
 	int incompat_features;
 	int ret = 0;
-	unsigned long parsed_options;
-	s16 slot;
+	struct mount_options parsed_options;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
-	if (!ocfs2_parse_options(sb, data, &parsed_options, &slot, 1)) {
+	if (!ocfs2_parse_options(sb, data, &parsed_options, 1)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if ((osb->s_mount_opt & OCFS2_MOUNT_HB_LOCAL) !=
-	    (parsed_options & OCFS2_MOUNT_HB_LOCAL)) {
+	    (parsed_options.mount_opt & OCFS2_MOUNT_HB_LOCAL)) {
 		ret = -EINVAL;
 		mlog(ML_ERROR, "Cannot change heartbeat mode on remount\n");
 		goto out;
 	}
 
 	if ((osb->s_mount_opt & OCFS2_MOUNT_DATA_WRITEBACK) !=
-	    (parsed_options & OCFS2_MOUNT_DATA_WRITEBACK)) {
+	    (parsed_options.mount_opt & OCFS2_MOUNT_DATA_WRITEBACK)) {
 		ret = -EINVAL;
 		mlog(ML_ERROR, "Cannot change data mode on remount\n");
 		goto out;
@@ -435,7 +441,9 @@ unlock_osb:
 
 		/* Only save off the new mount options in case of a successful
 		 * remount. */
-		osb->s_mount_opt = parsed_options;
+		osb->s_mount_opt = parsed_options.mount_opt;
+		osb->s_atime_quantum = parsed_options.atime_quantum;
+		osb->preferred_slot = parsed_options.slot;
 	}
 out:
 	return ret;
@@ -547,8 +555,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct dentry *root;
 	int status, sector_size;
-	unsigned long parsed_opt;
-	s16 slot;
+	struct mount_options parsed_options;
 	struct inode *inode = NULL;
 	struct ocfs2_super *osb = NULL;
 	struct buffer_head *bh = NULL;
@@ -556,14 +563,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	mlog_entry("%p, %p, %i", sb, data, silent);
 
-	if (!ocfs2_parse_options(sb, data, &parsed_opt, &slot, 0)) {
+	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
 		status = -EINVAL;
 		goto read_super_error;
 	}
 
 	/* for now we only have one cluster/node, make sure we see it
 	 * in the heartbeat universe */
-	if (parsed_opt & OCFS2_MOUNT_HB_LOCAL) {
+	if (parsed_options.mount_opt & OCFS2_MOUNT_HB_LOCAL) {
 		if (!o2hb_check_local_node_heartbeating()) {
 			status = -EINVAL;
 			goto read_super_error;
@@ -585,8 +592,9 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	brelse(bh);
 	bh = NULL;
-	osb->s_mount_opt = parsed_opt;
-	osb->preferred_slot = slot;
+	osb->s_mount_opt = parsed_options.mount_opt;
+	osb->s_atime_quantum = parsed_options.atime_quantum;
+	osb->preferred_slot = parsed_options.slot;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -728,8 +736,7 @@ static struct file_system_type ocfs2_fs_type = {
 
 static int ocfs2_parse_options(struct super_block *sb,
 			       char *options,
-			       unsigned long *mount_opt,
-			       s16 *slot,
+			       struct mount_options *mopt,
 			       int is_remount)
 {
 	int status;
@@ -738,8 +745,9 @@ static int ocfs2_parse_options(struct super_block *sb,
 	mlog_entry("remount: %d, options: \"%s\"\n", is_remount,
 		   options ? options : "(none)");
 
-	*mount_opt = 0;
-	*slot = OCFS2_INVALID_SLOT;
+	mopt->mount_opt = 0;
+	mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
+	mopt->slot = OCFS2_INVALID_SLOT;
 
 	if (!options) {
 		status = 1;
@@ -749,7 +757,6 @@ static int ocfs2_parse_options(struct super_block *sb,
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token, option;
 		substring_t args[MAX_OPT_ARGS];
-		struct ocfs2_super * osb = OCFS2_SB(sb);
 
 		if (!*p)
 			continue;
@@ -757,10 +764,10 @@ static int ocfs2_parse_options(struct super_block *sb,
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_hb_local:
-			*mount_opt |= OCFS2_MOUNT_HB_LOCAL;
+			mopt->mount_opt |= OCFS2_MOUNT_HB_LOCAL;
 			break;
 		case Opt_hb_none:
-			*mount_opt &= ~OCFS2_MOUNT_HB_LOCAL;
+			mopt->mount_opt &= ~OCFS2_MOUNT_HB_LOCAL;
 			break;
 		case Opt_barrier:
 			if (match_int(&args[0], &option)) {
@@ -768,27 +775,27 @@ static int ocfs2_parse_options(struct super_block *sb,
 				goto bail;
 			}
 			if (option)
-				*mount_opt |= OCFS2_MOUNT_BARRIER;
+				mopt->mount_opt |= OCFS2_MOUNT_BARRIER;
 			else
-				*mount_opt &= ~OCFS2_MOUNT_BARRIER;
+				mopt->mount_opt &= ~OCFS2_MOUNT_BARRIER;
 			break;
 		case Opt_intr:
-			*mount_opt &= ~OCFS2_MOUNT_NOINTR;
+			mopt->mount_opt &= ~OCFS2_MOUNT_NOINTR;
 			break;
 		case Opt_nointr:
-			*mount_opt |= OCFS2_MOUNT_NOINTR;
+			mopt->mount_opt |= OCFS2_MOUNT_NOINTR;
 			break;
 		case Opt_err_panic:
-			*mount_opt |= OCFS2_MOUNT_ERRORS_PANIC;
+			mopt->mount_opt |= OCFS2_MOUNT_ERRORS_PANIC;
 			break;
 		case Opt_err_ro:
-			*mount_opt &= ~OCFS2_MOUNT_ERRORS_PANIC;
+			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_PANIC;
 			break;
 		case Opt_data_ordered:
-			*mount_opt &= ~OCFS2_MOUNT_DATA_WRITEBACK;
+			mopt->mount_opt &= ~OCFS2_MOUNT_DATA_WRITEBACK;
 			break;
 		case Opt_data_writeback:
-			*mount_opt |= OCFS2_MOUNT_DATA_WRITEBACK;
+			mopt->mount_opt |= OCFS2_MOUNT_DATA_WRITEBACK;
 			break;
 		case Opt_atime_quantum:
 			if (match_int(&args[0], &option)) {
@@ -796,9 +803,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 				goto bail;
 			}
 			if (option >= 0)
-				osb->s_atime_quantum = option;
-			else
-				osb->s_atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
+				mopt->atime_quantum = option;
 			break;
 		case Opt_slot:
 			option = 0;
@@ -807,7 +812,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 				goto bail;
 			}
 			if (option)
-				*slot = (s16)option;
+				mopt->slot = (s16)option;
 			break;
 		default:
 			mlog(ML_ERROR,
