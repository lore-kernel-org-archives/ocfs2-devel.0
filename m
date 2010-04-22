From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:27 +0800
Subject: [Ocfs2-devel] [PATCH 13/17] ocfs2: ocfs2_group_bitmap_size has to
	handle old volume.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-13-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_group_bitmap_size has to handle the case when the
volume don't have discontiguous block group support. So
pass the feature_incompat in and check it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/localalloc.c |    2 +-
 fs/ocfs2/ocfs2_fs.h   |   37 +++++++++++++++++++++++++------------
 fs/ocfs2/resize.c     |    6 ++++--
 fs/ocfs2/suballoc.c   |    3 ++-
 fs/ocfs2/super.c      |    3 ++-
 5 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 4aa83df..6b15b24 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -122,7 +122,7 @@ unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb)
 	struct super_block *sb = osb->sb;
 
 	gd_mb = ocfs2_clusters_to_megabytes(osb->sb,
-					    8 * ocfs2_group_bitmap_size(sb, 0));
+		8 * ocfs2_group_bitmap_size(sb, 0, osb->s_feature_incompat));
 
 	/*
 	 * This takes care of files systems with very small group
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index a17bce5..67bb8a7 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -1338,15 +1338,21 @@ static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
 }
 
 static inline int ocfs2_group_bitmap_size(struct super_block *sb,
-					  int suballocator)
+					  int suballocator,
+					  u32 feature_incompat)
 {
-	int size;
+	int size = sb->s_blocksize -
+		offsetof(struct ocfs2_group_desc, bg_bitmap);
 
-	if (suballocator)
+	/*
+	 * The cluster allocator uses the entire block.  Suballocators have
+	 * never used more than OCFS2_MAX_BG_BITMAP_SIZE.  Unfortunately, older
+	 * code expects bg_size set to the maximum.  Thus we must keep
+	 * bg_size as-is unless discontig_bg is enabled.
+	 */
+	if (suballocator &&
+	    (feature_incompat & OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG))
 		size = OCFS2_MAX_BG_BITMAP_SIZE;
-	else
-		size = sb->s_blocksize -
-			offsetof(struct ocfs2_group_desc, bg_bitmap);
 
 	return size;
 }
@@ -1479,15 +1485,22 @@ static inline int ocfs2_local_alloc_size(int blocksize)
 	return size;
 }
 
-static inline int ocfs2_group_bitmap_size(int blocksize, int suballocator)
+static inline int ocfs2_group_bitmap_size(int blocksize,
+					  int suballocator,
+					  uint32_t feature_incompat)
 {
-	int size;
+	int size = sb->s_blocksize -
+		offsetof(struct ocfs2_group_desc, bg_bitmap);
 
-	if (suballocator)
+	/*
+	 * The cluster allocator uses the entire block.  Suballocators have
+	 * never used more than OCFS2_MAX_BG_BITMAP_SIZE.  Unfortunately, older
+	 * code expects bg_size set to the maximum.  Thus we must keep
+	 * bg_size as-is unless discontig_bg is enabled.
+	 */
+	if (suballocator &&
+	    (feature_incompat & OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG))
 		size = OCFS2_MAX_BG_BITMAP_SIZE;
-	else
-		size = blocksize -
-			offsetof(struct ocfs2_group_desc, bg_bitmap);
 
 	return size;
 }
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 5bbfc12..dacd553 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -315,7 +315,8 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
-				 ocfs2_group_bitmap_size(osb->sb, 0) * 8) {
+		ocfs2_group_bitmap_size(osb->sb, 0,
+					osb->s_feature_incompat) * 8) {
 		mlog(ML_ERROR, "The disk is too old and small. "
 		     "Force to do offline resize.");
 		ret = -EINVAL;
@@ -496,7 +497,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
-				 ocfs2_group_bitmap_size(osb->sb, 0) * 8) {
+		ocfs2_group_bitmap_size(osb->sb, 0,
+					osb->s_feature_incompat) * 8) {
 		mlog(ML_ERROR, "The disk is too old and small."
 		     " Force to do offline resize.");
 		ret = -EINVAL;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index ce92967..bfeb6ac 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -395,7 +395,8 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	memset(bg, 0, sb->s_blocksize);
 	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
 	bg->bg_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
-	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1));
+	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1,
+						osb->s_feature_incompat));
 	bg->bg_chain = cpu_to_le16(my_chain);
 	bg->bg_next_group = cl->cl_recs[my_chain].c_blkno;
 	bg->bg_parent_dinode = cpu_to_le64(OCFS2_I(alloc_inode)->ip_blkno);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 9bbed28..fdea6ba 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2277,7 +2277,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->osb_clusters_at_boot = OCFS2_I(inode)->ip_clusters;
 	iput(inode);
 
-	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb, 0) * 8;
+	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb, 0,
+				 osb->s_feature_incompat) * 8;
 
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
-- 
1.5.5
