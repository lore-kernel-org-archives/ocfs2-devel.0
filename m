From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri,  5 Feb 2010 17:59:19 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions from
	ocfs2_fs.h to new added ocfs2_ioctl.h.
Message-ID: <1265363960-13329-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently we were adding ioctl cmds/structures for ocfs2 into ocfs2_fs.h
which was used for define ocfs2 on-disk layout. That sounds a little bit
confusing, and it may be quickly polluted espcially when growing the
ocfs2_info_request ioctls afterwards(it will grow i bet).

As a result, such OCFS2 IOCs do need to be placed somewhere other than ocfs2_fs.h,
a separated ocfs2_ioctl.h will be added to store such ioctl structures and definitions
which could also be used from userspace to invoke the ioctls.

What's more, the patch also introduces new structures and definitions for the new
OCFS2_IOC_INFO.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.h        |    2 +
 fs/ocfs2/ioctl.h       |    6 +-
 fs/ocfs2/ocfs2_fs.h    |   57 --------------
 fs/ocfs2/ocfs2_ioctl.h |  195 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/resize.c      |    1 +
 5 files changed, 201 insertions(+), 60 deletions(-)
 create mode 100644 fs/ocfs2/ocfs2_ioctl.h

diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index d66cf4f..eb891db 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -26,6 +26,8 @@
 #ifndef OCFS2_FILE_H
 #define OCFS2_FILE_H
 
+#include "ocfs2_ioctl.h"
+
 extern const struct file_operations ocfs2_fops;
 extern const struct file_operations ocfs2_dops;
 extern const struct file_operations ocfs2_fops_no_plocks;
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
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index e9431e4..54e1de0 100644
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
index 0000000..e15c84d
--- /dev/null
+++ b/fs/ocfs2/ocfs2_ioctl.h
@@ -0,0 +1,195 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * ocfs2_ioctl.h
+ *
+ * Defines OCFS2 ioctls.
+ *
+ * Copyright (C) 2009 Oracle.  All rights reserved.
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
+
+/* Following definitions dedicated for ocfs2_info_request ioctls. */
+
+#define OCFS2_INFO_VOL_UUID_LEN		(16)
+#define OCFS2_INFO_MAX_VOL_LABEL_LEN	(64)
+#define OCFS2_INFO_VOL_UUIDSTR_LEN	(OCFS2_INFO_VOL_UUID_LEN * 2 + 1)
+#define OCFS2_INFO_MAX_SLOTS		(255)
+#define OCFS2_INFO_MAX_HIST		(32)
+
+#define OCFS2_INFO_MAX_REQUEST		(50)
+
+/* Magic number of all requests */
+#define OCFS2_INFO_MAGIC		(0x4F32494E)
+
+/*
+ * Always try to separate info request into small pieces to
+ * guarantee the backward&forward compatibility.
+ */
+
+struct ocfs2_info {
+	__u64 info_requests;	/* Array of __u64 pointers to requests */
+	__u32 info_count;	/* Number of requests in info_requests */
+};
+
+struct ocfs2_info_request {
+/*00*/	__u32 ir_magic;	/* Magic number */
+	__u32 ir_code;	/* Info request code */
+	__u32 ir_size;	/* Size of request */
+	__u32 ir_flags;	/* Request flags */
+/*10*/	/* Request specific fields */
+};
+
+struct ocfs2_info_clustersize {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_clustersize;
+};
+
+struct ocfs2_info_blocksize {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_blocksize;
+};
+
+struct ocfs2_info_slotnum {
+	struct ocfs2_info_request ir_request;
+	__u16 ir_slotnum;
+};
+
+struct ocfs2_info_label {
+	struct ocfs2_info_request ir_request;
+	__u8	ir_label[OCFS2_INFO_MAX_VOL_LABEL_LEN];
+};
+
+struct ocfs2_info_uuid {
+	struct ocfs2_info_request ir_request;
+	__u8	ir_uuid_str[OCFS2_INFO_VOL_UUIDSTR_LEN];
+};
+
+struct ocfs2_info_fs_features {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_compat_features;
+	__u32 ir_incompat_features;
+	__u32 ir_ro_compat_features;
+};
+
+struct ocfs2_info_freefrag {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_chunksize; /* chunksize in clusters(in) */
+	struct ocfs2_info_freefrag_stats { /* (out) */
+		__u32 ir_clusters;
+		__u32 ir_free_clusters;
+		__u32 ir_free_chunks;
+		__u32 ir_free_chunks_real;
+		__u32 ir_min; /* Minimum free chunksize in clusters */
+		__u32 ir_max;
+		__u32 ir_avg;
+		struct ocfs2_info_free_chunk_list {
+			__u32 ir_fc_chunks[OCFS2_INFO_MAX_HIST];
+			__u32 ir_fc_clusters[OCFS2_INFO_MAX_HIST];
+		} ir_fc_hist;
+	} ir_ffg;
+};
+
+struct ocfs2_info_freeinode {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_slotnum; /* out */
+	struct ocfs2_info_local_fi {
+		__u64 ir_total;
+		__u64 ir_free;
+	} ir_fi_stat[OCFS2_INFO_MAX_SLOTS];
+};
+
+/* Codes for ocfs2_info_request */
+
+#define OCFS2_INFO_CLUSTERSIZE	(0x00000001)
+#define OCFS2_INFO_BLOCKSIZE	(0x00000002)
+#define OCFS2_INFO_SLOTNUM	(0x00000004)
+#define OCFS2_INFO_LABEL	(0x00000008)
+#define OCFS2_INFO_UUID		(0x00000010)
+#define OCFS2_INFO_FS_FEATURES	(0x00000020)
+#define OCFS2_INFO_FREEFRAG	(0x00000040)
+#define OCFS2_INFO_FREEINODE	(0x00000080)
+
+/* Flags for struct ocfs2_info_request */
+/* Filled by the caller */
+#define OCFS2_INFO_FL_NON_COHERENT	(0x00000001)	/* Cluster coherency not
+							   required. This is a hint.
+							   It is up to ocfs2 whether
+							   the request can be fulfilled
+							   without locking. */
+/* Filled by ocfs2 */
+#define OCFS2_INFO_FL_FILLED		(0x80000000)	/* Filesystem understood
+							   this request and
+							   filled in the answer */
+
+#define OCFS2_IOC_INFO		_IOR('o', 5, struct ocfs2_info)
+
+#endif /* OCFS2_IOCTL_H */
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 3c3d673..9cf5da3 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -42,6 +42,7 @@
 
 #include "buffer_head_io.h"
 #include "suballoc.h"
+#include "ocfs2_ioctl.h"
 #include "resize.h"
 
 /*
-- 
1.5.5
