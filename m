From: Christoph Hellwig <hch@lst.de>
Date: Fri Aug 13 20:40:15 2004
Subject: [Ocfs2-devel] [PATCH] split inode.c
Message-ID: <20040813222716.GA15758@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

two new files:

 - aops.c implementing ocfs_aops
 - 24io.c implementing 2.4 specific direct I/O and AIO code


Index: src/Makefile
===================================================================
--- src/Makefile	(revision 1355)
+++ src/Makefile	(working copy)
@@ -54,7 +54,9 @@
 endif
 
 CFILES = \
+	24io.c			\
 	alloc.c			\
+	aops.c			\
 	bitmap.c		\
 	buffer_head_io.c	\
 	dcache.c		\
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1355)
+++ src/inode.c	(working copy)
@@ -58,17 +58,8 @@
 
 #define OCFS_DEBUG_CONTEXT    OCFS_DEBUG_CONTEXT_INODE
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-# include <linux/iobuf.h>
-# if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
-#  define free_kiovec_sz(nr, buf, bh)     free_kiovec(nr, buf)
-#  define alloc_kiovec_sz(nr, buf, bh)    alloc_kiovec(nr, buf)
-# endif
-#endif /* for 2.6 - no more kiovec, kiobuf structures - vfs handles
-	* this for us (direct i/o) */
-
-
 extern struct semaphore recovery_list_sem;
+extern struct address_space_operations ocfs_aops;
 
 typedef struct _ocfs_find_inode_args
 {
@@ -78,47 +69,14 @@
 }
 ocfs_find_inode_args;
 
-static int ocfs_readpage (struct file *file, struct page *page);
-static int ocfs_prepare_write (struct file *file, struct page *page, unsigned from, unsigned to);
-static int ocfs_commit_write (struct file *file, struct page *page, unsigned from, unsigned to);
-static int ocfs_get_block (struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create);
-static int ocfs_symlink_get_block (struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create);
-
 static int ocfs_read_locked_inode(struct inode *inode, ocfs_find_inode_args *args);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-static sector_t ocfs_bmap(struct address_space *mapping, sector_t block);
-static int ocfs_writepage (struct page *page, struct writeback_control *wbc);
-static ssize_t ocfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t offset, unsigned long nr_segs);
 static int ocfs_init_locked_inode(struct inode * inode, void * opaque);
 static int ocfs_find_actor (struct inode *inode, void *opaque);
 #else /* 2.4 kernel */
 static int ocfs_find_inode (struct inode *inode, unsigned long ino, void *opaque);
-static int ocfs_bmap(struct address_space *mapping, long block);
-static int ocfs_writepage (struct page *page);
-static int ocfs_get_block2 (struct inode *inode, long iblock, long *oblock, int len);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined(SUSE)
-static int ocfs_direct_IO (int rw, struct file *filp, struct kiobuf *iobuf, unsigned long blocknr, int blocksize);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,10)
-static int ocfs_direct_IO (int rw, struct inode *inode, struct kiobuf *iobuf, unsigned long blocknr, int blocksize);
 #endif
-#endif
 
-static struct address_space_operations ocfs_aops = {
-	.readpage = ocfs_readpage,
-	.writepage = ocfs_writepage,
-	.prepare_write = ocfs_prepare_write,
-	.bmap = ocfs_bmap,
-	.commit_write = ocfs_commit_write,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,10)
-/*
- * On a 2.4 system, we are only adding this here as a dummy basically, 
- * just need open with O_DIRECT to succeed, we still call ocfs_rw_direct().
- * For a 2.6 system, this is the way a filesystem provides direct-io support. 
- */
-	.direct_IO = ocfs_direct_IO
-#endif
-};
-
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /* 
  * ocfs_ilookup()
@@ -813,281 +771,7 @@
 	return;
 }				/* ocfs_clear_inode */
 
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-inline void __mark_dirty(struct buffer_head *bh)
-{
-	set_buffer_flushtime(bh);
-	refile_buffer(bh);
-}
-
-static int __block_commit_write(struct inode *inode, struct page *page,
-		unsigned from, unsigned to)
-{
-	unsigned block_start, block_end;
-	int partial = 0, need_balance_dirty = 0;
-	unsigned blocksize;
-	struct buffer_head *bh, *head;
-
-	blocksize = 1 << inode->i_blkbits;
-
-	for(bh = head = page->buffers, block_start = 0;
-	    bh != head || !block_start;
-	    block_start=block_end, bh = bh->b_this_page) {
-		block_end = block_start + blocksize;
-		if (block_end <= from || block_start >= to) {
-			if (!buffer_uptodate(bh))
-				partial = 1;
-		} else {
-			set_bit(BH_Uptodate, &bh->b_state);
-			if (!atomic_set_buffer_dirty(bh)) {
-				__mark_dirty(bh);
-				buffer_insert_inode_data_queue(bh, inode);
-				need_balance_dirty = 1;
-			}
-		}
-	}
-
-	if (need_balance_dirty)
-		balance_dirty();
-	/*
-	 * is this a partial write that happened to make all buffers
-	 * uptodate then we can optimize away a bogus readpage() for
-	 * the next read(). Here we 'discover' wether the page went
-	 * uptodate as a result of this (potentially partial) write.
-	 */
-	if (!partial)
-		SetPageUptodate(page);
-	return 0;
-}
-
-static int ocfs2_cont_prepare_write(struct page *page, unsigned offset, unsigned to, get_block_t *get_block, loff_t *bytes)
-{
-	struct address_space *mapping = page->mapping;
-	struct inode *inode = mapping->host;
-	struct page *new_page;
-	unsigned long pgpos;
-	long status;
-	unsigned zerofrom;
-	unsigned blocksize = 1 << inode->i_blkbits;
-	char *kaddr;
-
-	while(page->index > (pgpos = *bytes>>PAGE_CACHE_SHIFT)) {
-		status = -ENOMEM;
-		new_page = grab_cache_page(mapping, pgpos);
-		if (!new_page)
-			goto out;
-		/* we might sleep */
-		if (*bytes>>PAGE_CACHE_SHIFT != pgpos) {
-			unlock_page(new_page);
-			page_cache_release(new_page);
-			continue;
-		}
-		zerofrom = *bytes & ~PAGE_CACHE_MASK;
-		if (zerofrom & (blocksize-1)) {
-			*bytes |= (blocksize-1);
-			(*bytes)++;
-		}
-		status = block_prepare_write(new_page, zerofrom,
-					     PAGE_CACHE_SIZE, get_block);
-		if (status)
-			goto out_unmap;
-		kaddr = page_address(new_page);
-		memset(kaddr+zerofrom, 0, PAGE_CACHE_SIZE-zerofrom);
-		flush_dcache_page(new_page);
-		__block_commit_write(inode, new_page, zerofrom, PAGE_CACHE_SIZE);
-		kunmap(new_page);
-		unlock_page(new_page);
-		page_cache_release(new_page);
-	}
-
-	if (page->index < pgpos) {
-		/* completely inside the area */
-		zerofrom = offset;
-	} else {
-		/* page covers the boundary, find the boundary offset */
-		zerofrom = *bytes & ~PAGE_CACHE_MASK;
-
-		/* if we will expand the thing last block will be filled */
-		if (to > zerofrom && (zerofrom & (blocksize-1))) {
-			*bytes |= (blocksize-1);
-			(*bytes)++;
-		}
-
-		/* starting below the boundary? Nothing to zero out */
-		if (offset <= zerofrom)
-			zerofrom = offset;
-	}
-	status = block_prepare_write(page, zerofrom, to, get_block);
-	if (status)
-		goto out1;
-	kaddr = page_address(page);
-	if (zerofrom < offset) {
-		memset(kaddr+zerofrom, 0, offset-zerofrom);
-		flush_dcache_page(page);
-		__block_commit_write(inode, page, zerofrom, offset);
-	}
-	return 0;
-out1:
-	ClearPageUptodate(page);
-	kunmap(page);
-	return status;
-
-out_unmap:
-	ClearPageUptodate(new_page);
-	kunmap(new_page);
-	UnlockPage(new_page);
-	page_cache_release(new_page);
-out:
-	return status;
-}
-
-/* Mark's favorite hack */
-#undef cont_prepare_write
-#define cont_prepare_write ocfs2_cont_prepare_write
-#endif  /* < 2.6.0 */
-
 /*
- * ocfs_prepare_write()
- *
- */
-static int ocfs_prepare_write (struct file *file, struct page *page, unsigned from, unsigned to)
-{
-	int ret;
-	struct inode *inode = page->mapping->host;
-
-	LOG_SET_CONTEXT(PREPARE_WRITE);
-
-	LOG_ENTRY_ARGS ("(0x%p, 0x%p, %u, %u)\n", file, page, from, to);
-
-	if (!inode)
-		BUG();
-
-	ret = cont_prepare_write(page, from, to, ocfs_get_block,
-		&(OCFS_I(page->mapping->host)->ip_mmu_private));
-
-	LOG_EXIT_INT (ret);
-
-	LOG_CLEAR_CONTEXT();
-	return ret;
-}				/* ocfs_prepare_write */
-
-/*
- * ocfs_commit_write()
- *
- */
-static int ocfs_commit_write (struct file *file, struct page *page, unsigned from, unsigned to)
-{
-	int ret;
-
-	LOG_SET_CONTEXT(COMMIT_WRITE);
-
-	LOG_ENTRY_ARGS ("(0x%p, 0x%p, %u, %u)\n", file, page, from, to);
-
-	ret = generic_commit_write (file, page, from, to);
-
-	LOG_EXIT_INT (ret);
-
-	LOG_CLEAR_CONTEXT();
-	return ret;
-}				/* ocfs_commit_write */
-
-/*
- * ocfs_symlink_get_block()
- *  
- */
-static int ocfs_symlink_get_block (struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create)
-{
-	int err = -EIO;
-	int status;
-	ocfs2_dinode *fe = NULL;
-	struct buffer_head *bh = NULL;
-	struct buffer_head *buffer_cache_bh = NULL;
-	ocfs_super *osb = OCFS_SB(inode->i_sb);
-	void *kaddr;
-
-	LOG_ENTRY_ARGS ("(0x%p, %llu, 0x%p, %d)\n", inode,
-			(unsigned long long)iblock, bh_result, create);
-
-	if (!inode) {
-		LOG_ERROR_STR ("bad inode");
-		goto bail;
-	}
-
-	if ((iblock << inode->i_sb->s_blocksize_bits) > PATH_MAX + 1) {
-		LOG_ERROR_ARGS ("block offset > PATH_MAX: %llu",
-				(unsigned long long)iblock);
-		goto bail;
-	}
-
-	status = ocfs_read_bh(OCFS_SB(inode->i_sb),
-			      OCFS_I(inode)->ip_blkno << inode->i_sb->s_blocksize_bits,
-			      &bh,
-			      OCFS_BH_CACHED, inode);
-	if (status < 0) {
-		LOG_ERROR_STATUS (status);
-		goto bail;
-	}
-	fe = (ocfs2_dinode *) bh->b_data;
-
-	if (!IS_VALID_FILE_ENTRY(fe)) {
-		LOG_ERROR_ARGS("Invalid fe at blkno %llu",
-			       OCFS_I(inode)->ip_blkno);
-		goto bail;
-	}
-
-	if ((u64)iblock >= ocfs_clusters_to_blocks(inode->i_sb,
-					      fe->i_clusters)) {
-		LOG_ERROR_ARGS ("block offset is outside the allocated size: %llu",
-		     (unsigned long long)iblock);
-		goto bail;
-	}
-
-	/* We don't use the page cache to create symlink data, so if
-	 * need be, copy it over from the buffer cache. */
-	if (!buffer_uptodate(bh_result) && !ocfs_inode_is_new(osb, inode)) {
-		buffer_cache_bh = sb_getblk(osb->sb, 
-					    fe->id2.i_list.l_recs[0].e_blkno + iblock);
-		if (!buffer_cache_bh) {
-			LOG_ERROR_STR("couldn't getblock for symlink!");
-			goto bail;
-		}
-
-		/* we haven't locked out transactions, so a commit
-		 * could've happened. Since we've got a reference on
-		 * the bh, even if it commits while we're doing the
-		 * copy, the data is still good. */
-		if (buffer_jbd(buffer_cache_bh) 
-		    && !ocfs_inode_is_new(osb, inode)) {
-			kaddr = kmap_atomic(bh_result->b_page, KM_USER0);
-			if (!kaddr) {
-				LOG_ERROR_ARGS("couldn't kmap!\n");
-				goto bail;
-			}
-			memcpy(kaddr + (bh_result->b_size * iblock), 
-			       buffer_cache_bh->b_data, 
-			       bh_result->b_size);
-			kunmap_atomic(kaddr, KM_USER0);
-			set_buffer_uptodate(bh_result);
-		}
-		brelse(buffer_cache_bh);
-	}
-
-	map_bh(bh_result, inode->i_sb,
-	       fe->id2.i_list.l_recs[0].e_blkno + iblock);
-
-	err = 0;
-
-bail:
-	if (bh)
-		brelse(bh);
-
-	LOG_EXIT_INT (err);
-	return err;
-}				/* ocfs_symlink_get_block */
-
-
-/*
  * TODO: this should probably be merged into ocfs_get_block
  * 
  * However, you now need to pay attention to the cont_prepare_write()
@@ -1194,834 +878,6 @@
 }
 
 /*
- * ocfs_get_block()
- *
- */
-static int ocfs_get_block (struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create)
-{
-	int err = -EIO;
-	__s64 vbo = 0;
-	__s64 lbo = 0;
-	__u32 len;
-	int open_direct;
-
-	LOG_ENTRY_ARGS ("(0x%p, %llu, 0x%p, %d)\n", inode,
-			(unsigned long long)iblock, bh_result, create);
-
-	if (!inode) {
-		LOG_ERROR_STR ("bad inode");
-		goto bail;
-	}
-
-	if (OCFS_I(inode)->ip_flags & OCFS_INODE_SYSTEM_FILE) {
-		printk("get_block on system inode 0x%p (%lu)\n",
-		       inode, inode->i_ino);
-	}
-
-	open_direct = OCFS_I(inode)->ip_open_flags & OCFS_OIN_OPEN_FOR_DIRECTIO;
-
-	if (S_ISLNK (inode->i_mode)) {
-		/* this always does I/O for some reason. */
-		down_read(&OCFS_I(inode)->ip_io_sem);
-		err = ocfs_symlink_get_block (inode, iblock, bh_result, 
-					      create);
-		up_read(&OCFS_I(inode)->ip_io_sem);
-		goto bail;
-	}
-
-	vbo = (__s64) iblock << inode->i_sb->s_blocksize_bits;
-
-#if 0
-	if (!INODE_JOURNAL(inode) && vbo >= OCFS_I(inode)->ip_alloc_size) {
-		int vbo_pad;
-		
-		vbo_pad = inode->i_sb->s_blocksize;
-		vbo_pad -= vbo & (s64)(inode->i_sb->s_blocksize - 1);
-
-		LOG_TRACE_STR("Extending allocation");
-		LOG_ERROR_ARGS("extending inode %lu in get_block!!\n", 
-			       inode->i_ino);
-		down_write(&OCFS_I(inode)->ip_io_sem);
-		err = ocfs_extend_file(osb, vbo + vbo_pad, 
-				       NULL, inode, NULL, 0, NULL);
-		up_write(&OCFS_I(inode)->ip_io_sem);
-		if (err < 0) {
-			err = -ENOSPC;
-			LOG_ERROR_STATUS (err);
-			goto bail;
-		}
-	}
-#else
-	if (vbo >= OCFS_I(inode)->ip_alloc_size) {
-		err = -EIO;
-		LOG_ERROR_ARGS("Trying to extend in ocfs_get_block() (inode %llu, blkno %llu, vbo %llu, alloc %llu)\n", OCFS_I(inode)->ip_blkno, (u64)iblock, (u64)vbo, OCFS_I(inode)->ip_alloc_size);
-		goto bail;
-	}
-#endif
-
-	len = inode->i_sb->s_blocksize;
-	if (!open_direct)
-		down_read(&OCFS_I(inode)->ip_extend_sem);
-	err = ocfs_lookup_file_allocation(OCFS2_SB(inode->i_sb),
-					  vbo, &lbo, len, NULL, 
-					  inode, open_direct);
-	if (!open_direct)
-		up_read(&OCFS_I(inode)->ip_extend_sem);
-	if (err < 0) {
-		LOG_ERROR_ARGS ("vbo=%lld lbo=%lld len=%u", vbo, lbo, len);
-		goto bail;
-	}
-
-	map_bh(bh_result, inode->i_sb, lbo >> inode->i_sb->s_blocksize_bits);
-
-	err = 0;
-
-	if (bh_result->b_blocknr == 0) {
-		err = -EIO;
-		LOG_ERROR_ARGS ("vbo=%lld lbo=%lld len=%u, blkno=(%llu)\n",
-				vbo, lbo, len, 
-				OCFS_I(inode)->ip_blkno);
-	}
-
-	if (vbo < OCFS_I(inode)->ip_mmu_private)
-		goto bail;
-	if (!create)
-		goto bail;
-	if (vbo != OCFS_I(inode)->ip_mmu_private) {
-		LOG_ERROR_ARGS("Uh-oh, vbo = %lld, i_size = %llu, mmu = %llu, "
-			       "inode = %llu\n",
-			       vbo, inode->i_size, 
-			       OCFS_I(inode)->ip_mmu_private,
-			       OCFS_I(inode)->ip_blkno);
-		BUG();
-		err = -EIO;
-		goto bail;
-	}
-
-	bh_result->b_state |= (1UL << BH_New);
-	OCFS_I(inode)->ip_mmu_private += inode->i_sb->s_blocksize;
-
-bail:
-	if (err < 0)
-		err = -EIO;
-
-	LOG_EXIT_INT (err);
-	return err;
-}				/* ocfs_get_block */
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-static sector_t ocfs_bmap(struct address_space *mapping, sector_t block) 
-#else
-static int ocfs_bmap(struct address_space *mapping, long block) 
-#endif
-{
-	int disk_block = 0;
-	ocfs_super *osb = OCFS_SB(mapping->host->i_sb);
-	__s64 vbo = 0;
-	__s64 lbo = 0;
-	__u32 len;
-	int err = 0, status;
-	struct inode *inode = mapping->host;
-
-	LOG_SET_CONTEXT(BMAP);
-
-	LOG_ENTRY_ARGS("(block = %llu)\n", (unsigned long long)block);
-
-	if (!inode) {
-		LOG_ERROR_STR ("bmap: bad inode");
-		err = -EINVAL;
-		LOG_ERROR_STATUS(err);
-		goto bail;
-	}
-
-	if (!INODE_JOURNAL(inode)) {
-		LOG_ERROR_STR("bmap is only for journal inodes!");
-		err = -EINVAL;
-		LOG_ERROR_STATUS(err);
-		goto bail;
-	}
-
-	vbo = (__s64) block << inode->i_sb->s_blocksize_bits;
-	len = osb->sb->s_blocksize;
-	err = ocfs_lookup_file_allocation(osb, vbo, &lbo, len, NULL, 
-					   inode, 1);
-	if (err < 0) {
-		LOG_ERROR_ARGS ("vbo=%lld lbo=%lld len=%u", vbo,
-				lbo, len);
-		LOG_ERROR_STATUS(err);
-		goto bail;
-	}
-
-	disk_block = lbo >> inode->i_sb->s_blocksize_bits;
-
-bail:
-	status = err ? err : disk_block;
-	LOG_EXIT_STATUS(status);
-
-	LOG_CLEAR_CONTEXT();
-	return(status);
-}
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-/*
- * ocfs_get_block2()
- *
- */
-static int ocfs_get_block2 (struct inode *inode, long iblock, long *oblock, int len)
-{
-	int err = -EIO;
-	ocfs_super *osb;
-	__s64 vbo = 0;
-	__s64 lbo = 0;
-
-	LOG_ENTRY_ARGS ("(0x%p, %ld)\n", inode, iblock);
-
-	if (!inode) {
-		LOG_ERROR_STR ("bad inode");
-		err = -1;
-		goto bail;
-	}
-
-	osb = OCFS_SB(inode->i_sb);
-
-	vbo = (__s64) iblock << osb->s_sectsize_bits;
-	err = ocfs_lookup_file_allocation(osb, vbo, &lbo, len, NULL, 
-					   inode, 1);
-	if (err < 0) {
-		LOG_ERROR_STATUS (err);
-		err = -1;
-		goto bail;
-	}
-
-	err = 0;
-
-	*oblock = lbo >> osb->s_sectsize_bits;
-	if (*oblock == 0) {
-		err = -EIO;
-		LOG_ERROR_ARGS ("vbo=%lld lbo=%lld len=%u, blkno=(%llu)\n",
-				vbo, lbo, len, 
-				OCFS_I(inode)->ip_blkno);
-	}
-
-bail:
-	if (err < 0)
-		err = -EIO;
-	LOG_EXIT_INT (err);
-	return err;
-}				/* ocfs_get_block2 */
-#endif
-
-/*
- * ocfs_readpage()
- *
- */
-static int ocfs_readpage (struct file *file, struct page *page)
-{
-	int ret;
-
-	LOG_SET_CONTEXT(READPAGE);
-
-	LOG_ENTRY_ARGS ("(0x%p, %lu)\n", file, (page ? page->index : 0));
-
-	ret = block_read_full_page (page, ocfs_get_block);
-	if (ret < 0)
-		goto bail;
-
-bail:
-	LOG_EXIT_INT (ret);
-
-	LOG_CLEAR_CONTEXT();
-	return ret;
-}				/* ocfs_readpage */
-
-/*
- * ocfs_writepage()
- *
- */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-static int ocfs_writepage (struct page *page, struct writeback_control *wbc)
-{
-	int ret;
-
-	LOG_SET_CONTEXT(WRITEPAGE);
-
-	LOG_ENTRY_ARGS ("(0x%p)\n", page);
-
-	ret = block_write_full_page (page, ocfs_get_block, wbc);
-
-	LOG_EXIT_INT (ret);
-
-	LOG_CLEAR_CONTEXT();
-	return ret;
-}				/* ocfs_writepage */
-#else
-static int ocfs_writepage (struct page *page)
-{
-	int ret;
-
-	LOG_SET_CONTEXT(WRITEPAGE);
-
-	LOG_ENTRY_ARGS ("(0x%p)\n", page);
-
-	ret = block_write_full_page (page, ocfs_get_block);
-
-	LOG_EXIT_INT (ret);
-
-	LOG_CLEAR_CONTEXT();
-	return ret;
-}				/* ocfs_writepage */
-#endif
-
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-/*
- * TODO: Make this into a generic get_blocks function.
- *
- * From do_direct_io in direct-io.c:
- *  "So what we do is to permit the ->get_blocks function to populate 
- *   bh.b_size with the size of IO which is permitted at this offset and 
- *   this i_blkbits."
- *
- * This function is called directly from get_more_blocks in direct-io.c.
- *
- * We should probably have this data in the oin for the inode.
- * Otherwise, we might want to look at ocfs_rw_direct, 
- *  ocfs_lookup_file_allocation and ocfs_get_block
- *
- * called like this: dio->get_blocks(dio->inode, fs_startblk,
- * 					fs_count, map_bh, dio->rw == WRITE);
- */
-static int ocfs_direct_IO_get_blocks(struct inode *inode, sector_t iblock, unsigned long max_blocks, struct buffer_head *bh_result, int create)
-{
-	int ret = -1;
-	int status;
-	ocfs_super *osb = NULL;
-	__s64 vbo; /* file offset */
-	__s64 lbo; /* logical (disk) offset */
-	__s64 vbo_max; /* file offset, max_blocks from iblock */
-	int set_new = 0; /* flag */
-	__u64 new_size; /* In bytes, the size of the contiguous block */
-	unsigned char blocksize_bits;
-
-	if (!inode || !bh_result) {
-		LOG_ERROR_STR("ocfs_direct_IO_get_blocks: inode or bh_result is null");
-		return -EIO;
-	}
-
-	osb = inode->i_sb->s_fs_info;
-	blocksize_bits = inode->i_sb->s_blocksize_bits;
-	/* make sure we're up to date... */
-	if (atomic_read(&OCFS_I(inode)->ip_needs_verification)) {
-		LOG_TRACE_STR ("ocfs_direct_IO_get_blocks: verify oin.");
-		status = ocfs_verify_update_inode (osb, inode, 0);
-		if (status < 0) {
-			LOG_TRACE_STR ("ocfs_verify_update_inode failed");
-			ret = -EIO;
-			goto bail;
-		}
-	}
-
-	/* This function won't even be called if the request isn't all
-	 * nicely aligned and of the right size, so there's no need
-	 * for us to check any of that. */
-
-	vbo = (__s64) iblock << blocksize_bits;
-	vbo_max = vbo + ((__s64) max_blocks << blocksize_bits);
-
-	/* NOTE: create flag is set when we ?may? have to allocate some
-	   blocks for the file. */
-	if (create && vbo_max > OCFS_I(inode)->ip_alloc_size) {
-		/* WARNING: How much do we really want to extend the file? */
-		status = ocfs_extend_file(osb, vbo_max,
-					  NULL, inode, NULL, 0, NULL);
-		if (status < 0) {
-			status = -ENOSPC;
-			LOG_ERROR_STR("ocfs_direct_IO_get_blocks: failed to extend the file!");
-			goto bail;
-		}
-		set_new = 1;
-	}
-
-	/* This figure out the size of the next contiguous block, and
-	 * our logical offset */	
-	/* TODO: Try our damndest to give sizes in multiples of PAGE_SIZE */
-	status = ocfs_lookup_file_allocation(osb, vbo, &lbo, max_blocks << blocksize_bits, 
-					     &new_size, inode, 1);
-
-	/* Do whatever we need to the buffer_head */
-	if (set_new) {
-		set_buffer_new(bh_result);
-		/* Do we really want to set bh_result->b_blocknr here too? */
-		bh_result->b_blocknr = lbo >> blocksize_bits;
-	} else {
-		clear_buffer_new(bh_result);
-		/* is the last argument here correct? */
-		map_bh(bh_result, inode->i_sb, lbo >> blocksize_bits);
-	}
-
-	/* make sure we don't map more than max_blocks blocks here as
-	   that's all the kernel will handle at this point. */
-	if (new_size > (__u64)max_blocks << blocksize_bits)
-		new_size = (__u64)max_blocks << blocksize_bits;
-	bh_result->b_size = new_size;
-
-	ret = 0;
-bail:
-	return ret;
-}
-
-/*
- * ocfs_direct_IO()
- * used to be: 
- * static int ocfs_direct_IO (int rw,
- *	       struct inode *inode,
- *	       struct kiobuf *iobuf, unsigned long blocknr, int blocksize)
- *
- * now:         
-  static int ocfs_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
- * int (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
- *                  loff_t offset, unsigned long nr_segs);
- */
-static ssize_t ocfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t offset, unsigned long nr_segs)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_dentry->d_inode->i_mapping->host;
-	int ret;
-
-	LOG_SET_CONTEXT(DIRECT_IO);
-
-	LOG_ENTRY ();
-
-	/* blockdev_direct_IO checks alignment for us, using */
-	ret = blockdev_direct_IO (rw, iocb, inode, inode->i_sb->s_bdev, iov, offset, nr_segs, ocfs_direct_IO_get_blocks, NULL);
-
-	LOG_EXIT_INT (ret);
-
-	LOG_CLEAR_CONTEXT();
-	return ret;
-}				/* ocfs_direct_IO */
-
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,10)
-/*
- * ocfs_direct_IO()
- *
- * we are not using this function anymore, in fact
- * we should never get here any more
- * so let's just BUG(), hint from sct@redhat.com
- */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined(SUSE)
-static int ocfs_direct_IO (int rw, struct file *filp, struct kiobuf *iobuf, unsigned long blocknr, int blocksize)
-{
-	BUG();
-	return 0;
-}				/* ocfs_direct_IO */
-#else
-static int ocfs_direct_IO (int rw, struct inode *inode, struct kiobuf *iobuf, unsigned long blocknr, int blocksize)
-{
-	BUG();
-	return 0;
-}				/* ocfs_direct_IO */
-#endif
-#endif  /* version >= 2.4.10 */
-
-#if defined(SUSE) && LINUX_VERSION_CODE < KERNEL_VERSION(2,4,20)
-#define OCFS_KIO_BLOCKS(_iobuf)  ((_iobuf)->kio_blocks)
-#else
-#define OCFS_KIO_BLOCKS(_iobuf)  ((_iobuf)->blocks)
-#endif
-
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,4,10)
-#define KERNEL_NO_F_IOBUF 1
-#elif defined(SUSE) && LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20)
-#define KERNEL_NO_F_IOBUF 1
-#endif
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-/*
- * ocfs_rw_direct()
- *
- */
-ssize_t ocfs_rw_direct (int rw, struct file *filp, char *buf, size_t size, loff_t * offp)
-{
-#ifdef KERNEL_NO_F_IOBUF
-	struct kiobuf *iobuf;
-#else
-	struct kiobuf *iobuf = filp->f_iobuf;
-	int new_iobuf = 0;
-#endif
-	int err = 0;
-	unsigned long blocknr, blocks, myiosize;
-	size_t transferred;
-	int iosize, clustersize;
-	int i;
-	struct inode *inode = filp->f_dentry->d_inode;
-	int max_sectors;
-	int nbhs;
-	int sector_size, sector_bits, sector_mask, sectors_per_page;
-	int ret = 0;
-	int large_io = 0;
-	int inuse = 0;
-	unsigned long blocks_end_cluster = 0;
-	loff_t saved_off;
-	size_t saved_size;
-	unsigned long firstlogic;
-	long firstphys;
-	long nextphys;
-	unsigned long nextlogic = 0;
-	unsigned long totalioblocks = 0;
-
-	saved_off = *offp;
-	saved_size = size;
-	
-	/* FIXME: Need to differentiate between sectors and blocksize */
-	sector_bits = OCFS_SB(inode->i_sb)->s_sectsize_bits;
-	sector_size = 1 << OCFS_SB(inode->i_sb)->s_sectsize_bits;
-	sector_mask = sector_size - 1;
-	sectors_per_page = PAGE_SIZE / sector_size;
-	/* max sectors is 1024 in 2.4.9
-	 * max data is 512kb  
-	 */
-
-	err = -EINVAL;
-	if (size == 0) {
-		printk("direct write of 0 byte\n");
-		return 0;
-	}
-
-	if (rw == READ) {
-	   if (inode->i_size <= *offp) /* read past end of file */
-	      return 0;
-	   if  (size > (inode->i_size - *offp))
-	      size = inode->i_size - *offp;
-	}
-
-	/* make sure aligned to either PAGE_SIZE or sect_size IO */
-#ifndef LARGEIOS
-	if ((*offp & sector_mask) || (size & sector_mask)) 
-	   /* if not, then fail, we need either to do dio */
-	   return err;
-
-	max_sectors = KIO_MAX_SECTORS;
-	large_io = 0;
-#endif
-#ifdef LARGEIOS	
-	if ((*offp & ~PAGE_MASK) || (size & ~PAGE_MASK)) {
-		/* if it's not PAGE_SIZE, then sect_size */
-		 if ((*offp & sector_mask) || (size & sector_mask))
-			 /* if not, then fail, we need either to do dio */
-			 return err;
-		 max_sectors = KIO_MAX_SECTORS; /* for 2.4.9 - 1024 */
-	} /* ok we 're PAGE_SIZE aligned, lets see if the buffer is */
-	else {
-		if (!((unsigned long) buf & ~PAGE_MASK)) {
-			/* yippie we are .. we can do PAGE_SIZE size io's */
-			large_io = 1;
-			/* for 2.4.9 */
-			max_sectors = KIO_MAX_SECTORS / sectors_per_page;
-		} else {
-			max_sectors = KIO_MAX_SECTORS;
-			large_io = 0;
-		}
-
-	}	
-#endif
-	/* find out how far we are to the end of our cluster */
-
-	err = 0;
-	if (size)
-		err = -ENXIO;
-
-	/* Split the IO into KIO_MAX_SECTORS chunks, mapping and */
-	/* unmapping the single kiobuf as we go to perform each chunk of IO. */
-
-	transferred = 0;
-	blocknr = *offp >> sector_bits;
-	clustersize = inode->i_blksize >> sector_bits;
-	myiosize = size >> sector_bits;
-	blocks_end_cluster = clustersize - (blocknr % clustersize);
-	firstlogic = blocknr;
-	totalioblocks = 0;
-
-	ret = ocfs_get_block2 (inode, blocknr, &firstphys, sector_size);
-	if (ret == -1) {
-		err = 0;
-		goto out;
-	}
-	while (myiosize > 0) {
-	    if (blocks_end_cluster + 1 > myiosize) {
-		totalioblocks += myiosize;
-		myiosize = 0;
-		goto doio;
-	    } else {
-		totalioblocks += blocks_end_cluster;
-		myiosize -= blocks_end_cluster;
-		nextlogic = firstlogic + blocks_end_cluster;
-	    }
-again:
-	    ret = ocfs_get_block2 (inode, nextlogic, &nextphys, sector_size);
-	    if (ret == -1) {
-		err = 0;
-		goto out;
-	    }
-	    if (nextphys == (firstphys + totalioblocks)) {
-		// merge ok
-		blocks_end_cluster = clustersize - (nextlogic % clustersize);
-		if (blocks_end_cluster + 1 > myiosize) {
-		   totalioblocks += myiosize;
-		   myiosize = 0;
-		} else {
-		   totalioblocks += blocks_end_cluster;
-		   myiosize -= blocks_end_cluster;
-		   nextlogic = nextlogic + blocks_end_cluster;
-		   goto again;
-		}
-	    }
-doio:
-		size = totalioblocks << sector_bits;
-		if (large_io)
-			nbhs = (size >> PAGE_SHIFT);
-		else
-			nbhs = (size >> sector_bits);
-		if (nbhs > max_sectors)
-			nbhs = max_sectors;
-
-#ifdef KERNEL_NO_F_IOBUF
-		err = alloc_kiovec_sz (1, &iobuf, &nbhs);
-		if (err)
-			goto out;
-#else
-		if (test_and_set_bit(0, &filp->f_iobuf_lock)) {
-			/*
-			* A parallel read/write is using the preallocated iobuf
-			* so just run slow and allocate a new one.
-			*/
-			err = alloc_kiovec_sz (1, &iobuf, &nbhs);
-			if (err)
-				goto out;
-			new_iobuf = 1;
-		} else
-			new_iobuf = 0;
-				
-#endif
-		inuse = 1;
-
-		totalioblocks = 0;
-		while (size > 0) {
-			if (large_io) {
-				blocks = size >> PAGE_SHIFT;
-				if (blocks > max_sectors)
-					blocks = max_sectors;
-				iosize = blocks << PAGE_SHIFT;
-			} else {
-				blocks = size >> sector_bits;
-				if (blocks > max_sectors)
-					blocks = max_sectors;
-				iosize = blocks << sector_bits;
-			}
-			if (!blocks)
-				break;
-			err = map_user_kiobuf (rw, iobuf, (unsigned long) buf, iosize);
-			if (err)
-				break;
-			/* get the blocknr depending on io size for all blocks */
-			/* since we are awlays within the extent we only need to get the first block */
-			OCFS_KIO_BLOCKS(iobuf)[0] = firstphys + totalioblocks;
-
-			if (large_io) {
-				blocknr += sectors_per_page;
-				OCFS_KIO_BLOCKS(iobuf)[0] = OCFS_KIO_BLOCKS(iobuf)[0] / sectors_per_page;
-			} else {
-				blocknr++;
-			}
-
-			for (i = 1; i < blocks; i++) {
-				if (large_io) {
-					blocknr += sectors_per_page;
-				} else {
-					blocknr++;
-				}
-				OCFS_KIO_BLOCKS(iobuf)[i] = OCFS_KIO_BLOCKS(iobuf)[0] + i;
-			}
-			err = brw_kiovec (rw, 1, &iobuf, inode->i_dev, OCFS_KIO_BLOCKS(iobuf),
-					large_io ? PAGE_SIZE : sector_size);
-#ifdef SUSE
-			if (rw == READ &&  err > 0)
-				mark_dirty_kiobuf(iobuf, err);
-#endif
-			if (err >= 0) {
-				transferred += err;
-				size -= err;
-				buf += err;
-				if (large_io) {
-					totalioblocks +=
-					    (blocks * sectors_per_page);
-				} else {
-					totalioblocks += blocks;
-				}
-			} else {
-				printk( "ocfs_rw_direct : brw_kiovec() %d\n", err);	
-				break;
-			}
-			unmap_kiobuf (iobuf);
-			if (err != iosize)
-				break;
-		}
-#ifdef KERNEL_NO_F_IOBUF
-		free_kiovec_sz(1, &iobuf, &nbhs);
-#else
-		if (!new_iobuf)
-			clear_bit(0, &filp->f_iobuf_lock);
-		else
-			free_kiovec_sz(1, &iobuf, &nbhs);
-#endif
-		inuse = 0;
-		totalioblocks = 0;
-		firstlogic = nextlogic;
-		firstphys = nextphys;
-	}
-	if (transferred) {
-		*offp += transferred;
-		err = transferred;
-	}
-
-out:
-#ifdef KERNEL_NO_F_IOBUF
-	if (inuse)
-	   free_kiovec_sz (1, &iobuf, &nbhs);
-#else
-	if (inuse) {
-		if (!new_iobuf)
-			clear_bit(0, &filp->f_iobuf_lock);
-		else
-			free_kiovec_sz(1, &iobuf, &nbhs);
-	}
-#endif
-	return err;
-}				/* ocfs_rw_direct */
-#endif /* 2.4.x kernel */
-
-#ifdef AIO_ENABLED
-static int ocfs_kvec_rw(struct file *filp, int rw, kvec_cb_t cb,
-		size_t size, loff_t pos)
-{
-	int	     err = 0;
-	int max_sectors = 25000;
-	struct inode *inode = filp->f_dentry->d_inode;
-	unsigned long blocknr, blocks, iosize,myiosize;
-	long firstphys;
-	int clustersize;
-	unsigned long blocks_end_cluster = 0;
- 
-	/* FIXME: Need to differentiate betwen sectors and blocksize */
-	int sector_bits = OCFS_SB(inode->i_sb)->s_sectsize_bits;
-	int sector_size = 1 << OCFS_SB(inode->i_sb)->s_sectsize_bits;
-	int sector_mask = sector_size - 1;
-
-	int ret;
-	unsigned long firstlogic;
-	long nextphys;
-	unsigned long nextlogic = 0;
-	unsigned long totalioblocks = 0;
-
-	if (!size || (pos == inode->i_size)) {
-		cb.fn(cb.data, cb.vec, err);
-		return err;
-	}
-
-	err = -ENXIO;
-	if (pos >= inode->i_size) {
-		return err;
-	}
-
-	err = -EINVAL;
-	if ((pos < 0) || (pos & sector_mask) || (size & sector_mask)) {
-		return err;
-	}
-
-	blocknr = pos >> sector_bits;
-
-	blocks = size >> sector_bits;;
-	if (blocks > max_sectors)
-		blocks = max_sectors;
-	if (!blocks) {
-		err = -ENXIO;
-		return err;;
-	}
-
-	iosize = blocks << sector_bits;
-	clustersize = inode->i_blksize >> sector_bits;
-	blocks_end_cluster = clustersize - (blocknr % clustersize);
-	myiosize = size >> sector_bits;
-	firstlogic = blocknr;
-	totalioblocks = 0;
-
-	err = ocfs_get_block2(inode, blocknr, &firstphys, sector_size);
-	if ( err == -1 ) {
-		err = 0;
-		return err;
-	}
-		if (blocks_end_cluster + 1 > myiosize) {
-			totalioblocks += myiosize;
-			myiosize = 0;
-			goto doio;
-		} else {
-			totalioblocks += blocks_end_cluster;
-			myiosize -= blocks_end_cluster;
-			nextlogic = firstlogic + blocks_end_cluster;
-		}
-again:
-		ret = ocfs_get_block2 (inode, nextlogic, &nextphys, sector_size);
-		if (ret == -1) {
-			err = 0;
-			return err;
-		}
-	    if (nextphys == (firstphys + totalioblocks)) {
-		blocks_end_cluster = clustersize - (nextlogic % clustersize);
-		if (blocks_end_cluster + 1 > myiosize) {
-		   totalioblocks += myiosize;
-		   myiosize = 0;
-		} else {
-		   totalioblocks += blocks_end_cluster;
-		   myiosize -= blocks_end_cluster;
-		   nextlogic = nextlogic + blocks_end_cluster;
-		   goto again;
-		}
-	    }
-doio:
-	blocks = totalioblocks;
-	err = brw_kvec_async(rw, cb, inode->i_dev, blocks, firstphys, sector_bits);
-	return err;
-
-}
-
-int ocfs_kvec_read(struct file *file, kvec_cb_t cb, size_t size, loff_t pos) 
-{
-	int ret;
-
-	LOG_SET_CONTEXT(KVEC_READ);
-
-	ret = ocfs_kvec_rw(file, READ, cb, size, pos);
-
-	LOG_CLEAR_CONTEXT();
-	return ret;
-}
-
-int ocfs_kvec_write(struct file *file, kvec_cb_t cb, size_t size, loff_t pos) 
-{
-	int ret;
-
-	LOG_SET_CONTEXT(KVEC_WRITE);
-
-	ret = ocfs_kvec_rw(file, WRITE, cb, size, pos);
-
-	LOG_CLEAR_CONTEXT();
-	return ret;
-}
-#endif
-
-/*
  * ocfs_inode_revalidate()
  *
  * In 2.4, this is called only from stat.c always without i_sem before
Index: src/aops.c
===================================================================
--- src/aops.c	(revision 0)
+++ src/aops.c	(revision 0)
@@ -0,0 +1,677 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ *
+ * Authors: Kurt Hackel, Mark Fasheh, Sunil Mushran, Wim Coekaerts,
+ *	    Manish Singh, Neeraj Goyal, Suchit Kaura
+ */
+#include "ocfs_compat.h"
+
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <asm/byteorder.h>
+
+#include "ocfs_log.h"
+#include "ocfs.h"
+
+#include "alloc.h"
+#include "buffer_head_io.h"
+#include "file.h"
+#include "inode.h"
+#include "ocfs_journal.h"
+
+
+#define OCFS_DEBUG_CONTEXT    OCFS_DEBUG_CONTEXT_INODE
+
+static int ocfs_symlink_get_block(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh_result, int create)
+{
+	int err = -EIO;
+	int status;
+	ocfs2_dinode *fe = NULL;
+	struct buffer_head *bh = NULL;
+	struct buffer_head *buffer_cache_bh = NULL;
+	ocfs_super *osb = OCFS_SB(inode->i_sb);
+	void *kaddr;
+
+	LOG_ENTRY_ARGS("(0x%p, %llu, 0x%p, %d)\n", inode,
+			(unsigned long long)iblock, bh_result, create);
+
+	if ((iblock << inode->i_sb->s_blocksize_bits) > PATH_MAX + 1) {
+		LOG_ERROR_ARGS ("block offset > PATH_MAX: %llu",
+				(unsigned long long)iblock);
+		goto bail;
+	}
+
+	status = ocfs_read_bh(OCFS_SB(inode->i_sb),
+			      OCFS_I(inode)->ip_blkno <<
+			      	inode->i_sb->s_blocksize_bits,
+			      &bh,
+			      OCFS_BH_CACHED, inode);
+	if (status < 0) {
+		LOG_ERROR_STATUS (status);
+		goto bail;
+	}
+	fe = (ocfs2_dinode *) bh->b_data;
+
+	if (!IS_VALID_FILE_ENTRY(fe)) {
+		LOG_ERROR_ARGS("Invalid fe at blkno %llu",
+			       OCFS_I(inode)->ip_blkno);
+		goto bail;
+	}
+
+	if ((u64)iblock >= ocfs_clusters_to_blocks(inode->i_sb,
+					      fe->i_clusters)) {
+		LOG_ERROR_ARGS ("block offset is outside the allocated size: %llu",
+		     (unsigned long long)iblock);
+		goto bail;
+	}
+
+	/* We don't use the page cache to create symlink data, so if
+	 * need be, copy it over from the buffer cache. */
+	if (!buffer_uptodate(bh_result) && !ocfs_inode_is_new(osb, inode)) {
+		buffer_cache_bh = sb_getblk(osb->sb, 
+					    fe->id2.i_list.l_recs[0].e_blkno + iblock);
+		if (!buffer_cache_bh) {
+			LOG_ERROR_STR("couldn't getblock for symlink!");
+			goto bail;
+		}
+
+		/* we haven't locked out transactions, so a commit
+		 * could've happened. Since we've got a reference on
+		 * the bh, even if it commits while we're doing the
+		 * copy, the data is still good. */
+		if (buffer_jbd(buffer_cache_bh) 
+		    && !ocfs_inode_is_new(osb, inode)) {
+			kaddr = kmap_atomic(bh_result->b_page, KM_USER0);
+			if (!kaddr) {
+				LOG_ERROR_ARGS("couldn't kmap!\n");
+				goto bail;
+			}
+			memcpy(kaddr + (bh_result->b_size * iblock), 
+			       buffer_cache_bh->b_data, 
+			       bh_result->b_size);
+			kunmap_atomic(kaddr, KM_USER0);
+			set_buffer_uptodate(bh_result);
+		}
+		brelse(buffer_cache_bh);
+	}
+
+	map_bh(bh_result, inode->i_sb,
+	       fe->id2.i_list.l_recs[0].e_blkno + iblock);
+
+	err = 0;
+
+bail:
+	if (bh)
+		brelse(bh);
+
+	LOG_EXIT_INT (err);
+	return err;
+}
+
+static int ocfs_get_block(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh_result, int create)
+{
+	int err = -EIO;
+	__s64 vbo = 0;
+	__s64 lbo = 0;
+	__u32 len;
+	int open_direct;
+
+	LOG_ENTRY_ARGS("(0x%p, %llu, 0x%p, %d)\n", inode,
+			(unsigned long long)iblock, bh_result, create);
+
+	if (OCFS_I(inode)->ip_flags & OCFS_INODE_SYSTEM_FILE) {
+		printk("get_block on system inode 0x%p (%lu)\n",
+		       inode, inode->i_ino);
+	}
+
+	open_direct = OCFS_I(inode)->ip_open_flags & OCFS_OIN_OPEN_FOR_DIRECTIO;
+
+	if (S_ISLNK(inode->i_mode)) {
+		/* this always does I/O for some reason. */
+		down_read(&OCFS_I(inode)->ip_io_sem);
+		err = ocfs_symlink_get_block (inode, iblock, bh_result, 
+					      create);
+		up_read(&OCFS_I(inode)->ip_io_sem);
+		goto bail;
+	}
+
+	vbo = (__s64) iblock << inode->i_sb->s_blocksize_bits;
+
+#if 0
+	if (!INODE_JOURNAL(inode) && vbo >= OCFS_I(inode)->ip_alloc_size) {
+		int vbo_pad;
+		
+		vbo_pad = inode->i_sb->s_blocksize;
+		vbo_pad -= vbo & (s64)(inode->i_sb->s_blocksize - 1);
+
+		LOG_TRACE_STR("Extending allocation");
+		LOG_ERROR_ARGS("extending inode %lu in get_block!!\n", 
+			       inode->i_ino);
+		down_write(&OCFS_I(inode)->ip_io_sem);
+		err = ocfs_extend_file(osb, vbo + vbo_pad, 
+				       NULL, inode, NULL, 0, NULL);
+		up_write(&OCFS_I(inode)->ip_io_sem);
+		if (err < 0) {
+			err = -ENOSPC;
+			LOG_ERROR_STATUS (err);
+			goto bail;
+		}
+	}
+#else
+	if (vbo >= OCFS_I(inode)->ip_alloc_size) {
+		err = -EIO;
+		LOG_ERROR_ARGS("Trying to extend in ocfs_get_block() "
+			"(inode %llu, blkno %llu, vbo %llu, alloc %llu)\n",
+			OCFS_I(inode)->ip_blkno, (u64)iblock, (u64)vbo,
+			OCFS_I(inode)->ip_alloc_size);
+		goto bail;
+	}
+#endif
+
+	len = inode->i_sb->s_blocksize;
+	if (!open_direct)
+		down_read(&OCFS_I(inode)->ip_extend_sem);
+	err = ocfs_lookup_file_allocation(OCFS2_SB(inode->i_sb),
+					  vbo, &lbo, len, NULL, 
+					  inode, open_direct);
+	if (!open_direct)
+		up_read(&OCFS_I(inode)->ip_extend_sem);
+
+	if (err < 0) {
+		LOG_ERROR_ARGS("vbo=%lld lbo=%lld len=%u", vbo, lbo, len);
+		goto bail;
+	}
+
+	map_bh(bh_result, inode->i_sb, lbo >> inode->i_sb->s_blocksize_bits);
+
+	err = 0;
+
+	if (bh_result->b_blocknr == 0) {
+		err = -EIO;
+		LOG_ERROR_ARGS ("vbo=%lld lbo=%lld len=%u, blkno=(%llu)\n",
+				vbo, lbo, len, 
+				OCFS_I(inode)->ip_blkno);
+	}
+
+	if (vbo < OCFS_I(inode)->ip_mmu_private)
+		goto bail;
+	if (!create)
+		goto bail;
+	if (vbo != OCFS_I(inode)->ip_mmu_private) {
+		LOG_ERROR_ARGS("Uh-oh, vbo = %lld, i_size = %llu, mmu = %llu, "
+			       "inode = %llu\n",
+			       vbo, inode->i_size, 
+			       OCFS_I(inode)->ip_mmu_private,
+			       OCFS_I(inode)->ip_blkno);
+		BUG();
+		err = -EIO;
+		goto bail;
+	}
+
+	bh_result->b_state |= (1UL << BH_New);
+	OCFS_I(inode)->ip_mmu_private += inode->i_sb->s_blocksize;
+
+bail:
+	if (err < 0)
+		err = -EIO;
+
+	LOG_EXIT_INT (err);
+	return err;
+}
+
+static int ocfs_readpage(struct file *file, struct page *page)
+{
+	int ret;
+
+	LOG_SET_CONTEXT(READPAGE);
+	LOG_ENTRY_ARGS("(0x%p, %lu)\n", file, (page ? page->index : 0));
+
+	ret = block_read_full_page(page, ocfs_get_block);
+
+	LOG_EXIT_INT(ret);
+	LOG_CLEAR_CONTEXT();
+	return ret;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static int ocfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	int ret;
+
+	LOG_SET_CONTEXT(WRITEPAGE);
+	LOG_ENTRY_ARGS("(0x%p)\n", page);
+
+	ret = block_write_full_page(page, ocfs_get_block, wbc);
+
+	LOG_EXIT_INT(ret);
+	LOG_CLEAR_CONTEXT();
+	return ret;
+}
+#else
+static int ocfs_writepage(struct page *page)
+{
+	int ret;
+
+	LOG_SET_CONTEXT(WRITEPAGE);
+	LOG_ENTRY_ARGS("(0x%p)\n", page);
+
+	ret = block_write_full_page(page, ocfs_get_block);
+
+	LOG_EXIT_INT(ret);
+	LOG_CLEAR_CONTEXT();
+	return ret;
+}
+#endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+inline void __mark_dirty(struct buffer_head *bh)
+{
+	set_buffer_flushtime(bh);
+	refile_buffer(bh);
+}
+
+static int __block_commit_write(struct inode *inode, struct page *page,
+		unsigned from, unsigned to)
+{
+	unsigned block_start, block_end;
+	int partial = 0, need_balance_dirty = 0;
+	unsigned blocksize;
+	struct buffer_head *bh, *head;
+
+	blocksize = 1 << inode->i_blkbits;
+
+	for(bh = head = page->buffers, block_start = 0;
+	    bh != head || !block_start;
+	    block_start=block_end, bh = bh->b_this_page) {
+		block_end = block_start + blocksize;
+		if (block_end <= from || block_start >= to) {
+			if (!buffer_uptodate(bh))
+				partial = 1;
+		} else {
+			set_bit(BH_Uptodate, &bh->b_state);
+			if (!atomic_set_buffer_dirty(bh)) {
+				__mark_dirty(bh);
+				buffer_insert_inode_data_queue(bh, inode);
+				need_balance_dirty = 1;
+			}
+		}
+	}
+
+	if (need_balance_dirty)
+		balance_dirty();
+	/*
+	 * is this a partial write that happened to make all buffers
+	 * uptodate then we can optimize away a bogus readpage() for
+	 * the next read(). Here we 'discover' wether the page went
+	 * uptodate as a result of this (potentially partial) write.
+	 */
+	if (!partial)
+		SetPageUptodate(page);
+	return 0;
+}
+
+static int ocfs2_cont_prepare_write(struct page *page, unsigned offset,
+		unsigned to, get_block_t *get_block, loff_t *bytes)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	struct page *new_page;
+	unsigned long pgpos;
+	long status;
+	unsigned zerofrom;
+	unsigned blocksize = 1 << inode->i_blkbits;
+	char *kaddr;
+
+	while (page->index > (pgpos = *bytes>>PAGE_CACHE_SHIFT)) {
+		status = -ENOMEM;
+		new_page = grab_cache_page(mapping, pgpos);
+		if (!new_page)
+			goto out;
+		/* we might sleep */
+		if (*bytes>>PAGE_CACHE_SHIFT != pgpos) {
+			unlock_page(new_page);
+			page_cache_release(new_page);
+			continue;
+		}
+		zerofrom = *bytes & ~PAGE_CACHE_MASK;
+		if (zerofrom & (blocksize-1)) {
+			*bytes |= (blocksize-1);
+			(*bytes)++;
+		}
+		status = block_prepare_write(new_page, zerofrom,
+					     PAGE_CACHE_SIZE, get_block);
+		if (status)
+			goto out_unmap;
+		kaddr = page_address(new_page);
+		memset(kaddr+zerofrom, 0, PAGE_CACHE_SIZE-zerofrom);
+		flush_dcache_page(new_page);
+		__block_commit_write(inode, new_page, zerofrom, PAGE_CACHE_SIZE);
+		kunmap(new_page);
+		unlock_page(new_page);
+		page_cache_release(new_page);
+	}
+
+	if (page->index < pgpos) {
+		/* completely inside the area */
+		zerofrom = offset;
+	} else {
+		/* page covers the boundary, find the boundary offset */
+		zerofrom = *bytes & ~PAGE_CACHE_MASK;
+
+		/* if we will expand the thing last block will be filled */
+		if (to > zerofrom && (zerofrom & (blocksize-1))) {
+			*bytes |= (blocksize-1);
+			(*bytes)++;
+		}
+
+		/* starting below the boundary? Nothing to zero out */
+		if (offset <= zerofrom)
+			zerofrom = offset;
+	}
+	status = block_prepare_write(page, zerofrom, to, get_block);
+	if (status)
+		goto out1;
+	kaddr = page_address(page);
+	if (zerofrom < offset) {
+		memset(kaddr+zerofrom, 0, offset-zerofrom);
+		flush_dcache_page(page);
+		__block_commit_write(inode, page, zerofrom, offset);
+	}
+	return 0;
+out1:
+	ClearPageUptodate(page);
+	kunmap(page);
+	return status;
+
+out_unmap:
+	ClearPageUptodate(new_page);
+	kunmap(new_page);
+	UnlockPage(new_page);
+	page_cache_release(new_page);
+out:
+	return status;
+}
+
+/* Mark's favorite hack */
+#undef cont_prepare_write
+#define cont_prepare_write ocfs2_cont_prepare_write
+#endif  /* < 2.6.0 */
+
+/*
+ * ocfs_prepare_write()
+ *
+ */
+static int ocfs_prepare_write(struct file *file, struct page *page,
+		unsigned from, unsigned to)
+{
+	int ret;
+
+	LOG_SET_CONTEXT(PREPARE_WRITE);
+	LOG_ENTRY_ARGS("(0x%p, 0x%p, %u, %u)\n", file, page, from, to);
+
+	ret = cont_prepare_write(page, from, to, ocfs_get_block,
+		&(OCFS_I(page->mapping->host)->ip_mmu_private));
+
+	LOG_EXIT_INT(ret);
+	LOG_CLEAR_CONTEXT();
+	return ret;
+}
+
+/*
+ * ocfs_commit_write()
+ *
+ */
+static int ocfs_commit_write(struct file *file, struct page *page,
+		unsigned from, unsigned to)
+{
+	int ret;
+
+	LOG_SET_CONTEXT(COMMIT_WRITE);
+	LOG_ENTRY_ARGS("(0x%p, 0x%p, %u, %u)\n", file, page, from, to);
+
+	ret = generic_commit_write(file, page, from, to);
+
+	LOG_EXIT_INT(ret);
+	LOG_CLEAR_CONTEXT();
+	return ret;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static sector_t ocfs_bmap(struct address_space *mapping, sector_t block) 
+#else
+static int ocfs_bmap(struct address_space *mapping, long block) 
+#endif
+{
+	int disk_block = 0;
+	ocfs_super *osb = OCFS_SB(mapping->host->i_sb);
+	__s64 vbo = 0;
+	__s64 lbo = 0;
+	__u32 len;
+	int err = 0, status;
+	struct inode *inode = mapping->host;
+
+	LOG_SET_CONTEXT(BMAP);
+	LOG_ENTRY_ARGS("(block = %llu)\n", (unsigned long long)block);
+
+	if (!INODE_JOURNAL(inode)) {
+		LOG_ERROR_STR("bmap is only for journal inodes!");
+		err = -EINVAL;
+		LOG_ERROR_STATUS(err);
+		goto bail;
+	}
+
+	vbo = (__s64) block << inode->i_sb->s_blocksize_bits;
+	len = osb->sb->s_blocksize;
+	err = ocfs_lookup_file_allocation(osb, vbo, &lbo, len, NULL, 
+					   inode, 1);
+	if (err < 0) {
+		LOG_ERROR_ARGS ("vbo=%lld lbo=%lld len=%u", vbo,
+				lbo, len);
+		LOG_ERROR_STATUS(err);
+		goto bail;
+	}
+
+	disk_block = lbo >> inode->i_sb->s_blocksize_bits;
+
+bail:
+	status = err ? err : disk_block;
+
+	LOG_EXIT_STATUS(status);
+	LOG_CLEAR_CONTEXT();
+	return status;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+/*
+ * TODO: Make this into a generic get_blocks function.
+ *
+ * From do_direct_io in direct-io.c:
+ *  "So what we do is to permit the ->get_blocks function to populate 
+ *   bh.b_size with the size of IO which is permitted at this offset and 
+ *   this i_blkbits."
+ *
+ * This function is called directly from get_more_blocks in direct-io.c.
+ *
+ * We should probably have this data in the oin for the inode.
+ * Otherwise, we might want to look at ocfs_rw_direct, 
+ *  ocfs_lookup_file_allocation and ocfs_get_block
+ *
+ * called like this: dio->get_blocks(dio->inode, fs_startblk,
+ * 					fs_count, map_bh, dio->rw == WRITE);
+ */
+static int ocfs_direct_IO_get_blocks(struct inode *inode, sector_t iblock, unsigned long max_blocks, struct buffer_head *bh_result, int create)
+{
+	int ret = -1;
+	int status;
+	ocfs_super *osb = NULL;
+	__s64 vbo; /* file offset */
+	__s64 lbo; /* logical (disk) offset */
+	__s64 vbo_max; /* file offset, max_blocks from iblock */
+	int set_new = 0; /* flag */
+	__u64 new_size; /* In bytes, the size of the contiguous block */
+	unsigned char blocksize_bits;
+
+	if (!inode || !bh_result) {
+		LOG_ERROR_STR("ocfs_direct_IO_get_blocks: inode or bh_result is null");
+		return -EIO;
+	}
+
+	osb = inode->i_sb->s_fs_info;
+	blocksize_bits = inode->i_sb->s_blocksize_bits;
+	/* make sure we're up to date... */
+	if (atomic_read(&OCFS_I(inode)->ip_needs_verification)) {
+		LOG_TRACE_STR ("ocfs_direct_IO_get_blocks: verify oin.");
+		status = ocfs_verify_update_inode (osb, inode, 0);
+		if (status < 0) {
+			LOG_TRACE_STR ("ocfs_verify_update_inode failed");
+			ret = -EIO;
+			goto bail;
+		}
+	}
+
+	/* This function won't even be called if the request isn't all
+	 * nicely aligned and of the right size, so there's no need
+	 * for us to check any of that. */
+
+	vbo = (__s64) iblock << blocksize_bits;
+	vbo_max = vbo + ((__s64) max_blocks << blocksize_bits);
+
+	/* NOTE: create flag is set when we ?may? have to allocate some
+	   blocks for the file. */
+	if (create && vbo_max > OCFS_I(inode)->ip_alloc_size) {
+		/* WARNING: How much do we really want to extend the file? */
+		status = ocfs_extend_file(osb, vbo_max,
+					  NULL, inode, NULL, 0, NULL);
+		if (status < 0) {
+			status = -ENOSPC;
+			LOG_ERROR_STR("ocfs_direct_IO_get_blocks: failed to extend the file!");
+			goto bail;
+		}
+		set_new = 1;
+	}
+
+	/* This figure out the size of the next contiguous block, and
+	 * our logical offset */	
+	/* TODO: Try our damndest to give sizes in multiples of PAGE_SIZE */
+	status = ocfs_lookup_file_allocation(osb, vbo, &lbo, max_blocks << blocksize_bits, 
+					     &new_size, inode, 1);
+
+	/* Do whatever we need to the buffer_head */
+	if (set_new) {
+		set_buffer_new(bh_result);
+		/* Do we really want to set bh_result->b_blocknr here too? */
+		bh_result->b_blocknr = lbo >> blocksize_bits;
+	} else {
+		clear_buffer_new(bh_result);
+		/* is the last argument here correct? */
+		map_bh(bh_result, inode->i_sb, lbo >> blocksize_bits);
+	}
+
+	/* make sure we don't map more than max_blocks blocks here as
+	   that's all the kernel will handle at this point. */
+	if (new_size > (__u64)max_blocks << blocksize_bits)
+		new_size = (__u64)max_blocks << blocksize_bits;
+	bh_result->b_size = new_size;
+
+	ret = 0;
+bail:
+	return ret;
+}
+
+/*
+ * ocfs_direct_IO()
+ * used to be: 
+ * static int ocfs_direct_IO (int rw,
+ *	       struct inode *inode,
+ *	       struct kiobuf *iobuf, unsigned long blocknr, int blocksize)
+ *
+ * now:         
+  static int ocfs_direct_IO(int rw, struct kiocb *iocb,
+			const struct iovec *iov, loff_t offset,
+			unsigned long nr_segs)
+ * int (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
+ *                  loff_t offset, unsigned long nr_segs);
+ */
+static ssize_t ocfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_dentry->d_inode->i_mapping->host;
+	int ret;
+
+	LOG_SET_CONTEXT(DIRECT_IO);
+
+	LOG_ENTRY ();
+
+	/* blockdev_direct_IO checks alignment for us, using */
+	ret = blockdev_direct_IO (rw, iocb, inode, inode->i_sb->s_bdev, iov, offset, nr_segs, ocfs_direct_IO_get_blocks, NULL);
+
+	LOG_EXIT_INT (ret);
+
+	LOG_CLEAR_CONTEXT();
+	return ret;
+}				/* ocfs_direct_IO */
+
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,10)
+/*
+ * ocfs_direct_IO()
+ *
+ * we are not using this function anymore, in fact
+ * we should never get here any more
+ * so let's just BUG(), hint from sct@redhat.com
+ */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined(SUSE)
+static int ocfs_direct_IO (int rw, struct file *filp, struct kiobuf *iobuf, unsigned long blocknr, int blocksize)
+{
+	BUG();
+	return 0;
+}				/* ocfs_direct_IO */
+#else
+static int ocfs_direct_IO (int rw, struct inode *inode, struct kiobuf *iobuf, unsigned long blocknr, int blocksize)
+{
+	BUG();
+	return 0;
+}				/* ocfs_direct_IO */
+#endif
+#endif  /* version >= 2.4.10 */
+
+
+struct address_space_operations ocfs_aops = {
+	.readpage	= ocfs_readpage,
+	.writepage	= ocfs_writepage,
+	.prepare_write	= ocfs_prepare_write,
+	.commit_write	= ocfs_commit_write,
+	.bmap		= ocfs_bmap,
+
+	/*
+	 * On a 2.4 system, we are only adding this here as a dummy basically.
+	 * Just need open with O_DIRECT to succeed, we still call
+	 * ocfs_rw_direct().
+	 *
+	 * For a 2.6 system, this is the way a filesystem provides
+	 * direct-io support. 
+	 */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,10)
+	.direct_IO	= ocfs_direct_IO
+#endif
+};
Index: src/24io.c
===================================================================
--- src/24io.c	(revision 0)
+++ src/24io.c	(revision 0)
@@ -0,0 +1,481 @@
+
+#include <linux/version.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+
+#define KERNEL_NO_F_IOBUF
+#include "ocfs_compat.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/iobuf.h>
+
+#include <asm/byteorder.h>
+
+#include "ocfs_log.h"
+#include "ocfs.h"
+
+#include "alloc.h"
+#include "dlm.h"
+#include "extmap.h"
+#include "file.h"
+#include "inode.h"
+#include "lockres.h"
+#include "namei.h"
+#include "super.h"
+#include "symlink.h"
+#include "sysfile.h"
+#include "util.h"
+#include "vote.h"
+
+#include "ocfs_journal.h"
+#include "buffer_head_io.h"
+
+#define OCFS_DEBUG_CONTEXT    OCFS_DEBUG_CONTEXT_INODE
+
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
+# define free_kiovec_sz(nr, buf, bh)     free_kiovec(nr, buf)
+# define alloc_kiovec_sz(nr, buf, bh)    alloc_kiovec(nr, buf)
+#endif
+
+#if defined(SUSE) && LINUX_VERSION_CODE < KERNEL_VERSION(2,4,20)
+#define OCFS_KIO_BLOCKS(_iobuf)  ((_iobuf)->kio_blocks)
+#else
+#define OCFS_KIO_BLOCKS(_iobuf)  ((_iobuf)->blocks)
+#endif
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,4,10)
+#define KERNEL_NO_F_IOBUF 1
+#elif defined(SUSE) && LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20)
+#define KERNEL_NO_F_IOBUF 1
+#endif
+
+static int ocfs_get_block2 (struct inode *inode, long iblock, long *oblock, int len)
+{
+	int err = -EIO;
+	ocfs_super *osb;
+	__s64 vbo = 0;
+	__s64 lbo = 0;
+
+	LOG_ENTRY_ARGS ("(0x%p, %ld)\n", inode, iblock);
+
+	if (!inode) {
+		LOG_ERROR_STR ("bad inode");
+		err = -1;
+		goto bail;
+	}
+
+	osb = OCFS_SB(inode->i_sb);
+
+	vbo = (__s64) iblock << osb->s_sectsize_bits;
+	err = ocfs_lookup_file_allocation(osb, vbo, &lbo, len, NULL, 
+					   inode, 1);
+	if (err < 0) {
+		LOG_ERROR_STATUS (err);
+		err = -1;
+		goto bail;
+	}
+
+	err = 0;
+
+	*oblock = lbo >> osb->s_sectsize_bits;
+	if (*oblock == 0) {
+		err = -EIO;
+		LOG_ERROR_ARGS ("vbo=%lld lbo=%lld len=%u, blkno=(%llu)\n",
+				vbo, lbo, len, 
+				OCFS_I(inode)->ip_blkno);
+	}
+
+bail:
+	if (err < 0)
+		err = -EIO;
+	LOG_EXIT_INT (err);
+	return err;
+}				/* ocfs_get_block2 */
+
+/*
+ * ocfs_rw_direct()
+ *
+ */
+ssize_t ocfs_rw_direct (int rw, struct file *filp, char *buf, size_t size, loff_t * offp)
+{
+#ifdef KERNEL_NO_F_IOBUF
+	struct kiobuf *iobuf;
+#else
+	struct kiobuf *iobuf = filp->f_iobuf;
+	int new_iobuf = 0;
+#endif
+	int err = 0;
+	unsigned long blocknr, blocks, myiosize;
+	size_t transferred;
+	int iosize, clustersize;
+	int i;
+	struct inode *inode = filp->f_dentry->d_inode;
+	int max_sectors;
+	int nbhs;
+	int sector_size, sector_bits, sector_mask, sectors_per_page;
+	int ret = 0;
+	int large_io = 0;
+	int inuse = 0;
+	unsigned long blocks_end_cluster = 0;
+	loff_t saved_off;
+	size_t saved_size;
+	unsigned long firstlogic;
+	long firstphys;
+	long nextphys;
+	unsigned long nextlogic = 0;
+	unsigned long totalioblocks = 0;
+
+	saved_off = *offp;
+	saved_size = size;
+	
+	/* FIXME: Need to differentiate between sectors and blocksize */
+	sector_bits = OCFS_SB(inode->i_sb)->s_sectsize_bits;
+	sector_size = 1 << OCFS_SB(inode->i_sb)->s_sectsize_bits;
+	sector_mask = sector_size - 1;
+	sectors_per_page = PAGE_SIZE / sector_size;
+	/* max sectors is 1024 in 2.4.9
+	 * max data is 512kb  
+	 */
+
+	err = -EINVAL;
+	if (size == 0) {
+		printk("direct write of 0 byte\n");
+		return 0;
+	}
+
+	if (rw == READ) {
+	   if (inode->i_size <= *offp) /* read past end of file */
+	      return 0;
+	   if  (size > (inode->i_size - *offp))
+	      size = inode->i_size - *offp;
+	}
+
+	/* make sure aligned to either PAGE_SIZE or sect_size IO */
+#ifndef LARGEIOS
+	if ((*offp & sector_mask) || (size & sector_mask)) 
+	   /* if not, then fail, we need either to do dio */
+	   return err;
+
+	max_sectors = KIO_MAX_SECTORS;
+	large_io = 0;
+#endif
+#ifdef LARGEIOS	
+	if ((*offp & ~PAGE_MASK) || (size & ~PAGE_MASK)) {
+		/* if it's not PAGE_SIZE, then sect_size */
+		 if ((*offp & sector_mask) || (size & sector_mask))
+			 /* if not, then fail, we need either to do dio */
+			 return err;
+		 max_sectors = KIO_MAX_SECTORS; /* for 2.4.9 - 1024 */
+	} /* ok we 're PAGE_SIZE aligned, lets see if the buffer is */
+	else {
+		if (!((unsigned long) buf & ~PAGE_MASK)) {
+			/* yippie we are .. we can do PAGE_SIZE size io's */
+			large_io = 1;
+			/* for 2.4.9 */
+			max_sectors = KIO_MAX_SECTORS / sectors_per_page;
+		} else {
+			max_sectors = KIO_MAX_SECTORS;
+			large_io = 0;
+		}
+
+	}	
+#endif
+	/* find out how far we are to the end of our cluster */
+
+	err = 0;
+	if (size)
+		err = -ENXIO;
+
+	/* Split the IO into KIO_MAX_SECTORS chunks, mapping and */
+	/* unmapping the single kiobuf as we go to perform each chunk of IO. */
+
+	transferred = 0;
+	blocknr = *offp >> sector_bits;
+	clustersize = inode->i_blksize >> sector_bits;
+	myiosize = size >> sector_bits;
+	blocks_end_cluster = clustersize - (blocknr % clustersize);
+	firstlogic = blocknr;
+	totalioblocks = 0;
+
+	ret = ocfs_get_block2 (inode, blocknr, &firstphys, sector_size);
+	if (ret == -1) {
+		err = 0;
+		goto out;
+	}
+	while (myiosize > 0) {
+	    if (blocks_end_cluster + 1 > myiosize) {
+		totalioblocks += myiosize;
+		myiosize = 0;
+		goto doio;
+	    } else {
+		totalioblocks += blocks_end_cluster;
+		myiosize -= blocks_end_cluster;
+		nextlogic = firstlogic + blocks_end_cluster;
+	    }
+again:
+	    ret = ocfs_get_block2 (inode, nextlogic, &nextphys, sector_size);
+	    if (ret == -1) {
+		err = 0;
+		goto out;
+	    }
+	    if (nextphys == (firstphys + totalioblocks)) {
+		// merge ok
+		blocks_end_cluster = clustersize - (nextlogic % clustersize);
+		if (blocks_end_cluster + 1 > myiosize) {
+		   totalioblocks += myiosize;
+		   myiosize = 0;
+		} else {
+		   totalioblocks += blocks_end_cluster;
+		   myiosize -= blocks_end_cluster;
+		   nextlogic = nextlogic + blocks_end_cluster;
+		   goto again;
+		}
+	    }
+doio:
+		size = totalioblocks << sector_bits;
+		if (large_io)
+			nbhs = (size >> PAGE_SHIFT);
+		else
+			nbhs = (size >> sector_bits);
+		if (nbhs > max_sectors)
+			nbhs = max_sectors;
+
+#ifdef KERNEL_NO_F_IOBUF
+		err = alloc_kiovec_sz (1, &iobuf, &nbhs);
+		if (err)
+			goto out;
+#else
+		if (test_and_set_bit(0, &filp->f_iobuf_lock)) {
+			/*
+			* A parallel read/write is using the preallocated iobuf
+			* so just run slow and allocate a new one.
+			*/
+			err = alloc_kiovec_sz (1, &iobuf, &nbhs);
+			if (err)
+				goto out;
+			new_iobuf = 1;
+		} else
+			new_iobuf = 0;
+				
+#endif
+		inuse = 1;
+
+		totalioblocks = 0;
+		while (size > 0) {
+			if (large_io) {
+				blocks = size >> PAGE_SHIFT;
+				if (blocks > max_sectors)
+					blocks = max_sectors;
+				iosize = blocks << PAGE_SHIFT;
+			} else {
+				blocks = size >> sector_bits;
+				if (blocks > max_sectors)
+					blocks = max_sectors;
+				iosize = blocks << sector_bits;
+			}
+			if (!blocks)
+				break;
+			err = map_user_kiobuf (rw, iobuf, (unsigned long) buf, iosize);
+			if (err)
+				break;
+			/* get the blocknr depending on io size for all blocks */
+			/* since we are awlays within the extent we only need to get the first block */
+			OCFS_KIO_BLOCKS(iobuf)[0] = firstphys + totalioblocks;
+
+			if (large_io) {
+				blocknr += sectors_per_page;
+				OCFS_KIO_BLOCKS(iobuf)[0] = OCFS_KIO_BLOCKS(iobuf)[0] / sectors_per_page;
+			} else {
+				blocknr++;
+			}
+
+			for (i = 1; i < blocks; i++) {
+				if (large_io) {
+					blocknr += sectors_per_page;
+				} else {
+					blocknr++;
+				}
+				OCFS_KIO_BLOCKS(iobuf)[i] = OCFS_KIO_BLOCKS(iobuf)[0] + i;
+			}
+			err = brw_kiovec (rw, 1, &iobuf, inode->i_dev, OCFS_KIO_BLOCKS(iobuf),
+					large_io ? PAGE_SIZE : sector_size);
+#ifdef SUSE
+			if (rw == READ &&  err > 0)
+				mark_dirty_kiobuf(iobuf, err);
+#endif
+			if (err >= 0) {
+				transferred += err;
+				size -= err;
+				buf += err;
+				if (large_io) {
+					totalioblocks +=
+					    (blocks * sectors_per_page);
+				} else {
+					totalioblocks += blocks;
+				}
+			} else {
+				printk( "ocfs_rw_direct : brw_kiovec() %d\n", err);	
+				break;
+			}
+			unmap_kiobuf (iobuf);
+			if (err != iosize)
+				break;
+		}
+#ifdef KERNEL_NO_F_IOBUF
+		free_kiovec_sz(1, &iobuf, &nbhs);
+#else
+		if (!new_iobuf)
+			clear_bit(0, &filp->f_iobuf_lock);
+		else
+			free_kiovec_sz(1, &iobuf, &nbhs);
+#endif
+		inuse = 0;
+		totalioblocks = 0;
+		firstlogic = nextlogic;
+		firstphys = nextphys;
+	}
+	if (transferred) {
+		*offp += transferred;
+		err = transferred;
+	}
+
+out:
+#ifdef KERNEL_NO_F_IOBUF
+	if (inuse)
+	   free_kiovec_sz (1, &iobuf, &nbhs);
+#else
+	if (inuse) {
+		if (!new_iobuf)
+			clear_bit(0, &filp->f_iobuf_lock);
+		else
+			free_kiovec_sz(1, &iobuf, &nbhs);
+	}
+#endif
+	return err;
+}				/* ocfs_rw_direct */
+
+#ifdef AIO_ENABLED
+static int ocfs_kvec_rw(struct file *filp, int rw, kvec_cb_t cb,
+		size_t size, loff_t pos)
+{
+	int	     err = 0;
+	int max_sectors = 25000;
+	struct inode *inode = filp->f_dentry->d_inode;
+	unsigned long blocknr, blocks, iosize,myiosize;
+	long firstphys;
+	int clustersize;
+	unsigned long blocks_end_cluster = 0;
+ 
+	/* FIXME: Need to differentiate betwen sectors and blocksize */
+	int sector_bits = OCFS_SB(inode->i_sb)->s_sectsize_bits;
+	int sector_size = 1 << OCFS_SB(inode->i_sb)->s_sectsize_bits;
+	int sector_mask = sector_size - 1;
+
+	int ret;
+	unsigned long firstlogic;
+	long nextphys;
+	unsigned long nextlogic = 0;
+	unsigned long totalioblocks = 0;
+
+	if (!size || (pos == inode->i_size)) {
+		cb.fn(cb.data, cb.vec, err);
+		return err;
+	}
+
+	err = -ENXIO;
+	if (pos >= inode->i_size) {
+		return err;
+	}
+
+	err = -EINVAL;
+	if ((pos < 0) || (pos & sector_mask) || (size & sector_mask)) {
+		return err;
+	}
+
+	blocknr = pos >> sector_bits;
+
+	blocks = size >> sector_bits;;
+	if (blocks > max_sectors)
+		blocks = max_sectors;
+	if (!blocks) {
+		err = -ENXIO;
+		return err;;
+	}
+
+	iosize = blocks << sector_bits;
+	clustersize = inode->i_blksize >> sector_bits;
+	blocks_end_cluster = clustersize - (blocknr % clustersize);
+	myiosize = size >> sector_bits;
+	firstlogic = blocknr;
+	totalioblocks = 0;
+
+	err = ocfs_get_block2(inode, blocknr, &firstphys, sector_size);
+	if ( err == -1 ) {
+		err = 0;
+		return err;
+	}
+		if (blocks_end_cluster + 1 > myiosize) {
+			totalioblocks += myiosize;
+			myiosize = 0;
+			goto doio;
+		} else {
+			totalioblocks += blocks_end_cluster;
+			myiosize -= blocks_end_cluster;
+			nextlogic = firstlogic + blocks_end_cluster;
+		}
+again:
+		ret = ocfs_get_block2 (inode, nextlogic, &nextphys, sector_size);
+		if (ret == -1) {
+			err = 0;
+			return err;
+		}
+	    if (nextphys == (firstphys + totalioblocks)) {
+		blocks_end_cluster = clustersize - (nextlogic % clustersize);
+		if (blocks_end_cluster + 1 > myiosize) {
+		   totalioblocks += myiosize;
+		   myiosize = 0;
+		} else {
+		   totalioblocks += blocks_end_cluster;
+		   myiosize -= blocks_end_cluster;
+		   nextlogic = nextlogic + blocks_end_cluster;
+		   goto again;
+		}
+	    }
+doio:
+	blocks = totalioblocks;
+	err = brw_kvec_async(rw, cb, inode->i_dev, blocks, firstphys, sector_bits);
+	return err;
+
+}
+
+int ocfs_kvec_read(struct file *file, kvec_cb_t cb, size_t size, loff_t pos) 
+{
+	int ret;
+
+	LOG_SET_CONTEXT(KVEC_READ);
+
+	ret = ocfs_kvec_rw(file, READ, cb, size, pos);
+
+	LOG_CLEAR_CONTEXT();
+	return ret;
+}
+
+int ocfs_kvec_write(struct file *file, kvec_cb_t cb, size_t size, loff_t pos) 
+{
+	int ret;
+
+	LOG_SET_CONTEXT(KVEC_WRITE);
+
+	ret = ocfs_kvec_rw(file, WRITE, cb, size, pos);
+
+	LOG_CLEAR_CONTEXT();
+	return ret;
+}
+
+#endif /* aio */
+#endif /* 2.6 */
