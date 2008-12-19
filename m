From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:47 -0800
Subject: [Ocfs2-devel] [PATCH 28/45] ocfs2: add ocfs2_check_acl
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-29-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tiger Yang <tiger.yang@oracle.com>

This function is used to enhance permission checking with POSIX ACLs.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/acl.c  |   15 +++++++++++++++
 fs/ocfs2/acl.h  |   10 ++++++++++
 fs/ocfs2/file.c |    3 ++-
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 62d0faa..a6a2bf6 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -230,6 +230,21 @@ static int ocfs2_set_acl(handle_t *handle,
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
index 3605491..7bad7d9 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -56,6 +56,7 @@
 #include "suballoc.h"
 #include "super.h"
 #include "xattr.h"
+#include "acl.h"
 
 #include "buffer_head_io.h"
 
@@ -1035,7 +1036,7 @@ int ocfs2_permission(struct inode *inode, int mask)
 		goto out;
 	}
 
-	ret = generic_permission(inode, mask, NULL);
+	ret = generic_permission(inode, mask, ocfs2_check_acl);
 
 	ocfs2_inode_unlock(inode, 0);
 out:
-- 
1.5.6
