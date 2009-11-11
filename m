From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 10 Nov 2009 17:38:23 -0800
Subject: [Ocfs2-devel] [PATCH 1/8] ocfs2: Handle non-const seq_operations
In-Reply-To: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
References: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257903510-29198-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 15ad7cdcfd76450d4beebc789ec646664238184d const-ified seq_file->op.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in     |    1 +
 configure.in       |    5 +++++
 fs/ocfs2/Makefile  |    4 ++++
 fs/ocfs2/dlmglue.c |    4 ++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index ba72950..18edfa8 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -62,6 +62,7 @@ NO_DLMCONSTANTS_HEADER = @NO_DLMCONSTANTS_HEADER@
 NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
 ADDRESS_SPACE_OPS_EXT = @ADDRESS_SPACE_OPS_EXT@
 FVERSION_IS_ULONG = @FVERSION_IS_ULONG@
+SEQ_OPS_IS_NOT_CONST = @SEQ_OPS_IS_NOT_CONST@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 7ee2d34..b1aaf4e 100644
--- a/configure.in
+++ b/configure.in
@@ -231,6 +231,11 @@ if test "x$FVERSION_IS_ULONG" = "x" ; then
 fi
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS fversion.h"
 
+SEQ_OPS_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([const struct seq_operations in seq_file.h], seq_file.h,
+  , SEQ_OPS_IS_NOT_CONST=yes, [const struct seq_operations \*op;])
+AC_SUBST(SEQ_OPS_IS_NOT_CONST)
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index e6b5801..37d3009 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -56,6 +56,10 @@ ifdef FVERSION_IS_ULONG
 EXTRA_CFLAGS += -DFVERSION_IS_ULONG
 endif
 
+ifdef SEQ_OPS_IS_NOT_CONST
+EXTRA_CFLAGS += -DSEQ_OPS_IS_NOT_CONST
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 0d38d67..0b73382 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2834,7 +2834,11 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+#ifndef SEQ_OPS_IS_NOT_CONST
 static const struct seq_operations ocfs2_dlm_seq_ops = {
+#else
+static struct seq_operations ocfs2_dlm_seq_ops = {
+#endif
 	.start =	ocfs2_dlm_seq_start,
 	.stop =		ocfs2_dlm_seq_stop,
 	.next =		ocfs2_dlm_seq_next,
-- 
1.5.6.5
