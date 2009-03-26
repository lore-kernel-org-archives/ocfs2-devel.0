From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:08 +0800
Subject: [Ocfs2-devel] [PATCH 02/42] ocfs2: Define refcount tree structure.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |   55 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c7ae45a..b3e7bfd 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -66,6 +66,7 @@
 #define OCFS2_GROUP_DESC_SIGNATURE      "GROUP01"
 #define OCFS2_XATTR_BLOCK_SIGNATURE	"XATTR01"
 #define OCFS2_DIR_TRAILER_SIGNATURE	"DIRTRL1"
+#define OCFS2_REFCOUNT_BLOCK_SIGNATURE	"REFCNT1"
 
 /* Compatibility flags */
 #define OCFS2_HAS_COMPAT_FEATURE(sb,mask)			\
@@ -154,6 +155,9 @@
 /* Metadata checksum and error correction */
 #define OCFS2_FEATURE_INCOMPAT_META_ECC		0x0800
 
+/* Refcount tree support */
+#define OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE	0x1000
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -217,6 +221,7 @@
 #define OCFS2_HAS_XATTR_FL	(0x0002)
 #define OCFS2_INLINE_XATTR_FL	(0x0004)
 #define OCFS2_INDEXED_DIR_FL	(0x0008)
+#define OCFS2_HAS_REFCOUNT_FL   (0x0010)
 
 /* Inode attributes, keep in sync with EXT2 */
 #define OCFS2_SECRM_FL		(0x00000001)	/* Secure deletion */
@@ -235,8 +240,14 @@
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
+#define OCFS2_EXT_REFCOUNT_RECORD	(0x04)  /* Extent record is the
+						 * leaf of a refcount
+						 * tree */
 
 /*
  * ioctl commands
@@ -465,7 +476,14 @@ struct ocfs2_extent_rec {
 			__u8 e_flags; /* Extent flags */
 		};
 	};
-	__le64 e_blkno;		/* Physical disk offset, in blocks */
+	union {
+		__le64 e_blkno;		/* Physical disk offset, in blocks */
+		struct {
+			__le32 e_refcount;	/* Refrence count for
+						   this extent. */
+			__le32 e_reserved2;
+		};
+	};
 /*10*/
 };
 
@@ -705,7 +723,8 @@ struct ocfs2_dinode {
 	__le16 i_dyn_features;
 	__le64 i_xattr_loc;
 /*80*/	struct ocfs2_block_check i_check;	/* Error checking */
-/*88*/	__le64 i_reserved2[6];
+	__le64 i_refcount_loc;
+/*90*/	__le64 i_reserved2[5];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
@@ -805,6 +824,24 @@ struct ocfs2_group_desc
 /*40*/	__u8    bg_bitmap[0];
 };
 
+struct ocfs2_refcount_block {
+/*00*/	__u8    rf_signature[8];	/* Signature for verification */
+	__le16  rf_suballoc_slot;	/* Slot suballocator this block
+					   belongs to */
+	__le16  rf_suballoc_bit;	/* Bit offset in suballocator
+					   block group */
+	__le32  rf_fs_generation;	/* Must match superblock */
+/*10*/	__le64  rf_blkno;		/* Offset on disk, in blocks */
+	struct ocfs2_block_check rf_check;	/* Error checking */
+/*20*/  __le64  rf_last_eb_blk;		/* Pointer to last extent block */
+	__le32  rf_count;		/* Number of inodes sharing this
+					   refcount tree */
+	__le32  rf_clusters;
+/*30*/	__le64  rf_reserved2[10];
+/*80*/	struct ocfs2_extent_list rf_list;	/* Extent record list */
+/* Actual on-disk size is one block */
+};
+
 /*
  * On disk extended attribute structure for OCFS2.
  */
@@ -1192,6 +1229,16 @@ static inline u16 ocfs2_xattr_recs_per_xb(struct super_block *sb)
 
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
 #else
 static inline int ocfs2_fast_symlink_chars(int blocksize)
 {
-- 
1.6.2.rc2.16.gf474c
