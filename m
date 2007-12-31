From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Dec 31 14:25:48 2007
Subject: [Ocfs2-devel] [PATCH 26/30] ocfs2: Handle missing const struct
	inode_operations in struct inode
In-Reply-To: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199139862-31452-25-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit c5ef1c42c51b1b5b4a401a6517bdda30933ddbaf in mainline marks struct
inode_operations in struct inode as a const. This patch allows one to build
ocfs2 with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in        |    1 +
 configure.in          |    5 +++++
 fs/ocfs2/Makefile     |    4 ++++
 fs/ocfs2/dlm/Makefile |    4 ++++
 fs/ocfs2/dlm/dlmfs.c  |   18 ++++++++++++++++++
 fs/ocfs2/file.c       |    8 ++++++++
 fs/ocfs2/file.h       |    5 +++++
 fs/ocfs2/namei.c      |    4 ++++
 fs/ocfs2/namei.h      |    4 ++++
 fs/ocfs2/symlink.c    |    8 ++++++++
 fs/ocfs2/symlink.h    |    5 +++++
 11 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 8479f37..4b2d1c5 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -71,6 +71,7 @@ NO_SPLICE_HEADER = @NO_SPLICE_HEADER@
 NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 NO_GENERIC_SEGMENT_CHECKS = @NO_GENERIC_SEGMENT_CHECKS@
 SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
+IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index cba4609..9caf68d 100644
--- a/configure.in
+++ b/configure.in
@@ -280,6 +280,11 @@ OCFS2_CHECK_KERNEL([s_op declared as const in struct super_block in fs.h], fs.h,
   , SOP_IS_NOT_CONST=yes, [^.*const struct super_operations.*\*s_op;])
 AC_SUBST(SOP_IS_NOT_CONST)
 
+IOP_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([i_op declared as const in struct inode in fs.h], fs.h,
+  , IOP_IS_NOT_CONST=yes, [^.*const struct inode_operations.*\*i_op;])
+AC_SUBST(IOP_IS_NOT_CONST)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 5a8a838..a894c45 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -69,6 +69,10 @@ ifdef SOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DSOP_IS_NOT_CONST
 endif
 
+ifdef IOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 5108301..30a8d43 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -36,6 +36,10 @@ ifdef SOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DSOP_IS_NOT_CONST
 endif
 
+ifdef IOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
+endif
+
 DLM_SOURCES =			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 6d57554..db6d582 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -66,9 +66,15 @@ static struct super_operations dlmfs_ops;
 static const struct super_operations dlmfs_ops;
 #endif
 static const struct file_operations dlmfs_file_operations;
+#ifdef IOP_IS_NOT_CONST
+static struct inode_operations dlmfs_dir_inode_operations;
+static struct inode_operations dlmfs_root_inode_operations;
+static struct inode_operations dlmfs_file_inode_operations;
+#else
 static const struct inode_operations dlmfs_dir_inode_operations;
 static const struct inode_operations dlmfs_root_inode_operations;
 static const struct inode_operations dlmfs_file_inode_operations;
+#endif
 static struct kmem_cache *dlmfs_inode_cache;
 
 struct workqueue_struct *user_dlm_worker;
@@ -547,14 +553,22 @@ static const struct file_operations dlmfs_file_operations = {
 	.write		= dlmfs_file_write,
 };
 
+#ifdef IOP_IS_NOT_CONST
+static struct inode_operations dlmfs_dir_inode_operations = {
+#else
 static const struct inode_operations dlmfs_dir_inode_operations = {
+#endif
 	.create		= dlmfs_create,
 	.lookup		= simple_lookup,
 	.unlink		= dlmfs_unlink,
 };
 
 /* this way we can restrict mkdir to only the toplevel of the fs. */
+#ifdef IOP_IS_NOT_CONST
+static struct inode_operations dlmfs_root_inode_operations = {
+#else
 static const struct inode_operations dlmfs_root_inode_operations = {
+#endif
 	.lookup		= simple_lookup,
 	.mkdir		= dlmfs_mkdir,
 	.rmdir		= simple_rmdir,
@@ -572,7 +586,11 @@ static const struct super_operations dlmfs_ops = {
 	.drop_inode	= generic_delete_inode,
 };
 
+#ifdef IOP_IS_NOT_CONST
+static struct inode_operations dlmfs_file_inode_operations = {
+#else
 static const struct inode_operations dlmfs_file_inode_operations = {
+#endif
 	.getattr	= simple_getattr,
 };
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ad38a21..a19322e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2399,7 +2399,11 @@ bail:
 	return ret;
 }
 
+#ifdef IOP_IS_NOT_CONST
+struct inode_operations ocfs2_file_iops = {
+#else
 const struct inode_operations ocfs2_file_iops = {
+#endif
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
@@ -2408,7 +2412,11 @@ const struct inode_operations ocfs2_file_iops = {
 #endif
 };
 
+#ifdef IOP_IS_NOT_CONST
+struct inode_operations ocfs2_special_file_iops = {
+#else
 const struct inode_operations ocfs2_special_file_iops = {
+#endif
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 066f14a..807795a 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -28,8 +28,13 @@
 
 extern const struct file_operations ocfs2_fops;
 extern const struct file_operations ocfs2_dops;
+#ifdef IOP_IS_NOT_CONST
+extern struct inode_operations ocfs2_file_iops;
+extern struct inode_operations ocfs2_special_file_iops;
+#else
 extern const struct inode_operations ocfs2_file_iops;
 extern const struct inode_operations ocfs2_special_file_iops;
+#endif
 struct ocfs2_alloc_context;
 
 enum ocfs2_alloc_restarted {
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 7292590..6d822b7 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1898,7 +1898,11 @@ leave:
 	return status;
 }
 
+#ifdef IOP_IS_NOT_CONST
+struct inode_operations ocfs2_dir_iops = {
+#else
 const struct inode_operations ocfs2_dir_iops = {
+#endif
 	.create		= ocfs2_create,
 	.lookup		= ocfs2_lookup,
 	.link		= ocfs2_link,
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index 688aef6..8022f3c 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -26,7 +26,11 @@
 #ifndef OCFS2_NAMEI_H
 #define OCFS2_NAMEI_H
 
+#ifdef IOP_IS_NOT_CONST
+extern struct inode_operations ocfs2_dir_iops;
+#else
 extern const struct inode_operations ocfs2_dir_iops;
+#endif
 
 struct dentry *ocfs2_get_parent(struct dentry *child);
 
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 7134007..9794649 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -163,12 +163,20 @@ bail:
 	return ERR_PTR(status);
 }
 
+#ifdef IOP_IS_NOT_CONST
+struct inode_operations ocfs2_symlink_inode_operations = {
+#else
 const struct inode_operations ocfs2_symlink_inode_operations = {
+#endif
 	.readlink	= page_readlink,
 	.follow_link	= ocfs2_follow_link,
 	.getattr	= ocfs2_getattr,
 };
+#ifdef IOP_IS_NOT_CONST
+struct inode_operations ocfs2_fast_symlink_inode_operations = {
+#else
 const struct inode_operations ocfs2_fast_symlink_inode_operations = {
+#endif
 	.readlink	= ocfs2_readlink,
 	.follow_link	= ocfs2_follow_link,
 	.getattr	= ocfs2_getattr,
diff --git a/fs/ocfs2/symlink.h b/fs/ocfs2/symlink.h
index 65a6c9c..f53d1e0 100644
--- a/fs/ocfs2/symlink.h
+++ b/fs/ocfs2/symlink.h
@@ -26,8 +26,13 @@
 #ifndef OCFS2_SYMLINK_H
 #define OCFS2_SYMLINK_H
 
+#ifdef IOP_IS_NOT_CONST
+extern struct inode_operations ocfs2_symlink_inode_operations;
+extern struct inode_operations ocfs2_fast_symlink_inode_operations;
+#else
 extern const struct inode_operations ocfs2_symlink_inode_operations;
 extern const struct inode_operations ocfs2_fast_symlink_inode_operations;
+#endif
 
 /*
  * Test whether an inode is a fast symlink.
-- 
1.5.3.4
