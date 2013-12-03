From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 3 Dec 2013 15:59:42 -0600
Subject: [Ocfs2-devel] [PATCH] Remove versioning information v2
Message-ID: <20131203215937.GA12329@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The versioning information is confusing for end-users. The numbers
are stuck at 1.5.0 when the tools version have moved to 1.8.2. Remove
the versioning system in the OCFS2 modules and let the kernel
version be the guide to debug issues.

Changes since v1:
  * Added MODULE_DESCRIPTION

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
---
 fs/ocfs2/Makefile              |  1 -
 fs/ocfs2/cluster/Makefile      |  2 +-
 fs/ocfs2/cluster/nodemanager.c |  4 +---
 fs/ocfs2/cluster/ver.c         | 42 -----------------------------------------
 fs/ocfs2/cluster/ver.h         | 31 ------------------------------
 fs/ocfs2/dlm/Makefile          |  2 +-
 fs/ocfs2/dlm/dlmdomain.c       |  5 +----
 fs/ocfs2/dlm/dlmver.c          | 42 -----------------------------------------
 fs/ocfs2/dlm/dlmver.h          | 31 ------------------------------
 fs/ocfs2/dlmfs/Makefile        |  2 +-
 fs/ocfs2/dlmfs/dlmfs.c         |  4 +---
 fs/ocfs2/dlmfs/dlmfsver.c      | 42 -----------------------------------------
 fs/ocfs2/dlmfs/dlmfsver.h      | 31 ------------------------------
 fs/ocfs2/super.c               |  4 +---
 fs/ocfs2/ver.c                 | 43 ------------------------------------------
 fs/ocfs2/ver.h                 | 31 ------------------------------
 16 files changed, 7 insertions(+), 310 deletions(-)
 delete mode 100644 fs/ocfs2/cluster/ver.c
 delete mode 100644 fs/ocfs2/cluster/ver.h
 delete mode 100644 fs/ocfs2/dlm/dlmver.c
 delete mode 100644 fs/ocfs2/dlm/dlmver.h
 delete mode 100644 fs/ocfs2/dlmfs/dlmfsver.c
 delete mode 100644 fs/ocfs2/dlmfs/dlmfsver.h
 delete mode 100644 fs/ocfs2/ver.c
 delete mode 100644 fs/ocfs2/ver.h

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index f17e58b..ce210d4 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -38,7 +38,6 @@ ocfs2-objs := \
 	symlink.o 		\
 	sysfile.o 		\
 	uptodate.o		\
-	ver.o			\
 	quota_local.o		\
 	quota_global.o		\
 	xattr.o			\
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index bc8c5e7..1aefc03 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_OCFS2_FS) += ocfs2_nodemanager.o
 
 ocfs2_nodemanager-objs := heartbeat.o masklog.o sys.o nodemanager.o \
-	quorum.o tcp.o netdebug.o ver.o
+	quorum.o tcp.o netdebug.o
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index bb24064..441c84e 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -29,7 +29,6 @@
 #include "heartbeat.h"
 #include "masklog.h"
 #include "sys.h"
-#include "ver.h"
 
 /* for now we operate under the assertion that there can be only one
  * cluster active at a time.  Changing this will require trickling
@@ -945,8 +944,6 @@ static int __init init_o2nm(void)
 {
 	int ret = -1;
 
-	cluster_print_version();
-
 	ret = o2hb_init();
 	if (ret)
 		goto out;
@@ -984,6 +981,7 @@ out:
 
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("OCFS2 cluster management");
 
 module_init(init_o2nm)
 module_exit(exit_o2nm)
diff --git a/fs/ocfs2/cluster/ver.c b/fs/ocfs2/cluster/ver.c
deleted file mode 100644
index a56eee6..0000000
--- a/fs/ocfs2/cluster/ver.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * ver.c
- *
- * version string
- *
- * Copyright (C) 2002, 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-
-#include "ver.h"
-
-#define CLUSTER_BUILD_VERSION "1.5.0"
-
-#define VERSION_STR "OCFS2 Node Manager " CLUSTER_BUILD_VERSION
-
-void cluster_print_version(void)
-{
-	printk(KERN_INFO "%s\n", VERSION_STR);
-}
-
-MODULE_DESCRIPTION(VERSION_STR);
-
-MODULE_VERSION(CLUSTER_BUILD_VERSION);
diff --git a/fs/ocfs2/cluster/ver.h b/fs/ocfs2/cluster/ver.h
deleted file mode 100644
index 32554c3..0000000
--- a/fs/ocfs2/cluster/ver.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * ver.h
- *
- * Function prototypes
- *
- * Copyright (C) 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef O2CLUSTER_VER_H
-#define O2CLUSTER_VER_H
-
-void cluster_print_version(void);
-
-#endif /* O2CLUSTER_VER_H */
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index c8a044e..bd1aab1f 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -3,5 +3,5 @@ ccflags-y := -Ifs/ocfs2
 obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_dlm.o
 
 ocfs2_dlm-objs := dlmdomain.o dlmdebug.o dlmthread.o dlmrecovery.o \
-	dlmmaster.o dlmast.o dlmconvert.o dlmlock.o dlmunlock.o dlmver.o
+	dlmmaster.o dlmast.o dlmconvert.o dlmlock.o dlmunlock.o
 
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 8b3382a..33660a4 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -43,8 +43,6 @@
 #include "dlmdomain.h"
 #include "dlmdebug.h"
 
-#include "dlmver.h"
-
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_DOMAIN)
 #include "cluster/masklog.h"
 
@@ -2328,8 +2326,6 @@ static int __init dlm_init(void)
 {
 	int status;
 
-	dlm_print_version();
-
 	status = dlm_init_mle_cache();
 	if (status) {
 		mlog(ML_ERROR, "Could not create o2dlm_mle slabcache\n");
@@ -2379,6 +2375,7 @@ static void __exit dlm_exit (void)
 
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("OCFS2 Distributed Lock Management");
 
 module_init(dlm_init);
 module_exit(dlm_exit);
diff --git a/fs/ocfs2/dlm/dlmver.c b/fs/ocfs2/dlm/dlmver.c
deleted file mode 100644
index dfc0da4..0000000
--- a/fs/ocfs2/dlm/dlmver.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * dlmver.c
- *
- * version string
- *
- * Copyright (C) 2002, 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-
-#include "dlmver.h"
-
-#define DLM_BUILD_VERSION "1.5.0"
-
-#define VERSION_STR "OCFS2 DLM " DLM_BUILD_VERSION
-
-void dlm_print_version(void)
-{
-	printk(KERN_INFO "%s\n", VERSION_STR);
-}
-
-MODULE_DESCRIPTION(VERSION_STR);
-
-MODULE_VERSION(DLM_BUILD_VERSION);
diff --git a/fs/ocfs2/dlm/dlmver.h b/fs/ocfs2/dlm/dlmver.h
deleted file mode 100644
index f674aee..0000000
--- a/fs/ocfs2/dlm/dlmver.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * dlmfsver.h
- *
- * Function prototypes
- *
- * Copyright (C) 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef DLM_VER_H
-#define DLM_VER_H
-
-void dlm_print_version(void);
-
-#endif /* DLM_VER_H */
diff --git a/fs/ocfs2/dlmfs/Makefile b/fs/ocfs2/dlmfs/Makefile
index f14be89..eed3db8 100644
--- a/fs/ocfs2/dlmfs/Makefile
+++ b/fs/ocfs2/dlmfs/Makefile
@@ -2,4 +2,4 @@ ccflags-y := -Ifs/ocfs2
 
 obj-$(CONFIG_OCFS2_FS) += ocfs2_dlmfs.o
 
-ocfs2_dlmfs-objs := userdlm.o dlmfs.o dlmfsver.o
+ocfs2_dlmfs-objs := userdlm.o dlmfs.o
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index efa2b3d..09b7d9d 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -49,7 +49,6 @@
 
 #include "stackglue.h"
 #include "userdlm.h"
-#include "dlmfsver.h"
 
 #define MLOG_MASK_PREFIX ML_DLMFS
 #include "cluster/masklog.h"
@@ -644,8 +643,6 @@ static int __init init_dlmfs_fs(void)
 	int status;
 	int cleanup_inode = 0, cleanup_worker = 0;
 
-	dlmfs_print_version();
-
 	status = bdi_init(&dlmfs_backing_dev_info);
 	if (status)
 		return status;
@@ -701,6 +698,7 @@ static void __exit exit_dlmfs_fs(void)
 
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("OCFS2 DLM-Filesystem");
 
 module_init(init_dlmfs_fs)
 module_exit(exit_dlmfs_fs)
diff --git a/fs/ocfs2/dlmfs/dlmfsver.c b/fs/ocfs2/dlmfs/dlmfsver.c
deleted file mode 100644
index a733b33..0000000
--- a/fs/ocfs2/dlmfs/dlmfsver.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * dlmfsver.c
- *
- * version string
- *
- * Copyright (C) 2002, 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-
-#include "dlmfsver.h"
-
-#define DLM_BUILD_VERSION "1.5.0"
-
-#define VERSION_STR "OCFS2 DLMFS " DLM_BUILD_VERSION
-
-void dlmfs_print_version(void)
-{
-	printk(KERN_INFO "%s\n", VERSION_STR);
-}
-
-MODULE_DESCRIPTION(VERSION_STR);
-
-MODULE_VERSION(DLM_BUILD_VERSION);
diff --git a/fs/ocfs2/dlmfs/dlmfsver.h b/fs/ocfs2/dlmfs/dlmfsver.h
deleted file mode 100644
index f35eadb..0000000
--- a/fs/ocfs2/dlmfs/dlmfsver.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * dlmver.h
- *
- * Function prototypes
- *
- * Copyright (C) 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef DLMFS_VER_H
-#define DLMFS_VER_H
-
-void dlmfs_print_version(void);
-
-#endif /* DLMFS_VER_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c414929..fcd595e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -68,7 +68,6 @@
 #include "super.h"
 #include "sysfile.h"
 #include "uptodate.h"
-#include "ver.h"
 #include "xattr.h"
 #include "quota.h"
 #include "refcounttree.h"
@@ -90,6 +89,7 @@ static struct dentry *ocfs2_debugfs_root = NULL;
 
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("OCFS2 cluster file system");
 
 struct mount_options
 {
@@ -1618,8 +1618,6 @@ static int __init ocfs2_init(void)
 {
 	int status, i;
 
-	ocfs2_print_version();
-
 	for (i = 0; i < OCFS2_IOEND_WQ_HASH_SZ; i++)
 		init_waitqueue_head(&ocfs2__ioend_wq[i]);
 
diff --git a/fs/ocfs2/ver.c b/fs/ocfs2/ver.c
deleted file mode 100644
index e2488f4..0000000
--- a/fs/ocfs2/ver.c
+++ /dev/null
@@ -1,43 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * ver.c
- *
- * version string
- *
- * Copyright (C) 2002, 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-
-#include "ver.h"
-
-#define OCFS2_BUILD_VERSION "1.5.0"
-
-#define VERSION_STR "OCFS2 " OCFS2_BUILD_VERSION
-
-void ocfs2_print_version(void)
-{
-	printk(KERN_INFO "%s\n", VERSION_STR);
-}
-
-MODULE_DESCRIPTION(VERSION_STR);
-
-MODULE_VERSION(OCFS2_BUILD_VERSION);
diff --git a/fs/ocfs2/ver.h b/fs/ocfs2/ver.h
deleted file mode 100644
index d7395cb..0000000
--- a/fs/ocfs2/ver.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * ver.h
- *
- * Function prototypes
- *
- * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef OCFS2_VER_H
-#define OCFS2_VER_H
-
-void ocfs2_print_version(void);
-
-#endif /* OCFS2_VER_H */
-- 
1.8.4


-- 
Goldwyn
