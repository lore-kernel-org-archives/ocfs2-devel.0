From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan  9 18:00:12 2008
Subject: [Ocfs2-devel] [PATCH 17/30] ocfs2: Handle su_mutex in struct
	configfs_subsystem
In-Reply-To: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
References: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199930370-17076-16-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit e6bd07aee739566803425acdbf5cdb29919164e1 in mainline changed a
semaphore into a mutex in struct configfs_subsystem. This patch allows
building ocfs2 with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Config.make.in                 |    1 +
 Makefile                       |    3 ++-
 configure.in                   |    6 ++++++
 fs/ocfs2/cluster/Makefile      |    4 ++++
 fs/ocfs2/cluster/nodemanager.c |    2 +-
 kapi-compat/include/su_mutex.h |   13 +++++++++++++
 6 files changed, 27 insertions(+), 2 deletions(-)
 create mode 100644 kapi-compat/include/su_mutex.h

diff --git a/Config.make.in b/Config.make.in
index 9e2b466..3dd84e2 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -64,6 +64,7 @@ NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
 NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
 KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
 REGISTER_SYSCTL_TWO_ARGS = @REGISTER_SYSCTL_TWO_ARGS@
+NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM = @NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/Makefile b/Makefile
index 4256eb7..1ecedd2 100644
--- a/Makefile
+++ b/Makefile
@@ -21,7 +21,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/fs_rename_does_d_move.h \
 	kapi-compat/include/sysctl.h \
 	kapi-compat/include/configfs.h \
-	kapi-compat/include/register_sysctl.h
+	kapi-compat/include/register_sysctl.h \
+	kapi-compat/include/su_mutex.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 795437c..f04af3d 100644
--- a/configure.in
+++ b/configure.in
@@ -242,6 +242,12 @@ OCFS2_CHECK_KERNEL([register_sysctl() with two args in sysctl.h], sysctl.h,
 AC_SUBST(REGISTER_SYSCTL_TWO_ARGS)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS register_sysctl.h"
 
+NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM=
+OCFS2_CHECK_KERNEL([su_mutex in struct configfs_subsystem in configfs.h], configfs.h,
+  , NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM=yes, [su_mutex])
+AC_SUBST(NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS su_mutex.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index 28fe533..4c3f6e5 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -26,6 +26,10 @@ ifdef REGISTER_SYSCTL_TWO_ARGS
 EXTRA_CFLAGS += -DREGISTER_SYSCTL_TWO_ARGS
 endif
 
+ifdef NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM
+EXTRA_CFLAGS += -DNO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM
+endif
+
 SOURCES +=			\
 	heartbeat.c		\
 	masklog.c		\
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 9fff881..cb06ef4 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -974,7 +974,7 @@ static int __init init_o2nm(void)
 		goto out_sysctl;
 
 	config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
-	mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
+	init_su_mutex(&o2nm_cluster_group.cs_subsys.su_mutex);
 	ret = configfs_register_subsystem(&o2nm_cluster_group.cs_subsys);
 	if (ret) {
 		printk(KERN_ERR "nodemanager: Registration returned %d\n", ret);
diff --git a/kapi-compat/include/su_mutex.h b/kapi-compat/include/su_mutex.h
new file mode 100644
index 0000000..12ebc2d
--- /dev/null
+++ b/kapi-compat/include/su_mutex.h
@@ -0,0 +1,13 @@
+#ifndef KAPI_SUMUTEX_H
+#define KAPI_SUMUTEX_H
+
+#ifdef NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM
+# include "asm/semaphore.h"
+# define init_su_mutex		init_MUTEX
+# define su_mutex		su_sem
+#else
+# define init_su_mutex		mutex_init
+# define su_mutex		su_mutex
+#endif
+
+#endif
-- 
1.5.2.5
