From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:06 +0800
Subject: [Ocfs2-devel] [PATCH 05/41] ocfs2: Add new refcount tree lock
	resource in dlmglue.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-5-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

refcount tree lock resource is used to protect refcount
tree read/write among multiple nodes.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dlmglue.c      |   80 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlmglue.h      |    6 +++
 fs/ocfs2/ocfs2_lockid.h |    5 +++
 fs/ocfs2/refcounttree.h |   36 +++++++++++++++++++++
 4 files changed, 127 insertions(+), 0 deletions(-)
 create mode 100644 fs/ocfs2/refcounttree.h

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 79db055..bb2fc69 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -53,6 +53,7 @@
 #include "super.h"
 #include "uptodate.h"
 #include "quota.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -110,6 +111,11 @@ static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
 
 static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres);
 
+static int ocfs2_check_refcount_downconvert(struct ocfs2_lock_res *lockres,
+					    int new_level);
+static int ocfs2_refcount_convert_worker(struct ocfs2_lock_res *lockres,
+					 int blocking);
+
 #define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
 
 /* This aids in debugging situations where a bad LVB might be involved. */
@@ -278,6 +284,12 @@ static struct ocfs2_lock_res_ops ocfs2_qinfo_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH | LOCK_TYPE_USES_LVB,
 };
 
+static struct ocfs2_lock_res_ops ocfs2_refcount_block_lops = {
+	.check_downconvert = ocfs2_check_refcount_downconvert,
+	.downconvert_worker = ocfs2_refcount_convert_worker,
+	.flags		= 0,
+};
+
 static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
 {
 	return lockres->l_type == OCFS2_LOCK_TYPE_META ||
@@ -306,6 +318,12 @@ static inline struct ocfs2_mem_dqinfo *ocfs2_lock_res_qinfo(struct ocfs2_lock_re
 	return (struct ocfs2_mem_dqinfo *)lockres->l_priv;
 }
 
+static inline struct ocfs2_refcount_tree *
+ocfs2_lock_res_refcount_tree(struct ocfs2_lock_res *res)
+{
+	return container_of(res, struct ocfs2_refcount_tree, rf_lockres);
+}
+
 static inline struct ocfs2_super *ocfs2_get_lockres_osb(struct ocfs2_lock_res *lockres)
 {
 	if (lockres->l_ops->get_osb)
@@ -693,6 +711,17 @@ void ocfs2_qinfo_lock_res_init(struct ocfs2_lock_res *lockres,
 				   info);
 }
 
+void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
+				  struct ocfs2_super *osb, u64 ref_blkno,
+				  unsigned int generation)
+{
+	ocfs2_lock_res_init_once(lockres);
+	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_REFCOUNT, ref_blkno,
+			      generation, lockres->l_name);
+	ocfs2_lock_res_init_common(osb, lockres, OCFS2_LOCK_TYPE_REFCOUNT,
+				   &ocfs2_refcount_block_lops, osb);
+}
+
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 {
 	mlog_entry_void();
@@ -3648,6 +3677,26 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 	return UNBLOCK_CONTINUE_POST;
 }
 
+static int ocfs2_check_refcount_downconvert(struct ocfs2_lock_res *lockres,
+					    int new_level)
+{
+	struct ocfs2_refcount_tree *tree =
+				ocfs2_lock_res_refcount_tree(lockres);
+
+	return ocfs2_ci_checkpointed(&tree->rf_ci, lockres, new_level);
+}
+
+static int ocfs2_refcount_convert_worker(struct ocfs2_lock_res *lockres,
+					 int blocking)
+{
+	struct ocfs2_refcount_tree *tree =
+				ocfs2_lock_res_refcount_tree(lockres);
+
+	ocfs2_metadata_cache_purge(&tree->rf_ci);
+
+	return UNBLOCK_CONTINUE;
+}
+
 static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres)
 {
 	struct ocfs2_qinfo_lvb *lvb;
@@ -3760,6 +3809,37 @@ bail:
 	return status;
 }
 
+int ocfs2_refcount_lock(struct ocfs2_refcount_tree *ref_tree, int ex)
+{
+	int status;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
+	struct ocfs2_lock_res *lockres = &ref_tree->rf_lockres;
+	struct ocfs2_super *osb = lockres->l_priv;
+
+
+	if (ocfs2_is_hard_readonly(osb))
+		return -EROFS;
+
+	if (ocfs2_mount_local(osb))
+		return 0;
+
+	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
+	if (status < 0)
+		mlog_errno(status);
+
+	return status;
+}
+
+void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex)
+{
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
+	struct ocfs2_lock_res *lockres = &ref_tree->rf_lockres;
+	struct ocfs2_super *osb = lockres->l_priv;
+
+	if (!ocfs2_mount_local(osb))
+		ocfs2_cluster_unlock(osb, lockres, level);
+}
+
 /*
  * This is the filesystem locking protocol.  It provides the lock handling
  * hooks for the underlying DLM.  It has a maximum version number.
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 7553836..d1ce48e 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -101,6 +101,9 @@ void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
 struct ocfs2_mem_dqinfo;
 void ocfs2_qinfo_lock_res_init(struct ocfs2_lock_res *lockres,
                                struct ocfs2_mem_dqinfo *info);
+void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
+				  struct ocfs2_super *osb, u64 ref_blkno,
+				  unsigned int generation);
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res);
 int ocfs2_create_new_inode_locks(struct inode *inode);
 int ocfs2_drop_inode_locks(struct inode *inode);
@@ -148,6 +151,9 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock);
 void ocfs2_file_unlock(struct file *file);
 int ocfs2_qinfo_lock(struct ocfs2_mem_dqinfo *oinfo, int ex);
 void ocfs2_qinfo_unlock(struct ocfs2_mem_dqinfo *oinfo, int ex);
+struct ocfs2_refcount_tree;
+int ocfs2_refcount_lock(struct ocfs2_refcount_tree *ref_tree, int ex);
+void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex);
 
 
 void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index fcdba09..c746087 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -49,6 +49,7 @@ enum ocfs2_lock_type {
 	OCFS2_LOCK_TYPE_QINFO,
 	OCFS2_LOCK_TYPE_NFS_SYNC,
 	OCFS2_LOCK_TYPE_ORPHAN_SCAN,
+	OCFS2_LOCK_TYPE_REFCOUNT,
 	OCFS2_NUM_LOCK_TYPES
 };
 
@@ -89,6 +90,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
 		case OCFS2_LOCK_TYPE_ORPHAN_SCAN:
 			c = 'P';
 			break;
+		case OCFS2_LOCK_TYPE_REFCOUNT:
+			c = 'T';
+			break;
 		default:
 			c = '\0';
 	}
@@ -109,6 +113,7 @@ static char *ocfs2_lock_type_strings[] = {
 	[OCFS2_LOCK_TYPE_FLOCK] = "Flock",
 	[OCFS2_LOCK_TYPE_QINFO] = "Quota",
 	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "OrphanScan",
+	[OCFS2_LOCK_TYPE_REFCOUNT] = "Refcount",
 };
 
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
new file mode 100644
index 0000000..9a3695c
--- /dev/null
+++ b/fs/ocfs2/refcounttree.h
@@ -0,0 +1,36 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * refcounttree.h
+ *
+ * Copyright (C) 2009 Oracle.  All rights reserved.
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
+#ifndef OCFS2_REFCOUNTTREE_H
+#define OCFS2_REFCOUNTTREE_H
+
+struct ocfs2_refcount_tree {
+	struct rb_node rf_node;
+	u64 rf_blkno;
+	u32 rf_generation;
+	struct rw_semaphore rf_sem;
+	struct ocfs2_lock_res rf_lockres;
+	struct kref rf_getcnt;
+	int rf_removed;
+
+	/* the following 4 fields are used by caching_info. */
+	struct ocfs2_caching_info rf_ci;
+	spinlock_t rf_lock;
+	struct mutex rf_io_mutex;
+	struct super_block *rf_sb;
+};
+
+#endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
