From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:46:16 +0800
Subject: [Ocfs2-devel] [PATCH 37/42] ocfs2: Call refcount tree remove
	process properly.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-37-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/alloc.c        |    5 -----
 fs/ocfs2/file.c         |    3 +++
 fs/ocfs2/inode.c        |    7 +++++++
 fs/ocfs2/refcounttree.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    2 ++
 fs/ocfs2/xattr.c        |   23 +++++++++++++++++++++++
 fs/ocfs2/xattr.h        |    2 ++
 7 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d2a058a..ef51d02 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7650,11 +7650,6 @@ bail:
 	if (ref_tree)
 		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 
-	if (!status && OCFS2_I(inode)->ip_clusters == 0) {
-		/* remove the refcount tree. */
-		status = ocfs2_remove_refcount_tree(inode, fe_bh);
-	}
-
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 
 	if (meta_ac)
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 796be27..c36daa7 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -59,6 +59,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "quota.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -483,6 +484,8 @@ bail_unlock_sem:
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 bail:
+	if (!status && OCFS2_I(inode)->ip_clusters == 0)
+		status = ocfs2_try_remove_refcount_tree(inode, di_bh);
 
 	mlog_exit(status);
 	return status;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 748fd5a..1e3c006 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -52,6 +52,7 @@
 #include "sysfile.h"
 #include "uptodate.h"
 #include "xattr.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -748,6 +749,12 @@ static int ocfs2_wipe_inode(struct inode *inode,
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
index d680edb..c12fcb0 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -427,6 +427,42 @@ out:
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
index 0ad42c0..8939e00 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -47,6 +47,8 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 			    struct buffer_head *di_bh,
 			    u64 blkno);
 int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
+int ocfs2_try_remove_refcount_tree(struct inode *inode,
+				   struct buffer_head *di_bh);
 
 int ocfs2_decrease_refcount(struct inode *inode,
 			    handle_t *handle, u32 cpos, u32 len,
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b606604..d3fd0de 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -835,6 +835,23 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
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
@@ -2892,10 +2909,16 @@ int ocfs2_xattr_set(struct inode *inode,
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
index 22a7cee..e5e67e6 100644
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
