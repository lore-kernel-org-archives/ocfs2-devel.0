From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Dec 31 14:25:36 2007
Subject: [Ocfs2-devel] [PATCH 22/30] ocfs2: Handle missing macro MNT_RELATIME
In-Reply-To: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199139862-31452-21-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 47ae32d6a54955a041cdc30b06d0bb16e75f68d5 in mainline introduced
macro MNT_RELATIME to limit atime updates to frequency specified in the
mount option. This patch allows one to build ocfs2 with kernels having/not
having this change.

It should be noted that the functionality will not be available on kernels
not having the macro as the vfs support will be missing.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Makefile                       |    3 ++-
 configure.in                   |    5 +++++
 kapi-compat/include/relatime.h |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/relatime.h

diff --git a/Makefile b/Makefile
index cb395cc..b3998b4 100644
--- a/Makefile
+++ b/Makefile
@@ -24,7 +24,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/register_sysctl.h \
 	kapi-compat/include/su_mutex.h \
 	kapi-compat/include/kobject.h \
-	kapi-compat/include/cap.h
+	kapi-compat/include/cap.h \
+	kapi-compat/include/relatime.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 2a7dc9c..9cef1f8 100644
--- a/configure.in
+++ b/configure.in
@@ -258,6 +258,11 @@ OCFS2_CHECK_KERNEL([struct splice_desc in splice.h], splice.h,
   , NO_SPLICE_HEADER=yes, [^struct splice_desc ])
 AC_SUBST(NO_SPLICE_HEADER)
 
+relatime_compat_header=""
+OCFS2_CHECK_KERNEL([MNT_RELATIME in mount.h], mount.h,
+  , relatime_compat_header="relatime.h", [^#define MNT_RELATIME])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $relatime_compat_header"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/kapi-compat/include/relatime.h b/kapi-compat/include/relatime.h
new file mode 100644
index 0000000..34c5d38
--- /dev/null
+++ b/kapi-compat/include/relatime.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_RELATIME_H
+#define KAPI_RELATIME_H
+
+#define MNT_RELATIME    0x20
+
+#endif
-- 
1.5.3.4
