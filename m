From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 30 Oct 2008 19:42:24 +0800
Subject: [Ocfs2-devel] [PATCH 14/15] ocfs2: add ocfs2_init_acl in mknod
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <1225366944-6473-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This function get the parent directory's acl,
and let the child inherit it. We must calculate and
reserve metadata and clusters for it need.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/acl.c   |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/acl.h   |   14 ++++++++++++
 fs/ocfs2/namei.c |   13 +++++++++-
 fs/ocfs2/xattr.c |   48 ++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/xattr.h |    4 +-
 5 files changed, 132 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 7c7e4d4..181ad1b 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -322,6 +322,67 @@ int ocfs2_acl_chmod(handle_t *handle,
 	return ret;
 }
 
+/*
+ * Initialize the ACLs of a new inode. If parent directory has default ACL,
+ * then clone to new inode. Called from ocfs2_mknod.
+ */
+int ocfs2_init_acl(handle_t *handle,
+		   struct inode *inode,
+		   struct inode *dir,
+		   struct buffer_head *di_bh,
+		   struct buffer_head *dir_bh,
+		   struct ocfs2_alloc_context *meta_ac,
+		   struct ocfs2_alloc_context *data_ac)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct posix_acl *acl = NULL;
+	int ret = 0;
+
+	if (!S_ISLNK(inode->i_mode)) {
+		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
+						   dir_bh);
+			if (IS_ERR(acl))
+				return PTR_ERR(acl);
+		}
+		if (!acl)
+			inode->i_mode &= ~current->fs->umask;
+	}
+	if ((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) && acl) {
+		struct posix_acl *clone;
+		mode_t mode;
+
+		if (S_ISDIR(inode->i_mode)) {
+			ret = ocfs2_set_acl_handle(handle, inode, di_bh,
+						   ACL_TYPE_DEFAULT, acl,
+						   meta_ac, data_ac);
+			if (ret)
+				goto cleanup;
+		}
+		clone = posix_acl_clone(acl, GFP_NOFS);
+		ret = -ENOMEM;
+		if (!clone)
+			goto cleanup;
+
+		mode = inode->i_mode;
+		ret = posix_acl_create_masq(clone, &mode);
+		if (ret >= 0) {
+			inode->i_mode = mode;
+			if (ret > 0) {
+				ret = ocfs2_set_acl_handle(handle, inode,
+							   di_bh,
+							   ACL_TYPE_ACCESS,
+							   clone,
+							   meta_ac, data_ac);
+			}
+		}
+		posix_acl_release(clone);
+	}
+cleanup:
+	posix_acl_release(acl);
+	return ret;
+}
+
 static size_t ocfs2_xattr_list_acl_access(struct inode *inode,
 					  char *list,
 					  size_t list_len,
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index f7b1df7..bd48bf4 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -30,6 +30,10 @@ struct ocfs2_acl_entry {
 
 extern int ocfs2_check_acl(struct inode *, int);
 extern int ocfs2_acl_chmod(handle_t *, struct inode *, struct buffer_head *);
+extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
+			  struct buffer_head *, struct buffer_head *,
+			  struct ocfs2_alloc_context *,
+			  struct ocfs2_alloc_context *);
 
 #else /* CONFIG_OCFS2_FS_POSIX_ACL*/
 
@@ -40,6 +44,16 @@ static inline int ocfs2_acl_chmod(handle_t *handle,
 {
 	return 0;
 }
+static inline int ocfs2_init_acl(handle_t *handle,
+				 struct inode *inode,
+				 struct inode *dir,
+				 struct buffer_head *di_bh,
+				 struct buffer_head *dir_bh,
+				 struct ocfs2_alloc_context *meta_ac,
+				 struct ocfs2_alloc_context *data_ac)
+{
+	return 0;
+}
 
 #endif /* CONFIG_OCFS2_FS_POSIX_ACL*/
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6ec42ef..c8781d5 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -61,6 +61,7 @@
 #include "sysfile.h"
 #include "uptodate.h"
 #include "xattr.h"
+#include "acl.h"
 
 #include "buffer_head_io.h"
 
@@ -290,8 +291,9 @@ static int ocfs2_mknod(struct inode *dir,
 		}
 	}
 
-	/* calculate meta data/clusters for setting security xattr */
-	status = ocfs2_calc_xattr_init(dir, strlen(security_name),
+	/* calculate meta data/clusters for setting security and acl xattrs */
+	status = ocfs2_calc_xattr_init(dir, parent_fe_bh, mode,
+					strlen(security_name),
 					security_len, has_security,
 					&want_clusters, &xattr_ac);
 	if (status < 0) {
@@ -350,6 +352,13 @@ static int ocfs2_mknod(struct inode *dir,
 		inc_nlink(dir);
 	}
 
+	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
+				xattr_ac, data_ac);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
 	if (has_security) {
 		status = ocfs2_init_security_set(handle, inode, new_fe_bh,
 						 security_name, security_value,
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index bcd4f1b..b47f237 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -84,6 +84,10 @@ struct ocfs2_xattr_set_ctxt {
 #define OCFS2_XATTR_FREE_IN_IBODY	(OCFS2_MIN_XATTR_INLINE_SIZE \
 					 - sizeof(struct ocfs2_xattr_header) \
 					 - sizeof(__u32))
+#define OCFS2_XATTR_FREE_IN_BLOCK(ptr)	((ptr)->i_sb->s_blocksize \
+					 - sizeof(struct ocfs2_xattr_block) \
+					 - sizeof(struct ocfs2_xattr_header) \
+					 - sizeof(__u32))
 
 static struct ocfs2_xattr_def_value_root def_xv = {
 	.xv.xr_list.l_count = cpu_to_le16(1),
@@ -368,6 +372,8 @@ static int ocfs2_xattr_entry_real_size(int name_len, size_t value_len)
 }
 
 int ocfs2_calc_xattr_init(struct inode *dir,
+			  struct buffer_head *dir_bh,
+			  int mode,
 			  int s_name_len,
 			  size_t s_value_len,
 			  int has_security,
@@ -377,18 +383,40 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	int s_size = 0;
+	int a_size = 0;
+	int acl_len = 0;
 
 	if (has_security)
 		s_size = ocfs2_xattr_entry_real_size(s_name_len, s_value_len);
-	else
+
+	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+		acl_len = ocfs2_xattr_get_nolock(dir, dir_bh,
+					OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT,
+					"", NULL, 0);
+		if (acl_len > 0) {
+			a_size = ocfs2_xattr_entry_real_size(0, acl_len);
+			if (S_ISDIR(mode))
+				a_size <<= 1;
+		} else if (acl_len != 0 && acl_len != -ENODATA) {
+			mlog_errno(ret);
+			return ret;
+		}
+	}
+
+	if (!(s_size + a_size))
 		return ret;
+
 	/*
 	 * The max space of security xattr taken inline is
 	 * 256(name) + 80(value) + 16(entry) = 352 bytes,
-	 * So reserve one metadata block for it is ok.
+	 * The max space of acl xattr taken inline is
+	 * 80(value) + 16(entry) * 2(if directory) = 192 bytes,
+	 * when blocksize = 512, may reserve one more cluser for
+	 * xattr bucket, otherwise reserve one metadata block
+	 * for them is ok.
 	 */
 	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE ||
-	    s_size > OCFS2_XATTR_FREE_IN_IBODY) {
+	    (s_size + a_size) > OCFS2_XATTR_FREE_IN_IBODY) {
 		ret = ocfs2_reserve_new_metadata_blocks(osb, 1, xattr_ac);
 		if (ret) {
 			mlog_errno(ret);
@@ -396,10 +424,22 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 		}
 	}
 
+	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE &&
+	    (s_size + a_size) > OCFS2_XATTR_FREE_IN_BLOCK(dir))
+		*want_clusters += 1;
+
 	/* reserve clusters for xattr value which will be set in B tree*/
-	if (s_value_len > OCFS2_XATTR_INLINE_SIZE)
+	if (has_security && s_value_len > OCFS2_XATTR_INLINE_SIZE)
 		*want_clusters += ocfs2_clusters_for_bytes(dir->i_sb,
 							   s_value_len);
+	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL &&
+	    acl_len > OCFS2_XATTR_INLINE_SIZE) {
+		*want_clusters += ocfs2_clusters_for_bytes(dir->i_sb, acl_len);
+		if (S_ISDIR(mode))
+			*want_clusters += ocfs2_clusters_for_bytes(dir->i_sb,
+								   acl_len);
+	}
+
 	return ret;
 }
 
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index b8ab4dc..de0f172 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -56,8 +56,8 @@ int ocfs2_init_security_set(handle_t *, struct inode *,
 			    char *, void *, size_t,
 			    struct ocfs2_alloc_context *,
 			    struct ocfs2_alloc_context *);
-int ocfs2_calc_xattr_init(struct inode *, int, size_t,
-			  int, int *,
+int ocfs2_calc_xattr_init(struct inode *, struct buffer_head *,
+			  int, int, size_t, int, int *,
 			  struct ocfs2_alloc_context **);
 
 #endif /* OCFS2_XATTR_H */
-- 
1.5.4.1
