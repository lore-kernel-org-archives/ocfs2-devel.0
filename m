From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 10 Nov 2009 17:38:27 -0800
Subject: [Ocfs2-devel] [PATCH 5/8] ocfs2: Handle non-const sb->s_export_op
In-Reply-To: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
References: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257903510-29198-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 39655164405940d4818224a085e35420e2f97aed const-ified sb->s_export_op.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/export.c |    4 ++++
 fs/ocfs2/export.h |    4 ++++
 5 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 9da1d2b..9d2feb2 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -66,6 +66,7 @@ SEQ_OPS_IS_NOT_CONST = @SEQ_OPS_IS_NOT_CONST@
 IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
 DOP_IS_NOT_CONST = @DOP_IS_NOT_CONST@
 SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
+EXPORTOP_IS_NOT_CONST = @EXPORTOP_IS_NOT_CONST@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 76ea242..2ab0696 100644
--- a/configure.in
+++ b/configure.in
@@ -252,6 +252,11 @@ OCFS2_CHECK_KERNEL([sb->s_op has the const modifier in fs.h], fs.h,
   , SOP_IS_NOT_CONST=yes, [^.*const struct super_operations.*\*s_op;])
 AC_SUBST(SOP_IS_NOT_CONST)
 
+EXPORTOP_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([sb->s_export_op has the const modifier in fs.h], fs.h,
+  , EXPORTOP_IS_NOT_CONST=yes, [^.*const struct export_operations \*s_export_op;])
+AC_SUBST(EXPORTOP_IS_NOT_CONST)
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index ddeb107..f39b1ee 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -72,6 +72,10 @@ ifdef SOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DSOP_IS_NOT_CONST
 endif
 
+ifdef EXPORTOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DEXPORTOP_IS_NOT_CONST
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 15713cb..fce7d23 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -275,7 +275,11 @@ static struct dentry *ocfs2_fh_to_parent(struct super_block *sb,
 	return ocfs2_get_dentry(sb, &parent);
 }
 
+#ifdef EXPORTOP_IS_NOT_CONST
+struct export_operations ocfs2_export_ops = {
+#else
 const struct export_operations ocfs2_export_ops = {
+#endif
 	.encode_fh	= ocfs2_encode_fh,
 	.fh_to_dentry	= ocfs2_fh_to_dentry,
 	.fh_to_parent	= ocfs2_fh_to_parent,
diff --git a/fs/ocfs2/export.h b/fs/ocfs2/export.h
index 41a7386..0707bf3 100644
--- a/fs/ocfs2/export.h
+++ b/fs/ocfs2/export.h
@@ -28,6 +28,10 @@
 
 #include <linux/exportfs.h>
 
+#ifdef EXPORTOP_IS_NOT_CONST
+extern struct export_operations ocfs2_export_ops;
+#else
 extern const struct export_operations ocfs2_export_ops;
+#endif
 
 #endif /* OCFS2_EXPORT_H */
-- 
1.5.6.5
