From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Sep 2008 15:01:17 -0700
Subject: [Ocfs2-devel] [PATCH 36/39] ocfs2: Limit inode allocation to 32bits.
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Message-ID: <1222293680-15451-37-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

ocfs2 inode numbers are block numbers.  For any filesystem with less
than 2^32 blocks, this is not a problem.  However, when ocfs2 starts
using JDB2, it will be able to support filesystems with more than 2^32
blocks.  This would result in inode numbers higher than 2^32.

The problem is that stat(2) can't handle those numbers on 32bit
machines.  The simple solution is to have ocfs2 allocate all inodes
below that boundary.

The suballoc code is changed to honor an optional block limit.  Only the
inode suballocator sets that limit - all other allocations stay unlimited.

The biggest trick is to grow the inode suballocator beneath that limit.
There's no point in allocating block groups that are above the limit,
then rejecting their elements later on.  We want to prevent the inode
allocator from ever having block groups above the limit.  This involves
a little gyration with the local alloc code.  If the local alloc window
is above the limit, it signals the caller to try the global bitmap but
does not disable the local alloc file (which can be used for other
allocations).

[ Minor cleanup - removed an ML_NOTICE comment. --Mark ]

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/localalloc.c |   55 ++++++++++++++++++++++++++++++++
 fs/ocfs2/suballoc.c   |   83 ++++++++++++++++++++++++++++++++++++++++---------
 fs/ocfs2/suballoc.h   |   11 ++++--
 3 files changed, 130 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index b889f10..02227c3 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -570,6 +570,46 @@ out:
 	return status;
 }
 
+/* Check to see if the local alloc window is within ac->ac_max_block */
+static int ocfs2_local_alloc_in_range(struct inode *inode,
+				      struct ocfs2_alloc_context *ac,
+				      u32 bits_wanted)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_dinode *alloc;
+	struct ocfs2_local_alloc *la;
+	int start;
+	u64 block_off;
+
+	if (!ac->ac_max_block)
+		return 1;
+
+	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
+	la = OCFS2_LOCAL_ALLOC(alloc);
+
+	start = ocfs2_local_alloc_find_clear_bits(osb, alloc, bits_wanted);
+	if (start == -1) {
+		mlog_errno(-ENOSPC);
+		return 0;
+	}
+
+	/*
+	 * Converting (bm_off + start + bits_wanted) to blocks gives us
+	 * the blkno just past our actual allocation.  This is perfect
+	 * to compare with ac_max_block.
+	 */
+	block_off = ocfs2_clusters_to_blocks(inode->i_sb,
+					     le32_to_cpu(la->la_bm_off) +
+					     start + bits_wanted);
+	mlog(0, "Checking %llu against %llu\n",
+	     (unsigned long long)block_off,
+	     (unsigned long long)ac->ac_max_block);
+	if (block_off > ac->ac_max_block)
+		return 0;
+
+	return 1;
+}
+
 /*
  * make sure we've got at least bits_wanted contiguous bits in the
  * local alloc. You lose them when you drop i_mutex.
@@ -658,6 +698,21 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 			goto bail;
 	}
 
+	if (ac->ac_max_block)
+		mlog(0, "Calling in_range for max block %llu\n",
+		     (unsigned long long)ac->ac_max_block);
+
+	if (!ocfs2_local_alloc_in_range(local_alloc_inode, ac,
+					bits_wanted)) {
+		/*
+		 * The window is outside ac->ac_max_block.
+		 * This errno tells the caller to keep localalloc enabled
+		 * but to get the allocation from the main bitmap.
+		 */
+		status = -EFBIG;
+		goto bail;
+	}
+
 	ac->ac_inode = local_alloc_inode;
 	/* We should never use localalloc from another slot */
 	ac->ac_alloc_slot = osb->slot_num;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8d3947e..213bdca 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -62,15 +62,18 @@ static int ocfs2_block_group_fill(handle_t *handle,
 				  struct ocfs2_chain_list *cl);
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
-				   struct buffer_head *bh);
+				   struct buffer_head *bh,
+				   u64 max_block);
 
 static int ocfs2_cluster_group_search(struct inode *inode,
 				      struct buffer_head *group_bh,
 				      u32 bits_wanted, u32 min_bits,
+				      u64 max_block,
 				      u16 *bit_off, u16 *bits_found);
 static int ocfs2_block_group_search(struct inode *inode,
 				    struct buffer_head *group_bh,
 				    u32 bits_wanted, u32 min_bits,
+				    u64 max_block,
 				    u16 *bit_off, u16 *bits_found);
 static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
 				     struct ocfs2_alloc_context *ac,
@@ -110,6 +113,9 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
 						u64 data_blkno,
 						u64 *bg_blkno,
 						u16 *bg_bit_off);
+static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
+					     u32 bits_wanted, u64 max_block,
+					     struct ocfs2_alloc_context **ac);
 
 void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
 {
@@ -276,7 +282,8 @@ static inline u16 ocfs2_find_smallest_chain(struct ocfs2_chain_list *cl)
  */
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
-				   struct buffer_head *bh)
+				   struct buffer_head *bh,
+				   u64 max_block)
 {
 	int status, credits;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bh->b_data;
@@ -294,9 +301,9 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	mlog_entry_void();
 
 	cl = &fe->id2.i_chain;
-	status = ocfs2_reserve_clusters(osb,
-					le16_to_cpu(cl->cl_cpg),
-					&ac);
+	status = ocfs2_reserve_clusters_with_limit(osb,
+						   le16_to_cpu(cl->cl_cpg),
+						   max_block, &ac);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -469,7 +476,8 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 			goto bail;
 		}
 
-		status = ocfs2_block_group_alloc(osb, alloc_inode, bh);
+		status = ocfs2_block_group_alloc(osb, alloc_inode, bh,
+						 ac->ac_max_block);
 		if (status < 0) {
 			if (status != -ENOSPC)
 				mlog_errno(status);
@@ -591,6 +599,13 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 	(*ac)->ac_group_search = ocfs2_block_group_search;
 
 	/*
+	 * stat(2) can't handle i_ino > 32bits, so we tell the
+	 * lower levels not to allocate us a block group past that
+	 * limit.
+	 */
+	(*ac)->ac_max_block = (u32)~0U;
+
+	/*
 	 * slot is set when we successfully steal inode from other nodes.
 	 * It is reset in 3 places:
 	 * 1. when we flush the truncate log
@@ -670,9 +685,9 @@ bail:
 /* Callers don't need to care which bitmap (local alloc or main) to
  * use so we figure it out for them, but unfortunately this clutters
  * things a bit. */
-int ocfs2_reserve_clusters(struct ocfs2_super *osb,
-			   u32 bits_wanted,
-			   struct ocfs2_alloc_context **ac)
+static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
+					     u32 bits_wanted, u64 max_block,
+					     struct ocfs2_alloc_context **ac)
 {
 	int status;
 
@@ -686,13 +701,18 @@ int ocfs2_reserve_clusters(struct ocfs2_super *osb,
 	}
 
 	(*ac)->ac_bits_wanted = bits_wanted;
+	(*ac)->ac_max_block = max_block;
 
 	status = -ENOSPC;
 	if (ocfs2_alloc_should_use_local(osb, bits_wanted)) {
 		status = ocfs2_reserve_local_alloc_bits(osb,
 							bits_wanted,
 							*ac);
-		if ((status < 0) && (status != -ENOSPC)) {
+		if (status == -EFBIG) {
+			/* The local alloc window is outside ac_max_block.
+			 * use the main bitmap. */
+			status = -ENOSPC;
+		} else if ((status < 0) && (status != -ENOSPC)) {
 			mlog_errno(status);
 			goto bail;
 		}
@@ -718,6 +738,13 @@ bail:
 	return status;
 }
 
+int ocfs2_reserve_clusters(struct ocfs2_super *osb,
+			   u32 bits_wanted,
+			   struct ocfs2_alloc_context **ac)
+{
+	return ocfs2_reserve_clusters_with_limit(osb, bits_wanted, 0, ac);
+}
+
 /*
  * More or less lifted from ext3. I'll leave their description below:
  *
@@ -1000,10 +1027,12 @@ static inline int ocfs2_block_group_reasonably_empty(struct ocfs2_group_desc *bg
 static int ocfs2_cluster_group_search(struct inode *inode,
 				      struct buffer_head *group_bh,
 				      u32 bits_wanted, u32 min_bits,
+				      u64 max_block,
 				      u16 *bit_off, u16 *bits_found)
 {
 	int search = -ENOSPC;
 	int ret;
+	u64 blkoff;
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *) group_bh->b_data;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	u16 tmp_off, tmp_found;
@@ -1038,6 +1067,17 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 		if (ret)
 			return ret;
 
+		if (max_block) {
+			blkoff = ocfs2_clusters_to_blocks(inode->i_sb,
+							  gd_cluster_off +
+							  tmp_off + tmp_found);
+			mlog(0, "Checking %llu against %llu\n",
+			     (unsigned long long)blkoff,
+			     (unsigned long long)max_block);
+			if (blkoff > max_block)
+				return -ENOSPC;
+		}
+
 		/* ocfs2_block_group_find_clear_bits() might
 		 * return success, but we still want to return
 		 * -ENOSPC unless it found the minimum number
@@ -1061,19 +1101,31 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 static int ocfs2_block_group_search(struct inode *inode,
 				    struct buffer_head *group_bh,
 				    u32 bits_wanted, u32 min_bits,
+				    u64 max_block,
 				    u16 *bit_off, u16 *bits_found)
 {
 	int ret = -ENOSPC;
+	u64 blkoff;
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) group_bh->b_data;
 
 	BUG_ON(min_bits != 1);
 	BUG_ON(ocfs2_is_cluster_bitmap(inode));
 
-	if (bg->bg_free_bits_count)
+	if (bg->bg_free_bits_count) {
 		ret = ocfs2_block_group_find_clear_bits(OCFS2_SB(inode->i_sb),
 							group_bh, bits_wanted,
 							le16_to_cpu(bg->bg_bits),
 							bit_off, bits_found);
+		if (!ret && max_block) {
+			blkoff = le64_to_cpu(bg->bg_blkno) + *bit_off +
+				*bits_found;
+			mlog(0, "Checking %llu against %llu\n",
+			     (unsigned long long)blkoff,
+			     (unsigned long long)max_block);
+			if (blkoff > max_block)
+				ret = -ENOSPC;
+		}
+	}
 
 	return ret;
 }
@@ -1138,7 +1190,7 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	}
 
 	ret = ac->ac_group_search(alloc_inode, group_bh, bits_wanted, min_bits,
-				  bit_off, &found);
+				  ac->ac_max_block, bit_off, &found);
 	if (ret < 0) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
@@ -1210,11 +1262,12 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	status = -ENOSPC;
 	/* for now, the chain search is a bit simplistic. We just use
 	 * the 1st group with any empty bits. */
-	while ((status = ac->ac_group_search(alloc_inode, group_bh, bits_wanted,
-					     min_bits, bit_off, &tmp_bits)) == -ENOSPC) {
+	while ((status = ac->ac_group_search(alloc_inode, group_bh,
+					     bits_wanted, min_bits,
+					     ac->ac_max_block, bit_off,
+					     &tmp_bits)) == -ENOSPC) {
 		if (!bg->bg_next_group)
 			break;
-
 		if (prev_group_bh) {
 			brelse(prev_group_bh);
 			prev_group_bh = NULL;
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index dd09636..4df159d 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -28,10 +28,11 @@
 
 typedef int (group_search_t)(struct inode *,
 			     struct buffer_head *,
-			     u32,
-			     u32,
-			     u16 *,
-			     u16 *);
+			     u32,			/* bits_wanted */
+			     u32,			/* min_bits */
+			     u64,			/* max_block */
+			     u16 *,			/* *bit_off */
+			     u16 *);			/* *bits_found */
 
 struct ocfs2_alloc_context {
 	struct inode *ac_inode;    /* which bitmap are we allocating from? */
@@ -51,6 +52,8 @@ struct ocfs2_alloc_context {
 	group_search_t *ac_group_search;
 
 	u64    ac_last_group;
+	u64    ac_max_block;  /* Highest block number to allocate. 0 is
+				 is the same as ~0 - unlimited */
 };
 
 void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac);
-- 
1.5.4.5
