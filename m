From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue,  2 Mar 2010 13:59:42 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions from
	ocfs2_fs.h to newly added ocfs2_ioctl.h
Message-ID: <1267509583-6160-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently we were adding ioctl cmds/structures for ocfs2 into ocfs2_fs.h
which was used for define ocfs2 on-disk layout. That sounds a little bit
confusing, and it may be quickly polluted espcially when growing the
ocfs2_info_request ioctls afterwards(it will grow i bet).

As a result, such OCFS2 IOCs do need to be placed somewhere other than
ocfs2_fs.h, a separated ocfs2_ioctl.h will be added to store such ioctl
structures and definitions which could also be used from userspace to
invoke ioctls call.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.h       |    6 ++--
 fs/ocfs2/ocfs2.h       |    1 +
 fs/ocfs2/ocfs2_fs.h    |   57 ----------------------------------
 fs/ocfs2/ocfs2_ioctl.h |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 60 deletions(-)
 create mode 100644 fs/ocfs2/ocfs2_ioctl.h

diff --git a/fs/ocfs2/ioctl.h b/fs/ocfs2/ioctl.h
index cf9a5ee..0cd5323 100644
--- a/fs/ocfs2/ioctl.h
+++ b/fs/ocfs2/ioctl.h
@@ -7,10 +7,10 @@
  *
  */
 
-#ifndef OCFS2_IOCTL_H
-#define OCFS2_IOCTL_H
+#ifndef OCFS2_IOCTL_PROTO_H
+#define OCFS2_IOCTL_PROTO_H
 
 long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
-#endif /* OCFS2_IOCTL_H */
+#endif /* OCFS2_IOCTL_PROTO_H */
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 740f448..eb8e14e 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -42,6 +42,7 @@
 
 #include "ocfs2_fs.h"
 #include "ocfs2_lockid.h"
+#include "ocfs2_ioctl.h"
 
 /* For struct ocfs2_blockcheck_stats */
 #include "blockcheck.h"
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 7638a38..bb37218 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -254,63 +254,6 @@
 						 * refcount tree */
 
 /*
- * ioctl commands
- */
-#define OCFS2_IOC_GETFLAGS	_IOR('f', 1, long)
-#define OCFS2_IOC_SETFLAGS	_IOW('f', 2, long)
-#define OCFS2_IOC32_GETFLAGS	_IOR('f', 1, int)
-#define OCFS2_IOC32_SETFLAGS	_IOW('f', 2, int)
-
-/*
- * Space reservation / allocation / free ioctls and argument structure
- * are designed to be compatible with XFS.
- *
- * ALLOCSP* and FREESP* are not and will never be supported, but are
- * included here for completeness.
- */
-struct ocfs2_space_resv {
-	__s16		l_type;
-	__s16		l_whence;
-	__s64		l_start;
-	__s64		l_len;		/* len == 0 means until end of file */
-	__s32		l_sysid;
-	__u32		l_pid;
-	__s32		l_pad[4];	/* reserve area			    */
-};
-
-#define OCFS2_IOC_ALLOCSP		_IOW ('X', 10, struct ocfs2_space_resv)
-#define OCFS2_IOC_FREESP		_IOW ('X', 11, struct ocfs2_space_resv)
-#define OCFS2_IOC_RESVSP		_IOW ('X', 40, struct ocfs2_space_resv)
-#define OCFS2_IOC_UNRESVSP	_IOW ('X', 41, struct ocfs2_space_resv)
-#define OCFS2_IOC_ALLOCSP64	_IOW ('X', 36, struct ocfs2_space_resv)
-#define OCFS2_IOC_FREESP64	_IOW ('X', 37, struct ocfs2_space_resv)
-#define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
-#define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
-
-/* Used to pass group descriptor data when online resize is done */
-struct ocfs2_new_group_input {
-	__u64 group;		/* Group descriptor's blkno. */
-	__u32 clusters;		/* Total number of clusters in this group */
-	__u32 frees;		/* Total free clusters in this group */
-	__u16 chain;		/* Chain for this group */
-	__u16 reserved1;
-	__u32 reserved2;
-};
-
-#define OCFS2_IOC_GROUP_EXTEND	_IOW('o', 1, int)
-#define OCFS2_IOC_GROUP_ADD	_IOW('o', 2,struct ocfs2_new_group_input)
-#define OCFS2_IOC_GROUP_ADD64	_IOW('o', 3,struct ocfs2_new_group_input)
-
-/* Used to pass 2 file names to reflink. */
-struct reflink_arguments {
-	__u64 old_path;
-	__u64 new_path;
-	__u64 preserve;
-};
-#define OCFS2_IOC_REFLINK	_IOW('o', 4, struct reflink_arguments)
-
-
-/*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
  */
 #define OCFS2_JOURNAL_DIRTY_FL	(0x00000001)	/* Journal needs recovery */
diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
new file mode 100644
index 0000000..2d3420a
--- /dev/null
+++ b/fs/ocfs2/ocfs2_ioctl.h
@@ -0,0 +1,79 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * ocfs2_ioctl.h
+ *
+ * Defines OCFS2 ioctls.
+ *
+ * Copyright (C) 2010 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License, version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef OCFS2_IOCTL_H
+#define OCFS2_IOCTL_H
+
+/*
+ * ioctl commands
+ */
+#define OCFS2_IOC_GETFLAGS	_IOR('f', 1, long)
+#define OCFS2_IOC_SETFLAGS	_IOW('f', 2, long)
+#define OCFS2_IOC32_GETFLAGS	_IOR('f', 1, int)
+#define OCFS2_IOC32_SETFLAGS	_IOW('f', 2, int)
+
+/*
+ * Space reservation / allocation / free ioctls and argument structure
+ * are designed to be compatible with XFS.
+ *
+ * ALLOCSP* and FREESP* are not and will never be supported, but are
+ * included here for completeness.
+ */
+struct ocfs2_space_resv {
+	__s16		l_type;
+	__s16		l_whence;
+	__s64		l_start;
+	__s64		l_len;		/* len == 0 means until end of file */
+	__s32		l_sysid;
+	__u32		l_pid;
+	__s32		l_pad[4];	/* reserve area			    */
+};
+
+#define OCFS2_IOC_ALLOCSP		_IOW ('X', 10, struct ocfs2_space_resv)
+#define OCFS2_IOC_FREESP		_IOW ('X', 11, struct ocfs2_space_resv)
+#define OCFS2_IOC_RESVSP		_IOW ('X', 40, struct ocfs2_space_resv)
+#define OCFS2_IOC_UNRESVSP	_IOW ('X', 41, struct ocfs2_space_resv)
+#define OCFS2_IOC_ALLOCSP64	_IOW ('X', 36, struct ocfs2_space_resv)
+#define OCFS2_IOC_FREESP64	_IOW ('X', 37, struct ocfs2_space_resv)
+#define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
+#define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
+
+/* Used to pass group descriptor data when online resize is done */
+struct ocfs2_new_group_input {
+	__u64 group;		/* Group descriptor's blkno. */
+	__u32 clusters;		/* Total number of clusters in this group */
+	__u32 frees;		/* Total free clusters in this group */
+	__u16 chain;		/* Chain for this group */
+	__u16 reserved1;
+	__u32 reserved2;
+};
+
+#define OCFS2_IOC_GROUP_EXTEND	_IOW('o', 1, int)
+#define OCFS2_IOC_GROUP_ADD	_IOW('o', 2,struct ocfs2_new_group_input)
+#define OCFS2_IOC_GROUP_ADD64	_IOW('o', 3,struct ocfs2_new_group_input)
+
+/* Used to pass 2 file names to reflink. */
+struct reflink_arguments {
+	__u64 old_path;
+	__u64 new_path;
+	__u64 preserve;
+};
+#define OCFS2_IOC_REFLINK	_IOW('o', 4, struct reflink_arguments)
+
+#endif /* OCFS2_IOCTL_H */
-- 
1.5.5
