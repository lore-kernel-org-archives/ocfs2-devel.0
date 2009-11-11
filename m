From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 10 Nov 2009 17:38:29 -0800
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Handle non-const
	vm_area_struct->vm_ops
In-Reply-To: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
References: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257903510-29198-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit f0f37e2f77731b3473fa6bd5ee53255d9a9cdb40 const-ified vm_area_struct->vm_ops.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/mmap.c   |    4 ++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 8e1f49a..32d99a8 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -68,6 +68,7 @@ DOP_IS_NOT_CONST = @DOP_IS_NOT_CONST@
 SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
 EXPORTOP_IS_NOT_CONST = @EXPORTOP_IS_NOT_CONST@
 MATCHTABLE_IS_NOT_CONST = @MATCHTABLE_IS_NOT_CONST@
+VMOP_IS_NOT_CONST = @VMOP_IS_NOT_CONST@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index b0dabdd..e7939c4 100644
--- a/configure.in
+++ b/configure.in
@@ -262,6 +262,11 @@ OCFS2_CHECK_KERNEL([match_token() takes const arg in parser.h], parser.h,
  , MATCHTABLE_IS_NOT_CONST=yes, [^int match_token(char \*, const match_table_t table, ])
 AC_SUBST(MATCHTABLE_IS_NOT_CONST)
 
+VMOP_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([vm_area_struct->vm_ops has the const modifier in mm.h], mm.h,
+  , VMOP_IS_NOT_CONST=yes, [^.*const struct vm_operations_struct \*vm_ops;])
+AC_SUBST(VMOP_IS_NOT_CONST)
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index bd5afb5..b8ce33c 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -80,6 +80,10 @@ ifdef MATCHTABLE_IS_NOT_CONST
 EXTRA_CFLAGS += -DMATCHTABLE_IS_NOT_CONST
 endif
 
+ifdef VMOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DVMOP_IS_NOT_CONST
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 55afd11..b4a25c8 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -202,7 +202,11 @@ out:
 	return ret;
 }
 
+#ifdef VMOP_IS_NOT_CONST
+static struct vm_operations_struct ocfs2_file_vm_ops = {
+#else
 static const struct vm_operations_struct ocfs2_file_vm_ops = {
+#endif
 	.fault		= ocfs2_fault,
 	.page_mkwrite	= ocfs2_page_mkwrite,
 };
-- 
1.5.6.5
