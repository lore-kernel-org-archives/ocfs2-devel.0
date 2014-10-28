From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 28 Oct 2014 21:11:32 +0800
Subject: [Ocfs2-devel] [PATCH 1/7 v5] ocfs2: eliminate the static flag of
	some functions
Message-ID: <544F9604.7080702@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Weiwei Wang <wangww631@huawei.com>

Eliminate the static flag of some functions which will be used in
append O_DIRECT write.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/file.c | 11 +++++++++--
 fs/ocfs2/file.h |  9 +++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 324dc93..cb444df 100644
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
@@ -709,6 +709,13 @@ leave:
 	return status;
 }

+int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
+		u32 clusters_to_add, int mark_unwritten)
+{
+	return __ocfs2_extend_allocation(inode, logical_start,
+			clusters_to_add, mark_unwritten);
+}
+
 /*
  * While a write will already be ordering the data, a truncate will not.
  * Thus, we need to explicitly order the zeroed pages.
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 97bf761..e8c62f2 100644
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
+int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
+		u32 clusters_to_add, int mark_unwritten);
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
-- 
1.8.4.3
