From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Jan  3 11:21:59 2008
Subject: [Ocfs2-devel] [PATCH 20/30] ocfs2: Handle missing iop->fallocate()
In-Reply-To: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199388006-32658-19-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 97ac73506c0ba93f30239bb57b4cfc5d73e68a62 in mainline introduces a
new iop, fallocate(). This patch allows one to build ocfs2 with kernels
having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |    6 ++++++
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 34c4825..7d0ca7d 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -66,6 +66,7 @@ KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
 REGISTER_SYSCTL_TWO_ARGS = @REGISTER_SYSCTL_TWO_ARGS@
 NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM = @NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM@
 STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
+NO_FALLOCATE = @NO_FALLOCATE@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index 4e47421..d258f97 100644
--- a/configure.in
+++ b/configure.in
@@ -248,6 +248,11 @@ OCFS2_CHECK_KERNEL([is_owner_or_cap() in fs.h], fs.h,
   , cap_compat_header="cap.h", [^#define is_owner_or_cap])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $cap_compat_header"
 
+NO_FALLOCATE=
+OCFS2_CHECK_KERNEL([fallocate() in fs.h], fs.h,
+  , NO_FALLOCATE=yes, [^.*long (\*fallocate)])
+AC_SUBST(NO_FALLOCATE)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 2511fba..3b13b0c 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -49,6 +49,10 @@ ifdef STRUCT_SUBSYSTEM_DEFINED
 EXTRA_CFLAGS += -DSTRUCT_SUBSYSTEM_DEFINED
 endif
 
+ifdef NO_FALLOCATE
+EXTRA_CFLAGS += -DNO_FALLOCATE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1ccf8ea..45b1c05 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -34,7 +34,9 @@
 #include <linux/splice.h>
 #include <linux/mount.h>
 #include <linux/writeback.h>
+#ifndef NO_FALLOCATE
 #include <linux/falloc.h>
+#endif
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
@@ -1749,6 +1751,7 @@ int ocfs2_change_file_space(struct file *file, unsigned int cmd,
 	return __ocfs2_change_file_space(file, inode, file->f_pos, cmd, sr, 0);
 }
 
+#ifndef NO_FALLOCATE
 static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 			    loff_t len)
 {
@@ -1772,6 +1775,7 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	return __ocfs2_change_file_space(NULL, inode, offset,
 					 OCFS2_IOC_RESVSP64, &sr, change_size);
 }
+#endif
 
 static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 					 loff_t *ppos,
@@ -2397,7 +2401,9 @@ const struct inode_operations ocfs2_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
+#ifndef NO_FALLOCATE
 	.fallocate	= ocfs2_fallocate,
+#endif
 };
 
 const struct inode_operations ocfs2_special_file_iops = {
-- 
1.5.2.5
