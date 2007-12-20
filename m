From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Dec 20 15:30:09 2007
Subject: [Ocfs2-devel] [PATCH 27/30] ocfs2: Handle missing vectorized
	fileops aio_read() and aio_write()
In-Reply-To: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1198193387-16606-26-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 027445c37282bc1ed26add45e573ad2d3e4860a5 in mainline vectorized
fileops aio_read() and aio_write(). This patch allows one to build ocfs2
with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |   33 +++++++++++++++++++++++++++++----
 4 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index d4cd518..f99b9f4 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -71,6 +71,7 @@ GENERIC_SEGMENT_CHECKS = @GENERIC_SEGMENT_CHECKS@
 FAULT_IN_VMOPS = @FAULT_IN_VMOPS@
 SOP_IS_CONST = @SOP_IS_CONST@
 IOP_IS_CONST = @IOP_IS_CONST@
+VECTORED_FILE_AIO = @VECTORED_FILE_AIO@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index 8a23983..741dfdb 100644
--- a/configure.in
+++ b/configure.in
@@ -282,6 +282,11 @@ OCFS2_CHECK_KERNEL([i_op declared as const in struct inode in fs.h], fs.h,
   IOP_IS_CONST=yes, , [^.*const struct inode_operations.*\*i_op;])
 AC_SUBST(IOP_IS_CONST)
 
+VECTORED_FILE_AIO=
+OCFS2_CHECK_KERNEL([aio_read() in struct file_operations using iovec in fs.h], fs.h,
+  VECTORED_FILE_AIO=yes, , [ssize_t (\*aio_read) (struct kiocb \*, const struct iovec \*, unsigned long, loff_t);])
+AC_SUBST(VECTORED_FILE_AIO)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 97912fd..80fd6c6 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -73,6 +73,10 @@ ifdef IOP_IS_CONST
 EXTRA_CFLAGS += -DIOP_IS_CONST
 endif
 
+ifdef VECTORED_FILE_AIO
+EXTRA_CFLAGS += -DVECTORED_FILE_AIO
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e74730d..1ee2a79 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2087,10 +2087,19 @@ out:
 	return total ? total : ret;
 }
 
+#ifdef VECTORED_FILE_AIO
+#define iocb_ki_left	iocb->ki_left
 static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 				    const struct iovec *iov,
 				    unsigned long nr_segs,
 				    loff_t pos)
+#else
+#define iocb_ki_left	buflen
+static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
+				    const char __user *buf,
+				    size_t buflen,
+				    loff_t pos)
+#endif
 {
 	int ret, direct_io, appending, rw_level, have_alloc_sem  = 0;
 	int can_do_direct, sync = 0;
@@ -2100,13 +2109,19 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	loff_t *ppos = &iocb->ki_pos;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path_dentry->d_inode;
+#ifndef VECTORED_FILE_AIO
+	struct iovec iov_local = { .iov_base = (void __user *)buf,
+				   .iov_len  = buflen };
+	const struct iovec *iov = &iov_local;
+	unsigned long nr_segs = 1;
+#endif
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", file,
 		   (unsigned int)nr_segs,
 		   file->f_path_dentry->d_name.len,
 		   file->f_path_dentry->d_name.name);
 
-	if (iocb->ki_left == 0)
+	if (iocb_ki_left == 0)
 		return 0;
 
 	ret = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
@@ -2139,7 +2154,7 @@ relock:
 
 	can_do_direct = direct_io;
 	ret = ocfs2_prepare_inode_for_write(file->f_path_dentry, ppos,
-					    iocb->ki_left, appending,
+					    iocb_ki_left, appending,
 					    &can_do_direct);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2392,17 +2407,23 @@ bail:
 	return ret;
 }
 
+#ifdef VECTORED_FILE_AIO
 static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 				   const struct iovec *iov,
 				   unsigned long nr_segs,
 				   loff_t pos)
+#else
+static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
+				   char __user *buf,
+				   size_t buflen,
+				   loff_t pos)
+#endif
 {
 	int ret = 0, rw_level = -1, have_alloc_sem = 0, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = filp->f_path_dentry->d_inode;
 
-	mlog_entry("(0x%p, %u, '%.*s')\n", filp,
-		   (unsigned int)nr_segs,
+	mlog_entry("(0x%p, '%.*s')\n", filp,
 		   filp->f_path_dentry->d_name.len,
 		   filp->f_path_dentry->d_name.name);
 
@@ -2446,7 +2467,11 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	}
 	ocfs2_meta_unlock(inode, lock_level);
 
+#ifdef VECTORED_FILE_AIO
 	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
+#else
+	ret = generic_file_aio_read(iocb, buf, buflen, iocb->ki_pos);
+#endif
 	if (ret == -EINVAL)
 		mlog(ML_ERROR, "generic_file_aio_read returned -EINVAL\n");
 
-- 
1.5.2.5
