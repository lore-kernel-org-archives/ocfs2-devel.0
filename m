From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 28 Oct 2014 21:19:17 +0800
Subject: [Ocfs2-devel] [PATCH 5/7 v5] ocfs2: allocate blocks in
	ocfs2_direct_IO_get_blocks
Message-ID: <544F97D5.30506@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Weiwei Wang <wangww631@huawei.com>

Allow blocks allocation in ocfs2_direct_IO_get_blocks.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index eb41ede..38e5a9f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -510,18 +510,21 @@ bail:
  *
  * called like this: dio->get_blocks(dio->inode, fs_startblk,
  * 					fs_count, map_bh, dio->rw == WRITE);
- *
- * Note that we never bother to allocate blocks here, and thus ignore the
- * create argument.
  */
 static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 				     struct buffer_head *bh_result, int create)
 {
 	int ret;
+	u32 cpos = 0;
+	int alloc_locked = 0;
 	u64 p_blkno, inode_blocks, contig_blocks;
 	unsigned int ext_flags;
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
+	unsigned long len = bh_result->b_size;
+	unsigned int clusters_to_alloc = 0;
+
+	cpos = ocfs2_blocks_to_clusters(inode->i_sb, iblock);

 	/* This function won't even be called if the request isn't all
 	 * nicely aligned and of the right size, so there's no need
@@ -543,6 +546,40 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 	/* We should already CoW the refcounted extent in case of create. */
 	BUG_ON(create && (ext_flags & OCFS2_EXT_REFCOUNTED));

+	/* allocate blocks if no p_blkno is found, and create == 1 */
+	if (!p_blkno && create) {
+		ret = ocfs2_inode_lock(inode, NULL, 1);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto bail;
+		}
+
+		alloc_locked = 1;
+
+		/* fill hole, allocate blocks can't be larger than the size
+		 * of the hole */
+		clusters_to_alloc = ocfs2_clusters_for_bytes(inode->i_sb, len);
+		if (clusters_to_alloc > contig_blocks)
+			clusters_to_alloc = contig_blocks;
+
+		/* allocate extent and insert them into the extent tree */
+		ret = ocfs2_extend_allocation(inode, cpos,
+				clusters_to_alloc, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto bail;
+		}
+
+		ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
+				&contig_blocks, &ext_flags);
+		if (ret < 0) {
+			mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
+					(unsigned long long)iblock);
+			ret = -EIO;
+			goto bail;
+		}
+	}
+
 	/*
 	 * get_more_blocks() expects us to describe a hole by clearing
 	 * the mapped bit on bh_result().
@@ -560,6 +597,8 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 		contig_blocks = max_blocks;
 	bh_result->b_size = contig_blocks << blocksize_bits;
 bail:
+	if (alloc_locked)
+		ocfs2_inode_unlock(inode, 1);
 	return ret;
 }

-- 
1.8.4.3
