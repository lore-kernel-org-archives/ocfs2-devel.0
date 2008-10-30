From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 30 Oct 2008 19:41:56 +0800
Subject: [Ocfs2-devel] [PATCH 12/15] ocfs2: add ocfs2_check_acl
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <1225366916-6435-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This functions use to enhance permission checking with
POSIX ACL.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/acl.c  |   15 +++++++++++++++
 fs/ocfs2/acl.h  |   10 ++++++++++
 fs/ocfs2/file.c |    3 ++-
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 1f20e73..584da84 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -273,6 +273,21 @@ static int ocfs2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 	return ret;
 }
 
+int ocfs2_check_acl(struct inode *inode, int mask)
+{
+	struct posix_acl *acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl) {
+		int ret = posix_acl_permission(inode, acl, mask);
+		posix_acl_release(acl);
+		return ret;
+	}
+
+	return -EAGAIN;
+}
+
 static size_t ocfs2_xattr_list_acl_access(struct inode *inode,
 					  char *list,
 					  size_t list_len,
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index 1b39f3e..fef10f1 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -26,4 +26,14 @@ struct ocfs2_acl_entry {
 	__le32 e_id;
 };
 
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+
+extern int ocfs2_check_acl(struct inode *, int);
+
+#else /* CONFIG_OCFS2_FS_POSIX_ACL*/
+
+#define ocfs2_check_acl NULL
+
+#endif /* CONFIG_OCFS2_FS_POSIX_ACL*/
+
 #endif /* OCFS2_ACL_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1df4850..5a45b6b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -56,6 +56,7 @@
 #include "suballoc.h"
 #include "super.h"
 #include "xattr.h"
+#include "acl.h"
 
 #include "buffer_head_io.h"
 
@@ -1036,7 +1037,7 @@ int ocfs2_permission(struct inode *inode, int mask)
 		goto out;
 	}
 
-	ret = generic_permission(inode, mask, NULL);
+	ret = generic_permission(inode, mask, ocfs2_check_acl);
 
 	ocfs2_inode_unlock(inode, 0);
 out:
-- 
1.5.4.1
