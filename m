From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Jan  3 11:21:56 2008
Subject: [Ocfs2-devel] [PATCH 27/30] ocfs2: Handle missing vectorized
	fileops aio_read() and aio_write()
In-Reply-To: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199388006-32658-26-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 027445c37282bc1ed26add45e573ad2d3e4860a5 in mainline vectorized
fileops aio_read() and aio_write(). This patch allows one to build ocfs2
with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in               |    1 +
 Makefile                     |    3 +-
 configure.in                 |    6 ++++
 fs/ocfs2/Makefile            |    4 ++
 fs/ocfs2/file.c              |    6 ++--
 kapi-compat/include/aiovec.h |   68 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 84 insertions(+), 4 deletions(-)
 create mode 100644 kapi-compat/include/aiovec.h

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
 
diff --git a/Makefile b/Makefile
index 9427ce6..a3a0c9d 100644
--- a/Makefile
+++ b/Makefile
@@ -27,7 +27,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/cap.h \
 	kapi-compat/include/relatime.h \
 	kapi-compat/include/should_remove_suid.h \
-	kapi-compat/include/generic_segment_checks.h
+	kapi-compat/include/generic_segment_checks.h \
+	kapi-compat/include/aiovec.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index a6f4336..8c30910 100644
--- a/configure.in
+++ b/configure.in
@@ -285,6 +285,12 @@ OCFS2_CHECK_KERNEL([i_op declared as const in struct inode in fs.h], fs.h,
   , IOP_IS_NOT_CONST=yes, [^.*const struct inode_operations.*\*i_op;])
 AC_SUBST(IOP_IS_NOT_CONST)
 
+NO_VECTORIZED_AIO=
+OCFS2_CHECK_KERNEL([aio_read() in struct file_operations using iovec in fs.h], fs.h,
+  , NO_VECTORIZED_AIO=yes, [ssize_t (\*aio_read) (struct kiocb \*, const struct iovec \*, unsigned long, loff_t);])
+AC_SUBST(NO_VECTORIZED_AIO)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS aiovec.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index a894c45..1646a9b 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -73,6 +73,10 @@ ifdef IOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
 endif
 
+ifdef NO_VECTORIZED_AIO
+CFLAGS_file.o += -DNO_VECTORIZED_AIO
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a19322e..62040aa 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2017,7 +2017,7 @@ out:
 	return total ? total : ret;
 }
 
-static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
+static ssize_t __ocfs2_file_aio_write(struct kiocb *iocb,
 				    const struct iovec *iov,
 				    unsigned long nr_segs,
 				    loff_t pos)
@@ -2322,7 +2322,7 @@ bail:
 	return ret;
 }
 
-static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
+static ssize_t __ocfs2_file_aio_read(struct kiocb *iocb,
 				   const struct iovec *iov,
 				   unsigned long nr_segs,
 				   loff_t pos)
@@ -2376,7 +2376,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	}
 	ocfs2_meta_unlock(inode, lock_level);
 
-	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
+	ret = kapi_generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
 	if (ret == -EINVAL)
 		mlog(ML_ERROR, "generic_file_aio_read returned -EINVAL\n");
 
diff --git a/kapi-compat/include/aiovec.h b/kapi-compat/include/aiovec.h
new file mode 100644
index 0000000..e6cb3fb
--- /dev/null
+++ b/kapi-compat/include/aiovec.h
@@ -0,0 +1,68 @@
+#ifndef KAPI_AIOVEC_H
+#define KAPI_AIOVEC_H
+
+#ifdef NO_VECTORIZED_AIO
+
+#include <linux/fs.h>
+#include <linux/uio.h>
+
+static ssize_t kapi_generic_file_aio_read(struct kiocb *iocb,
+					  const struct iovec *iov,
+					  unsigned long nr_segs,
+					  loff_t pos)
+{
+	BUG_ON(nr_segs != 1);
+	return generic_file_aio_read(iocb, iov->iov_base, iov->iov_len, pos);
+}
+
+static ssize_t __ocfs2_file_aio_read(struct kiocb *iocb,
+				     const struct iovec *iov,
+				     unsigned long nr_segs,
+				     loff_t pos);
+
+static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
+				   char __user *buf,
+				   size_t buflen,
+				   loff_t pos)
+{
+	struct iovec iov_local = { .iov_base = (void __user *)buf,
+				   .iov_len  = buflen };
+	const struct iovec *iov = &iov_local;
+	unsigned long nr_segs = 1;
+
+	return __ocfs2_file_aio_read(iocb, iov, nr_segs, pos);
+}
+
+static ssize_t __ocfs2_file_aio_write(struct kiocb *iocb,
+				      const struct iovec *iov,
+				      unsigned long nr_segs,
+				      loff_t pos);
+
+static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
+				    const char __user *buf,
+				    size_t buflen,
+				    loff_t pos)
+{
+	struct iovec iov_local = { .iov_base = (void __user *)buf,
+				   .iov_len  = buflen };
+	const struct iovec *iov = &iov_local;
+	unsigned long nr_segs = 1;
+
+	iocb->ki_left = buflen;
+	return __ocfs2_file_aio_write(iocb, iov, nr_segs, pos);
+}
+
+#else	/* ! NO_VECTORIZED_AIO */
+
+#define kapi_generic_file_aio_read(a, b, c, d) \
+			generic_file_aio_read(a, b, c, d)
+
+#define ocfs2_file_aio_read(a, b, c, d) \
+			__ocfs2_file_aio_read(a, b, c, d)
+
+#define ocfs2_file_aio_write(a, b, c, d) \
+			__ocfs2_file_aio_write(a, b, c, d)
+
+#endif
+
+#endif
-- 
1.5.2.5
