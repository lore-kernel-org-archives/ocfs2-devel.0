From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 12 Mar 2010 17:07:20 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2-1.6: Add file_remove_suid()
In-Reply-To: <1268384742-3861-1-git-send-email-tiger.yang@oracle.com>
References: <1268384742-3861-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <1268384840-3910-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

commit 2f1936b87783a3a56c9441b27b9ba7a747f11e8e in mainline
change remove_suid() to file_remove_suid() in vfs. This patch
allows building ocfs2 with kernels having/not having this change.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Config.make.in                         |    1 +
 Makefile                               |    3 ++-
 configure.in                           |    6 ++++++
 fs/ocfs2/Makefile                      |    4 ++++
 kapi-compat/include/file_remove_suid.h |    8 ++++++++
 5 files changed, 21 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/file_remove_suid.h

diff --git a/Config.make.in b/Config.make.in
index 2ec02b6..6c556d6 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -80,6 +80,7 @@ NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
 NO_CONFIRM_IN_PIPE_OPERATIONS = @NO_CONFIRM_IN_PIPE_OPERATIONS@
 NO_INODE_DOUBLE_LOCK = @NO_INODE_DOUBLE_LOCK@
+NO_FILE_REMOVE_SUID = @NO_FILE_REMOVE_SUID@
 SKIP_SPLICE = @SKIP_SPLICE@
 SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
diff --git a/Makefile b/Makefile
index 91324e8..6039b16 100644
--- a/Makefile
+++ b/Makefile
@@ -44,7 +44,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/cancel_work_sync.h		\
 	kapi-compat/include/fiemap_shared.h		\
 	kapi-compat/include/pipe_buf_operations.h	\
-	kapi-compat/include/inode_double_lock.h
+	kapi-compat/include/inode_double_lock.h		\
+	kapi-compat/include/file_remove_suid.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index e1d006b..36a1867 100644
--- a/configure.in
+++ b/configure.in
@@ -426,6 +426,12 @@ OCFS2_CHECK_KERNEL([inode_double_lock() in fs.h], fs.h,
 AC_SUBST(NO_INODE_DOUBLE_LOCK)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_INODE_DOUBLE_LOCK"
 
+NO_FILE_REMOVE_SUID=
+OCFS2_CHECK_KERNEL([file_remove_suid() in fs.h], fs.h,
+ , NO_FILE_REMOVE_SUID=file_remove_suid.h, [^extern int file_remove_suid])
+AC_SUBST(NO_FILE_REMOVE_SUID)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_FILE_REMOVE_SUID"
+
 SKIP_SPLICE=
 OCFS2_CHECK_KERNEL([splice.h], splice.h,
   , SKIP_SPLICE=yes, [struct splice_desc {])
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index cc7dc54..866f87e 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -120,6 +120,10 @@ ifdef NO_INODE_DOUBLE_LOCK
 EXTRA_CFLAGS += -DNO_INODE_DOUBLE_LOCK
 endif
 
+ifdef NO_FILE_REMOVE_SUID
+EXTRA_CFLAGS += -DNO_FILE_REMOVE_SUID
+endif
+
 ifdef SKIP_SPLICE
 EXTRA_CFLAGS += -DSKIP_SPLICE
 endif
diff --git a/kapi-compat/include/file_remove_suid.h b/kapi-compat/include/file_remove_suid.h
new file mode 100644
index 0000000..c38f9ea
--- /dev/null
+++ b/kapi-compat/include/file_remove_suid.h
@@ -0,0 +1,8 @@
+#ifndef KAPI_FILE_REMOVE_SUID_H
+#define KAPI_FILE_REMOVE_SUID_H
+
+#ifdef NO_FILE_REMOVE_SUID
+#define file_remove_suid(f)	remove_suid(filp_dentry(f))
+#endif
+
+#endif
-- 
1.5.2.3
