From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:39 +0800
Subject: [Ocfs2-devel] [PATCH 38/41] ocfs2: Add preserve to reflink.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-38-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

reflink has 2 options for the destination file:
1. snapshot: reflink will attempt to preserve ownership, permissions,
   and all other security state in order to create a full snapshot.
2. new file: it will acquire the data extent sharing but will see the
   file's security state and attributes initialized as a new file.

So add the option to ocfs2.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   38 ++++++++++--------
 fs/ocfs2/xattr.c        |   98 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/xattr.h        |    5 ++-
 3 files changed, 119 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 4a16574..05e7f18 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3761,7 +3761,8 @@ out:
 static int ocfs2_complete_reflink(struct inode *s_inode,
 				  struct buffer_head *s_bh,
 				  struct inode *t_inode,
-				  struct buffer_head *t_bh)
+				  struct buffer_head *t_bh,
+				  bool preserve)
 {
 	int ret;
 	handle_t *handle;
@@ -3796,22 +3797,26 @@ static int ocfs2_complete_reflink(struct inode *s_inode,
 	di->i_size = s_di->i_size;
 	di->i_dyn_features = s_di->i_dyn_features;
 	di->i_attr = s_di->i_attr;
-	di->i_uid = s_di->i_uid;
-	di->i_gid = s_di->i_gid;
-	di->i_mode = s_di->i_mode;
 
-	/*
-	 * update time.
-	 * we want mtime to appear identical to the source and update ctime.
-	 */
-	t_inode->i_ctime = CURRENT_TIME;
+	if (preserve) {
+		di->i_uid = s_di->i_uid;
+		di->i_gid = s_di->i_gid;
+		di->i_mode = s_di->i_mode;
+
+		/*
+		 * update time.
+		 * we want mtime to appear identical to the source and
+		 * update ctime.
+		 */
+		t_inode->i_ctime = CURRENT_TIME;
 
-	di->i_ctime = cpu_to_le64(t_inode->i_ctime.tv_sec);
-	di->i_ctime_nsec = cpu_to_le32(t_inode->i_ctime.tv_nsec);
+		di->i_ctime = cpu_to_le64(t_inode->i_ctime.tv_sec);
+		di->i_ctime_nsec = cpu_to_le32(t_inode->i_ctime.tv_nsec);
 
-	t_inode->i_mtime = s_inode->i_mtime;
-	di->i_mtime = s_di->i_mtime;
-	di->i_mtime_nsec = s_di->i_mtime_nsec;
+		t_inode->i_mtime = s_inode->i_mtime;
+		di->i_mtime = s_di->i_mtime;
+		di->i_mtime_nsec = s_di->i_mtime_nsec;
+	}
 
 	ocfs2_journal_dirty(handle, t_bh);
 
@@ -3823,7 +3828,8 @@ out_commit:
 static int ocfs2_create_reflink_node(struct inode *s_inode,
 				     struct buffer_head *s_bh,
 				     struct inode *t_inode,
-				     struct buffer_head *t_bh)
+				     struct buffer_head *t_bh,
+				     bool preserve)
 {
 	int ret;
 	struct buffer_head *ref_root_bh = NULL;
@@ -3858,7 +3864,7 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 		goto out_unlock_refcount;
 	}
 
-	ret = ocfs2_complete_reflink(s_inode, s_bh, t_inode, t_bh);
+	ret = ocfs2_complete_reflink(s_inode, s_bh, t_inode, t_bh, preserve);
 	if (ret)
 		mlog_errno(ret);
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4eef69b..a3eed49 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -56,6 +56,7 @@
 #include "super.h"
 #include "xattr.h"
 #include "refcounttree.h"
+#include "acl.h"
 
 struct ocfs2_xattr_def_value_root {
 	struct ocfs2_xattr_value_root	xv;
@@ -204,6 +205,8 @@ static int ocfs2_get_xattr_tree_value_root(struct super_block *sb,
 					   int offset,
 					   struct ocfs2_xattr_value_root **xv,
 					   struct buffer_head **bh);
+static int ocfs2_xattr_security_set(struct inode *inode, const char *name,
+				    const void *value, size_t size, int flags);
 
 static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
 {
@@ -5994,6 +5997,7 @@ out:
 	return ret;
 }
 
+typedef int (should_xattr_reflinked)(struct ocfs2_xattr_entry *xe);
 /*
  * Store the information we need in xattr reflink.
  * old_bh and new_bh are inode bh for the old and new inode.
@@ -6006,6 +6010,7 @@ struct ocfs2_xattr_reflink {
 	struct ocfs2_caching_info *ref_ci;
 	struct buffer_head *ref_root_bh;
 	struct ocfs2_cached_dealloc_ctxt *dealloc;
+	should_xattr_reflinked *xattr_reflinked;
 };
 
 /*
@@ -6147,6 +6152,9 @@ out:
  * NOTE:
  * Before we call this function, the caller has memcpy the xattr in
  * old_xh to the new_xh.
+ *
+ * If args.xattr_reflinked is set, call it to decide whether the xe should
+ * be reflinked or not. If not, remove it from the new xattr header.
  */
 static int ocfs2_reflink_xattr_header(handle_t *handle,
 				      struct ocfs2_xattr_reflink *args,
@@ -6159,10 +6167,10 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
 				      get_xattr_value_root *func,
 				      void *para)
 {
-	int ret = 0, i;
+	int ret = 0, i, j;
 	struct super_block *sb = args->old_inode->i_sb;
 	struct buffer_head *value_bh;
-	struct ocfs2_xattr_entry *xe;
+	struct ocfs2_xattr_entry *xe, *last;
 	struct ocfs2_xattr_value_root *xv, *new_xv;
 	struct ocfs2_extent_tree data_et;
 	u32 clusters, cpos, p_cluster, num_clusters;
@@ -6170,9 +6178,30 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
 
 	mlog(0, "reflink xattr in container %llu, count = %u\n",
 	     (unsigned long long)old_bh->b_blocknr, le16_to_cpu(xh->xh_count));
-	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
+
+	last = &new_xh->xh_entries[le16_to_cpu(new_xh->xh_count)];
+	for (i = 0, j = 0; i < le16_to_cpu(xh->xh_count); i++, j++) {
 		xe = &xh->xh_entries[i];
 
+		if (args->xattr_reflinked && !args->xattr_reflinked(xe)) {
+			xe = &new_xh->xh_entries[j];
+
+			le16_add_cpu(&new_xh->xh_count, -1);
+			if (new_xh->xh_count) {
+				memmove(xe, xe + 1,
+					(void *)last - (void *)xe);
+				memset(last, 0,
+				       sizeof(struct ocfs2_xattr_entry));
+			}
+
+			/*
+			 * We don't want j to increase in the next round since
+			 * it is already moved ahead.
+			 */
+			j--;
+			continue;
+		}
+
 		if (ocfs2_xattr_is_local(xe))
 			continue;
 
@@ -6182,7 +6211,7 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
 			break;
 		}
 
-		ret = func(sb, new_bh, new_xh, i, &new_xv, &value_bh, para);
+		ret = func(sb, new_bh, new_xh, j, &new_xv, &value_bh, para);
 		if (ret) {
 			mlog_errno(ret);
 			break;
@@ -6847,10 +6876,20 @@ out:
 	return ret;
 }
 
+static int ocfs2_reflink_xattr_no_security(struct ocfs2_xattr_entry *xe)
+{
+	int type = ocfs2_xattr_get_type(xe);
+
+	return type != OCFS2_XATTR_INDEX_SECURITY &&
+	       type != OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS &&
+	       type != OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT;
+}
+
 int ocfs2_reflink_xattrs(struct inode *old_inode,
 			 struct buffer_head *old_bh,
 			 struct inode *new_inode,
-			 struct buffer_head *new_bh)
+			 struct buffer_head *new_bh,
+			 bool preserve_security)
 {
 	int ret;
 	struct ocfs2_xattr_reflink args;
@@ -6878,6 +6917,10 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
 	args.ref_ci = &ref_tree->rf_ci;
 	args.ref_root_bh = ref_root_bh;
 	args.dealloc = &dealloc;
+	if (preserve_security)
+		args.xattr_reflinked = NULL;
+	else
+		args.xattr_reflinked = ocfs2_reflink_xattr_no_security;
 
 	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
 		ret = ocfs2_reflink_xattr_inline(&args);
@@ -6918,6 +6961,51 @@ out:
 }
 
 /*
+ * Initialize security and acl for a already created inode.
+ * Used for reflink a non-preserve-security file.
+ *
+ * It uses common api like ocfs2_xattr_set, so the caller
+ * must not hold any lock expect i_mutex.
+ */
+int ocfs2_init_security_and_acl(struct inode *dir,
+				struct inode *inode)
+{
+	int ret = 0;
+	struct buffer_head *dir_bh = NULL;
+	struct ocfs2_security_xattr_info si = {
+		.enable = 1,
+	};
+
+	ret = ocfs2_init_security_get(inode, dir, &si);
+	if (!ret) {
+		ret = ocfs2_xattr_security_set(inode, si.name,
+					       si.value, si.value_len,
+					       XATTR_CREATE);
+		if (ret) {
+			mlog_errno(ret);
+			goto leave;
+		}
+	} else if (ret != -EOPNOTSUPP) {
+		mlog_errno(ret);
+		goto leave;
+	}
+
+	ret = ocfs2_inode_lock(dir, &dir_bh, 0);
+	if (ret) {
+		mlog_errno(ret);
+		goto leave;
+	}
+
+	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
+	if (ret)
+		mlog_errno(ret);
+
+	ocfs2_inode_unlock(dir, 0);
+	brelse(dir_bh);
+leave:
+	return ret;
+}
+/*
  * 'security' attributes support
  */
 static size_t ocfs2_xattr_security_list(struct inode *inode, char *list,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 4f91305..08e3638 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -93,5 +93,8 @@ int ocfs2_xattr_attach_refcount_tree(struct inode *inode,
 int ocfs2_reflink_xattrs(struct inode *old_inode,
 			 struct buffer_head *old_bh,
 			 struct inode *new_inode,
-			 struct buffer_head *new_bh);
+			 struct buffer_head *new_bh,
+			 bool preserve_security);
+int ocfs2_init_security_and_acl(struct inode *dir,
+				struct inode *inode);
 #endif /* OCFS2_XATTR_H */
-- 
1.6.2.rc2.16.gf474c
