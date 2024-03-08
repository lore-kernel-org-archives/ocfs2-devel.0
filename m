Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7103A4EB43
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 Mar 2024 07:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709881563; cv=none; b=P2fM2JRV+wdGN09CzY++eQgR1ZsodOQlPm6kbbTgjiYH9LQTI1kWgJS5bpszLvmBvfnFP59GjLWxMLKhM2pfqqxAz38E7QLLm3qxiBom7ytBr9n4YOj/B7iqLs3DUQFd0ijQmMGfnC8XEfqSZx3RT71kimGWEX163wly/fmmXtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709881563; c=relaxed/simple;
	bh=p5B4I3XrVlG3BNwKfZgZaLTaAJQ7SziFDbSWMdDYprg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZJsdU43ntdjO5xRUUVUaT6KoGrlUcyXfMU4JTMF/ELfKFkfwFkx0cuCDXzlTTjStOreyEuRNsf2pM6YgyqkAfNTK7AgiB0pMT69sGWRrI/bODfLPCPUWC278pdRbx1DXX7zaNZ4eh/9l/k9+YUFayS1ZVJXHFKwZORL8qhjpZJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VWvFXqIV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=po5H4CeU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VWvFXqIV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="po5H4CeU"
Received: from c73.suse.cz (unknown [10.202.0.23])
	by smtp-out1.suse.de (Postfix) with ESMTP id A30AB3733D;
	Fri,  8 Mar 2024 01:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1709862777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GOaNyYY5AzfkrlqiRsz7UNPsijapsw+0C7K8f/KBDpE=;
	b=VWvFXqIVvqk4xHwlBPYTiOlxCo3mvgRvx7L+qyT3xXIphfhilvZ7RDwxP1qwsJv0J8HS0k
	AZhRLPqt0zypF6ZIDMn4A7tQLKPAaJdZ3pJuN1EdSeiKH8UBoGLbQ2dMB/l8kEVmWhVi1V
	MSCuZ0LjMT0OIDZME0gP4JXed/PTpxI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1709862776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GOaNyYY5AzfkrlqiRsz7UNPsijapsw+0C7K8f/KBDpE=;
	b=po5H4CeU+thelmII8Mw2cv8S3SpUsoa5HOm7VKgzgawlPnF/Y9xoLpuSLLe+Ejwgwo234d
	46xM2Ziyw/yorgD+mIxP77dTvic2W2f9RN7bREt2tl1cCTrJNQrXMsB/EB+EfzrBK4qU8G
	JLicZ4f75R3Q4QEH2xDa+6VNyfsNkGU=
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH] ocfs2: improve write IO performance when fragmentation is high
Date: Fri,  8 Mar 2024 09:52:51 +0800
Message-Id: <20240308015251.32041-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.71
X-Spamd-Result: default: False [0.71 / 50.00];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 TO_DN_SOME(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-0.19)[-0.927];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_COUNT_ZERO(0.00)[0];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Flag: NO

The group_search function ocfs2_cluster_group_search() should
bypass groups with insufficient space to avoid unnecessary
searches.

This patch is particularly useful when ocfs2 is handling huge
number small files, and volume fragmentation is very high.
In this case, ocfs2 is busy with looking up available la window
from //global_bitmap.

This patch introduces a new member in the Group Description (gd)
struct called 'bg_contig_free_bits', representing the max
contigous free bits in this gd. When ocfs2 allocates a new
la window from //global_bitmap, 'bg_contig_free_bits' helps
expedite the search process.

Let's image below path.

1. la state (->local_alloc_state) is set THROTTLED or DISABLED.

2. when user delete a large file and trigger
   ocfs2_local_alloc_seen_free_bits set osb->local_alloc_state
   unconditionally.

3. a write IOs thread run and trigger the worst performance path

```
ocfs2_reserve_clusters_with_limit
 ocfs2_reserve_local_alloc_bits
  ocfs2_local_alloc_slide_window //[1]
   + ocfs2_local_alloc_reserve_for_window //[2]
   + ocfs2_local_alloc_new_window //[3]
      ocfs2_recalc_la_window
```

[1]:
will be called when la window bits used up.

[2]:
under la state is ENABLED, and this func only check global_bitmap
free bits, it will succeed in general.

[3]:
will use the default la window size to search clusters then fail.
ocfs2_recalc_la_window attempts other la window sizes.
the timing complexity is O(n^4), resulting in a significant time
cost for scanning global bitmap. This leads to a dramatic slowdown
in write I/Os (e.g., user space 'dd').

i.e.
an ocfs2 partition size: 1.45TB, cluster size: 4KB,
la window default size: 106MB.
The partition is fragmentation by creating & deleting huge mount of
small files.

before this patch, the timing of [3] should be
(the number got from real world):
- la window size change order (size: MB):
  106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
  only 0.8MB succeed, 0.8MB also triggers la window to disable.
  ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
  runs in worst case.
- group chain number: 242
  ocfs2_claim_suballoc_bits calls for-loop 242 times
- each chain has 49 block group
  ocfs2_search_chain calls while-loop 49 times
- each bg has 32256 blocks
  ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
  for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
  (32256/64) (this is not worst value) for timing calucation.

the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)

In the worst case, user space writes 1MB data will trigger 42M scanning
times.

under this patch, the timing is '7*242*49 = 83006', reduce by three
orders of magnitude.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/move_extents.c |   6 +-
 fs/ocfs2/ocfs2_fs.h     |   4 +-
 fs/ocfs2/resize.c       |   7 +++
 fs/ocfs2/suballoc.c     | 120 ++++++++++++++++++++++++++++------------
 fs/ocfs2/suballoc.h     |  28 +++++++++-
 5 files changed, 122 insertions(+), 43 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 1f9ed117e78b..6b9753b8c6fb 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -576,6 +576,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	u32 move_max_hop = ocfs2_blocks_to_clusters(inode->i_sb,
 						    context->range->me_threshold);
 	u64 phys_blkno, new_phys_blkno;
+	struct ocfs2_suballoc_result res = {0};
 
 	phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 
@@ -684,8 +685,9 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 		goto out_commit;
 	}
 
-	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
-					 goal_bit, len);
+	res.sr_bit_offset = goal_bit;
+	res.sr_bits = len;
+	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh, &res, 0);
 	if (ret) {
 		ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
 					       le16_to_cpu(gd->bg_chain));
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 7aebdbf5cc0a..eae18d772e93 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -883,14 +883,14 @@ struct ocfs2_group_desc
 	__le16	bg_free_bits_count;     /* Free bits count */
 	__le16   bg_chain;               /* What chain I am in. */
 /*10*/	__le32   bg_generation;
-	__le32	bg_reserved1;
+	__le32   bg_contig_free_bits;  /* max contig free bits length */
 	__le64   bg_next_group;          /* Next group in my list, in
 					   blocks */
 /*20*/	__le64   bg_parent_dinode;       /* dinode which owns me, in
 					   blocks */
 	__le64   bg_blkno;               /* Offset on disk, in blocks */
 /*30*/	struct ocfs2_block_check bg_check;	/* Error checking */
-	__le64   bg_reserved2;
+	__le64   bg_reserved1;
 /*40*/	union {
 		DECLARE_FLEX_ARRAY(__u8, bg_bitmap);
 		struct {
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index d65d43c61857..ab30518d5f04 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -91,6 +91,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
 	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
 	u16 old_bg_clusters;
+	u32 contig_bits = 0, old_bg_contig_free_bits;
 
 	trace_ocfs2_update_last_group_and_inode(new_clusters,
 						first_new_cluster);
@@ -122,6 +123,11 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
 	}
 
+	ocfs2_find_max_contig_free_bits(group->bg_bitmap,
+					group->bg_bits, 0, &contig_bits);
+	old_bg_contig_free_bits = group->bg_contig_free_bits;
+	group->bg_contig_free_bits = cpu_to_le32(contig_bits);
+
 	ocfs2_journal_dirty(handle, group_bh);
 
 	/* update the inode accordingly. */
@@ -160,6 +166,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 		le16_add_cpu(&group->bg_free_bits_count, backups);
 		le16_add_cpu(&group->bg_bits, -1 * num_bits);
 		le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
+		group->bg_contig_free_bits = old_bg_contig_free_bits;
 	}
 out:
 	if (ret)
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 166c8918c825..df149c3b0eed 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -37,21 +37,6 @@
 
 #define OCFS2_MAX_TO_STEAL		1024
 
-struct ocfs2_suballoc_result {
-	u64		sr_bg_blkno;	/* The bg we allocated from.  Set
-					   to 0 when a block group is
-					   contiguous. */
-	u64		sr_bg_stable_blkno; /*
-					     * Doesn't change, always
-					     * set to target block
-					     * group descriptor
-					     * block.
-					     */
-	u64		sr_blkno;	/* The first allocated block */
-	unsigned int	sr_bit_offset;	/* The bit in the bg */
-	unsigned int	sr_bits;	/* How many bits we claimed */
-};
-
 static u64 ocfs2_group_from_res(struct ocfs2_suballoc_result *res)
 {
 	if (res->sr_blkno == 0)
@@ -1272,6 +1257,25 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 	return ret;
 }
 
+/* caller should initialize contig_bits */
+void ocfs2_find_max_contig_free_bits(void *bitmap,
+			 unsigned int total_bits, int start,
+			 unsigned int *contig_bits)
+{
+	int offset, free_bits;
+
+	while (start < total_bits) {
+		offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start);
+		if (offset == total_bits)
+			break;
+
+		start = ocfs2_find_next_bit(bitmap, total_bits, offset);
+		free_bits = start - offset;
+		if (*contig_bits < free_bits)
+			*contig_bits = free_bits;
+	}
+}
+
 static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 					     struct buffer_head *bg_bh,
 					     unsigned int bits_wanted,
@@ -1279,7 +1283,7 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 					     struct ocfs2_suballoc_result *res)
 {
 	void *bitmap;
-	u16 best_offset, best_size;
+	u16 best_offset, best_size, prev_best_size = 0;
 	int offset, start, found, status = 0;
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 
@@ -1308,6 +1312,7 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 			/* got a zero after some ones */
 			found = 1;
 			start = offset + 1;
+			prev_best_size = best_size;
 		}
 		if (found > best_size) {
 			best_size = found;
@@ -1320,6 +1325,8 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 		}
 	}
 
+	/* best_size will be allocated, we save prev_best_size */
+	res->sr_max_contig_bits = prev_best_size;
 	if (best_size) {
 		res->sr_bit_offset = best_offset;
 		res->sr_bits = best_size;
@@ -1336,12 +1343,15 @@ int ocfs2_block_group_set_bits(handle_t *handle,
 					     struct inode *alloc_inode,
 					     struct ocfs2_group_desc *bg,
 					     struct buffer_head *group_bh,
-					     unsigned int bit_off,
-					     unsigned int num_bits)
+						 struct ocfs2_suballoc_result *res,
+						 int failure_path)
 {
 	int status;
 	void *bitmap = bg->bg_bitmap;
 	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
+	unsigned int bit_off = res->sr_bit_offset;
+	unsigned int num_bits = res->sr_bits;
+	unsigned int start = bit_off + num_bits;
 
 	/* All callers get the descriptor via
 	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
@@ -1373,6 +1383,26 @@ int ocfs2_block_group_set_bits(handle_t *handle,
 	while(num_bits--)
 		ocfs2_set_bit(bit_off++, bitmap);
 
+	/*
+	 * this is optimize for failure path, caller set old contig value
+	 * in res->sr_max_contig_bits to bypass finding action.
+	 */
+	if (failure_path) {
+		bg->bg_contig_free_bits = cpu_to_le16(res->sr_max_contig_bits);
+	} else if (ocfs2_is_cluster_bitmap(alloc_inode)) {
+		/*
+		 * Usually, the block group bitmap allocates only 1 bit
+		 * at a time, while the cluster group allocates n bits
+		 * each time. Therefore, we only save the contig bits for
+		 * the cluster group.
+		 */
+		ocfs2_find_max_contig_free_bits(bitmap, le16_to_cpu(bg->bg_bits),
+				start, &res->sr_max_contig_bits);
+		bg->bg_contig_free_bits = cpu_to_le16(res->sr_max_contig_bits);
+	} else {
+		bg->bg_contig_free_bits = 0;
+	}
+
 	ocfs2_journal_dirty(handle, group_bh);
 
 bail:
@@ -1486,7 +1516,12 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 
 	BUG_ON(!ocfs2_is_cluster_bitmap(inode));
 
-	if (gd->bg_free_bits_count) {
+	if (le16_to_cpu(gd->bg_contig_free_bits) &&
+		le16_to_cpu(gd->bg_contig_free_bits) < bits_wanted)
+		return -ENOSPC;
+
+	/* ->bg_contig_free_bits may un-initialized, so compare again */
+	if (le16_to_cpu(gd->bg_free_bits_count) >= bits_wanted) {
 		max_bits = le16_to_cpu(gd->bg_bits);
 
 		/* Tail groups in cluster bitmaps which aren't cpg
@@ -1555,7 +1590,7 @@ static int ocfs2_block_group_search(struct inode *inode,
 	BUG_ON(min_bits != 1);
 	BUG_ON(ocfs2_is_cluster_bitmap(inode));
 
-	if (bg->bg_free_bits_count) {
+	if (le16_to_cpu(bg->bg_free_bits_count) >= bits_wanted) {
 		ret = ocfs2_block_group_find_clear_bits(OCFS2_SB(inode->i_sb),
 							group_bh, bits_wanted,
 							le16_to_cpu(bg->bg_bits),
@@ -1715,7 +1750,7 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	}
 
 	ret = ocfs2_block_group_set_bits(handle, alloc_inode, gd, group_bh,
-					 res->sr_bit_offset, res->sr_bits);
+					 res, 0);
 	if (ret < 0) {
 		ocfs2_rollback_alloc_dinode_counts(alloc_inode, ac->ac_bh,
 					       res->sr_bits,
@@ -1845,11 +1880,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	}
 
 	status = ocfs2_block_group_set_bits(handle,
-					    alloc_inode,
-					    bg,
-					    group_bh,
-					    res->sr_bit_offset,
-					    res->sr_bits);
+					    alloc_inode, bg, group_bh, res, 0);
 	if (status < 0) {
 		ocfs2_rollback_alloc_dinode_counts(alloc_inode,
 					ac->ac_bh, res->sr_bits, chain);
@@ -2159,11 +2190,7 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
 	}
 
 	ret = ocfs2_block_group_set_bits(handle,
-					 ac->ac_inode,
-					 bg,
-					 bg_bh,
-					 res->sr_bit_offset,
-					 res->sr_bits);
+					 ac->ac_inode, bg, bg_bh, res, 0);
 	if (ret < 0) {
 		ocfs2_rollback_alloc_dinode_counts(ac->ac_inode,
 					       ac->ac_bh, res->sr_bits, chain);
@@ -2380,8 +2407,7 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 					struct inode *alloc_inode,
 					struct ocfs2_group_desc *bg,
 					struct buffer_head *group_bh,
-					unsigned int bit_off,
-					unsigned int num_bits,
+					struct ocfs2_suballoc_result *res,
 					void (*undo_fn)(unsigned int bit,
 							unsigned long *bmap))
 {
@@ -2389,6 +2415,8 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 	unsigned int tmp;
 	struct ocfs2_group_desc *undo_bg = NULL;
 	struct journal_head *jh;
+	unsigned int bit_off = res->sr_bit_offset;
+	unsigned int num_bits = res->sr_bits;
 
 	/* The caller got this descriptor from
 	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
@@ -2433,6 +2461,19 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 				   num_bits);
 	}
 
+	/*
+	 * Rescan whole bg.
+	 * TODO: even 'num_bits == 1' (the worst case, release 1 cluster),
+	 * we still need to rescan whole bg.
+	 */
+	if (ocfs2_is_cluster_bitmap(alloc_inode)) {
+		ocfs2_find_max_contig_free_bits(bg->bg_bitmap, le16_to_cpu(bg->bg_bits),
+				0, &res->sr_max_contig_bits);
+		bg->bg_contig_free_bits = cpu_to_le16(res->sr_max_contig_bits);
+	} else {
+		bg->bg_contig_free_bits = 0;
+	}
+
 	if (undo_fn)
 		spin_unlock(&jh->b_state_lock);
 
@@ -2459,6 +2500,11 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	struct ocfs2_chain_list *cl = &fe->id2.i_chain;
 	struct buffer_head *group_bh = NULL;
 	struct ocfs2_group_desc *group;
+	struct ocfs2_suballoc_result res = {
+		.sr_bit_offset = start_bit,
+		.sr_bits = count,
+		.sr_max_contig_bits = 0};
+	u32 old_bg_contig_free_bits = 0;
 
 	/* The alloc_bh comes from ocfs2_free_dinode() or
 	 * ocfs2_free_clusters().  The callers have all locked the
@@ -2483,9 +2529,10 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 
 	BUG_ON((count + start_bit) > le16_to_cpu(group->bg_bits));
 
+	if (ocfs2_is_cluster_bitmap(alloc_inode))
+		old_bg_contig_free_bits = group->bg_contig_free_bits;
 	status = ocfs2_block_group_clear_bits(handle, alloc_inode,
-					      group, group_bh,
-					      start_bit, count, undo_fn);
+					      group, group_bh, &res, undo_fn);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -2495,8 +2542,9 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 					 alloc_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
+		res.sr_max_contig_bits = old_bg_contig_free_bits;
 		ocfs2_block_group_set_bits(handle, alloc_inode, group, group_bh,
-				start_bit, count);
+				&res, 1);
 		goto bail;
 	}
 
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 9c74eace3adc..ca9af6297724 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -10,7 +10,26 @@
 #ifndef _CHAINALLOC_H_
 #define _CHAINALLOC_H_
 
-struct ocfs2_suballoc_result;
+struct ocfs2_suballoc_result {
+	u64		sr_bg_blkno; /* The bg we allocated from. Set
+					   * to 0 when a block group is
+					   * contiguous. */
+	u64		sr_bg_stable_blkno; /*
+					   * Doesn't change, always
+					   * set to target block
+					   * group descriptor
+					   * block.
+					   */
+	u64		sr_blkno; /* The first allocated block */
+	unsigned int	sr_bit_offset;	/* The bit in the bg */
+	unsigned int	sr_bits;	/* How many bits we claimed */
+	unsigned int	sr_max_contig_bits; /*
+					   * The length for contiguous free
+					   * bits, only available for cluster
+					   * group.
+					   */
+};
+
 typedef int (group_search_t)(struct inode *,
 			     struct buffer_head *,
 			     u32,			/* bits_wanted */
@@ -79,12 +98,15 @@ void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
 			 struct buffer_head *di_bh,
 			 u32 num_bits,
 			 u16 chain);
+void ocfs2_find_max_contig_free_bits(void *bitmap,
+			 unsigned int total_bits, int start,
+			 unsigned int *contig_bits);
 int ocfs2_block_group_set_bits(handle_t *handle,
 			 struct inode *alloc_inode,
 			 struct ocfs2_group_desc *bg,
 			 struct buffer_head *group_bh,
-			 unsigned int bit_off,
-			 unsigned int num_bits);
+			 struct ocfs2_suballoc_result *res,
+			 int failure_path);
 
 int ocfs2_claim_metadata(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
-- 
2.35.3

