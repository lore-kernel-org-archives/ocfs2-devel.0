From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Dec 31 14:25:50 2007
Subject: [Ocfs2-devel] [PATCH 27/30] ocfs2: Handle missing vectorized
	fileops aio_read() and aio_write()
In-Reply-To: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199139862-31452-26-git-send-email-sunil.mushran@oracle.com>
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
 fs/ocfs2/file.c   |   34 ++++++++++++++++++++++++++++++----
 4 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 4b2d1c5..c6deb57 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -72,6 +72,7 @@ NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 NO_GENERIC_SEGMENT_CHECKS = @NO_GENERIC_SEGMENT_CHECKS@
 SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
 IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
+NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index 9caf68d..248b167 100644
--- a/configure.in
+++ b/configure.in
@@ -285,6 +285,11 @@ OCFS2_CHECK_KERNEL([i_op declared as const in struct inode in fs.h], fs.h,
   , IOP_IS_NOT_CONST=yes, [^.*const struct inode_operations.*\*i_op;])
 AC_SUBST(IOP_IS_NOT_CONST)
 
+NO_VECTORIZED_AIO=
+OCFS2_CHECK_KERNEL([aio_read() in struct file_operations using iovec in fs.h], fs.h,
+  , NO_VECTORIZED_AIO=yes, [ssize_t (\*aio_read) (struct kiocb \*, const struct iovec \*, unsigned long, loff_t);])
+AC_SUBST(NO_VECTORIZED_AIO)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index a894c45..e85fcea 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -73,6 +73,10 @@ ifdef IOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
 endif
 
+ifdef NO_VECTORIZED_AIO
+EXTRA_CFLAGS += -DNO_VECTORIZED_AIO
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a19322e..a7b965a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2017,10 +2017,19 @@ out:
 	return total ? total : ret;
 }
 
+#ifdef NO_VECTORIZED_AIO
+#define iocb_ki_left	buflen
+static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
+				    const char __user *buf,
+				    size_t buflen,
+				    loff_t pos)
+#else
+#define iocb_ki_left	iocb->ki_left
 static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 				    const struct iovec *iov,
 				    unsigned long nr_segs,
 				    loff_t pos)
+#endif
 {
 	int ret, direct_io, appending, rw_level, have_alloc_sem  = 0;
 	int can_do_direct, sync = 0;
@@ -2030,13 +2039,20 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	loff_t *ppos = &iocb->ki_pos;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = filp_dentry(file)->d_inode;
+#ifdef NO_VECTORIZED_AIO
+	struct iovec iov_local = { .iov_base = (void __user *)buf,
+				   .iov_len  = buflen };
+	const struct iovec *iov = &iov_local;
+	unsigned long nr_segs = 1;
+#endif
+
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", file,
 		   (unsigned int)nr_segs,
 		   filp_dentry(file)->d_name.len,
 		   filp_dentry(file)->d_name.name);
 
-	if (iocb->ki_left == 0)
+	if (iocb_ki_left == 0)
 		return 0;
 
 	ret = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
@@ -2069,7 +2085,7 @@ relock:
 
 	can_do_direct = direct_io;
 	ret = ocfs2_prepare_inode_for_write(filp_dentry(file), ppos,
-					    iocb->ki_left, appending,
+					    iocb_ki_left, appending,
 					    &can_do_direct);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2322,17 +2338,23 @@ bail:
 	return ret;
 }
 
+#ifdef NO_VECTORIZED_AIO
+static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
+				   char __user *buf,
+				   size_t buflen,
+				   loff_t pos)
+#else
 static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 				   const struct iovec *iov,
 				   unsigned long nr_segs,
 				   loff_t pos)
+#endif
 {
 	int ret = 0, rw_level = -1, have_alloc_sem = 0, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = filp_dentry(filp)->d_inode;
 
-	mlog_entry("(0x%p, %u, '%.*s')\n", filp,
-		   (unsigned int)nr_segs,
+	mlog_entry("(0x%p, '%.*s')\n", filp,
 		   filp_dentry(filp)->d_name.len,
 		   filp_dentry(filp)->d_name.name);
 
@@ -2376,7 +2398,11 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	}
 	ocfs2_meta_unlock(inode, lock_level);
 
+#ifdef NO_VECTORIZED_AIO
+	ret = generic_file_aio_read(iocb, buf, buflen, iocb->ki_pos);
+#else
 	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
+#endif
 	if (ret == -EINVAL)
 		mlog(ML_ERROR, "generic_file_aio_read returned -EINVAL\n");
 
-- 
1.5.3.4
