From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Dec 20 15:29:59 2007
Subject: [Ocfs2-devel] [PATCH 28/30] ocfs2: Handle missing
	__splice_from_pipe()
In-Reply-To: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1198193387-16606-27-git-send-email-sunil.mushran@oracle.com>
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
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |    4 ++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index f99b9f4..89c1e94 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -72,6 +72,7 @@ FAULT_IN_VMOPS = @FAULT_IN_VMOPS@
 SOP_IS_CONST = @SOP_IS_CONST@
 IOP_IS_CONST = @IOP_IS_CONST@
 VECTORED_FILE_AIO = @VECTORED_FILE_AIO@
+SPLICE_FROM_PIPE = @SPLICE_FROM_PIPE@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index 741dfdb..021b925 100644
--- a/configure.in
+++ b/configure.in
@@ -287,6 +287,11 @@ OCFS2_CHECK_KERNEL([aio_read() in struct file_operations using iovec in fs.h], f
   VECTORED_FILE_AIO=yes, , [ssize_t (\*aio_read) (struct kiocb \*, const struct iovec \*, unsigned long, loff_t);])
 AC_SUBST(VECTORED_FILE_AIO)
 
+SPLICE_FROM_PIPE=
+OCFS2_CHECK_KERNEL([__splice_from_pipe() in splice.h], splice.h,
+  SPLICE_FROM_PIPE=yes, , [^extern ssize_t __splice_from_pipe(struct pipe_inode_info \*])
+AC_SUBST(SPLICE_FROM_PIPE)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 80fd6c6..e4296d3 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -77,6 +77,10 @@ ifdef VECTORED_FILE_AIO
 EXTRA_CFLAGS += -DVECTORED_FILE_AIO
 endif
 
+ifdef SPLICE_FROM_PIPE
+EXTRA_CFLAGS += -DSPLICE_FROM_PIPE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1ee2a79..e022c97 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2258,6 +2258,7 @@ out_sems:
 	return written ? written : ret;
 }
 
+#ifdef SPLICE_FROM_PIPE
 static int ocfs2_splice_write_actor(struct pipe_inode_info *pipe,
 				    struct pipe_buffer *buf,
 				    struct splice_desc *sd)
@@ -2406,6 +2407,7 @@ bail:
 	mlog_exit(ret);
 	return ret;
 }
+#endif
 
 #ifdef VECTORED_FILE_AIO
 static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
@@ -2530,8 +2532,10 @@ const struct file_operations ocfs2_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
+#ifdef SPLICE_FROM_PIPE
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
+#endif
 };
 
 const struct file_operations ocfs2_dops = {
-- 
1.5.2.5
