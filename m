From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 19:40:04 -0800
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Handle older prototype of
	register_sysctl_table()
In-Reply-To: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
References: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257997205-18055-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 0b4d414714f0d2f922d39424b0c5c82ad900a381 removed the insert_at_head
argument from register_sysctl_table(). Patch allows building with older kernels.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                              |    3 ++-
 configure.in                          |    5 +++++
 fs/ocfs2/kapi-default.h               |    4 ++++
 fs/ocfs2/stackglue.c                  |    2 +-
 kapi-compat/include/register_sysctl.h |    6 ++++++
 5 files changed, 18 insertions(+), 2 deletions(-)
 create mode 100644 kapi-compat/include/register_sysctl.h

diff --git a/Makefile b/Makefile
index 01b0033..a8d30d0 100644
--- a/Makefile
+++ b/Makefile
@@ -21,7 +21,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/aiovec.h			\
 	kapi-compat/include/mandatory_lock.h		\
 	kapi-compat/include/fsuid.h			\
-	kapi-compat/include/umh_wait.h
+	kapi-compat/include/umh_wait.h			\
+	kapi-compat/include/register_sysctl.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 9cfdbe3..cc0574a 100644
--- a/configure.in
+++ b/configure.in
@@ -318,6 +318,11 @@ OCFS2_CHECK_KERNEL([enum umh_wait in kmod.h], kmod.h,
   , kmod_compat_header=umh_wait.h, [enum umh_wait {])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $kmod_compat_header"
 
+old_register_sysctl=
+OCFS2_CHECK_KERNEL([register_sysctl_table() has one arg in sysctl.h], sysctl.h,
+  , old_register_sysctl=register_sysctl.h, [^struct ctl_table_header \*register_sysctl_table(struct ctl_table \* table);])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $old_register_sysctl"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/kapi-default.h b/fs/ocfs2/kapi-default.h
index d068aaf..7489a19 100644
--- a/fs/ocfs2/kapi-default.h
+++ b/fs/ocfs2/kapi-default.h
@@ -46,4 +46,8 @@ typedef u64 f_version_t;
 # define ocfs2_file_aio_write	__ocfs2_file_aio_write
 #endif
 
+#ifndef kapi_register_sysctl_table
+# define kapi_register_sysctl_table(a)	register_sysctl_table(a)
+#endif
+
 #endif
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 3f2f1c4..b4c85be 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -678,7 +678,7 @@ static int __init ocfs2_stack_glue_init(void)
 {
 	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
 
-	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
+	ocfs2_table_header = kapi_register_sysctl_table(ocfs2_root_table);
 	if (!ocfs2_table_header) {
 		printk(KERN_ERR
 		       "ocfs2 stack glue: unable to register sysctl\n");
diff --git a/kapi-compat/include/register_sysctl.h b/kapi-compat/include/register_sysctl.h
new file mode 100644
index 0000000..15d9068
--- /dev/null
+++ b/kapi-compat/include/register_sysctl.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_REGISTER_SYSCTL_H
+#define KAPI_REGISTER_SYSCTL_H
+
+#define kapi_register_sysctl_table(a)	register_sysctl_table(a, 0)
+
+#endif
-- 
1.5.6.5
