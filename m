From: WeiWei Wang <wangww631@huawei.com>
Date: Sat, 11 Oct 2014 20:25:30 +0800
Subject: [Ocfs2-devel] [PATCH 1/7 v4] ocfs2: eliminate the static flag of
 some functions
Message-ID: <543921BA.7020804@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Eliminate the static flag of some functions.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/file.c  |  6 +++---
 fs/ocfs2/file.h  |  9 +++++++++
 fs/ocfs2/namei.c | 18 ++----------------
 fs/ocfs2/namei.h | 15 ++++++++++++++-
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2930e23..964d442 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -295,7 +295,7 @@ out:
 	return ret;
 }

-static int ocfs2_set_inode_size(handle_t *handle,
+int ocfs2_set_inode_size(handle_t *handle,
 				struct inode *inode,
 				struct buffer_head *fe_bh,
 				u64 new_i_size)
@@ -441,7 +441,7 @@ out:
 	return status;
 }

-static int ocfs2_truncate_file(struct inode *inode,
+int ocfs2_truncate_file(struct inode *inode,
 			       struct buffer_head *di_bh,
 			       u64 new_i_size)
 {
@@ -557,7 +557,7 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
 	return ret;
 }

-static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
+int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 				     u32 clusters_to_add, int mark_unwritten)
 {
 	int status = 0;
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 97bf761..43e688a 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -51,13 +51,22 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
 			 struct ocfs2_alloc_context *data_ac,
 			 struct ocfs2_alloc_context *meta_ac,
 			 enum ocfs2_alloc_restarted *reason_ret);
+int ocfs2_set_inode_size(handle_t *handle,
+		struct inode *inode,
+		struct buffer_head *fe_bh,
+		u64 new_i_size);
 int ocfs2_simple_size_update(struct inode *inode,
 			     struct buffer_head *di_bh,
 			     u64 new_i_size);
+int ocfs2_truncate_file(struct inode *inode,
+		struct buffer_head *di_bh,
+		u64 new_i_size);
 int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
 			  u64 new_i_size, u64 zero_to);
 int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
 		      loff_t zero_to);
+int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
+		u32 clusters_to_add, int mark_unwritten);
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 8add6f1..2666dce 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -75,20 +75,6 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 			      handle_t *handle,
 			      struct ocfs2_alloc_context *inode_ac);

-static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
-				    struct inode **ret_orphan_dir,
-				    u64 blkno,
-				    char *name,
-				    struct ocfs2_dir_lookup_result *lookup);
-
-static int ocfs2_orphan_add(struct ocfs2_super *osb,
-			    handle_t *handle,
-			    struct inode *inode,
-			    struct buffer_head *fe_bh,
-			    char *name,
-			    struct ocfs2_dir_lookup_result *lookup,
-			    struct inode *orphan_dir_inode);
-
 static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 				     handle_t *handle,
 				     struct inode *inode,
@@ -2097,7 +2083,7 @@ static int __ocfs2_prepare_orphan_dir(struct inode *orphan_dir_inode,
  *
  * Returns non-zero on failure.
  */
-static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
+int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
 				    u64 blkno,
 				    char *name,
@@ -2137,7 +2123,7 @@ out:
 	return ret;
 }

-static int ocfs2_orphan_add(struct ocfs2_super *osb,
+int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    handle_t *handle,
 			    struct inode *inode,
 			    struct buffer_head *fe_bh,
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index e5d059d..052a323 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -26,10 +26,23 @@
 #ifndef OCFS2_NAMEI_H
 #define OCFS2_NAMEI_H

+#include "dir.h"
+
 extern const struct inode_operations ocfs2_dir_iops;

 struct dentry *ocfs2_get_parent(struct dentry *child);
-
+int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
+		struct inode **ret_orphan_dir,
+		u64 blkno,
+		char *name,
+		struct ocfs2_dir_lookup_result *lookup);
+int ocfs2_orphan_add(struct ocfs2_super *osb,
+		handle_t *handle,
+		struct inode *inode,
+		struct buffer_head *fe_bh,
+		char *name,
+		struct ocfs2_dir_lookup_result *lookup,
+		struct inode *orphan_dir_inode);
 int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     handle_t *handle,
 		     struct inode *orphan_dir_inode,
-- 
1.8.4.3
