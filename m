From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:13 +0800
Subject: [Ocfs2-devel] [PATCH 01/39] ocfs2: Define refcount tree structure.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |   85 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 7ab6e9e..8d47d74 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -68,6 +68,7 @@
 #define OCFS2_DIR_TRAILER_SIGNATURE	"DIRTRL1"
 #define OCFS2_DX_ROOT_SIGNATURE		"DXDIR01"
 #define OCFS2_DX_LEAF_SIGNATURE		"DXLEAF1"
+#define OCFS2_REFCOUNT_BLOCK_SIGNATURE	"REFCNT1"
 
 /* Compatibility flags */
 #define OCFS2_HAS_COMPAT_FEATURE(sb,mask)			\
@@ -160,6 +161,9 @@
 /* Metadata checksum and error correction */
 #define OCFS2_FEATURE_INCOMPAT_META_ECC		0x0800
 
+/* Refcount tree support */
+#define OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE	0x1000
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -223,6 +227,7 @@
 #define OCFS2_HAS_XATTR_FL	(0x0002)
 #define OCFS2_INLINE_XATTR_FL	(0x0004)
 #define OCFS2_INDEXED_DIR_FL	(0x0008)
+#define OCFS2_HAS_REFCOUNT_FL   (0x0010)
 
 /* Inode attributes, keep in sync with EXT2 */
 #define OCFS2_SECRM_FL		(0x00000001)	/* Secure deletion */
@@ -241,8 +246,11 @@
 /*
  * Extent record flags (e_node.leaf.flags)
  */
-#define OCFS2_EXT_UNWRITTEN	(0x01)	/* Extent is allocated but
-					 * unwritten */
+#define OCFS2_EXT_UNWRITTEN		(0x01)	/* Extent is allocated but
+						 * unwritten */
+#define OCFS2_EXT_REFCOUNTED		(0x02)  /* Extent is reference
+						 * counted in an associated
+						 * refcount tree */
 
 /*
  * ioctl commands
@@ -717,7 +725,8 @@ struct ocfs2_dinode {
 	__le64 i_xattr_loc;
 /*80*/	struct ocfs2_block_check i_check;	/* Error checking */
 /*88*/	__le64 i_dx_root;		/* Pointer to dir index root block */
-	__le64 i_reserved2[5];
+/*90*/	__le64 i_refcount_loc;
+	__le64 i_reserved2[4];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
@@ -901,6 +910,56 @@ struct ocfs2_group_desc
 /*40*/	__u8    bg_bitmap[0];
 };
 
+struct ocfs2_refcount_rec {
+/*00*/  __le64 r_cpos;		/* Physical offset, in clusters */
+	__le32 r_clusters;	/* Clusters covered by this extent */
+	__le32 r_refcount;	/* Reference count of this extent */
+/*10*/
+};
+
+#define OCFS2_REFCOUNT_LEAF_FL          (0x00000001)
+#define OCFS2_REFCOUNT_TREE_FL          (0x00000002)
+
+struct ocfs2_refcount_list {
+/*00*/  __le16 rl_count;	/* Maximum number of entries possible
+				   in rl_records */
+	__le16 rl_used;		/* Current number of used records */
+	__le32 rl_reserved2;
+	__le64 rl_reserved1;	/* Pad to sizeof(ocfs2_refcount_record) */
+/*10*/	struct ocfs2_refcount_rec rl_recs[0];	/* Refcount records */
+};
+
+
+struct ocfs2_refcount_block {
+/*00*/	__u8 rf_signature[8];		/* Signature for verification */
+	__le16 rf_suballoc_slot;	/* Slot suballocator this block
+					   belongs to */
+	__le16 rf_suballoc_bit;		/* Bit offset in suballocator
+					   block group */
+	__le32 rf_fs_generation;	/* Must match superblock */
+/*10*/	__le64 rf_blkno;		/* Offset on disk, in blocks */
+	__le64 rf_parent;		/* Parent block, only valid if
+					   OCFS2_REFCOUNT_LEAF_FL is set in
+					   rf_flags */
+/*20*/	struct ocfs2_block_check rf_check;	/* Error checking */
+	__le64 rf_last_eb_blk;		/* Pointer to last extent block */
+/*30*/	__le32 rf_count;		/* Number of inodes sharing this
+					   refcount tree */
+	__le32 rf_flags;		/* See the flags above */
+	__le32 rf_clusters;		/* clusters covered by refcount tree. */
+	__le32 rf_cpos;			/* cluster offset in refcount tree.*/
+/*40*/	__le64 rf_reserved1[8];
+/*80*/	union {
+		struct ocfs2_refcount_list rf_records;  /* List of refcount
+							  records */
+		struct ocfs2_extent_list rf_list;	/* Extent record list,
+							only valid if
+							OCFS2_REFCOUNT_TREE_FL
+							is set in rf_flags */
+	};
+/* Actual on-disk size is one block */
+};
+
 /*
  * On disk extended attribute structure for OCFS2.
  */
@@ -1312,6 +1371,26 @@ static inline u16 ocfs2_xattr_recs_per_xb(struct super_block *sb)
 
 	return size / sizeof(struct ocfs2_extent_rec);
 }
+
+static inline u16 ocfs2_extent_recs_per_rb(struct super_block *sb)
+{
+	int size;
+
+	size = sb->s_blocksize -
+		offsetof(struct ocfs2_refcount_block, rf_list.l_recs);
+
+	return size / sizeof(struct ocfs2_extent_rec);
+}
+
+static inline u16 ocfs2_refcount_recs_per_rb(struct super_block *sb)
+{
+	int size;
+
+	size = sb->s_blocksize -
+		offsetof(struct ocfs2_refcount_block, rf_records.rl_recs);
+
+	return size / sizeof(struct ocfs2_refcount_rec);
+}
 #else
 static inline int ocfs2_fast_symlink_chars(int blocksize)
 {
-- 
1.6.2.rc2.16.gf474c
