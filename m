From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:36 -0800
Subject: [Ocfs2-devel] [PATCH 15/18] ocfs2: Handle missing export
	should_remove_suid()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-16-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit d23a147bb6e8d467e8df73b6589888717da3b9ce exported the symbol
should_remove_suid(). Patch adds compat_should_remove_suid.c that includes
the same function that gets built when building with EL5.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in                           |    1 +
 Makefile                                 |    3 +-
 configure.in                             |   10 +++++++
 fs/ocfs2/Makefile                        |    6 ++++
 fs/ocfs2/compat_should_remove_suid.c     |   40 ++++++++++++++++++++++++++++++
 kapi-compat/include/should_remove_suid.h |   12 +++++++++
 6 files changed, 71 insertions(+), 1 deletions(-)
 create mode 100644 fs/ocfs2/compat_should_remove_suid.c
 create mode 100644 kapi-compat/include/should_remove_suid.h

diff --git a/Config.make.in b/Config.make.in
index 355bf2a..4b5f4c3 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -76,6 +76,7 @@ KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
 OLD_BIO_END_IO_T = @OLD_BIO_END_IO_T@
 NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
 GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN = @GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN@
+NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/Makefile b/Makefile
index 898879d..8536d51 100644
--- a/Makefile
+++ b/Makefile
@@ -32,7 +32,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/sock_shutdown.h		\
 	kapi-compat/include/bdi_init.h			\
 	kapi-compat/include/bdi_define.h		\
-	kapi-compat/include/inode_permission.h
+	kapi-compat/include/inode_permission.h		\
+	kapi-compat/include/should_remove_suid.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index b8f1bd8..3b8fd4e 100644
--- a/configure.in
+++ b/configure.in
@@ -389,6 +389,16 @@ OCFS2_CHECK_KERNEL([	get() return u64 in simple_attr_open() in fs.h], fs.h,
  GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN=yes, , [u64 (\*get)(void \*), void (\*set)(void \*, u64),])
 AC_SUBST(GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN)
 
+NO_SHOULD_REMOVE_SUID=
+AC_MSG_CHECKING(for	including should_remove_suid())
+AC_ARG_ENABLE(srsuid, [  --enable-srsuid=[yes/no]	Include should_remove_suid() [default=yes]],,enable_srsuid=yes)
+if test "x$enable_srsuid" = "xyes"; then
+  NO_SHOULD_REMOVE_SUID=yes
+  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS should_remove_suid.h"
+fi
+AC_SUBST(NO_SHOULD_REMOVE_SUID)
+AC_MSG_RESULT($enable_srsuid)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 6960f40..4a4c250 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -104,6 +104,12 @@ ifdef GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN
 EXTRA_CFLAGS += -DGET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN
 endif
 
+COMPAT_SOURCES += compat_should_remove_suid.c
+ifdef NO_SHOULD_REMOVE_SUID
+FS_SOURCES += compat_should_remove_suid.c
+EXTRA_CFLAGS += -DNO_SHOULD_REMOVE_SUID
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/compat_should_remove_suid.c b/fs/ocfs2/compat_should_remove_suid.c
new file mode 100644
index 0000000..6b4fdc7
--- /dev/null
+++ b/fs/ocfs2/compat_should_remove_suid.c
@@ -0,0 +1,40 @@
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
+#include <linux/capability.h>
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
index 0000000..8491125
--- /dev/null
+++ b/kapi-compat/include/should_remove_suid.h
@@ -0,0 +1,12 @@
+#ifndef KAPI_SHOULD_REMOVE_SUID_H
+#define KAPI_SHOULD_REMOVE_SUID_H
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
1.5.6.5
