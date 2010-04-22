From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:29 +0800
Subject: [Ocfs2-devel] [PATCH 15/17] ocfs2: Free block to the right block
	group.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-15-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In case the block we are going to free is allocated from
a discontiguous block group, we have to use suballoc_loc
to be the right group.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |   18 ++++++++++++------
 fs/ocfs2/alloc.h        |    2 +-
 fs/ocfs2/dir.c          |    5 ++++-
 fs/ocfs2/refcounttree.c |    6 +++++-
 fs/ocfs2/suballoc.c     |    2 ++
 fs/ocfs2/xattr.c        |    5 ++++-
 6 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index dc029e0..008a11f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6215,6 +6215,7 @@ int ocfs2_truncate_log_init(struct ocfs2_super *osb)
  */
 struct ocfs2_cached_block_free {
 	struct ocfs2_cached_block_free		*free_next;
+	u64					free_bg;
 	u64					free_blk;
 	unsigned int				free_bit;
 };
@@ -6261,8 +6262,11 @@ static int ocfs2_free_cached_blocks(struct ocfs2_super *osb,
 	}
 
 	while (head) {
-		bg_blkno = ocfs2_which_suballoc_group(head->free_blk,
-						      head->free_bit);
+		if (head->free_bg)
+			bg_blkno = head->free_bg;
+		else
+			bg_blkno = ocfs2_which_suballoc_group(head->free_blk,
+							      head->free_bit);
 		mlog(0, "Free bit: (bit %u, blkno %llu)\n",
 		     head->free_bit, (unsigned long long)head->free_blk);
 
@@ -6310,7 +6314,7 @@ int ocfs2_cache_cluster_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
 	int ret = 0;
 	struct ocfs2_cached_block_free *item;
 
-	item = kmalloc(sizeof(*item), GFP_NOFS);
+	item = kzalloc(sizeof(*item), GFP_NOFS);
 	if (item == NULL) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -6450,8 +6454,8 @@ ocfs2_find_per_slot_free_list(int type,
 }
 
 int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
-			      int type, int slot, u64 blkno,
-			      unsigned int bit)
+			      int type, int slot, u64 suballoc,
+			      u64 blkno, unsigned int bit)
 {
 	int ret;
 	struct ocfs2_per_slot_free_list *fl;
@@ -6464,7 +6468,7 @@ int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
 		goto out;
 	}
 
-	item = kmalloc(sizeof(*item), GFP_NOFS);
+	item = kzalloc(sizeof(*item), GFP_NOFS);
 	if (item == NULL) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -6474,6 +6478,7 @@ int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
 	mlog(0, "Insert: (type %d, slot %u, bit %u, blk %llu)\n",
 	     type, slot, bit, (unsigned long long)blkno);
 
+	item->free_bg = suballoc;
 	item->free_blk = blkno;
 	item->free_bit = bit;
 	item->free_next = fl->f_first;
@@ -6490,6 +6495,7 @@ static int ocfs2_cache_extent_block_free(struct ocfs2_cached_dealloc_ctxt *ctxt,
 {
 	return ocfs2_cache_block_dealloc(ctxt, EXTENT_ALLOC_SYSTEM_INODE,
 					 le16_to_cpu(eb->h_suballoc_slot),
+					 le64_to_cpu(eb->h_suballoc_loc),
 					 le64_to_cpu(eb->h_blkno),
 					 le16_to_cpu(eb->h_suballoc_bit));
 }
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 1db4359..fc28d64 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -209,7 +209,7 @@ static inline void ocfs2_init_dealloc_ctxt(struct ocfs2_cached_dealloc_ctxt *c)
 int ocfs2_cache_cluster_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
 				u64 blkno, unsigned int bit);
 int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
-			      int type, int slot, u64 blkno,
+			      int type, int slot, u64 suballoc, u64 blkno,
 			      unsigned int bit);
 static inline int ocfs2_dealloc_has_cluster(struct ocfs2_cached_dealloc_ctxt *c)
 {
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 341bb8f..3fea52d 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -4466,7 +4466,10 @@ static int ocfs2_dx_dir_remove_index(struct inode *dir,
 
 	blk = le64_to_cpu(dx_root->dr_blkno);
 	bit = le16_to_cpu(dx_root->dr_suballoc_bit);
-	bg_blkno = ocfs2_which_suballoc_group(blk, bit);
+	if (dx_root->dr_suballoc_loc)
+		bg_blkno = le64_to_cpu(dx_root->dr_suballoc_loc);
+	else
+		bg_blkno = ocfs2_which_suballoc_group(blk, bit);
 	ret = ocfs2_free_suballoc_bits(handle, dx_alloc_inode, dx_alloc_bh,
 				       bit, bg_blkno, 1);
 	if (ret)
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 4825ce1..63dac01 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -792,7 +792,10 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 	if (le32_to_cpu(rb->rf_count) == 1) {
 		blk = le64_to_cpu(rb->rf_blkno);
 		bit = le16_to_cpu(rb->rf_suballoc_bit);
-		bg_blkno = ocfs2_which_suballoc_group(blk, bit);
+		if (rb->rf_suballoc_loc)
+			bg_blkno = le64_to_cpu(rb->rf_suballoc_loc);
+		else
+			bg_blkno = ocfs2_which_suballoc_group(blk, bit);
 
 		alloc_inode = ocfs2_get_system_file_inode(osb,
 					EXTENT_ALLOC_SYSTEM_INODE,
@@ -2108,6 +2111,7 @@ static int ocfs2_remove_refcount_extent(handle_t *handle,
 	 */
 	ret = ocfs2_cache_block_dealloc(dealloc, EXTENT_ALLOC_SYSTEM_INODE,
 					le16_to_cpu(rb->rf_suballoc_slot),
+					le64_to_cpu(rb->rf_suballoc_loc),
 					le64_to_cpu(rb->rf_blkno),
 					le16_to_cpu(rb->rf_suballoc_bit));
 	if (ret) {
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index bfeb6ac..a971ec6 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2342,6 +2342,8 @@ int ocfs2_free_dinode(handle_t *handle,
 	u16 bit = le16_to_cpu(di->i_suballoc_bit);
 	u64 bg_blkno = ocfs2_which_suballoc_group(blk, bit);
 
+	if (di->i_suballoc_loc)
+		bg_blkno = le64_to_cpu(di->i_suballoc_loc);
 	return ocfs2_free_suballoc_bits(handle, inode_alloc_inode,
 					inode_alloc_bh, bit, bg_blkno, 1);
 }
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0ac2a8a..ff8a8ea 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2466,7 +2466,10 @@ static int ocfs2_xattr_free_block(struct inode *inode,
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 	blk = le64_to_cpu(xb->xb_blkno);
 	bit = le16_to_cpu(xb->xb_suballoc_bit);
-	bg_blkno = ocfs2_which_suballoc_group(blk, bit);
+	if (xb->xb_suballoc_loc)
+		bg_blkno = le64_to_cpu(xb->xb_suballoc_loc);
+	else
+		bg_blkno = ocfs2_which_suballoc_group(blk, bit);
 
 	xb_alloc_inode = ocfs2_get_system_file_inode(osb,
 				EXTENT_ALLOC_SYSTEM_INODE,
-- 
1.5.5
