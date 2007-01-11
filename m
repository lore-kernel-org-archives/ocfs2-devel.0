From: Philipp Reisner <philipp.reisner@linbit.com>
Date: Thu Jan 11 01:58:43 2007
Subject: [Ocfs2-devel] Fixing cluster/heartbeat.c's use of bio_add_page()
In-Reply-To: <20070109222804.GY6831@ca-server1.us.oracle.com>
References: <200701051506.52840.philipp.reisner@linbit.com>
	<20070109222804.GY6831@ca-server1.us.oracle.com>
Message-ID: <200701111058.11212.philipp.reisner@linbit.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

[...]
>
> You changed o2hb_bio_wait_init() to initialize wc_num_reqs to zero, and
> instead you increment the value before each submit_bio(). This makes sense
> because we now don't know how many requests will ultimately be submitted.
>
> However, A race now exists here between the piecemeal increment of
> wc_num_reqs and the completion code in o2hb_bio_wait_dec():
>
> 		if (atomic_dec_and_test(&wc->wc_num_reqs)) {
> 			BUG_ON(num > 0);
> 			complete(&wc->wc_io_complete);
> 		}
>
> So, if enough bios complete before you're done submitting all your read
> requests, you could trigger the completion, wc_io_complete early.
>
> This would certainly be hard to hit, but that's never stopped a race from
> occuring before :)
>

Right, here is a new version of the patch. Now wc_num_reqs gets initialized
to one, and the final decrement happens in o2hb_wait_on_io()

My try of a 'The perfect patch':

Moved the bio_put() call into the bio's bi_end_io() function. This makes the
whole idea of trying to predict the behaviour of bio_add_page() unnecessary.
Removed compute_max_sectors() and o2hb_compute_request_limits().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>

--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -184,10 +184,9 @@ static void o2hb_disarm_write_timeout(st
 	flush_scheduled_work();
 }
 
-static inline void o2hb_bio_wait_init(struct o2hb_bio_wait_ctxt *wc,
-				      unsigned int num_ios)
+static inline void o2hb_bio_wait_init(struct o2hb_bio_wait_ctxt *wc)
 {
-	atomic_set(&wc->wc_num_reqs, num_ios);
+	atomic_set(&wc->wc_num_reqs, 1);
 	init_completion(&wc->wc_io_complete);
 	wc->wc_error = 0;
 }
@@ -212,6 +211,7 @@ static void o2hb_wait_on_io(struct o2hb_
 	struct address_space *mapping = reg->hr_bdev->bd_inode->i_mapping;
 
 	blk_run_address_space(mapping);
+	o2hb_bio_wait_dec(wc, 1);
 
 	wait_for_completion(&wc->wc_io_complete);
 }
@@ -231,6 +231,7 @@ static int o2hb_bio_end_io(struct bio *b
 		return 1;
 
 	o2hb_bio_wait_dec(wc, 1);
+	bio_put(bio);
 	return 0;
 }
 
@@ -238,23 +239,22 @@ static int o2hb_bio_end_io(struct bio *b
  * start_slot. */
 static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 				      struct o2hb_bio_wait_ctxt *wc,
-				      unsigned int start_slot,
-				      unsigned int num_slots)
+				      unsigned int *current_slot,
+				      unsigned int max_slots)
 {
-	int i, nr_vecs, len, first_page, last_page;
+	int len, current_page;
 	unsigned int vec_len, vec_start;
 	unsigned int bits = reg->hr_block_bits;
 	unsigned int spp = reg->hr_slots_per_page;
+	unsigned int cs = *current_slot;
 	struct bio *bio;
 	struct page *page;
 
-	nr_vecs = (num_slots + spp - 1) / spp;
-
 	/* Testing has shown this allocation to take long enough under
 	 * GFP_KERNEL that the local node can get fenced. It would be
 	 * nicest if we could pre-allocate these bios and avoid this
 	 * all together. */
-	bio = bio_alloc(GFP_ATOMIC, nr_vecs);
+	bio = bio_alloc(GFP_ATOMIC, 16);
 	if (!bio) {
 		mlog(ML_ERROR, "Could not alloc slots BIO!\n");
 		bio = ERR_PTR(-ENOMEM);
@@ -262,137 +262,53 @@ static struct bio *o2hb_setup_one_bio(st
 	}
 
 	/* Must put everything in 512 byte sectors for the bio... */
-	bio->bi_sector = (reg->hr_start_block + start_slot) << (bits - 9);
+	bio->bi_sector = (reg->hr_start_block + cs) << (bits - 9);
 	bio->bi_bdev = reg->hr_bdev;
 	bio->bi_private = wc;
 	bio->bi_end_io = o2hb_bio_end_io;
 
-	first_page = start_slot / spp;
-	last_page = first_page + nr_vecs;
-	vec_start = (start_slot << bits) % PAGE_CACHE_SIZE;
-	for(i = first_page; i < last_page; i++) {
-		page = reg->hr_slot_data[i];
+	vec_start = (cs << bits) % PAGE_CACHE_SIZE;
+	while(cs < max_slots) {
+		current_page = cs / spp;
+		page = reg->hr_slot_data[current_page];
 
-		vec_len = PAGE_CACHE_SIZE;
-		/* last page might be short */
-		if (((i + 1) * spp) > (start_slot + num_slots))
-			vec_len = ((num_slots + start_slot) % spp) << bits;
-		vec_len -=  vec_start;
+		vec_len = min( PAGE_CACHE_SIZE, 
+			       (max_slots-cs) * (PAGE_CACHE_SIZE/spp) ); 
 
 		mlog(ML_HB_BIO, "page %d, vec_len = %u, vec_start = %u\n",
-		     i, vec_len, vec_start);
+		     current_page, vec_len, vec_start);
 
 		len = bio_add_page(bio, page, vec_len, vec_start);
-		if (len != vec_len) {
-			bio_put(bio);
-			bio = ERR_PTR(-EIO);
-
-			mlog(ML_ERROR, "Error adding page to bio i = %d, "
-			     "vec_len = %u, len = %d\n, start = %u\n",
-			     i, vec_len, len, vec_start);
-			goto bail;
-		}
+		if (len != vec_len) break;
 
+		cs += vec_len / (PAGE_CACHE_SIZE/spp);
 		vec_start = 0;
 	}
 
 bail:
+	*current_slot = cs;
 	return bio;
 }
 
-/*
- * Compute the maximum number of sectors the bdev can handle in one bio,
- * as a power of two.
- *
- * Stolen from oracleasm, thanks Joel!
- */
-static int compute_max_sectors(struct block_device *bdev)
-{
-	int max_pages, max_sectors, pow_two_sectors;
-
-	struct request_queue *q;
-
-	q = bdev_get_queue(bdev);
-	max_pages = q->max_sectors >> (PAGE_SHIFT - 9);
-	if (max_pages > BIO_MAX_PAGES)
-		max_pages = BIO_MAX_PAGES;
-	if (max_pages > q->max_phys_segments)
-		max_pages = q->max_phys_segments;
-	if (max_pages > q->max_hw_segments)
-		max_pages = q->max_hw_segments;
-	max_pages--; /* Handle I/Os that straddle a page */
-
-	if (max_pages) {
-		max_sectors = max_pages << (PAGE_SHIFT - 9);
-	} else {
-		/* If BIO contains 1 or less than 1 page. */
-		max_sectors = q->max_sectors;
-	}
-	/* Why is fls() 1-based???? */
-	pow_two_sectors = 1 << (fls(max_sectors) - 1);
-
-	return pow_two_sectors;
-}
-
-static inline void o2hb_compute_request_limits(struct o2hb_region *reg,
-					       unsigned int num_slots,
-					       unsigned int *num_bios,
-					       unsigned int *slots_per_bio)
-{
-	unsigned int max_sectors, io_sectors;
-
-	max_sectors = compute_max_sectors(reg->hr_bdev);
-
-	io_sectors = num_slots << (reg->hr_block_bits - 9);
-
-	*num_bios = (io_sectors + max_sectors - 1) / max_sectors;
-	*slots_per_bio = max_sectors >> (reg->hr_block_bits - 9);
-
-	mlog(ML_HB_BIO, "My io size is %u sectors for %u slots. This "
-	     "device can handle %u sectors of I/O\n", io_sectors, num_slots,
-	     max_sectors);
-	mlog(ML_HB_BIO, "Will need %u bios holding %u slots each\n",
-	     *num_bios, *slots_per_bio);
-}
-
 static int o2hb_read_slots(struct o2hb_region *reg,
 			   unsigned int max_slots)
 {
-	unsigned int num_bios, slots_per_bio, start_slot, num_slots;
-	int i, status;
+	unsigned int current_slot=0;
+	int status;
 	struct o2hb_bio_wait_ctxt wc;
-	struct bio **bios;
 	struct bio *bio;
 
-	o2hb_compute_request_limits(reg, max_slots, &num_bios, &slots_per_bio);
+	o2hb_bio_wait_init(&wc);
 
-	bios = kcalloc(num_bios, sizeof(struct bio *), GFP_KERNEL);
-	if (!bios) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		return status;
-	}
-
-	o2hb_bio_wait_init(&wc, num_bios);
-
-	num_slots = slots_per_bio;
-	for(i = 0; i < num_bios; i++) {
-		start_slot = i * slots_per_bio;
-
-		/* adjust num_slots@last bio */
-		if (max_slots < (start_slot + num_slots))
-			num_slots = max_slots - start_slot;
-
-		bio = o2hb_setup_one_bio(reg, &wc, start_slot, num_slots);
+	while(current_slot < max_slots) {
+		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots);
 		if (IS_ERR(bio)) {
-			o2hb_bio_wait_dec(&wc, num_bios - i);
-
 			status = PTR_ERR(bio);
 			mlog_errno(status);
 			goto bail_and_wait;
 		}
-		bios[i] = bio;
 
+		atomic_inc(&wc.wc_num_reqs);
 		submit_bio(READ, bio);
 	}
 
@@ -403,38 +319,30 @@ bail_and_wait:
 	if (wc.wc_error && !status)
 		status = wc.wc_error;
 
-	if (bios) {
-		for(i = 0; i < num_bios; i++)
-			if (bios[i])
-				bio_put(bios[i]);
-		kfree(bios);
-	}
-
 	return status;
 }
 
 static int o2hb_issue_node_write(struct o2hb_region *reg,
-				 struct bio **write_bio,
 				 struct o2hb_bio_wait_ctxt *write_wc)
 {
 	int status;
 	unsigned int slot;
 	struct bio *bio;
 
-	o2hb_bio_wait_init(write_wc, 1);
+	o2hb_bio_wait_init(write_wc);
 
 	slot = o2nm_this_node();
 
-	bio = o2hb_setup_one_bio(reg, write_wc, slot, 1);
+	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1);
 	if (IS_ERR(bio)) {
 		status = PTR_ERR(bio);
 		mlog_errno(status);
 		goto bail;
 	}
 
+	atomic_inc(&write_wc->wc_num_reqs);
 	submit_bio(WRITE, bio);
 
-	*write_bio = bio;
 	status = 0;
 bail:
 	return status;
@@ -826,7 +734,6 @@ static int o2hb_do_disk_heartbeat(struct
 {
 	int i, ret, highest_node, change = 0;
 	unsigned long configured_nodes[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	struct bio *write_bio;
 	struct o2hb_bio_wait_ctxt write_wc;
 
 	ret = o2nm_configured_node_map(configured_nodes,
@@ -864,7 +771,7 @@ static int o2hb_do_disk_heartbeat(struct
 
 	/* And fire off the write. Note that we don't wait on this I/O
 	 * until later. */
-	ret = o2hb_issue_node_write(reg, &write_bio, &write_wc);
+	ret = o2hb_issue_node_write(reg, &write_wc);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -882,7 +789,6 @@ static int o2hb_do_disk_heartbeat(struct
 	 * people we find in our steady state have seen us.
 	 */
 	o2hb_wait_on_io(reg, &write_wc);
-	bio_put(write_bio);
 	if (write_wc.wc_error) {
 		/* Do not re-arm the write timeout on I/O error - we
 		 * can't be sure that the new block ever made it to
@@ -943,7 +849,6 @@ static int o2hb_thread(void *data)
 {
 	int i, ret;
 	struct o2hb_region *reg = data;
-	struct bio *write_bio;
 	struct o2hb_bio_wait_ctxt write_wc;
 	struct timeval before_hb, after_hb;
 	unsigned int elapsed_msec;
@@ -993,10 +898,9 @@ static int o2hb_thread(void *data)
 	 *
 	 * XXX: Should we skip this on unclean_stop? */
 	o2hb_prepare_block(reg, 0);
-	ret = o2hb_issue_node_write(reg, &write_bio, &write_wc);
+	ret = o2hb_issue_node_write(reg, &write_wc);
 	if (ret == 0) {
 		o2hb_wait_on_io(reg, &write_wc);
-		bio_put(write_bio);
 	} else {
 		mlog_errno(ret);
 	}

-- 
: Dipl-Ing Philipp Reisner                      Tel +43-1-8178292-50 :
: LINBIT Information Technologies GmbH          Fax +43-1-8178292-82 :
: Vivenotgasse 48, 1120 Vienna, Austria        http://www.linbit.com :
