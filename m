From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan  9 17:59:51 2008
Subject: [Ocfs2-devel] [PATCH 24/30] ocfs2: Handle missing export
	generic_segment_checks()
In-Reply-To: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
References: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199930370-17076-23-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 0ceb331433e8aad9c5f441a965d7c681f8b9046f in mainline wraps
common segment checks in generic_segment_checks(). This patch allows
one to build ocfs2 with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Config.make.in                               |    1 +
 Makefile                                     |    3 +-
 configure.in                                 |    6 +++
 fs/ocfs2/Makefile                            |    6 +++
 fs/ocfs2/compat_generic_segment_checks.c     |   51 ++++++++++++++++++++++++++
 kapi-compat/include/generic_segment_checks.h |   15 ++++++++
 6 files changed, 81 insertions(+), 1 deletions(-)
 create mode 100644 fs/ocfs2/compat_generic_segment_checks.c
 create mode 100644 kapi-compat/include/generic_segment_checks.h

diff --git a/Config.make.in b/Config.make.in
index 6afaef6..e49c8d5 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -69,6 +69,7 @@ STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
 NO_FALLOCATE = @NO_FALLOCATE@
 NO_SPLICE_HEADER = @NO_SPLICE_HEADER@
 NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
+NO_GENERIC_SEGMENT_CHECKS = @NO_GENERIC_SEGMENT_CHECKS@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/Makefile b/Makefile
index 0c17fec..9427ce6 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/kobject.h \
 	kapi-compat/include/cap.h \
 	kapi-compat/include/relatime.h \
-	kapi-compat/include/should_remove_suid.h
+	kapi-compat/include/should_remove_suid.h \
+	kapi-compat/include/generic_segment_checks.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 6d20acc..1ecdba6 100644
--- a/configure.in
+++ b/configure.in
@@ -280,6 +280,12 @@ OCFS2_CHECK_KERNEL([should_remove_suid() in fs.h], fs.h,
 AC_SUBST(NO_SHOULD_REMOVE_SUID)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS should_remove_suid.h"
 
+NO_GENERIC_SEGMENT_CHECKS=
+OCFS2_CHECK_KERNEL([generic_segment_checks() in fs.h], fs.h,
+  , NO_GENERIC_SEGMENT_CHECKS=yes, [generic_segment_checks()])
+AC_SUBST(NO_GENERIC_SEGMENT_CHECKS)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS generic_segment_checks.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 8360fe3..3228a44 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -70,6 +70,12 @@ SOURCES += compat_should_remove_suid.c
 EXTRA_CFLAGS += -DNO_SHOULD_REMOVE_SUID
 endif
 
+COMPAT_SOURCES += compat_generic_segment_checks.c
+ifdef NO_GENERIC_SEGMENT_CHECKS
+SOURCES += compat_generic_segment_checks.c
+EXTRA_CFLAGS += -DNO_GENERIC_SEGMENT_CHECKS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/compat_generic_segment_checks.c b/fs/ocfs2/compat_generic_segment_checks.c
new file mode 100644
index 0000000..10b04d5
--- /dev/null
+++ b/fs/ocfs2/compat_generic_segment_checks.c
@@ -0,0 +1,51 @@
+/*
+ * compat_generic_segment_checks.c
+ *
+ * This code has been copied from mainline linux kernel git commit
+ * e7b34019606ab1dd06196635e931b0c302799228 to allow ocfs2 to build
+ * against older kernels. For license, refer to mm/filemap.c in mainline
+ * linux kernel.
+ *
+ */
+
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/uio.h>
+
+/*
+ * Performs necessary checks before doing a write
+ * @iov:	io vector request
+ * @nr_segs:	number of segments in the iovec
+ * @count:	number of bytes to write
+ * @access_flags: type of access: %VERIFY_READ or %VERIFY_WRITE
+ *
+ * Adjust number of segments and amount of bytes to write (nr_segs should be
+ * properly initialized first). Returns appropriate error code that caller
+ * should return or zero in case that write should be allowed.
+ */
+int generic_segment_checks(const struct iovec *iov, unsigned long *nr_segs,
+			   size_t *count, int access_flags)
+{
+	unsigned long   seg;
+	size_t cnt = 0;
+	for (seg = 0; seg < *nr_segs; seg++) {
+		const struct iovec *iv = &iov[seg];
+
+		/*
+		 * If any segment has a negative length, or the cumulative
+		 * length ever wraps negative then return -EINVAL.
+		 */
+		cnt += iv->iov_len;
+		if (unlikely((ssize_t)(cnt|iv->iov_len) < 0))
+			return -EINVAL;
+		if (access_ok(access_flags, iv->iov_base, iv->iov_len))
+			continue;
+		if (seg == 0)
+			return -EFAULT;
+		*nr_segs = seg;
+		cnt -= iv->iov_len;	/* This segment is no good */
+		break;
+	}
+	*count = cnt;
+	return 0;
+}
diff --git a/kapi-compat/include/generic_segment_checks.h b/kapi-compat/include/generic_segment_checks.h
new file mode 100644
index 0000000..76e0ecf
--- /dev/null
+++ b/kapi-compat/include/generic_segment_checks.h
@@ -0,0 +1,15 @@
+#ifndef KAPI_GENERIC_SEGMENT_CHECKS_H
+#define KAPI_GENERIC_SEGMENT_CHECKS_H
+
+#ifdef NO_GENERIC_SEGMENT_CHECKS
+
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/uio.h>
+
+int generic_segment_checks(const struct iovec *iov, unsigned long *nr_segs,
+			   size_t *count, int access_flags);
+
+#endif
+
+#endif
-- 
1.5.2.5
