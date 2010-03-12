From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 12 Mar 2010 17:05:42 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2-1.6: pipe operation pin() changes
	to confirm()
In-Reply-To: <>
References: <>
Message-ID: <1268384742-3861-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

commit cac36bb06efe4880234524e117e0e712b10b1f16 in mainline
changes pipe_buf_operations->pin() to ->confirm(). This patch
allows building ocfs2 with kernels having/not having this change.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Config.make.in                            |    1 +
 Makefile                                  |    3 ++-
 configure.in                              |    6 ++++++
 fs/ocfs2/Makefile                         |    4 ++++
 kapi-compat/include/pipe_buf_operations.h |   10 ++++++++++
 5 files changed, 23 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/pipe_buf_operations.h

diff --git a/Config.make.in b/Config.make.in
index 304fd76..b3f3572 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -78,6 +78,7 @@ NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
 GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN = @GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN@
 NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
+NO_CONFIRM_IN_PIPE_OPERATIONS = @NO_CONFIRM_IN_PIPE_OPERATIONS@
 SKIP_SPLICE = @SKIP_SPLICE@
 SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
diff --git a/Makefile b/Makefile
index 5c6f080..eff8362 100644
--- a/Makefile
+++ b/Makefile
@@ -42,7 +42,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/compat_kobject.h		\
 	kapi-compat/include/quotas.h			\
 	kapi-compat/include/cancel_work_sync.h		\
-	kapi-compat/include/fiemap_shared.h
+	kapi-compat/include/fiemap_shared.h		\
+	kapi-compat/include/pipe_buf_operations.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index bda3636..2fc25ce 100644
--- a/configure.in
+++ b/configure.in
@@ -414,6 +414,12 @@ OCFS2_CHECK_KERNEL([	fops->sendfile() in fs.h], fs.h,
   HAS_FOPS_SENDFILE=yes, , [^.*ssize_t (\*sendfile)])
 AC_SUBST(HAS_FOPS_SENDFILE)
 
+NO_CONFIRM_IN_PIPE_OPERATIONS=
+OCFS2_CHECK_KERNEL([confirm() in struct pipe_buf_operations in pipe_fs_i.h], pipe_fs_i.h,
+ , NO_CONFIRM_IN_PIPE_OPERATIONS=pipe_buf_operations.h, [int (\*confirm)(struct pipe_inode_info \*])
+AC_SUBST(NO_CONFIRM_IN_PIPE_OPERATIONS)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_CONFIRM_IN_PIPE_OPERATIONS"
+
 SKIP_SPLICE=
 OCFS2_CHECK_KERNEL([splice.h], splice.h,
   , SKIP_SPLICE=yes, [struct splice_desc {])
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 5c49863..a408082 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -112,6 +112,10 @@ ifdef HAS_FOPS_SENDFILE
 EXTRA_CFLAGS += -DHAS_FOPS_SENDFILE
 endif
 
+ifdef NO_CONFIRM_IN_PIPE_OPERATIONS
+EXTRA_CFLAGS += -DNO_CONFIRM_IN_PIPE_OPERATIONS
+endif
+
 ifdef SKIP_SPLICE
 EXTRA_CFLAGS += -DSKIP_SPLICE
 endif
diff --git a/kapi-compat/include/pipe_buf_operations.h b/kapi-compat/include/pipe_buf_operations.h
new file mode 100644
index 0000000..a867845
--- /dev/null
+++ b/kapi-compat/include/pipe_buf_operations.h
@@ -0,0 +1,10 @@
+#ifndef KAPI_PIPE_BUF_OPERATIONS_H
+#define KAPI_PIPE_BUF_OPERATIONS_H
+
+#ifdef NO_CONFIRM_IN_PIPE_OPERATIONS
+# define kapi_confirm(a, b) pin(a, b)
+#else
+# define kapi_confirm(a, b) confirm(a, b)
+#endif
+
+#endif
-- 
1.5.2.3
