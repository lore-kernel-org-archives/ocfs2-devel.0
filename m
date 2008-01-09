From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan  9 18:00:06 2008
Subject: [Ocfs2-devel] [PATCH 23/30] ocfs2: Handles missing export
	should_remove_suid()
In-Reply-To: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
References: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199930370-17076-22-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commits 01de85e057328ecbef36e108673b1e81059d54c1 and
d23a147bb6e8d467e8df73b6589888717da3b9ce in mainline added and exported
symbol should_remove_suid(). This patch allows one to build ocfs2 with
kernels having/not having these changes.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Config.make.in                           |    1 +
 Makefile                                 |    3 +-
 configure.in                             |    6 ++++
 fs/ocfs2/Makefile                        |    6 ++++
 fs/ocfs2/compat_should_remove_suid.c     |   39 ++++++++++++++++++++++++++++++
 kapi-compat/include/should_remove_suid.h |   12 +++++++++
 6 files changed, 66 insertions(+), 1 deletions(-)
 create mode 100644 fs/ocfs2/compat_should_remove_suid.c
 create mode 100644 kapi-compat/include/should_remove_suid.h

diff --git a/Config.make.in b/Config.make.in
index ad1c8e9..6afaef6 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -68,6 +68,7 @@ NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM = @NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSY
 STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
 NO_FALLOCATE = @NO_FALLOCATE@
 NO_SPLICE_HEADER = @NO_SPLICE_HEADER@
+NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/Makefile b/Makefile
index ea4b979..0c17fec 100644
--- a/Makefile
+++ b/Makefile
@@ -25,7 +25,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/su_mutex.h \
 	kapi-compat/include/kobject.h \
 	kapi-compat/include/cap.h \
-	kapi-compat/include/relatime.h
+	kapi-compat/include/relatime.h \
+	kapi-compat/include/should_remove_suid.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 2f2a263..6d20acc 100644
--- a/configure.in
+++ b/configure.in
@@ -274,6 +274,12 @@ OCFS2_CHECK_KERNEL([MNT_RELATIME in mount.h], mount.h,
   , relatime_compat_header="relatime.h", [^#define MNT_RELATIME])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $relatime_compat_header"
 
+NO_SHOULD_REMOVE_SUID=
+OCFS2_CHECK_KERNEL([should_remove_suid() in fs.h], fs.h,
+  , NO_SHOULD_REMOVE_SUID=yes, [should_remove_suid()])
+AC_SUBST(NO_SHOULD_REMOVE_SUID)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS should_remove_suid.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index f4c9428..8360fe3 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -64,6 +64,12 @@ ifdef NO_SPLICE_HEADER
 EXTRA_CFLAGS += -DNO_SPLICE_HEADER
 endif
 
+COMPAT_SOURCES += compat_should_remove_suid.c
+ifdef NO_SHOULD_REMOVE_SUID
+SOURCES += compat_should_remove_suid.c
+EXTRA_CFLAGS += -DNO_SHOULD_REMOVE_SUID
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/compat_should_remove_suid.c b/fs/ocfs2/compat_should_remove_suid.c
new file mode 100644
index 0000000..ae843db
--- /dev/null
+++ b/fs/ocfs2/compat_should_remove_suid.c
@@ -0,0 +1,39 @@
+/*
+ * compat_should_remove_suid.c
+ *
+ * This code has been copied from mainline linux kernel git commit
+ * e7b34019606ab1dd06196635e931b0c302799228 to allow ocfs2 to build
+ * against older kernels. For license, refer to mm/filemap.c in mainline
+ * linux kernel.
+ *
+ */
+
+#include <linux/fs.h>
+
+/*
+ * The logic we want is
+ *
+ *	if suid or (sgid and xgrp)
+ *		remove privs
+ */
+int should_remove_suid(struct dentry *dentry)
+{
+	mode_t mode = dentry->d_inode->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	/*
+	 * sgid without any exec bits is just a mandatory locking mark; leave
+	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
+	 */
+	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
+		kill |= ATTR_KILL_SGID;
+
+	if (unlikely(kill && !capable(CAP_FSETID)))
+		return kill;
+
+	return 0;
+}
diff --git a/kapi-compat/include/should_remove_suid.h b/kapi-compat/include/should_remove_suid.h
new file mode 100644
index 0000000..1d1a9c3
--- /dev/null
+++ b/kapi-compat/include/should_remove_suid.h
@@ -0,0 +1,12 @@
+#ifndef KAP_SHOULD_REMOVE_SUID_H
+#define KAP_SHOULD_REMOVE_SUID_H
+
+#ifdef NO_SHOULD_REMOVE_SUID
+
+#include <linux/fs.h>
+
+int should_remove_suid(struct dentry *dentry);
+
+#endif
+
+#endif
-- 
1.5.2.5
