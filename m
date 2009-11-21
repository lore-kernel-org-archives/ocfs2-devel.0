From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:49 -0800
Subject: [Ocfs2-devel] [PATCH 02/10] ocfs2: Temporarily disable splice i/o
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch disables splice i/o temporarily. It will be enabled later.

TODO: Enable splice.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |    8 ++++++++
 fs/ocfs2/xattr.c  |    2 ++
 5 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 02b8c9c..a2365e4 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -78,6 +78,7 @@ NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
 GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN = @GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN@
 NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
+SKIP_SPLICE = @SKIP_SPLICE@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 5bc9d42..f028444 100644
--- a/configure.in
+++ b/configure.in
@@ -414,6 +414,11 @@ OCFS2_CHECK_KERNEL([	fops->sendfile() in fs.h], fs.h,
   HAS_FOPS_SENDFILE=yes, , [^.*ssize_t (\*sendfile)])
 AC_SUBST(HAS_FOPS_SENDFILE)
 
+SKIP_SPLICE=
+OCFS2_CHECK_KERNEL([splice.h], splice.h,
+  , SKIP_SPLICE=yes, [struct splice_desc {])
+AC_SUBST(SKIP_SPLICE)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 2e85623..ba2a3ea 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -114,6 +114,10 @@ ifdef HAS_FOPS_SENDFILE
 EXTRA_CFLAGS += -DHAS_FOPS_SENDFILE
 endif
 
+ifdef SKIP_SPLICE
+EXTRA_CFLAGS += -DSKIP_SPLICE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index de75f5a..81bd622 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -31,7 +31,9 @@
 #include <linux/pagemap.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
+#ifndef SKIP_SPLICE
 #include <linux/splice.h>
+#endif
 #include <linux/mount.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
@@ -2058,6 +2060,7 @@ out_sems:
 	return ret;
 }
 
+#ifndef SKIP_SPLICE
 static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
 				struct file *out,
 				struct splice_desc *sd)
@@ -2171,6 +2174,7 @@ bail:
 	mlog_exit(ret);
 	return ret;
 }
+#endif /* SKIP SPLICE */
 
 static ssize_t __ocfs2_file_aio_read(struct kiocb *iocb,
 				   const struct iovec *iov,
@@ -2334,8 +2338,10 @@ const struct file_operations ocfs2_fops = {
 #endif
 	.lock		= ocfs2_lock,
 	.flock		= ocfs2_flock,
+#ifndef SKIP_SPLICE
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
+#endif
 #ifdef HAS_FOPS_SENDFILE
 	.sendfile	= ocfs2_file_sendfile,
 #endif
@@ -2383,8 +2389,10 @@ const struct file_operations ocfs2_fops_no_plocks = {
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
 	.flock		= ocfs2_flock,
+#ifndef SKIP_SPLICE
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
+#endif
 #ifdef HAS_FOPS_SENDFILE
 	.sendfile	= ocfs2_file_sendfile,
 #endif
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index fe34190..9a03d9b 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -27,7 +27,9 @@
 #include <linux/pagemap.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
+#ifndef SKIP_SPLICE
 #include <linux/splice.h>
+#endif
 #include <linux/mount.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
-- 
1.5.6.5
