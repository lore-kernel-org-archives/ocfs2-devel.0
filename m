From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 21 Jan 2011 18:20:21 +0800
Subject: [Ocfs2-devel] [PATCH 04/14] Ocfs2/move_extents: Add basic framework
	and source files for extent moving.
In-Reply-To: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1295605231-15991-5-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Adding new files move_extents.[c|h] and fill it with nothing but
only a context structure.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/Makefile          |    1 +
 fs/ocfs2/cluster/masklog.h |    1 +
 fs/ocfs2/move_extents.c    |   57 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/move_extents.h    |   20 +++++++++++++++
 4 files changed, 79 insertions(+), 0 deletions(-)
 create mode 100644 fs/ocfs2/move_extents.c
 create mode 100644 fs/ocfs2/move_extents.h

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 07d9fd8..5166f2d 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -30,6 +30,7 @@ ocfs2-objs := \
 	namei.o 		\
 	refcounttree.o		\
 	reservations.o		\
+	move_extents.o		\
 	resize.o		\
 	slot_map.o 		\
 	suballoc.o 		\
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index ea2ed9f..36f1cb2 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -121,6 +121,7 @@
 #define ML_KTHREAD	0x0000000400000000ULL /* kernel thread activity */
 #define ML_RESERVATIONS	0x0000000800000000ULL /* ocfs2 alloc reservations */
 #define ML_CLUSTER	0x0000001000000000ULL /* cluster stack */
+#define ML_MOVE_EXT	0x0000002000000000ULL /* move extents */
 
 #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
 #define MLOG_INITIAL_NOT_MASK (ML_ENTRY|ML_EXIT)
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
new file mode 100644
index 0000000..b79c2d3
--- /dev/null
+++ b/fs/ocfs2/move_extents.c
@@ -0,0 +1,57 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * move_extents.c
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/mount.h>
+#include <linux/swap.h>
+
+#define MLOG_MASK_PREFIX ML_MOVE_EXT
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+#include "ocfs2_ioctl.h"
+
+#include "alloc.h"
+#include "aops.h"
+#include "dlmglue.h"
+#include "extent_map.h"
+#include "inode.h"
+#include "journal.h"
+#include "suballoc.h"
+#include "uptodate.h"
+#include "super.h"
+#include "dir.h"
+#include "buffer_head_io.h"
+#include "sysfile.h"
+#include "suballoc.h"
+#include "refcounttree.h"
+#include "move_extents.h"
+
+struct ocfs2_move_extents_context {
+	struct inode *inode;
+	struct file *file;
+	int auto_defrag;
+	int credits;
+	u32 new_phys_cpos;
+	u32 clusters_moved;
+	u64 refcount_loc;
+	struct ocfs2_move_extents *range;
+	struct ocfs2_extent_tree et;
+	struct ocfs2_alloc_context *meta_ac;
+	struct ocfs2_alloc_context *data_ac;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+};
diff --git a/fs/ocfs2/move_extents.h b/fs/ocfs2/move_extents.h
new file mode 100644
index 0000000..eba4044
--- /dev/null
+++ b/fs/ocfs2/move_extents.h
@@ -0,0 +1,20 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * move_extents.h
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef OCFS2_MOVE_EXTENTS_H
+#define OCFS2_MOVE_EXTENTS_H
+
+#endif /* OCFS2_MOVE_EXTENTS_H */
-- 
1.5.5
