From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon,  7 May 2012 16:21:28 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: new structure to implment
	discontiguous local alloc bitmap
In-Reply-To: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1336432890-18638-2-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Current local alloc handles single contiguous free chunk of clusters. This
patch enhances local alloc to handle discontigous free chunks. It adds a new
ocfs2_local_alloc_rec structure which tracks single contiguous free chunk. An
array of these sit in the bitmap itself and track discontiguous chunks. In
best case there is only one record and increases as the filesystem gets
fragmented. Number of records at a time are limited depending on the size
of the bitmap and the max limit is defined by OCFS2_MAX_LOCAL_ALLOC_RECS.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/localalloc.c |   10 ++++++++++
 fs/ocfs2/ocfs2.h      |    8 ++++++++
 fs/ocfs2/ocfs2_fs.h   |   48 ++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 210c352..4190e53 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -48,6 +48,16 @@
 
 #define OCFS2_LOCAL_ALLOC(dinode)	(&((dinode)->id2.i_lab))
 
+#define OCFS2_LOCAL_ALLOC_REC_SZ(la)	(le16_to_cpu(la->la_rec_count) *\
+					 sizeof(struct ocfs2_local_alloc_rec))
+#define OCFS2_LOCAL_ALLOC_BITMAP(la)    ((char *)(&(la->la_recs)) +\
+					 OCFS2_LOCAL_ALLOC_REC_SZ(la))
+#define OCFS2_LOCAL_ALLOC_BITS_PER_REC (sizeof(struct ocfs2_local_alloc_rec)*8)
+
+/* Maximum number of local alloc records */
+#define OCFS2_MAX_LOCAL_ALLOC_REC_LIMIT	128
+
+
 static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc);
 
 static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index d355e6e..d4c36d2 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -367,6 +367,7 @@ struct ocfs2_super
 							 * by osb_lock */
 
 	struct buffer_head *local_alloc_bh;
+	struct inode	   *local_alloc_inode;
 
 	u64 la_last_gd;
 
@@ -522,6 +523,13 @@ static inline int ocfs2_supports_discontig_bg(struct ocfs2_super *osb)
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
index 938387a..6a0fe02 100644
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
@@ -664,14 +668,19 @@ struct ocfs2_super_block {
  * Local allocation bitmap for OCFS2 slots
  * Note that it exists inside an ocfs2_dinode, so all offsets are
  * relative to the start of ocfs2_dinode.id2.
+ * Each ocfs2_local_alloc_rec tracks one contigous chunk of clusters.
  */
+struct ocfs2_local_alloc_rec {
+	__le32 la_start;	/* 1st cluster in this extent */
+	__le32 la_clusters;	/* Number of contiguous clusters */
+};
+
 struct ocfs2_local_alloc
 {
 /*00*/	__le32 la_bm_off;	/* Starting bit offset in main bitmap */
 	__le16 la_size;		/* Size of included bitmap, in bytes */
-	__le16 la_reserved1;
-	__le64 la_reserved2;
-/*10*/	__u8   la_bitmap[0];
+	__le16 la_rec_count;	/* Number of discontiguous records */
+	struct ocfs2_local_alloc_rec la_recs[0]; /* Localalloc records */
 };
 
 /*
@@ -1380,11 +1389,24 @@ static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
 	u16 size;
 
 	size = sb->s_blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_lab.la_bitmap);
+		offsetof(struct ocfs2_dinode, id2.i_lab.la_recs);
+	size -= sizeof(struct ocfs2_local_alloc_rec);
 
 	return size;
 }
 
+/* effectively this is also the bitmap size */
+static inline u32 ocfs2_local_alloc_cluster_count(struct ocfs2_local_alloc *la)
+{
+	u32 i, clusters;
+
+	clusters = 0;
+	for (i = 0; i < le16_to_cpu(la->la_rec_count); i++)
+		clusters +=  le32_to_cpu(la->la_recs[i].la_clusters);
+
+	return clusters;
+}
+
 static inline int ocfs2_group_bitmap_size(struct super_block *sb,
 					  int suballocator,
 					  u32 feature_incompat)
@@ -1528,11 +1550,25 @@ static inline int ocfs2_local_alloc_size(int blocksize)
 	int size;
 
 	size = blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_lab.la_bitmap);
+		offsetof(struct ocfs2_dinode, id2.i_lab.la_recs);
+	size -= sizeof(struct ocfs2_local_alloc_rec);
 
 	return size;
 }
 
+/* effectively this is also the bitmap size */
+static inline uint32_t
+ocfs2_local_alloc_cluster_count(struct ocfs2_local_alloc *la)
+{
+	uint32_t i, clusters;
+
+	clusters = 0;
+	for (i = 0; i < le16_to_cpu(la->la_rec_count); i++)
+		clusters +=  le32_to_cpu(la->la_recs[i].la_clusters);
+
+	return clusters;
+}
+
 static inline int ocfs2_group_bitmap_size(int blocksize,
 					  int suballocator,
 					  uint32_t feature_incompat)
-- 
1.5.4.3
