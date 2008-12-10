From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:39 -0800
Subject: [Ocfs2-devel] [PATCH 02/18] ocfs2: Add the on-disk structures for
	metadata checksums.
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Define struct ocfs2_block_check, an 8-byte structure containing a 32bit
crc32_le and a 16bit hamming code ecc.  This will be used for metadata
checksums.  Add the structure to free spaces in the various metadata
structures.

Add the OCFS2_FEATURE_INCOMPAT_META_ECC bit.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |   55 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 4ae3984..4e20f50 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -148,6 +148,9 @@
 /* Support for extended attributes */
 #define OCFS2_FEATURE_INCOMPAT_XATTR		0x0200
 
+/* Metadata checksum and error correction */
+#define OCFS2_FEATURE_INCOMPAT_META_ECC		0x0800
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -421,6 +424,22 @@ static unsigned char ocfs2_type_by_mode[S_IFMT >> S_SHIFT] = {
 #define OCFS2_RAW_SB(dinode)		(&((dinode)->id2.i_super))
 
 /*
+ * Block checking structure.  This is used in metadata to validate the
+ * contents.  If OCFS2_FEATURE_INCOMPAT_META_ECC is not set, it is all
+ * zeros.
+ */
+struct ocfs2_block_check {
+/*00*/	__le32 bc_crc32e;	/* 802.3 Ethernet II CRC32 */
+	__le16 bc_ecc;		/* Single-error-correction parity vector.
+				   This is a simple Hamming code dependant
+				   on the blocksize.  OCFS2's maximum
+				   blocksize, 4K, requires 16 parity bits,
+				   so we fit in __le16. */
+	__le16 bc_reserved1;
+/*08*/
+};
+
+/*
  * On disk extent record for OCFS2
  * It describes a range of clusters on disk.
  *
@@ -507,7 +526,7 @@ struct ocfs2_truncate_log {
 struct ocfs2_extent_block
 {
 /*00*/	__u8 h_signature[8];		/* Signature for verification */
-	__le64 h_reserved1;
+	struct ocfs2_block_check h_check;	/* Error checking */
 /*10*/	__le16 h_suballoc_slot;		/* Slot suballocator this
 					   extent_header belongs to */
 	__le16 h_suballoc_bit;		/* Bit offset in suballocator
@@ -677,7 +696,8 @@ struct ocfs2_dinode {
 					   was set in i_flags */
 	__le16 i_dyn_features;
 	__le64 i_xattr_loc;
-/*80*/	__le64 i_reserved2[7];
+/*80*/	struct ocfs2_block_check i_check;	/* Error checking */
+/*88*/	__le64 i_reserved2[6];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
@@ -744,7 +764,8 @@ struct ocfs2_group_desc
 /*20*/	__le64   bg_parent_dinode;       /* dinode which owns me, in
 					   blocks */
 	__le64   bg_blkno;               /* Offset on disk, in blocks */
-/*30*/	__le64   bg_reserved2[2];
+/*30*/	struct ocfs2_block_check bg_check;	/* Error checking */
+	__le64   bg_reserved2;
 /*40*/	__u8    bg_bitmap[0];
 };
 
@@ -787,7 +808,12 @@ struct ocfs2_xattr_header {
 						   in this extent record,
 						   only valid in the first
 						   bucket. */
-	__le64  xh_csum;
+	struct ocfs2_block_check xh_check;	/* Error checking
+						   (Note, this is only
+						    used for xattr
+						    buckets.  A block uses
+						    xb_check and sets
+						    this field to zero.) */
 	struct ocfs2_xattr_entry xh_entries[0]; /* xattr entry list. */
 };
 
@@ -838,7 +864,7 @@ struct ocfs2_xattr_block {
 					block group */
 	__le32	xb_fs_generation;    /* Must match super block */
 /*10*/	__le64	xb_blkno;            /* Offset on disk, in blocks */
-	__le64	xb_csum;
+	struct ocfs2_block_check xb_check;	/* Error checking */
 /*20*/	__le16	xb_flags;            /* Indicates whether this block contains
 					real xattr or a xattr tree. */
 	__le16	xb_reserved0;
@@ -982,6 +1008,25 @@ struct ocfs2_local_disk_dqblk {
 /*10*/	__le64 dqb_inodemod;	/* Change in the amount of used inodes */
 };
 
+
+/*
+ * The quota trailer lives at the end of each quota block.
+ */
+
+struct ocfs2_disk_dqtrailer {
+/*00*/	struct ocfs2_block_check dq_check;	/* Error checking */
+/*08*/	/* Cannot be larger than OCFS2_QBLK_RESERVED_SPACE */
+};
+
+static inline struct ocfs2_disk_dqtrailer *ocfs2_block_dqtrailer(int blocksize,
+								 void *buf)
+{
+	char *ptr = buf;
+	ptr += blocksize - OCFS2_QBLK_RESERVED_SPACE;
+
+	return (struct ocfs2_disk_dqtrailer *)ptr;
+}
+
 #ifdef __KERNEL__
 static inline int ocfs2_fast_symlink_chars(struct super_block *sb)
 {
-- 
1.5.6.5
