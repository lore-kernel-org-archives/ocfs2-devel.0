From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:37 -0800
Subject: [Ocfs2-devel] [PATCH 16/18] ocfs2: Handle missing struct path in
	struct nameidata
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-17-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 4ac9137858e08a19f29feac4e1f4df7c268b0ba5 embedded struct path
into struct nameidata. Mainline commit 2d8f30380ab8c706f4e0a8f1aaa22b5886e9ac8a
added new helpers like user_path_at() that passed struct path instead of struct
nameidata.

Patch adds access wrappers to allow building against current and EL5 kernels.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                           |    3 ++-
 configure.in                       |    5 +++++
 fs/ocfs2/kapi-default.h            |    9 +++++++++
 fs/ocfs2/refcounttree.c            |   18 +++++++++---------
 kapi-compat/include/user_path_at.h |   11 +++++++++++
 5 files changed, 36 insertions(+), 10 deletions(-)
 create mode 100644 kapi-compat/include/user_path_at.h

diff --git a/Makefile b/Makefile
index 8536d51..3447409 100644
--- a/Makefile
+++ b/Makefile
@@ -33,7 +33,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/bdi_init.h			\
 	kapi-compat/include/bdi_define.h		\
 	kapi-compat/include/inode_permission.h		\
-	kapi-compat/include/should_remove_suid.h
+	kapi-compat/include/should_remove_suid.h	\
+	kapi-compat/include/user_path_at.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 3b8fd4e..86dc11b 100644
--- a/configure.in
+++ b/configure.in
@@ -399,6 +399,11 @@ fi
 AC_SUBST(NO_SHOULD_REMOVE_SUID)
 AC_MSG_RESULT($enable_srsuid)
 
+user_path_header=
+OCFS2_CHECK_KERNEL([struct path in struct nameidata in namei.h], namei.h,
+ , user_path_header=user_path_at.h, [struct path.*path;])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $user_path_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/kapi-default.h b/fs/ocfs2/kapi-default.h
index 2f60b87..7b16678 100644
--- a/fs/ocfs2/kapi-default.h
+++ b/fs/ocfs2/kapi-default.h
@@ -54,4 +54,13 @@ typedef u64 f_version_t;
 # define kapi_kmem_cache_create(a, b, c, d, e)	kmem_cache_create(a, b, c, d, e)
 #endif
 
+#ifndef kapi_path
+# define kapi_path			path
+# define kapi_path_put			path_put
+# define kapi_user_path_at(a, b, c, d)	user_path_at(a, b, c, d)
+# define kapi_to_mnt(a)			(a).path.mnt
+# define kapi_to_dentry(a)		(a).path.dentry
+# define kapi_to_path_ptr(a)		(&(a).path)
+#endif
+
 #endif
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 60287fc..49771c3 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4260,14 +4260,14 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 {
 	struct dentry *new_dentry;
 	struct nameidata nd;
-	struct path old_path;
+	struct kapi_path old_path;
 	int error;
 	char *to = NULL;
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb)))
 		return -EOPNOTSUPP;
 
-	error = user_path_at(AT_FDCWD, oldname, 0, &old_path);
+	error = kapi_user_path_at(AT_FDCWD, oldname, 0, &old_path);
 	if (error) {
 		mlog_errno(error);
 		return error;
@@ -4280,7 +4280,7 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 	}
 
 	error = -EXDEV;
-	if (old_path.mnt != nd.path.mnt)
+	if (old_path.mnt != kapi_to_mnt(nd))
 		goto out_release;
 	new_dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(new_dentry);
@@ -4289,25 +4289,25 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 		goto out_unlock;
 	}
 
-	error = mnt_want_write(nd.path.mnt);
+	error = mnt_want_write(kapi_to_mnt(nd));
 	if (error) {
 		mlog_errno(error);
 		goto out_dput;
 	}
 
 	error = ocfs2_vfs_reflink(old_path.dentry,
-				  nd.path.dentry->d_inode,
+				  kapi_to_dentry(nd)->d_inode,
 				  new_dentry, preserve);
-	mnt_drop_write(nd.path.mnt);
+	mnt_drop_write(kapi_to_mnt(nd));
 out_dput:
 	dput(new_dentry);
 out_unlock:
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+	mutex_unlock(&kapi_to_dentry(nd)->d_inode->i_mutex);
 out_release:
-	path_put(&nd.path);
+	kapi_path_put(kapi_to_path_ptr(nd));
 	putname(to);
 out:
-	path_put(&old_path);
+	kapi_path_put(&old_path);
 
 	return error;
 }
diff --git a/kapi-compat/include/user_path_at.h b/kapi-compat/include/user_path_at.h
new file mode 100644
index 0000000..fc11d36
--- /dev/null
+++ b/kapi-compat/include/user_path_at.h
@@ -0,0 +1,11 @@
+#ifndef KAPI_USER_WALK_AT_H
+#define KAPI_USER_WALK_AT_H
+
+#define	kapi_path			nameidata
+#define kapi_path_put			path_release
+#define kapi_user_path_at(a, b, c, d)	__user_walk(b, c, d)
+#define kapi_to_mnt(a)			(a).mnt
+#define kapi_to_dentry(a)		(a).dentry
+#define kapi_to_path_ptr(a)		(&(a))
+
+#endif
-- 
1.5.6.5
