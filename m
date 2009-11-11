From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 10 Nov 2009 17:38:24 -0800
Subject: [Ocfs2-devel] [PATCH 2/8] ocfs2: Handle non-const inode->i_op
In-Reply-To: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
References: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257903510-29198-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit c5ef1c42c51b1b5b4a401a6517bdda30933ddbaf const-ified inode->i_op.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
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
 fs/ocfs2/symlink.c    |    9 +++++++++
 fs/ocfs2/symlink.h    |    5 +++++
 11 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 18edfa8..2c18b6f 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -63,6 +63,7 @@ NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
 ADDRESS_SPACE_OPS_EXT = @ADDRESS_SPACE_OPS_EXT@
 FVERSION_IS_ULONG = @FVERSION_IS_ULONG@
 SEQ_OPS_IS_NOT_CONST = @SEQ_OPS_IS_NOT_CONST@
+IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index b1aaf4e..16d02c3 100644
--- a/configure.in
+++ b/configure.in
@@ -236,6 +236,11 @@ OCFS2_CHECK_KERNEL([const struct seq_operations in seq_file.h], seq_file.h,
   , SEQ_OPS_IS_NOT_CONST=yes, [const struct seq_operations \*op;])
 AC_SUBST(SEQ_OPS_IS_NOT_CONST)
 
+IOP_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([inode->i_op has the const modifier in fs.h], fs.h,
+  , IOP_IS_NOT_CONST=yes, [^.*const struct inode_operations.*\*i_op;])
+AC_SUBST(IOP_IS_NOT_CONST)
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 37d3009..e66665a 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -60,6 +60,10 @@ ifdef SEQ_OPS_IS_NOT_CONST
 EXTRA_CFLAGS += -DSEQ_OPS_IS_NOT_CONST
 endif
 
+ifdef IOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index a42d35d..250994f 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -30,6 +30,10 @@ ifdef NO_F_PATH_IN_STRUCT_FILE
 EXTRA_CFLAGS += -DNO_F_PATH_IN_STRUCT_FILE
 endif
 
+ifdef IOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
+endif
+
 DLM_SOURCES +=			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 8e293fa..b1b9996 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -64,9 +64,15 @@
 
 static const struct super_operations dlmfs_ops;
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
@@ -553,14 +559,22 @@ static const struct file_operations dlmfs_file_operations = {
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
@@ -574,7 +588,11 @@ static const struct super_operations dlmfs_ops = {
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
index 68bf44f..7bac90d 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2245,7 +2245,11 @@ bail:
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
@@ -2257,7 +2261,11 @@ const struct inode_operations ocfs2_file_iops = {
 	.fiemap		= ocfs2_fiemap,
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
index d66cf4f..da85393 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -30,8 +30,13 @@ extern const struct file_operations ocfs2_fops;
 extern const struct file_operations ocfs2_dops;
 extern const struct file_operations ocfs2_fops_no_plocks;
 extern const struct file_operations ocfs2_dops_no_plocks;
+#ifdef IOP_IS_NOT_CONST
+extern struct inode_operations ocfs2_file_iops;
+extern struct inode_operations ocfs2_special_file_iops;
+#else
 extern const struct inode_operations ocfs2_file_iops;
 extern const struct inode_operations ocfs2_special_file_iops;
+#endif
 struct ocfs2_alloc_context;
 enum ocfs2_alloc_restarted;
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f010b22..f2df1eb 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2309,7 +2309,11 @@ leave:
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
index e5d059d..bc3792e 100644
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
index e342103..426584f 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -153,7 +153,11 @@ static void ocfs2_fast_put_link(struct dentry *dentry, struct nameidata *nd, voi
 	kfree(link);
 }
 
+#ifdef IOP_IS_NOT_CONST
+struct inode_operations ocfs2_symlink_inode_operations = {
+#else
 const struct inode_operations ocfs2_symlink_inode_operations = {
+#endif
 	.readlink	= page_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
@@ -164,7 +168,12 @@ const struct inode_operations ocfs2_symlink_inode_operations = {
 	.listxattr	= ocfs2_listxattr,
 	.removexattr	= generic_removexattr,
 };
+
+#ifdef IOP_IS_NOT_CONST
+struct inode_operations ocfs2_fast_symlink_inode_operations = {
+#else
 const struct inode_operations ocfs2_fast_symlink_inode_operations = {
+#endif
 	.readlink	= ocfs2_readlink,
 	.follow_link	= ocfs2_fast_follow_link,
 	.put_link	= ocfs2_fast_put_link,
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
1.5.6.5
