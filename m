From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 19:40:02 -0800
Subject: [Ocfs2-devel] [PATCH 5/8] ocfs2: Handle missing helper
	current_fsuid()
In-Reply-To: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
References: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257997205-18055-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 86a264abe542cfececb4df129bc45a0338d8cdb9 added helper current_fsuid().

An earlier commit grouped security credentials in struct task in struct cred.
The patch ensures that if the above helper is not found, that struct cred is
missing. If not, build fails.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                    |    3 ++-
 configure.in                |   13 +++++++++++++
 kapi-compat/include/fsuid.h |    7 +++++++
 3 files changed, 22 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/fsuid.h

diff --git a/Makefile b/Makefile
index b9d5c5f..46c7218 100644
--- a/Makefile
+++ b/Makefile
@@ -19,7 +19,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/fversion.h			\
 	kapi-compat/include/relatime.h			\
 	kapi-compat/include/aiovec.h			\
-	kapi-compat/include/mandatory_lock.h
+	kapi-compat/include/mandatory_lock.h		\
+	kapi-compat/include/fsuid.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index d0d1d18..3548225 100644
--- a/configure.in
+++ b/configure.in
@@ -300,6 +300,19 @@ OCFS2_CHECK_KERNEL([mandatory_lock() in fs.h], fs.h,
  , mandatory_lock_header=mandatory_lock.h, [^static inline int mandatory_lock(])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $mandatory_lock_header"
 
+no_current_fsuid=
+OCFS2_CHECK_KERNEL([current_fsuid() in cred.h], cred.h,
+ , no_current_fsuid=fsuid.h, [#define current_fsuid()])
+if test "x$no_current_fsuid" = "xfsuid.h" ; then
+  fsuid_in_task=
+  OCFS2_CHECK_KERNEL([	fsuid in struct task in sched.h], sched.h,
+  fsuid_in_task=yes, , [uid_t uid,euid,suid,fsuid;])
+  if test "x$fsuid_in_task" = "x" ; then
+    AC_MSG_ERROR(Cannot build with kernel that is missing fsuid and struct cred in struct task)
+  fi
+fi
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $no_current_fsuid"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/fsuid.h b/kapi-compat/include/fsuid.h
new file mode 100644
index 0000000..08d0915
--- /dev/null
+++ b/kapi-compat/include/fsuid.h
@@ -0,0 +1,7 @@
+#ifndef KAPI_FSUID_H
+#define KAPI_FSUID_H
+
+#define current_fsuid()		(current->fsuid)
+#define current_fsgid()		(current->fsgid)
+
+#endif
-- 
1.5.6.5
