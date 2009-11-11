From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 10 Nov 2009 17:38:25 -0800
Subject: [Ocfs2-devel] [PATCH 3/8] ocfs2: Handle non-const dentry->d_op
In-Reply-To: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
References: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257903510-29198-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e56980d451904b623573ef4966cbab768e433c79 const-ified dentry->d_op.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    6 ++++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/dcache.c |    4 ++++
 fs/ocfs2/dcache.h |    4 ++++
 5 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 2c18b6f..7cda5cb 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -64,6 +64,7 @@ ADDRESS_SPACE_OPS_EXT = @ADDRESS_SPACE_OPS_EXT@
 FVERSION_IS_ULONG = @FVERSION_IS_ULONG@
 SEQ_OPS_IS_NOT_CONST = @SEQ_OPS_IS_NOT_CONST@
 IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
+DOP_IS_NOT_CONST = @DOP_IS_NOT_CONST@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 16d02c3..f79da91 100644
--- a/configure.in
+++ b/configure.in
@@ -242,6 +242,12 @@ OCFS2_CHECK_KERNEL([inode->i_op has the const modifier in fs.h], fs.h,
 AC_SUBST(IOP_IS_NOT_CONST)
 
 
+DOP_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([dentry->d_op has the const modifier in dcache.h], dcache.h,
+  , DOP_IS_NOT_CONST=yes, [^.*const struct dentry_operations \*d_op;])
+AC_SUBST(DOP_IS_NOT_CONST)
+
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index e66665a..4e1a0e6 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -64,6 +64,10 @@ ifdef IOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DIOP_IS_NOT_CONST
 endif
 
+ifdef DOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DDOP_IS_NOT_CONST
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 8ad82bc..55a3fdb 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -500,7 +500,11 @@ out_move:
 	d_move(dentry, target);
 }
 
+#ifdef DOP_IS_NOT_CONST
+struct dentry_operations ocfs2_dentry_ops = {
+#else
 const struct dentry_operations ocfs2_dentry_ops = {
+#endif
 	.d_revalidate		= ocfs2_dentry_revalidate,
 	.d_iput			= ocfs2_dentry_iput,
 };
diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
index d13a087..2703a1a 100644
--- a/fs/ocfs2/dcache.h
+++ b/fs/ocfs2/dcache.h
@@ -26,7 +26,11 @@
 #ifndef OCFS2_DCACHE_H
 #define OCFS2_DCACHE_H
 
+#ifdef DOP_IS_NOT_CONST
+extern struct dentry_operations ocfs2_dentry_ops;
+#else
 extern const struct dentry_operations ocfs2_dentry_ops;
+#endif
 
 struct ocfs2_dentry_lock {
 	/* Use count of dentry lock */
-- 
1.5.6.5
