From: Tao Ma <tao.ma@oracle.com>
Date: Tue Nov 27 00:23:01 2007
Subject: [Ocfs2-devel] 
	[PATCH 2/3] Add group extend for online resize, take 2
In-Reply-To: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
Message-ID: <20071127082135.GA4480@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

User can do offline resize using tunefs.ocfs2 when a volume isn't
mounted. Now the support for online resize is added into ocfs2.

Please note that the node where online resize goes must already
has the volume mounted. We don't mount it behind the user and the
operation would fail if we find it isn't mounted. As for other
nodes, we don't care whether the volume is mounted or not.

global_bitmap, super block and all the backups will be updated
in the kernel. And if super block or backup's update fails, we
just output some error message in dmesg and continue the work.

The whole process is derived from ext3 and divided into 2 steps:
1. If the last group isn't full, tunefs.ocfs2 will call
   OCFS2_IOC_GROUP_EXTEND first to extend it. All the main work is
   done in kernel.
2. For every new groups, tunefs.ocfs2 will call OCFS2_IOC_GROUP_ADD
   to add them one by one. The new group descriptor is initialized
   in userspace, we only check it in the kernel and update the
   global_bitap, super blocks etc.

This patch includes the implementation for the 1st step.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/Makefile         |    3 +-
 fs/ocfs2/buffer_head_io.c |   61 ++++++++
 fs/ocfs2/buffer_head_io.h |    2 +
 fs/ocfs2/ioctl.c          |    7 +
 fs/ocfs2/journal.h        |    3 +
 fs/ocfs2/ocfs2.h          |    5 +
 fs/ocfs2/ocfs2_fs.h       |    2 +
 fs/ocfs2/resize.c         |  366 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/suballoc.c       |    5 +-
 9 files changed, 449 insertions(+), 5 deletions(-)
 create mode 100644 fs/ocfs2/resize.c

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 9fb8132..ecc58b8 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -28,7 +28,8 @@ ocfs2-objs := \
 	sysfile.o 		\
 	uptodate.o		\
 	ver.o 			\
-	vote.o
+	vote.o			\
+	resize.o
 
 obj-$(CONFIG_OCFS2_FS) += cluster/
 obj-$(CONFIG_OCFS2_FS) += dlm/
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index c903741..6eaa67f 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -280,3 +280,64 @@ bail:
 	mlog_exit(status);
 	return status;
 }
+
+/* Check whether the blkno is the super block or one of the backups. */
+static inline void ocfs2_check_super_or_backup(struct super_block *sb,
+					       sector_t blkno)
+{
+	int i;
+	u64 backup_blkno;
+
+	if (blkno == OCFS2_SUPER_BLOCK_BLKNO)
+		return;
+
+	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
+		backup_blkno = ocfs2_backup_super_blkno(sb, i);
+		if (backup_blkno == blkno)
+			return;
+	}
+
+	BUG();
+}
+
+/*
+ * Write super block and bakcups doesn't need to collaborate with journal,
+ * so we don't need to lock ip_io_mutex and inode doesn't need to bea passed
+ * into this function.
+ */
+int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
+				struct buffer_head *bh)
+{
+	int ret = 0;
+
+	mlog_entry_void();
+
+	BUG_ON(buffer_jbd(bh));
+	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
+
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
+		ret = -EROFS;
+		goto out;
+	}
+
+	lock_buffer(bh);
+	set_buffer_uptodate(bh);
+
+	/* remove from dirty list before I/O. */
+	clear_buffer_dirty(bh);
+
+	get_bh(bh); /* for end_buffer_write_sync() */
+	bh->b_end_io = end_buffer_write_sync;
+	submit_bh(WRITE, bh);
+
+	wait_on_buffer(bh);
+
+	if (!buffer_uptodate(bh)) {
+		ret = -EIO;
+		brelse(bh);
+	}
+
+out:
+	mlog_exit(ret);
+	return ret;
+}
diff --git a/fs/ocfs2/buffer_head_io.h b/fs/ocfs2/buffer_head_io.h
index 6cc2093..c2e7861 100644
--- a/fs/ocfs2/buffer_head_io.h
+++ b/fs/ocfs2/buffer_head_io.h
@@ -47,6 +47,8 @@ int ocfs2_read_blocks(struct ocfs2_super          *osb,
 		      int                  flags,
 		      struct inode        *inode);
 
+int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
+				struct buffer_head *bh);
 
 #define OCFS2_BH_CACHED            1
 #define OCFS2_BH_READAHEAD         8
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 87dcece..60698de 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -115,6 +115,7 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 	unsigned int cmd, unsigned long arg)
 {
 	unsigned int flags;
+	u32 new_clusters;
 	int status;
 	struct ocfs2_space_resv sr;
 
@@ -140,6 +141,11 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 			return -EFAULT;
 
 		return ocfs2_change_file_space(filp, cmd, &sr);
+	case OCFS2_IOC_GROUP_EXTEND:
+		if (get_user(new_clusters, (__u32 __user *)arg))
+			return -EFAULT;
+
+		return ocfs2_group_extend(inode, new_clusters);
 	default:
 		return -ENOTTY;
 	}
@@ -162,6 +168,7 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case OCFS2_IOC_RESVSP64:
 	case OCFS2_IOC_UNRESVSP:
 	case OCFS2_IOC_UNRESVSP64:
+	case OCFS2_IOC_GROUP_EXTEND:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 4b32e09..0ba3a42 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -278,6 +278,9 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
 /* simple file updates like chmod, etc. */
 #define OCFS2_INODE_UPDATE_CREDITS 1
 
+/* group extend. inode update and last group update. */
+#define OCFS2_GROUP_EXTEND_CREDITS	(OCFS2_INODE_UPDATE_CREDITS + 1)
+
 /* get one bit out of a suballocator: dinode + group descriptor +
  * prev. group desc. if we relink. */
 #define OCFS2_SUBALLOC_ALLOC (3)
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 60a23e1..8a6925b 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -527,6 +527,11 @@ static inline unsigned int ocfs2_pages_per_cluster(struct super_block *sb)
 	return pages_per_cluster;
 }
 
+/* given a cluster offset, calculate which block group it belongs to
+ * and return that block offset. */
+u64 ocfs2_which_cluster_group(struct inode *inode, u32 cluster);
+int ocfs2_group_extend(struct inode * inode, u32 new_clusters);
+
 #define ocfs2_set_bit ext2_set_bit
 #define ocfs2_clear_bit ext2_clear_bit
 #define ocfs2_test_bit ext2_test_bit
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 6ef8767..4b5813d 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -231,6 +231,8 @@ struct ocfs2_space_resv {
 #define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
 #define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
 
+#define OCFS2_IOC_GROUP_EXTEND	_IOW('f', 7, unsigned long)
+
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
  */
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
new file mode 100644
index 0000000..5c863af
--- /dev/null
+++ b/fs/ocfs2/resize.c
@@ -0,0 +1,366 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * resize.c
+ *
+ * volume resize.
+ * Inspired by ext3/resize.c.
+ *
+ * Copyright (C) 2007 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/fs.h>
+#include <linux/types.h>
+
+#define MLOG_MASK_PREFIX ML_DISK_ALLOC
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+
+#include "alloc.h"
+#include "dlmglue.h"
+#include "inode.h"
+#include "journal.h"
+#include "super.h"
+#include "sysfile.h"
+#include "uptodate.h"
+
+#include "buffer_head_io.h"
+
+/*
+ * Check whether there are new backup superblocks exist
+ * in the last group. If there are some, mark them and modify
+ * the group information.
+ * Return how many backups we find in the last group.
+ */
+static u16 ocfs2_add_new_backup_super(struct inode *inode,
+				      struct ocfs2_group_desc *gd,
+				      u32 new_clusters,
+				      u32 first_new_cluster,
+				      u16 cl_cpg)
+{
+	int i;
+	u16 backups = 0;
+	u32 cluster;
+	u64 blkno, gd_blkno, lgd_blkno = le64_to_cpu(gd->bg_blkno);
+
+	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
+		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
+		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
+
+		gd_blkno = ocfs2_which_cluster_group(inode, cluster);
+		if (gd_blkno < lgd_blkno)
+			continue;
+		else if (gd_blkno > lgd_blkno)
+			break;
+
+		ocfs2_set_bit(cluster % cl_cpg, (unsigned long *)gd->bg_bitmap);
+		le16_add_cpu(&gd->bg_free_bits_count, -1);
+		backups++;
+	}
+
+	mlog_exit_void();
+	return backups;
+}
+
+static int ocfs2_update_last_group_and_inode(handle_t *handle,
+					     struct inode *bm_inode,
+					     struct buffer_head *bm_bh,
+					     struct buffer_head *group_bh,
+					     u32 first_new_cluster,
+					     u32 new_clusters)
+{
+	int ret = 0;
+	struct ocfs2_super *osb = OCFS2_SB(bm_inode->i_sb);
+	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bm_bh->b_data;
+	struct ocfs2_chain_list *cl = &fe->id2.i_chain;
+	struct ocfs2_chain_rec *cr;
+	struct ocfs2_group_desc *group;
+	u16 chain, num_bits, backups = 0;
+	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
+	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
+
+	mlog_entry("(new_clusters=%u, first_new_cluster = %u)\n",
+		   new_clusters, first_new_cluster);
+
+	ret = ocfs2_journal_access(handle, bm_inode, group_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	group = (struct ocfs2_group_desc *) group_bh->b_data;
+
+	/* update the group first. */
+	num_bits = new_clusters * cl_bpc;
+	le16_add_cpu(&group->bg_bits, num_bits);
+	le16_add_cpu(&group->bg_free_bits_count, num_bits);
+
+	/*
+	 * check whether there are some new backup superblocks exist in
+	 * this group and update the group bitmap accordingly.
+	 */
+	if (OCFS2_HAS_COMPAT_FEATURE(osb->sb,
+				     OCFS2_FEATURE_COMPAT_BACKUP_SB))
+		backups = ocfs2_add_new_backup_super(bm_inode,
+						     group,
+						     new_clusters,
+						     first_new_cluster,
+						     cl_cpg);
+
+	ret = ocfs2_journal_dirty(handle, group_bh);
+	if (ret < 0)
+		mlog_errno(ret);
+
+	/* update the inode accordingly. */
+	ret = ocfs2_journal_access(handle, bm_inode, bm_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	chain = le16_to_cpu(group->bg_chain);
+	cr = (&cl->cl_recs[chain]);
+	le32_add_cpu(&cr->c_total, num_bits);
+	le32_add_cpu(&cr->c_free, num_bits);
+	le32_add_cpu(&fe->id1.bitmap1.i_total, num_bits);
+
+	if (backups) {
+		le32_add_cpu(&cr->c_free, -1 * backups);
+		le32_add_cpu(&fe->id1.bitmap1.i_used, backups);
+	}
+
+	le32_add_cpu(&fe->i_clusters, new_clusters);
+	le64_add_cpu(&fe->i_size, new_clusters << osb->s_clustersize_bits);
+
+	ret = ocfs2_journal_dirty(handle, bm_bh);
+	if (ret < 0)
+		mlog_errno(ret);
+
+out:
+	mlog_exit(ret);
+	return ret;
+}
+
+static void update_backups(struct inode * inode, u32 clusters, char *data)
+{
+	int i, ret = 0;
+	u32 cluster;
+	u64 blkno;
+	struct buffer_head *backup = NULL;
+	struct ocfs2_dinode *backup_di = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	/* calculate the real backups we need to update. */
+	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
+		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
+		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
+		 if (cluster > clusters)
+			break;
+
+		ret = ocfs2_read_block(osb, blkno, &backup, 0, NULL);
+		if (ret < 0) {
+			mlog_errno(ret);
+			return;
+		}
+
+		memcpy(backup->b_data, data, inode->i_sb->s_blocksize);
+
+		backup_di = (struct ocfs2_dinode *)backup->b_data;
+		backup_di->i_blkno = cpu_to_le64(blkno);
+
+		ret = ocfs2_write_super_or_backup(osb, backup);
+		brelse(backup);
+		backup = NULL;
+		if (ret < 0) {
+			mlog_errno(ret);
+			break;
+		}
+	}
+
+	return;
+}
+
+static void ocfs2_update_super_and_backups(struct inode *inode,
+					   u32 new_clusters)
+{
+	int ret;
+	u32 clusters = 0;
+	struct buffer_head *super_bh = NULL;
+	struct ocfs2_dinode *super_di = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	/*
+	 * update the superblock last.
+	 * It doesn't matter if the write failed.
+	 */
+	ret = ocfs2_read_block(osb, OCFS2_SUPER_BLOCK_BLKNO,
+			       &super_bh, 0, NULL);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	super_di = (struct ocfs2_dinode *)super_bh->b_data;
+	le32_add_cpu(&super_di->i_clusters, new_clusters);
+	clusters = le32_to_cpu(super_di->i_clusters);
+
+	ret = ocfs2_write_super_or_backup(osb, super_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (OCFS2_HAS_COMPAT_FEATURE(osb->sb, OCFS2_FEATURE_COMPAT_BACKUP_SB))
+		update_backups(inode, clusters, super_bh->b_data);
+
+out:
+	if (super_bh)
+		brelse(super_bh);
+	return;
+}
+
+/*
+ * Extend the filesystem to the new number of clusters specified.  This entry
+ * point is only used to extend the current filesystem to the end of the last
+ * existing group.
+ */
+int ocfs2_group_extend(struct inode * inode, u32 new_clusters)
+{
+	int ret;
+	handle_t *handle;
+	struct buffer_head *main_bm_bh = NULL;
+	struct buffer_head *group_bh = NULL;
+	struct inode *main_bm_inode = NULL;
+	struct ocfs2_dinode *fe = NULL;
+	struct ocfs2_group_desc *group = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	u16 cl_bpc;
+	u32 first_new_cluster;
+	u64 lgd_blkno;
+
+	mlog_entry_void();
+
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return -EROFS;
+
+	if (new_clusters == 0)
+		return 0;
+
+	main_bm_inode = ocfs2_get_system_file_inode(osb,
+						    GLOBAL_BITMAP_SYSTEM_INODE,
+						    OCFS2_INVALID_SLOT);
+	if (!main_bm_inode) {
+		ret = -EINVAL;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mutex_lock(&main_bm_inode->i_mutex);
+
+	ret = ocfs2_meta_lock(main_bm_inode, &main_bm_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_mutex;
+	}
+
+	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
+
+	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
+				 ocfs2_group_bitmap_size(osb->sb) * 8) {
+		mlog(0, "The disk is too old. Force to do offline resize.");
+		ret = -EINVAL;
+		goto out_mutex;
+	}
+
+	if (!OCFS2_IS_VALID_DINODE(fe)) {
+		OCFS2_RO_ON_INVALID_DINODE(main_bm_inode->i_sb, fe);
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	first_new_cluster = le32_to_cpu(fe->i_clusters);
+	lgd_blkno = ocfs2_which_cluster_group(main_bm_inode,
+					      first_new_cluster - 1);
+
+	ret = ocfs2_read_block(osb, lgd_blkno, &group_bh, OCFS2_BH_CACHED,
+			       main_bm_inode);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	group = (struct ocfs2_group_desc *) group_bh->b_data;
+	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
+	if (new_clusters + le16_to_cpu(group->bg_bits) / cl_bpc >
+		le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	mlog(0, "extend the last group at %llu, new cluster = %u\n",
+	     le64_to_cpu(group->bg_blkno), new_clusters);
+
+	handle = ocfs2_start_trans(osb, OCFS2_GROUP_EXTEND_CREDITS);
+	if (IS_ERR(handle)) {
+		mlog_errno(PTR_ERR(handle));
+		handle = NULL;
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* update the last group descriptor and inode. */
+	ret = ocfs2_update_last_group_and_inode(handle, main_bm_inode,
+						main_bm_bh, group_bh,
+						first_new_cluster,
+						new_clusters);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ret = ocfs2_commit_trans(osb, handle);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
+	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
+	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
+
+	ocfs2_update_super_and_backups(inode, new_clusters);
+out_unlock:
+	if (group_bh)
+		brelse(group_bh);
+
+	if (main_bm_bh)
+		brelse(main_bm_bh);
+
+	ocfs2_meta_unlock(main_bm_inode, 1);
+
+out_mutex:
+	mutex_unlock(&main_bm_inode->i_mutex);
+	iput(main_bm_inode);
+
+out:
+	mlog_exit_void();
+	return ret;
+}
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8f09f52..3d0c988 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -101,8 +101,6 @@ static inline int ocfs2_block_group_reasonably_empty(struct ocfs2_group_desc *bg
 static inline u32 ocfs2_desc_bitmap_to_cluster_off(struct inode *inode,
 						   u64 bg_blkno,
 						   u16 bg_bit_off);
-static inline u64 ocfs2_which_cluster_group(struct inode *inode,
-					    u32 cluster);
 static inline void ocfs2_block_to_cluster_group(struct inode *inode,
 						u64 data_blkno,
 						u64 *bg_blkno,
@@ -1443,8 +1441,7 @@ static inline u32 ocfs2_desc_bitmap_to_cluster_off(struct inode *inode,
 
 /* given a cluster offset, calculate which block group it belongs to
  * and return that block offset. */
-static inline u64 ocfs2_which_cluster_group(struct inode *inode,
-					    u32 cluster)
+u64 ocfs2_which_cluster_group(struct inode *inode, u32 cluster)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	u32 group_no;
-- 
gitgui.0.9.0.gd794
