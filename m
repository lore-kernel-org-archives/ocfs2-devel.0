From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Dec 31 14:25:38 2007
Subject: [Ocfs2-devel] [PATCH 30/30] ocfs2: Handle missing exportfs.h
In-Reply-To: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199139862-31452-29-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit a569425512253992cc64ebf8b6d00a62f986db3e in mainline
moved struct export_operation from fs.h to exportfs.h. This
patch allows one to build ocfs2 with kernels having/not having
this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/export.h |    2 ++
 4 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 98577c6..ed67a49 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -75,6 +75,7 @@ IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
 NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
 NO_SPLICE_FROM_PIPE = @NO_SPLICE_FROM_PIPE@
 OLD_BIO_END_IO = @OLD_BIO_END_IO@
+NO_EXPORTFS_HEADER = @NO_EXPORTFS_HEADER@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index ba2153a..2c3ea77 100644
--- a/configure.in
+++ b/configure.in
@@ -300,6 +300,11 @@ OCFS2_CHECK_KERNEL([old bio_end_io_t in bio.h], bio.h,
   OLD_BIO_END_IO=yes, , [^typedef int (bio_end_io_t) (struct bio \*, unsigned int, int);])
 AC_SUBST(OLD_BIO_END_IO)
 
+NO_EXPORTFS_HEADER=
+OCFS2_CHECK_KERNEL([exportfs.h], exportfs.h,
+  , NO_EXPORTFS_HEADER=yes, [^struct export_operations {])
+AC_SUBST(NO_EXPORTFS_HEADER)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 529de3d..5045b3e 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -81,6 +81,10 @@ ifdef NO_SPLICE_FROM_PIPE
 EXTRA_CFLAGS += -DNO_SPLICE_FROM_PIPE
 endif
 
+ifdef NO_EXPORTFS_HEADER
+EXTRA_CFLAGS += -DNO_EXPORTFS_HEADER
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/export.h b/fs/ocfs2/export.h
index e08bed9..591b185 100644
--- a/fs/ocfs2/export.h
+++ b/fs/ocfs2/export.h
@@ -26,7 +26,9 @@
 #ifndef OCFS2_EXPORT_H
 #define OCFS2_EXPORT_H
 
+#ifndef NO_EXPORTFS_HEADER
 #include <linux/exportfs.h>
+#endif
 
 extern struct export_operations ocfs2_export_ops;
 
-- 
1.5.3.4
