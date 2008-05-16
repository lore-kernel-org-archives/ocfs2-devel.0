From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 16 May 2008 14:04:21 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Add inode_double_lock()/unlock()
In-Reply-To: <1210917863-6809-1-git-send-email-tiger.yang@oracle.com>
References: <1210917863-6809-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <1210917863-6809-2-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

commit 62752ee198dca9209b7dee504763e51b11e9e0ca in mainline
added these two functions. This patch allows building ocfs2
with kernels having/not having this change.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Config.make.in                          |    1 +
 configure.in                            |    6 +++++
 fs/ocfs2/Makefile                       |    4 +++
 kapi-compat/include/inode_double_lock.h |   34 +++++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 kapi-compat/include/inode_double_lock.h

diff --git a/Config.make.in b/Config.make.in
index 1abcc55..2fddd6f 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -96,6 +96,7 @@ NO_SYSTEM_UTSNAME = @NO_SYSTEM_UTSNAME@
 HAS_MS_LOOP_NO_AOPS  = @HAS_MS_LOOP_NO_AOPS@
 HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
 NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS = @NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS@
+NO_INODE_DOUBLE_LOCK = @NO_INODE_DOUBLE_LOCK@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index 94d981a..1a7b2b5 100644
--- a/configure.in
+++ b/configure.in
@@ -431,6 +431,12 @@ OCFS2_CHECK_KERNEL([confirm() in struct pipe_buf_operations in pipe_fs_i.h], pip
 AC_SUBST(NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS pipe_buf_operations.h"
 
+NO_INODE_DOUBLE_LOCK=
+OCFS2_CHECK_KERNEL([inode_double_lock) in fs.h], fs.h,
+  , NO_INODE_DOUBLE_LOCK=yes, [^extern void inode_double_lock])
+AC_SUBST(NO_INODE_DOUBLE_LOCK)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS inode_double_lock.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 4d1fddb..dd1a8bc 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -172,6 +172,10 @@ ifdef NO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS
 EXTRA_CFLAGS += -DNO_CONFIRM_IN_STRUCT_PIPE_BUF_OPERATIONS
 endif
 
+ifdef NO_INODE_DOUBLE_LOCK
+EXTRA_CFLAGS += -DNO_INODE_DOUBLE_LOCK
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/kapi-compat/include/inode_double_lock.h b/kapi-compat/include/inode_double_lock.h
new file mode 100644
index 0000000..6b28e0b
--- /dev/null
+++ b/kapi-compat/include/inode_double_lock.h
@@ -0,0 +1,34 @@
+#ifndef KAPI_INODE_DOUBLE_LOCK_H
+#define KAPI_INODE_DOUBLE_LOCK_H
+
+#ifdef NO_INODE_DOUBLE_LOCK
+static inline void inode_double_lock(struct inode *inode1, struct inode *inode2)
+{
+	if (inode1 == NULL || inode2 == NULL || inode1 == inode2) {
+		if (inode1)
+			mutex_lock(&inode1->i_mutex);
+		else if (inode2)
+			mutex_lock(&inode2->i_mutex);
+		return;
+	}
+
+	if (inode1 < inode2) {
+		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
+	} else {
+		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_CHILD);
+	}
+}
+
+static inline void inode_double_unlock(struct inode *inode1, struct inode *inode2)
+{
+	if (inode1)
+		mutex_unlock(&inode1->i_mutex);
+
+	if (inode2 && inode2 != inode1)
+		mutex_unlock(&inode2->i_mutex);
+}
+#endif
+
+#endif
-- 
1.5.4.4
