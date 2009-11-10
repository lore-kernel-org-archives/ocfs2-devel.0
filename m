From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 18:00:12 -0800
Subject: [Ocfs2-devel] [PATCH 09/10] ocfs2: Handle missing USHORT_MAX
In-Reply-To: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257818413-32014-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 44f564a4bf6ac70f2a84806203045cf515bc9367 USHORT_MAX.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                        |    3 ++-
 configure.in                    |    5 +++++
 kapi-compat/include/ushortmax.h |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/ushortmax.h

diff --git a/Makefile b/Makefile
index 6a28531..6e28427 100644
--- a/Makefile
+++ b/Makefile
@@ -14,7 +14,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/task_pid_nr.h		\
 	kapi-compat/include/current_umask.h		\
 	kapi-compat/include/sync_mapping.h		\
-	kapi-compat/include/fpath.h
+	kapi-compat/include/fpath.h			\
+	kapi-compat/include/ushortmax.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 8179f59..4d9bea3 100644
--- a/configure.in
+++ b/configure.in
@@ -212,6 +212,11 @@ if test "x$ADDRESS_SPACE_OPS_EXT" = "x" ; then
   fi
 fi
 
+ushort_max_compat_header=
+OCFS2_CHECK_KERNEL([USHORT_MAX in kernel.h], kernel.h,
+  , ushort_max_compat_header="ushortmax.h", [#define USHORT_MAX])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $ushort_max_compat_header"
+
 
 # End kapi_compat checks
 
diff --git a/kapi-compat/include/ushortmax.h b/kapi-compat/include/ushortmax.h
new file mode 100644
index 0000000..a12633a
--- /dev/null
+++ b/kapi-compat/include/ushortmax.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_USHORTMAX_H
+#define KAPI_USHORTMAX_H
+
+#define USHORT_MAX     ((u16)(~0U))
+
+#endif
-- 
1.5.6.5
