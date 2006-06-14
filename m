From: Herbert Poetzl <herbert@13thfloor.at>
Date: Wed, 14 Jun 2006 19:18:24 +0200
Subject: [Ocfs2-devel] ext2 attributes for OCFS2 v2
Message-ID: <20060614171824.GB31504@MAIL.13thfloor.at>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi Mark!

here is the 'new' approach with the added back
mangling (no extra function, only three places)
and the mapping between ext2 and ocfs2 ...

please let me know what you think ...

TIA,
Herbert

diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/Makefile linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/Makefile
--- linux-2.6.16.20/fs/ocfs2/Makefile	2006-01-18 06:08:34 +0100
+++ linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/Makefile	2006-06-12 20:28:07 +0200
@@ -16,6 +16,7 @@ ocfs2-objs := \
 	file.o 			\
 	heartbeat.o 		\
 	inode.o 		\
+	ioctl.o 		\
 	journal.o 		\
 	localalloc.o 		\
 	mmap.o 			\
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/dlmglue.c linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/dlmglue.c
--- linux-2.6.16.20/fs/ocfs2/dlmglue.c	2006-01-18 06:08:34 +0100
+++ linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/dlmglue.c	2006-06-14 17:51:21 +0200
@@ -1321,6 +1321,7 @@ static void __ocfs2_stuff_meta_lvb(struc
 	lvb->lvb_version   = cpu_to_be32(OCFS2_LVB_VERSION);
 	lvb->lvb_isize	   = cpu_to_be64(i_size_read(inode));
 	lvb->lvb_iclusters = cpu_to_be32(oi->ip_clusters);
+	lvb->lvb_iflags    = cpu_to_be32(oi->ip_flags) & OCFS2_FL_MASK;
 	lvb->lvb_iuid      = cpu_to_be32(inode->i_uid);
 	lvb->lvb_igid      = cpu_to_be32(inode->i_gid);
 	lvb->lvb_imode     = cpu_to_be16(inode->i_mode);
@@ -1368,6 +1371,9 @@ static void ocfs2_refresh_inode_from_lvb
 		inode->i_blocks =
 			ocfs2_align_bytes_to_sectors(i_size_read(inode));
 
+	oi->ip_flags &= ~OCFS2_FL_MASK;
+	oi->ip_flags |= be32_to_cpu(lvb->lvb_iflags) & OCFS2_FL_MASK;
+
 	inode->i_uid     = be32_to_cpu(lvb->lvb_iuid);
 	inode->i_gid     = be32_to_cpu(lvb->lvb_igid);
 	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/dlmglue.h linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/dlmglue.h
--- linux-2.6.16.20/fs/ocfs2/dlmglue.h	2006-01-18 06:08:34 +0100
+++ linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/dlmglue.h	2006-06-12 20:26:51 +0200
@@ -27,7 +27,7 @@
 #ifndef DLMGLUE_H
 #define DLMGLUE_H
 
-#define OCFS2_LVB_VERSION 2
+#define OCFS2_LVB_VERSION 3
 
 struct ocfs2_meta_lvb {
 	__be32       lvb_version;
@@ -40,7 +40,8 @@ struct ocfs2_meta_lvb {
 	__be64       lvb_isize;
 	__be16       lvb_imode;
 	__be16       lvb_inlink;
-	__be32       lvb_reserved[3];
+	__be32       lvb_iflags;
+	__be32       lvb_reserved[2];
 };
 
 /* ocfs2_meta_lock_full() and ocfs2_data_lock_full() 'arg_flags' flags */
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/file.c linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/file.c
--- linux-2.6.16.20/fs/ocfs2/file.c	2006-03-20 17:33:12 +0100
+++ linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/file.c	2006-06-12 21:18:13 +0200
@@ -44,6 +44,7 @@
 #include "file.h"
 #include "sysfile.h"
 #include "inode.h"
+#include "ioctl.h"
 #include "journal.h"
 #include "mmap.h"
 #include "suballoc.h"
@@ -1182,10 +1183,12 @@ struct file_operations ocfs2_fops = {
 	.open		= ocfs2_file_open,
 	.aio_read	= ocfs2_file_aio_read,
 	.aio_write	= ocfs2_file_aio_write,
+	.ioctl		= ocfs2_ioctl,
 };
 
 struct file_operations ocfs2_dops = {
 	.read		= generic_read_dir,
 	.readdir	= ocfs2_readdir,
 	.fsync		= ocfs2_sync_file,
+	.ioctl		= ocfs2_ioctl,
 };
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/inode.c linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/inode.c
--- linux-2.6.16.20/fs/ocfs2/inode.c	2006-03-20 17:33:12 +0100
+++ linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/inode.c	2006-06-14 17:49:35 +0200
@@ -71,6 +71,26 @@ static int ocfs2_truncate_for_delete(str
 				    struct inode *inode,
 				    struct buffer_head *fe_bh);
 
+void ocfs2_set_inode_flags(struct inode *inode)
+{
+	unsigned int flags = OCFS2_I(inode)->ip_flags;
+
+	inode->i_flags &= ~(S_IMMUTABLE |
+		S_SYNC | S_APPEND | S_NOATIME | S_DIRSYNC);
+
+	if (flags & OCFS2_IMMUTABLE_FL)
+		inode->i_flags |= S_IMMUTABLE;
+
+	if (flags & OCFS2_SYNC_FL)
+		inode->i_flags |= S_SYNC;
+	if (flags & OCFS2_APPEND_FL)
+		inode->i_flags |= S_APPEND;
+	if (flags & OCFS2_NOATIME_FL)
+		inode->i_flags |= S_NOATIME;
+	if (flags & OCFS2_DIRSYNC_FL)
+		inode->i_flags |= S_DIRSYNC;
+}
+
 struct inode *ocfs2_ilookup_for_vote(struct ocfs2_super *osb,
 				     u64 blkno,
 				     int delete_vote)
@@ -258,7 +278,6 @@ int ocfs2_populate_inode(struct inode *i
 		inode->i_blocks =
 			ocfs2_align_bytes_to_sectors(le64_to_cpu(fe->i_size));
 	inode->i_mapping->a_ops = &ocfs2_aops;
-	inode->i_flags |= S_NOATIME;
 	inode->i_atime.tv_sec = le64_to_cpu(fe->i_atime);
 	inode->i_atime.tv_nsec = le32_to_cpu(fe->i_atime_nsec);
 	inode->i_mtime.tv_sec = le64_to_cpu(fe->i_mtime);
@@ -273,6 +292,8 @@ int ocfs2_populate_inode(struct inode *i
 
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
 	OCFS2_I(inode)->ip_orphaned_slot = OCFS2_INVALID_SLOT;
+	OCFS2_I(inode)->ip_flags &= ~OCFS2_FL_MASK;
+	OCFS2_I(inode)->ip_flags |= le32_to_cpu(fe->i_flags) & OCFS2_FL_MASK;
 
 	if (create_ino)
 		inode->i_ino = ino_from_blkno(inode->i_sb,
@@ -326,7 +347,8 @@ int ocfs2_populate_inode(struct inode *i
 				  OCFS2_LOCK_TYPE_META, inode);
 	ocfs2_inode_lock_res_init(&OCFS2_I(inode)->ip_data_lockres,
 				  OCFS2_LOCK_TYPE_DATA, inode);
-
+	ocfs2_set_inode_flags(inode);
+	inode->i_flags |= S_NOATIME;
 	status = 0;
 bail:
 	mlog_exit(status);
@@ -1125,6 +1146,8 @@ int ocfs2_mark_inode_dirty(struct ocfs2_
 
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 	fe->i_clusters = cpu_to_le32(OCFS2_I(inode)->ip_clusters);
+	fe->i_flags &= cpu_to_le32(~OCFS2_FL_MASK);
+	fe->i_flags |= cpu_to_le32(OCFS2_I(inode)->ip_flags & OCFS2_FL_MASK);
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 
 	fe->i_size = cpu_to_le64(i_size_read(inode));
@@ -1163,6 +1186,10 @@ void ocfs2_refresh_inode(struct inode *i
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
+	OCFS2_I(inode)->ip_flags &= ~OCFS2_FL_MASK;
+	OCFS2_I(inode)->ip_flags |= le32_to_cpu(fe->i_flags) & OCFS2_FL_MASK;
+	ocfs2_set_inode_flags(inode);
+
 	i_size_write(inode, le64_to_cpu(fe->i_size));
 	inode->i_nlink = le16_to_cpu(fe->i_links_count);
 	inode->i_uid = le32_to_cpu(fe->i_uid);
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/inode.h linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/inode.h
--- linux-2.6.16.20/fs/ocfs2/inode.h	2006-04-09 13:49:54 +0200
+++ linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/inode.h	2006-06-14 17:04:20 +0200
@@ -142,4 +142,6 @@ int ocfs2_mark_inode_dirty(struct ocfs2_
 int ocfs2_aio_read(struct file *file, struct kiocb *req, struct iocb *iocb);
 int ocfs2_aio_write(struct file *file, struct kiocb *req, struct iocb *iocb);
 
+void ocfs2_set_inode_flags(struct inode *inode);
+
 #endif /* OCFS2_INODE_H */
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/ioctl.c linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/ioctl.c
--- linux-2.6.16.20/fs/ocfs2/ioctl.c	1970-01-01 01:00:00 +0100
+++ linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/ioctl.c	2006-06-14 17:27:23 +0200
@@ -0,0 +1,166 @@
+/*
+ * linux/fs/ocfs2/ioctl.c
+ *
+ * Copyright (C) 2006 Herbert Poetzl
+ * adapted from Remy Card's ext2/ioctl.c
+ */
+
+#include <linux/fs.h>
+#include <linux/mount.h>
+
+#define MLOG_MASK_PREFIX ML_INODE
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+#include "alloc.h"
+#include "dlmglue.h"
+#include "inode.h"
+#include "journal.h"
+
+#include "ocfs2_fs.h"
+#include <linux/ext2_fs.h>
+
+
+static struct {
+	long ocfs2_flag;
+	long ext2_flag;
+} ocfs2_map[] = {
+	{OCFS2_NOATIME_FL, EXT2_NOATIME_FL},
+	{OCFS2_DIRSYNC_FL, EXT2_DIRSYNC_FL},
+	{OCFS2_SYNC_FL, EXT2_SYNC_FL},
+	{OCFS2_SECRM_FL, EXT2_SECRM_FL},
+	{OCFS2_UNRM_FL, EXT2_UNRM_FL},
+	{OCFS2_APPEND_FL, EXT2_APPEND_FL},
+	{OCFS2_IMMUTABLE_FL, EXT2_IMMUTABLE_FL},
+	{0, 0},
+};
+
+static long ocfs2_map_ext2(unsigned long flags, int from)
+{
+	int index=0;
+	long mapped=0;
+
+	while (ocfs2_map[index].ocfs2_flag) {
+		if (from) {
+			if (ocfs2_map[index].ext2_flag & flags)
+				mapped |= ocfs2_map[index].ocfs2_flag;
+		} else {
+			if (ocfs2_map[index].ocfs2_flag & flags)
+				mapped |= ocfs2_map[index].ext2_flag;
+		}
+		index++;
+	}
+	return mapped;
+}
+
+
+int ocfs2_get_iflags(struct inode *inode, unsigned *flags)
+{
+	int status;
+
+	status = ocfs2_meta_lock(inode, NULL, NULL, 0);
+	if (status < 0) {
+		mlog_errno(status);
+		return status;
+	}
+	*flags = OCFS2_I(inode)->ip_flags;
+	ocfs2_meta_unlock(inode, 0);
+
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_set_iflags(struct inode *inode, unsigned flags, unsigned mask)
+{
+	struct ocfs2_inode_info *ocfs2_inode = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_journal_handle *handle = NULL;
+	struct buffer_head *bh = NULL;
+	unsigned oldflags;
+	int status;
+
+	status = ocfs2_meta_lock(inode, NULL, &bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	status = -EROFS;
+	if (IS_RDONLY(inode))
+		goto bail_unlock;
+
+	status = -EACCES;
+	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
+		goto bail_unlock;
+
+	if (!S_ISDIR(inode->i_mode))
+		flags &= ~OCFS2_DIRSYNC_FL;
+
+	handle = ocfs2_start_trans(osb, NULL, OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		mlog_errno(status);
+		goto bail_unlock;
+	}
+
+	oldflags = ocfs2_inode->ip_flags;
+	flags = flags & mask;
+	flags |= oldflags & ~mask;
+
+	/*
+	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
+	 * the relevant capability.
+	 */
+	status = -EPERM;
+	if ((oldflags & OCFS2_IMMUTABLE_FL) || ((flags ^ oldflags) &
+		(OCFS2_APPEND_FL | OCFS2_IMMUTABLE_FL))) {
+		if (!capable(CAP_LINUX_IMMUTABLE))
+			goto bail_unlock;
+	}
+
+	ocfs2_inode->ip_flags = flags;
+	ocfs2_set_inode_flags(inode);
+
+	status = ocfs2_mark_inode_dirty(handle, inode, bh);
+	if (status < 0)
+		mlog_errno(status);
+
+	ocfs2_commit_trans(handle);
+bail_unlock:
+	ocfs2_meta_unlock(inode, 1);
+bail:
+	if (bh)
+		brelse(bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+
+int ocfs2_ioctl(struct inode * inode, struct file * filp,
+	unsigned int cmd, unsigned long arg)
+{
+	unsigned int flags;
+	int status;
+
+	switch (cmd) {
+	case OCFS2_IOC_GETFLAGS:
+		status = ocfs2_get_iflags(inode, &flags);
+		if (status < 0)
+			return status;
+
+		flags &= OCFS2_FL_VISIBLE;
+		flags = ocfs2_map_ext2(flags, 0);
+		return put_user(flags, (int __user *) arg);
+	case OCFS2_IOC_SETFLAGS:
+		if (get_user(flags, (int __user *) arg))
+			return -EFAULT;
+
+		flags = ocfs2_map_ext2(flags, 1);
+		return ocfs2_set_iflags(inode, flags,
+			OCFS2_FL_MODIFIABLE);
+	default:
+		return -ENOTTY;
+	}
+}
+
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/ioctl.h linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/ioctl.h
--- linux-2.6.16.20/fs/ocfs2/ioctl.h	1970-01-01 01:00:00 +0100
+++ linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/ioctl.h	2006-06-12 21:17:50 +0200
@@ -0,0 +1,16 @@
+/*
+ * ioctl.h
+ *
+ * Function prototypes
+ *
+ * Copyright (C) 2006 Herbert Poetzl
+ *
+ */
+
+#ifndef OCFS2_IOCTL_H
+#define OCFS2_IOCTL_H
+
+int ocfs2_ioctl(struct inode * inode, struct file * filp,
+	unsigned int cmd, unsigned long arg);
+
+#endif /* OCFS2_IOCTL_H */
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/ocfs2_fs.h linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/ocfs2_fs.h
--- linux-2.6.16.20/fs/ocfs2/ocfs2_fs.h	2006-04-09 13:49:54 +0200
+++ linux-2.6.16.20-ocfs2-0.02/fs/ocfs2/ocfs2_fs.h	2006-06-14 17:13:13 +0200
@@ -114,6 +114,27 @@
 #define OCFS2_CHAIN_FL		(0x00000400)	/* Chain allocator */
 #define OCFS2_DEALLOC_FL	(0x00000800)	/* Truncate log */
 
+/* Inode attributes */
+#define OCFS2_SECRM_FL		(0x00010000)	/* Secure deletion */
+#define OCFS2_UNRM_FL		(0x00020000)	/* Undelete */
+#define OCFS2_COMPR_FL		(0x00040000)	/* Compress file */
+#define OCFS2_SYNC_FL		(0x00080000)	/* Synchronous updates */
+#define OCFS2_IMMUTABLE_FL	(0x00100000)	/* Immutable file */
+#define OCFS2_APPEND_FL		(0x00200000)	/* writes to file may only append */
+#define OCFS2_NODUMP_FL		(0x00400000)	/* do not dump file */
+#define OCFS2_NOATIME_FL	(0x00800000)	/* do not update atime */
+#define OCFS2_DIRSYNC_FL	(0x01000000)	/* dirsync behaviour (directories only) */
+
+#define OCFS2_FL_VISIBLE	(0x01FF0000)	/* User visible flags */
+#define OCFS2_FL_MODIFIABLE	(0x01FF0000)	/* User modifiable flags */
+#define OCFS2_FL_MASK		(0x01FF0000)	/* ext2 flag mask */
+
+/*
+ * ioctl commands
+ */
+#define OCFS2_IOC_GETFLAGS	_IOR('f', 1, long)
+#define OCFS2_IOC_SETFLAGS	_IOW('f', 2, long)
+
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
  */
