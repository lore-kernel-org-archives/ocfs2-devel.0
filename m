From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 18:00:09 -0800
Subject: [Ocfs2-devel] [PATCH 06/10] ocfs2: Handle missing
	do_sync_mapping_range()
In-Reply-To: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257818413-32014-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 5b04aa3a64f854244bc40a6f528176ed50b5c4f6 added
do_sync_mapping_range(). EL5 has do_sync_file_range(). This patch
wires do_sync_mapping_range() into do_sync_file_range().

Build fails if both symbols are not found.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                           |    3 ++-
 configure.in                       |   13 +++++++++++++
 kapi-compat/include/sync_mapping.h |   13 +++++++++++++
 3 files changed, 28 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/sync_mapping.h

diff --git a/Makefile b/Makefile
index 950d6fc..8e58c5d 100644
--- a/Makefile
+++ b/Makefile
@@ -12,7 +12,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/workqueue.h			\
 	kapi-compat/include/dlmconstants.h		\
 	kapi-compat/include/task_pid_nr.h		\
-	kapi-compat/include/current_umask.h
+	kapi-compat/include/current_umask.h		\
+	kapi-compat/include/sync_mapping.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 93f9632..658cd6f 100644
--- a/configure.in
+++ b/configure.in
@@ -180,6 +180,19 @@ OCFS2_CHECK_KERNEL([current_umask() in fs.h], fs.h,
  , current_umask_compat_header="current_umask.h", [^extern int current_umask(void)])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $current_umask_compat_header"
 
+do_sync_mapping_range=
+OCFS2_CHECK_KERNEL([do_sync_mapping_range() in fs.h], fs.h,
+do_sync_mapping_range="yes", , [int do_sync_mapping_range(struct address_space \*mapping])
+if test "x$do_sync_mapping_range" = "x" ; then
+  do_sync_file_range=
+  OCFS2_CHECK_KERNEL([	do_sync_file_range() in fs.h], fs.h,
+  do_sync_file_range="yes", , [int do_sync_file_range(struct file \*file])
+  if test "x$do_sync_file_range" = "x" ; then
+    AC_MSG_ERROR(Cannot build with kernel that is missing both do_sync_mapping_range() and do_sync_file_range())
+  fi
+  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS sync_mapping.h"
+fi
+
 
 # End kapi_compat checks
 
diff --git a/kapi-compat/include/sync_mapping.h b/kapi-compat/include/sync_mapping.h
new file mode 100644
index 0000000..5d77feb
--- /dev/null
+++ b/kapi-compat/include/sync_mapping.h
@@ -0,0 +1,13 @@
+#ifndef KAPI_SYNC_MAPPING_H
+#define KAPI_SYNC_MAPPING_H
+
+#include <linux/fs.h>
+static inline int do_sync_mapping_range(struct address_space *mapping,
+					loff_t offset, loff_t endbyte,
+					unsigned int flags)
+{
+	struct file fake = { .f_mapping = mapping, };
+	return do_sync_file_range(&fake, offset, endbyte, flags);
+}
+
+#endif
-- 
1.5.6.5
