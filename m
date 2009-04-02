From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:43 +0800
Subject: [Ocfs2-devel] [PATCH 04/42] ocfs2: Add ocfs2_read_refcount_block.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-4-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/Makefile          |    1 +
 fs/ocfs2/cluster/masklog.c |    1 +
 fs/ocfs2/cluster/masklog.h |    1 +
 fs/ocfs2/ocfs2.h           |    3 +
 fs/ocfs2/refcounttree.c    |   99 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 105 insertions(+), 0 deletions(-)
 create mode 100644 fs/ocfs2/refcounttree.c

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 0159607..31f25ce 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -28,6 +28,7 @@ ocfs2-objs := \
 	locks.o			\
 	mmap.o 			\
 	namei.o 		\
+	refcounttree.o		\
 	resize.o		\
 	slot_map.o 		\
 	suballoc.o 		\
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 96df541..1cd2934 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -111,6 +111,7 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(EXPORT),
 	define_mask(XATTR),
 	define_mask(QUOTA),
+	define_mask(REFCOUNT),
 	define_mask(ERROR),
 	define_mask(NOTICE),
 	define_mask(KTHREAD),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 7e72a81..d233ec2 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -114,6 +114,7 @@
 #define ML_EXPORT	0x0000000010000000ULL /* ocfs2 export operations */
 #define ML_XATTR	0x0000000020000000ULL /* ocfs2 extended attributes */
 #define ML_QUOTA	0x0000000040000000ULL /* ocfs2 quota operations */
+#define ML_REFCOUNT	0x0000000080000000ULL /* refcount tree operations */
 /* bits that are infrequently given and frequently matched in the high word */
 #define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
 #define ML_NOTICE	0x0000000200000000ULL /* setn to KERN_NOTICE */
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 8374b6b..fb2d092 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -511,6 +511,9 @@ static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
 #define OCFS2_IS_VALID_DIR_TRAILER(ptr)					\
 	(!strcmp((ptr)->db_signature, OCFS2_DIR_TRAILER_SIGNATURE))
 
+#define OCFS2_IS_VALID_REFCOUNT_BLOCK(ptr)				\
+	(!strcmp((ptr)->rf_signature, OCFS2_REFCOUNT_BLOCK_SIGNATURE))
+
 static inline unsigned long ino_from_blkno(struct super_block *sb,
 					   u64 blkno)
 {
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
new file mode 100644
index 0000000..9790032
--- /dev/null
+++ b/fs/ocfs2/refcounttree.c
@@ -0,0 +1,99 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * refcounttree.c
+ *
+ * Copyright (C) 2004, 2009 Oracle.  All rights reserved.
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
+
+#define MLOG_MASK_PREFIX ML_REFCOUNT
+#include <cluster/masklog.h>
+#include "ocfs2.h"
+#include "inode.h"
+#include "alloc.h"
+#include "suballoc.h"
+#include "journal.h"
+#include "uptodate.h"
+#include "super.h"
+#include "buffer_head_io.h"
+#include "blockcheck.h"
+
+static int ocfs2_validate_refcount_block(struct super_block *sb,
+					 struct buffer_head *bh)
+{
+	int rc;
+	struct ocfs2_refcount_block *rb =
+		(struct ocfs2_refcount_block *)bh->b_data;
+
+	mlog(0, "Validating refcount block %llu\n",
+	     (unsigned long long)bh->b_blocknr);
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	/*
+	 * If the ecc fails, we return the error but otherwise
+	 * leave the filesystem running.  We know any error is
+	 * local to this block.
+	 */
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &rb->rf_check);
+	if (rc) {
+		mlog(ML_ERROR, "Checksum failed for extent block %llu\n",
+		     (unsigned long long)bh->b_blocknr);
+		return rc;
+	}
+
+
+	if (!OCFS2_IS_VALID_REFCOUNT_BLOCK(rb)) {
+		ocfs2_error(sb,
+			    "Refcount block #%llu has bad signature %.*s",
+			    (unsigned long long)bh->b_blocknr, 7,
+			    rb->rf_signature);
+		return -EINVAL;
+	}
+
+	if (le64_to_cpu(rb->rf_blkno) != bh->b_blocknr) {
+		ocfs2_error(sb,
+			    "Refcount block #%llu has an invalid rf_blkno "
+			    "of %llu",
+			    (unsigned long long)bh->b_blocknr,
+			    (unsigned long long)le64_to_cpu(rb->rf_blkno));
+		return -EINVAL;
+	}
+
+	if (le32_to_cpu(rb->rf_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+		ocfs2_error(sb,
+			    "Refcount block #%llu has an invalid "
+			    "rf_fs_generation of #%u",
+			    (unsigned long long)bh->b_blocknr,
+			    le32_to_cpu(rb->rf_fs_generation));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ocfs2_read_refcount_block(struct ocfs2_caching_info *ci,
+				     u64 rb_blkno,
+				     struct buffer_head **bh)
+{
+	int rc;
+	struct buffer_head *tmp = *bh;
+
+	rc = ocfs2_read_block(ci, rb_blkno, &tmp,
+			      ocfs2_validate_refcount_block);
+
+	/* If ocfs2_read_block() got us a new bh, pass it up. */
+	if (!rc && !*bh)
+		*bh = tmp;
+
+	return rc;
+}
-- 
1.6.2.rc2.16.gf474c
