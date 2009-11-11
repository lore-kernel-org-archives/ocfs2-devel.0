From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 10 Nov 2009 17:38:26 -0800
Subject: [Ocfs2-devel] [PATCH 4/8] ocfs2: Handle non-const sb->s_op
In-Reply-To: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
References: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257903510-29198-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit ee9b6d61a2a43c5952eb43283f8db284a4e70b8a const-ified sb->s_op.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in        |    1 +
 configure.in          |    5 +++++
 fs/ocfs2/Makefile     |    4 ++++
 fs/ocfs2/dlm/Makefile |    4 ++++
 fs/ocfs2/dlm/dlmfs.c  |    8 ++++++++
 fs/ocfs2/super.c      |    4 ++++
 6 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 7cda5cb..9da1d2b 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -65,6 +65,7 @@ FVERSION_IS_ULONG = @FVERSION_IS_ULONG@
 SEQ_OPS_IS_NOT_CONST = @SEQ_OPS_IS_NOT_CONST@
 IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
 DOP_IS_NOT_CONST = @DOP_IS_NOT_CONST@
+SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index f79da91..76ea242 100644
--- a/configure.in
+++ b/configure.in
@@ -247,6 +247,11 @@ OCFS2_CHECK_KERNEL([dentry->d_op has the const modifier in dcache.h], dcache.h,
   , DOP_IS_NOT_CONST=yes, [^.*const struct dentry_operations \*d_op;])
 AC_SUBST(DOP_IS_NOT_CONST)
 
+SOP_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([sb->s_op has the const modifier in fs.h], fs.h,
+  , SOP_IS_NOT_CONST=yes, [^.*const struct super_operations.*\*s_op;])
+AC_SUBST(SOP_IS_NOT_CONST)
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 4e1a0e6..ddeb107 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -68,6 +68,10 @@ ifdef DOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DDOP_IS_NOT_CONST
 endif
 
+ifdef SOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DSOP_IS_NOT_CONST
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 250994f..b70058d 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -34,6 +34,10 @@ ifdef IOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
 endif
 
+ifdef SOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DSOP_IS_NOT_CONST
+endif
+
 DLM_SOURCES +=			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index b1b9996..d05653d 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -62,7 +62,11 @@
 
 #include "ocfs2_lockingver.h"
 
+#ifdef SOP_IS_NOT_CONST
+static struct super_operations dlmfs_ops;
+#else
 static const struct super_operations dlmfs_ops;
+#endif
 static const struct file_operations dlmfs_file_operations;
 #ifdef IOP_IS_NOT_CONST
 static struct inode_operations dlmfs_dir_inode_operations;
@@ -580,7 +584,11 @@ static const struct inode_operations dlmfs_root_inode_operations = {
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
index 8c8b206..5e4fbad 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -135,7 +135,11 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
 
+#ifdef SOP_IS_NOT_CONST
+static struct super_operations ocfs2_sops = {
+#else
 static const struct super_operations ocfs2_sops = {
+#endif
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
 	.destroy_inode	= ocfs2_destroy_inode,
-- 
1.5.6.5
