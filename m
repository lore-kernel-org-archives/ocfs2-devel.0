From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 18 Sep 2012 17:11:01 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: new structure to implement
	discontiguous localalloc bitmap
In-Reply-To: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
References: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1348013463-23980-4-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently localalloc bitmap uses single contiguous free chunk of clusters. It's
size gets reduced as the contiguous free chunks gets smaller. This ultimately
gets disabled if the largest contiguous free chunk is smaller than 1Mb.

This patch localalloc bitmap to use space from multiple contiguous free chunk
clusters.

This patch introduces new ocfs2_local_alloc_rec structure which tracks a
single contiguous free chunk. When discontigous localalloc is enabled,
ocfs2_local_alloc now holds an array of these records each pointing to a free
chunk on the disk. In best case there is one record and as the filesystem gets
fragmented you may see multipe records.

This feature can be enabled/disabled when the file system is offline.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/localalloc.c |   22 ++++++++++++++--
 fs/ocfs2/ocfs2.h      |    7 +++++
 fs/ocfs2/ocfs2_fs.h   |   65 ++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 79 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 45818df..98961f4 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -48,6 +48,13 @@
 
 #define OCFS2_LOCAL_ALLOC(dinode)	(&((dinode)->id2.i_lab))
 
+#define OCFS2_LOCAL_ALLOC_REC_SZ(la)	(le16_to_cpu(la->la_rec_count) *\
+					 sizeof(struct ocfs2_local_alloc_rec))
+#define OCFS2_LOCAL_ALLOC_BITS_PER_REC (sizeof(struct ocfs2_local_alloc_rec)*8)
+
+#define OCFS2_LOCAL_ALLOC_SIZE(osb)	ocfs2_local_alloc_size(osb->sb,\
+						       osb->s_feature_incompat)
+
 static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc);
 
 static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
@@ -74,6 +81,15 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 
 static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb);
 
+static inline u8 *ocfs2_local_alloc_bitmap(struct ocfs2_super *osb,
+					   struct ocfs2_local_alloc *la)
+{
+	if (ocfs2_supports_discontig_la(osb))
+		return (u8 *)la->la_recs + le16_to_cpu(la->la_bm_start);
+	else
+		return la->la_bitmap;
+}
+
 /*
  * ocfs2_la_default_mb() - determine a default size, in megabytes of
  * the local alloc.
@@ -184,7 +200,7 @@ unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb)
 
 	/* We can't store more bits than we can in a block. */
 	la_max_mb = ocfs2_clusters_to_megabytes(osb->sb,
-						ocfs2_local_alloc_size(sb) * 8);
+					OCFS2_LOCAL_ALLOC_SIZE(osb) * 8);
 	if (la_mb > la_max_mb)
 		la_mb = la_max_mb;
 
@@ -198,7 +214,7 @@ void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
 	unsigned int la_max_mb;
 
 	la_max_mb = ocfs2_clusters_to_megabytes(sb,
-						ocfs2_local_alloc_size(sb) * 8);
+					OCFS2_LOCAL_ALLOC_SIZE(osb) * 8);
 
 	trace_ocfs2_la_set_sizes(requested_mb, la_max_mb, la_default_mb);
 
@@ -329,7 +345,7 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 	}
 
 	if ((la->la_size == 0) ||
-	    (le16_to_cpu(la->la_size) > ocfs2_local_alloc_size(inode->i_sb))) {
+	    (le16_to_cpu(la->la_size) > OCFS2_LOCAL_ALLOC_SIZE(osb))) {
 		mlog(ML_ERROR, "Local alloc size is invalid (la_size = %u)\n",
 		     le16_to_cpu(la->la_size));
 		status = -EINVAL;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 836a647..7ab1afe 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -523,6 +523,13 @@ static inline int ocfs2_supports_discontig_bg(struct ocfs2_super *osb)
 	return 0;
 }
 
+static inline int ocfs2_supports_discontig_la(struct ocfs2_super *osb)
+{
+	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_DISCONTIG_LA)
+		return 1;
+	return 0;
+}
+
 static inline unsigned int ocfs2_link_max(struct ocfs2_super *osb)
 {
 	if (ocfs2_supports_indexed_dirs(osb))
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 938387a..409b2b0 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -102,7 +102,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS \
 					 | OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE \
 					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG	\
-					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO)
+					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO \
+					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_LA)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
 					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
@@ -177,6 +178,9 @@
  */
 #define OCFS2_FEATURE_INCOMPAT_CLUSTERINFO	0x4000
 
+/* Discontiguous local alloc */
+#define OCFS2_FEATURE_INCOMPAT_DISCONTIG_LA	0x8000
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -661,17 +665,44 @@ struct ocfs2_super_block {
 };
 
 /*
+ * LocalAlloc record used when discontig-la is enabled. Each record points
+ * to one contiguous chunk
+ */
+#define OCFS2_MAX_LOCAL_ALLOC_REC_LIMIT	128 	/* Max localalloc records */
+
+struct ocfs2_local_alloc_rec {
+	__le32 la_start;	/* 1st cluster in this extent */
+	__le32 la_clusters;	/* Number of contiguous clusters */
+};
+
+/*
  * Local allocation bitmap for OCFS2 slots
  * Note that it exists inside an ocfs2_dinode, so all offsets are
  * relative to the start of ocfs2_dinode.id2.
+ * Each ocfs2_local_alloc_rec tracks one contigous chunk of clusters.
  */
 struct ocfs2_local_alloc
 {
-/*00*/	__le32 la_bm_off;	/* Starting bit offset in main bitmap */
-	__le16 la_size;		/* Size of included bitmap, in bytes */
-	__le16 la_reserved1;
-	__le64 la_reserved2;
-/*10*/	__u8   la_bitmap[0];
+	union {
+		/* struct used when localalloc is contiguous */
+		struct {
+		/*00*/	__le32 la_bm_off;	/* offset in main bitmap */
+			__le16 la_size;		/* Size of bitmap, in bytes */
+			__le16 la_reserved1;
+			__le64 la_reserved2;
+		/*10*/ 	__u8   la_bitmap[0];
+		};
+
+		/* struct used when localalloc can be discontigous */
+		struct {
+		/*00*/	__le16 la_bm_start;  /* start offset to the bitmap */
+			__le16 la_rec_count; /* number of localalloc recs */
+			__le16 la_dc_size;   /* space for records & bitmap */
+			__le16 la_reserved3;
+			__le64 la_reserved4;
+		/*10*/	struct ocfs2_local_alloc_rec la_recs[0];
+		};
+	};
 };
 
 /*
@@ -1375,12 +1406,17 @@ static inline int ocfs2_dx_entries_per_root(struct super_block *sb)
 	return size / sizeof(struct ocfs2_dx_entry);
 }
 
-static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
+static inline u16 ocfs2_local_alloc_size(struct super_block *sb,
+					 u32 feature_incompat)
 {
 	u16 size;
 
-	size = sb->s_blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_lab.la_bitmap);
+	if (feature_incompat & OCFS2_FEATURE_INCOMPAT_DISCONTIG_LA)
+		size = sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_lab.la_bitmap);
+	else
+		size = sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_lab.la_bitmap);
 
 	return size;
 }
@@ -1523,12 +1559,17 @@ static inline int ocfs2_extent_recs_per_gd(int blocksize)
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 
-static inline int ocfs2_local_alloc_size(int blocksize)
+static inline int ocfs2_local_alloc_size(int blocksize,
+					 u32 feature_incompat)
 {
 	int size;
 
-	size = blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_lab.la_bitmap);
+	if (feature_incompat & OCFS2_FEATURE_INCOMPAT_DISCONTIG_LA)
+		size = blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_lab.la_recs);
+	else
+		size = blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_lab.la_bitmap);
 
 	return size;
 }
-- 
1.5.4.3
