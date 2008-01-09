From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan  9 18:00:02 2008
Subject: [Ocfs2-devel] [PATCH 14/30] ocfs2: Handle enum value FS_OCFS2
In-Reply-To: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
References: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199930370-17076-13-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 0e03036c97b70b2602f7dedaa3a223ed7563c2c9 in mainline registers
ocfs2 sysctl (FS_OCFS2) number under CTL_FS. This patch allows one to
build ocfs2 with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Makefile                     |    3 ++-
 configure.in                 |    5 +++++
 kapi-compat/include/sysctl.h |    9 +++++++++
 3 files changed, 16 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/sysctl.h

diff --git a/Makefile b/Makefile
index 43cd04c..1d27943 100644
--- a/Makefile
+++ b/Makefile
@@ -18,7 +18,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/inc_nlink.h \
 	kapi-compat/include/drop_nlink.h \
 	kapi-compat/include/slab.h \
-	kapi-compat/include/fs_rename_does_d_move.h
+	kapi-compat/include/fs_rename_does_d_move.h \
+	kapi-compat/include/sysctl.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index f1d3732..7874829 100644
--- a/configure.in
+++ b/configure.in
@@ -226,6 +226,11 @@ if test "x$fstype_compat_header" = "xfs_rename_does_d_move.h" ; then
   fi
 fi
 
+sysctl_compat_header=""
+OCFS2_CHECK_KERNEL([enum FS_OCFS2 in sysctl.h], sysctl.h,
+  , sysctl_compat_header="sysctl.h", [FS_OCFS2])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $sysctl_compat_header"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/kapi-compat/include/sysctl.h b/kapi-compat/include/sysctl.h
new file mode 100644
index 0000000..73ed0a7
--- /dev/null
+++ b/kapi-compat/include/sysctl.h
@@ -0,0 +1,9 @@
+#ifndef KAPI_SYSCTL_H
+#define KAPI_SYSCTL_H
+
+/* CTL_FS names: */
+enum {
+	FS_OCFS2=988,   /* ocfs2 */
+};
+
+#endif
-- 
1.5.2.5
