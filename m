From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon,  7 May 2012 16:21:29 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: implement discontiguous localalloc
	bitmap
In-Reply-To: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1336432890-18638-3-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds supporting functions and modifies localalloc code to implement
discontiguous localalloc bitmap.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/localalloc.c |  523 ++++++++++++++++++++++++++++++++-----------------
 1 files changed, 342 insertions(+), 181 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 4190e53..f63381e 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -48,6 +48,9 @@
 
 #define OCFS2_LOCAL_ALLOC(dinode)	(&((dinode)->id2.i_lab))
 
+/* defines minimum contiguous required */
+#define OCFS2_LOCAL_ALLOC_MIN_BITS	2
+
 #define OCFS2_LOCAL_ALLOC_REC_SZ(la)	(le16_to_cpu(la->la_rec_count) *\
 					 sizeof(struct ocfs2_local_alloc_rec))
 #define OCFS2_LOCAL_ALLOC_BITMAP(la)    ((char *)(&(la->la_recs)) +\
@@ -58,7 +61,8 @@
 #define OCFS2_MAX_LOCAL_ALLOC_REC_LIMIT	128
 
 
-static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc);
+static u32 ocfs2_local_alloc_count_bits(struct ocfs2_super *osb,
+					struct ocfs2_dinode *alloc);
 
 static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 					     struct ocfs2_dinode *alloc,
@@ -82,8 +86,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 					handle_t *handle,
 					struct ocfs2_alloc_context *ac);
 
-static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
-					  struct inode *local_alloc_inode);
+static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb);
 
 /*
  * ocfs2_la_default_mb() - determine a default size, in megabytes of
@@ -202,6 +205,74 @@ unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb)
 	return la_mb;
 }
 
+static u32 ocfs2_local_bitmap_to_cluster(struct ocfs2_local_alloc *la, u32 bit)
+{
+	u32 start, prev, offset;
+	int rec;
+
+	rec = start = prev = 0;
+	for (rec = 0; rec < le16_to_cpu(la->la_rec_count); rec++) {
+		prev = start;
+		start += le32_to_cpu(la->la_recs[rec].la_clusters);
+		if (bit < start)
+			break;
+	}
+	offset = le32_to_cpu(la->la_recs[rec].la_start) + (bit - prev);
+
+	return offset;
+}
+
+/*
+ * This function is called before allocating a new chunk for the localalloc
+ * bitmap to make sure there is enough space in the bitmap for the new record
+ */
+static u32 ocfs2_local_alloc_adjust_bits_wanted(struct ocfs2_local_alloc *la,
+						struct ocfs2_alloc_context *ac)
+{
+	u32 required, available, cluster_cnt;
+
+	if (ac->ac_bits_given == ac->ac_bits_wanted)
+		return 0;
+
+	/* total bits available in bitmap */
+	available   = le16_to_cpu(la->la_size) << 3;
+	cluster_cnt = ocfs2_local_alloc_cluster_count(la);
+
+	/*
+	 * Wanted shouldn't be greater than bitmap size and given should be
+	 * equal to cluster count
+	 */
+	BUG_ON(ac->ac_bits_given > ac->ac_bits_wanted);
+	BUG_ON(ac->ac_bits_wanted > available);
+	BUG_ON(ac->ac_bits_given != cluster_cnt);
+
+	/* reduce bits taken by each record structure */
+	available -= (le16_to_cpu(la->la_rec_count) *
+		      OCFS2_LOCAL_ALLOC_BITS_PER_REC);
+
+	/* reduce space reserved for bitmap for already allocated clusters */
+	available -= cluster_cnt;
+
+	/* if available bits are not enough to fit a new record return 0 */
+	if (available < (OCFS2_LOCAL_ALLOC_BITS_PER_REC + 1))
+		return 0;
+
+	/* Adjust space that will be consumed by new record structure */
+	available -= OCFS2_LOCAL_ALLOC_BITS_PER_REC;
+
+	required = ac->ac_bits_wanted - ac->ac_bits_given;
+
+	/*
+	 * we can't allocate clusters more than the bits available. Adjust
+	 * bits wanted
+	 */
+	if (required > available) {
+		ac->ac_bits_wanted = ac->ac_bits_given + available;
+		return available;
+	} else
+		return required;
+}
+
 void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
 {
 	struct super_block *sb = osb->sb;
@@ -239,12 +310,14 @@ void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
 				      unsigned int num_clusters)
 {
 	spin_lock(&osb->osb_lock);
-	if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
-	    osb->local_alloc_state == OCFS2_LA_THROTTLED)
-		if (num_clusters >= osb->local_alloc_default_bits) {
-			cancel_delayed_work(&osb->la_enable_wq);
+	if (osb->local_alloc_state == OCFS2_LA_DISABLED) {
+		cancel_delayed_work(&osb->la_enable_wq);
+		if (num_clusters >= osb->local_alloc_bits)
+			osb->local_alloc_state = OCFS2_LA_THROTTLED;
+
+		if (num_clusters >= osb->local_alloc_default_bits)
 			osb->local_alloc_state = OCFS2_LA_ENABLED;
-		}
+	}
 	spin_unlock(&osb->osb_lock);
 }
 
@@ -280,7 +353,7 @@ int ocfs2_alloc_should_use_local(struct ocfs2_super *osb, u64 bits)
 	 * a new block group. We want to be sure block group
 	 * allocations go through the local alloc, so allow an
 	 * allocation to take up to half the bitmap. */
-	if (bits > (la_bits / 2))
+	if ((la_bits > OCFS2_LOCAL_ALLOC_MIN_BITS) && (bits > (la_bits / 2)))
 		goto bail;
 
 	ret = 1;
@@ -348,21 +421,21 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 	}
 
 	/* do a little verification. */
-	num_used = ocfs2_local_alloc_count_bits(alloc);
+	num_used = ocfs2_local_alloc_count_bits(osb, alloc);
 
 	/* hopefully the local alloc has always been recovered before
 	 * we load it. */
 	if (num_used
 	    || alloc->id1.bitmap1.i_used
 	    || alloc->id1.bitmap1.i_total
-	    || la->la_bm_off)
+	    || la->la_rec_count)
 		mlog(ML_ERROR, "Local alloc hasn't been recovered!\n"
-		     "found = %u, set = %u, taken = %u, off = %u\n",
+		     "found = %u, set = %u, taken = %u\n",
 		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
-		     le32_to_cpu(alloc->id1.bitmap1.i_total),
-		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
+		     le32_to_cpu(alloc->id1.bitmap1.i_total));
 
-	osb->local_alloc_bh = alloc_bh;
+	osb->local_alloc_bh    = alloc_bh;
+	osb->local_alloc_inode = inode;
 	osb->local_alloc_state = OCFS2_LA_ENABLED;
 
 bail:
@@ -389,7 +462,6 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 {
 	int status;
 	handle_t *handle;
-	struct inode *local_alloc_inode = NULL;
 	struct buffer_head *bh = NULL;
 	struct buffer_head *main_bm_bh = NULL;
 	struct inode *main_bm_inode = NULL;
@@ -402,16 +474,6 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
 		goto out;
 
-	local_alloc_inode =
-		ocfs2_get_system_file_inode(osb,
-					    LOCAL_ALLOC_SYSTEM_INODE,
-					    osb->slot_num);
-	if (!local_alloc_inode) {
-		status = -ENOENT;
-		mlog_errno(status);
-		goto out;
-	}
-
 	osb->local_alloc_state = OCFS2_LA_DISABLED;
 
 	ocfs2_resmap_uninit(&osb->osb_la_resmap);
@@ -451,13 +513,19 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	}
 	memcpy(alloc_copy, alloc, bh->b_size);
 
-	status = ocfs2_journal_access_di(handle, INODE_CACHE(local_alloc_inode),
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(osb->local_alloc_inode),
 					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_commit;
 	}
 
+	status = ocfs2_sync_local_to_main(osb, handle, alloc_copy,
+					  main_bm_inode, main_bm_bh);
+	if (status < 0)
+		mlog_errno(status);
+
 	ocfs2_clear_local_alloc(alloc);
 	ocfs2_journal_dirty(handle, bh);
 
@@ -465,11 +533,6 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	osb->local_alloc_bh = NULL;
 	osb->local_alloc_state = OCFS2_LA_UNUSED;
 
-	status = ocfs2_sync_local_to_main(osb, handle, alloc_copy,
-					  main_bm_inode, main_bm_bh);
-	if (status < 0)
-		mlog_errno(status);
-
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 
@@ -483,9 +546,6 @@ out_mutex:
 	iput(main_bm_inode);
 
 out:
-	if (local_alloc_inode)
-		iput(local_alloc_inode);
-
 	if (alloc_copy)
 		kfree(alloc_copy);
 }
@@ -641,22 +701,11 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 {
 	int status;
 	struct ocfs2_dinode *alloc;
-	struct inode *local_alloc_inode;
 	unsigned int free_bits;
 
 	BUG_ON(!ac);
 
-	local_alloc_inode =
-		ocfs2_get_system_file_inode(osb,
-					    LOCAL_ALLOC_SYSTEM_INODE,
-					    osb->slot_num);
-	if (!local_alloc_inode) {
-		status = -ENOENT;
-		mlog_errno(status);
-		goto bail;
-	}
-
-	mutex_lock(&local_alloc_inode->i_mutex);
+	mutex_lock(&osb->local_alloc_inode->i_mutex);
 
 	/*
 	 * We must double check state and allocator bits because
@@ -675,12 +724,12 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 
 #ifdef CONFIG_OCFS2_DEBUG_FS
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
-	    ocfs2_local_alloc_count_bits(alloc)) {
+	    ocfs2_local_alloc_count_bits(osb, alloc)) {
 		ocfs2_error(osb->sb, "local alloc inode %llu says it has "
 			    "%u free bits, but a count shows %u",
 			    (unsigned long long)le64_to_cpu(alloc->i_blkno),
 			    le32_to_cpu(alloc->id1.bitmap1.i_used),
-			    ocfs2_local_alloc_count_bits(alloc));
+			    ocfs2_local_alloc_count_bits(osb, alloc));
 		status = -EIO;
 		goto bail;
 	}
@@ -690,8 +739,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 		le32_to_cpu(alloc->id1.bitmap1.i_used);
 	if (bits_wanted > free_bits) {
 		/* uhoh, window change time. */
-		status =
-			ocfs2_local_alloc_slide_window(osb, local_alloc_inode);
+		status = ocfs2_local_alloc_slide_window(osb);
 		if (status < 0) {
 			if (status != -ENOSPC)
 				mlog_errno(status);
@@ -714,7 +762,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 			goto bail;
 	}
 
-	ac->ac_inode = local_alloc_inode;
+	ac->ac_inode = osb->local_alloc_inode;
 	/* We should never use localalloc from another slot */
 	ac->ac_alloc_slot = osb->slot_num;
 	ac->ac_which = OCFS2_AC_USE_LOCAL;
@@ -722,9 +770,8 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 	ac->ac_bh = osb->local_alloc_bh;
 	status = 0;
 bail:
-	if (status < 0 && local_alloc_inode) {
-		mutex_unlock(&local_alloc_inode->i_mutex);
-		iput(local_alloc_inode);
+	if (status < 0 && osb->local_alloc_inode) {
+		mutex_unlock(&osb->local_alloc_inode->i_mutex);
 	}
 
 	trace_ocfs2_reserve_local_alloc_bits(
@@ -745,7 +792,7 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 {
 	int status, start;
 	struct inode *local_alloc_inode;
-	void *bitmap;
+	u8 *bitmap;
 	struct ocfs2_dinode *alloc;
 	struct ocfs2_local_alloc *la;
 
@@ -764,8 +811,8 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	bitmap = la->la_bitmap;
-	*bit_off = le32_to_cpu(la->la_bm_off) + start;
+	bitmap = OCFS2_LOCAL_ALLOC_BITMAP(la);
+	*bit_off = ocfs2_local_bitmap_to_cluster(la, start);
 	*num_bits = bits_wanted;
 
 	status = ocfs2_journal_access_di(handle,
@@ -792,16 +839,29 @@ bail:
 	return status;
 }
 
-static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
+static u32 ocfs2_local_alloc_count_bits(struct ocfs2_super *osb,
+					struct ocfs2_dinode *alloc)
 {
 	int i;
-	u8 *buffer;
+	u8 *bitmap;
 	u32 count = 0;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	buffer = la->la_bitmap;
-	for (i = 0; i < le16_to_cpu(la->la_size); i++)
-		count += hweight8(buffer[i]);
+	/*
+	 * if discontig is not enabled then lets update the first localalloc
+	 * record with the current bitmap block info. We are doing this because
+	 * old disk formats are not aware of the records.
+	 */
+	if (!ocfs2_supports_discontig_la(osb) && la->la_bm_off) {
+		la->la_rec_count = cpu_to_le16(1);
+		la->la_recs[0].la_start = la->la_bm_off;
+		la->la_recs[0].la_clusters = alloc->id1.bitmap1.i_total;
+	}
+
+	bitmap = OCFS2_LOCAL_ALLOC_BITMAP(la);
+	for (i = 0; i < le32_to_cpu(alloc->id1.bitmap1.i_total); i++)
+		if (ocfs2_test_bit(i, bitmap))
+			count++;
 
 	trace_ocfs2_local_alloc_count_bits(count);
 	return count;
@@ -812,10 +872,11 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 				     u32 *numbits,
 				     struct ocfs2_alloc_reservation *resv)
 {
-	int numfound, bitoff, left, startoff, lastzero;
-	int local_resv = 0;
+	int numfound, bitoff, left, startoff;
+	int i, local_resv = 0;
 	struct ocfs2_alloc_reservation r;
-	void *bitmap = NULL;
+	struct ocfs2_local_alloc *la;
+	u8 *bitmap = NULL;
 	struct ocfs2_reservation_map *resmap = &osb->osb_la_resmap;
 
 	if (!alloc->id1.bitmap1.i_total) {
@@ -847,37 +908,44 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 	 * Reservations are disabled. Handle this the old way.
 	 */
 
-	bitmap = OCFS2_LOCAL_ALLOC(alloc)->la_bitmap;
+	la     = OCFS2_LOCAL_ALLOC(alloc);
+	bitmap = OCFS2_LOCAL_ALLOC_BITMAP(la);
 
-	numfound = bitoff = startoff = 0;
-	lastzero = -1;
-	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
-	while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left, startoff)) != -1) {
-		if (bitoff == left) {
-			/* mlog(0, "bitoff (%d) == left", bitoff); */
-			break;
-		}
-		/* mlog(0, "Found a zero: bitoff = %d, startoff = %d, "
-		   "numfound = %d\n", bitoff, startoff, numfound);*/
-
-		/* Ok, we found a zero bit... is it contig. or do we
-		 * start over?*/
-		if (bitoff == startoff) {
-			/* we found a zero */
-			numfound++;
-			startoff++;
-		} else {
-			/* got a zero after some ones */
-			numfound = 1;
-			startoff = bitoff+1;
-		}
-		/* we got everything we needed */
-		if (numfound == *numbits) {
-			/* mlog(0, "Found it all!\n"); */
-			break;
+	left = numfound = bitoff = startoff = 0;
+	for (i = 0; i < le16_to_cpu(la->la_rec_count); i++) {
+
+		numfound  = 0;
+		startoff += left;
+		left      = le32_to_cpu(la->la_recs[i].la_clusters);
+
+		while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left,
+							  startoff)) != -1) {
+			if (bitoff == left) {
+				/* mlog(0, "bitoff (%d) == left", bitoff); */
+				break;
+			}
+			/* mlog(0, "Found a zero: bitoff = %d, startoff = %d, "
+			 * "numfound = %d\n", bitoff, startoff, numfound);*/
+
+			/* Ok, we found a zero bit... is it contig. or do we
+			 * start over?*/
+			if (bitoff == startoff) {
+				/* we found a zero */
+				numfound++;
+				startoff++;
+			} else {
+				/* got a zero after some ones */
+				numfound = 1;
+				startoff = bitoff+1;
+			}
+			/* we got everything we needed */
+			if (numfound == *numbits) {
+				/* mlog(0, "Found it all!\n"); */
+				goto out;
+			}
 		}
 	}
-
+out:
 	trace_ocfs2_local_alloc_find_clear_bits_search_bitmap(bitoff, numfound);
 
 	if (numfound == *numbits)
@@ -900,12 +968,18 @@ static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc)
 {
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 	int i;
+	u8 *bitmap;
 
 	alloc->id1.bitmap1.i_total = 0;
 	alloc->id1.bitmap1.i_used = 0;
+	la->la_rec_count = 0;
 	la->la_bm_off = 0;
+
+	/* We reset the rec count so following will clear records as well */
+	bitmap = OCFS2_LOCAL_ALLOC_BITMAP(la);
+	bitmap += sizeof(struct ocfs2_local_alloc);
 	for(i = 0; i < le16_to_cpu(la->la_size); i++)
-		la->la_bitmap[i] = 0;
+		bitmap[i] = 0;
 }
 
 #if 0
@@ -933,17 +1007,64 @@ static void ocfs2_verify_zero_bits(unsigned long *bitmap,
  * assumes you've already locked the main bitmap -- the bitmap inode
  * passed is used for caching.
  */
+static int ocfs2_sync_local_rec_to_main(struct ocfs2_super *osb,
+					handle_t *handle,
+					struct ocfs2_dinode *alloc,
+					struct inode *main_bm_inode,
+					struct buffer_head *main_bm_bh,
+					u8 *bitmap, u64 la_start_blk,
+					int start, int left)
+{
+	int bit_off = 0, status = 0, prev, count;
+	u64 blkno;
+
+	prev = start;
+	count = 0;
+	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left,
+						   start)) != -1) {
+		if ((bit_off < left) && (bit_off == start)) {
+			count++;
+			start++;
+			continue;
+		}
+		if (count) {
+			blkno = la_start_blk +
+				ocfs2_clusters_to_blocks(osb->sb,
+						 (start - prev) - count);
+			mlog(0, "\nfreeing %u bits starting at local "
+			     "alloc bit %u (la_start_blk = %llu, "
+			     "blkno = %llu)\n",
+			     count, ((start - prev) - count),
+			     (unsigned long long)la_start_blk,
+			     (unsigned long long)blkno);
+			status = ocfs2_release_clusters(handle, main_bm_inode,
+							main_bm_bh, blkno,
+							count);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
+		}
+		if (bit_off >= left)
+			break;
+		count = 1;
+		start = bit_off + 1;
+	}
+bail:
+	return status;
+}
+
 static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 				    handle_t *handle,
 				    struct ocfs2_dinode *alloc,
 				    struct inode *main_bm_inode,
 				    struct buffer_head *main_bm_bh)
 {
-	int status = 0;
-	int bit_off, left, count, start;
+	int i, status = 0;
+	int total, start, rec_cnt, credits;
+	u32 clusters;
 	u64 la_start_blk;
-	u64 blkno;
-	void *bitmap;
+	u8 *bitmap;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
 	trace_ocfs2_sync_local_to_main(
@@ -954,49 +1075,58 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	/* if all bits are used nothing to sync, just return */
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) ==
 	    le32_to_cpu(alloc->id1.bitmap1.i_total)) {
 		goto bail;
 	}
 
-	la_start_blk = ocfs2_clusters_to_blocks(osb->sb,
-						le32_to_cpu(la->la_bm_off));
-	bitmap = la->la_bitmap;
-	start = count = bit_off = 0;
-	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
+	bitmap  = OCFS2_LOCAL_ALLOC_BITMAP(la);
+	rec_cnt = le16_to_cpu(la->la_rec_count) - 1;
 
-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))
-	       != -1) {
-		if ((bit_off < left) && (bit_off == start)) {
-			count++;
-			start++;
-			continue;
-		}
-		if (count) {
-			blkno = la_start_blk +
-				ocfs2_clusters_to_blocks(osb->sb,
-							 start - count);
+	for (i = rec_cnt; i >= 0 ; i--) {
+		la_start_blk = ocfs2_clusters_to_blocks(osb->sb,
+					le32_to_cpu(la->la_recs[i].la_start));
 
-			trace_ocfs2_sync_local_to_main_free(
-			     count, start - count,
-			     (unsigned long long)la_start_blk,
-			     (unsigned long long)blkno);
+		total    = le32_to_cpu(alloc->id1.bitmap1.i_total);
+		clusters = le32_to_cpu(la->la_recs[i].la_clusters);
+		start    = total - clusters;
 
-			status = ocfs2_release_clusters(handle,
-							main_bm_inode,
-							main_bm_bh, blkno,
-							count);
+		status = ocfs2_sync_local_rec_to_main(osb, handle, alloc,
+						      main_bm_inode,
+						      main_bm_bh, bitmap,
+						      la_start_blk, start,
+						      total);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+		la->la_bm_off              = 0;
+		la->la_recs[i].la_start    = 0;
+		la->la_recs[i].la_clusters = 0;
+		le16_add_cpu(&la->la_rec_count, -1);
+		le32_add_cpu(&alloc->id1.bitmap1.i_total, -clusters);
+
+		ocfs2_journal_dirty(handle, osb->local_alloc_bh);
+
+		/* if we need more credits extend the transaction */
+		credits = OCFS2_WINDOW_MOVE_CREDITS - handle->h_buffer_credits;
+		if (credits > 0) {
+			status = ocfs2_extend_trans(handle, credits);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
+			status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(osb->local_alloc_inode),
+					 osb->local_alloc_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
 			}
 		}
-		if (bit_off >= left)
-			break;
-		count = 1;
-		start = bit_off + 1;
 	}
-
 bail:
 	if (status)
 		mlog_errno(status);
@@ -1046,9 +1176,12 @@ static int ocfs2_recalc_la_window(struct ocfs2_super *osb,
 		 * We ran out of contiguous space in the primary
 		 * bitmap. Drastically reduce the number of bits used
 		 * by local alloc until we have to disable it.
+		 * In general we will be seeing atleast few contiguous free
+		 * bits. It should be ok to keep local alloc enabled even
+		 * in extreme case where max available contiguous free bit is 1
 		 */
 		bits = osb->local_alloc_bits >> 1;
-		if (bits > ocfs2_megabytes_to_clusters(osb->sb, 1)) {
+		if (bits) {
 			/*
 			 * By setting state to THROTTLED, we'll keep
 			 * the number of local alloc bits used down
@@ -1096,8 +1229,9 @@ static int ocfs2_local_alloc_reserve_for_window(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	osb->local_alloc_bits = osb->local_alloc_default_bits;
 retry_enospc:
-	(*ac)->ac_bits_wanted = osb->local_alloc_default_bits;
+	(*ac)->ac_bits_wanted = osb->local_alloc_bits;
 	status = ocfs2_reserve_cluster_bitmap_bits(osb, *ac);
 	if (status == -ENOSPC) {
 		if (ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_ENOSPC) ==
@@ -1137,9 +1271,11 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 					struct ocfs2_alloc_context *ac)
 {
 	int status = 0;
-	u32 cluster_off, cluster_count;
+	u32 wanted, cluster_off, cluster_count;
 	struct ocfs2_dinode *alloc = NULL;
 	struct ocfs2_local_alloc *la;
+	u8 *bitmap;
+	int i, rec_cnt, credits;
 
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 	la = OCFS2_LOCAL_ALLOC(alloc);
@@ -1156,72 +1292,97 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 	/* we used the generic suballoc reserve function, but we set
 	 * everything up nicely, so there's no reason why we can't use
 	 * the more specific cluster api to claim bits. */
-	status = ocfs2_claim_clusters(handle, ac, osb->local_alloc_bits,
-				      &cluster_off, &cluster_count);
-	if (status == -ENOSPC) {
-retry_enospc:
-		/*
-		 * Note: We could also try syncing the journal here to
-		 * allow use of any free bits which the current
-		 * transaction can't give us access to. --Mark
-		 */
-		if (ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_FRAGMENTED) ==
-		    OCFS2_LA_DISABLED)
-			goto bail;
-
-		ac->ac_bits_wanted = osb->local_alloc_default_bits;
-		status = ocfs2_claim_clusters(handle, ac,
-					      osb->local_alloc_bits,
-					      &cluster_off,
+	rec_cnt = 0;
+	wanted = osb->local_alloc_bits;
+	while (1) {
+		status = ocfs2_claim_clusters(handle, ac, wanted, &cluster_off,
 					      &cluster_count);
-		if (status == -ENOSPC)
-			goto retry_enospc;
-		/*
-		 * We only shrunk the *minimum* number of in our
-		 * request - it's entirely possible that the allocator
-		 * might give us more than we asked for.
-		 */
-		if (status == 0) {
-			spin_lock(&osb->osb_lock);
-			osb->local_alloc_bits = cluster_count;
-			spin_unlock(&osb->osb_lock);
+		if (status == -ENOSPC) {
+			/* reduce window size and retry */
+			if (ocfs2_recalc_la_window(osb,
+			   OCFS2_LA_EVENT_FRAGMENTED) == OCFS2_LA_DISABLED)
+				break;
+			wanted = osb->local_alloc_bits;
+			continue;
+		} else if (status < 0)
+			break;
+
+		BUG_ON(ac->ac_bits_given > ac->ac_bits_wanted);
+
+		/* found a window */
+		la->la_recs[rec_cnt].la_start    = cpu_to_le32(cluster_off);
+		la->la_recs[rec_cnt].la_clusters = cpu_to_le32(cluster_count);
+		rec_cnt++;
+		la->la_rec_count = cpu_to_le16(rec_cnt);
+		le32_add_cpu(&alloc->id1.bitmap1.i_total, cluster_count);
+
+		ocfs2_journal_dirty(handle, osb->local_alloc_bh);
+
+		if (!ocfs2_supports_discontig_la(osb)) {
+			la->la_bm_off = cpu_to_le32(cluster_off);
+			break;
+		}
+
+		/* exit if we can't fit another record */
+		wanted = ocfs2_local_alloc_adjust_bits_wanted(la, ac);
+		if (!wanted)
+			break;
+
+		if (wanted > osb->local_alloc_bits)
+			wanted = osb->local_alloc_bits;
+
+		/* if we need more credits extend the transaction */
+		if (rec_cnt >= OCFS2_MAX_LOCAL_ALLOC_REC_LIMIT)
+			break;
+
+		credits = OCFS2_WINDOW_MOVE_CREDITS - handle->h_buffer_credits;
+		if (credits > 0) {
+			status = ocfs2_extend_trans(handle, credits);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
+			status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(osb->local_alloc_inode),
+					 osb->local_alloc_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
 		}
 	}
-	if (status < 0) {
-		if (status != -ENOSPC)
-			mlog_errno(status);
+	if (!rec_cnt)
 		goto bail;
-	}
 
+	osb->local_alloc_state = OCFS2_LA_ENABLED;
+	spin_lock(&osb->osb_lock);
+	if (cluster_count > osb->local_alloc_bits)
+		osb->local_alloc_bits = cluster_count;
+	spin_unlock(&osb->osb_lock);
 	osb->la_last_gd = ac->ac_last_group;
 
-	la->la_bm_off = cpu_to_le32(cluster_off);
-	alloc->id1.bitmap1.i_total = cpu_to_le32(cluster_count);
-	/* just in case... In the future when we find space ourselves,
-	 * we don't have to get all contiguous -- but we'll have to
-	 * set all previously used bits in bitmap and update
-	 * la_bits_set before setting the bits in the main bitmap. */
-	alloc->id1.bitmap1.i_used = 0;
-	memset(OCFS2_LOCAL_ALLOC(alloc)->la_bitmap, 0,
-	       le16_to_cpu(la->la_size));
-
-	ocfs2_resmap_restart(&osb->osb_la_resmap, cluster_count,
-			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
+	bitmap = OCFS2_LOCAL_ALLOC_BITMAP(la);
+	ocfs2_resmap_restart(&osb->osb_la_resmap, rec_cnt,
+			     alloc->id1.bitmap1.i_total, bitmap);
+	for (i = 0; i < rec_cnt; i++)
+		ocfs2_resmap_set_ext(&osb->osb_la_resmap, i,
+				     le32_to_cpu(la->la_recs[i].la_clusters));
 
-	trace_ocfs2_local_alloc_new_window_result(
-		OCFS2_LOCAL_ALLOC(alloc)->la_bm_off,
+	trace_ocfs2_local_alloc_new_window_result
+		(OCFS2_LOCAL_ALLOC(alloc)->la_recs[0].la_start,
 		le32_to_cpu(alloc->id1.bitmap1.i_total));
 
 bail:
-	if (status)
+	if ((status < 0) && (status != -ENOSPC))
 		mlog_errno(status);
+
 	return status;
 }
 
 /* Note that we do *NOT* lock the local alloc inode here as
  * it's been locked already for us. */
-static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
-					  struct inode *local_alloc_inode)
+static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb)
 {
 	int status = 0;
 	struct buffer_head *main_bm_bh = NULL;
@@ -1268,7 +1429,7 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
 
 	status = ocfs2_journal_access_di(handle,
-					 INODE_CACHE(local_alloc_inode),
+					 INODE_CACHE(osb->local_alloc_inode),
 					 osb->local_alloc_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
-- 
1.5.4.3
