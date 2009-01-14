From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Jan 2009 17:47:08 -0800
Subject: [Ocfs2-devel] [PATCH 03/15] ocfs2: Add helper clear_nlink()
In-Reply-To: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
References: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1231897640-31410-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit ce71ec36840368b877fb63bd14c8e67ab62d08b1 in mainline introduced
helper clear_nlink(). This patch adds the helper in kapi-include.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                          |    3 ++-
 configure.in                      |    5 +++++
 kapi-compat/include/clear_nlink.h |   19 +++++++++++++++++++
 3 files changed, 26 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/clear_nlink.h

diff --git a/Makefile b/Makefile
index 8e959ff..d976201 100644
--- a/Makefile
+++ b/Makefile
@@ -42,7 +42,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/le16_add_cpu.h \
 	kapi-compat/include/le32_add_cpu.h \
 	kapi-compat/include/le64_add_cpu.h \
-	kapi-compat/include/be32_add_cpu.h
+	kapi-compat/include/be32_add_cpu.h \
+	kapi-compat/include/clear_nlink.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index a92110a..b7efa1b 100644
--- a/configure.in
+++ b/configure.in
@@ -480,6 +480,11 @@ OCFS2_CHECK_KERNEL([be32_add_cpu() in byteorder/generic.h], byteorder/generic.h,
   , be32_add_cpu_compat_header="be32_add_cpu.h", [^static inline void be32_add_cpu(])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $be32_add_cpu_compat_header"
 
+clear_nlink_compat_header=""
+OCFS2_CHECK_KERNEL([clear_nlink() in fs.h], fs.h,
+  , clear_nlink_compat_header="clear_nlink.h", [^static inline void clear_nlink(])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $clear_nlink_compat_header"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/kapi-compat/include/clear_nlink.h b/kapi-compat/include/clear_nlink.h
new file mode 100644
index 0000000..ef43ff2
--- /dev/null
+++ b/kapi-compat/include/clear_nlink.h
@@ -0,0 +1,19 @@
+#ifndef KAPI_CLEAR_NLINK_H
+#define KAPI_CLEAR_NLINK_H
+
+#include <linux/fs.h>
+
+/**
+ * clear_nlink - directly zero an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  See
+ * drop_nlink() for why we care about i_nlink hitting zero.
+ */
+static inline void clear_nlink(struct inode *inode)
+{
+	inode->i_nlink = 0;
+}
+
+#endif
-- 
1.5.6.3
