From: Tao Ma <tao.ma@oracle.com>
Date: Mon Dec 17 17:18:10 2007
Subject: [Ocfs2-devel] [PATCH 6/6] Add online resize support in
	tunefs.ocfs2.take 3
In-Reply-To: <47671D39.6090509@oracle.com>
Message-ID: <20071218011434.GA23488@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

User can do offline resize using tunefs.ocfs2 when a volume isn't
mounted. Now the support for online resize is added.

Please note that the node where online resize goes must already
has the volume mounted. We don't mount it behind the user and the
operation would fail if we find it isn't mounted. As for other
nodes, we don't care whether the volume is mounted or not.

global_bitmap, super block and all the backups will be updated
in the kernel. And if super block or backup's update fails, we
just output some error message in dmesg and continue the work.

The whole process is derived from ext3 and divided into 2 steps:
1. OCFS2_IOC_GROUP_EXTEND: We will extend the last group first
   if it isn't full. All the work is done in kernel.
2. For every new group,  call OCFS2_IOC_GROUP_ADD to add them
   one by one. We initialize the new group descriptor in userspace,
   and let the kernel update the global_bitap etc.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 libocfs2/include/ocfs2_fs.h |   14 ++
 tunefs.ocfs2/resize.c       |  277 ++++++++++++++++++++++++++++++++++++++-----
 tunefs.ocfs2/tunefs.c       |   53 ++++++++-
 tunefs.ocfs2/tunefs.h       |    6 +-
 4 files changed, 314 insertions(+), 36 deletions(-)

diff --git a/libocfs2/include/ocfs2_fs.h b/libocfs2/include/ocfs2_fs.h
index cfaf28f..9d3b307 100644
--- a/libocfs2/include/ocfs2_fs.h
+++ b/libocfs2/include/ocfs2_fs.h
@@ -230,6 +230,20 @@ struct ocfs2_space_resv {
 #define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
 #define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
 
+/* Used to pass group descriptor data when online resize is done */
+struct ocfs2_new_group_input {
+	__u64 group;		/* Group descriptor's blkno. */
+	__u32 clusters;		/* Total number of clusters in this group */
+	__u32 frees;		/* Total free number of clusters in this group */
+	__u16 chain;		/* Chain for this group */
+	__u16 reserved1;
+	__u32 reserved2;
+};
+
+#define OCFS2_IOC_GROUP_EXTEND	_IOW('o', 1, int)
+#define OCFS2_IOC_GROUP_ADD	_IOW('o', 2,struct ocfs2_new_group_input)
+#define OCFS2_IOC_GROUP_ADD64	_IOW('o', 3,struct ocfs2_new_group_input)
+
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
  */
diff --git a/tunefs.ocfs2/resize.c b/tunefs.ocfs2/resize.c
index 0466d60..bdbcbb7 100644
--- a/tunefs.ocfs2/resize.c
+++ b/tunefs.ocfs2/resize.c
@@ -22,10 +22,75 @@
  *
  */
 
+#include <limits.h>		/* for PATH_MAX */
+#ifndef PATH_MAX
+#define PATH_MAX 8192
+#endif
+
+#include <sys/ioctl.h>
+#include <errno.h>
 #include <tunefs.h>
 
 extern ocfs2_tune_opts opts;
 
+/*
+ * This lock name is specific and only used in online resize;
+ */
+static char lock_name[OCFS2_LOCK_ID_MAX_LEN] = "tunefs-online-resize-lock";
+static char mnt_dir[PATH_MAX];
+static int fd = -1;
+
+errcode_t online_resize_lock(ocfs2_filesys *fs)
+{
+	return o2dlm_lock(fs->fs_dlm_ctxt, lock_name,
+			  O2DLM_LEVEL_EXMODE, O2DLM_TRYLOCK);
+}
+
+errcode_t online_resize_unlock(ocfs2_filesys *fs)
+{
+	return o2dlm_unlock(fs->fs_dlm_ctxt, lock_name);
+}
+
+static errcode_t find_mount_point(char *device)
+{
+	int mount_flags = 0;
+	errcode_t ret;
+
+	memset(mnt_dir, 0, sizeof(mnt_dir));
+
+	ret = ocfs2_check_mount_point(device, &mount_flags,
+				      mnt_dir, sizeof(mnt_dir));
+	if (ret)
+		goto out;
+
+	if (!(mount_flags & OCFS2_MF_MOUNTED) ||
+	    (mount_flags & OCFS2_MF_READONLY) ||
+	    (mount_flags & OCFS2_MF_SWAP)) {
+		ret = OCFS2_ET_BAD_DEVICE_NAME;
+		goto out;
+	}
+
+	ret = 0;
+out:
+	return ret;
+}
+
+errcode_t online_resize_check(ocfs2_filesys *fs)
+{
+	/*
+	 * we don't allow online resize to be coexist with other tunefs
+	 * options to keep things simple.
+	 */
+	if (opts.backup_super || opts.vol_label || opts.num_slots ||
+	     opts.mount || opts.jrnl_size) {
+		com_err(opts.progname, 0, "Cannot do online-resize"
+			" along with other tasks");
+		exit(1);
+	}
+
+	return find_mount_point(opts.device);
+}
+
 void get_vol_size(ocfs2_filesys *fs)
 {
 	errcode_t ret = 0;
@@ -85,6 +150,117 @@ int validate_vol_size(ocfs2_filesys *fs)
 	return 0;
 }
 
+static inline errcode_t online_last_group_extend(uint32_t *new_clusters)
+{
+	return ioctl(fd, OCFS2_IOC_GROUP_EXTEND, new_clusters);
+}
+
+static inline errcode_t online_add_new_group(struct ocfs2_new_group_input *input)
+{
+	return ioctl(fd, OCFS2_IOC_GROUP_ADD, input);
+}
+
+static inline errcode_t reserve_cluster(ocfs2_filesys *fs,
+					uint16_t cl_cpg,
+					uint32_t cluster,
+					struct ocfs2_group_desc *gd)
+{
+	errcode_t ret = 0;
+	char *bitmap = gd->bg_bitmap;
+
+	ret = ocfs2_set_bit(cluster % cl_cpg, bitmap);
+	if (ret != 0) {
+		com_err(opts.progname, 0, "while allocating backup superblock"
+			"in cluster %u during volume resize", cluster);
+		goto out;
+	}
+
+	gd->bg_free_bits_count--;
+out:
+	return ret;
+}
+
+/* Reserve the backup superblocks which exist in the new added groups. */
+static errcode_t reserve_backup_in_group(ocfs2_filesys *fs,
+					 struct ocfs2_dinode *di,
+					 struct ocfs2_group_desc *gd,
+					 uint16_t *backups)
+{
+	errcode_t ret = 0;
+	int numsb, i;
+	uint64_t blkno, gd_blkno = gd->bg_blkno;
+	uint64_t blocks[OCFS2_MAX_BACKUP_SUPERBLOCKS];
+	uint16_t cl_cpg = di->id2.i_chain.cl_cpg;
+	uint32_t cluster;
+
+	*backups = 0;
+
+	if (!OCFS2_HAS_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super),
+				      OCFS2_FEATURE_COMPAT_BACKUP_SB))
+		goto out;
+
+	numsb = ocfs2_get_backup_super_offset(fs, blocks, ARRAY_SIZE(blocks));
+	if (numsb <= 0)
+		goto out;
+
+	for (i = 0; i < numsb; i++) {
+		cluster = ocfs2_blocks_to_clusters(fs, blocks[i]);
+		blkno = ocfs2_which_cluster_group(fs, cl_cpg, cluster);
+		if (blkno < gd_blkno)
+			continue;
+		else if (blkno > gd_blkno)
+			break;
+
+		ret = reserve_cluster(fs, cl_cpg, cluster, gd);
+		if (ret)
+			goto out;
+		(*backups)++;
+	}
+
+out:
+	return ret;
+}
+
+static errcode_t online_resize_group_add(ocfs2_filesys *fs,
+					 struct ocfs2_dinode *di,
+					 uint64_t gd_blkno,
+					 char *gd_buf,
+					 uint16_t chain,
+					 uint32_t new_clusters)
+{
+	errcode_t ret;
+	uint16_t backups = 0, cl_bpc = di->id2.i_chain.cl_bpc;
+	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)gd_buf;
+	struct ocfs2_new_group_input input;
+
+	ret = reserve_backup_in_group(fs, di, gd, &backups);
+	if (ret)
+		goto out;
+
+	ret = ocfs2_write_group_desc(fs, gd_blkno, gd_buf);
+	if (ret)
+		goto out;
+
+	/*
+ 	 * Initialize the input data and call online resize procedure.
+ 	 * free clusters is calculated accordingly and checked in the kernel.
+ 	 */
+	memset(&input, 0, sizeof(input));
+
+	input.group = gd_blkno;
+	input.clusters = new_clusters;
+	input.chain = chain;
+	input.frees = gd->bg_bits/cl_bpc - 1 - backups;
+
+	ret = online_add_new_group(&input);
+	if (ret)
+		com_err(opts.progname, ret, "whiling add a new group % "PRIu64
+			"at chain[%u] which has %u clusters.",
+			gd_blkno, chain, new_clusters);
+out:
+	return ret;
+}
+
 /*
  * Initalize the group descriptors in the new added cluster range.
  *
@@ -101,7 +277,8 @@ static errcode_t init_new_gd(ocfs2_filesys *fs,
 			     uint32_t num_new_clusters,
 			     uint16_t chain,
 			     uint32_t *total_bits,
-			     uint32_t *used_bits)
+			     uint32_t *used_bits,
+			     int online)
 {
 	errcode_t ret = 0;
 	uint32_t cluster_chunk;
@@ -174,13 +351,26 @@ static errcode_t init_new_gd(ocfs2_filesys *fs,
 			goto bail;
 		}
 
-		/* write a new group descriptor */
-		ret = ocfs2_write_group_desc(fs, gd_blkno, gd_buf);
-		if (ret) {
-			com_err(opts.progname, ret, "while writing group "
-				"descriptor at block %"PRIu64" during "
-				"volume resize", gd_blkno);
-			goto bail;
+		if (online) {
+			ret = online_resize_group_add(fs, di, gd_blkno, gd_buf,
+						      chain, cluster_chunk);
+			if (ret) {
+				com_err(opts.progname, ret,
+					"while add a new group at "
+					"block %"PRIu64" during "
+					"volume online resize", gd_blkno);
+				goto bail;
+			}
+		} else {
+			/* write a new group descriptor */
+			ret = ocfs2_write_group_desc(fs, gd_blkno, gd_buf);
+			if (ret) {
+				com_err(opts.progname, ret,
+					"while writing group descriptor at "
+					"block %"PRIu64" during "
+					"volume resize", gd_blkno);
+				goto bail;
+			}
 		}
 	}
 
@@ -224,7 +414,7 @@ bail:
 	return ret;
 }
 
-errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
+errcode_t update_volume_size(ocfs2_filesys *fs, int *changed, int online)
 {
 	errcode_t ret = 0;
 	struct ocfs2_dinode *di;
@@ -242,7 +432,16 @@ errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 	uint32_t used_bits;
 	uint32_t total_bits;
 	uint32_t num_bits;
-	int flush_lgd = 0;
+	int flush_lgd = 0, i = 0, new_clusters;
+
+	if (online) {
+		fd = open(mnt_dir, O_RDONLY);
+		if (fd < 0) {
+			com_err(opts.progname, errno,
+				"while opening mounted dir %s.\n", mnt_dir);
+			return errno;
+		}
+	}
 
 	ret = ocfs2_malloc_block(fs->fs_io, &in_buf);
 	if (ret) {
@@ -277,9 +476,6 @@ errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 	di = (struct ocfs2_dinode *)in_buf;
 	cl = &(di->id2.i_chain);
 
-	total_bits = di->id1.bitmap1.i_total;
-	used_bits = di->id1.bitmap1.i_used;
-
 	first_new_cluster = di->i_clusters;
 	save_new_clusters = num_new_clusters =
 		ocfs2_blocks_to_clusters(fs, opts.num_blocks) - di->i_clusters;
@@ -304,7 +500,12 @@ errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 
 	chain = gd->bg_chain;
 
-	/* If possible round off the last group to cpg */
+	/*
+	 * If possible round off the last group to cpg.
+	 *
+	 * For online resize, it is proceeded as offline resize,
+	 * but the update of the group will be done by kernel.
+	 */
 	cluster_chunk = MIN(num_new_clusters,
 			    (cl->cl_cpg - (gd->bg_bits/cl->cl_bpc)));
 	if (cluster_chunk) {
@@ -328,27 +529,45 @@ errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 		/* This cluster group block is written after the new */
 		/* cluster groups are written to disk */
 		flush_lgd = 1;
+
+		if (online) {
+			new_clusters = cluster_chunk;
+			ret = online_last_group_extend(&new_clusters);
+			if (ret < 0) {
+				com_err(opts.progname, errno, "while adding %u "
+					"more clusters in the last group",
+					cluster_chunk);
+				goto bail;
+			}
+		}
 	}
 
-	/* Init the new groups and write to disk */
-	/* Add these groups one by one starting from the first chain after */
-	/* the one containing the last group */
-	ret = init_new_gd(fs, di, first_new_cluster,
-			  num_new_clusters, chain, &total_bits, &used_bits);
-	if (ret)
-		goto bail;
+	/*
+	 * Init the new groups and write to disk
+	 * Add these groups one by one starting from the first chain after
+	 * the one containing the last group.
+	 */
+	if (num_new_clusters) {
+		ret = init_new_gd(fs, di, first_new_cluster,
+				  num_new_clusters, chain,
+				  &total_bits, &used_bits, online);
+		if (ret)
+			goto bail;
+	}
 
-	di->id1.bitmap1.i_total = total_bits;
-	di->id1.bitmap1.i_used = used_bits;
+	if (!online) {
+		di->id1.bitmap1.i_total = total_bits;
+		di->id1.bitmap1.i_used = used_bits;
 
-	di->i_clusters += save_new_clusters;
-	di->i_size = (uint64_t) di->i_clusters * fs->fs_clustersize;
+		di->i_clusters += save_new_clusters;
+		di->i_size = (uint64_t) di->i_clusters * fs->fs_clustersize;
 
-	fs->fs_super->i_clusters = di->i_clusters;
+		fs->fs_super->i_clusters = di->i_clusters;
 
-	ret = update_global_bitmap(fs, di, gd, flush_lgd);
-	if (ret)
-		goto bail;
+		ret = update_global_bitmap(fs, di, gd, flush_lgd);
+		if (ret)
+			goto bail;
+	}
 
 	*changed = 1;
 
diff --git a/tunefs.ocfs2/tunefs.c b/tunefs.ocfs2/tunefs.c
index cea9eb1..e9fcee2 100644
--- a/tunefs.ocfs2/tunefs.c
+++ b/tunefs.ocfs2/tunefs.c
@@ -30,6 +30,7 @@ ocfs2_tune_opts opts;
 ocfs2_filesys *fs_gbl = NULL;
 static int cluster_locked = 0;
 static int resize = 0;
+static int online_resize = 0;
 static uint64_t def_jrnl_size = 0;
 static char old_uuid[OCFS2_VOL_UUID_LEN * 2 + 1];
 static char new_uuid[OCFS2_VOL_UUID_LEN * 2 + 1];
@@ -1006,6 +1007,17 @@ static errcode_t volume_check(ocfs2_filesys *fs)
 	int dirty = 0;
 	uint16_t max_slots = OCFS2_RAW_SB(fs->fs_super)->s_max_slots;
 
+	/*
+	 * online_resize can't coexist with other tasks, and it does't
+	 * need other checks, so we just do the check and return.
+	 */
+	if (online_resize) {
+		ret = online_resize_check(fs);
+		if (ret)
+			com_err(opts.progname, 0, "online resize check failed.");
+		goto bail;
+	}
+
 	ret = journal_check(fs, &dirty, &def_jrnl_size);
 	if (ret || dirty)
 		goto bail;
@@ -1235,13 +1247,19 @@ int main(int argc, char **argv)
 
 		block_signals(SIG_BLOCK);
 		ret = ocfs2_lock_down_cluster(fs);
-		if (ret) {
-			block_signals(SIG_UNBLOCK);
+		block_signals(SIG_UNBLOCK);
+		if (!ret)
+			cluster_locked = 1;
+		else if (ret == O2DLM_ET_TRYLOCK_FAILED && resize) {
+			/*
+			 * We just set the flag here and more check and
+			 * lock will be done later.
+			 */
+			online_resize = 1;
+		} else {
 			com_err(opts.progname, ret, "while locking down the cluster");
 			goto close;
 		}
-		cluster_locked = 1;
-		block_signals(SIG_UNBLOCK);
 	}
 
 	/*
@@ -1274,6 +1292,27 @@ int main(int argc, char **argv)
 		}
 	}
 
+	/*
+	 * We handle online resize seperately here, since it is
+	 * not like tunefs operations.
+	 */
+	if (online_resize) {
+		ret = online_resize_lock(fs);
+		if (ret)
+			goto close;
+
+		ret = update_volume_size(fs, &upd_blocks, 1);
+		if (ret) {
+			com_err(opts.progname, ret,
+				"while updating volume size");
+			goto online_resize_unlock;
+		}
+		if (upd_blocks)
+			printf("Resized volume\n");
+
+		goto online_resize_unlock;
+	}
+
 	/* Set resize incompat flag on superblock */
 	max_slots = OCFS2_RAW_SB(fs->fs_super)->s_max_slots;
 	if (opts.num_blocks ||
@@ -1352,7 +1391,7 @@ int main(int argc, char **argv)
 	/* update volume size */
 	if (opts.num_blocks) {
 		old_blocks = fs->fs_blocks;
-		ret = update_volume_size(fs, &upd_blocks);
+		ret = update_volume_size(fs, &upd_blocks, 0);
 		if (ret) {
 			com_err(opts.progname, ret,
 				"while updating volume size");
@@ -1450,7 +1489,9 @@ int main(int argc, char **argv)
 			}
 		}
 	}
-
+online_resize_unlock:
+	if (online_resize)
+		online_resize_unlock(fs);
 unlock:
 	block_signals(SIG_BLOCK);
 	if (cluster_locked && fs->fs_dlm_ctxt)
diff --git a/tunefs.ocfs2/tunefs.h b/tunefs.ocfs2/tunefs.h
index 3863331..b1ad470 100644
--- a/tunefs.ocfs2/tunefs.h
+++ b/tunefs.ocfs2/tunefs.h
@@ -117,6 +117,10 @@ errcode_t feature_check(ocfs2_filesys *fs);
 errcode_t update_feature(ocfs2_filesys *fs);
 
 void get_vol_size(ocfs2_filesys *fs);
-errcode_t update_volume_size(ocfs2_filesys *fs, int *changed);
+errcode_t update_volume_size(ocfs2_filesys *fs, int *changed, int online);
 int validate_vol_size(ocfs2_filesys *fs);
+
+errcode_t online_resize_check(ocfs2_filesys *fs);
+errcode_t online_resize_lock(ocfs2_filesys *fs);
+errcode_t online_resize_unlock(ocfs2_filesys *fs);
 #endif /* _TUNEFS_H */
-- 
gitgui.0.9.0.gd794
