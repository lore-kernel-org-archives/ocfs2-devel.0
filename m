From: Jeff Mahoney <jeffm@suse.com>
Date: Thu Jan 31 12:55:55 2008
Subject: [Ocfs2-devel] [patch 3/5] ocfs2: Add check for const file_operations
References: <20080131204634.478915000@suse.com>
Message-ID: <20080131204715.623639000@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 SLES10 doesn't have a const f_op in struct file. This patch adds a check.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 Config.make.in        |    1 +
 configure.in          |    5 +++++
 fs/ocfs2/Makefile     |    4 ++++
 fs/ocfs2/dlm/Makefile |    4 ++++
 fs/ocfs2/dlm/dlmfs.c  |    8 ++++++++
 fs/ocfs2/dlmglue.c    |    4 ++++
 fs/ocfs2/file.c       |    8 ++++++++
 fs/ocfs2/file.h       |    5 +++++
 8 files changed, 39 insertions(+)

diff --git a/Config.make.in b/Config.make.in
index 5b58fe1..dc5431b 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -72,6 +72,7 @@ NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 NO_GENERIC_SEGMENT_CHECKS = @NO_GENERIC_SEGMENT_CHECKS@
 SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
 IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
+FOP_IS_NOT_CONST = @FOP_IS_NOT_CONST@
 NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
 NO_SPLICE_FROM_PIPE = @NO_SPLICE_FROM_PIPE@
 OLD_BIO_END_IO = @OLD_BIO_END_IO@
diff --git a/configure.in b/configure.in
index d1ebeae..3d9e49f 100644
--- a/configure.in
+++ b/configure.in
@@ -305,6 +305,11 @@ OCFS2_CHECK_KERNEL([i_op declared as const in struct inode in fs.h], fs.h,
   , IOP_IS_NOT_CONST=yes, [^.*const struct inode_operations.*\*i_op;])
 AC_SUBST(IOP_IS_NOT_CONST)
 
+FOP_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([f_op declared as const in struct file in fs.h], fs.h,
+  , FOP_IS_NOT_CONST=yes, [^.*const struct file_operations.*\*f_op;])
+AC_SUBST(FOP_IS_NOT_CONST)
+
 NO_VECTORIZED_AIO=
 OCFS2_CHECK_KERNEL([aio_read() in struct file_operations using iovec in fs.h], fs.h,
   , NO_VECTORIZED_AIO=yes, [ssize_t (\*aio_read) (struct kiocb \*, const struct iovec \*, unsigned long, loff_t);])
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index b53630d..5750280 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -84,6 +84,10 @@ ifdef IOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
 endif
 
+ifdef FOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DFOP_IS_NOT_CONST
+endif
+
 ifdef NO_VECTORIZED_AIO
 CFLAGS_file.o += -DNO_VECTORIZED_AIO
 endif
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 74bd019..4b718cf 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -46,6 +46,10 @@ ifdef IOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
 endif
 
+ifdef FOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DFOP_IS_NOT_CONST
+endif
+
 ifdef NO_VFSMOUNT_IN_GET_SB_BDEV
 EXTRA_CFLAGS += -DNO_VFSMOUNT_IN_GET_SB_BDEV
 endif
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index ba35f76..f7e0263 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -65,7 +65,11 @@ static struct super_operations dlmfs_ops;
 #else
 static const struct super_operations dlmfs_ops;
 #endif
+#ifdef FOP_IS_NOT_CONST
+static struct file_operations dlmfs_file_operations;
+#else
 static const struct file_operations dlmfs_file_operations;
+#endif
 #ifdef IOP_IS_NOT_CONST
 static struct inode_operations dlmfs_dir_inode_operations;
 static struct inode_operations dlmfs_root_inode_operations;
@@ -546,7 +550,11 @@ static int dlmfs_fill_super(struct super_block * sb,
 	return 0;
 }
 
+#ifdef FOP_IS_NOT_CONST
+static struct file_operations dlmfs_file_operations = {
+#else
 static const struct file_operations dlmfs_file_operations = {
+#endif
 	.open		= dlmfs_file_open,
 	.release	= dlmfs_file_release,
 	.read		= dlmfs_file_read,
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 9ce2881..04f9ec3 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2441,7 +2441,11 @@ out:
 	return ret;
 }
 
+#ifdef FOP_IS_NOT_CONST
+static struct file_operations ocfs2_dlm_debug_fops = {
+#else
 static const struct file_operations ocfs2_dlm_debug_fops = {
+#endif
 	.open =		ocfs2_dlm_debug_open,
 	.release =	ocfs2_dlm_debug_release,
 	.read =		seq_read,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 40122fe..e068a76 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2488,7 +2488,11 @@ const struct inode_operations ocfs2_special_file_iops = {
 	.permission	= ocfs2_permission,
 };
 
+#ifdef FOP_IS_NOT_CONST
+struct file_operations ocfs2_fops = {
+#else
 const struct file_operations ocfs2_fops = {
+#endif
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
@@ -2509,7 +2513,11 @@ const struct file_operations ocfs2_fops = {
 #endif
 };
 
+#ifdef FOP_IS_NOT_CONST
+struct file_operations ocfs2_dops = {
+#else
 const struct file_operations ocfs2_dops = {
+#endif
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ocfs2_readdir,
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 8cf0821..2b118b8 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -26,8 +26,13 @@
 #ifndef OCFS2_FILE_H
 #define OCFS2_FILE_H
 
+#ifdef FOP_IS_NOT_CONST
+extern struct file_operations ocfs2_fops;
+extern struct file_operations ocfs2_dops;
+#else
 extern const struct file_operations ocfs2_fops;
 extern const struct file_operations ocfs2_dops;
+#endif
 #ifdef IOP_IS_NOT_CONST
 extern struct inode_operations ocfs2_file_iops;
 extern struct inode_operations ocfs2_special_file_iops;
