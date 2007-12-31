From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Dec 31 14:25:54 2007
Subject: [Ocfs2-devel] [PATCH 16/30] ocfs2: Handle different prototypes of
	register_sysctl_table()
In-Reply-To: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199139862-31452-15-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 0b4d414714f0d2f922d39424b0c5c82ad900a381 in mainline removes the
insert_at_head argument from register_sysctl_table(). This patch allows
building ocfs2 with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in                        |    1 +
 Makefile                              |    3 ++-
 configure.in                          |    6 ++++++
 fs/ocfs2/cluster/Makefile             |    4 ++++
 fs/ocfs2/cluster/nodemanager.c        |    2 +-
 kapi-compat/include/register_sysctl.h |   10 ++++++++++
 6 files changed, 24 insertions(+), 2 deletions(-)
 create mode 100644 kapi-compat/include/register_sysctl.h

diff --git a/Config.make.in b/Config.make.in
index d289a16..2b2a041 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -63,6 +63,7 @@ NO_SYNC_MAPPING_RANGE  = @NO_SYNC_MAPPING_RANGE@
 NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
 NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
 KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
+REGISTER_SYSCTL_TWO_ARGS = @REGISTER_SYSCTL_TWO_ARGS@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/Makefile b/Makefile
index cbb99be..685f1d1 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/slab.h \
 	kapi-compat/include/fstype.h \
 	kapi-compat/include/sysctl.h \
-	kapi-compat/include/configfs.h
+	kapi-compat/include/configfs.h \
+	kapi-compat/include/register_sysctl.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index eb8fe18..590f338 100644
--- a/configure.in
+++ b/configure.in
@@ -225,6 +225,12 @@ OCFS2_CHECK_KERNEL([configfs_depend_item() in configfs.h], configfs.h,
   , configfs_compat_header="configfs.h", [configfs_depend_item()])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $configfs_compat_header"
 
+REGISTER_SYSCTL_TWO_ARGS=
+OCFS2_CHECK_KERNEL([register_sysctl() with two args in sysctl.h], sysctl.h,
+  REGISTER_SYSCTL_TWO_ARGS=yes, , [^.*int insert_at_head);])
+AC_SUBST(REGISTER_SYSCTL_TWO_ARGS)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS register_sysctl.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index c40eae0..68b434b 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -17,6 +17,10 @@ ifdef NO_DELAYED_WORK
 EXTRA_CFLAGS += -DNO_DELAYED_WORK
 endif
 
+ifdef REGISTER_SYSCTL_TWO_ARGS
+EXTRA_CFLAGS += -DREGISTER_SYSCTL_TWO_ARGS
+endif
+
 SOURCES =			\
 	heartbeat.c		\
 	masklog.c		\
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index af2070d..9fff881 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -962,7 +962,7 @@ static int __init init_o2nm(void)
 	o2hb_init();
 	o2net_init();
 
-	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
+	ocfs2_table_header = kapi_register_sysctl_table(ocfs2_root_table);
 	if (!ocfs2_table_header) {
 		printk(KERN_ERR "nodemanager: unable to register sysctl\n");
 		ret = -ENOMEM; /* or something. */
diff --git a/kapi-compat/include/register_sysctl.h b/kapi-compat/include/register_sysctl.h
new file mode 100644
index 0000000..94e8071
--- /dev/null
+++ b/kapi-compat/include/register_sysctl.h
@@ -0,0 +1,10 @@
+#ifndef KAPI_REGISTER_SYSCTL_H
+#define KAPI_REGISTER_SYSCTL_H
+
+#ifdef REGISTER_SYSCTL_TWO_ARGS
+#define kapi_register_sysctl_table(a)	register_sysctl_table(a, 0)
+#else
+#define kapi_register_sysctl_table(a)	register_sysctl_table(a)
+#endif
+
+#endif
-- 
1.5.3.4
