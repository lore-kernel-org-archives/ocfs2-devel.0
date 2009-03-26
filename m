From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:30 +0800
Subject: [Ocfs2-devel] [PATCH 24/42] ocfs2: Add new refcount tree lock
	resource.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-24-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

refcount tree lock resource is used to protect refcount
tree read/write among multiple nodes.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dlmglue.c      |   68 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlmglue.h      |    4 +++
 fs/ocfs2/ocfs2_lockid.h |    5 +++
 fs/ocfs2/refcounttree.h |   14 +++++++++
 4 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 68cb674..cc0a65e 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -53,6 +53,7 @@
 #include "super.h"
 #include "uptodate.h"
 #include "quota.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -107,6 +108,11 @@ static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
 
 static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres);
 
+static int ocfs2_check_refcount_downconvert(struct ocfs2_lock_res *lockres,
+					    int new_level);
+static int ocfs2_refcount_convert_worker(struct ocfs2_lock_res *lockres,
+					 int blocking);
+
 #define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
 
 /* This aids in debugging situations where a bad LVB might be involved. */
@@ -267,6 +273,12 @@ static struct ocfs2_lock_res_ops ocfs2_qinfo_lops = {
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
@@ -648,6 +660,16 @@ void ocfs2_qinfo_lock_res_init(struct ocfs2_lock_res *lockres,
 				   info);
 }
 
+void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
+				  struct ocfs2_super *osb, u64 ref_blkno)
+{
+	ocfs2_lock_res_init_once(lockres);
+	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_REFCOUNT, ref_blkno,
+			      0, lockres->l_name);
+	ocfs2_lock_res_init_common(osb, lockres, OCFS2_LOCK_TYPE_REFCOUNT,
+				   &ocfs2_refcount_block_lops, osb);
+}
+
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 {
 	mlog_entry_void();
@@ -3495,6 +3517,24 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 	return UNBLOCK_CONTINUE_POST;
 }
 
+static int ocfs2_check_refcount_downconvert(struct ocfs2_lock_res *lockres,
+					    int new_level)
+{
+	struct ocfs2_refcount_tree *tree = OCFS2_REF_ITEM(lockres);
+
+	return ocfs2_ci_checkpointed(&tree->rf_ci, lockres, new_level);
+}
+
+static int ocfs2_refcount_convert_worker(struct ocfs2_lock_res *lockres,
+					 int blocking)
+{
+	struct ocfs2_refcount_tree *tree = OCFS2_REF_ITEM(lockres);
+
+	ocfs2_metadata_cache_purge(&tree->rf_ci);
+
+	return UNBLOCK_CONTINUE;
+}
+
 static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres)
 {
 	struct ocfs2_qinfo_lvb *lvb;
@@ -3606,6 +3646,34 @@ bail:
 	return status;
 }
 
+int ocfs2_refcount_lock(struct ocfs2_lock_res *lockres, int ex)
+{
+	int status;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
+	struct ocfs2_super *osb = lockres->l_priv;
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
+void ocfs2_refcount_unlock(struct ocfs2_lock_res *lockres, int ex)
+{
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
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
index 3f8d998..20fe528 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -85,6 +85,8 @@ void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
 struct ocfs2_mem_dqinfo;
 void ocfs2_qinfo_lock_res_init(struct ocfs2_lock_res *lockres,
                                struct ocfs2_mem_dqinfo *info);
+void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
+				  struct ocfs2_super *osb, u64 ref_blkno);
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res);
 int ocfs2_create_new_inode_locks(struct inode *inode);
 int ocfs2_drop_inode_locks(struct inode *inode);
@@ -121,6 +123,8 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock);
 void ocfs2_file_unlock(struct file *file);
 int ocfs2_qinfo_lock(struct ocfs2_mem_dqinfo *oinfo, int ex);
 void ocfs2_qinfo_unlock(struct ocfs2_mem_dqinfo *oinfo, int ex);
+int ocfs2_refcount_lock(struct ocfs2_lock_res *lockres, int ex);
+void ocfs2_refcount_unlock(struct ocfs2_lock_res *lockres, int ex);
 
 
 void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index eb6f50c..aafed05 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -47,6 +47,7 @@ enum ocfs2_lock_type {
 	OCFS2_LOCK_TYPE_OPEN,
 	OCFS2_LOCK_TYPE_FLOCK,
 	OCFS2_LOCK_TYPE_QINFO,
+	OCFS2_LOCK_TYPE_REFCOUNT,
 	OCFS2_NUM_LOCK_TYPES
 };
 
@@ -81,6 +82,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
 		case OCFS2_LOCK_TYPE_QINFO:
 			c = 'Q';
 			break;
+		case OCFS2_LOCK_TYPE_REFCOUNT:
+			c = 'T';
+			break;
 		default:
 			c = '\0';
 	}
@@ -100,6 +104,7 @@ static char *ocfs2_lock_type_strings[] = {
 	[OCFS2_LOCK_TYPE_OPEN] = "Open",
 	[OCFS2_LOCK_TYPE_FLOCK] = "Flock",
 	[OCFS2_LOCK_TYPE_QINFO] = "Quota",
+	[OCFS2_LOCK_TYPE_REFCOUNT] = "Refcount",
 };
 
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index d38f996..0364989 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -17,6 +17,20 @@
 #ifndef OCFS2_REFCOUNTTREE_H
 #define OCFS2_REFCOUNTTREE_H
 
+struct ocfs2_refcount_tree {
+	struct rb_node rf_node;
+	u64 rf_blkno;
+	struct rw_semaphore rf_sem;
+	struct ocfs2_lock_res rf_lockres;
+	struct ocfs2_caching_info rf_ci;
+};
+
+static inline struct ocfs2_refcount_tree *
+OCFS2_REF_ITEM(struct ocfs2_lock_res *res)
+{
+	return container_of(res, struct ocfs2_refcount_tree, rf_lockres);
+}
+
 int ocfs2_create_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
 int ocfs2_set_refcount_tree(struct inode *inode,
 			    struct buffer_head *di_bh,
-- 
1.6.2.rc2.16.gf474c
