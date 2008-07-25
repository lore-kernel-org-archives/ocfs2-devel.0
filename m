From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 25 Jul 2008 15:06:38 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2-tools: Add extended attribute
	support in mkfs.ocfs2
Message-ID: <1216969599-9280-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch add support for new feature xattr in mkfs.ocfs2.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 include/ocfs2-kernel/ocfs2_fs.h |   89 ++++++++++++++++++++++++++++++++++----
 include/ocfs2/ocfs2.h           |    2 +
 libocfs2/Makefile               |    3 +-
 libocfs2/feature_string.c       |    9 ++++-
 libocfs2/inode.c                |    7 +++
 libocfs2/xattr.c                |   37 ++++++++++++++++
 mkfs.ocfs2/mkfs.c               |    6 +++
 mkfs.ocfs2/mkfs.ocfs2.8.in      |    5 ++
 sizetest/sizetest.c             |   12 +++++-
 9 files changed, 157 insertions(+), 13 deletions(-)
 create mode 100644 libocfs2/xattr.c

diff --git a/include/ocfs2-kernel/ocfs2_fs.h b/include/ocfs2-kernel/ocfs2_fs.h
index 0cfef2a..ade9ec1 100644
--- a/include/ocfs2-kernel/ocfs2_fs.h
+++ b/include/ocfs2-kernel/ocfs2_fs.h
@@ -64,6 +64,7 @@
 #define OCFS2_INODE_SIGNATURE		"INODE01"
 #define OCFS2_EXTENT_BLOCK_SIGNATURE	"EXBLK01"
 #define OCFS2_GROUP_DESC_SIGNATURE      "GROUP01"
+#define OCFS2_XATTR_BLOCK_SIGNATURE	"XATTR01"
 
 /* Compatibility flags */
 #define OCFS2_HAS_COMPAT_FEATURE(sb,mask)			\
@@ -89,7 +90,8 @@
 #define OCFS2_FEATURE_INCOMPAT_SUPP	(OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT \
 					 | OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC \
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
-					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK)
+					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
+					 | OCFS2_FEATURE_INCOMPAT_XATTR)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
 
 /*
@@ -126,10 +128,6 @@
 /* Support for data packed into inode blocks */
 #define OCFS2_FEATURE_INCOMPAT_INLINE_DATA	0x0040
 
-/* Support for the extended slot map */
-#define OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP 0x100
-
-
 /*
  * Support for alternate, userspace cluster stacks.  If set, the superblock
  * field s_cluster_info contains a tag for the alternate stack in use as
@@ -141,6 +139,12 @@
  */
 #define OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK	0x0080
 
+/* Support for the extended slot map */
+#define OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP 0x100
+
+/* Support for extended attributes */
+#define OCFS2_FEATURE_INCOMPAT_XATTR		0x0200
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -554,7 +558,7 @@ struct ocfs2_super_block {
 /*40*/	__le16 s_max_slots;		/* Max number of simultaneous mounts
 					   before tunefs required */
 	__le16 s_tunefs_flag;
-	__le32 s_reserved1;
+	__le32 s_uuid_hash;
 	__le64 s_first_cluster_group;	/* Block offset of 1st cluster
 					 * group header */
 /*50*/	__u8  s_label[OCFS2_MAX_VOL_LABEL_LEN];	/* Label for mounting, etc. */
@@ -562,7 +566,11 @@ struct ocfs2_super_block {
 /*A0*/  struct ocfs2_cluster_info s_cluster_info; /* Selected userspace
 						     stack.  Only valid
 						     with INCOMPAT flag. */
-/*B8*/  __le64 s_reserved2[17];		/* Fill out superblock */
+/*B8*/	__le16 s_xattr_inline_size;	/* extended attribute inline size
+					   for this fs*/
+	__le16 s_reserved0;
+	__le32 s_reserved1;
+/*C0*/  __le64 s_reserved2[16];		/* Fill out superblock */
 /*140*/
 
 	/*
@@ -612,7 +620,8 @@ struct ocfs2_dinode {
 					   belongs to */
 	__le16 i_suballoc_bit;		/* Bit offset in suballocator
 					   block group */
-/*10*/	__le32 i_reserved0;
+/*10*/	__le16 i_reserved0;
+	__le16 i_xattr_inline_size;
 	__le32 i_clusters;		/* Cluster count */
 	__le32 i_uid;			/* Owner UID */
 	__le32 i_gid;			/* Owning GID */
@@ -631,11 +640,12 @@ struct ocfs2_dinode {
 	__le32 i_atime_nsec;
 	__le32 i_ctime_nsec;
 	__le32 i_mtime_nsec;
-	__le32 i_attr;
+/*70*/	__le32 i_attr;
 	__le16 i_orphaned_slot;		/* Only valid when OCFS2_ORPHANED_FL
 					   was set in i_flags */
 	__le16 i_dyn_features;
-/*70*/	__le64 i_reserved2[8];
+	__le64 i_xattr_loc;
+/*80*/	__le64 i_reserved2[7];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
@@ -706,6 +716,65 @@ struct ocfs2_group_desc
 /*40*/	__u8    bg_bitmap[0];
 };
 
+/*
+ * On disk extended attribute structure for OCFS2
+ * Include ocfs2_xattr_entry, ocfs2_xattr_header, ocfs2_xattr_value_root
+ * ocfs2_xattr_tree_root and ocfs2_xattr_block.
+ */
+#define OCFS2_XATTR_INDEXED		0x1
+
+#define OCFS2_HASH_SHIFT		5
+
+/* Inline extended attribute size (in bytes) */
+#define OCFS2_MIN_XATTR_INLINE_SIZE     256
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
+	__le64  xh_reserved2;
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
 #ifdef __KERNEL__
 static inline int ocfs2_fast_symlink_chars(struct super_block *sb)
 {
diff --git a/include/ocfs2/ocfs2.h b/include/ocfs2/ocfs2.h
index 642027e..1f81c47 100644
--- a/include/ocfs2/ocfs2.h
+++ b/include/ocfs2/ocfs2.h
@@ -941,4 +941,6 @@ errcode_t ocfs2_block_iterate_inode(ocfs2_filesys *fs,
 						void *priv_data),
 				    void *priv_data);
 
+uint32_t xattr_uuid_hash(unsigned char *uuid);
+
 #endif  /* _FILESYS_H */
diff --git a/libocfs2/Makefile b/libocfs2/Makefile
index 5e12e7c..941688d 100644
--- a/libocfs2/Makefile
+++ b/libocfs2/Makefile
@@ -73,7 +73,8 @@ CFILES = 		\
 	lockid.c	\
 	backup_super.c	\
 	feature_string.c\
-	image.c
+	image.c		\
+	xattr.c
 
 HFILES =		\
 	bitmap.h	\
diff --git a/libocfs2/feature_string.c b/libocfs2/feature_string.c
index 4dc6a19..e4b914c 100644
--- a/libocfs2/feature_string.c
+++ b/libocfs2/feature_string.c
@@ -59,7 +59,8 @@ static ocfs2_fs_options feature_level_defaults[] = {
 
 	{OCFS2_FEATURE_COMPAT_BACKUP_SB,
 	 OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC |
-	 OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP,
+	 OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP |
+	 OCFS2_FEATURE_INCOMPAT_XATTR,
 	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN}, /* OCFS2_FEATURE_LEVEL_MAX_FEATURES */
 };
 
@@ -91,6 +92,12 @@ static struct fs_feature_flags ocfs2_supported_features[] = {
 		{0, OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP, 0},
 	},
 	{
+		"xattr",
+		{0, OCFS2_FEATURE_INCOMPAT_XATTR, 0},
+		{0, OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC |
+		 OCFS2_FEATURE_INCOMPAT_XATTR, 0},
+	},
+	{
 		NULL,
 		{0, 0, 0},
 		{0, 0, 0}
diff --git a/libocfs2/inode.c b/libocfs2/inode.c
index d556b38..cf8323e 100644
--- a/libocfs2/inode.c
+++ b/libocfs2/inode.c
@@ -127,7 +127,10 @@ static void ocfs2_swap_inode_second(struct ocfs2_dinode *di)
 		sb->s_blocksize_bits      = bswap_32(sb->s_blocksize_bits);
 		sb->s_clustersize_bits    = bswap_32(sb->s_clustersize_bits);
 		sb->s_max_slots           = bswap_16(sb->s_max_slots);
+		sb->s_tunefs_flag         = bswap_16(sb->s_tunefs_flag);
+		sb->s_uuid_hash           = bswap_32(sb->s_uuid_hash);
 		sb->s_first_cluster_group = bswap_64(sb->s_first_cluster_group);
+		sb->s_xattr_inline_size   = bswap_16(sb->s_xattr_inline_size);
 
 	} else if (di->i_flags & OCFS2_LOCAL_ALLOC_FL) {
 		struct ocfs2_local_alloc *la = &di->id2.i_lab;
@@ -156,6 +159,7 @@ static void ocfs2_swap_inode_first(struct ocfs2_dinode *di)
 	di->i_generation    = bswap_32(di->i_generation);
 	di->i_suballoc_slot = bswap_16(di->i_suballoc_slot);
 	di->i_suballoc_bit  = bswap_16(di->i_suballoc_bit);
+	di->i_xattr_inline_size = bswap_16(di->i_xattr_inline_size);
 	di->i_clusters      = bswap_32(di->i_clusters);
 	di->i_uid           = bswap_32(di->i_uid);
 	di->i_gid           = bswap_32(di->i_gid);
@@ -174,6 +178,9 @@ static void ocfs2_swap_inode_first(struct ocfs2_dinode *di)
 	di->i_ctime_nsec    = bswap_32(di->i_ctime_nsec);
 	di->i_mtime_nsec    = bswap_32(di->i_mtime_nsec);
 	di->i_attr          = bswap_32(di->i_attr);
+	di->i_orphaned_slot = bswap_16(di->i_orphaned_slot);
+	di->i_dyn_features  = bswap_16(di->i_dyn_features);
+	di->i_xattr_loc     = bswap_64(di->i_xattr_loc);
 }
 
 static int has_extents(struct ocfs2_dinode *di)
diff --git a/libocfs2/xattr.c b/libocfs2/xattr.c
new file mode 100644
index 0000000..d198743
--- /dev/null
+++ b/libocfs2/xattr.c
@@ -0,0 +1,37 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * Copyright (C) 2004 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License, version 2,  as published by the Free Software Foundation.
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
+#include <string.h>
+#include <inttypes.h>
+
+#include "ocfs2/byteorder.h"
+#include "ocfs2/ocfs2.h"
+
+uint32_t xattr_uuid_hash(unsigned char *uuid)
+{
+	uint32_t i, hash = 0;
+
+	for (i = 0; i < OCFS2_VOL_UUID_LEN; i++) {
+		hash = (hash << OCFS2_HASH_SHIFT) ^
+			(hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
+			*uuid++;
+	}
+	return hash;
+}
+
diff --git a/mkfs.ocfs2/mkfs.c b/mkfs.ocfs2/mkfs.c
index dce7cab..8ce5651 100644
--- a/mkfs.ocfs2/mkfs.c
+++ b/mkfs.ocfs2/mkfs.c
@@ -1876,6 +1876,12 @@ format_superblock(State *s, SystemFileDiskRecord *rec,
 	 */
 	s->feature_flags.opt_compat &= !OCFS2_FEATURE_COMPAT_BACKUP_SB;
 
+	if (s->feature_flags.opt_incompat & OCFS2_FEATURE_INCOMPAT_XATTR) {
+		di->id2.i_super.s_xattr_inline_size =
+						OCFS2_MIN_XATTR_INLINE_SIZE;
+		di->id2.i_super.s_uuid_hash = xattr_uuid_hash(s->uuid);
+	}
+
 	di->id2.i_super.s_feature_incompat = s->feature_flags.opt_incompat;
 	di->id2.i_super.s_feature_compat = s->feature_flags.opt_compat;
 	di->id2.i_super.s_feature_ro_compat = s->feature_flags.opt_ro_compat;
diff --git a/mkfs.ocfs2/mkfs.ocfs2.8.in b/mkfs.ocfs2/mkfs.ocfs2.8.in
index 6b553f8..cd36eea 100644
--- a/mkfs.ocfs2/mkfs.ocfs2.8.in
+++ b/mkfs.ocfs2/mkfs.ocfs2.8.in
@@ -108,6 +108,11 @@ Enable support for sparse files. With this, \fIOCFS2\fR can avoid allocating (an
 \fBunwritten\fR
 Enable unwritten extents support. With this turned on, an application can request that a range of clusters be pre-allocated within a file. \fIOCFS2\fR will mark those extents with a special flag so that expensive data zeroing doesn't have to be performed. Reads and writes to a pre-allocated region act as reads and writes to a hole, except a write will not fail due to lack of data allocation. This feature requires \fBsparse\fR file support to be turned on. Available with the file system bundled with Linux kernels 2.6.23 and later.
 .RE
+.RS 1.2i
+.TP
+\fBxattr\fR
+Enable support for extended attribute.
+.RE
 
 .TP
 \fB\-\-fs\-feature\-level=\fR\fR\fIfeature\-level\fR
diff --git a/sizetest/sizetest.c b/sizetest/sizetest.c
index 35d85f0..fff0787 100644
--- a/sizetest/sizetest.c
+++ b/sizetest/sizetest.c
@@ -137,10 +137,15 @@ static void print_ocfs2_super_block(void)
 	SHOW_OFFSET(struct ocfs2_super_block, s_clustersize_bits);
 	SHOW_OFFSET(struct ocfs2_super_block, s_max_slots);
 	SHOW_OFFSET(struct ocfs2_super_block, s_tunefs_flag);
-	SHOW_OFFSET(struct ocfs2_super_block, s_reserved1);
+	SHOW_OFFSET(struct ocfs2_super_block, s_uuid_hash);
 	SHOW_OFFSET(struct ocfs2_super_block, s_first_cluster_group);
 	SHOW_OFFSET(struct ocfs2_super_block, s_label);
 	SHOW_OFFSET(struct ocfs2_super_block, s_uuid);
+	SHOW_OFFSET(struct ocfs2_super_block, s_cluster_info);
+	SHOW_OFFSET(struct ocfs2_super_block, s_xattr_inline_size);
+	SHOW_OFFSET(struct ocfs2_super_block, s_reserved0);
+	SHOW_OFFSET(struct ocfs2_super_block, s_reserved1);
+	SHOW_OFFSET(struct ocfs2_super_block, s_reserved2);
 	
         END_TYPE(struct ocfs2_super_block);
         printf("\n");
@@ -169,6 +174,7 @@ static void print_ocfs2_dinode(void)
 	SHOW_OFFSET(struct ocfs2_dinode, i_suballoc_slot);
 	SHOW_OFFSET(struct ocfs2_dinode, i_suballoc_bit);
 	SHOW_OFFSET(struct ocfs2_dinode, i_reserved0);
+	SHOW_OFFSET(struct ocfs2_dinode, i_xattr_inline_size);
 	SHOW_OFFSET(struct ocfs2_dinode, i_clusters);
 	SHOW_OFFSET(struct ocfs2_dinode, i_uid);
 	SHOW_OFFSET(struct ocfs2_dinode, i_gid);
@@ -187,7 +193,9 @@ static void print_ocfs2_dinode(void)
 	SHOW_OFFSET(struct ocfs2_dinode, i_ctime_nsec);
 	SHOW_OFFSET(struct ocfs2_dinode, i_mtime_nsec);
 	SHOW_OFFSET(struct ocfs2_dinode, i_attr);
+	SHOW_OFFSET(struct ocfs2_dinode, i_orphaned_slot);
 	SHOW_OFFSET(struct ocfs2_dinode, i_dyn_features);
+	SHOW_OFFSET(struct ocfs2_dinode, i_xattr_loc);
 	SHOW_OFFSET(struct ocfs2_dinode, i_reserved2);
 
 	SHOW_OFFSET(struct ocfs2_dinode, id1.i_pad1);
@@ -201,6 +209,8 @@ static void print_ocfs2_dinode(void)
 	SHOW_OFFSET(struct ocfs2_dinode, id2.i_lab);
 	SHOW_OFFSET(struct ocfs2_dinode, id2.i_chain);
 	SHOW_OFFSET(struct ocfs2_dinode, id2.i_list);
+	SHOW_OFFSET(struct ocfs2_dinode, id2.i_dealloc);
+	SHOW_OFFSET(struct ocfs2_dinode, id2.i_data);
 	SHOW_OFFSET(struct ocfs2_dinode, id2.i_symlink);
 	
         END_TYPE(struct ocfs2_dinode);
-- 
1.5.4.4
