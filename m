From: Tao Ma <tao.ma@oracle.com>
Date: Mon Dec 17 17:16:08 2007
Subject: [Ocfs2-devel] [PATCH 3/6] Abstract checking and validating process
	in tunefs.ocfs2.take 3
In-Reply-To: <47671D39.6090509@oracle.com>
Message-ID: <20071218011317.GA23447@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the main function of tunefs.ocfs2, there are a large
number of checking and validating process. They are seperated
and can be moved out of "main" so that future online resize
can skip these check easily. So add 2 new function, volume_check
and validate_parameter to organize the complicated process.

There are also 2 minor changes in this patch:
1. the print of "Adding backup superblock for the volume" are moved to
   validate process as others.
2. remove_slot_check is moved into function volume_check as it does
   the check work while it was in validate process.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 tunefs.ocfs2/tunefs.c |  267 +++++++++++++++++++++++++++----------------------
 1 files changed, 147 insertions(+), 120 deletions(-)

diff --git a/tunefs.ocfs2/tunefs.c b/tunefs.ocfs2/tunefs.c
index 207431c..cea9eb1 100644
--- a/tunefs.ocfs2/tunefs.c
+++ b/tunefs.ocfs2/tunefs.c
@@ -30,6 +30,9 @@ ocfs2_tune_opts opts;
 ocfs2_filesys *fs_gbl = NULL;
 static int cluster_locked = 0;
 static int resize = 0;
+static uint64_t def_jrnl_size = 0;
+static char old_uuid[OCFS2_VOL_UUID_LEN * 2 + 1];
+static char new_uuid[OCFS2_VOL_UUID_LEN * 2 + 1];
 
 static void usage(const char *progname)
 {
@@ -997,6 +1000,145 @@ static void free_opts(void)
 		free(opts.device);
 }
 
+static errcode_t volume_check(ocfs2_filesys *fs)
+{
+	errcode_t ret;
+	int dirty = 0;
+	uint16_t max_slots = OCFS2_RAW_SB(fs->fs_super)->s_max_slots;
+
+	ret = journal_check(fs, &dirty, &def_jrnl_size);
+	if (ret || dirty)
+		goto bail;
+
+	ret = 1;
+	if (opts.list_sparse) {
+		if (!ocfs2_sparse_alloc(OCFS2_RAW_SB(fs->fs_super))) {
+			com_err(opts.progname, 0,
+				"sparse_file flag check failed. ");
+			goto bail;
+		}
+		printf("List all the sparse files in the volume\n");
+	}
+
+	if (opts.feature_string) {
+		if (feature_check(fs)) {
+			com_err(opts.progname, 0,
+				"feature check failed. ");
+			goto bail;
+		}
+		printf("Modify feature \"%s\" for the volume\n",
+			opts.feature_string);
+	}
+
+	/* If operation requires touching the global bitmap, ensure it is good */
+	/* This is to handle failed resize */
+	if (opts.num_blocks || opts.num_slots || opts.jrnl_size ||
+	    opts.backup_super) {
+		if (global_bitmap_check(fs)) {
+			com_err(opts.progname, 0, "Global bitmap check failed. "
+				"Run fsck.ocfs2 -f <device>.");
+			goto bail;
+		}
+	}
+
+	/* check whether the block for backup superblock are used. */
+	if (opts.backup_super) {
+		if (backup_super_check(fs))
+			goto bail;
+	}
+
+	/* remove slot check. */
+	if (opts.num_slots && opts.num_slots < max_slots) {
+		ret = remove_slot_check(fs);
+		if (ret) {
+			com_err(opts.progname, 0,
+				"remove slot check failed. ");
+			goto bail;
+		}
+	}
+
+	ret = 0;
+bail:
+	return ret;
+}
+
+static void validate_parameter(ocfs2_filesys *fs)
+{
+	uint16_t max_slots = OCFS2_RAW_SB(fs->fs_super)->s_max_slots;
+	uint64_t num_clusters;
+	char *tmpstr;
+
+	/* valid backup super. */
+	if (opts.backup_super)
+		printf("Adding backup superblock for the volume\n");
+
+	/* validate volume label */
+	if (opts.vol_label) {
+		printf("Changing volume label from %s to %s\n",
+		       OCFS2_RAW_SB(fs->fs_super)->s_label, opts.vol_label);
+	}
+
+	/* validate volume uuid */
+	if (opts.vol_uuid) {
+		uuid_unparse(OCFS2_RAW_SB(fs->fs_super)->s_uuid, old_uuid);
+		uuid_unparse(opts.vol_uuid, new_uuid);
+		printf("Changing volume uuid from %s to %s\n", old_uuid, new_uuid);
+	}
+
+	/* validate mount type */
+	if (opts.mount) {
+		if (!validate_mount_change(fs)) {
+			if (opts.mount == MOUNT_LOCAL)
+				tmpstr = MOUNT_LOCAL_STR;
+			else
+				tmpstr = MOUNT_CLUSTER_STR;
+			printf("Changing mount type to %s\n", tmpstr);
+		} else
+			opts.mount = 0;
+	}
+
+	/* validate num slots */
+	max_slots = OCFS2_RAW_SB(fs->fs_super)->s_max_slots;
+	if (opts.num_slots) {
+		if (opts.num_slots > max_slots) {
+			if (!opts.jrnl_size)
+				opts.jrnl_size = def_jrnl_size;
+
+		} else if (opts.num_slots == max_slots) {
+			printf("Giving the same number of nodes. "
+				"Ignore the change of slots.");
+			opts.num_slots = 0;
+		}
+
+		if (opts.num_slots)
+			printf("Changing number of node slots from %d to %d\n",
+			       max_slots, opts.num_slots);
+	}
+
+	/* validate journal size */
+	if (opts.jrnl_size) {
+		num_clusters = (opts.jrnl_size + fs->fs_clustersize - 1) >>
+				OCFS2_RAW_SB(fs->fs_super)->s_clustersize_bits;
+
+		opts.jrnl_size = num_clusters <<
+				OCFS2_RAW_SB(fs->fs_super)->s_clustersize_bits;
+
+		if (opts.jrnl_size != def_jrnl_size)
+			printf("Changing journal size %"PRIu64" to %"PRIu64"\n",
+			       def_jrnl_size, opts.jrnl_size);
+	}
+
+	/* validate volume size */
+	if (opts.num_blocks) {
+		if (validate_vol_size(fs))
+			opts.num_blocks = 0;
+		else
+			printf("Changing volume size from %"PRIu64" blocks to "
+			       "%"PRIu64" blocks\n", fs->fs_blocks,
+			       opts.num_blocks);
+	}
+}
+
 int main(int argc, char **argv)
 {
 	errcode_t ret = 0;
@@ -1011,14 +1153,8 @@ int main(int argc, char **argv)
 	int upd_incompat = 0;
 	int upd_backup_super = 0;
 	int upd_feature = 0;
-	char *tmpstr;
 	uint16_t max_slots;
-	uint64_t def_jrnl_size = 0;
-	uint64_t num_clusters;
 	uint64_t old_blocks = 0;
-	int dirty = 0;
-	char old_uuid[OCFS2_VOL_UUID_LEN * 2 + 1];
-	char new_uuid[OCFS2_VOL_UUID_LEN * 2 + 1];
 
 	initialize_ocfs_error_table();
 	initialize_o2dl_error_table();
@@ -1116,121 +1252,11 @@ int main(int argc, char **argv)
 	 */
 	io_init_cache(fs->fs_io, ocfs2_extent_recs_per_eb(fs->fs_blocksize));
 
-	ret = journal_check(fs, &dirty, &def_jrnl_size);
-	if (ret || dirty)
-		goto unlock;
-
-	if (opts.list_sparse) {
-		if (!ocfs2_sparse_alloc(OCFS2_RAW_SB(fs->fs_super))) {
-			com_err(opts.progname, 0,
-				"sparse_file flag check failed. ");
-			goto unlock;
-		}
-		printf("List all the sparse files in the volume\n");
-	}
-
-	if (opts.feature_string) {
-		if (feature_check(fs)) {
-			com_err(opts.progname, 0,
-				"feature check failed. ");
-			goto unlock;
-		}
-		printf("Modify feature \"%s\" for the volume\n",
-			opts.feature_string);
-	}
-
-	/* If operation requires touching the global bitmap, ensure it is good */
-	/* This is to handle failed resize */
-	if (opts.num_blocks || opts.num_slots || opts.jrnl_size ||
-	    opts.backup_super) {
-		if (global_bitmap_check(fs)) {
-			com_err(opts.progname, 0, "Global bitmap check failed. "
-				"Run fsck.ocfs2 -f <device>.");
-			goto unlock;
-		}
-	}
-
-	/* check whether the block for backup superblock are used. */
-	if (opts.backup_super) {
-		if (backup_super_check(fs))
-			goto unlock;
-		else
-			printf("Adding backup superblock for the volume\n");
-	}
-
-	/* validate volume label */
-	if (opts.vol_label) {
-		printf("Changing volume label from %s to %s\n",
-		       OCFS2_RAW_SB(fs->fs_super)->s_label, opts.vol_label);
-	}
-
-	/* validate volume uuid */
-	if (opts.vol_uuid) {
-		uuid_unparse(OCFS2_RAW_SB(fs->fs_super)->s_uuid, old_uuid);
-		uuid_unparse(opts.vol_uuid, new_uuid);
-		printf("Changing volume uuid from %s to %s\n", old_uuid, new_uuid);
-	}
-
-	/* validate mount type */
-	if (opts.mount) {
-		if (!validate_mount_change(fs)) {
-			if (opts.mount == MOUNT_LOCAL)
-				tmpstr = MOUNT_LOCAL_STR;
-			else
-				tmpstr = MOUNT_CLUSTER_STR;
-			printf("Changing mount type to %s\n", tmpstr);
-		} else
-			opts.mount = 0;
-	}
-
-	/* validate num slots */
-	max_slots = OCFS2_RAW_SB(fs->fs_super)->s_max_slots;
-	if (opts.num_slots) {
-		if (opts.num_slots < max_slots) {
-			ret = remove_slot_check(fs);
-			if (ret) {
-				com_err(opts.progname, 0,
-					"remove slot check failed. ");
-				goto unlock;
-			}
-		}
-		else if (opts.num_slots > max_slots) {
-			if (!opts.jrnl_size)
-				opts.jrnl_size = def_jrnl_size;
-
-		} else {
-			printf("Giving the same number of nodes. "
-				"Ignore the change of slots.");
-			opts.num_slots = 0;
-		}
-
-		if (opts.num_slots)
-			printf("Changing number of node slots from %d to %d\n",
-			       max_slots, opts.num_slots);
-	}
-
-	/* validate journal size */
-	if (opts.jrnl_size) {
-		num_clusters = (opts.jrnl_size + fs->fs_clustersize - 1) >>
-				OCFS2_RAW_SB(fs->fs_super)->s_clustersize_bits;
-
-		opts.jrnl_size = num_clusters <<
-				OCFS2_RAW_SB(fs->fs_super)->s_clustersize_bits;
-
-		if (opts.jrnl_size != def_jrnl_size)
-			printf("Changing journal size %"PRIu64" to %"PRIu64"\n",
-			       def_jrnl_size, opts.jrnl_size);
-	}
+	ret = volume_check(fs);
+	if (ret)
+ 		goto unlock;
 
-	/* validate volume size */
-	if (opts.num_blocks) {
-		if (validate_vol_size(fs))
-			opts.num_blocks = 0;
-		else
-			printf("Changing volume size from %"PRIu64" blocks to "
-			       "%"PRIu64" blocks\n", fs->fs_blocks,
-			       opts.num_blocks);
-	}
+	validate_parameter(fs);
 
 	if (!opts.vol_label && !opts.vol_uuid && !opts.num_slots &&
 	    !opts.jrnl_size && !opts.num_blocks && !opts.mount &&
@@ -1249,6 +1275,7 @@ int main(int argc, char **argv)
 	}
 
 	/* Set resize incompat flag on superblock */
+	max_slots = OCFS2_RAW_SB(fs->fs_super)->s_max_slots;
 	if (opts.num_blocks ||
 	    (opts.num_slots && opts.num_slots < max_slots)) {
 		if (opts.num_blocks)
-- 
gitgui.0.9.0.gd794
