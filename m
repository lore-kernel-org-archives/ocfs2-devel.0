From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 5 Jun 2008 15:33:42 +0800
Subject: [Ocfs2-devel] [PATCH 5/8] Add xattr header in ocfs2.v1
In-Reply-To: <484792D1.3080802@oracle.com>
Message-ID: <20080605073342.GA19789@tma-pc2.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.h |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100644 fs/ocfs2/xattr.h

diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
new file mode 100644
index 0000000..a5b93cf
--- /dev/null
+++ b/fs/ocfs2/xattr.h
@@ -0,0 +1,95 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * xattr.h
+ *
+ * Function prototypes
+ *
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef OCFS2_XATTR_H
+#define OCFS2_XATTR_H
+
+#include <linux/init.h>
+#include <linux/xattr.h>
+
+/* Magic value in attribute blocks */
+#define OCFS2_XATTR_BLOCK_SIGNATURE_1	"XATTR01"
+#define OCFS2_XATTR_BLOCK_SIGNATURE_2	"XATTR02"
+
+enum ocfs2_xattr_type {
+	OCFS2_XATTR_INDEX_USER = 1,
+	OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS,
+	OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT,
+	OCFS2_XATTR_INDEX_TRUSTED,
+	OCFS2_XATTR_INDEX_LUSTRE,
+	OCFS2_XATTR_INDEX_SECURITY,
+	OCFS2_XATTR_MAX
+};
+
+struct ocfs2_xattr_entry {
+	__le32	xe_name_hash;
+	__le16	xe_name_offset;
+	__u8	xe_name_len;
+	__u8	xe_type : 7;
+	__u8	xe_local : 1;
+	__le64	xe_value_size;
+};
+
+struct ocfs2_xattr_header {
+	__le16	xh_count;
+	__le16	xh_reserved1;
+	__le32	xh_csum;
+	__le16  xh_reserved2[4];
+	struct ocfs2_xattr_entry	xh_entries[0];
+};
+
+struct ocfs2_xattr_value_root {
+/*00*/	__le32	xr_clusters;
+	__le32	xr_reserved0;
+	__le64	xr_last_eb_blk;
+/*10*/	struct ocfs2_extent_list	xr_list;
+};
+
+struct ocfs2_xattr_tree_root {
+/*00*/	__le32	xt_clusters;
+	__le32	xt_reserved0;
+	__le64	xt_last_eb_blk;
+/*10*/	struct ocfs2_extent_list	xt_list;
+};
+
+#define OCFS2_XATTR_INDEXED 0x1
+
+struct ocfs2_xattr_block {
+/*00*/	__u8	xb_signature[8];
+	__le16	xb_suballoc_slot;
+	__le16	xb_suballoc_bit;
+	__le32	xb_fs_generation;
+/*10*/	__le32	xb_csum;
+	__le16	xb_flags;
+	__le16	xb_reserved0;
+	__le64	xb_blkno;
+/*20*/	__le64	xb_reserved1[2];
+/*30*/	union {
+		struct ocfs2_xattr_header	xb_header;
+		struct ocfs2_xattr_tree_root	xb_root;
+	} xb_attrs;
+};
+
+#endif /* OCFS2_XATTR_H */
-- 
1.5.4.GIT
