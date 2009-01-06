From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 6 Jan 2009 15:11:41 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add statistics for the checksum and
	ecc operations.
Message-ID: <20090106231141.GA1713@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It would be nice to know how often we get checksum failures.  Even
better, how many of them we can fix with the single bit ecc.  So, we add
a statistics structure.  The structure can be installed into debugfs
wherever the user wants.

For ocfs2, we'll put it in the superblock-specific debugfs directory and
pass it down from our higher-level functions.  The stats are only
registered with debugfs when the filesystem supports metadata ecc.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/blockcheck.c |  184 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/blockcheck.h |   29 +++++++-
 fs/ocfs2/ocfs2.h      |    4 +
 fs/ocfs2/super.c      |   42 +++++++++---
 4 files changed, 240 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index 2a947c4..a1163b8 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -22,6 +22,9 @@
 #include <linux/crc32.h>
 #include <linux/buffer_head.h>
 #include <linux/bitops.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/fs.h>
 #include <asm/byteorder.h>
 
 #include <cluster/masklog.h>
@@ -222,6 +225,155 @@ void ocfs2_hamming_fix_block(void *data, unsigned int blocksize,
 	ocfs2_hamming_fix(data, blocksize * 8, 0, fix);
 }
 
+
+/*
+ * Debugfs handling.
+ */
+
+#ifdef CONFIG_DEBUG_FS
+
+static int blockcheck_u64_get(void *data, u64 *val)
+{
+	*val = *(u64 *)data;
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(blockcheck_fops, blockcheck_u64_get, NULL, "%llu\n");
+
+static struct dentry *blockcheck_debugfs_create(const char *name,
+						struct dentry *parent,
+						u64 *value)
+{
+	return debugfs_create_file(name, S_IFREG | S_IRUSR, parent, value,
+				   &blockcheck_fops);
+}
+
+static void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
+{
+	if (stats) {
+		debugfs_remove(stats->b_debug_check);
+		stats->b_debug_check = NULL;
+		debugfs_remove(stats->b_debug_failure);
+		stats->b_debug_failure = NULL;
+		debugfs_remove(stats->b_debug_recover);
+		stats->b_debug_recover = NULL;
+		debugfs_remove(stats->b_debug_dir);
+		stats->b_debug_dir = NULL;
+	}
+}
+
+static int ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
+					  struct dentry *parent)
+{
+	int rc = -EINVAL;
+
+	if (!stats)
+		goto out;
+
+	stats->b_debug_dir = debugfs_create_dir("blockcheck", parent);
+	if (!stats->b_debug_dir)
+		goto out;
+
+	stats->b_debug_check =
+		blockcheck_debugfs_create("blocks_checked",
+					  stats->b_debug_dir,
+					  &stats->b_check_count);
+
+	stats->b_debug_failure =
+		blockcheck_debugfs_create("checksums_failed",
+					  stats->b_debug_dir,
+					  &stats->b_failure_count);
+
+	stats->b_debug_recover =
+		blockcheck_debugfs_create("ecc_recoveries",
+					  stats->b_debug_dir,
+					  &stats->b_recover_count);
+	if (stats->b_debug_check && stats->b_debug_failure &&
+	    stats->b_debug_recover)
+		rc = 0;
+
+out:
+	if (rc)
+		ocfs2_blockcheck_debug_remove(stats);
+	return rc;
+}
+#else
+static inline int ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
+						 struct dentry *parent)
+{
+	return 0;
+}
+
+static inline void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
+{
+}
+#endif  /* CONFIG_DEBUG_FS */
+
+/* Always-called wrappers for starting and stopping the debugfs files */
+int ocfs2_blockcheck_stats_debugfs_install(struct ocfs2_blockcheck_stats *stats,
+					   struct dentry *parent)
+{
+	return ocfs2_blockcheck_debug_install(stats, parent);
+}
+
+void ocfs2_blockcheck_stats_debugfs_remove(struct ocfs2_blockcheck_stats *stats)
+{
+	ocfs2_blockcheck_debug_remove(stats);
+}
+
+static void ocfs2_blockcheck_inc_check(struct ocfs2_blockcheck_stats *stats)
+{
+	u64 new_count;
+
+	if (!stats)
+		return;
+
+	spin_lock(&stats->b_lock);
+	stats->b_check_count++;
+	new_count = stats->b_check_count;
+	spin_unlock(&stats->b_lock);
+
+	if (!new_count)
+		mlog(ML_NOTICE, "Block check count has wrapped\n");
+}
+
+static void ocfs2_blockcheck_inc_failure(struct ocfs2_blockcheck_stats *stats)
+{
+	u64 new_count;
+
+	if (!stats)
+		return;
+
+	spin_lock(&stats->b_lock);
+	stats->b_failure_count++;
+	new_count = stats->b_failure_count;
+	spin_unlock(&stats->b_lock);
+
+	if (!new_count)
+		mlog(ML_NOTICE, "Checksum failure count has wrapped\n");
+}
+
+static void ocfs2_blockcheck_inc_recover(struct ocfs2_blockcheck_stats *stats)
+{
+	u64 new_count;
+
+	if (!stats)
+		return;
+
+	spin_lock(&stats->b_lock);
+	stats->b_recover_count++;
+	new_count = stats->b_recover_count;
+	spin_unlock(&stats->b_lock);
+
+	if (!new_count)
+		mlog(ML_NOTICE, "ECC recovery count has wrapped\n");
+}
+
+
+
+/*
+ * These are the low-level APIs for using the ocfs2_block_check structure.
+ */
+
 /*
  * This function generates check information for a block.
  * data is the block to be checked.  bc is a pointer to the
@@ -266,12 +418,15 @@ void ocfs2_block_check_compute(void *data, size_t blocksize,
  * Again, the data passed in should be the on-disk endian.
  */
 int ocfs2_block_check_validate(void *data, size_t blocksize,
-			       struct ocfs2_block_check *bc)
+			       struct ocfs2_block_check *bc,
+			       struct ocfs2_blockcheck_stats *stats)
 {
 	int rc = 0;
 	struct ocfs2_block_check check;
 	u32 crc, ecc;
 
+	ocfs2_blockcheck_inc_check(stats);
+
 	check.bc_crc32e = le32_to_cpu(bc->bc_crc32e);
 	check.bc_ecc = le16_to_cpu(bc->bc_ecc);
 
@@ -282,6 +437,7 @@ int ocfs2_block_check_validate(void *data, size_t blocksize,
 	if (crc == check.bc_crc32e)
 		goto out;
 
+	ocfs2_blockcheck_inc_failure(stats);
 	mlog(ML_ERROR,
 	     "CRC32 failed: stored: %u, computed %u.  Applying ECC.\n",
 	     (unsigned int)check.bc_crc32e, (unsigned int)crc);
@@ -292,8 +448,10 @@ int ocfs2_block_check_validate(void *data, size_t blocksize,
 
 	/* And check the crc32 again */
 	crc = crc32_le(~0, data, blocksize);
-	if (crc == check.bc_crc32e)
+	if (crc == check.bc_crc32e) {
+		ocfs2_blockcheck_inc_recover(stats);
 		goto out;
+	}
 
 	mlog(ML_ERROR, "Fixed CRC32 failed: stored: %u, computed %u\n",
 	     (unsigned int)check.bc_crc32e, (unsigned int)crc);
@@ -366,7 +524,8 @@ void ocfs2_block_check_compute_bhs(struct buffer_head **bhs, int nr,
  * Again, the data passed in should be the on-disk endian.
  */
 int ocfs2_block_check_validate_bhs(struct buffer_head **bhs, int nr,
-				   struct ocfs2_block_check *bc)
+				   struct ocfs2_block_check *bc,
+				   struct ocfs2_blockcheck_stats *stats)
 {
 	int i, rc = 0;
 	struct ocfs2_block_check check;
@@ -377,6 +536,8 @@ int ocfs2_block_check_validate_bhs(struct buffer_head **bhs, int nr,
 	if (!nr)
 		return 0;
 
+	ocfs2_blockcheck_inc_check(stats);
+
 	check.bc_crc32e = le32_to_cpu(bc->bc_crc32e);
 	check.bc_ecc = le16_to_cpu(bc->bc_ecc);
 
@@ -388,6 +549,7 @@ int ocfs2_block_check_validate_bhs(struct buffer_head **bhs, int nr,
 	if (crc == check.bc_crc32e)
 		goto out;
 
+	ocfs2_blockcheck_inc_failure(stats);
 	mlog(ML_ERROR,
 	     "CRC32 failed: stored: %u, computed %u.  Applying ECC.\n",
 	     (unsigned int)check.bc_crc32e, (unsigned int)crc);
@@ -416,8 +578,10 @@ int ocfs2_block_check_validate_bhs(struct buffer_head **bhs, int nr,
 	/* And check the crc32 again */
 	for (i = 0, crc = ~0; i < nr; i++)
 		crc = crc32_le(crc, bhs[i]->b_data, bhs[i]->b_size);
-	if (crc == check.bc_crc32e)
+	if (crc == check.bc_crc32e) {
+		ocfs2_blockcheck_inc_recover(stats);
 		goto out;
+	}
 
 	mlog(ML_ERROR, "Fixed CRC32 failed: stored: %u, computed %u\n",
 	     (unsigned int)check.bc_crc32e, (unsigned int)crc);
@@ -448,9 +612,11 @@ int ocfs2_validate_meta_ecc(struct super_block *sb, void *data,
 			    struct ocfs2_block_check *bc)
 {
 	int rc = 0;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
 
-	if (ocfs2_meta_ecc(OCFS2_SB(sb)))
-		rc = ocfs2_block_check_validate(data, sb->s_blocksize, bc);
+	if (ocfs2_meta_ecc(osb))
+		rc = ocfs2_block_check_validate(data, sb->s_blocksize, bc,
+						&osb->osb_ecc_stats);
 
 	return rc;
 }
@@ -468,9 +634,11 @@ int ocfs2_validate_meta_ecc_bhs(struct super_block *sb,
 				struct ocfs2_block_check *bc)
 {
 	int rc = 0;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
 
-	if (ocfs2_meta_ecc(OCFS2_SB(sb)))
-		rc = ocfs2_block_check_validate_bhs(bhs, nr, bc);
+	if (ocfs2_meta_ecc(osb))
+		rc = ocfs2_block_check_validate_bhs(bhs, nr, bc,
+						    &osb->osb_ecc_stats);
 
 	return rc;
 }
diff --git a/fs/ocfs2/blockcheck.h b/fs/ocfs2/blockcheck.h
index 70ec3fe..d4b69fe 100644
--- a/fs/ocfs2/blockcheck.h
+++ b/fs/ocfs2/blockcheck.h
@@ -21,6 +21,24 @@
 #define OCFS2_BLOCKCHECK_H
 
 
+/* Count errors and error correction from blockcheck.c */
+struct ocfs2_blockcheck_stats {
+	spinlock_t b_lock;
+	u64 b_check_count;	/* Number of blocks we've checked */
+	u64 b_failure_count;	/* Number of failed checksums */
+	u64 b_recover_count;	/* Number of blocks fixed by ecc */
+
+	/*
+	 * debugfs entries, used if this is passed to
+	 * ocfs2_blockcheck_stats_debugfs_install()
+	 */
+	struct dentry *b_debug_dir;	/* Parent of the debugfs  files */
+	struct dentry *b_debug_check;	/* Exposes b_check_count */
+	struct dentry *b_debug_failure;	/* Exposes b_failure_count */
+	struct dentry *b_debug_recover;	/* Exposes b_recover_count */
+};
+
+
 /* High level block API */
 void ocfs2_compute_meta_ecc(struct super_block *sb, void *data,
 			    struct ocfs2_block_check *bc);
@@ -37,11 +55,18 @@ int ocfs2_validate_meta_ecc_bhs(struct super_block *sb,
 void ocfs2_block_check_compute(void *data, size_t blocksize,
 			       struct ocfs2_block_check *bc);
 int ocfs2_block_check_validate(void *data, size_t blocksize,
-			       struct ocfs2_block_check *bc);
+			       struct ocfs2_block_check *bc,
+			       struct ocfs2_blockcheck_stats *stats);
 void ocfs2_block_check_compute_bhs(struct buffer_head **bhs, int nr,
 				   struct ocfs2_block_check *bc);
 int ocfs2_block_check_validate_bhs(struct buffer_head **bhs, int nr,
-				   struct ocfs2_block_check *bc);
+				   struct ocfs2_block_check *bc,
+				   struct ocfs2_blockcheck_stats *stats);
+
+/* Debug Initialization */
+int ocfs2_blockcheck_stats_debugfs_install(struct ocfs2_blockcheck_stats *stats,
+					   struct dentry *parent);
+void ocfs2_blockcheck_stats_debugfs_remove(struct ocfs2_blockcheck_stats *stats);
 
 /*
  * Hamming code functions
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index ad5c24a..ba37433 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -47,6 +47,9 @@
 #include "ocfs2_fs.h"
 #include "ocfs2_lockid.h"
 
+/* For struct ocfs2_blockcheck_stats */
+#include "blockcheck.h"
+
 /* Most user visible OCFS2 inodes will have very few pieces of
  * metadata, but larger files (including bitmaps, etc) must be taken
  * into account when designing an access scheme. We allow a small
@@ -297,6 +300,7 @@ struct ocfs2_super
 	struct ocfs2_dinode *local_alloc_copy;
 	struct ocfs2_quota_recovery *quota_rec;
 
+	struct ocfs2_blockcheck_stats osb_ecc_stats;
 	struct ocfs2_alloc_stats alloc_stats;
 	char dev_str[20];		/* "major,minor" of the device */
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 43ed113..518b08a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -118,10 +118,12 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb);
 static int ocfs2_check_volume(struct ocfs2_super *osb);
 static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 			       struct buffer_head *bh,
-			       u32 sectsize);
+			       u32 sectsize,
+			       struct ocfs2_blockcheck_stats *stats);
 static int ocfs2_initialize_super(struct super_block *sb,
 				  struct buffer_head *bh,
-				  int sector_size);
+				  int sector_size,
+				  struct ocfs2_blockcheck_stats *stats);
 static int ocfs2_get_sector(struct super_block *sb,
 			    struct buffer_head **bh,
 			    int block,
@@ -539,7 +541,8 @@ out:
 
 static int ocfs2_sb_probe(struct super_block *sb,
 			  struct buffer_head **bh,
-			  int *sector_size)
+			  int *sector_size,
+			  struct ocfs2_blockcheck_stats *stats)
 {
 	int status, tmpstat;
 	struct ocfs1_vol_disk_hdr *hdr;
@@ -605,7 +608,8 @@ static int ocfs2_sb_probe(struct super_block *sb,
 			goto bail;
 		}
 		di = (struct ocfs2_dinode *) (*bh)->b_data;
-		status = ocfs2_verify_volume(di, *bh, blksize);
+		memset(stats, 0, sizeof(struct ocfs2_blockcheck_stats));
+		status = ocfs2_verify_volume(di, *bh, blksize, stats);
 		if (status >= 0)
 			goto bail;
 		brelse(*bh);
@@ -811,6 +815,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	struct ocfs2_super *osb = NULL;
 	struct buffer_head *bh = NULL;
 	char nodestr[8];
+	struct ocfs2_blockcheck_stats stats;
 
 	mlog_entry("%p, %p, %i", sb, data, silent);
 
@@ -820,13 +825,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/* probe for superblock */
-	status = ocfs2_sb_probe(sb, &bh, &sector_size);
+	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
 	if (status < 0) {
 		mlog(ML_ERROR, "superblock probe failed!\n");
 		goto read_super_error;
 	}
 
-	status = ocfs2_initialize_super(sb, bh, sector_size);
+	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
 	osb = OCFS2_SB(sb);
 	if (status < 0) {
 		mlog_errno(status);
@@ -926,6 +931,18 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		goto read_super_error;
 	}
 
+	if (ocfs2_meta_ecc(osb)) {
+		status = ocfs2_blockcheck_stats_debugfs_install(
+						&osb->osb_ecc_stats,
+						osb->osb_debug_root);
+		if (status) {
+			mlog(ML_ERROR,
+			     "Unable to create blockcheck statistics "
+			     "files\n");
+			goto read_super_error;
+		}
+	}
+
 	status = ocfs2_mount_volume(sb);
 	if (osb->root_inode)
 		inode = igrab(osb->root_inode);
@@ -1656,6 +1673,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	if (osb->cconn)
 		ocfs2_dlm_shutdown(osb, hangup_needed);
 
+	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove(osb->osb_debug_root);
 
 	if (hangup_needed)
@@ -1703,7 +1721,8 @@ static int ocfs2_setup_osb_uuid(struct ocfs2_super *osb, const unsigned char *uu
 
 static int ocfs2_initialize_super(struct super_block *sb,
 				  struct buffer_head *bh,
-				  int sector_size)
+				  int sector_size,
+				  struct ocfs2_blockcheck_stats *stats)
 {
 	int status;
 	int i, cbits, bbits;
@@ -1755,6 +1774,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	atomic_set(&osb->alloc_stats.bg_allocs, 0);
 	atomic_set(&osb->alloc_stats.bg_extends, 0);
 
+	/* Copy the blockcheck stats from the superblock probe */
+	osb->osb_ecc_stats = *stats;
+
 	ocfs2_init_node_maps(osb);
 
 	snprintf(osb->dev_str, sizeof(osb->dev_str), "%u,%u",
@@ -1982,7 +2004,8 @@ bail:
  */
 static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 			       struct buffer_head *bh,
-			       u32 blksz)
+			       u32 blksz,
+			       struct ocfs2_blockcheck_stats *stats)
 {
 	int status = -EAGAIN;
 
@@ -1995,7 +2018,8 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 		    OCFS2_FEATURE_INCOMPAT_META_ECC) {
 			status = ocfs2_block_check_validate(bh->b_data,
 							    bh->b_size,
-							    &di->i_check);
+							    &di->i_check,
+							    stats);
 			if (status)
 				goto out;
 		}
-- 
1.5.6.5


-- 

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
