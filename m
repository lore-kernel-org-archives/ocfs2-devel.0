From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 10 Nov 2009 17:38:28 -0800
Subject: [Ocfs2-devel] [PATCH 6/8] ocfs2: Handle missing const modifier in
	match_token() args
In-Reply-To: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
References: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257903510-29198-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit a447c0932445f92ce6f4c1bd020f62c5097a7842 const-ified match_table_t
argument in match_token().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/super.c  |    4 ++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 9d2feb2..8e1f49a 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -67,6 +67,7 @@ IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
 DOP_IS_NOT_CONST = @DOP_IS_NOT_CONST@
 SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
 EXPORTOP_IS_NOT_CONST = @EXPORTOP_IS_NOT_CONST@
+MATCHTABLE_IS_NOT_CONST = @MATCHTABLE_IS_NOT_CONST@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 2ab0696..b0dabdd 100644
--- a/configure.in
+++ b/configure.in
@@ -257,6 +257,11 @@ OCFS2_CHECK_KERNEL([sb->s_export_op has the const modifier in fs.h], fs.h,
   , EXPORTOP_IS_NOT_CONST=yes, [^.*const struct export_operations \*s_export_op;])
 AC_SUBST(EXPORTOP_IS_NOT_CONST)
 
+MATCHTABLE_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([match_token() takes const arg in parser.h], parser.h,
+ , MATCHTABLE_IS_NOT_CONST=yes, [^int match_token(char \*, const match_table_t table, ])
+AC_SUBST(MATCHTABLE_IS_NOT_CONST)
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index f39b1ee..bd5afb5 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -76,6 +76,10 @@ ifdef EXPORTOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DEXPORTOP_IS_NOT_CONST
 endif
 
+ifdef MATCHTABLE_IS_NOT_CONST
+EXTRA_CFLAGS += -DMATCHTABLE_IS_NOT_CONST
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5e4fbad..bee2c31 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -180,7 +180,11 @@ enum {
 	Opt_err,
 };
 
+#ifdef MATCHTABLE_IS_NOT_CONST
+static match_table_t tokens = {
+#else
 static const match_table_t tokens = {
+#endif
 	{Opt_barrier, "barrier=%u"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
-- 
1.5.6.5
