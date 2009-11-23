From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 23 Nov 2009 13:31:40 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Enable fiemap() support
In-Reply-To: <1259011901-13582-1-git-send-email-sunil.mushran@oracle.com>
References: <1259011901-13582-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1259011901-13582-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

EL5 U4 enables fiemap() support for file systems that has FS_HAS_FIEMAP
flag set. Patch detects such kernels and appends the flag to enable it.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/super.c  |    4 ++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index acbe8fd..c149524 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -84,6 +84,7 @@ NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
 NO_KOBJ_ATTRIBUTE = @NO_KOBJ_ATTRIBUTE@
 SKIP_QUOTAS= @SKIP_QUOTAS@
 SKIP_EXPORTS= @SKIP_EXPORTS@
+APPEND_FIEMAP_FLAG=@APPEND_FIEMAP_FLAG@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 405e1a5..fc46d2c 100644
--- a/configure.in
+++ b/configure.in
@@ -459,6 +459,11 @@ OCFS2_CHECK_KERNEL([cancel_work_sync() in workqueue.h], workqueue.h,
  , cancel_work_sync_header=cancel_work_sync.h, [extern int cancel_work_sync(struct work_struct])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $cancel_work_sync_header"
 
+APPEND_FIEMAP_FLAG=
+OCFS2_CHECK_KERNEL([	FS_HAS_FIEMAP in fs.h], fs.h,
+ APPEND_FIEMAP_FLAG=yes, , [#define FS_HAS_FIEMAP ])
+AC_SUBST(APPEND_FIEMAP_FLAG)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 848c121..1905000 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -136,6 +136,10 @@ ifdef SKIP_EXPORTS
 EXTRA_CFLAGS += -DSKIP_EXPORTS
 endif
 
+ifdef APPEND_FIEMAP_FLAG
+EXTRA_CFLAGS += -DAPPEND_FIEMAP_FLAG
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f6e2c69..adc337f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1559,6 +1559,10 @@ static int __init ocfs2_init(void)
 
 	ocfs2_print_version();
 
+#ifdef APPEND_FIEMAP_FLAG
+	ocfs2_fs_type.fs_flags |= FS_HAS_FIEMAP;
+#endif
+
 	status = init_ocfs2_uptodate_cache();
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.6.3.3
