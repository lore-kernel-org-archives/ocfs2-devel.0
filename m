From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Dec 31 14:25:46 2007
Subject: [Ocfs2-devel] [PATCH 13/30] ocfs2: Define FS_RENAME_DOES_D_MOVE
In-Reply-To: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199139862-31452-12-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 349457ccf2592c14bdf13b6706170ae2e94931b1 in mainline defines macro
FS_RENAME_DOES_D_MOVE to allow fs to call d_move() during rename().
This patch allows one to build ocfs2 with kernels having/not having
this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Makefile                     |    3 ++-
 configure.in                 |    5 +++++
 kapi-compat/include/fstype.h |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/fstype.h

diff --git a/Makefile b/Makefile
index 7a472fb..7d6788e 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/kmod.h \
 	kapi-compat/include/inc_nlink.h \
 	kapi-compat/include/drop_nlink.h \
-	kapi-compat/include/slab.h
+	kapi-compat/include/slab.h \
+	kapi-compat/include/fstype.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 0e1e33e..abc835b 100644
--- a/configure.in
+++ b/configure.in
@@ -210,6 +210,11 @@ OCFS2_CHECK_KERNEL([kmem_cache_create() with dtor arg in slab.h], slab.h,
 AC_SUBST(KMEM_CACHE_CREATE_DTOR)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS slab.h"
 
+fstype_compat_header=""
+OCFS2_CHECK_KERNEL([flag FS_RENAME_DOES_D_MOVE in fs.h], fs.h,
+  , fstype_compat_header="fstype.h", [FS_RENAME_DOES_D_MOVE])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $fstype_compat_header"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/kapi-compat/include/fstype.h b/kapi-compat/include/fstype.h
new file mode 100644
index 0000000..895ea86
--- /dev/null
+++ b/kapi-compat/include/fstype.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_FSTYPE_H
+#define KAPI_FSTYPE_H
+
+#define FS_RENAME_DOES_D_MOVE	FS_ODD_RENAME
+
+#endif
-- 
1.5.3.4
