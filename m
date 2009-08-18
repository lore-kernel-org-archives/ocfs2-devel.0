From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:31 +0800
Subject: [Ocfs2-devel] [PATCH 30/41] ocfs2: Call refcount tree remove
	process properly.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-30-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now with xattr refcount support, we need to check whether
we have xattr refcounted before we remove the refcount tree.

Now the mechanism is:
1) Check whether i_clusters == 0, if no, exit.
2) check whether we have i_xattr_loc in dinode. if yes, exit.
2) Check whether we have inline xattr stored outside, if yes, exit.
4) Remove the tree.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/file.c         |    2 ++
 fs/ocfs2/inode.c        |    7 +++++++
 fs/ocfs2/refcounttree.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    3 +++
 fs/ocfs2/xattr.c        |   23 +++++++++++++++++++++++
 fs/ocfs2/xattr.h        |    2 ++
 6 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1254d72..ccbcc82 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -531,6 +531,8 @@ bail_unlock_sem:
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 bail:
+	if (!status && OCFS2_I(inode)->ip_clusters == 0)
+		status = ocfs2_try_remove_refcount_tree(inode, di_bh);
 
 	mlog_exit(status);
 	return status;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index e82ceb3..0297fb8 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -53,6 +53,7 @@
 #include "sysfile.h"
 #include "uptodate.h"
 #include "xattr.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -782,6 +783,12 @@ static int ocfs2_wipe_inode(struct inode *inode,
 		goto bail_unlock_dir;
 	}
 
+	status = ocfs2_remove_refcount_tree(inode, di_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_unlock_dir;
+	}
+
 	status = ocfs2_remove_inode(inode, di_bh, orphan_dir_inode,
 				    orphan_dir_bh);
 	if (status < 0)
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 9638e46..aec8bf1 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -925,6 +925,42 @@ out:
 }
 
 /*
+ * Try to remove refcount tree. The mechanism is:
+ * 1) Check whether i_clusters == 0, if no, exit.
+ * 2) check whether we have i_xattr_loc in dinode. if yes, exit.
+ * 3) Check whether we have inline xattr stored outside, if yes, exit.
+ * 4) Remove the tree.
+ */
+int ocfs2_try_remove_refcount_tree(struct inode *inode,
+				   struct buffer_head *di_bh)
+{
+	int ret;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	down_write(&oi->ip_xattr_sem);
+	down_write(&oi->ip_alloc_sem);
+
+	if (oi->ip_clusters)
+		goto out;
+
+	if ((oi->ip_dyn_features & OCFS2_HAS_XATTR_FL) && di->i_xattr_loc)
+		goto out;
+
+	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL &&
+	    ocfs2_has_inline_xattr_value_outside(inode, di))
+		goto out;
+
+	ret = ocfs2_remove_refcount_tree(inode, di_bh);
+	if (ret)
+		mlog_errno(ret);
+out:
+	up_write(&oi->ip_alloc_sem);
+	up_write(&oi->ip_xattr_sem);
+	return 0;
+}
+
+/*
  * Given a cpos and len, try to find the refcount record which contains cpos.
  * 1. If cpos can be found in one refcount record, return the record.
  * 2. If cpos can't be found, return a fake record which start from cpos
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 7796d1a..e46406a 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -90,4 +90,7 @@ int ocfs2_add_refcount_flag(struct inode *inode,
 			    u32 cpos, u32 p_cluster, u32 num_clusters,
 			    struct ocfs2_cached_dealloc_ctxt *dealloc,
 			    struct ocfs2_post_refcount *post);
+int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
+int ocfs2_try_remove_refcount_tree(struct inode *inode,
+				   struct buffer_head *di_bh);
 #endif /* OCFS2_REFCOUNTTREE_H */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 9c3be01..7f9c3ac 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -840,6 +840,23 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
 	return result;
 }
 
+int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
+					 struct ocfs2_dinode *di)
+{
+	struct ocfs2_xattr_header *xh;
+	int i;
+
+	xh = (struct ocfs2_xattr_header *)
+		 ((void *)di + inode->i_sb->s_blocksize -
+		 le16_to_cpu(di->i_xattr_inline_size));
+
+	for (i = 0; i < le16_to_cpu(xh->xh_count); i++)
+		if (!ocfs2_xattr_is_local(&xh->xh_entries[i]))
+			return 1;
+
+	return 0;
+}
+
 static int ocfs2_xattr_ibody_list(struct inode *inode,
 				  struct ocfs2_dinode *di,
 				  char *buffer,
@@ -2898,10 +2915,16 @@ int ocfs2_xattr_set(struct inode *inode,
 	if (ocfs2_dealloc_has_cluster(&ctxt.dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
+
 cleanup:
 	if (ref_tree)
 		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
+	if (!value && !ret) {
+		ret = ocfs2_try_remove_refcount_tree(inode, di_bh);
+		if (ret)
+			mlog_errno(ret);
+	}
 	ocfs2_inode_unlock(inode, 1);
 cleanup_nolock:
 	brelse(di_bh);
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index a3295d7..e74703f 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -55,6 +55,8 @@ int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
 			   int, const char *, const void *, size_t, int,
 			   struct ocfs2_alloc_context *,
 			   struct ocfs2_alloc_context *);
+int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
+					 struct ocfs2_dinode *di);
 int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
 int ocfs2_init_security_get(struct inode *, struct inode *,
 			    struct ocfs2_security_xattr_info *);
-- 
1.6.2.rc2.16.gf474c
