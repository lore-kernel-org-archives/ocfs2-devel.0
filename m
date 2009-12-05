From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  4 Dec 2009 17:54:05 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Reverse patch that disabled NFS
In-Reply-To: <1259978046-5692-1-git-send-email-sunil.mushran@oracle.com>
References: <1259978046-5692-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1259978046-5692-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch reverses commit 73359af38a74b691d30e889c707266bf436476cb.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 -
 configure.in      |    2 --
 fs/ocfs2/Makefile |    4 ----
 fs/ocfs2/export.c |    4 ----
 fs/ocfs2/export.h |    3 ---
 fs/ocfs2/super.c  |    2 --
 6 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index acbe8fd..8675982 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -83,7 +83,6 @@ SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
 NO_KOBJ_ATTRIBUTE = @NO_KOBJ_ATTRIBUTE@
 SKIP_QUOTAS= @SKIP_QUOTAS@
-SKIP_EXPORTS= @SKIP_EXPORTS@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 405e1a5..6b83f8c 100644
--- a/configure.in
+++ b/configure.in
@@ -452,8 +452,6 @@ OCFS2_CHECK_KERNEL([new quota format in dqblk_qtree.h], dqblk_qtree.h,
 AC_SUBST(SKIP_QUOTAS)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $SKIP_QUOTAS"
 
-SKIP_EXPORTS=yes
-
 cancel_work_sync_header=
 OCFS2_CHECK_KERNEL([cancel_work_sync() in workqueue.h], workqueue.h,
  , cancel_work_sync_header=cancel_work_sync.h, [extern int cancel_work_sync(struct work_struct])
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 848c121..7a03c94 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -132,10 +132,6 @@ ifdef SKIP_QUOTAS
 EXTRA_CFLAGS += -DSKIP_QUOTAS
 endif
 
-ifdef SKIP_EXPORTS
-EXTRA_CFLAGS += -DSKIP_EXPORTS
-endif
-
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index e2a584f..fce7d23 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -23,8 +23,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#ifndef SKIP_EXPORTS
-
 #include <linux/fs.h>
 #include <linux/types.h>
 
@@ -287,5 +285,3 @@ const struct export_operations ocfs2_export_ops = {
 	.fh_to_parent	= ocfs2_fh_to_parent,
 	.get_parent	= ocfs2_get_parent,
 };
-
-#endif	/* SKIP_EXPORTS */
diff --git a/fs/ocfs2/export.h b/fs/ocfs2/export.h
index 1f93127..0707bf3 100644
--- a/fs/ocfs2/export.h
+++ b/fs/ocfs2/export.h
@@ -26,8 +26,6 @@
 #ifndef OCFS2_EXPORT_H
 #define OCFS2_EXPORT_H
 
-#ifndef SKIP_EXPORTS
-
 #include <linux/exportfs.h>
 
 #ifdef EXPORTOP_IS_NOT_CONST
@@ -36,5 +34,4 @@ extern struct export_operations ocfs2_export_ops;
 extern const struct export_operations ocfs2_export_ops;
 #endif
 
-#endif
 #endif /* OCFS2_EXPORT_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index cf50330..a104314 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2020,9 +2020,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
-#ifndef SKIP_EXPORTS
 	sb->s_export_op = &ocfs2_export_ops;
-#endif
 #ifndef SKIP_QUOTAS
 	sb->s_qcop = &ocfs2_quotactl_ops;
 	sb->dq_op = &ocfs2_quota_operations;
-- 
1.6.3.3
