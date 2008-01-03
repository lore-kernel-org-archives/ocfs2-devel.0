From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Jan  3 11:21:57 2008
Subject: [Ocfs2-devel] [PATCH 28/30] ocfs2: Handle missing
	__splice_from_pipe()
In-Reply-To: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199388006-32658-27-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit c66ab6fa705e1b2887a6d9246b798bdc526839e2 in mainline introduced
__splice_from_pipe(). This patch allows one to build ocfs2 with kernels
having/not having this change.

Note: This patch disables splice io for kernels not providing
__splice_from_pipe(). We will later add a patch to enable splice
io with such kernels too.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |    4 ++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index c6deb57..114cf90 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -73,6 +73,7 @@ NO_GENERIC_SEGMENT_CHECKS = @NO_GENERIC_SEGMENT_CHECKS@
 SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
 IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
 NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
+NO_SPLICE_FROM_PIPE = @NO_SPLICE_FROM_PIPE@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index 8c30910..b1e7be6 100644
--- a/configure.in
+++ b/configure.in
@@ -291,6 +291,11 @@ OCFS2_CHECK_KERNEL([aio_read() in struct file_operations using iovec in fs.h], f
 AC_SUBST(NO_VECTORIZED_AIO)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS aiovec.h"
 
+NO_SPLICE_FROM_PIPE=
+OCFS2_CHECK_KERNEL([__splice_from_pipe() in splice.h], splice.h,
+  , NO_SPLICE_FROM_PIPE=yes, [^extern ssize_t __splice_from_pipe(struct pipe_inode_info \*])
+AC_SUBST(NO_SPLICE_FROM_PIPE)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 1646a9b..eb46c29 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -77,6 +77,10 @@ ifdef NO_VECTORIZED_AIO
 CFLAGS_file.o += -DNO_VECTORIZED_AIO
 endif
 
+ifdef NO_SPLICE_FROM_PIPE
+EXTRA_CFLAGS += -DNO_SPLICE_FROM_PIPE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 62040aa..ad73b3c 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2173,6 +2173,7 @@ out_sems:
 	return written ? written : ret;
 }
 
+#ifndef NO_SPLICE_FROM_PIPE
 static int ocfs2_splice_write_actor(struct pipe_inode_info *pipe,
 				    struct pipe_buffer *buf,
 				    struct splice_desc *sd)
@@ -2321,6 +2322,7 @@ bail:
 	mlog_exit(ret);
 	return ret;
 }
+#endif
 
 static ssize_t __ocfs2_file_aio_read(struct kiocb *iocb,
 				   const struct iovec *iov,
@@ -2435,8 +2437,10 @@ const struct file_operations ocfs2_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
+#ifndef NO_SPLICE_FROM_PIPE
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
+#endif
 };
 
 const struct file_operations ocfs2_dops = {
-- 
1.5.2.5
