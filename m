From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:40 +0800
Subject: [Ocfs2-devel] [PATCH 39/41] ocfs2: Implement ocfs2_reflink.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-39-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Implement ocfs2_reflink.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c        |    2 +
 fs/ocfs2/refcounttree.c |  123 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    2 +
 3 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f010b22..589ecde 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -63,6 +63,7 @@
 #include "uptodate.h"
 #include "xattr.h"
 #include "acl.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -2326,4 +2327,5 @@ const struct inode_operations ocfs2_dir_iops = {
 	.getxattr	= generic_getxattr,
 	.listxattr	= ocfs2_listxattr,
 	.removexattr	= generic_removexattr,
+	.reflink	= ocfs2_reflink,
 };
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 05e7f18..711d5b0 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -33,6 +33,7 @@
 #include "extent_map.h"
 #include "aops.h"
 #include "xattr.h"
+#include "namei.h"
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
@@ -3879,3 +3880,125 @@ out:
 
 	return ret;
 }
+
+static int __ocfs2_reflink(struct dentry *old_dentry,
+			   struct buffer_head *old_bh,
+			   struct inode *new_inode,
+			   bool preserve)
+{
+	int ret;
+	struct inode *inode = old_dentry->d_inode;
+	struct buffer_head *new_bh = NULL;
+
+	ret = filemap_fdatawrite(inode->i_mapping);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_attach_refcount_tree(inode, old_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mutex_lock(&new_inode->i_mutex);
+	ret = ocfs2_inode_lock(new_inode, &new_bh, 1);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ret = ocfs2_create_reflink_node(inode, old_bh,
+					new_inode, new_bh, preserve);
+	if (ret) {
+		mlog_errno(ret);
+		goto inode_unlock;
+	}
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_XATTR_FL) {
+		ret = ocfs2_reflink_xattrs(inode, old_bh,
+					   new_inode, new_bh,
+					   preserve);
+		if (ret)
+			mlog_errno(ret);
+	}
+inode_unlock:
+	ocfs2_inode_unlock(new_inode, 1);
+	brelse(new_bh);
+out_unlock:
+	mutex_unlock(&new_inode->i_mutex);
+out:
+	if (!ret) {
+		ret = filemap_fdatawait(inode->i_mapping);
+		if (ret)
+			mlog_errno(ret);
+	}
+	return ret;
+}
+
+int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
+		  struct dentry *new_dentry, bool preserve)
+{
+	int error;
+	struct inode *inode = old_dentry->d_inode;
+	struct buffer_head *old_bh = NULL;
+	struct inode *new_orphan_inode = NULL;
+
+	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb)))
+		return -EOPNOTSUPP;
+
+	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
+					     &new_orphan_inode);
+	if (error) {
+		mlog_errno(error);
+		goto out;
+	}
+
+	error = ocfs2_inode_lock(inode, &old_bh, 1);
+	if (error) {
+		mlog_errno(error);
+		goto out;
+	}
+
+	down_write(&OCFS2_I(inode)->ip_xattr_sem);
+	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+	error = __ocfs2_reflink(old_dentry, old_bh,
+				new_orphan_inode, preserve);
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
+	up_write(&OCFS2_I(inode)->ip_xattr_sem);
+
+	ocfs2_inode_unlock(inode, 1);
+	brelse(old_bh);
+
+	if (error) {
+		mlog_errno(error);
+		goto out;
+	}
+
+	/* If the security isn't preserved, we need to re-initialize them. */
+	if (!preserve) {
+		error = ocfs2_init_security_and_acl(dir, new_orphan_inode);
+		if (error)
+			mlog_errno(error);
+	}
+out:
+	if (!error) {
+		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
+						       new_dentry);
+		if (error)
+			mlog_errno(error);
+	}
+
+	if (new_orphan_inode) {
+		/*
+		 * We need to open_unlock the inode no matter whether we
+		 * succeed or not, so that other nodes can delete it later.
+		 */
+		ocfs2_open_unlock(new_orphan_inode);
+		if (error)
+			iput(new_orphan_inode);
+	}
+
+	return error;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 7b769b0..89d55ef 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -99,4 +99,6 @@ int ocfs2_increase_refcount(handle_t *handle,
 			    u64 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
 			    struct ocfs2_cached_dealloc_ctxt *dealloc);
+int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
+		  struct dentry *new_dentry, bool preserve);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
