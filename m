From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 11 10:53:27 2008
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Detect and use MS_LOOP_NO_AOPS
In-Reply-To: <1202755969-7115-1-git-send-email-sunil.mushran@oracle.com>
References: <1202755969-7115-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1202755969-7115-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Some vendor kernels provide a superblock flag, MS_LOOP_NO_AOPS which will
enable writable loopback support for ocfs2 1.4. Detect that flag and use it
if possible.

This patch was forward-ported from 1.2.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/super.c  |    4 ++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 0d6b2df..a9740e8 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -93,6 +93,7 @@ INVALIDATEPAGE_RETURNS_INT = @INVALIDATEPAGE_RETURNS_INT@
 DIO_OLD_GET_BLOCKS = @DIO_OLD_GET_BLOCKS@
 NO_LINUX_UACCESS_H = @NO_LINUX_UACCESS_H@
 NO_SYSTEM_UTSNAME = @NO_SYSTEM_UTSNAME@
+HAS_MS_LOOP_NO_AOPS  = @HAS_MS_LOOP_NO_AOPS@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index 29ab597..a1c5d19 100644
--- a/configure.in
+++ b/configure.in
@@ -410,6 +410,11 @@ OCFS2_CHECK_KERNEL([system_utsname in utsname.h], utsname.h, ,
   NO_SYSTEM_UTSNAME=yes, [^extern struct new_utsname system_utsname])
 AC_SUBST(NO_SYSTEM_UTSNAME)
 
+HAS_MS_LOOP_NO_AOPS=
+OCFS2_CHECK_KERNEL([MS_LOOP_NO_AOPS flag defined], fs.h,
+  HAS_MS_LOOP_NO_AOPS==yes, , [MS_LOOP_NO_AOPS])
+AC_SUBST(HAS_MS_LOOP_NO_AOPS)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index c80e2a0..05a94c7 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -160,6 +160,10 @@ ifdef NO_LINUX_UACCESS_H
 EXTRA_CFLAGS += -DNO_LINUX_UACCESS_H
 endif
 
+ifdef HAS_MS_LOOP_NO_AOPS
+EXTRA_CFLAGS += -DHAS_MS_LOOP_NO_AOPS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index d5e2644..9ce5cc8 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -724,6 +724,10 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
+#ifdef HAS_MS_LOOP_NO_AOPS
+	/* OCFS2's prepare and commit write operations don't do any locking. */
+	sb->s_flags |= MS_LOOP_NO_AOPS;
+#endif
 	mlog_exit(status);
 	return status;
 
-- 
1.5.3.4
