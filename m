From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Dec 20 15:30:08 2007
Subject: [Ocfs2-devel] [PATCH 19/30] ocfs2: Handle missing iop->fallocate()
In-Reply-To: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1198193387-16606-18-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 97ac73506c0ba93f30239bb57b4cfc5d73e68a62 in mainline introduces a
new iop, fallocate(). This patch allows one to build ocfs2 with kernels
having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |    6 ++++++
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index a27e274..3818cd5 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -65,6 +65,7 @@ KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
 REGISTER_SYSCTL_TWO_ARGS = @REGISTER_SYSCTL_TWO_ARGS@
 SU_MUTEX_DEFINED = @SU_MUTEX_DEFINED@
 STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
+FALLOCATE_DEFINED = @FALLOCATE_DEFINED@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index f8b5f20..74337ee 100644
--- a/configure.in
+++ b/configure.in
@@ -242,6 +242,11 @@ OCFS2_CHECK_KERNEL([is_owner_or_cap() in fs.h], fs.h,
   , cap_compat_header="cap.h", [^#define is_owner_or_cap])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $cap_compat_header"
 
+FALLOCATE_DEFINED=
+OCFS2_CHECK_KERNEL([fallocate() in fs.h], fs.h,
+  FALLOCATE_DEFINED=yes, , [^.*long (\*fallocate)])
+AC_SUBST(FALLOCATE_DEFINED)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 5c290b7..6f21960 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -45,6 +45,10 @@ ifdef STRUCT_SUBSYSTEM_DEFINED
 EXTRA_CFLAGS += -DSTRUCT_SUBSYSTEM_DEFINED
 endif
 
+ifdef FALLOCATE_DEFINED
+EXTRA_CFLAGS += -DFALLOCATE_DEFINED
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index adb10b9..ce18447 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -34,7 +34,9 @@
 #include <linux/splice.h>
 #include <linux/mount.h>
 #include <linux/writeback.h>
+#ifdef FALLOCATE_DEFINED
 #include <linux/falloc.h>
+#endif
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
@@ -1749,6 +1751,7 @@ int ocfs2_change_file_space(struct file *file, unsigned int cmd,
 	return __ocfs2_change_file_space(file, inode, file->f_pos, cmd, sr, 0);
 }
 
+#ifdef FALLOCATE_DEFINED
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
+#ifdef FALLOCATE_DEFINED
 	.fallocate	= ocfs2_fallocate,
+#endif
 };
 
 const struct inode_operations ocfs2_special_file_iops = {
-- 
1.5.2.5
