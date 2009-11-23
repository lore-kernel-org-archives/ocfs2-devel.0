From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 23 Nov 2009 13:31:41 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Enable fallocate() support
In-Reply-To: <1259011901-13582-1-git-send-email-sunil.mushran@oracle.com>
References: <1259011901-13582-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1259011901-13582-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

EL5 U4 enables fallocate() support for file systems that has FS_HAS_FALLOCATE
flag set. Patch detects such kernels and appends the flag to enable it.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/super.c  |    4 ++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index c149524..c12ee75 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -85,6 +85,7 @@ NO_KOBJ_ATTRIBUTE = @NO_KOBJ_ATTRIBUTE@
 SKIP_QUOTAS= @SKIP_QUOTAS@
 SKIP_EXPORTS= @SKIP_EXPORTS@
 APPEND_FIEMAP_FLAG=@APPEND_FIEMAP_FLAG@
+APPEND_FALLOCATE_FLAG=@APPEND_FALLOCATE_FLAG@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index fc46d2c..af7b575 100644
--- a/configure.in
+++ b/configure.in
@@ -464,6 +464,11 @@ OCFS2_CHECK_KERNEL([	FS_HAS_FIEMAP in fs.h], fs.h,
  APPEND_FIEMAP_FLAG=yes, , [#define FS_HAS_FIEMAP ])
 AC_SUBST(APPEND_FIEMAP_FLAG)
 
+APPEND_FALLOCATE_FLAG=
+OCFS2_CHECK_KERNEL([	FS_HAS_FALLOCATE in fs.h], fs.h,
+ APPEND_FALLOCATE_FLAG=yes, , [#define FS_HAS_FALLOCATE ])
+AC_SUBST(APPEND_FALLOCATE_FLAG)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 1905000..1cc1aaf 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -140,6 +140,10 @@ ifdef APPEND_FIEMAP_FLAG
 EXTRA_CFLAGS += -DAPPEND_FIEMAP_FLAG
 endif
 
+ifdef APPEND_FALLOCATE_FLAG
+EXTRA_CFLAGS += -DAPPEND_FALLOCATE_FLAG
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index adc337f..fe79509 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1563,6 +1563,10 @@ static int __init ocfs2_init(void)
 	ocfs2_fs_type.fs_flags |= FS_HAS_FIEMAP;
 #endif
 
+#ifdef APPEND_FALLOCATE_FLAG
+	ocfs2_fs_type.fs_flags |= FS_HAS_FALLOCATE;
+#endif
+
 	status = init_ocfs2_uptodate_cache();
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.6.3.3
