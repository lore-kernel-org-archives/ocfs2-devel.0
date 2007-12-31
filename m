From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Dec 31 14:25:52 2007
Subject: [Ocfs2-devel] [PATCH 09/30] ocfs2: Define enum umh_wait
In-Reply-To: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199139862-31452-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 86313c488a6848b7ec2ba04e74f25f79dd32a0b7 in mainline introduced
enum umh_wait. This patch allows one to build ocfs2 with kernels having/
not having that change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Makefile                   |    3 ++-
 configure.in               |    5 +++++
 kapi-compat/include/kmod.h |   10 ++++++++++
 3 files changed, 17 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/kmod.h

diff --git a/Makefile b/Makefile
index c1ebc15..a12754c 100644
--- a/Makefile
+++ b/Makefile
@@ -13,7 +13,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/compiler.h \
 	kapi-compat/include/highmem.h \
 	kapi-compat/include/sync_mapping_range.h \
-	kapi-compat/include/fpath.h
+	kapi-compat/include/fpath.h \
+	kapi-compat/include/kmod.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 62588ac..584b564 100644
--- a/configure.in
+++ b/configure.in
@@ -189,6 +189,11 @@ OCFS2_CHECK_KERNEL([f_path in fs.h], fs.h,
 AC_SUBST(NO_F_PATH_IN_STRUCT_FILE)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS fpath.h"
 
+kmod_compat_header=""
+OCFS2_CHECK_KERNEL([enum umh_wait in kmod.h], kmod.h,
+  , kmod_compat_header="kmod.h", [umh_wait])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $kmod_compat_header"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/kapi-compat/include/kmod.h b/kapi-compat/include/kmod.h
new file mode 100644
index 0000000..42a082b
--- /dev/null
+++ b/kapi-compat/include/kmod.h
@@ -0,0 +1,10 @@
+#ifndef KAPI_KMOD_H
+#define KAPI_KMOD_H
+
+enum umh_wait {
+	UMH_NO_WAIT = -1,	/* don't wait at all */
+	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
+	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
+};
+
+#endif
-- 
1.5.3.4
