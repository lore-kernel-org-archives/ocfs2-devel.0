From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:56 -0800
Subject: [Ocfs2-devel] [PATCH 09/10] ocfs2: Temporarily disable NFS exports
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have no intention of disabling NFS exports in OCFS2 1.6. However, writing
a clean patch to enable it in EL5 will take sometime. This is being done only
because we want to start testing the fs now.

TODO: Enable NFS exports

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    2 ++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/export.c |    4 ++++
 fs/ocfs2/export.h |    3 +++
 fs/ocfs2/super.c  |    2 ++
 6 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 8675982..acbe8fd 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -83,6 +83,7 @@ SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
 NO_KOBJ_ATTRIBUTE = @NO_KOBJ_ATTRIBUTE@
 SKIP_QUOTAS= @SKIP_QUOTAS@
+SKIP_EXPORTS= @SKIP_EXPORTS@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 3dfe596..9913820 100644
--- a/configure.in
+++ b/configure.in
@@ -452,6 +452,8 @@ OCFS2_CHECK_KERNEL([new quota format in dqblk_qtree.h], dqblk_qtree.h,
 AC_SUBST(SKIP_QUOTAS)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $SKIP_QUOTAS"
 
+SKIP_EXPORTS=yes
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 7a03c94..848c121 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -132,6 +132,10 @@ ifdef SKIP_QUOTAS
 EXTRA_CFLAGS += -DSKIP_QUOTAS
 endif
 
+ifdef SKIP_EXPORTS
+EXTRA_CFLAGS += -DSKIP_EXPORTS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index fce7d23..e2a584f 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -23,6 +23,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#ifndef SKIP_EXPORTS
+
 #include <linux/fs.h>
 #include <linux/types.h>
 
@@ -285,3 +287,5 @@ const struct export_operations ocfs2_export_ops = {
 	.fh_to_parent	= ocfs2_fh_to_parent,
 	.get_parent	= ocfs2_get_parent,
 };
+
+#endif	/* SKIP_EXPORTS */
diff --git a/fs/ocfs2/export.h b/fs/ocfs2/export.h
index 0707bf3..1f93127 100644
--- a/fs/ocfs2/export.h
+++ b/fs/ocfs2/export.h
@@ -26,6 +26,8 @@
 #ifndef OCFS2_EXPORT_H
 #define OCFS2_EXPORT_H
 
+#ifndef SKIP_EXPORTS
+
 #include <linux/exportfs.h>
 
 #ifdef EXPORTOP_IS_NOT_CONST
@@ -34,4 +36,5 @@ extern struct export_operations ocfs2_export_ops;
 extern const struct export_operations ocfs2_export_ops;
 #endif
 
+#endif
 #endif /* OCFS2_EXPORT_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5092558..f6e2c69 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2006,7 +2006,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
+#ifndef SKIP_EXPORTS
 	sb->s_export_op = &ocfs2_export_ops;
+#endif
 #ifndef SKIP_QUOTAS
 	sb->s_qcop = &ocfs2_quotactl_ops;
 	sb->dq_op = &ocfs2_quota_operations;
-- 
1.5.6.5
