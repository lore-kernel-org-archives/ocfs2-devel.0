From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Jan  3 11:21:55 2008
Subject: [Ocfs2-devel] [PATCH 25/30] ocfs2: Handle missing const s_op in
	struct super_block
In-Reply-To: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199388006-32658-24-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit ee9b6d61a2a43c5952eb43283f8db284a4e70b8a in mainline marks
struct super_operations as a const in struct super_block. This patch
allows one to build with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in        |    1 +
 configure.in          |    5 +++++
 fs/ocfs2/Makefile     |    4 ++++
 fs/ocfs2/dlm/Makefile |    4 ++++
 fs/ocfs2/dlm/dlmfs.c  |    8 ++++++++
 fs/ocfs2/super.c      |    4 ++++
 6 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index a44bbe3..8479f37 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -70,6 +70,7 @@ NO_FALLOCATE = @NO_FALLOCATE@
 NO_SPLICE_HEADER = @NO_SPLICE_HEADER@
 NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 NO_GENERIC_SEGMENT_CHECKS = @NO_GENERIC_SEGMENT_CHECKS@
+SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index 2f7e19c..4771818 100644
--- a/configure.in
+++ b/configure.in
@@ -275,6 +275,11 @@ OCFS2_CHECK_KERNEL([generic_segment_checks() in fs.h], fs.h,
 AC_SUBST(NO_GENERIC_SEGMENT_CHECKS)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS generic_segment_checks.h"
 
+SOP_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([s_op declared as const in struct super_block in fs.h], fs.h,
+  , SOP_IS_NOT_CONST=yes, [^.*const struct super_operations.*\*s_op;])
+AC_SUBST(SOP_IS_NOT_CONST)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 98a7ada..5a8a838 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -65,6 +65,10 @@ ifdef NO_GENERIC_SEGMENT_CHECKS
 CFLAGS_file.o += -DNO_GENERIC_SEGMENT_CHECKS
 endif
 
+ifdef SOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DSOP_IS_NOT_CONST
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 76d794b..5108301 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -32,6 +32,10 @@ ifdef STRUCT_SUBSYSTEM_DEFINED
 EXTRA_CFLAGS += -DSTRUCT_SUBSYSTEM_DEFINED
 endif
 
+ifdef SOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DSOP_IS_NOT_CONST
+endif
+
 DLM_SOURCES =			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 78704a1..6d57554 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -60,7 +60,11 @@
 #define MLOG_MASK_PREFIX ML_DLMFS
 #include "cluster/masklog.h"
 
+#ifdef SOP_IS_NOT_CONST
+static struct super_operations dlmfs_ops;
+#else
 static const struct super_operations dlmfs_ops;
+#endif
 static const struct file_operations dlmfs_file_operations;
 static const struct inode_operations dlmfs_dir_inode_operations;
 static const struct inode_operations dlmfs_root_inode_operations;
@@ -556,7 +560,11 @@ static const struct inode_operations dlmfs_root_inode_operations = {
 	.rmdir		= simple_rmdir,
 };
 
+#ifdef SOP_IS_NOT_CONST
+static struct super_operations dlmfs_ops = {
+#else
 static const struct super_operations dlmfs_ops = {
+#endif
 	.statfs		= simple_statfs,
 	.alloc_inode	= dlmfs_alloc_inode,
 	.destroy_inode	= dlmfs_destroy_inode,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f5c424d..43147c0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -124,7 +124,11 @@ static void ocfs2_write_super(struct super_block *sb);
 static struct inode *ocfs2_alloc_inode(struct super_block *sb);
 static void ocfs2_destroy_inode(struct inode *inode);
 
+#ifdef SOP_IS_NOT_CONST
+static struct super_operations ocfs2_sops = {
+#else
 static const struct super_operations ocfs2_sops = {
+#endif
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
 	.destroy_inode	= ocfs2_destroy_inode,
-- 
1.5.2.5
