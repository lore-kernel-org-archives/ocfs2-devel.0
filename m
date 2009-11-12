From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 19:40:03 -0800
Subject: [Ocfs2-devel] [PATCH 6/8] ocfs2: Handle missing enum umh_wait
In-Reply-To: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
References: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257997205-18055-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 86313c488a6848b7ec2ba04e74f25f79dd32a0b7 added enum umh_wait in kmod.h.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                       |    3 ++-
 configure.in                   |    5 +++++
 kapi-compat/include/umh_wait.h |   10 ++++++++++
 3 files changed, 17 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/umh_wait.h

diff --git a/Makefile b/Makefile
index 46c7218..01b0033 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/relatime.h			\
 	kapi-compat/include/aiovec.h			\
 	kapi-compat/include/mandatory_lock.h		\
-	kapi-compat/include/fsuid.h
+	kapi-compat/include/fsuid.h			\
+	kapi-compat/include/umh_wait.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 3548225..9cfdbe3 100644
--- a/configure.in
+++ b/configure.in
@@ -313,6 +313,11 @@ if test "x$no_current_fsuid" = "xfsuid.h" ; then
 fi
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $no_current_fsuid"
 
+kmod_compat_header=
+OCFS2_CHECK_KERNEL([enum umh_wait in kmod.h], kmod.h,
+  , kmod_compat_header=umh_wait.h, [enum umh_wait {])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $kmod_compat_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/umh_wait.h b/kapi-compat/include/umh_wait.h
new file mode 100644
index 0000000..42a082b
--- /dev/null
+++ b/kapi-compat/include/umh_wait.h
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
1.5.6.5
