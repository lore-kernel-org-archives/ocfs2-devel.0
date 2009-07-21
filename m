From: wen.gang.wang at oracle.com <wen.gang.wang@oracle.com>
Date: Tue, 21 Jul 2009 02:56:15 GMT
Subject: [Ocfs2-devel] (no subject)
Message-ID: <200907210256.n6L2uFJu017248@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From c70adcaca99acf93bc00cf2edc4d549b83e2f95d Mon Sep 17 00:00:00 2001
From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 21 Jul 2009 10:52:52 +0800
Subject: [PATCH 1/1] ocfs2: adds mlogs to aops.c -V2

  this patch adds some mlogs to apos.c helping tracing and narrowing down bugs.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/aops.c |  242 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 198 insertions(+), 44 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b2c52b3..4527f16 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -90,7 +90,7 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 			    iblock;
 		buffer_cache_bh = sb_getblk(osb->sb, blkno);
 		if (!buffer_cache_bh) {
-			mlog(ML_ERROR, "couldn't getblock for symlink!\n");
+			mlog(ML_ERROR, "couldn't get block for symlink!\n");
 			goto bail;
 		}
 
@@ -191,7 +191,9 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
 			     (unsigned long long)iblock,
 			     (unsigned long long)p_blkno,
 			     (unsigned long long)OCFS2_I(inode)->ip_blkno);
-			mlog(ML_ERROR, "Size %llu, clusters %u\n", (unsigned long long)i_size_read(inode), OCFS2_I(inode)->ip_clusters);
+			mlog(ML_ERROR, "Size %llu, clusters %u\n",
+			     (unsigned long long)i_size_read(inode),
+			     OCFS2_I(inode)->ip_clusters);
 			dump_stack();
 		}
 
@@ -217,11 +219,17 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 	void *kaddr;
 	loff_t size;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	int status = 0;
+
+	mlog_entry("(%llu, %lu, %llu)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+		   page->index, (unsigned long long)di_bh->b_blocknr);
 
 	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)) {
 		ocfs2_error(inode->i_sb, "Inode %llu lost inline data flag",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		return -EROFS;
+		status = -EROFS;
+		goto bail;
 	}
 
 	size = i_size_read(inode);
@@ -232,7 +240,8 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 			    "Inode %llu has with inline data has bad size: %Lu",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    (unsigned long long)size);
-		return -EROFS;
+		status = -EROFS;
+		goto bail;
 	}
 
 	kaddr = kmap_atomic(page, KM_USER0);
@@ -245,7 +254,9 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 
 	SetPageUptodate(page);
 
-	return 0;
+bail:
+	mlog_exit(status);
+	return status;
 }
 
 static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
@@ -253,6 +264,9 @@ static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
 	int ret;
 	struct buffer_head *di_bh = NULL;
 
+	mlog_entry("(%llu, %lu)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno, page->index);
+
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
@@ -267,6 +281,7 @@ out:
 	unlock_page(page);
 
 	brelse(di_bh);
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -277,7 +292,7 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 	loff_t start = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	int ret, unlock = 1;
 
-	mlog_entry("(0x%p, %lu)\n", file, (page ? page->index : 0));
+	mlog_entry("(0x%p, %lu)\n", file, page->index);
 
 	ret = ocfs2_inode_lock_with_page(inode, NULL, 0, page);
 	if (ret != 0) {
@@ -344,17 +359,21 @@ static int ocfs2_readpages(struct file *filp, struct address_space *mapping,
 	loff_t start;
 	struct page *last;
 
+	mlog_entry("(0x%p, 0x%p, 0x%p, %u)\n", filp, mapping, pages, nr_pages);
+
 	/*
 	 * Use the nonblocking flag for the dlm code to avoid page
 	 * lock inversion, but don't bother with retrying.
 	 */
 	ret = ocfs2_inode_lock_full(inode, NULL, 0, OCFS2_LOCK_NONBLOCK);
-	if (ret)
-		return err;
+	if (ret) {
+		mlog_errno(ret);
+		goto bail;
+	}
 
 	if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
 		ocfs2_inode_unlock(inode, 0);
-		return err;
+		goto bail;
 	}
 
 	/*
@@ -378,7 +397,8 @@ static int ocfs2_readpages(struct file *filp, struct address_space *mapping,
 out_unlock:
 	up_read(&oi->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 0);
-
+bail:
+	mlog_exit(err);
 	return err;
 }
 
@@ -397,7 +417,7 @@ static int ocfs2_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
 
-	mlog_entry("(0x%p)\n", page);
+	mlog_entry("(0x%p, 0x%p)\n", page, wbc);
 
 	ret = block_write_full_page(page, ocfs2_get_block, wbc);
 
@@ -416,8 +436,13 @@ int ocfs2_prepare_write_nolock(struct inode *inode, struct page *page,
 {
 	int ret;
 
+	mlog_entry("(%llu, %lu, %u, %u)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno, page->index,
+		   from, to);
+
 	ret = block_prepare_write(page, from, to, ocfs2_get_block);
 
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -439,6 +464,8 @@ int walk_page_buffers(	handle_t *handle,
 	int err, ret = 0;
 	struct buffer_head *next;
 
+	mlog_entry("(0x%p, 0x%p, %u, %u, 0x%p)\n", handle, head, from, to, fn);
+
 	for (	bh = head, block_start = 0;
 		ret == 0 && (bh != head || !block_start);
 	    	block_start = block_end, bh = next)
@@ -454,18 +481,23 @@ int walk_page_buffers(	handle_t *handle,
 		if (!ret)
 			ret = err;
 	}
+
+	mlog_exit(ret);
 	return ret;
 }
 
 handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
-							 struct page *page,
-							 unsigned from,
-							 unsigned to)
+				      struct page *page,
+				      unsigned from,
+				      unsigned to)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	handle_t *handle;
 	int ret = 0;
 
+	mlog_entry("(%llu, 0x%p, %u, %u)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno, page, from, to);
+
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
@@ -484,6 +516,8 @@ out:
 			ocfs2_commit_trans(osb, handle);
 		handle = ERR_PTR(ret);
 	}
+
+	mlog_exit_ptr(handle);
 	return handle;
 }
 
@@ -494,7 +528,7 @@ static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 	int err = 0;
 	struct inode *inode = mapping->host;
 
-	mlog_entry("(block = %llu)\n", (unsigned long long)block);
+	mlog_entry("(0x%p, %llu)\n", mapping, (unsigned long long)block);
 
 	/* We don't need to lock journal system files, since they aren't
 	 * accessed concurrently from multiple nodes.
@@ -555,6 +589,10 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
 
+	mlog_entry("(%llu, %llu, 0x%p, %d)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+		   (unsigned long long)iblock, bh_result, create);
+
 	/* This function won't even be called if the request isn't all
 	 * nicely aligned and of the right size, so there's no need
 	 * for us to check any of that. */
@@ -565,6 +603,8 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 	 * Any write past EOF is not allowed because we'd be extending.
 	 */
 	if (create && (iblock + max_blocks) > inode_blocks) {
+		mlog(0, "writting to EOF(%llu/%llu)\n",
+		     iblock + max_blocks, inode_blocks);
 		ret = -EIO;
 		goto bail;
 	}
@@ -618,6 +658,7 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 		contig_blocks = max_blocks;
 	bh_result->b_size = contig_blocks << blocksize_bits;
 bail:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -638,6 +679,8 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
+	mlog(0, "(0x%p, %lld, %ld, 0x%p)\n", iocb, offset, (long)bytes, private);
+
 	ocfs2_iocb_clear_rw_locked(iocb);
 
 	level = ocfs2_iocb_rw_locked_level(iocb);
@@ -655,16 +698,25 @@ static void ocfs2_invalidatepage(struct page *page, unsigned long offset)
 {
 	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
 
+	mlog(0, "(%lu, %lu)\n", page->index, offset);
+
 	jbd2_journal_invalidatepage(journal, page, offset);
 }
 
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
 {
+	int status = 0;
 	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
 
+	mlog_entry("(%lu, %u)\n", page->index, wait);
+
 	if (!page_has_buffers(page))
-		return 0;
-	return jbd2_journal_try_to_free_buffers(journal, page, wait);
+		goto bail;
+
+	status = jbd2_journal_try_to_free_buffers(journal, page, wait);
+bail:
+	mlog_exit(status);
+	return status;
 }
 
 static ssize_t ocfs2_direct_IO(int rw,
@@ -675,16 +727,17 @@ static ssize_t ocfs2_direct_IO(int rw,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
-	int ret;
+	int ret = 0;
 
-	mlog_entry_void();
+	mlog_entry("(%d, 0x%p, 0x%p, %lld, %lu)\n",
+		   rw, iocb, iov, offset, nr_segs);
 
 	/*
 	 * Fallback to buffered I/O if we see an inode without
 	 * extents.
 	 */
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-		return 0;
+		goto bail;
 
 	ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
 					    inode->i_sb->s_bdev, iov, offset,
@@ -692,6 +745,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 					    ocfs2_direct_IO_get_blocks,
 					    ocfs2_dio_end_io);
 
+bail:
 	mlog_exit(ret);
 	return ret;
 }
@@ -703,6 +757,8 @@ static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
 {
 	unsigned int cluster_start = 0, cluster_end = PAGE_CACHE_SIZE;
 
+	mlog(0, "(0x%p, %u, ..)\n", osb, cpos);
+
 	if (unlikely(PAGE_CACHE_SHIFT > osb->s_clustersize_bits)) {
 		unsigned int cpp;
 
@@ -738,6 +794,8 @@ static void ocfs2_clear_page_regions(struct page *page,
 	void *kaddr;
 	unsigned int cluster_start, cluster_end;
 
+	mlog(0, "(%lu, 0x%p, %u, %u, %u)\n", page->index, osb, cpos, from, to);
+
 	ocfs2_figure_cluster_boundaries(osb, cpos, &cluster_start, &cluster_end);
 
 	kaddr = kmap_atomic(page, KM_USER0);
@@ -764,15 +822,23 @@ static void ocfs2_clear_page_regions(struct page *page,
 static int ocfs2_should_read_blk(struct inode *inode, struct page *page,
 				 unsigned int block_start)
 {
+	int ret = 1;
 	u64 offset = page_offset(page) + block_start;
 
+	mlog_entry("(%llu, %lu, %u)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno, page->index,
+		   block_start);
+
 	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
-		return 1;
+		goto bail;
 
 	if (i_size_read(inode) > offset)
-		return 1;
+		goto bail;
 
-	return 0;
+	ret = 0;
+bail:
+	mlog_exit(ret);
+	return ret;
 }
 
 /*
@@ -791,6 +857,10 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 	unsigned int block_end, block_start;
 	unsigned int bsize = 1 << inode->i_blkbits;
 
+	mlog_entry("(%lu, .., %llu, %u, %u, %d)\n",
+		   page->index, (unsigned long long)OCFS2_I(inode)->ip_blkno,
+		   from, to, new);
+
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, bsize, 0);
 
@@ -842,12 +912,14 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 	 */
 	while(wait_bh > wait) {
 		wait_on_buffer(*--wait_bh);
-		if (!buffer_uptodate(*wait_bh))
+		if (!buffer_uptodate(*wait_bh)) {
 			ret = -EIO;
+			mlog_errno(ret);
+		}
 	}
 
 	if (ret == 0 || !new)
-		return ret;
+		goto bail;
 
 	/*
 	 * If we get -EIO above, zero out any newly allocated blocks
@@ -871,6 +943,8 @@ next_bh:
 		bh = bh->b_this_page;
 	} while (bh != head);
 
+bail:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -954,6 +1028,8 @@ void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 {
 	int i;
 
+	mlog(0, "(0x%p, %d)\n", pages, num_pages);
+
 	for(i = 0; i < num_pages; i++) {
 		if (pages[i]) {
 			unlock_page(pages[i]);
@@ -965,6 +1041,8 @@ void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 
 static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
 {
+	mlog(0, "(0x%p)\n", wc);
+
 	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
 
 	brelse(wc->w_di_bh);
@@ -978,9 +1056,14 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 	u32 cend;
 	struct ocfs2_write_ctxt *wc;
 
+	mlog_entry("(.., 0x%p, %lld, %u, %llu)\n",
+		   osb, pos, len, (unsigned long long)di_bh->b_blocknr);
+
 	wc = kzalloc(sizeof(struct ocfs2_write_ctxt), GFP_NOFS);
-	if (!wc)
+	if (!wc) {
+		mlog_exit(-ENOMEM);
 		return -ENOMEM;
+	}
 
 	wc->w_cpos = pos >> osb->s_clustersize_bits;
 	cend = (pos + len - 1) >> osb->s_clustersize_bits;
@@ -997,6 +1080,7 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 
 	*wcp = wc;
 
+	mlog_exit(0);
 	return 0;
 }
 
@@ -1010,6 +1094,8 @@ static void ocfs2_zero_new_buffers(struct page *page, unsigned from, unsigned to
 	unsigned int block_start, block_end;
 	struct buffer_head *head, *bh;
 
+	mlog(0, "(%lu, %u, %u)\n", page->index, from, to);
+
 	BUG_ON(!PageLocked(page));
 	if (!page_has_buffers(page))
 		return;
@@ -1054,6 +1140,10 @@ static void ocfs2_write_failure(struct inode *inode,
 		to = user_pos + user_len;
 	struct page *tmppage;
 
+	mlog(0, "(%llu, 0x%p, %lld, %u)\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno, wc, user_pos,
+	     user_len);
+
 	ocfs2_zero_new_buffers(wc->w_target_page, from, to);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
@@ -1079,6 +1169,10 @@ static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
 	unsigned int cluster_start, cluster_end;
 	unsigned int user_data_from = 0, user_data_to = 0;
 
+	mlog_entry("(%llu, .., 0x%p, %lu, %u, %lld, %u, %d)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno, wc, page->index,
+		   cpos, user_pos, user_len, new);
+
 	ocfs2_figure_cluster_boundaries(OCFS2_SB(inode->i_sb), cpos,
 					&cluster_start, &cluster_end);
 
@@ -1140,6 +1234,7 @@ static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
 	flush_dcache_page(page);
 
 out:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -1155,6 +1250,9 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 	unsigned long start, target_index, index;
 	struct inode *inode = mapping->host;
 
+	mlog_entry("(0x%p, 0x%p, %u, %lld, %d, %lu)\n",
+		   mapping, wc, cpos, user_pos, new, mmap_page->index);
+
 	target_index = user_pos >> PAGE_CACHE_SHIFT;
 
 	/*
@@ -1209,6 +1307,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 			wc->w_target_page = wc->w_pages[i];
 	}
 out:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -1227,6 +1326,10 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	struct ocfs2_extent_tree et;
 
+	mlog_entry("(0x%p, %u, %u, 0x%p, 0x%p, 0x%p, %u, %lld, %u)\n",
+		   mapping, phys, unwritten, data_ac, meta_ac, wc,
+		   cpos, user_pos, user_len);
+
 	new = phys == 0 ? 1 : 0;
 	if (new || unwritten)
 		should_zero = 1;
@@ -1312,7 +1415,7 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 		ocfs2_write_failure(inode, wc, user_pos, user_len);
 
 out:
-
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -1328,6 +1431,9 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
 	struct ocfs2_write_cluster_desc *desc;
 	struct ocfs2_super *osb = OCFS2_SB(mapping->host->i_sb);
 
+	mlog_entry("(0x%p, 0x%p, 0x%p, 0x%p, %lld, %u)\n",
+		   mapping, data_ac, meta_ac, wc, pos, len);
+
 	for (i = 0; i < wc->w_clen; i++) {
 		desc = &wc->w_desc[i];
 
@@ -1354,6 +1460,7 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
 
 	ret = 0;
 out:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -1371,6 +1478,8 @@ static void ocfs2_set_target_boundaries(struct ocfs2_super *osb,
 	wc->w_target_from = pos & (PAGE_CACHE_SIZE - 1);
 	wc->w_target_to = wc->w_target_from + len;
 
+	mlog(0, "(0x%p, 0x%p, %lld, %u, %d)\n", osb, wc, pos, len, alloc);
+
 	if (alloc == 0)
 		return;
 
@@ -1429,6 +1538,9 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 	u32 phys = 0;
 	int i;
 
+	mlog_entry("(%llu, 0x%p, ..)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno, wc);
+
 	*clusters_to_alloc = 0;
 	*extents_to_split = 0;
 
@@ -1479,6 +1591,7 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 
 	ret = 0;
 out:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -1492,6 +1605,9 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 	handle_t *handle;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 
+	mlog_entry("(0x%p, %llu, 0x%p)\n",
+		   mapping, (unsigned long long)OCFS2_I(inode)->ip_blkno, wc);
+
 	page = find_or_create_page(mapping, 0, GFP_NOFS);
 	if (!page) {
 		ret = -ENOMEM;
@@ -1527,14 +1643,15 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 	if (!PageUptodate(page)) {
 		ret = ocfs2_read_inline_data(inode, page, wc->w_di_bh);
 		if (ret) {
+			mlog_errno(ret);
 			ocfs2_commit_trans(osb, handle);
-
 			goto out;
 		}
 	}
 
 	wc->w_handle = handle;
 out:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -1542,8 +1659,14 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size)
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
-	if (new_size <= le16_to_cpu(di->id2.i_data.id_count))
+	mlog_entry("(%llu, %llu)\n",
+		   di_bh->b_blocknr, (unsigned long long)new_size);
+
+	if (new_size <= le16_to_cpu(di->id2.i_data.id_count)) {
+		mlog_exit(1);
 		return 1;
+	}
+	mlog_exit(0);
 	return 0;
 }
 
@@ -1552,14 +1675,14 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
 					  unsigned len, struct page *mmap_page,
 					  struct ocfs2_write_ctxt *wc)
 {
-	int ret, written = 0;
+	int ret = 0, written = 0;
 	loff_t end = pos + len;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = NULL;
 
-	mlog(0, "Inode %llu, write of %u bytes at off %llu. features: 0x%x\n",
-	     (unsigned long long)oi->ip_blkno, len, (unsigned long long)pos,
-	     oi->ip_dyn_features);
+	mlog_entry("Inode %llu, write of %u bytes at off %llu. features: 0x%x\n",
+		   (unsigned long long)oi->ip_blkno, len, (unsigned long long)pos,
+		   oi->ip_dyn_features);
 
 	/*
 	 * Handle inodes which already have inline data 1st.
@@ -1583,15 +1706,14 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
 	 * Check whether the inode can accept inline data.
 	 */
 	if (oi->ip_clusters != 0 || i_size_read(inode) != 0)
-		return 0;
-
+		goto out;
 	/*
 	 * Check whether the write can fit.
 	 */
 	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 	if (mmap_page ||
 	    end > ocfs2_max_inline_data_with_xattr(inode->i_sb, di))
-		return 0;
+		goto out;
 
 do_inline_write:
 	ret = ocfs2_write_begin_inline(mapping, inode, wc);
@@ -1606,7 +1728,11 @@ do_inline_write:
 	 */
 	written = 1;
 out:
-	return written ? written : ret;
+	if (written)
+		ret = written;
+
+	mlog_exit(ret);
+	return ret;
 }
 
 /*
@@ -1622,20 +1748,25 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
 					unsigned len,
 					struct ocfs2_write_ctxt *wc)
 {
-	int ret;
+	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	loff_t newsize = pos + len;
 
+	mlog_entry("(%llu, %lld, %u, 0x%p)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno, pos, len, wc);
+
 	if (ocfs2_sparse_alloc(osb))
-		return 0;
+		goto bail;
 
 	if (newsize <= i_size_read(inode))
-		return 0;
+		goto bail;
 
 	ret = ocfs2_extend_no_holes(inode, newsize, newsize - len);
 	if (ret)
 		mlog_errno(ret);
 
+bail:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -1655,6 +1786,10 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	handle_t *handle;
 	struct ocfs2_extent_tree et;
 
+	mlog_entry("(0x%p, %lld, %u, %u, .., %llu, %lu)\n",
+		   mapping, pos, len, flags, di_bh->b_blocknr,
+		   mmap_page->index);
+
 	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, di_bh);
 	if (ret) {
 		mlog_errno(ret);
@@ -1778,7 +1913,8 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 success:
 	*pagep = wc->w_target_page;
 	*fsdata = wc;
-	return 0;
+	ret = 0;
+	goto real_bail;
 out_quota:
 	if (clusters_to_alloc)
 		vfs_dq_free_space(inode,
@@ -1793,6 +1929,8 @@ out:
 		ocfs2_free_alloc_context(data_ac);
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
+real_bail:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -1804,10 +1942,13 @@ static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
 	struct buffer_head *di_bh = NULL;
 	struct inode *inode = mapping->host;
 
+	mlog_entry("(0x%p, 0x%p, %lld, %u, %u, ..)\n",
+		   file, mapping, pos, len, flags);
+
 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret) {
 		mlog_errno(ret);
-		return ret;
+		goto bail;
 	}
 
 	/*
@@ -1828,14 +1969,15 @@ static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
 
 	brelse(di_bh);
 
-	return 0;
+	goto bail;
 
 out_fail:
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	brelse(di_bh);
 	ocfs2_inode_unlock(inode, 1);
-
+bail:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -1846,6 +1988,10 @@ static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
 {
 	void *kaddr;
 
+	mlog(0, "%llu, %lld, %u, %u, 0x%p, 0x%p)\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno, pos, len, *copied,
+	     di, wc);
+
 	if (unlikely(*copied < len)) {
 		if (!PageUptodate(wc->w_target_page)) {
 			*copied = 0;
@@ -1877,6 +2023,9 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 	handle_t *handle = wc->w_handle;
 	struct page *tmppage;
 
+	mlog_entry("(0x%p, %lld, %u, %u, %lu, 0x%p)\n",
+		   mapping, pos, len, copied, page->index, fsdata);
+
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		ocfs2_write_end_inline(inode, pos, len, &copied, di, wc);
 		goto out_write_size;
@@ -1937,6 +2086,7 @@ out_write_size:
 
 	ocfs2_free_write_ctxt(wc);
 
+	mlog_exit((int)copied);
 	return copied;
 }
 
@@ -1947,11 +2097,15 @@ static int ocfs2_write_end(struct file *file, struct address_space *mapping,
 	int ret;
 	struct inode *inode = mapping->host;
 
+	mlog_entry("(0x%p, 0x%p, %lld, %u, %u, %lu, 0x%p)\n",
+		   file, mapping, pos, len, copied, page->index, fsdata);
+
 	ret = ocfs2_write_end_nolock(mapping, pos, len, copied, page, fsdata);
 
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
 
+	mlog_exit(ret);
 	return ret;
 }
 
-- 
1.6.2.5
