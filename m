From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Dec 20 15:30:00 2007
Subject: [Ocfs2-devel] [PATCH 18/30] ocfs2: Handle missing macro
	is_owner_or_cap()
In-Reply-To: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1198193387-16606-17-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 3bd858ab1c451725c07a805dcb315215dc85b86e in mainline introduces
helper macro is_owner_or_cap(). This patch allows one to build ocfs2 with
kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                  |    3 ++-
 configure.in              |    5 +++++
 kapi-compat/include/cap.h |    7 +++++++
 3 files changed, 14 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/cap.h

diff --git a/Makefile b/Makefile
index a26e24f..eafeb2f 100644
--- a/Makefile
+++ b/Makefile
@@ -22,7 +22,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/configfs.h \
 	kapi-compat/include/register_sysctl.h \
 	kapi-compat/include/su_mutex.h \
-	kapi-compat/include/kobject.h
+	kapi-compat/include/kobject.h \
+	kapi-compat/include/cap.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 83dcd37..f8b5f20 100644
--- a/configure.in
+++ b/configure.in
@@ -237,6 +237,11 @@ OCFS2_CHECK_KERNEL([struct subsystem in kobject.h], kobject.h,
 AC_SUBST(STRUCT_SUBSYSTEM_DEFINED)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS kobject.h"
 
+cap_compat_header=""
+OCFS2_CHECK_KERNEL([is_owner_or_cap() in fs.h], fs.h,
+  , cap_compat_header="cap.h", [^#define is_owner_or_cap])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $cap_compat_header"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/kapi-compat/include/cap.h b/kapi-compat/include/cap.h
new file mode 100644
index 0000000..a10a12f
--- /dev/null
+++ b/kapi-compat/include/cap.h
@@ -0,0 +1,7 @@
+#ifndef KAPI_CAP_H
+#define KAPI_CAP_H
+
+#define is_owner_or_cap(inode)  \
+	        ((current->fsuid == (inode)->i_uid) || capable(CAP_FOWNER))
+
+#endif
-- 
1.5.2.5
