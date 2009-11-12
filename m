From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 19:40:00 -0800
Subject: [Ocfs2-devel] [PATCH 3/8] ocfs2: Handle older prototype of
	iops->permission()
In-Reply-To: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
References: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257997205-18055-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e6305c43eda10ebfd2ad9e35d6e172ccc7bb3695 changed the prototype
of iops->permission() by dropping the last argument.
-       int (*permission) (struct inode *, int, struct nameidata *);
+       int (*permission) (struct inode *, int);

Patch allows building with kernels having the older prototype.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |   13 +++++++++++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |    4 ++++
 fs/ocfs2/file.h   |    4 ++++
 5 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index d129c64..a19d096 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -71,6 +71,7 @@ MATCHTABLE_IS_NOT_CONST = @MATCHTABLE_IS_NOT_CONST@
 VMOP_IS_NOT_CONST = @VMOP_IS_NOT_CONST@
 SEQOP_IS_NOT_CONST = @SEQOP_IS_NOT_CONST@
 NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
+OLD_PERMISSION = @OLD_PERMISSION@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 0b98e28..a1c4255 100644
--- a/configure.in
+++ b/configure.in
@@ -282,6 +282,19 @@ OCFS2_CHECK_KERNEL([aio_read() in struct file_operations using iovec in fs.h], f
 AC_SUBST(NO_VECTORIZED_AIO)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_VECTORIZED_AIO"
 
+OLD_PERSMISSION=
+OCFS2_CHECK_KERNEL([	older prototype of iops->permission() in fs.h], fs.h,
+OLD_PERSMISSION=yes, , [int (\*permission) (struct inode \*, int, struct nameidata \*);])
+AC_SUBST(OLD_PERSMISSION)
+if test "x$OLD_PERSMISSION" = "x" ; then
+  new_permission=
+  OCFS2_CHECK_KERNEL([	newer prototype of iops->permission() in fs.h], fs.h,
+  new_permission=yes, , [int (\*permission) (struct inode \*, int);])
+  if test "x$new_permission" = "x" ; then
+    AC_MSG_ERROR(Cannot build with kernel as the prototype of iops->permission is not recognized)
+  fi
+fi
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index df389bc..32d864d 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -88,6 +88,10 @@ ifdef NO_VECTORIZED_AIO
 CFLAGS_file.o += -DNO_VECTORIZED_AIO
 endif
 
+ifdef OLD_PERMISSION
+EXTRA_CFLAGS += -DOLD_PERMISSION
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index f5e8681..4c12c2d 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1138,7 +1138,11 @@ bail:
 	return err;
 }
 
+#ifdef OLD_PERMISSION
+int ocfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+#else
 int ocfs2_permission(struct inode *inode, int mask)
+#endif
 {
 	int ret;
 
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index da85393..845ea30 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -64,7 +64,11 @@ int ocfs2_extend_no_holes(struct inode *inode, u64 new_i_size,
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
+#ifdef OLD_PERMISSION
+int ocfs2_permission(struct inode *inode, int mask, struct nameidata *nd);
+#else
 int ocfs2_permission(struct inode *inode, int mask);
+#endif
 
 int ocfs2_should_update_atime(struct inode *inode,
 			      struct vfsmount *vfsmnt);
-- 
1.5.6.5
