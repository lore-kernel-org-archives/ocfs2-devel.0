From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:29 -0800
Subject: [Ocfs2-devel] [PATCH 08/18] ocfs2: Handle missing mutex in struct
	configfs_subsystem
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e6bd07aee739566803425acdbf5cdb29919164e1 changed a semaphore (su_sem)
into a mutex (su_mutex) in struct configfs_subsystem. Patch adds macros to allow
building with EL5.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                        |    3 ++-
 configure.in                    |    5 +++++
 fs/ocfs2/cluster/kapi-default.h |    5 +++++
 fs/ocfs2/cluster/nodemanager.c  |    2 +-
 kapi-compat/include/su_mutex.h  |    9 +++++++++
 5 files changed, 22 insertions(+), 2 deletions(-)
 create mode 100644 kapi-compat/include/su_mutex.h

diff --git a/Makefile b/Makefile
index 00535ff..623bda4 100644
--- a/Makefile
+++ b/Makefile
@@ -27,7 +27,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/slab.h			\
 	kapi-compat/include/blkdev_put.h		\
 	kapi-compat/include/blkdev_get.h		\
-	kapi-compat/include/configfs.h
+	kapi-compat/include/configfs.h			\
+	kapi-compat/include/su_mutex.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index aad0ea1..af32060 100644
--- a/configure.in
+++ b/configure.in
@@ -354,6 +354,11 @@ OCFS2_CHECK_KERNEL([configfs_depend_item() in configfs.h], configfs.h,
   , configfs_compat_header=configfs.h, [^int configfs_depend_item(])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $configfs_compat_header"
 
+su_mutex_header=
+OCFS2_CHECK_KERNEL([su_mutex in struct configfs_subsystem in configfs.h], configfs.h,
+  , su_mutex_header=su_mutex.h, [struct mutex            su_mutex;])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $su_mutex_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/cluster/kapi-default.h b/fs/ocfs2/cluster/kapi-default.h
index fc3da05..81dce2f 100644
--- a/fs/ocfs2/cluster/kapi-default.h
+++ b/fs/ocfs2/cluster/kapi-default.h
@@ -37,4 +37,9 @@ typedef struct work_struct kapi_work_struct_t;
 # define kapi_blkdev_get		blkdev_get
 #endif
 
+#ifndef kapi_mutex_init
+# define kapi_mutex_init		mutex_init
+# define su_mutex			su_mutex
+#endif
+
 #endif
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 7ee6188..31140df 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -903,7 +903,7 @@ static int __init init_o2nm(void)
 		goto out_o2net;
 
 	config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
-	mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
+	kapi_mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
 	ret = configfs_register_subsystem(&o2nm_cluster_group.cs_subsys);
 	if (ret) {
 		printk(KERN_ERR "nodemanager: Registration returned %d\n", ret);
diff --git a/kapi-compat/include/su_mutex.h b/kapi-compat/include/su_mutex.h
new file mode 100644
index 0000000..6713348
--- /dev/null
+++ b/kapi-compat/include/su_mutex.h
@@ -0,0 +1,9 @@
+#ifndef KAPI_SUMUTEX_H
+#define KAPI_SUMUTEX_H
+
+#include "asm/semaphore.h"
+
+#define kapi_mutex_init		init_MUTEX
+#define su_mutex		su_sem
+
+#endif
-- 
1.5.6.5
