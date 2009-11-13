From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:34 -0800
Subject: [Ocfs2-devel] [PATCH 13/18] ocfs2: Handle missing inode_permission()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-14-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit f419a2e3b64def707e1384ee38abb77f99af5f6d renamed permission()
to inode_permission(). Patch uses an inline to redirect inode_permission() to
permission() when building with EL5.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                               |    3 ++-
 configure.in                           |    5 +++++
 kapi-compat/include/inode_permission.h |   11 +++++++++++
 3 files changed, 18 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/inode_permission.h

diff --git a/Makefile b/Makefile
index 1cd2584..898879d 100644
--- a/Makefile
+++ b/Makefile
@@ -31,7 +31,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/su_mutex.h			\
 	kapi-compat/include/sock_shutdown.h		\
 	kapi-compat/include/bdi_init.h			\
-	kapi-compat/include/bdi_define.h
+	kapi-compat/include/bdi_define.h		\
+	kapi-compat/include/inode_permission.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index a65ba15..56315a6 100644
--- a/configure.in
+++ b/configure.in
@@ -379,6 +379,11 @@ OCFS2_CHECK_KERNEL([fault() in struct vm_operations_struct in mm.h], mm.h,
   , NO_FAULT_IN_VMOPS=yes, [^.*int (\*fault)])
 AC_SUBST(NO_FAULT_IN_VMOPS)
 
+inode_permission_header=
+OCFS2_CHECK_KERNEL([inode_permision in fs.h], fs.h,
+  , inode_permission_header=inode_permission.h, [^extern int inode_permission(struct inode \*])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $inode_permission_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/inode_permission.h b/kapi-compat/include/inode_permission.h
new file mode 100644
index 0000000..43f80d3
--- /dev/null
+++ b/kapi-compat/include/inode_permission.h
@@ -0,0 +1,11 @@
+#ifndef INODE_PERMISSION_H
+#define INODE_PERMISSION_H
+
+#include <linux/fs.h>
+
+static inline int inode_permission(struct inode *inode, int flags)
+{
+	return permission(inode, flags, NULL);
+}
+
+#endif
-- 
1.5.6.5
