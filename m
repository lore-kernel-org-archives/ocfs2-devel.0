From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Dec 31 14:25:58 2007
Subject: [Ocfs2-devel] [PATCH 24/30] ocfs2: Handle missing export
	generic_segment_checks()
In-Reply-To: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199139862-31452-23-git-send-email-sunil.mushran@oracle.com>
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
---
 Config.make.in                               |    1 +
 Makefile                                     |    3 +-
 configure.in                                 |    6 +++
 fs/ocfs2/Makefile                            |    4 ++
 kapi-compat/include/generic_segment_checks.h |   49 ++++++++++++++++++++++++++
 5 files changed, 62 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/generic_segment_checks.h

diff --git a/Config.make.in b/Config.make.in
index 53792d0..a44bbe3 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -69,6 +69,7 @@ STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
 NO_FALLOCATE = @NO_FALLOCATE@
 NO_SPLICE_HEADER = @NO_SPLICE_HEADER@
 NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
+NO_GENERIC_SEGMENT_CHECKS = @NO_GENERIC_SEGMENT_CHECKS@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/Makefile b/Makefile
index 5daa098..a4febde 100644
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
index c2356da..9f0131f 100644
--- a/configure.in
+++ b/configure.in
@@ -269,6 +269,12 @@ OCFS2_CHECK_KERNEL([should_remove_suid() in fs.h], fs.h,
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
index cecd610..98a7ada 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -61,6 +61,10 @@ ifdef NO_SHOULD_REMOVE_SUID
 CFLAGS_file.o += -DNO_SHOULD_REMOVE_SUID
 endif
 
+ifdef NO_GENERIC_SEGMENT_CHECKS
+CFLAGS_file.o += -DNO_GENERIC_SEGMENT_CHECKS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/kapi-compat/include/generic_segment_checks.h b/kapi-compat/include/generic_segment_checks.h
new file mode 100644
index 0000000..84aa888
--- /dev/null
+++ b/kapi-compat/include/generic_segment_checks.h
@@ -0,0 +1,49 @@
+#ifndef KAPI_GENERIC_SEGMENT_CHECKS_H
+#define KAPI_GENERIC_SEGMENT_CHECKS_H
+
+#ifdef NO_GENERIC_SEGMENT_CHECKS
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
+int generic_segment_checks(const struct iovec *iov,
+			unsigned long *nr_segs, size_t *count, int access_flags)
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
+#endif
+
+#endif
-- 
1.5.3.4
