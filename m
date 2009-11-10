From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 18:00:13 -0800
Subject: [Ocfs2-devel] [PATCH 10/10] ocfs2: Handle different f_version types
In-Reply-To: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257818413-32014-11-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 2b47c3611de05c585e2d81204f6c7e3e255a3461 changed type of
file->f_version from unsigned long to u64. This patch allows building with
kernels having either definition. Build fails if the type is something else.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in                 |    1 +
 Makefile                       |    3 ++-
 configure.in                   |   14 ++++++++++++++
 fs/ocfs2/Makefile              |    4 ++++
 fs/ocfs2/dir.c                 |   12 ++++++------
 kapi-compat/include/fversion.h |   10 ++++++++++
 6 files changed, 37 insertions(+), 7 deletions(-)
 create mode 100644 kapi-compat/include/fversion.h

diff --git a/Config.make.in b/Config.make.in
index aead755..ba72950 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -61,6 +61,7 @@ NO_DELAYED_WORK_STRUCT = @NO_DELAYED_WORK_STRUCT@
 NO_DLMCONSTANTS_HEADER = @NO_DLMCONSTANTS_HEADER@
 NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
 ADDRESS_SPACE_OPS_EXT = @ADDRESS_SPACE_OPS_EXT@
+FVERSION_IS_ULONG = @FVERSION_IS_ULONG@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/Makefile b/Makefile
index 6e28427..06ddabf 100644
--- a/Makefile
+++ b/Makefile
@@ -15,7 +15,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/current_umask.h		\
 	kapi-compat/include/sync_mapping.h		\
 	kapi-compat/include/fpath.h			\
-	kapi-compat/include/ushortmax.h
+	kapi-compat/include/ushortmax.h			\
+	kapi-compat/include/fversion.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 4d9bea3..7ee2d34 100644
--- a/configure.in
+++ b/configure.in
@@ -217,6 +217,20 @@ OCFS2_CHECK_KERNEL([USHORT_MAX in kernel.h], kernel.h,
   , ushort_max_compat_header="ushortmax.h", [#define USHORT_MAX])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $ushort_max_compat_header"
 
+FVERSION_IS_ULONG=
+OCFS2_CHECK_KERNEL([	f_version is type unsigned long in fs.h], fs.h,
+ FVERSION_IS_ULONG=yes, , [unsigned long.*f_version;])
+AC_SUBST(FVERSION_IS_ULONG)
+if test "x$FVERSION_IS_ULONG" = "x" ; then
+  fversion_is_u64=
+  OCFS2_CHECK_KERNEL([	f_version is type u64 in fs.h], fs.h,
+  fversion_is_u64=yes, , [u64.*f_version;])
+  if test "x$fversion_is_u64" = "x" ; then
+    AC_MSG_ERROR(Cannot build with kernel in which f_version type is neither unsigned long nor u64)
+  fi
+fi
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS fversion.h"
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 817f9d2..e6b5801 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -52,6 +52,10 @@ ifdef ADDRESS_SPACE_OPS_EXT
 EXTRA_CFLAGS += -DADDRESS_SPACE_OPS_EXT
 endif
 
+ifdef FVERSION_IS_ULONG
+EXTRA_CFLAGS += -DFVERSION_IS_ULONG
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 69b3402..b8991ac 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1771,7 +1771,7 @@ bail:
 }
 
 static int ocfs2_dir_foreach_blk_id(struct inode *inode,
-				    u64 *f_version,
+				    f_version_t *f_version,
 				    loff_t *f_pos, void *priv,
 				    filldir_t filldir, int *filldir_err)
 {
@@ -1832,7 +1832,7 @@ revalidate:
 			 * not the directory has been modified
 			 * during the copy operation.
 			 */
-			u64 version = *f_version;
+			f_version_t version = *f_version;
 			unsigned char d_type = DT_UNKNOWN;
 
 			if (de->file_type < OCFS2_FT_MAX)
@@ -1865,7 +1865,7 @@ out:
  * and indexed ones.
  */
 static int ocfs2_dir_foreach_blk_el(struct inode *inode,
-				    u64 *f_version,
+				    f_version_t *f_version,
 				    loff_t *f_pos, void *priv,
 				    filldir_t filldir, int *filldir_err)
 {
@@ -1952,7 +1952,7 @@ revalidate:
 				 * not the directory has been modified
 				 * during the copy operation.
 				 */
-				unsigned long version = *f_version;
+				f_version_t version = *f_version;
 				unsigned char d_type = DT_UNKNOWN;
 
 				if (de->file_type < OCFS2_FT_MAX)
@@ -1983,7 +1983,7 @@ out:
 	return stored;
 }
 
-static int ocfs2_dir_foreach_blk(struct inode *inode, u64 *f_version,
+static int ocfs2_dir_foreach_blk(struct inode *inode, f_version_t *f_version,
 				 loff_t *f_pos, void *priv, filldir_t filldir,
 				 int *filldir_err)
 {
@@ -2003,7 +2003,7 @@ int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
 		      filldir_t filldir)
 {
 	int ret = 0, filldir_err = 0;
-	u64 version = inode->i_version;
+	f_version_t version = inode->i_version;
 
 	while (*f_pos < i_size_read(inode)) {
 		ret = ocfs2_dir_foreach_blk(inode, &version, f_pos, priv,
diff --git a/kapi-compat/include/fversion.h b/kapi-compat/include/fversion.h
new file mode 100644
index 0000000..4977591
--- /dev/null
+++ b/kapi-compat/include/fversion.h
@@ -0,0 +1,10 @@
+#ifndef KAPI_FVERSION_H
+#define KAPI_FVERSION_H
+
+#ifdef FVERSION_IS_ULONG
+typedef unsigned long f_version_t;
+#else
+typedef u64 f_version_t;
+#endif
+
+#endif
-- 
1.5.6.5
