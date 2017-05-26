From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Fri, 26 May 2017 03:46:13 +0000
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
	direct io. review
References: <E3535A62B291B54FBD1D003696CCB53792E30014@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <E3535A62B291B54FBD1D003696CCB53792E30049@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch replace that function ocfs2_direct_IO_get_blocks with

this function ocfs2_get_blocks  in ocfs2_direct_IO, and remove the  ip_alloc_sem.

but i think ip_alloc_sem is still needed because protect  allocation changes is very correct.

Now, BUG_ON have been tiggered  in the process of testing direct-io.

Comments and questions are, as always, welcome. Thanks


As wangww631 described

In ocfs2, ip_alloc_sem is used to protect allocation changes on the node.
In direct IO, we add ip_alloc_sem to protect date consistent between
direct-io and ocfs2_truncate_file race (buffer io use ip_alloc_sem
already).  Although inode->i_mutex lock is used to avoid concurrency of
above situation, i think ip_alloc_sem is still needed because protect
allocation changes is significant.

Other filesystem like ext4 also uses rw_semaphore to protect data
consistent between get_block-vs-truncate race by other means, So
ip_alloc_sem in ocfs2 direct io is needed.


Date: Fri, 11 Sep 2015 16:19:18 +0800
From: Ryan Ding <ryan.ding@oracle.com>
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: fix sparse file & data
        ordering        issue in direct io.
To: ocfs2-devel at oss.oracle.com
Cc: mfasheh at suse.de
Message-ID: <1441959559-29947-8-git-send-email-ryan.ding@oracle.com>

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
- *                                     fs_count, map_bh, dio->rw == WRITE);
- */
-static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
-                                    struct buffer_head *bh_result, int create)
-{
-       int ret;
-       u32 cpos = 0;
-       int alloc_locked = 0;
-       u64 p_blkno, inode_blocks, contig_blocks;
-       unsigned int ext_flags;
-       unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
-       unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
-       unsigned long len = bh_result->b_size;
-       unsigned int clusters_to_alloc = 0, contig_clusters = 0;
-
-       cpos = ocfs2_blocks_to_clusters(inode->i_sb, iblock);
-
-       /* This function won't even be called if the request isn't all
-        * nicely aligned and of the right size, so there's no need
-        * for us to check any of that. */
-
-       inode_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
-
-       down_read(&OCFS2_I(inode)->ip_alloc_sem);
-
-       /* This figures out the size of the next contiguous block, and
-        * our logical offset */
-       ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
-                                         &contig_blocks, &ext_flags);
-       up_read(&OCFS2_I(inode)->ip_alloc_sem);
-
-       if (ret) {
-               mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
-                    (unsigned long long)iblock);
-               ret = -EIO;
-               goto bail;
-       }
-
-       /* We should already CoW the refcounted extent in case of create. */
-       BUG_ON(create && (ext_flags & OCFS2_EXT_REFCOUNTED));
-
-       /* allocate blocks if no p_blkno is found, and create == 1 */
-       if (!p_blkno && create) {
-               ret = ocfs2_inode_lock(inode, NULL, 1);
-               if (ret < 0) {
-                       mlog_errno(ret);
-                       goto bail;
-               }
-
-               alloc_locked = 1;
-
-               down_write(&OCFS2_I(inode)->ip_alloc_sem);
-
-               /* fill hole, allocate blocks can't be larger than the size
-                * of the hole */
-               clusters_to_alloc = ocfs2_clusters_for_bytes(inode->i_sb, len);
-               contig_clusters = ocfs2_clusters_for_blocks(inode->i_sb,
-                               contig_blocks);
-               if (clusters_to_alloc > contig_clusters)
-                       clusters_to_alloc = contig_clusters;
-
-               /* allocate extent and insert them into the extent tree */
-               ret = ocfs2_extend_allocation(inode, cpos,
-                               clusters_to_alloc, 0);
-               if (ret < 0) {
-                       up_write(&OCFS2_I(inode)->ip_alloc_sem);
-                       mlog_errno(ret);
-                       goto bail;
-               }
-
-               ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
-                               &contig_blocks, &ext_flags);
-               if (ret < 0) {
-                       up_write(&OCFS2_I(inode)->ip_alloc_sem);
-                       mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
-                                       (unsigned long long)iblock);
-                       ret = -EIO;
-                       goto bail;
-               }
-               up_write(&OCFS2_I(inode)->ip_alloc_sem);
-       }
-
-       /*
-        * get_more_blocks() expects us to describe a hole by clearing
-        * the mapped bit on bh_result().
-        *
-        * Consider an unwritten extent as a hole.
-        */
-       if (p_blkno && !(ext_flags & OCFS2_EXT_UNWRITTEN))
-               map_bh(bh_result, inode->i_sb, p_blkno);
-       else
-               clear_buffer_mapped(bh_result);
-
-       /* make sure we don't map more than max_blocks blocks here as
-          that's all the kernel will handle at this point. */
-       if (max_blocks < contig_blocks)
-               contig_blocks = max_blocks;
-       bh_result->b_size = contig_blocks << blocksize_bits;
-bail:
-       if (alloc_locked)
-               ocfs2_inode_unlock(inode, 1);
-       return ret;
-}

......

+static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+                              loff_t offset)
+{
+       struct file *file = iocb->ki_filp;
+       struct inode *inode = file_inode(file)->i_mapping->host;
+       struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+       loff_t end = offset + iter->count;
+       get_block_t *get_block;
+
+       /*
+        * Fallback to buffered I/O if we see an inode without
+        * extents.
+        */
+       if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+               return 0;
+
+       /* Fallback to buffered I/O if we do not support append dio. */
+       if (end > i_size_read(inode) && !ocfs2_supports_append_dio(osb))
+               return 0;
+
+       if (iov_iter_rw(iter) == READ)
+               get_block = ocfs2_get_block;
+       else
+               get_block = ocfs2_dio_get_block;
+
+       return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
+                                   iter, offset, get_block,
+                                   ocfs2_dio_end_io, NULL, 0);
+}
+
 const struct address_space_operations ocfs2_aops = {
        .readpage               = ocfs2_readpage,
        .readpages              = ocfs2_readpages,
________________________________
All the best wishes for you.
zhangguanghui
-------------------------------------------------------------------------------------------------------------------------------------
?????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from New H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170526/9698afea/attachment-0001.html 
