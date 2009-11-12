From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 19:40:05 -0800
Subject: [Ocfs2-devel] [PATCH 8/8] ocfs2: Handle missing enum value FS_OCFS2
In-Reply-To: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
References: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257997205-18055-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 0e03036c97b70b2602f7dedaa3a223ed7563c2c9 added enum FS_OCFS2.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                     |    3 ++-
 configure.in                 |    5 +++++
 kapi-compat/include/sysctl.h |    9 +++++++++
 3 files changed, 16 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/sysctl.h

diff --git a/Makefile b/Makefile
index a8d30d0..adaf9fb 100644
--- a/Makefile
+++ b/Makefile
@@ -22,7 +22,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/mandatory_lock.h		\
 	kapi-compat/include/fsuid.h			\
 	kapi-compat/include/umh_wait.h			\
-	kapi-compat/include/register_sysctl.h
+	kapi-compat/include/register_sysctl.h		\
+	kapi-compat/include/sysctl.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index cc0574a..b662f88 100644
--- a/configure.in
+++ b/configure.in
@@ -323,6 +323,11 @@ OCFS2_CHECK_KERNEL([register_sysctl_table() has one arg in sysctl.h], sysctl.h,
   , old_register_sysctl=register_sysctl.h, [^struct ctl_table_header \*register_sysctl_table(struct ctl_table \* table);])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $old_register_sysctl"
 
+sysctl_compat_header=
+OCFS2_CHECK_KERNEL([enum FS_OCFS2 in sysctl.h], sysctl.h,
+  , sysctl_compat_header=sysctl.h, [FS_OCFS2=])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $sysctl_compat_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
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
1.5.6.5
