From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:48 -0800
Subject: [Ocfs2-devel] [PATCH 29/45] ocfs2: add ocfs2_acl_chmod
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-30-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tiger Yang <tiger.yang@oracle.com>

This function is used to update acl xattrs during file mode changes.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/acl.c  |   27 +++++++++++++++++++++++++++
 fs/ocfs2/acl.h  |    5 +++++
 fs/ocfs2/file.c |    6 ++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index a6a2bf6..df72256 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -245,6 +245,33 @@ int ocfs2_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
+int ocfs2_acl_chmod(struct inode *inode)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct posix_acl *acl, *clone;
+	int ret;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return 0;
+
+	acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+	clone = posix_acl_clone(acl, GFP_KERNEL);
+	posix_acl_release(acl);
+	if (!clone)
+		return -ENOMEM;
+	ret = posix_acl_chmod_masq(clone, inode->i_mode);
+	if (!ret)
+		ret = ocfs2_set_acl(NULL, inode, NULL, ACL_TYPE_ACCESS,
+				    clone, NULL, NULL);
+	posix_acl_release(clone);
+	return ret;
+}
+
 static size_t ocfs2_xattr_list_acl_access(struct inode *inode,
 					  char *list,
 					  size_t list_len,
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index fef10f1..68ffd64 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -29,10 +29,15 @@ struct ocfs2_acl_entry {
 #ifdef CONFIG_OCFS2_FS_POSIX_ACL
 
 extern int ocfs2_check_acl(struct inode *, int);
+extern int ocfs2_acl_chmod(struct inode *);
 
 #else /* CONFIG_OCFS2_FS_POSIX_ACL*/
 
 #define ocfs2_check_acl NULL
+static inline int ocfs2_acl_chmod(struct inode *inode)
+{
+	return 0;
+}
 
 #endif /* CONFIG_OCFS2_FS_POSIX_ACL*/
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 7bad7d9..4636aa6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -990,6 +990,12 @@ bail_unlock_rw:
 bail:
 	brelse(bh);
 
+	if (!status && attr->ia_valid & ATTR_MODE) {
+		status = ocfs2_acl_chmod(inode);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
 	mlog_exit(status);
 	return status;
 }
-- 
1.5.6
