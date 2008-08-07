From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu,  7 Aug 2008 15:11:13 +0800
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: reserve inline space for
	extended attribute
In-Reply-To: <489A94F4.90903@oracle.com>
References: <489A94F4.90903@oracle.com>
Message-ID: <1218093073-8585-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch reserve some space in inode block for extended attribute.
That space used to store extent list or inline data.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/alloc.c    |   22 ++++++++++++++++------
 fs/ocfs2/ocfs2.h    |    1 +
 fs/ocfs2/ocfs2_fs.h |   43 ++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/super.c    |    2 ++
 4 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index e380f26..294bede 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6467,20 +6467,29 @@ out:
 	return ret;
 }
 
-static void ocfs2_zero_dinode_id2(struct inode *inode, struct ocfs2_dinode *di)
+static void ocfs2_zero_dinode_id2_with_xattr(struct inode *inode,
+					     struct ocfs2_dinode *di)
 {
 	unsigned int blocksize = 1 << inode->i_sb->s_blocksize_bits;
+	unsigned int xattrsize = le16_to_cpu(di->i_xattr_inline_size);
 
-	memset(&di->id2, 0, blocksize - offsetof(struct ocfs2_dinode, id2));
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL)
+		memset(&di->id2, 0, blocksize -
+				    offsetof(struct ocfs2_dinode, id2) -
+				    xattrsize);
+	else
+		memset(&di->id2, 0, blocksize -
+				    offsetof(struct ocfs2_dinode, id2));
 }
 
 void ocfs2_dinode_new_extent_list(struct inode *inode,
 				  struct ocfs2_dinode *di)
 {
-	ocfs2_zero_dinode_id2(inode, di);
+	ocfs2_zero_dinode_id2_with_xattr(inode, di);
 	di->id2.i_list.l_tree_depth = 0;
 	di->id2.i_list.l_next_free_rec = 0;
-	di->id2.i_list.l_count = cpu_to_le16(ocfs2_extent_recs_per_inode(inode->i_sb));
+	di->id2.i_list.l_count = cpu_to_le16(
+		ocfs2_extent_recs_per_inode_with_xattr(inode->i_sb, di));
 }
 
 void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di)
@@ -6497,9 +6506,10 @@ void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di)
 	 * We clear the entire i_data structure here so that all
 	 * fields can be properly initialized.
 	 */
-	ocfs2_zero_dinode_id2(inode, di);
+	ocfs2_zero_dinode_id2_with_xattr(inode, di);
 
-	idata->id_count = cpu_to_le16(ocfs2_max_inline_data(inode->i_sb));
+	idata->id_count = cpu_to_le16(
+			ocfs2_max_inline_data_with_xattr(inode->i_sb, di));
 }
 
 int ocfs2_convert_inline_data_to_extents(struct inode *inode,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 3169237..32631a5 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -227,6 +227,7 @@ struct ocfs2_super
 	int s_sectsize_bits;
 	int s_clustersize;
 	int s_clustersize_bits;
+	unsigned int s_xattr_inline_size;
 
 	atomic_t vol_state;
 	struct mutex recovery_lock;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index af91f9d..13bf3e5 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -300,6 +300,9 @@ struct ocfs2_new_group_input {
  */
 #define OCFS2_DEFAULT_LOCAL_ALLOC_SIZE	8
 
+/* Inline extended attribute size (in bytes) */
+#define OCFS2_MIN_XATTR_INLINE_SIZE     256
+
 struct ocfs2_system_inode_info {
 	char	*si_name;
 	int	si_iflags;
@@ -622,7 +625,8 @@ struct ocfs2_dinode {
 					   belongs to */
 	__le16 i_suballoc_bit;		/* Bit offset in suballocator
 					   block group */
-/*10*/	__le32 i_reserved0;
+/*10*/	__le16 i_reserved0;
+	__le16 i_xattr_inline_size;
 	__le32 i_clusters;		/* Cluster count */
 	__le32 i_uid;			/* Owner UID */
 	__le32 i_gid;			/* Owning GID */
@@ -641,11 +645,12 @@ struct ocfs2_dinode {
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
@@ -843,6 +848,20 @@ static inline int ocfs2_max_inline_data(struct super_block *sb)
 		offsetof(struct ocfs2_dinode, id2.i_data.id_data);
 }
 
+static inline int ocfs2_max_inline_data_with_xattr(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	unsigned int xattrsize = le16_to_cpu(di->i_xattr_inline_size);
+
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL)
+		return sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_data.id_data) -
+			xattrsize;
+	else
+		return sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_data.id_data);
+}
+
 static inline int ocfs2_extent_recs_per_inode(struct super_block *sb)
 {
 	int size;
@@ -853,6 +872,24 @@ static inline int ocfs2_extent_recs_per_inode(struct super_block *sb)
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 
+static inline int ocfs2_extent_recs_per_inode_with_xattr(
+						struct super_block *sb,
+						struct ocfs2_dinode *di)
+{
+	int size;
+	unsigned int xattrsize = le16_to_cpu(di->i_xattr_inline_size);
+
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL)
+		size = sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_list.l_recs) -
+			xattrsize;
+	else
+		size = sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_list.l_recs);
+
+	return size / sizeof(struct ocfs2_extent_rec);
+}
+
 static inline int ocfs2_chain_recs_per_inode(struct super_block *sb)
 {
 	int size;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index df63ba2..c0a1cdf 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1421,6 +1421,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	osb->slot_num = OCFS2_INVALID_SLOT;
 
+	osb->s_xattr_inline_size = OCFS2_MIN_XATTR_INLINE_SIZE;
+
 	osb->local_alloc_state = OCFS2_LA_UNUSED;
 	osb->local_alloc_bh = NULL;
 
-- 
1.5.4.4
