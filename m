From: Ryan Ding <ryan.ding@oracle.com>
Date: Fri, 11 Sep 2015 16:19:18 +0800
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: fix sparse file & data ordering
	issue in direct io.
In-Reply-To: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
References: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
Message-ID: <1441959559-29947-8-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There are mainly 3 issue in the direct io code path after commit 24c40b329e03 ("ocfs2: implement ocfs2_direct_IO_write"):
  * Do not support sparse file.
  * Do not support data ordering. eg: when write to a file hole, it will alloc
    extent first. If system crashed before io finished, data will corrupt.
  * Potential risk when doing aio+dio. The -EIOCBQUEUED return value is likely
    to be ignored by ocfs2_direct_IO_write().

To resolve above problems, re-design direct io code with following ideas:
  * Use buffer io to fill in holes. And this will make better performance also.
  * Clear unwritten after direct write finished. So we can make sure meta data
    changes after data write to disk. (Unwritten extent is invisible to user,
    from user's view, meta data is not changed when allocate an unwritten
    extent.)
  * Clear ocfs2_direct_IO_write(). Do all ending work in end_io.

This patch has passed fs,dio,ltp-aiodio.part1,ltp-aiodio.part2,ltp-aiodio.part4
test cases of ltp.

For performance improvement, see following test result:
ocfs2 cluster size 1MB, ocfs2 volume is mounted on /mnt/.
The original way:
  + rm /mnt/test.img -f
  + dd if=/dev/zero of=/mnt/test.img bs=4K count=1048576 oflag=direct
  1048576+0 records in
  1048576+0 records out
  4294967296 bytes (4.3 GB) copied, 1707.83 s, 2.5 MB/s
  + rm /mnt/test.img -f
  + dd if=/dev/zero of=/mnt/test.img bs=256K count=16384 oflag=direct
  16384+0 records in
  16384+0 records out
  4294967296 bytes (4.3 GB) copied, 582.705 s, 7.4 MB/s

After this patch:
  + rm /mnt/test.img -f
  + dd if=/dev/zero of=/mnt/test.img bs=4K count=1048576 oflag=direct
  1048576+0 records in
  1048576+0 records out
  4294967296 bytes (4.3 GB) copied, 64.6412 s, 66.4 MB/s
  + rm /mnt/test.img -f
  + dd if=/dev/zero of=/mnt/test.img bs=256K count=16384 oflag=direct
  16384+0 records in
  16384+0 records out
  4294967296 bytes (4.3 GB) copied, 34.7611 s, 124 MB/s

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
cc: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c |  851 ++++++++++++++++++++++---------------------------------
 1 files changed, 342 insertions(+), 509 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b4ec600..4bb9921 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -499,152 +499,6 @@ bail:
 	return status;
 }
 
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
- * called like this: dio->get_blocks(dio->inode, fs_startblk,
- * 					fs_count, map_bh, dio->rw == WRITE);
- */
-static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
-				     struct buffer_head *bh_result, int create)
-{
-	int ret;
-	u32 cpos = 0;
-	int alloc_locked = 0;
-	u64 p_blkno, inode_blocks, contig_blocks;
-	unsigned int ext_flags;
-	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
-	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
-	unsigned long len = bh_result->b_size;
-	unsigned int clusters_to_alloc = 0, contig_clusters = 0;
-
-	cpos = ocfs2_blocks_to_clusters(inode->i_sb, iblock);
-
-	/* This function won't even be called if the request isn't all
-	 * nicely aligned and of the right size, so there's no need
-	 * for us to check any of that. */
-
-	inode_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
-
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-
-	/* This figures out the size of the next contiguous block, and
-	 * our logical offset */
-	ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
-					  &contig_blocks, &ext_flags);
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-
-	if (ret) {
-		mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
-		     (unsigned long long)iblock);
-		ret = -EIO;
-		goto bail;
-	}
-
-	/* We should already CoW the refcounted extent in case of create. */
-	BUG_ON(create && (ext_flags & OCFS2_EXT_REFCOUNTED));
-
-	/* allocate blocks if no p_blkno is found, and create == 1 */
-	if (!p_blkno && create) {
-		ret = ocfs2_inode_lock(inode, NULL, 1);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto bail;
-		}
-
-		alloc_locked = 1;
-
-		down_write(&OCFS2_I(inode)->ip_alloc_sem);
-
-		/* fill hole, allocate blocks can't be larger than the size
-		 * of the hole */
-		clusters_to_alloc = ocfs2_clusters_for_bytes(inode->i_sb, len);
-		contig_clusters = ocfs2_clusters_for_blocks(inode->i_sb,
-				contig_blocks);
-		if (clusters_to_alloc > contig_clusters)
-			clusters_to_alloc = contig_clusters;
-
-		/* allocate extent and insert them into the extent tree */
-		ret = ocfs2_extend_allocation(inode, cpos,
-				clusters_to_alloc, 0);
-		if (ret < 0) {
-			up_write(&OCFS2_I(inode)->ip_alloc_sem);
-			mlog_errno(ret);
-			goto bail;
-		}
-
-		ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
-				&contig_blocks, &ext_flags);
-		if (ret < 0) {
-			up_write(&OCFS2_I(inode)->ip_alloc_sem);
-			mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
-					(unsigned long long)iblock);
-			ret = -EIO;
-			goto bail;
-		}
-		up_write(&OCFS2_I(inode)->ip_alloc_sem);
-	}
-
-	/*
-	 * get_more_blocks() expects us to describe a hole by clearing
-	 * the mapped bit on bh_result().
-	 *
-	 * Consider an unwritten extent as a hole.
-	 */
-	if (p_blkno && !(ext_flags & OCFS2_EXT_UNWRITTEN))
-		map_bh(bh_result, inode->i_sb, p_blkno);
-	else
-		clear_buffer_mapped(bh_result);
-
-	/* make sure we don't map more than max_blocks blocks here as
-	   that's all the kernel will handle at this point. */
-	if (max_blocks < contig_blocks)
-		contig_blocks = max_blocks;
-	bh_result->b_size = contig_blocks << blocksize_bits;
-bail:
-	if (alloc_locked)
-		ocfs2_inode_unlock(inode, 1);
-	return ret;
-}
-
-/*
- * ocfs2_dio_end_io is called by the dio core when a dio is finished.  We're
- * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
- * to protect io on one node from truncation on another.
- */
-static void ocfs2_dio_end_io(struct kiocb *iocb,
-			     loff_t offset,
-			     ssize_t bytes,
-			     void *private)
-{
-	struct inode *inode = file_inode(iocb->ki_filp);
-	int level;
-
-	/* this io's submitter should not have unlocked this before we could */
-	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
-
-	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
-		ocfs2_iocb_clear_unaligned_aio(iocb);
-
-		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
-	}
-
-	/* Let rw unlock to be done later to protect append direct io write */
-	if (offset + bytes <= i_size_read(inode)) {
-		ocfs2_iocb_clear_rw_locked(iocb);
-
-		level = ocfs2_iocb_rw_locked_level(iocb);
-		ocfs2_rw_unlock(inode, level);
-	}
-}
-
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
 {
 	if (!page_has_buffers(page))
@@ -652,361 +506,6 @@ static int ocfs2_releasepage(struct page *page, gfp_t wait)
 	return try_to_free_buffers(page);
 }
 
-static int ocfs2_is_overwrite(struct ocfs2_super *osb,
-		struct inode *inode, loff_t offset)
-{
-	int ret = 0;
-	u32 v_cpos = 0;
-	u32 p_cpos = 0;
-	unsigned int num_clusters = 0;
-	unsigned int ext_flags = 0;
-
-	v_cpos = ocfs2_bytes_to_clusters(osb->sb, offset);
-	ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos,
-			&num_clusters, &ext_flags);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
-
-	if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN))
-		return 1;
-
-	return 0;
-}
-
-static int ocfs2_direct_IO_zero_extend(struct ocfs2_super *osb,
-		struct inode *inode, loff_t offset,
-		u64 zero_len, int cluster_align)
-{
-	u32 p_cpos = 0;
-	u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, i_size_read(inode));
-	unsigned int num_clusters = 0;
-	unsigned int ext_flags = 0;
-	int ret = 0;
-
-	if (offset <= i_size_read(inode) || cluster_align)
-		return 0;
-
-	ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos, &num_clusters,
-			&ext_flags);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
-
-	if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN)) {
-		u64 s = i_size_read(inode);
-		sector_t sector = ((u64)p_cpos << (osb->s_clustersize_bits - 9)) +
-			(do_div(s, osb->s_clustersize) >> 9);
-
-		ret = blkdev_issue_zeroout(osb->sb->s_bdev, sector,
-				zero_len >> 9, GFP_NOFS, false);
-		if (ret < 0)
-			mlog_errno(ret);
-	}
-
-	return ret;
-}
-
-static int ocfs2_direct_IO_extend_no_holes(struct ocfs2_super *osb,
-		struct inode *inode, loff_t offset)
-{
-	u64 zero_start, zero_len, total_zero_len;
-	u32 p_cpos = 0, clusters_to_add;
-	u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, i_size_read(inode));
-	unsigned int num_clusters = 0;
-	unsigned int ext_flags = 0;
-	u32 size_div, offset_div;
-	int ret = 0;
-
-	{
-		u64 o = offset;
-		u64 s = i_size_read(inode);
-
-		offset_div = do_div(o, osb->s_clustersize);
-		size_div = do_div(s, osb->s_clustersize);
-	}
-
-	if (offset <= i_size_read(inode))
-		return 0;
-
-	clusters_to_add = ocfs2_bytes_to_clusters(inode->i_sb, offset) -
-		ocfs2_bytes_to_clusters(inode->i_sb, i_size_read(inode));
-	total_zero_len = offset - i_size_read(inode);
-	if (clusters_to_add)
-		total_zero_len -= offset_div;
-
-	/* Allocate clusters to fill out holes, and this is only needed
-	 * when we add more than one clusters. Otherwise the cluster will
-	 * be allocated during direct IO */
-	if (clusters_to_add > 1) {
-		ret = ocfs2_extend_allocation(inode,
-				OCFS2_I(inode)->ip_clusters,
-				clusters_to_add - 1, 0);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
-
-	while (total_zero_len) {
-		ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos, &num_clusters,
-				&ext_flags);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		zero_start = ocfs2_clusters_to_bytes(osb->sb, p_cpos) +
-			size_div;
-		zero_len = ocfs2_clusters_to_bytes(osb->sb, num_clusters) -
-			size_div;
-		zero_len = min(total_zero_len, zero_len);
-
-		if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN)) {
-			ret = blkdev_issue_zeroout(osb->sb->s_bdev,
-					zero_start >> 9, zero_len >> 9,
-					GFP_NOFS, false);
-			if (ret < 0) {
-				mlog_errno(ret);
-				goto out;
-			}
-		}
-
-		total_zero_len -= zero_len;
-		v_cpos += ocfs2_bytes_to_clusters(osb->sb, zero_len + size_div);
-
-		/* Only at first iteration can be cluster not aligned.
-		 * So set size_div to 0 for the rest */
-		size_div = 0;
-	}
-
-out:
-	return ret;
-}
-
-static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
-		struct iov_iter *iter,
-		loff_t offset)
-{
-	ssize_t ret = 0;
-	ssize_t written = 0;
-	bool orphaned = false;
-	int is_overwrite = 0;
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file_inode(file)->i_mapping->host;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct buffer_head *di_bh = NULL;
-	size_t count = iter->count;
-	journal_t *journal = osb->journal->j_journal;
-	u64 zero_len_head, zero_len_tail;
-	int cluster_align_head, cluster_align_tail;
-	loff_t final_size = offset + count;
-	int append_write = offset >= i_size_read(inode) ? 1 : 0;
-	unsigned int num_clusters = 0;
-	unsigned int ext_flags = 0;
-
-	{
-		u64 o = offset;
-		u64 s = i_size_read(inode);
-
-		zero_len_head = do_div(o, 1 << osb->s_clustersize_bits);
-		cluster_align_head = !zero_len_head;
-
-		zero_len_tail = osb->s_clustersize -
-			do_div(s, osb->s_clustersize);
-		if ((offset - i_size_read(inode)) < zero_len_tail)
-			zero_len_tail = offset - i_size_read(inode);
-		cluster_align_tail = !zero_len_tail;
-	}
-
-	/*
-	 * when final_size > inode->i_size, inode->i_size will be
-	 * updated after direct write, so add the inode to orphan
-	 * dir first.
-	 */
-	if (final_size > i_size_read(inode)) {
-		ret = ocfs2_add_inode_to_orphan(osb, inode);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-		orphaned = true;
-	}
-
-	if (append_write) {
-		ret = ocfs2_inode_lock(inode, NULL, 1);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto clean_orphan;
-		}
-
-		/* zeroing out the previously allocated cluster tail
-		 * that but not zeroed */
-		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb))) {
-			down_read(&OCFS2_I(inode)->ip_alloc_sem);
-			ret = ocfs2_direct_IO_zero_extend(osb, inode, offset,
-					zero_len_tail, cluster_align_tail);
-			up_read(&OCFS2_I(inode)->ip_alloc_sem);
-		} else {
-			down_write(&OCFS2_I(inode)->ip_alloc_sem);
-			ret = ocfs2_direct_IO_extend_no_holes(osb, inode,
-					offset);
-			up_write(&OCFS2_I(inode)->ip_alloc_sem);
-		}
-		if (ret < 0) {
-			mlog_errno(ret);
-			ocfs2_inode_unlock(inode, 1);
-			goto clean_orphan;
-		}
-
-		is_overwrite = ocfs2_is_overwrite(osb, inode, offset);
-		if (is_overwrite < 0) {
-			mlog_errno(is_overwrite);
-			ocfs2_inode_unlock(inode, 1);
-			goto clean_orphan;
-		}
-
-		ocfs2_inode_unlock(inode, 1);
-	}
-
-	written = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
-				       offset, ocfs2_direct_IO_get_blocks,
-				       ocfs2_dio_end_io, NULL, 0);
-	/* overwrite aio may return -EIOCBQUEUED, and it is not an error */
-	if ((written < 0) && (written != -EIOCBQUEUED)) {
-		loff_t i_size = i_size_read(inode);
-
-		if (offset + count > i_size) {
-			ret = ocfs2_inode_lock(inode, &di_bh, 1);
-			if (ret < 0) {
-				mlog_errno(ret);
-				goto clean_orphan;
-			}
-
-			if (i_size == i_size_read(inode)) {
-				ret = ocfs2_truncate_file(inode, di_bh,
-						i_size);
-				if (ret < 0) {
-					if (ret != -ENOSPC)
-						mlog_errno(ret);
-
-					ocfs2_inode_unlock(inode, 1);
-					brelse(di_bh);
-					di_bh = NULL;
-					goto clean_orphan;
-				}
-			}
-
-			ocfs2_inode_unlock(inode, 1);
-			brelse(di_bh);
-			di_bh = NULL;
-
-			ret = jbd2_journal_force_commit(journal);
-			if (ret < 0)
-				mlog_errno(ret);
-		}
-	} else if (written > 0 && append_write && !is_overwrite &&
-			!cluster_align_head) {
-		/* zeroing out the allocated cluster head */
-		u32 p_cpos = 0;
-		u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, offset);
-
-		ret = ocfs2_inode_lock(inode, NULL, 0);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto clean_orphan;
-		}
-
-		ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos,
-				&num_clusters, &ext_flags);
-		if (ret < 0) {
-			mlog_errno(ret);
-			ocfs2_inode_unlock(inode, 0);
-			goto clean_orphan;
-		}
-
-		BUG_ON(!p_cpos || (ext_flags & OCFS2_EXT_UNWRITTEN));
-
-		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
-				(u64)p_cpos << (osb->s_clustersize_bits - 9),
-				zero_len_head >> 9, GFP_NOFS, false);
-		if (ret < 0)
-			mlog_errno(ret);
-
-		ocfs2_inode_unlock(inode, 0);
-	}
-
-clean_orphan:
-	if (orphaned) {
-		int tmp_ret;
-		int update_isize = written > 0 ? 1 : 0;
-		loff_t end = update_isize ? offset + written : 0;
-
-		tmp_ret = ocfs2_inode_lock(inode, &di_bh, 1);
-		if (tmp_ret < 0) {
-			ret = tmp_ret;
-			mlog_errno(ret);
-			goto out;
-		}
-
-		tmp_ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
-				update_isize, end);
-		if (tmp_ret < 0) {
-			ret = tmp_ret;
-			mlog_errno(ret);
-			brelse(di_bh);
-			goto out;
-		}
-
-		ocfs2_inode_unlock(inode, 1);
-		brelse(di_bh);
-
-		tmp_ret = jbd2_journal_force_commit(journal);
-		if (tmp_ret < 0) {
-			ret = tmp_ret;
-			mlog_errno(tmp_ret);
-		}
-	}
-
-out:
-	if (ret >= 0)
-		ret = written;
-	return ret;
-}
-
-static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			       loff_t offset)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file_inode(file)->i_mapping->host;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	int full_coherency = !(osb->s_mount_opt &
-			OCFS2_MOUNT_COHERENCY_BUFFERED);
-
-	/*
-	 * Fallback to buffered I/O if we see an inode without
-	 * extents.
-	 */
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-		return 0;
-
-	/* Fallback to buffered I/O if we are appending and
-	 * concurrent O_DIRECT writes are allowed.
-	 */
-	if (i_size_read(inode) <= offset && !full_coherency)
-		return 0;
-
-	if (iov_iter_rw(iter) == READ)
-		return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
-					    iter, offset,
-					    ocfs2_direct_IO_get_blocks,
-					    ocfs2_dio_end_io, NULL, 0);
-	else
-		return ocfs2_direct_IO_write(iocb, iter, offset);
-}
-
 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
 					    u32 cpos,
 					    unsigned int *start,
@@ -1318,14 +817,14 @@ static void ocfs2_free_unwritten_list(struct inode *inode,
 				 struct list_head *head)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_unwritten_extent *dz = NULL, *tmp = NULL;
+	struct ocfs2_unwritten_extent *ue = NULL, *tmp = NULL;
 
-	list_for_each_entry_safe(dz, tmp, head, ue_node) {
-		list_del(&dz->ue_node);
+	list_for_each_entry_safe(ue, tmp, head, ue_node) {
+		list_del(&ue->ue_node);
 		spin_lock(&oi->ip_lock);
-		list_del(&dz->ue_ip_node);
+		list_del(&ue->ue_ip_node);
 		spin_unlock(&oi->ip_lock);
-		kfree(dz);
+		kfree(ue);
 	}
 }
 
@@ -1826,7 +1325,7 @@ static int ocfs2_unwritten_check(struct inode *inode,
 				 struct ocfs2_write_cluster_desc *desc)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_unwritten_extent *dz = NULL, *new = NULL;
+	struct ocfs2_unwritten_extent *ue = NULL, *new = NULL;
 	int ret = 0;
 
 	if (!desc->c_needs_zero)
@@ -1837,8 +1336,8 @@ retry:
 	/* Needs not to zero no metter buffer or direct. The one who is zero
 	 * the cluster is doing zero. And he will clear unwritten after all
 	 * cluster io finished. */
-	list_for_each_entry(dz, &oi->ip_unwritten_list, ue_ip_node) {
-		if (desc->c_cpos == dz->ue_cpos) {
+	list_for_each_entry(ue, &oi->ip_unwritten_list, ue_ip_node) {
+		if (desc->c_cpos == ue->ue_cpos) {
 			BUG_ON(desc->c_new);
 			desc->c_needs_zero = 0;
 			desc->c_clear_unwritten = 0;
@@ -2600,6 +2099,340 @@ static int ocfs2_write_end(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
+struct ocfs2_dio_write_ctxt {
+	struct list_head	dw_zero_list;
+	unsigned		dw_zero_count;
+	int			dw_orphaned;
+	pid_t			dw_writer_pid;
+};
+
+static struct ocfs2_dio_write_ctxt *
+ocfs2_dio_alloc_write_ctx(struct buffer_head *bh, int *alloc)
+{
+	struct ocfs2_dio_write_ctxt *dwc = NULL;
+
+	if (bh->b_private)
+		return bh->b_private;
+
+	dwc = kmalloc(sizeof(struct ocfs2_dio_write_ctxt), GFP_NOFS);
+	if (dwc == NULL)
+		return NULL;
+	INIT_LIST_HEAD(&dwc->dw_zero_list);
+	dwc->dw_zero_count = 0;
+	dwc->dw_orphaned = 0;
+	dwc->dw_writer_pid = task_pid_nr(current);
+	bh->b_private = dwc;
+	*alloc = 1;
+
+	return dwc;
+}
+
+static void ocfs2_dio_free_write_ctx(struct inode *inode,
+				     struct ocfs2_dio_write_ctxt *dwc)
+{
+	ocfs2_free_unwritten_list(inode, &dwc->dw_zero_list);
+	kfree(dwc);
+}
+
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
+ * called like this: dio->get_blocks(dio->inode, fs_startblk,
+ * 					fs_count, map_bh, dio->rw == WRITE);
+ */
+static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
+			       struct buffer_head *bh_result, int create)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_write_ctxt *wc;
+	struct ocfs2_write_cluster_desc *desc = NULL;
+	struct ocfs2_dio_write_ctxt *dwc = NULL;
+	struct buffer_head *di_bh = NULL;
+	u64 p_blkno;
+	loff_t pos = iblock << inode->i_sb->s_blocksize_bits;
+	unsigned len, total_len = bh_result->b_size;
+	int ret = 0, first_get_block = 0;
+
+	len = osb->s_clustersize - (pos & (osb->s_clustersize - 1));
+	len = min(total_len, len);
+
+	mlog(0, "get block of %lu at %llu:%u req %u\n",
+			inode->i_ino, pos, len, total_len);
+
+	/* This is the fast path for re-write. */
+	ret = ocfs2_get_block(inode, iblock, bh_result, create);
+
+	if (buffer_mapped(bh_result) &&
+	    !buffer_new(bh_result) &&
+	    ret == 0)
+		goto out;
+
+	/* Clear state set by ocfs2_get_block. */
+	bh_result->b_state = 0;
+
+	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
+	if (unlikely(dwc == NULL)) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (ocfs2_clusters_for_bytes(inode->i_sb, pos + total_len) >
+	    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode)) &&
+	    !dwc->dw_orphaned) {
+		/*
+		 * when we are going to alloc extents beyond file size, add the
+		 * inode to orphan dir, so we can recall those spaces when
+		 * system crashed during write.
+		 */
+		ret = ocfs2_add_inode_to_orphan(osb, inode);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+		dwc->dw_orphaned = 1;
+	}
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (first_get_block) {
+		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+			ret = ocfs2_zero_tail(inode, di_bh, pos);
+		else
+			ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
+							   total_len, NULL);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto unlock;
+		}
+	}
+
+	ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
+				       OCFS2_WRITE_DIRECT, NULL,
+				       (void **)&wc, di_bh, NULL);
+	if (ret) {
+		mlog_errno(ret);
+		goto unlock;
+	}
+
+	desc = &wc->w_desc[0];
+
+	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys);
+	BUG_ON(p_blkno == 0);
+	p_blkno += iblock & (u64)(ocfs2_clusters_to_blocks(inode->i_sb, 1) - 1);
+
+	map_bh(bh_result, inode->i_sb, p_blkno);
+	bh_result->b_size = len;
+	if (desc->c_needs_zero)
+		set_buffer_new(bh_result);
+
+	/* May sleep in end_io. It should not happen in a irq context. So defer
+	 * it to dio work queue. */
+	set_buffer_defer_completion(bh_result);
+
+	if (!list_empty(&wc->w_unwritten_list)) {
+		struct ocfs2_unwritten_extent *ue = NULL;
+
+		ue = list_first_entry(&wc->w_unwritten_list,
+				      struct ocfs2_unwritten_extent,
+				      ue_node);
+		BUG_ON(ue->ue_cpos != desc->c_cpos);
+		/* The physical address may be 0, fill it. */
+		ue->ue_phys = desc->c_phys;
+
+		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
+		dwc->dw_zero_count++;
+	}
+
+	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, NULL, wc);
+	BUG_ON(ret != len);
+	ret = 0;
+unlock:
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+out:
+	if (ret < 0)
+		ret = -EIO;
+	return ret;
+}
+
+static void ocfs2_dio_end_io_write(struct inode *inode,
+				   struct ocfs2_dio_write_ctxt *dwc,
+				   loff_t offset,
+				   ssize_t bytes)
+{
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_extent_tree et;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_unwritten_extent *ue = NULL;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+	struct ocfs2_alloc_context *data_ac = NULL;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	handle_t *handle = NULL;
+	loff_t end = offset + bytes;
+	int ret = 0, credits = 0, locked = 0;
+
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	/* We do clear unwritten, delete orphan, change i_size here. If neither
+	 * of these happen, we can skip all this. */
+	if (list_empty(&dwc->dw_zero_list) &&
+	    end <= i_size_read(inode) &&
+	    !dwc->dw_orphaned)
+		goto out;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/* ocfs2_file_write_iter will get i_mutex, so we need not lock if we
+	 * are in that context. */
+	if (dwc->dw_writer_pid != task_pid_nr(current)) {
+		mutex_lock(&inode->i_mutex);
+		locked = 1;
+	}
+
+	/* Delete orphan before acquire i_mutex. */
+	if (dwc->dw_orphaned) {
+		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
+
+		end = end > i_size_read(inode) ? end : 0;
+
+		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
+				!!end, end);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+	di = (struct ocfs2_dinode *)di_bh;
+
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
+
+	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
+				    &data_ac, &meta_ac);
+
+	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto unlock;
+	}
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto commit;
+	}
+
+	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
+		ret = ocfs2_mark_extent_written(inode, &et, handle,
+						ue->ue_cpos, 1,
+						ue->ue_phys,
+						meta_ac, &dealloc);
+		if (ret < 0) {
+			mlog_errno(ret);
+			break;
+		}
+	}
+
+	if (end > i_size_read(inode)) {
+		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+commit:
+	ocfs2_commit_trans(osb, handle);
+unlock:
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+out:
+	ocfs2_run_deallocs(osb, &dealloc);
+	if (locked)
+		mutex_unlock(&inode->i_mutex);
+	ocfs2_dio_free_write_ctx(inode, dwc);
+	if (data_ac)
+		ocfs2_free_alloc_context(data_ac);
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+}
+
+/*
+ * ocfs2_dio_end_io is called by the dio core when a dio is finished.  We're
+ * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
+ * to protect io on one node from truncation on another.
+ */
+static void ocfs2_dio_end_io(struct kiocb *iocb,
+			     loff_t offset,
+			     ssize_t bytes,
+			     void *private)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	int level;
+
+	/* this io's submitter should not have unlocked this before we could */
+	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
+
+	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
+		ocfs2_iocb_clear_unaligned_aio(iocb);
+
+		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
+	}
+
+	if (private)
+		ocfs2_dio_end_io_write(inode, private, offset, bytes);
+
+	ocfs2_iocb_clear_rw_locked(iocb);
+
+	level = ocfs2_iocb_rw_locked_level(iocb);
+	ocfs2_rw_unlock(inode, level);
+}
+
+static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			       loff_t offset)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file)->i_mapping->host;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	loff_t end = offset + iter->count;
+	get_block_t *get_block;
+
+	/*
+	 * Fallback to buffered I/O if we see an inode without
+	 * extents.
+	 */
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	/* Fallback to buffered I/O if we do not support append dio. */
+	if (end > i_size_read(inode) && !ocfs2_supports_append_dio(osb))
+		return 0;
+
+	if (iov_iter_rw(iter) == READ)
+		get_block = ocfs2_get_block;
+	else
+		get_block = ocfs2_dio_get_block;
+
+	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
+				    iter, offset, get_block,
+				    ocfs2_dio_end_io, NULL, 0);
+}
+
 const struct address_space_operations ocfs2_aops = {
 	.readpage		= ocfs2_readpage,
 	.readpages		= ocfs2_readpages,
-- 
1.7.1
