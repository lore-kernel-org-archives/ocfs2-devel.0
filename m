From: Tao Ma <tao.ma@oracle.com>
Date: Fri Nov 16 00:52:45 2007
Subject: [Ocfs2-devel] [PATCH 6/6] Add online resize in tunefs.ocfs2,take 1
In-Reply-To: <20071116083920.GA3879@tma-pc1.cn.oracle.com>
Message-ID: <20071116084804.GA3956@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During online resize, we prepare all the new group descriptors in
user space. For the update of global_bitmap, super block and all
the backups, they are handled in the kernel.

Signed-off-by: Tao Ma <tao.ma@oracle.com>

---

 libocfs2/include/ocfs2_fs.h |    4 +
 tunefs.ocfs2/resize.c       |  255 ++++++++++++++++++++++++++++++++++++++++---
 tunefs.ocfs2/tunefs.c       |   53 ++++++++-
 tunefs.ocfs2/tunefs.h       |    6 +
 4 files changed, 295 insertions(+), 23 deletions(-)

60516ce8535f9cd6c9f36ace7056e5a24fab5e1b
diff --git a/libocfs2/include/ocfs2_fs.h b/libocfs2/include/ocfs2_fs.h
index cfaf28f..5694114 100644
--- a/libocfs2/include/ocfs2_fs.h
+++ b/libocfs2/include/ocfs2_fs.h
@@ -27,7 +27,7 @@ #define _OCFS2_FS_H
 
 /* Version */
 #define OCFS2_MAJOR_REV_LEVEL		0
-#define OCFS2_MINOR_REV_LEVEL          	90
+#define OCFS2_MINOR_REV_LEVEL          	91
 
 /*
  * An OCFS2 volume starts this way:
@@ -230,6 +230,8 @@ #define OCFS2_IOC_FREESP64	_IOW ('X', 37
 #define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
 #define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
 
+#define OCFS2_IOC_FSGROWFSDATA	_IOW ('X', 110, struct ocfs2_dinode)
+
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
  */
diff --git a/tunefs.ocfs2/resize.c b/tunefs.ocfs2/resize.c
index 0466d60..dfee58f 100644
--- a/tunefs.ocfs2/resize.c
+++ b/tunefs.ocfs2/resize.c
@@ -22,10 +22,74 @@
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
+	if ((!mount_flags & OCFS2_MF_MOUNTED) ||
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
@@ -101,7 +165,8 @@ static errcode_t init_new_gd(ocfs2_files
 			     uint32_t num_new_clusters,
 			     uint16_t chain,
 			     uint32_t *total_bits,
-			     uint32_t *used_bits)
+			     uint32_t *used_bits,
+			     int online)
 {
 	errcode_t ret = 0;
 	uint32_t cluster_chunk;
@@ -224,7 +289,131 @@ bail:
 	return ret;
 }
 
-errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
+/*
+ * Reserve the block in the specified group and modify the
+ * group and chain information accordingly.
+ */
+static errcode_t reserve_cluster(ocfs2_filesys *fs,
+				 char *progname,
+				 struct ocfs2_dinode *di,
+				 uint64_t gd_blkno,
+				 uint32_t cluster)
+{
+	errcode_t ret;
+	uint16_t chain, cl_cpg = di->id2.i_chain.cl_cpg;
+	char *gd_buf = NULL;
+	struct ocfs2_group_desc *gd = NULL;
+	void *bitmap = NULL;
+	struct ocfs2_chain_rec *cr = NULL;
+	int retval;
+
+	ret = ocfs2_malloc_block(fs->fs_io, &gd_buf);
+	if (ret) {
+		com_err(opts.progname, ret, "while allocating a block during "
+			"reserve backup super blocks");
+		goto out;
+	}
+
+	ret = ocfs2_read_group_desc(fs, gd_blkno, gd_buf);
+	if (ret) {
+		com_err(opts.progname, ret, "while reading group descriptor "
+			"at block %"PRIu64" during volume resize", gd_blkno);
+		goto out;
+	}
+
+	gd = (struct ocfs2_group_desc *)gd_buf;
+	bitmap = gd->bg_bitmap;
+	retval = ocfs2_set_bit(cluster % cl_cpg, bitmap);
+	if (retval != 0) {
+		com_err(opts.progname, 0, "while allocating backup superblock"
+			"in cluster %u during volume resize", cluster);
+		goto out;
+	}
+
+	gd->bg_free_bits_count--;
+
+	ret = ocfs2_write_group_desc(fs, gd_blkno, gd_buf);
+	if (ret) {
+		com_err(opts.progname, ret, "while writing group descriptor "
+			"at block %"PRIu64" during volume resize", gd_blkno);
+		goto out;
+	}
+
+	/* update the dinode accordingly.*/
+	chain = gd->bg_chain;
+	cr = &(di->id2.i_chain.cl_recs[chain]);
+	cr->c_free--;
+
+	di->id1.bitmap1.i_used++;
+out:
+	if (gd_buf)
+		ocfs2_free(&gd_buf);
+	return ret;
+}
+
+/*
+ * Reserve the backup superblocks which exist in the new added groups.
+ *
+ * For those which are in the "old last" group but don't be within the
+ * "old" volume size, the kernel will reserve it.
+ */
+static errcode_t reserve_backup_supers(ocfs2_filesys *fs,
+				       char *progname,
+				       struct ocfs2_dinode *di,
+				       uint64_t lgd_blkno)
+{
+	errcode_t ret = 0;
+	int numsb, i;
+	uint64_t gd_blkno;
+	uint64_t blocks[OCFS2_MAX_BACKUP_SUPERBLOCKS];
+	uint16_t cl_cpg = di->id2.i_chain.cl_cpg;
+	uint32_t cluster;
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
+		gd_blkno = ocfs2_which_cluster_group(fs, cl_cpg, cluster);
+		if (lgd_blkno >= gd_blkno)
+			continue;
+
+		ret = reserve_cluster(fs, progname, di, gd_blkno, cluster);
+		if (ret)
+			goto out;
+	}
+
+out:
+	return ret;
+}
+
+static errcode_t update_global_bitmap_online(char *progname,
+					     struct ocfs2_dinode *di)
+{
+	int fd;
+	errcode_t ret;
+
+	fd = open(mnt_dir, O_RDONLY);
+	if (fd < 0) {
+		com_err(progname, errno,
+			"while opening mounted dir %s.\n", mnt_dir);
+		return errno;
+	}
+
+	ret = ioctl(fd, OCFS2_IOC_FSGROWFSDATA, di);
+	if (ret < 0)
+		com_err(progname, errno, "while ioctl on dir %s.\n", mnt_dir);
+
+	close(fd);
+	return ret;
+}
+
+errcode_t update_volume_size(ocfs2_filesys *fs, int *changed, int online)
 {
 	errcode_t ret = 0;
 	struct ocfs2_dinode *di;
@@ -242,7 +431,7 @@ errcode_t update_volume_size(ocfs2_files
 	uint32_t used_bits;
 	uint32_t total_bits;
 	uint32_t num_bits;
-	int flush_lgd = 0;
+	int flush_lgd = 0, i = 0;
 
 	ret = ocfs2_malloc_block(fs->fs_io, &in_buf);
 	if (ret) {
@@ -277,13 +466,31 @@ errcode_t update_volume_size(ocfs2_files
 	di = (struct ocfs2_dinode *)in_buf;
 	cl = &(di->id2.i_chain);
 
-	total_bits = di->id1.bitmap1.i_total;
-	used_bits = di->id1.bitmap1.i_used;
-
 	first_new_cluster = di->i_clusters;
 	save_new_clusters = num_new_clusters =
 		ocfs2_blocks_to_clusters(fs, opts.num_blocks) - di->i_clusters;
 
+	/*
+	 * For online resize, empty total_bits, used_bits, di->i_clusters
+	 * and all the information within the chain except c_blkno.
+	 * So after init_new_gd, used_bits, total_bits, and chain_rec will
+	 * record the real information of the new added group descriptors.
+	 *
+	 * We don't emtpy c_blkno here so that the original group header
+	 * can be linked to the tail of the new added group list.
+	 */
+	if (online) {
+		total_bits = 0;
+		used_bits = 0;
+		di->i_clusters = 0;
+		for (i = 0; i < cl->cl_count; i++) {
+			cl->cl_recs[i].c_free = 0;
+			cl->cl_recs[i].c_total = 0;
+		}
+	} else {
+		total_bits = di->id1.bitmap1.i_total;
+		used_bits = di->id1.bitmap1.i_used;
+	}
 	/* Find the blknum of the last cluster group */
 	lgd_blkno = ocfs2_which_cluster_group(fs, cl->cl_cpg, first_new_cluster - 1);
 
@@ -304,7 +511,12 @@ errcode_t update_volume_size(ocfs2_files
 
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
@@ -330,11 +542,14 @@ errcode_t update_volume_size(ocfs2_files
 		flush_lgd = 1;
 	}
 
-	/* Init the new groups and write to disk */
-	/* Add these groups one by one starting from the first chain after */
-	/* the one containing the last group */
+	/*
+	 * Init the new groups and write to disk
+	 * Add these groups one by one starting from the first chain after
+	 * the one containing the last group.
+	 */
 	ret = init_new_gd(fs, di, first_new_cluster,
-			  num_new_clusters, chain, &total_bits, &used_bits);
+			  num_new_clusters, chain, &total_bits, &used_bits,
+			  online);
 	if (ret)
 		goto bail;
 
@@ -344,11 +559,21 @@ errcode_t update_volume_size(ocfs2_files
 	di->i_clusters += save_new_clusters;
 	di->i_size = (uint64_t) di->i_clusters * fs->fs_clustersize;
 
-	fs->fs_super->i_clusters = di->i_clusters;
+	fs->fs_super->i_clusters = fs->fs_clusters;
 
-	ret = update_global_bitmap(fs, di, gd, flush_lgd);
-	if (ret)
-		goto bail;
+	if (online) {
+		ret = reserve_backup_supers(fs, opts.progname, di, lgd_blkno);
+		if (ret)
+			goto bail;
+
+		ret = update_global_bitmap_online(opts.progname, di);
+		if (ret)
+			goto bail;
+	} else {
+		ret = update_global_bitmap(fs, di, gd, flush_lgd);
+		if (ret)
+			goto bail;
+	}
 
 	*changed = 1;
 
diff --git a/tunefs.ocfs2/tunefs.c b/tunefs.ocfs2/tunefs.c
index cea9eb1..59aa56d 100644
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
@@ -1006,6 +1007,17 @@ static errcode_t volume_check(ocfs2_file
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
+		ret = update_volume_size(fs, &upd_blocks, online_resize);
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
@@ -117,6 +117,10 @@ errcode_t feature_check(ocfs2_filesys *f
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
1.3.3
