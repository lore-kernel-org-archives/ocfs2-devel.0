From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  1 Apr 2010 10:58:58 +0800
Subject: [Ocfs2-devel] [PATCH 01/15] ocfs2: Define data structures for
	discontiguous block groups.
In-Reply-To: <4BB40AB4.8040205@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
Message-ID: <1270090752-18935-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

Defines the OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG feature bit and modifies
struct ocfs2_group_desc for the feature.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |   53 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/ocfs2/resize.c   |    4 +-
 fs/ocfs2/suballoc.c |    2 +-
 fs/ocfs2/super.c    |    2 +-
 4 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index bb37218..055cf07 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -165,6 +165,9 @@
 /* Refcount tree support */
 #define OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE	0x1000
 
+/* Discontigous block groups */
+#define OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG	0x2000
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -840,6 +843,13 @@ struct ocfs2_dx_leaf {
 };
 
 /*
+ * Largest bitmap for a block (suballocator) group in bytes.  This limit
+ * does not affect cluster groups (global allocator).  Cluster group
+ * bitmaps run to the end of the block.
+ */
+#define OCFS2_MAX_BG_BITMAP_SIZE	256
+
+/*
  * On disk allocator group structure for OCFS2
  */
 struct ocfs2_group_desc
@@ -860,7 +870,29 @@ struct ocfs2_group_desc
 	__le64   bg_blkno;               /* Offset on disk, in blocks */
 /*30*/	struct ocfs2_block_check bg_check;	/* Error checking */
 	__le64   bg_reserved2;
-/*40*/	__u8    bg_bitmap[0];
+/*40*/	union {
+		__u8    bg_bitmap[0];
+		struct {
+			/*
+			 * Block groups may be discontiguous when
+			 * OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG is set.
+			 * The extents of a discontigous block group are
+			 * stored in bg_list.  It is a flat list.
+			 * l_tree_depth must always be zero.  A
+			 * discontiguous group is signified by a non-zero
+			 * bg_list->l_next_free_rec.  Only block groups
+			 * can be discontiguous; Cluster groups cannot.
+			 * We've never made a block group with more than
+			 * 2048 blocks (256 bytes of bg_bitmap).  This
+			 * codifies that limit so that we can fit bg_list.
+			 * bg_size of a discontiguous block group will
+			 * be 256 to match bg_bitmap_filler.
+			 */
+			__u8 bg_bitmap_filler[OCFS2_MAX_BG_BITMAP_SIZE];
+/*140*/			struct ocfs2_extent_list bg_list;
+		};
+	};
+/* Actual on-disk size is one block */
 };
 
 struct ocfs2_refcount_rec {
@@ -1284,12 +1316,16 @@ static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
 	return size;
 }
 
-static inline int ocfs2_group_bitmap_size(struct super_block *sb)
+static inline int ocfs2_group_bitmap_size(struct super_block *sb,
+					  int suballocator)
 {
 	int size;
 
-	size = sb->s_blocksize -
-		offsetof(struct ocfs2_group_desc, bg_bitmap);
+	if (suballocator)
+		size = OCFS2_MAX_BG_BITMAP_SIZE;
+	else
+		size = sb->s_blocksize -
+			offsetof(struct ocfs2_group_desc, bg_bitmap);
 
 	return size;
 }
@@ -1412,12 +1448,15 @@ static inline int ocfs2_local_alloc_size(int blocksize)
 	return size;
 }
 
-static inline int ocfs2_group_bitmap_size(int blocksize)
+static inline int ocfs2_group_bitmap_size(int blocksize, int suballocator)
 {
 	int size;
 
-	size = blocksize -
-		offsetof(struct ocfs2_group_desc, bg_bitmap);
+	if (suballocator)
+		size = OCFS2_MAX_BG_BITMAP_SIZE;
+	else
+		size = blocksize -
+			offsetof(struct ocfs2_group_desc, bg_bitmap);
 
 	return size;
 }
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 3c3d673..0ff4835 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -319,7 +319,7 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
-				 ocfs2_group_bitmap_size(osb->sb) * 8) {
+				 ocfs2_group_bitmap_size(osb->sb, 0) * 8) {
 		mlog(ML_ERROR, "The disk is too old and small. "
 		     "Force to do offline resize.");
 		ret = -EINVAL;
@@ -500,7 +500,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
-				 ocfs2_group_bitmap_size(osb->sb) * 8) {
+				 ocfs2_group_bitmap_size(osb->sb, 0) * 8) {
 		mlog(ML_ERROR, "The disk is too old and small."
 		     " Force to do offline resize.");
 		ret = -EINVAL;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index c3c60bc..84125bf 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -363,7 +363,7 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	memset(bg, 0, sb->s_blocksize);
 	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
 	bg->bg_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
-	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb));
+	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1));
 	bg->bg_bits = cpu_to_le16(ocfs2_bits_per_group(cl));
 	bg->bg_chain = cpu_to_le16(my_chain);
 	bg->bg_next_group = cl->cl_recs[my_chain].c_blkno;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index dee0319..de8547f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2226,7 +2226,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
 	iput(inode);
 
-	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb) * 8;
+	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb, 0) * 8;
 
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
-- 
1.5.5
