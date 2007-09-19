From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:23 2007
Subject: [Ocfs2-devel] [PATCH 11/15] ocfs2: Structure updates for inline data
Message-ID: <200709192012.l8JKCHOK012212@agmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add the disk, network and memory structures needed to support data in inode.

Struct ocfs2_inline_data is defined and embedded in ocfs2_dinode for storing
inline data.

A new inode field, i_dyn_features, is added to facilitate tracking of
dynamic inode state. Since it will be used often, we want to mirror it on
ocfs2_inode_info, and transfer it via the meta data lvb.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c  |    2 ++
 fs/ocfs2/dlmglue.h  |    4 ++--
 fs/ocfs2/inode.c    |    3 +++
 fs/ocfs2/inode.h    |    1 +
 fs/ocfs2/ocfs2.h    |    7 +++++++
 fs/ocfs2/ocfs2_fs.h |   44 ++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index f71250e..41c76ff 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1482,6 +1482,7 @@ static void __ocfs2_stuff_meta_lvb(struct inode *inode)
 	lvb->lvb_imtime_packed =
 		cpu_to_be64(ocfs2_pack_timespec(&inode->i_mtime));
 	lvb->lvb_iattr    = cpu_to_be32(oi->ip_attr);
+	lvb->lvb_idynfeatures = cpu_to_be16(oi->ip_dyn_features);
 	lvb->lvb_igeneration = cpu_to_be32(inode->i_generation);
 
 out:
@@ -1515,6 +1516,7 @@ static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 	i_size_write(inode, be64_to_cpu(lvb->lvb_isize));
 
 	oi->ip_attr = be32_to_cpu(lvb->lvb_iattr);
+	oi->ip_dyn_features = be16_to_cpu(lvb->lvb_idynfeatures);
 	ocfs2_set_inode_flags(inode);
 
 	/* fast-symlinks are a special case */
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 492bad3..87a785e 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -29,12 +29,12 @@
 
 #include "dcache.h"
 
-#define OCFS2_LVB_VERSION 4
+#define OCFS2_LVB_VERSION 5
 
 struct ocfs2_meta_lvb {
 	__u8         lvb_version;
 	__u8         lvb_reserved0;
-	__be16       lvb_reserved1;
+	__be16       lvb_idynfeatures;
 	__be32       lvb_iclusters;
 	__be32       lvb_iuid;
 	__be32       lvb_igid;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index c53a676..c8923ba 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -241,6 +241,7 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
 	OCFS2_I(inode)->ip_attr = le32_to_cpu(fe->i_attr);
+	OCFS2_I(inode)->ip_dyn_features = le16_to_cpu(fe->i_dyn_features);
 
 	inode->i_version = 1;
 	inode->i_generation = le32_to_cpu(fe->i_generation);
@@ -1220,6 +1221,7 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 	fe->i_clusters = cpu_to_le32(OCFS2_I(inode)->ip_clusters);
 	ocfs2_get_inode_flags(OCFS2_I(inode));
 	fe->i_attr = cpu_to_le32(OCFS2_I(inode)->ip_attr);
+	fe->i_dyn_features = cpu_to_le16(OCFS2_I(inode)->ip_dyn_features);
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 
 	fe->i_size = cpu_to_le64(i_size_read(inode));
@@ -1257,6 +1259,7 @@ void ocfs2_refresh_inode(struct inode *inode,
 
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
 	OCFS2_I(inode)->ip_attr = le32_to_cpu(fe->i_attr);
+	OCFS2_I(inode)->ip_dyn_features = le16_to_cpu(fe->i_dyn_features);
 	ocfs2_set_inode_flags(inode);
 	i_size_write(inode, le64_to_cpu(fe->i_size));
 	inode->i_nlink = le16_to_cpu(fe->i_links_count);
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index a41d081..70e881c 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -51,6 +51,7 @@ struct ocfs2_inode_info
 
 	u32				ip_flags; /* see below */
 	u32				ip_attr; /* inode attributes */
+	u16				ip_dyn_features;
 
 	/* protected by recovery_lock. */
 	struct inode			*ip_next_orphan;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 5830785..60a23e1 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -319,6 +319,13 @@ static inline int ocfs2_writes_unwritten_extents(struct ocfs2_super *osb)
 	return 0;
 }
 
+static inline int ocfs2_supports_inline_data(struct ocfs2_super *osb)
+{
+	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_INLINE_DATA)
+		return 1;
+	return 0;
+}
+
 /* set / clear functions because cluster events can make these happen
  * in parallel so we want the transitions to be atomic. this also
  * means that any future flags osb_flags must be protected by spinlock
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 82f8a75..da45ff5 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -87,7 +87,8 @@
 
 #define OCFS2_FEATURE_COMPAT_SUPP	OCFS2_FEATURE_COMPAT_BACKUP_SB
 #define OCFS2_FEATURE_INCOMPAT_SUPP	(OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT \
-					 | OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC)
+					 | OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC \
+					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
 
 /*
@@ -110,6 +111,9 @@
 /* Support for sparse allocation in b-trees */
 #define OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC	0x0010
 
+/* Support for data packed into inode blocks */
+#define OCFS2_FEATURE_INCOMPAT_INLINE_DATA	0x0040
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -146,6 +150,17 @@
 #define OCFS2_CHAIN_FL		(0x00000400)	/* Chain allocator */
 #define OCFS2_DEALLOC_FL	(0x00000800)	/* Truncate log */
 
+/*
+ * Flags on ocfs2_dinode.i_dyn_features
+ *
+ * These can change much more often than i_flags. When adding flags,
+ * keep in mind that i_dyn_features is only 16 bits wide.
+ */
+#define OCFS2_INLINE_DATA_FL	(0x0001)	/* Data stored in inode block */
+#define OCFS2_HAS_XATTR_FL	(0x0002)
+#define OCFS2_INLINE_XATTR_FL	(0x0004)
+#define OCFS2_INDEXED_DIR_FL	(0x0008)
+
 /* Inode attributes, keep in sync with EXT2 */
 #define OCFS2_SECRM_FL		(0x00000001)	/* Secure deletion */
 #define OCFS2_UNRM_FL		(0x00000002)	/* Undelete */
@@ -471,6 +486,19 @@ struct ocfs2_local_alloc
 };
 
 /*
+ * Data-in-inode header. This is only used if i_flags has
+ * OCFS2_INLINE_DATA_FL set.
+ */
+struct ocfs2_inline_data
+{
+/*00*/	__le16	id_count;	/* Number of bytes that can be used
+				 * for data, starting at id_data */
+	__le16	id_reserved0;
+	__le32	id_reserved1;
+	__u8	id_data[0];	/* Start of user data */
+};
+
+/*
  * On disk inode for OCFS2
  */
 struct ocfs2_dinode {
@@ -502,7 +530,7 @@ struct ocfs2_dinode {
 	__le32 i_attr;
 	__le16 i_orphaned_slot;		/* Only valid when OCFS2_ORPHANED_FL
 					   was set in i_flags */
-	__le16 i_reserved1;
+	__le16 i_dyn_features;
 /*70*/	__le64 i_reserved2[8];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
@@ -528,6 +556,7 @@ struct ocfs2_dinode {
 		struct ocfs2_chain_list		i_chain;
 		struct ocfs2_extent_list	i_list;
 		struct ocfs2_truncate_log	i_dealloc;
+		struct ocfs2_inline_data	i_data;
 		__u8               		i_symlink[0];
 	} id2;
 /* Actual on-disk size is one block */
@@ -577,6 +606,12 @@ static inline int ocfs2_fast_symlink_chars(struct super_block *sb)
 		 offsetof(struct ocfs2_dinode, id2.i_symlink);
 }
 
+static inline int ocfs2_max_inline_data(struct super_block *sb)
+{
+	return sb->s_blocksize -
+		offsetof(struct ocfs2_dinode, id2.i_data.id_data);
+}
+
 static inline int ocfs2_extent_recs_per_inode(struct super_block *sb)
 {
 	int size;
@@ -656,6 +691,11 @@ static inline int ocfs2_fast_symlink_chars(int blocksize)
 	return blocksize - offsetof(struct ocfs2_dinode, id2.i_symlink);
 }
 
+static inline int ocfs2_max_inline_data(int blocksize)
+{
+	return blocksize - offsetof(struct ocfs2_dinode, id2.i_data.id_data);
+}
+
 static inline int ocfs2_extent_recs_per_inode(int blocksize)
 {
 	int size;
-- 
1.5.0.6
