From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 19:40:01 -0800
Subject: [Ocfs2-devel] [PATCH 4/8] ocfs2: Handle missing helper
	mandatory_lock()
In-Reply-To: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
References: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257997205-18055-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit a16877ca9cec211708a161057a7cbfbf2cbc3a53 added helper mandatory_lock().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                             |    3 ++-
 configure.in                         |    4 ++++
 kapi-compat/include/mandatory_lock.h |   25 +++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/mandatory_lock.h

diff --git a/Makefile b/Makefile
index 140b9cd..b9d5c5f 100644
--- a/Makefile
+++ b/Makefile
@@ -18,7 +18,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/ushortmax.h			\
 	kapi-compat/include/fversion.h			\
 	kapi-compat/include/relatime.h			\
-	kapi-compat/include/aiovec.h
+	kapi-compat/include/aiovec.h			\
+	kapi-compat/include/mandatory_lock.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index a1c4255..d0d1d18 100644
--- a/configure.in
+++ b/configure.in
@@ -295,6 +295,10 @@ if test "x$OLD_PERSMISSION" = "x" ; then
   fi
 fi
 
+mandatory_lock_header=
+OCFS2_CHECK_KERNEL([mandatory_lock() in fs.h], fs.h,
+ , mandatory_lock_header=mandatory_lock.h, [^static inline int mandatory_lock(])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $mandatory_lock_header"
 
 # End kapi_compat checks
 
diff --git a/kapi-compat/include/mandatory_lock.h b/kapi-compat/include/mandatory_lock.h
new file mode 100644
index 0000000..9c9f937
--- /dev/null
+++ b/kapi-compat/include/mandatory_lock.h
@@ -0,0 +1,25 @@
+#ifndef KAPI_MANDATORY_LOCK_H
+#define KAPI_MANDATORY_LOCK_H
+
+#include <linux/fs.h>
+/*
+ * Candidates for mandatory locking have the setgid bit set
+ * but no group execute bit -  an otherwise meaningless combination.
+ */
+
+static inline int __mandatory_lock(struct inode *ino)
+{
+        return (ino->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID;
+}
+
+/*
+ * ... and these candidates should be on MS_MANDLOCK mounted fs,
+ * otherwise these will be advisory locks
+ */
+
+static inline int mandatory_lock(struct inode *ino)
+{
+        return IS_MANDLOCK(ino) && __mandatory_lock(ino);
+}
+
+#endif /* KAPI_MANDATORY_LOCK_H */
-- 
1.5.6.5
