From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan  9 18:00:03 2008
Subject: [Ocfs2-devel] [PATCH 21/30] ocfs2: Handle splice.h
In-Reply-To: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
References: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199930370-17076-20-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit d6b29d7cee064f28ca097e906de7453541351095 in mainline moves the splice
structures from pipe_fs_i.h to splice.h. This patch allows one to build
ocfs2 with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |    2 ++
 4 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index a33fba9..ad1c8e9 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -67,6 +67,7 @@ REGISTER_SYSCTL_TWO_ARGS = @REGISTER_SYSCTL_TWO_ARGS@
 NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM = @NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM@
 STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
 NO_FALLOCATE = @NO_FALLOCATE@
+NO_SPLICE_HEADER = @NO_SPLICE_HEADER@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index d93a896..19c38d4 100644
--- a/configure.in
+++ b/configure.in
@@ -264,6 +264,11 @@ OCFS2_CHECK_KERNEL([fallocate() in fs.h], fs.h,
   , NO_FALLOCATE=yes, [^.*long (\*fallocate)])
 AC_SUBST(NO_FALLOCATE)
 
+NO_SPLICE_HEADER=
+OCFS2_CHECK_KERNEL([struct splice_desc in splice.h], splice.h,
+  , NO_SPLICE_HEADER=yes, [^struct splice_desc ])
+AC_SUBST(NO_SPLICE_HEADER)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 7b40064..f4c9428 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -60,6 +60,10 @@ ifdef NO_FALLOCATE
 EXTRA_CFLAGS += -DNO_FALLOCATE
 endif
 
+ifdef NO_SPLICE_HEADER
+EXTRA_CFLAGS += -DNO_SPLICE_HEADER
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 45b1c05..ad38a21 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -31,7 +31,9 @@
 #include <linux/pagemap.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
+#ifndef NO_SPLICE_HEADER
 #include <linux/splice.h>
+#endif
 #include <linux/mount.h>
 #include <linux/writeback.h>
 #ifndef NO_FALLOCATE
-- 
1.5.2.5
