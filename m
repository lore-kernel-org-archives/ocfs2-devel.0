From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 19:39:59 -0800
Subject: [Ocfs2-devel] [PATCH 2/8] ocfs2: Handle missing vectorized fileops
	aio_read() and aio_write()
In-Reply-To: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
References: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257997205-18055-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 027445c37282bc1ed26add45e573ad2d3e4860a5 vectorized fileops
aio_read() and aio_write().

Patch provides support for the non-vectorized fileops (in EL5) by hand crafting
the iovec with the provided buf and buflen.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in               |    1 +
 Makefile                     |    3 +-
 configure.in                 |    6 ++++
 fs/ocfs2/Makefile            |    4 +++
 fs/ocfs2/file.c              |    6 ++--
 fs/ocfs2/kapi-default.h      |    7 +++++
 kapi-compat/include/aiovec.h |   57 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 80 insertions(+), 4 deletions(-)
 create mode 100644 kapi-compat/include/aiovec.h

diff --git a/Config.make.in b/Config.make.in
index 2e5ff54..d129c64 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -70,6 +70,7 @@ EXPORTOP_IS_NOT_CONST = @EXPORTOP_IS_NOT_CONST@
 MATCHTABLE_IS_NOT_CONST = @MATCHTABLE_IS_NOT_CONST@
 VMOP_IS_NOT_CONST = @VMOP_IS_NOT_CONST@
 SEQOP_IS_NOT_CONST = @SEQOP_IS_NOT_CONST@
+NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/Makefile b/Makefile
index 6676daf..140b9cd 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/fpath.h			\
 	kapi-compat/include/ushortmax.h			\
 	kapi-compat/include/fversion.h			\
-	kapi-compat/include/relatime.h
+	kapi-compat/include/relatime.h			\
+	kapi-compat/include/aiovec.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 07325c3..0b98e28 100644
--- a/configure.in
+++ b/configure.in
@@ -276,6 +276,12 @@ OCFS2_CHECK_KERNEL([MNT_RELATIME in mount.h], mount.h,
   , relatime_compat_header=relatime.h, [^#define MNT_RELATIME])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $relatime_compat_header"
 
+NO_VECTORIZED_AIO=
+OCFS2_CHECK_KERNEL([aio_read() in struct file_operations using iovec in fs.h], fs.h,
+  , NO_VECTORIZED_AIO=aiovec.h, [ssize_t (\*aio_read) (struct kiocb \*, const struct iovec \*, unsigned long, loff_t);])
+AC_SUBST(NO_VECTORIZED_AIO)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_VECTORIZED_AIO"
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 1b19e4c..df389bc 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -84,6 +84,10 @@ ifdef VMOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DVMOP_IS_NOT_CONST
 endif
 
+ifdef NO_VECTORIZED_AIO
+CFLAGS_file.o += -DNO_VECTORIZED_AIO
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 7bac90d..f5e8681 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1892,7 +1892,7 @@ out:
 	return ret;
 }
 
-static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
+static ssize_t __ocfs2_file_aio_write(struct kiocb *iocb,
 				    const struct iovec *iov,
 				    unsigned long nr_segs,
 				    loff_t pos)
@@ -2168,7 +2168,7 @@ bail:
 	return ret;
 }
 
-static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
+static ssize_t __ocfs2_file_aio_read(struct kiocb *iocb,
 				   const struct iovec *iov,
 				   unsigned long nr_segs,
 				   loff_t pos)
@@ -2222,7 +2222,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	}
 	ocfs2_inode_unlock(inode, lock_level);
 
-	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
+	ret = kapi_generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
 	if (ret == -EINVAL)
 		mlog(0, "generic_file_aio_read returned -EINVAL\n");
 
diff --git a/fs/ocfs2/kapi-default.h b/fs/ocfs2/kapi-default.h
index 3f04924..d068aaf 100644
--- a/fs/ocfs2/kapi-default.h
+++ b/fs/ocfs2/kapi-default.h
@@ -39,4 +39,11 @@ typedef struct work_struct kapi_work_struct_t;
 typedef u64 f_version_t;
 #endif
 
+#ifndef kapi_generic_file_aio_read
+# define kapi_generic_file_aio_read(a, b, c, d) \
+				generic_file_aio_read(a, b, c, d)
+# define ocfs2_file_aio_read	__ocfs2_file_aio_read
+# define ocfs2_file_aio_write	__ocfs2_file_aio_write
+#endif
+
 #endif
diff --git a/kapi-compat/include/aiovec.h b/kapi-compat/include/aiovec.h
new file mode 100644
index 0000000..0c4c312
--- /dev/null
+++ b/kapi-compat/include/aiovec.h
@@ -0,0 +1,57 @@
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
+#endif
+
+#endif
-- 
1.5.6.5
