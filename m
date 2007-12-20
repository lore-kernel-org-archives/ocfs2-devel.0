From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Dec 20 15:30:08 2007
Subject: [Ocfs2-devel] [PATCH 21/30] ocfs2: Handle missing macro MNT_RELATIME
In-Reply-To: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1198193387-16606-20-git-send-email-sunil.mushran@oracle.com>
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
---
 Makefile                    |    3 ++-
 configure.in                |    5 +++++
 kapi-compat/include/mount.h |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/mount.h

diff --git a/Makefile b/Makefile
index eafeb2f..3b2acf2 100644
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/register_sysctl.h \
 	kapi-compat/include/su_mutex.h \
 	kapi-compat/include/kobject.h \
-	kapi-compat/include/cap.h
+	kapi-compat/include/cap.h \
+	kapi-compat/include/mount.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 931cf2c..39fb02b 100644
--- a/configure.in
+++ b/configure.in
@@ -252,6 +252,11 @@ OCFS2_CHECK_KERNEL([struct splice_desc in splice.h], splice.h,
   SPLICE_HEADER=yes, , [^struct splice_desc ])
 AC_SUBST(SPLICE_HEADER)
 
+relatime_compat_header=""
+OCFS2_CHECK_KERNEL([MNT_RELATIME in mount.h], mount.h,
+  , relatime_compat_header="mount.h", [^#define MNT_RELATIME])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $relatime_compat_header"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/kapi-compat/include/mount.h b/kapi-compat/include/mount.h
new file mode 100644
index 0000000..f515b64
--- /dev/null
+++ b/kapi-compat/include/mount.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_MOUNT_H
+#define KAPI_MOUNT_H
+
+#define MNT_RELATIME    0x20
+
+#endif
-- 
1.5.2.5
