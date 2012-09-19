From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 18 Sep 2012 17:11:02 -0700
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: implement discontiguous localalloc
	bitmap
In-Reply-To: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
References: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1348013463-23980-5-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds code to support discontiguous localalloc bitmap. At any given
time there can be a combination of volumes that have discontigous feature
enabled or disabled.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/localalloc.c |  478 +++++++++++++++++++++++++++++++++++--------------
 1 files changed, 341 insertions(+), 137 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 98961f4..82653f2 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -55,14 +55,16 @@
 #define OCFS2_LOCAL_ALLOC_SIZE(osb)	ocfs2_local_alloc_size(osb->sb,\
 						       osb->s_feature_incompat)
 
-static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc);
+static u32 ocfs2_local_alloc_count_bits(struct ocfs2_super *osb,
+					struct ocfs2_dinode *alloc);
 
 static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 					     struct ocfs2_dinode *alloc,
 					     u32 *numbits,
 					     struct ocfs2_alloc_reservation *resv);
 
-static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc);
+static void ocfs2_clear_local_alloc(struct ocfs2_super *osb,
+				    struct ocfs2_dinode *alloc);
 
 static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 				    handle_t *handle,
@@ -207,6 +209,68 @@ unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb)
 	return la_mb;
 }
 
+static inline u32 ocfs2_local_bitmap_to_cluster(struct ocfs2_super *osb,
+						struct ocfs2_local_alloc *la,
+						u32 bit)
+{
+	u32 start, prev, offset;
+	int rec;
+
+	if (!ocfs2_supports_discontig_la(osb))
+		return le32_to_cpu(la->la_bm_off) + bit;
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
+ * bitmap to make sure there is enough space in the bitmap for the new record.
+ * It adjusts bits wanted and returns 0(if full) or a possitive
+ * number(bits required)
+ */
+static unsigned int
+ocfs2_local_alloc_adjust_bits_wanted(struct ocfs2_dinode *alloc,
+				     struct ocfs2_alloc_context *ac)
+{
+	unsigned int wanted, bits_used, total_bits;
+	struct ocfs2_local_alloc *la;
+	int bits_left;
+
+	BUG_ON(ac->ac_bits_given > ac->ac_bits_wanted);
+	wanted = ac->ac_bits_wanted - ac->ac_bits_given;
+	if (wanted == 0)
+		return 0;
+
+	la = OCFS2_LOCAL_ALLOC(alloc);
+	total_bits = le16_to_cpu(la->la_dc_size) << 3;
+
+	/* space for localalloc bitmap + space used for extent records */
+	bits_used  = le32_to_cpu(alloc->id1.bitmap1.i_total) +
+		(le16_to_cpu(la->la_rec_count) *
+		 OCFS2_LOCAL_ALLOC_BITS_PER_REC);
+
+	bits_left = total_bits - bits_used;
+	if (bits_left <= OCFS2_LOCAL_ALLOC_BITS_PER_REC)
+		return 0;
+
+	/* space fore new record */
+	bits_left -= OCFS2_LOCAL_ALLOC_BITS_PER_REC;
+	if (wanted > bits_left) {
+		wanted = bits_left;
+		ac->ac_bits_wanted = ac->ac_bits_given + bits_left;
+	}
+	return wanted;
+}
+
 void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
 {
 	struct super_block *sb = osb->sb;
@@ -344,28 +408,38 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	if ((la->la_size == 0) ||
-	    (le16_to_cpu(la->la_size) > OCFS2_LOCAL_ALLOC_SIZE(osb))) {
+	if (!ocfs2_supports_discontig_la(osb) &&
+	    (!la->la_size ||
+	     (le16_to_cpu(la->la_size) > OCFS2_LOCAL_ALLOC_SIZE(osb)))) {
 		mlog(ML_ERROR, "Local alloc size is invalid (la_size = %u)\n",
 		     le16_to_cpu(la->la_size));
 		status = -EINVAL;
 		goto bail;
 	}
 
+	if (ocfs2_supports_discontig_la(osb) &&
+	    (!la->la_dc_size ||
+	     (le16_to_cpu(la->la_dc_size) > OCFS2_LOCAL_ALLOC_SIZE(osb)))) {
+		mlog(ML_ERROR, "Local alloc size is invalid "
+		     "(la_dc_size = %u)\n", le16_to_cpu(la->la_dc_size));
+		status = -EINVAL;
+		goto bail;
+	}
+
 	/* do a little verification. */
-	num_used = ocfs2_local_alloc_count_bits(alloc);
+	num_used = ocfs2_local_alloc_count_bits(osb, alloc);
 
 	/* hopefully the local alloc has always been recovered before
 	 * we load it. */
 	if (num_used
 	    || alloc->id1.bitmap1.i_used
 	    || alloc->id1.bitmap1.i_total
-	    || la->la_bm_off)
+	    || (ocfs2_supports_discontig_la(osb) && la->la_rec_count)
+	    || (!ocfs2_supports_discontig_la(osb) && la->la_bm_off))
 		mlog(ML_ERROR, "Local alloc hasn't been recovered!\n"
-		     "found = %u, set = %u, taken = %u, off = %u\n",
+		     "found = %u, set = %u, taken = %u\n",
 		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
-		     le32_to_cpu(alloc->id1.bitmap1.i_total),
-		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
+		     le32_to_cpu(alloc->id1.bitmap1.i_total));
 
 	osb->local_alloc_bh    = alloc_bh;
 	osb->local_alloc_inode = inode;
@@ -454,11 +528,12 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 		goto out_commit;
 	}
 
-	ocfs2_clear_local_alloc(alloc);
+	ocfs2_clear_local_alloc(osb, alloc);
 	ocfs2_journal_dirty(handle, bh);
 
 	brelse(bh);
 	osb->local_alloc_bh = NULL;
+	osb->local_alloc_inode = NULL;
 	osb->local_alloc_state = OCFS2_LA_UNUSED;
 
 	status = ocfs2_sync_local_to_main(osb, handle, alloc_copy,
@@ -529,7 +604,7 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 	memcpy((*alloc_copy), alloc_bh->b_data, alloc_bh->b_size);
 
 	alloc = (struct ocfs2_dinode *) alloc_bh->b_data;
-	ocfs2_clear_local_alloc(alloc);
+	ocfs2_clear_local_alloc(osb, alloc);
 
 	ocfs2_compute_meta_ecc(osb->sb, alloc_bh->b_data, &alloc->i_check);
 	status = ocfs2_write_block(osb, alloc_bh, INODE_CACHE(inode));
@@ -657,12 +732,12 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 
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
@@ -744,8 +819,8 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	bitmap = la->la_bitmap;
-	*bit_off = le32_to_cpu(la->la_bm_off) + start;
+	bitmap = ocfs2_local_alloc_bitmap(osb, la);
+	*bit_off = ocfs2_local_bitmap_to_cluster(osb, la, start);
 	*num_bits = bits_wanted;
 
 	status = ocfs2_journal_access_di(handle,
@@ -772,12 +847,19 @@ bail:
 	return status;
 }
 
-static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
+static u32 ocfs2_local_alloc_count_bits(struct ocfs2_super *osb,
+					struct ocfs2_dinode *alloc)
 {
-	u32 count;
+	u32 size, count;
+	u8 *bitmap;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	count = memweight(la->la_bitmap, le16_to_cpu(la->la_size));
+	size = OCFS2_LOCAL_ALLOC_SIZE(osb);
+	if (ocfs2_supports_discontig_la(osb))
+		size -= le16_to_cpu(la->la_bm_start);
+
+	bitmap = ocfs2_local_alloc_bitmap(osb, la);
+	count = memweight(bitmap, size);
 
 	trace_ocfs2_local_alloc_count_bits(count);
 	return count;
@@ -788,10 +870,11 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 				     u32 *numbits,
 				     struct ocfs2_alloc_reservation *resv)
 {
-	int numfound, bitoff, left, startoff, lastzero;
-	int local_resv = 0;
+	int numfound, bitoff, left, startoff;
+	int i, rec_cnt, local_resv = 0;
 	struct ocfs2_alloc_reservation r;
-	void *bitmap = NULL;
+	struct ocfs2_local_alloc *la;
+	u8 *bitmap = NULL;
 	struct ocfs2_reservation_map *resmap = &osb->osb_la_resmap;
 
 	if (!alloc->id1.bitmap1.i_total) {
@@ -823,37 +906,47 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 	 * Reservations are disabled. Handle this the old way.
 	 */
 
-	bitmap = OCFS2_LOCAL_ALLOC(alloc)->la_bitmap;
+	la     = OCFS2_LOCAL_ALLOC(alloc);
+	bitmap = ocfs2_local_alloc_bitmap(osb, la);
 
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
+	if (ocfs2_supports_discontig_la(osb))
+		rec_cnt = le16_to_cpu(la->la_rec_count);
+	else
+		rec_cnt = 1;
+
+	left = numfound = bitoff = startoff = 0;
+	for (i = 0; i < rec_cnt; i++) {
+
+		numfound  = 0;
+		startoff += left;
+		if (ocfs2_supports_discontig_la(osb))
+			left = le32_to_cpu(la->la_recs[i].la_clusters);
+		else
+			left = le32_to_cpu(alloc->id1.bitmap1.i_total);
+
+		while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left,
+							  startoff)) != -1) {
+			if (bitoff == left)
+				break;
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
+
+			/* we got everything we needed */
+			if (numfound == *numbits)
+				goto out;
 		}
 	}
-
+out:
 	trace_ocfs2_local_alloc_find_clear_bits_search_bitmap(bitoff, numfound);
 
 	if (numfound == *numbits)
@@ -872,16 +965,25 @@ bail:
 	return bitoff;
 }
 
-static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc)
+static void ocfs2_clear_local_alloc(struct ocfs2_super *osb,
+				    struct ocfs2_dinode *alloc)
 {
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
-	int i;
+	int i, size;
+	u8 *bitmap;
 
 	alloc->id1.bitmap1.i_total = 0;
 	alloc->id1.bitmap1.i_used = 0;
-	la->la_bm_off = 0;
-	for(i = 0; i < le16_to_cpu(la->la_size); i++)
-		la->la_bitmap[i] = 0;
+	if (ocfs2_supports_discontig_la(osb)) {
+		la->la_bm_start  = 0;
+		la->la_rec_count = 0;
+	} else
+		la->la_bm_off = 0;
+
+	size   = OCFS2_LOCAL_ALLOC_SIZE(osb);
+	bitmap = ocfs2_local_alloc_bitmap(osb, la);
+	for (i = 0; i < size; i++)
+		bitmap[i] = 0;
 }
 
 #if 0
@@ -909,17 +1011,59 @@ static void ocfs2_verify_zero_bits(unsigned long *bitmap,
  * assumes you've already locked the main bitmap -- the bitmap inode
  * passed is used for caching.
  */
+static int ocfs2_sync_local_rec_to_main(struct ocfs2_super *osb,
+					handle_t *handle,
+					struct inode *main_bm_inode,
+					struct buffer_head *main_bm_bh,
+					u8 *bitmap, u64 la_start_blk,
+					int startoff, int left)
+{
+	int bit_off = 0, status = 0, prev, count;
+	u64 blkno;
+
+	BUG_ON(left < startoff);
+	prev = startoff;
+	count = 0;
+	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left,
+						   startoff)) != -1) {
+		if ((bit_off < left) && (bit_off == startoff)) {
+			count++;
+			startoff++;
+			continue;
+		}
+		if (count) {
+			blkno = la_start_blk +
+				ocfs2_clusters_to_blocks(osb->sb,
+						 (startoff - prev) - count);
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
+
+		count = 1;
+		startoff = bit_off + 1;
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
@@ -935,44 +1079,60 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	la_start_blk = ocfs2_clusters_to_blocks(osb->sb,
-						le32_to_cpu(la->la_bm_off));
-	bitmap = la->la_bitmap;
-	start = count = bit_off = 0;
-	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
+	bitmap  = ocfs2_local_alloc_bitmap(osb, la);
+	if (ocfs2_supports_discontig_la(osb))
+		rec_cnt = le16_to_cpu(la->la_rec_count);
+	else
+		rec_cnt = 1;
 
-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))
-	       != -1) {
-		if ((bit_off < left) && (bit_off == start)) {
-			count++;
-			start++;
-			continue;
+	for (i = rec_cnt - 1; i >= 0; i--) {
+		if (ocfs2_supports_discontig_la(osb)) {
+			clusters = le32_to_cpu(la->la_recs[i].la_clusters);
+			la_start_blk = ocfs2_clusters_to_blocks(osb->sb,
+					le32_to_cpu(la->la_recs[i].la_start));
+		} else {
+			clusters = le32_to_cpu(alloc->id1.bitmap1.i_total);
+			la_start_blk = ocfs2_clusters_to_blocks(osb->sb,
+						le32_to_cpu(la->la_bm_off));
 		}
-		if (count) {
-			blkno = la_start_blk +
-				ocfs2_clusters_to_blocks(osb->sb,
-							 start - count);
-
-			trace_ocfs2_sync_local_to_main_free(
-			     count, start - count,
-			     (unsigned long long)la_start_blk,
-			     (unsigned long long)blkno);
-
-			status = ocfs2_release_clusters(handle,
-							main_bm_inode,
-							main_bm_bh, blkno,
-							count);
+		total = le32_to_cpu(alloc->id1.bitmap1.i_total);
+		start = total - clusters;
+		status = ocfs2_sync_local_rec_to_main(osb, handle,
+						      main_bm_inode,
+						      main_bm_bh, bitmap,
+						      la_start_blk, start,
+						      total);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+		credits = OCFS2_WINDOW_MOVE_CREDITS - handle->h_buffer_credits;
+		if (credits > 0) {
+			status = ocfs2_extend_trans(handle, credits);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
+			status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(main_bm_inode),
+					 main_bm_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
 			}
 		}
-		if (bit_off >= left)
+
+		le32_add_cpu(&alloc->id1.bitmap1.i_total, -clusters);
+		if (!ocfs2_supports_discontig_la(osb)) {
+			la->la_bm_off = 0;
 			break;
-		count = 1;
-		start = bit_off + 1;
+		}
+		le16_add_cpu(&la->la_rec_count, -1);
 	}
 
+	if (ocfs2_supports_discontig_la(osb))
+		la->la_bm_start = 0;
 bail:
 	if (status)
 		mlog_errno(status);
@@ -1014,17 +1174,27 @@ static int ocfs2_recalc_la_window(struct ocfs2_super *osb,
 	}
 
 	/*
-	 * ENOSPC and fragmentation are treated similarly for now.
+	 * ENOSPC means there are not enough free clusters in global bitmap.
+	 * So disable localalloc.
 	 */
-	if (event == OCFS2_LA_EVENT_ENOSPC ||
-	    event == OCFS2_LA_EVENT_FRAGMENTED) {
+	if (event == OCFS2_LA_EVENT_ENOSPC) {
+		osb->local_alloc_state = OCFS2_LA_DISABLED;
+		queue_delayed_work(ocfs2_wq, &osb->la_enable_wq,
+				   OCFS2_LA_ENABLE_INTERVAL);
+		goto out_unlock;
+	}
+
+	if (event == OCFS2_LA_EVENT_FRAGMENTED) {
 		/*
 		 * We ran out of contiguous space in the primary
 		 * bitmap. Drastically reduce the number of bits used
 		 * by local alloc until we have to disable it.
+		 * If discontigous localalloc is enabled, we try to fill the
+		 * bitmap until it's disabled
 		 */
 		bits = osb->local_alloc_bits >> 1;
-		if (bits > ocfs2_megabytes_to_clusters(osb->sb, 1)) {
+		if (ocfs2_supports_discontig_la(osb) ||
+		    (bits > ocfs2_megabytes_to_clusters(osb->sb, 1))) {
 			/*
 			 * By setting state to THROTTLED, we'll keep
 			 * the number of local alloc bits used down
@@ -1113,9 +1283,11 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
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
@@ -1132,59 +1304,91 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
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
+		le32_add_cpu(&alloc->id1.bitmap1.i_total, cluster_count);
+		ocfs2_journal_dirty(handle, osb->local_alloc_bh);
+
+		if (!ocfs2_supports_discontig_la(osb)) {
+			la->la_bm_off = cpu_to_le32(cluster_off);
+			break;
+		}
+
+		la->la_recs[rec_cnt].la_start = cpu_to_le32(cluster_off);
+		la->la_recs[rec_cnt].la_clusters = cpu_to_le32(cluster_count);
+		rec_cnt++;
+		la->la_rec_count = cpu_to_le16(rec_cnt);
+		la->la_bm_start += sizeof(struct ocfs2_local_alloc_rec);
+
+		if (rec_cnt >= OCFS2_MAX_LOCAL_ALLOC_REC_LIMIT)
+			break;
+
+		/* exit if we can't fit another record */
+		wanted = ocfs2_local_alloc_adjust_bits_wanted(alloc, ac);
+		if (!wanted)
+			break;
+
+		/* we start from max bits seen instead of max bits needed */
+		if (wanted > osb->local_alloc_bits)
+			wanted = osb->local_alloc_bits;
+
+		/* if we need more credits extend transaction */
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
+
+	if (!alloc->id1.bitmap1.i_total)
 		goto bail;
-	}
 
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
-	ocfs2_resmap_restart(&osb->osb_la_resmap, 1, cluster_count,
-			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
+	bitmap = ocfs2_local_alloc_bitmap(osb, la);
 
-	ocfs2_resmap_set_extent_size(&osb->osb_la_resmap, 0, cluster_count);
+	if (!ocfs2_supports_discontig_la(osb)) {
+		ocfs2_resmap_restart(&osb->osb_la_resmap, 1, cluster_count,
+				     bitmap);
+		ocfs2_resmap_set_extent_size(&osb->osb_la_resmap, 0,
+					     cluster_count);
+	} else {
+		ocfs2_resmap_restart(&osb->osb_la_resmap, rec_cnt,
+				     alloc->id1.bitmap1.i_total, bitmap);
+		for (i = 0; i < rec_cnt; i++)
+			ocfs2_resmap_set_extent_size(&osb->osb_la_resmap, i,
+				     le32_to_cpu(la->la_recs[i].la_clusters));
+	}
 
 	trace_ocfs2_local_alloc_new_window_result(
 		OCFS2_LOCAL_ALLOC(alloc)->la_bm_off,
@@ -1253,7 +1457,7 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	ocfs2_clear_local_alloc(alloc);
+	ocfs2_clear_local_alloc(osb, alloc);
 	ocfs2_journal_dirty(handle, osb->local_alloc_bh);
 
 	status = ocfs2_sync_local_to_main(osb, handle, alloc_copy,
-- 
1.5.4.3
