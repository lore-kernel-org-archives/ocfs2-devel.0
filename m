From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 27 Oct 2008 16:43:34 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: add security xattr support
In-Reply-To: <49057D8B.5040700@oracle.com>
References: <49057D8B.5040700@oracle.com>
Message-ID: <1225097014-29688-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch add security xattr set/get/list APIs to
support security xattr in ocfs2.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/xattr.h |   10 +++++++
 2 files changed, 86 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3567182..eb543bc 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/security.h>
 
 #define MLOG_MASK_PREFIX ML_XATTR
 #include <cluster/masklog.h>
@@ -72,7 +73,6 @@ struct ocfs2_xattr_set_ctxt {
 };
 
 #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
-#define OCFS2_XATTR_INLINE_SIZE	80
 
 static struct ocfs2_xattr_def_value_root def_xv = {
 	.xv.xr_list.l_count = cpu_to_le16(1),
@@ -81,12 +81,14 @@ static struct ocfs2_xattr_def_value_root def_xv = {
 struct xattr_handler *ocfs2_xattr_handlers[] = {
 	&ocfs2_xattr_user_handler,
 	&ocfs2_xattr_trusted_handler,
+	&ocfs2_xattr_security_handler,
 	NULL
 };
 
 static struct xattr_handler *ocfs2_xattr_handler_map[OCFS2_XATTR_MAX] = {
 	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
 	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
+	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
 };
 
 struct ocfs2_xattr_info {
@@ -4982,6 +4984,79 @@ out:
 }
 
 /*
+ * 'security' attributes support
+ */
+static size_t ocfs2_xattr_security_list(struct inode *inode, char *list,
+					size_t list_size, const char *name,
+					size_t name_len)
+{
+	const size_t prefix_len = XATTR_SECURITY_PREFIX_LEN;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_SECURITY_PREFIX, prefix_len);
+		memcpy(list + prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int ocfs2_xattr_security_get(struct inode *inode, const char *name,
+				    void *buffer, size_t size)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ocfs2_xattr_get(inode, OCFS2_XATTR_INDEX_SECURITY, name,
+			       buffer, size);
+}
+
+static int ocfs2_xattr_security_set(struct inode *inode, const char *name,
+				    const void *value, size_t size, int flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY, name, value,
+			       size, flags);
+}
+
+int ocfs2_init_security_get(struct inode *inode,
+			    struct inode *dir,
+			    char **name,
+			    void **value,
+			    size_t *len)
+{
+	int ret;
+
+	ret = security_inode_init_security(inode, dir, name, value, len);
+	if (ret == -EOPNOTSUPP)
+		return 0;
+	return ret;
+}
+
+int ocfs2_init_security_set(handle_t *handle,
+			    struct inode *inode,
+			    struct buffer_head *di_bh,
+			    char *name,
+			    void *value,
+			    size_t len,
+			    struct ocfs2_alloc_context *xattr_ac,
+			    struct ocfs2_alloc_context *data_ac)
+{
+	return ocfs2_xattr_set_handle(handle, inode, di_bh,
+				     OCFS2_XATTR_INDEX_SECURITY,
+				     name, value, len, 0,
+				     xattr_ac, data_ac);
+}
+
+struct xattr_handler ocfs2_xattr_security_handler = {
+	.prefix	= XATTR_SECURITY_PREFIX,
+	.list	= ocfs2_xattr_security_list,
+	.get	= ocfs2_xattr_security_get,
+	.set	= ocfs2_xattr_security_set,
+};
+
+/*
  * 'trusted' attributes support
  */
 static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 8fbdc16..8aaf858 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -21,6 +21,8 @@
 #include <linux/init.h>
 #include <linux/xattr.h>
 
+#define OCFS2_XATTR_INLINE_SIZE	80
+
 enum ocfs2_xattr_type {
 	OCFS2_XATTR_INDEX_USER = 1,
 	OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS,
@@ -32,6 +34,7 @@ enum ocfs2_xattr_type {
 
 extern struct xattr_handler ocfs2_xattr_user_handler;
 extern struct xattr_handler ocfs2_xattr_trusted_handler;
+extern struct xattr_handler ocfs2_xattr_security_handler;
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
@@ -42,5 +45,12 @@ int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
 			   struct ocfs2_alloc_context *,
 			   struct ocfs2_alloc_context *);
 int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
+int ocfs2_init_security_get(struct inode *, struct inode *,
+			    char **, void **, size_t *);
+int ocfs2_init_security_set(handle_t *, struct inode *,
+			    struct buffer_head *,
+			    char *, void *, size_t,
+			    struct ocfs2_alloc_context *,
+			    struct ocfs2_alloc_context *);
 
 #endif /* OCFS2_XATTR_H */
-- 
1.5.4.1
