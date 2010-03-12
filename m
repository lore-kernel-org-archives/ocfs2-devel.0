From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 12 Mar 2010 17:07:00 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2-1.6: Add
	inode_double_lock()/unlock()
In-Reply-To: <1268384742-3861-1-git-send-email-tiger.yang@oracle.com>
References: <1268384742-3861-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <1268384820-3890-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

commit 62752ee198dca9209b7dee504763e51b11e9e0ca in mainline
added these two functions. This patch allows building ocfs2
with kernels having/not having this chang

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Config.make.in                          |    1 +
 Makefile                                |    3 +-
 configure.in                            |    6 +++++
 fs/ocfs2/Makefile                       |    4 +++
 kapi-compat/include/inode_double_lock.h |   36 +++++++++++++++++++++++++++++++
 5 files changed, 49 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/inode_double_lock.h

diff --git a/Config.make.in b/Config.make.in
index b3f3572..2ec02b6 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -79,6 +79,7 @@ GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN = @GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN@
 NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
 NO_CONFIRM_IN_PIPE_OPERATIONS = @NO_CONFIRM_IN_PIPE_OPERATIONS@
+NO_INODE_DOUBLE_LOCK = @NO_INODE_DOUBLE_LOCK@
 SKIP_SPLICE = @SKIP_SPLICE@
 SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
diff --git a/Makefile b/Makefile
index eff8362..91324e8 100644
--- a/Makefile
+++ b/Makefile
@@ -43,7 +43,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/quotas.h			\
 	kapi-compat/include/cancel_work_sync.h		\
 	kapi-compat/include/fiemap_shared.h		\
-	kapi-compat/include/pipe_buf_operations.h
+	kapi-compat/include/pipe_buf_operations.h	\
+	kapi-compat/include/inode_double_lock.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 2fc25ce..e1d006b 100644
--- a/configure.in
+++ b/configure.in
@@ -420,6 +420,12 @@ OCFS2_CHECK_KERNEL([confirm() in struct pipe_buf_operations in pipe_fs_i.h], pip
 AC_SUBST(NO_CONFIRM_IN_PIPE_OPERATIONS)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_CONFIRM_IN_PIPE_OPERATIONS"
 
+NO_INODE_DOUBLE_LOCK=
+OCFS2_CHECK_KERNEL([inode_double_lock() in fs.h], fs.h,
+ , NO_INODE_DOUBLE_LOCK=inode_double_lock.h, [^extern void inode_double_lock])
+AC_SUBST(NO_INODE_DOUBLE_LOCK)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_INODE_DOUBLE_LOCK"
+
 SKIP_SPLICE=
 OCFS2_CHECK_KERNEL([splice.h], splice.h,
   , SKIP_SPLICE=yes, [struct splice_desc {])
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index a408082..cc7dc54 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -116,6 +116,10 @@ ifdef NO_CONFIRM_IN_PIPE_OPERATIONS
 EXTRA_CFLAGS += -DNO_CONFIRM_IN_PIPE_OPERATIONS
 endif
 
+ifdef NO_INODE_DOUBLE_LOCK
+EXTRA_CFLAGS += -DNO_INODE_DOUBLE_LOCK
+endif
+
 ifdef SKIP_SPLICE
 EXTRA_CFLAGS += -DSKIP_SPLICE
 endif
diff --git a/kapi-compat/include/inode_double_lock.h b/kapi-compat/include/inode_double_lock.h
new file mode 100644
index 0000000..990b9a9
--- /dev/null
+++ b/kapi-compat/include/inode_double_lock.h
@@ -0,0 +1,36 @@
+#ifndef KAPI_INODE_DOUBLE_LOCK_H
+#define KAPI_INODE_DOUBLE_LOCK_H
+
+#ifdef NO_INODE_DOUBLE_LOCK
+static inline void inode_double_lock(struct inode *inode1,
+				     struct inode *inode2)
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
+static inline void inode_double_unlock(struct inode *inode1,
+				       struct inode *inode2)
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
1.5.2.3
