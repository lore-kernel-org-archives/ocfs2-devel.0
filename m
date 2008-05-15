From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 15 May 2008 16:52:05 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: Fixes pipe_buf_operations->pin
	switch to confirm in 2.6.23.
Message-ID: <1210841528-7769-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Config.make.in                            |    1 +
 configure.in                              |    6 ++++++
 fs/ocfs2/Makefile                         |    4 ++++
 kapi-compat/include/pipe_buf_operations.h |   10 ++++++++++
 4 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 kapi-compat/include/pipe_buf_operations.h

diff --git a/Config.make.in b/Config.make.in
index b7d553d..1abcc55 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -95,6 +95,7 @@ NO_LINUX_UACCESS_H = @NO_LINUX_UACCESS_H@
 NO_SYSTEM_UTSNAME = @NO_SYSTEM_UTSNAME@
 HAS_MS_LOOP_NO_AOPS  = @HAS_MS_LOOP_NO_AOPS@
 HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
+NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS = @NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index bc5187f..94d981a 100644
--- a/configure.in
+++ b/configure.in
@@ -425,6 +425,12 @@ OCFS2_CHECK_KERNEL([task_pid_nr in sched.h], sched.h,
   , task_pid_nr_compat_header="task_pid_nr.h", [^static inline pid_t task_pid_nr(struct])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $task_pid_nr_compat_header"
 
+NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS=
+OCFS2_CHECK_KERNEL([confirm() in struct pipe_buf_operations in pipe_fs_i.h], pipe_fs_i.h,
+  , NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS=yes, [int (\*confirm)(struct pipe_inode_info \*])
+AC_SUBST(NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS pipe_buf_operations.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 46aa8ee..4d1fddb 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -168,6 +168,10 @@ ifdef HAS_FOPS_SENDFILE
 EXTRA_CFLAGS += -DHAS_FOPS_SENDFILE
 endif
 
+ifdef NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS
+EXTRA_CFLAGS += -DNO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/kapi-compat/include/pipe_buf_operations.h b/kapi-compat/include/pipe_buf_operations.h
new file mode 100644
index 0000000..8da5361
--- /dev/null
+++ b/kapi-compat/include/pipe_buf_operations.h
@@ -0,0 +1,10 @@
+#ifndef KAPI_PIPE_BUF_OPERATIONS_H
+#define KAPI_PIPE_BUF_OPERATIONS_H
+
+#ifdef NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS
+# define kapi_confirm(a,b) pin(a,b)
+#else
+# define kapi_confirm(a,b) confirm(a,b)
+#endif
+
+#endif
-- 
1.5.4.4
