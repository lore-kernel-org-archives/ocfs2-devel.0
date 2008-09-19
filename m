From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 19 Sep 2008 17:42:00 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: small fix in xattr
In-Reply-To: <48D3725A.1030701@oracle.com>
References: <48D3725A.1030701@oracle.com>
Message-ID: <1221817320-11019-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fix some define problems.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.h         |   12 ++++++------
 fs/ocfs2/xattr_trusted.c |    4 +---
 fs/ocfs2/xattr_user.c    |    4 +---
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index d33dbe5..af2ba32 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -47,14 +47,14 @@ extern struct xattr_handler ocfs2_xattr_acl_default_handler;
 #ifdef CONFIG_OCFS2_FS_SECURITY
 extern struct xattr_handler ocfs2_xattr_security_handler;
 #endif
-
-extern ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
-extern int ocfs2_xattr_get(struct inode *, int, const char *, void *, size_t);
-extern int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
-			   size_t, int);
-extern int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh);
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
+ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
+int ocfs2_xattr_get(struct inode *, int, const char *, void *, size_t);
+int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
+		    size_t, int);
+int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh);
+
 static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
 {
 	return (1 << osb->s_clustersize_bits) / OCFS2_XATTR_BUCKET_SIZE;
diff --git a/fs/ocfs2/xattr_trusted.c b/fs/ocfs2/xattr_trusted.c
index 4c589c4..cc15d40 100644
--- a/fs/ocfs2/xattr_trusted.c
+++ b/fs/ocfs2/xattr_trusted.c
@@ -38,13 +38,11 @@
 #include "ocfs2_fs.h"
 #include "xattr.h"
 
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
 				       size_t list_size, const char *name,
 				       size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX) - 1;
+	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (list && total_len <= list_size) {
diff --git a/fs/ocfs2/xattr_user.c b/fs/ocfs2/xattr_user.c
index 93ba716..cb0bc41 100644
--- a/fs/ocfs2/xattr_user.c
+++ b/fs/ocfs2/xattr_user.c
@@ -38,13 +38,11 @@
 #include "ocfs2_fs.h"
 #include "xattr.h"
 
-#define XATTR_USER_PREFIX "user."
-
 static size_t ocfs2_xattr_user_list(struct inode *inode, char *list,
 				    size_t list_size, const char *name,
 				    size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_USER_PREFIX) - 1;
+	const size_t prefix_len = XATTR_USER_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-- 
1.5.4.1
