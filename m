From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 13 Jan 2011 18:20:14 +0800
Subject: [Ocfs2-devel] [PATCH 2/8] Ocfs2: Add basic framework and source
	files for extent moving.
In-Reply-To: <1294914020-21628-1-git-send-email-tristan.ye@oracle.com>
References: <1294914020-21628-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1294914020-21628-3-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch tries to do following things:

1. Adding new files move_extents.[c|h] and fill it with basic framework.

2. Adding handler for new ioctl OCFS2_IOC_MOVE_EXT.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/Makefile          |    1 +
 fs/ocfs2/cluster/masklog.h |    1 +
 fs/ocfs2/ioctl.c           |    5 +
 fs/ocfs2/move_extents.c    |  240 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/move_extents.h    |   22 ++++
 5 files changed, 269 insertions(+), 0 deletions(-)
 create mode 100644 fs/ocfs2/move_extents.c
 create mode 100644 fs/ocfs2/move_extents.h

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 07d9fd8..5166f2d 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -30,6 +30,7 @@ ocfs2-objs := \
 	namei.o 		\
 	refcounttree.o		\
 	reservations.o		\
+	move_extents.o		\
 	resize.o		\
 	slot_map.o 		\
 	suballoc.o 		\
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index ea2ed9f..36f1cb2 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -121,6 +121,7 @@
 #define ML_KTHREAD	0x0000000400000000ULL /* kernel thread activity */
 #define ML_RESERVATIONS	0x0000000800000000ULL /* ocfs2 alloc reservations */
 #define ML_CLUSTER	0x0000001000000000ULL /* cluster stack */
+#define ML_MOVE_EXT	0x0000002000000000ULL /* move extents */
 
 #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
 #define MLOG_INITIAL_NOT_MASK (ML_ENTRY|ML_EXIT)
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 7a48681..b8fe7a7 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -23,6 +23,7 @@
 #include "ioctl.h"
 #include "resize.h"
 #include "refcounttree.h"
+#include "move_extents.h"
 
 #include <linux/ext2_fs.h>
 
@@ -523,6 +524,8 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 
 		return ocfs2_info_handle(inode, &info, 0);
+	case OCFS2_IOC_MOVE_EXT:
+		return ocfs2_ioctl_move_extents(filp, (void __user *)arg);
 	default:
 		return -ENOTTY;
 	}
@@ -565,6 +568,8 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 			return -EFAULT;
 
 		return ocfs2_info_handle(inode, &info, 1);
+	case OCFS2_IOC_MOVE_EXT:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
new file mode 100644
index 0000000..9e9b9fd
--- /dev/null
+++ b/fs/ocfs2/move_extents.c
@@ -0,0 +1,240 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * move_extents.c
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/mount.h>
+#include <linux/swap.h>
+
+#define MLOG_MASK_PREFIX ML_MOVE_EXT
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+#include "ocfs2_ioctl.h"
+
+#include "alloc.h"
+#include "aops.h"
+#include "dlmglue.h"
+#include "extent_map.h"
+#include "inode.h"
+#include "journal.h"
+#include "suballoc.h"
+#include "uptodate.h"
+#include "super.h"
+#include "dir.h"
+#include "buffer_head_io.h"
+#include "sysfile.h"
+#include "suballoc.h"
+#include "move_extents.h"
+
+struct ocfs2_move_extents_context {
+	struct inode *inode;
+	struct file *file;
+	int auto_defrag;
+	int credits;
+	u32 new_phys_cpos;
+	u32 clusters_moved;
+	struct ocfs2_move_extents *range;
+	struct ocfs2_extent_tree et;
+	struct ocfs2_alloc_context *meta_ac;
+	struct ocfs2_alloc_context *data_ac;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+};
+
+static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
+{
+	int status;
+	handle_t *handle;
+	struct inode *inode = context->inode;
+	struct ocfs2_dinode *di;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (!inode)
+		return -ENOENT;
+
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return -EROFS;
+
+	mutex_lock(&inode->i_mutex);
+
+	/*
+	 * This prevents concurrent writes from other nodes
+	 */
+	status = ocfs2_rw_lock(inode, 1);
+	if (status) {
+		mlog_errno(status);
+		goto out;
+	}
+
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (status) {
+		mlog_errno(status);
+		goto out_rw_unlock;
+	}
+
+	/*
+	 * rememer ip_xattr_sem also needs to be held if necessary
+	 */
+	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+	/*
+	 * real extents moving codes will be fulfilled later.
+	 * 
+	 * status = __ocfs2_move_extents_range(di_bh, context);
+	 */
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
+	if (status) {
+		mlog_errno(status);
+		goto out_inode_unlock;
+	}
+
+	/*
+	 * We update ctime for these changes
+	 */
+	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		mlog_errno(status);
+		goto out_inode_unlock;
+	}
+
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status) {
+		mlog_errno(status);
+		goto out_commit;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	inode->i_ctime = CURRENT_TIME;
+	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
+	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+
+	ocfs2_journal_dirty(handle, di_bh);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out_inode_unlock:
+	brelse(di_bh);
+	ocfs2_inode_unlock(inode, 1);
+out_rw_unlock:
+	ocfs2_rw_unlock(inode, 1);
+out:
+	mutex_unlock(&inode->i_mutex);
+
+	return status;
+}
+
+int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
+{
+	int status;
+
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct ocfs2_move_extents range;
+	struct ocfs2_move_extents_context *context = NULL;
+
+	status = mnt_want_write(filp->f_path.mnt);
+	if (status)
+		return status;
+
+	status = -EINVAL;
+
+	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE))
+		goto out;
+
+	if (inode->i_flags & (S_IMMUTABLE|S_APPEND)) {
+		status = -EPERM;
+		goto out;
+	}
+
+	context = kzalloc(sizeof(struct ocfs2_move_extents_context), GFP_NOFS);
+	if (!context) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto out;
+	}
+
+	context->inode = inode;
+	context->file = filp;
+
+	if (!argp) {
+		memset(&range, 0, sizeof(range));
+		range.me_len = (u64)-1;
+		range.me_flags |= OCFS2_MOVE_EXT_FL_AUTO_DEFRAG;
+		context->auto_defrag = 1;
+	} else {
+		if (copy_from_user(&range, (struct ocfs2_move_extents *)argp,
+				   sizeof(range))) {
+			status = -EFAULT;
+			goto out;
+		}
+	}
+
+	if (range.me_start > i_size_read(inode))
+		goto out;
+
+	if (range.me_start + range.me_len > i_size_read(inode))
+			range.me_len = i_size_read(inode) - range.me_start;
+
+	context->range = &range;
+
+	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
+		context->auto_defrag = 1;
+		if (!range.me_thresh)
+			/*
+			 * ok, the default theshold for the defragmentation
+			 * is 1M, since our maximum clustersize was 1M also.
+			 * any thought?
+			 */
+			range.me_thresh = 1024 * 1024;
+	} else {
+		/*
+		 * first best-effort attempt to validate and adjust the goal
+		 * (physical address in block), while it can't guarantee later
+		 * operation can succeed all the time since global_bitmap may
+		 * change a bit over time.
+		 */
+		/*
+		 * real validation codes will be fulfilled later.
+		 *
+		 * status = ocfs2_validate_and_adjust_move_goal(inode, &range);
+		 * if (status)
+		 * 	goto out;
+		*/
+	}
+
+	status = ocfs2_move_extents(context);
+	if (status)
+		mlog_errno(status);
+out:
+	/*
+	 * movement/defragmentation may end up being partially completed,
+	 * that's the reason why we need to return userspace the finished
+	 * length and new_offset even if failure happens somewhere.
+	 */
+	if (argp) {
+		if (copy_to_user((struct ocfs2_move_extents *)argp, &range,
+				sizeof(range)))
+			status = -EFAULT;
+	}
+
+	kfree(context);
+
+	mnt_drop_write(filp->f_path.mnt);
+
+	return status;
+}
diff --git a/fs/ocfs2/move_extents.h b/fs/ocfs2/move_extents.h
new file mode 100644
index 0000000..d9f0f29
--- /dev/null
+++ b/fs/ocfs2/move_extents.h
@@ -0,0 +1,22 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * move_extents.h
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef OCFS2_MOVE_EXTENTS_H
+#define OCFS2_MOVE_EXTENTS_H
+
+int ocfs2_ioctl_move_extents(struct file *filp,  void __user *argp);
+
+#endif /* OCFS2_MOVE_EXTENTS_H */
-- 
1.5.5
