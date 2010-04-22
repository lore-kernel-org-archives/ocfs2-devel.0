From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:15 +0800
Subject: [Ocfs2-devel] [PATCH 01/17] ocfs2: Define data structures for
	discontiguous block groups.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

Defines the OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG feature bit and modifies
struct ocfs2_group_desc for the feature.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/localalloc.c |    2 +-
 fs/ocfs2/ocfs2_fs.h   |   53 ++++++++++++++++++++++++++++++++++++++++++------
 fs/ocfs2/resize.c     |    4 +-
 fs/ocfs2/suballoc.c   |    2 +-
 fs/ocfs2/super.c      |    2 +-
 5 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 2882f79..cb06315 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -122,7 +122,7 @@ unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb)
 	struct super_block *sb = osb->sb;
 
 	gd_mb = ocfs2_clusters_to_megabytes(osb->sb,
-					    8 * ocfs2_group_bitmap_size(sb));
+					    8 * ocfs2_group_bitmap_size(sb, 0));
 
 	/*
 	 * This takes care of files systems with very small group
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index d61a152..448aa8d 100644
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
@@ -832,6 +835,13 @@ struct ocfs2_dx_leaf {
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
@@ -852,7 +862,29 @@ struct ocfs2_group_desc
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
@@ -1276,12 +1308,16 @@ static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
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
@@ -1404,12 +1440,15 @@ static inline int ocfs2_local_alloc_size(int blocksize)
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
index a821f66..5bbfc12 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -315,7 +315,7 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
-				 ocfs2_group_bitmap_size(osb->sb) * 8) {
+				 ocfs2_group_bitmap_size(osb->sb, 0) * 8) {
 		mlog(ML_ERROR, "The disk is too old and small. "
 		     "Force to do offline resize.");
 		ret = -EINVAL;
@@ -496,7 +496,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
-				 ocfs2_group_bitmap_size(osb->sb) * 8) {
+				 ocfs2_group_bitmap_size(osb->sb, 0) * 8) {
 		mlog(ML_ERROR, "The disk is too old and small."
 		     " Force to do offline resize.");
 		ret = -EINVAL;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f8aedb3..b82a667 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -364,7 +364,7 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	memset(bg, 0, sb->s_blocksize);
 	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
 	bg->bg_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
-	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb));
+	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1));
 	bg->bg_bits = cpu_to_le16(ocfs2_bits_per_group(cl));
 	bg->bg_chain = cpu_to_le16(my_chain);
 	bg->bg_next_group = cl->cl_recs[my_chain].c_blkno;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 79d7d4c..9bbed28 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2277,7 +2277,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->osb_clusters_at_boot = OCFS2_I(inode)->ip_clusters;
 	iput(inode);
 
-	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb) * 8;
+	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb, 0) * 8;
 
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
-- 
1.5.5
