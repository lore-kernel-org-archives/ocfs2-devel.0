From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan  9 18:00:07 2008
Subject: [Ocfs2-devel] [PATCH 10/30] ocfs2: Add helper inc_nlink
In-Reply-To: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
References: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199930370-17076-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit d8c76e6f45c111c32a4b3e50a2adc9210737b0d8 in mainline introduced
helper inc_nlink(). This patch allows one to build ocfs2 with kernels
having/not having that change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Makefile                        |    3 ++-
 configure.in                    |    5 +++++
 kapi-compat/include/inc_nlink.h |   19 +++++++++++++++++++
 3 files changed, 26 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/inc_nlink.h

diff --git a/Makefile b/Makefile
index b937c2b..2995450 100644
--- a/Makefile
+++ b/Makefile
@@ -14,7 +14,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/highmem.h \
 	kapi-compat/include/sync_mapping_range.h \
 	kapi-compat/include/fpath.h \
-	kapi-compat/include/umh_wait.h
+	kapi-compat/include/umh_wait.h \
+	kapi-compat/include/inc_nlink.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 803ded1..1cdd243 100644
--- a/configure.in
+++ b/configure.in
@@ -194,6 +194,11 @@ OCFS2_CHECK_KERNEL([enum umh_wait in kmod.h], kmod.h,
   , kmod_compat_header="umh_wait.h", [umh_wait])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $kmod_compat_header"
 
+inc_nlink_compat_header=""
+OCFS2_CHECK_KERNEL([inc_nlink() in fs.h], fs.h,
+  , inc_nlink_compat_header="inc_nlink.h", [^static inline void inc_nlink(])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $inc_nlink_compat_header"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/kapi-compat/include/inc_nlink.h b/kapi-compat/include/inc_nlink.h
new file mode 100644
index 0000000..26ddaac
--- /dev/null
+++ b/kapi-compat/include/inc_nlink.h
@@ -0,0 +1,19 @@
+#ifndef KAPI_INC_NLINK_H
+#define KAPI_INC_NLINK_H
+
+#include <linux/fs.h>
+
+/*
+ * inc_nlink - directly increment an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  Currently,
+ * it is only here for parity with dec_nlink().
+ */
+static inline void inc_nlink(struct inode *inode)
+{
+	inode->i_nlink++;
+}
+
+#endif
-- 
1.5.2.5
