From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:17 +0800
Subject: [Ocfs2-devel] [PATCH 03/17] ocfs2: Pass suballocation results back
	via a structure.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-3-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

We're going to be adding more info to a suballocator allocation.  Rather
than growing every function in the chain, let's pass a result structure
around.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/suballoc.c |  165 +++++++++++++++++++++-----------------------------
 fs/ocfs2/suballoc.h |    5 +-
 2 files changed, 72 insertions(+), 98 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 9f985c5..bc1d6b7 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -53,6 +53,12 @@
 
 #define OCFS2_MAX_TO_STEAL		1024
 
+struct ocfs2_suballoc_result {
+	u64		sr_bg_blkno;	/* The bg we allocated from */
+	unsigned int	sr_bit_offset;	/* The bit in the bg */
+	unsigned int	sr_bits;	/* How many bits we claimed */
+};
+
 static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg);
 static inline void ocfs2_debug_suballoc_inode(struct ocfs2_dinode *fe);
 static inline u16 ocfs2_find_victim_chain(struct ocfs2_chain_list *cl);
@@ -74,20 +80,18 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 				      struct buffer_head *group_bh,
 				      u32 bits_wanted, u32 min_bits,
 				      u64 max_block,
-				      u16 *bit_off, u16 *bits_found);
+				      struct ocfs2_suballoc_result *res);
 static int ocfs2_block_group_search(struct inode *inode,
 				    struct buffer_head *group_bh,
 				    u32 bits_wanted, u32 min_bits,
 				    u64 max_block,
-				    u16 *bit_off, u16 *bits_found);
+				    struct ocfs2_suballoc_result *res);
 static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
 				     struct ocfs2_alloc_context *ac,
 				     handle_t *handle,
 				     u32 bits_wanted,
 				     u32 min_bits,
-				     u16 *bit_off,
-				     unsigned int *num_bits,
-				     u64 *bg_blkno);
+				     struct ocfs2_suballoc_result *res);
 static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 					 int nr);
 static inline int ocfs2_block_group_set_bits(handle_t *handle,
@@ -1252,8 +1256,7 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 					     struct buffer_head *bg_bh,
 					     unsigned int bits_wanted,
 					     unsigned int total_bits,
-					     u16 *bit_off,
-					     u16 *bits_found)
+					     struct ocfs2_suballoc_result *res)
 {
 	void *bitmap;
 	u16 best_offset, best_size;
@@ -1297,14 +1300,9 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 		}
 	}
 
-	/* XXX: I think the first clause is equivalent to the second
-	 * 	- jlbec */
-	if (found == bits_wanted) {
-		*bit_off = start - found;
-		*bits_found = found;
-	} else if (best_size) {
-		*bit_off = best_offset;
-		*bits_found = best_size;
+	if (best_size) {
+		res->sr_bit_offset = best_offset;
+		res->sr_bits = best_size;
 	} else {
 		status = -ENOSPC;
 		/* No error log here -- see the comment above
@@ -1460,14 +1458,13 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 				      struct buffer_head *group_bh,
 				      u32 bits_wanted, u32 min_bits,
 				      u64 max_block,
-				      u16 *bit_off, u16 *bits_found)
+				      struct ocfs2_suballoc_result *res)
 {
 	int search = -ENOSPC;
 	int ret;
 	u64 blkoff;
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *) group_bh->b_data;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	u16 tmp_off, tmp_found;
 	unsigned int max_bits, gd_cluster_off;
 
 	BUG_ON(!ocfs2_is_cluster_bitmap(inode));
@@ -1494,15 +1491,15 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 
 		ret = ocfs2_block_group_find_clear_bits(OCFS2_SB(inode->i_sb),
 							group_bh, bits_wanted,
-							max_bits,
-							&tmp_off, &tmp_found);
+							max_bits, res);
 		if (ret)
 			return ret;
 
 		if (max_block) {
 			blkoff = ocfs2_clusters_to_blocks(inode->i_sb,
 							  gd_cluster_off +
-							  tmp_off + tmp_found);
+							  res->sr_bit_offset +
+							  res->sr_bits);
 			mlog(0, "Checking %llu against %llu\n",
 			     (unsigned long long)blkoff,
 			     (unsigned long long)max_block);
@@ -1514,16 +1511,14 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 		 * return success, but we still want to return
 		 * -ENOSPC unless it found the minimum number
 		 * of bits. */
-		if (min_bits <= tmp_found) {
-			*bit_off = tmp_off;
-			*bits_found = tmp_found;
+		if (min_bits <= res->sr_bits)
 			search = 0; /* success */
-		} else if (tmp_found) {
+		else if (res->sr_bits) {
 			/*
 			 * Don't show bits which we'll be returning
 			 * for allocation to the local alloc bitmap.
 			 */
-			ocfs2_local_alloc_seen_free_bits(osb, tmp_found);
+			ocfs2_local_alloc_seen_free_bits(osb, res->sr_bits);
 		}
 	}
 
@@ -1534,7 +1529,7 @@ static int ocfs2_block_group_search(struct inode *inode,
 				    struct buffer_head *group_bh,
 				    u32 bits_wanted, u32 min_bits,
 				    u64 max_block,
-				    u16 *bit_off, u16 *bits_found)
+				    struct ocfs2_suballoc_result *res)
 {
 	int ret = -ENOSPC;
 	u64 blkoff;
@@ -1547,10 +1542,10 @@ static int ocfs2_block_group_search(struct inode *inode,
 		ret = ocfs2_block_group_find_clear_bits(OCFS2_SB(inode->i_sb),
 							group_bh, bits_wanted,
 							le16_to_cpu(bg->bg_bits),
-							bit_off, bits_found);
+							res);
 		if (!ret && max_block) {
-			blkoff = le64_to_cpu(bg->bg_blkno) + *bit_off +
-				*bits_found;
+			blkoff = le64_to_cpu(bg->bg_blkno) +
+				res->sr_bit_offset + res->sr_bits;
 			mlog(0, "Checking %llu against %llu\n",
 			     (unsigned long long)blkoff,
 			     (unsigned long long)max_block);
@@ -1593,20 +1588,17 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 				  handle_t *handle,
 				  u32 bits_wanted,
 				  u32 min_bits,
-				  u16 *bit_off,
-				  unsigned int *num_bits,
-				  u64 gd_blkno,
+				  struct ocfs2_suballoc_result *res,
 				  u16 *bits_left)
 {
 	int ret;
-	u16 found;
 	struct buffer_head *group_bh = NULL;
 	struct ocfs2_group_desc *gd;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)ac->ac_bh->b_data;
 	struct inode *alloc_inode = ac->ac_inode;
 
-	ret = ocfs2_read_group_descriptor(alloc_inode, di, gd_blkno,
-					  &group_bh);
+	ret = ocfs2_read_group_descriptor(alloc_inode, di,
+					  res->sr_bg_blkno, &group_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -1614,17 +1606,15 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 
 	gd = (struct ocfs2_group_desc *) group_bh->b_data;
 	ret = ac->ac_group_search(alloc_inode, group_bh, bits_wanted, min_bits,
-				  ac->ac_max_block, bit_off, &found);
+				  ac->ac_max_block, res);
 	if (ret < 0) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
 		goto out;
 	}
 
-	*num_bits = found;
-
 	ret = ocfs2_alloc_dinode_update_counts(alloc_inode, handle, ac->ac_bh,
-					       *num_bits,
+					       res->sr_bits,
 					       le16_to_cpu(gd->bg_chain));
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -1632,7 +1622,7 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	}
 
 	ret = ocfs2_block_group_set_bits(handle, alloc_inode, gd, group_bh,
-					 *bit_off, *num_bits);
+					 res->sr_bit_offset, res->sr_bits);
 	if (ret < 0)
 		mlog_errno(ret);
 
@@ -1648,13 +1638,11 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 			      handle_t *handle,
 			      u32 bits_wanted,
 			      u32 min_bits,
-			      u16 *bit_off,
-			      unsigned int *num_bits,
-			      u64 *bg_blkno,
+			      struct ocfs2_suballoc_result *res,
 			      u16 *bits_left)
 {
 	int status;
-	u16 chain, tmp_bits;
+	u16 chain;
 	u32 tmp_used;
 	u64 next_group;
 	struct inode *alloc_inode = ac->ac_inode;
@@ -1683,8 +1671,8 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	 * the 1st group with any empty bits. */
 	while ((status = ac->ac_group_search(alloc_inode, group_bh,
 					     bits_wanted, min_bits,
-					     ac->ac_max_block, bit_off,
-					     &tmp_bits)) == -ENOSPC) {
+					     ac->ac_max_block,
+					     res)) == -ENOSPC) {
 		if (!bg->bg_next_group)
 			break;
 
@@ -1709,11 +1697,11 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	}
 
 	mlog(0, "alloc succeeds: we give %u bits from block group %llu\n",
-	     tmp_bits, (unsigned long long)le64_to_cpu(bg->bg_blkno));
+	     res->sr_bits, (unsigned long long)le64_to_cpu(bg->bg_blkno));
 
-	*num_bits = tmp_bits;
+	res->sr_bg_blkno = le64_to_cpu(bg->bg_blkno);
 
-	BUG_ON(*num_bits == 0);
+	BUG_ON(res->sr_bits == 0);
 
 	/*
 	 * Keep track of previous block descriptor read. When
@@ -1730,7 +1718,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	 */
 	if (ac->ac_allow_chain_relink &&
 	    (prev_group_bh) &&
-	    (ocfs2_block_group_reasonably_empty(bg, *num_bits))) {
+	    (ocfs2_block_group_reasonably_empty(bg, res->sr_bits))) {
 		status = ocfs2_relink_block_group(handle, alloc_inode,
 						  ac->ac_bh, group_bh,
 						  prev_group_bh, chain);
@@ -1752,25 +1740,24 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	}
 
 	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
-	fe->id1.bitmap1.i_used = cpu_to_le32(*num_bits + tmp_used);
-	le32_add_cpu(&cl->cl_recs[chain].c_free, -(*num_bits));
+	fe->id1.bitmap1.i_used = cpu_to_le32(res->sr_bits + tmp_used);
+	le32_add_cpu(&cl->cl_recs[chain].c_free, -res->sr_bits);
 	ocfs2_journal_dirty(handle, ac->ac_bh);
 
 	status = ocfs2_block_group_set_bits(handle,
 					    alloc_inode,
 					    bg,
 					    group_bh,
-					    *bit_off,
-					    *num_bits);
+					    res->sr_bit_offset,
+					    res->sr_bits);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	mlog(0, "Allocated %u bits from suballocator %llu\n", *num_bits,
+	mlog(0, "Allocated %u bits from suballocator %llu\n", res->sr_bits,
 	     (unsigned long long)le64_to_cpu(fe->i_blkno));
 
-	*bg_blkno = le64_to_cpu(bg->bg_blkno);
 	*bits_left = le16_to_cpu(bg->bg_free_bits_count);
 bail:
 	brelse(group_bh);
@@ -1786,14 +1773,11 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
 				     handle_t *handle,
 				     u32 bits_wanted,
 				     u32 min_bits,
-				     u16 *bit_off,
-				     unsigned int *num_bits,
-				     u64 *bg_blkno)
+				     struct ocfs2_suballoc_result *res)
 {
 	int status;
 	u16 victim, i;
 	u16 bits_left = 0;
-	u64 hint_blkno = ac->ac_last_group;
 	struct ocfs2_chain_list *cl;
 	struct ocfs2_dinode *fe;
 
@@ -1820,22 +1804,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	if (hint_blkno) {
+	res->sr_bg_blkno = ac->ac_last_group;
+	if (res->sr_bg_blkno) {
 		/* Attempt to short-circuit the usual search mechanism
 		 * by jumping straight to the most recently used
 		 * allocation group. This helps us mantain some
 		 * contiguousness across allocations. */
 		status = ocfs2_search_one_group(ac, handle, bits_wanted,
-						min_bits, bit_off, num_bits,
-						hint_blkno, &bits_left);
-		if (!status) {
-			/* Be careful to update *bg_blkno here as the
-			 * caller is expecting it to be filled in, and
-			 * ocfs2_search_one_group() won't do that for
-			 * us. */
-			*bg_blkno = hint_blkno;
+						min_bits, res, &bits_left);
+		if (!status)
 			goto set_hint;
-		}
 		if (status < 0 && status != -ENOSPC) {
 			mlog_errno(status);
 			goto bail;
@@ -1848,8 +1826,8 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
 	ac->ac_chain = victim;
 	ac->ac_allow_chain_relink = 1;
 
-	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits, bit_off,
-				    num_bits, bg_blkno, &bits_left);
+	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
+				    res, &bits_left);
 	if (!status)
 		goto set_hint;
 	if (status < 0 && status != -ENOSPC) {
@@ -1873,8 +1851,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
 
 		ac->ac_chain = i;
 		status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
-					    bit_off, num_bits, bg_blkno,
-					    &bits_left);
+					    res, &bits_left);
 		if (!status)
 			break;
 		if (status < 0 && status != -ENOSPC) {
@@ -1891,7 +1868,7 @@ set_hint:
 		if (bits_left < min_bits)
 			ac->ac_last_group = 0;
 		else
-			ac->ac_last_group = *bg_blkno;
+			ac->ac_last_group = res->sr_bg_blkno;
 	}
 
 bail:
@@ -1908,7 +1885,7 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 			 u64 *blkno_start)
 {
 	int status;
-	u64 bg_blkno;
+	struct ocfs2_suballoc_result res;
 
 	BUG_ON(!ac);
 	BUG_ON(ac->ac_bits_wanted < (ac->ac_bits_given + bits_wanted));
@@ -1919,17 +1896,17 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 					   handle,
 					   bits_wanted,
 					   1,
-					   suballoc_bit_start,
-					   num_bits,
-					   &bg_blkno);
+					   &res);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 	atomic_inc(&osb->alloc_stats.bg_allocs);
 
-	*blkno_start = bg_blkno + (u64) *suballoc_bit_start;
-	ac->ac_bits_given += (*num_bits);
+	*suballoc_bit_start = res.sr_bit_offset;
+	*blkno_start = res.sr_bg_blkno + (u64)(res.sr_bit_offset);
+	ac->ac_bits_given += res.sr_bits;
+	*num_bits = res.sr_bits;
 	status = 0;
 bail:
 	mlog_exit(status);
@@ -1976,8 +1953,7 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 			  u64 *fe_blkno)
 {
 	int status;
-	unsigned int num_bits;
-	u64 bg_blkno;
+	struct ocfs2_suballoc_result res;
 
 	mlog_entry_void();
 
@@ -1993,18 +1969,17 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 					   handle,
 					   1,
 					   1,
-					   suballoc_bit,
-					   &num_bits,
-					   &bg_blkno);
+					   &res);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 	atomic_inc(&osb->alloc_stats.bg_allocs);
 
-	BUG_ON(num_bits != 1);
+	BUG_ON(res.sr_bits != 1);
 
-	*fe_blkno = bg_blkno + (u64) (*suballoc_bit);
+	*suballoc_bit = res.sr_bit_offset;
+	*fe_blkno = res.sr_bg_blkno + (u64)(res.sr_bit_offset);
 	ac->ac_bits_given++;
 	ocfs2_save_inode_ac_group(dir, ac);
 	status = 0;
@@ -2084,8 +2059,7 @@ int __ocfs2_claim_clusters(struct ocfs2_super *osb,
 {
 	int status;
 	unsigned int bits_wanted = max_clusters;
-	u64 bg_blkno = 0;
-	u16 bg_bit_off;
+	struct ocfs2_suballoc_result res;
 
 	mlog_entry_void();
 
@@ -2124,14 +2098,12 @@ int __ocfs2_claim_clusters(struct ocfs2_super *osb,
 						   handle,
 						   bits_wanted,
 						   min_clusters,
-						   &bg_bit_off,
-						   num_clusters,
-						   &bg_blkno);
+						   &res);
 		if (!status) {
 			*cluster_start =
 				ocfs2_desc_bitmap_to_cluster_off(ac->ac_inode,
-								 bg_blkno,
-								 bg_bit_off);
+								 res.sr_bg_blkno,
+								 res.sr_bit_offset);
 			atomic_inc(&osb->alloc_stats.bitmap_data);
 		}
 	}
@@ -2141,7 +2113,8 @@ int __ocfs2_claim_clusters(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	ac->ac_bits_given += *num_clusters;
+	ac->ac_bits_given += res.sr_bits;
+	*num_clusters = res.sr_bits;
 
 bail:
 	mlog_exit(status);
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 74e502e..26a5ad3 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -26,13 +26,14 @@
 #ifndef _CHAINALLOC_H_
 #define _CHAINALLOC_H_
 
+struct ocfs2_suballoc_result;
 typedef int (group_search_t)(struct inode *,
 			     struct buffer_head *,
 			     u32,			/* bits_wanted */
 			     u32,			/* min_bits */
 			     u64,			/* max_block */
-			     u16 *,			/* *bit_off */
-			     u16 *);			/* *bits_found */
+			     struct ocfs2_suballoc_result *);
+							/* found bits */
 
 struct ocfs2_alloc_context {
 	struct inode *ac_inode;    /* which bitmap are we allocating from? */
-- 
1.5.5
