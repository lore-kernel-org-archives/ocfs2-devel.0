From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Jun 2008 15:01:10 +0800
Subject: [Ocfs2-devel] [PATCH 05/15] Add xattr header in ocfs2.v2
In-Reply-To: <48648B3E.6050808@oracle.com>
Message-ID: <20080627070110.GA20347@tma-pc2.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Modification from V1 to V2:
Add EA disk layout to ocfs2_fs.h.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 52c4266..6bbeef4 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -64,6 +64,7 @@
 #define OCFS2_INODE_SIGNATURE		"INODE01"
 #define OCFS2_EXTENT_BLOCK_SIGNATURE	"EXBLK01"
 #define OCFS2_GROUP_DESC_SIGNATURE      "GROUP01"
+#define OCFS2_XATTR_BLOCK_SIGNATURE	"XATTR01"
 
 /* Compatibility flags */
 #define OCFS2_HAS_COMPAT_FEATURE(sb,mask)			\
@@ -712,6 +713,60 @@ struct ocfs2_group_desc
 /*40*/	__u8    bg_bitmap[0];
 };
 
+/*
+ * On disk extended attribute structure for OCFS2
+ * Include ocfs2_xattr_entry, ocfs2_xattr_header, ocfs2_xattr_value_root
+ * ocfs2_xattr_tree_root and ocfs2_xattr_block.
+ */
+struct ocfs2_xattr_entry {
+	__le32	xe_name_hash;
+	__le16	xe_name_offset;
+	__u8	xe_name_len;
+	__u8	xe_type : 7;
+	__u8	xe_local : 1;
+	__le64	xe_value_size;
+};
+
+struct ocfs2_xattr_header {
+	__le16	xh_count;
+	__le16	xh_reserved1;
+	__le32	xh_csum;
+	__le64  xh_reserved2;
+	struct ocfs2_xattr_entry	xh_entries[0];
+};
+
+struct ocfs2_xattr_value_root {
+/*00*/	__le32	xr_clusters;
+	__le32	xr_reserved0;
+	__le64	xr_last_eb_blk;
+/*10*/	struct ocfs2_extent_list	xr_list;
+};
+
+struct ocfs2_xattr_tree_root {
+/*00*/	__le32	xt_clusters;
+	__le32	xt_reserved0;
+	__le64	xt_last_eb_blk;
+/*10*/	struct ocfs2_extent_list	xt_list;
+};
+
+#define OCFS2_XATTR_INDEXED 0x1
+
+struct ocfs2_xattr_block {
+/*00*/	__u8	xb_signature[8];
+	__le16	xb_suballoc_slot;
+	__le16	xb_suballoc_bit;
+	__le32	xb_fs_generation;
+/*10*/	__le32	xb_csum;
+	__le16	xb_flags;
+	__le16	xb_reserved0;
+	__le64	xb_blkno;
+/*20*/	__le64	xb_reserved1[2];
+/*30*/	union {
+		struct ocfs2_xattr_header	xb_header;
+		struct ocfs2_xattr_tree_root	xb_root;
+	} xb_attrs;
+};
+
 #ifdef __KERNEL__
 static inline int ocfs2_fast_symlink_chars(struct super_block *sb)
 {
-- 
1.5.4.GIT
