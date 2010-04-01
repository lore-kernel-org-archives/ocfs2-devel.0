From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  1 Apr 2010 10:59:01 +0800
Subject: [Ocfs2-devel] [PATCH 04/15] ocfs2: Add suballoc_loc to metadata
	blocks.
In-Reply-To: <4BB40AB4.8040205@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
Message-ID: <1270090752-18935-4-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

We need a suballoc_loc field on any suballocated block.  Define them.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 0508e4e..42641f8 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -515,7 +515,10 @@ struct ocfs2_extent_block
 					   block group */
 	__le32 h_fs_generation;		/* Must match super block */
 	__le64 h_blkno;			/* Offset on disk, in blocks */
-/*20*/	__le64 h_reserved3;
+/*20*/	__le64 h_suballoc_loc;		/* Suballocator block group this
+					   eb belongs to.  Only valid
+					   if allocated from a
+					   discontiguous block group */
 	__le64 h_next_leaf_blk;		/* Offset on disk, in blocks,
 					   of next leaf header pointing
 					   to data */
@@ -682,7 +685,11 @@ struct ocfs2_dinode {
 /*80*/	struct ocfs2_block_check i_check;	/* Error checking */
 /*88*/	__le64 i_dx_root;		/* Pointer to dir index root block */
 /*90*/	__le64 i_refcount_loc;
-	__le64 i_reserved2[4];
+	__le64 i_suballoc_loc;		/* Suballocator block group this
+					   inode belongs to.  Only valid
+					   if allocated from a
+					   discontiguous block group */
+/*A0*/	__le64 i_reserved2[3];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
@@ -817,7 +824,12 @@ struct ocfs2_dx_root_block {
 	__le32		dr_reserved2;
 	__le64		dr_free_blk;		/* Pointer to head of free
 						 * unindexed block list. */
-	__le64		dr_reserved3[15];
+	__le64		dr_suballoc_loc;	/* Suballocator block group
+						   this root belongs to.
+						   Only valid if allocated
+						   from a discontiguous
+						   block group */
+	__le64		dr_reserved3[14];
 	union {
 		struct ocfs2_extent_list dr_list; /* Keep this aligned to 128
 						   * bits for maximum space
@@ -937,7 +949,11 @@ struct ocfs2_refcount_block {
 /*40*/	__le32 rf_generation;		/* generation number. all be the same
 					 * for the same refcount tree. */
 	__le32 rf_reserved0;
-	__le64 rf_reserved1[7];
+	__le64 rf_suballoc_loc;		/* Suballocator block group this
+					   refcount block belongs to. Only
+					   valid if allocated from a
+					   discontiguous block group */
+/*50*/	__le64 rf_reserved1[6];
 /*80*/	union {
 		struct ocfs2_refcount_list rf_records;  /* List of refcount
 							  records */
@@ -1049,7 +1065,10 @@ struct ocfs2_xattr_block {
 					real xattr or a xattr tree. */
 	__le16	xb_reserved0;
 	__le32  xb_reserved1;
-	__le64	xb_reserved2;
+	__le64	xb_suballoc_loc;	/* Suballocator block group this
+					   xattr block belongs to. Only
+					   valid if allocated from a
+					   discontiguous block group */
 /*30*/	union {
 		struct ocfs2_xattr_header xb_header; /* xattr header if this
 							block contains xattr */
-- 
1.5.5
