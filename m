From: WeiWei Wang <wangww631@huawei.com>
Date: Mon, 11 May 2015 14:42:57 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add ip_alloc_sem in direct IO to
 protect allocation changes
Message-ID: <55504F71.1030004@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

In ocfs2, ip_alloc_sem is used to protect allocation changes on the node.
In direct IO, we add ip_alloc_sem to protect date consistent between direct-io
and ocfs2_truncate_file race (buffer io use ip_alloc_sem already).
Although inode->i_mutex lock is used to avoid concurrency of above situation,
i think ip_alloc_sem is still needed because protect allocation changes is
significant.

Other filesystem like ext4 also uses rw_semaphore to protect data consistent
between get_block-vs-truncate race by other means, So ip_alloc_sem in ocfs2
direct io is needed.

Any comments are appreciated, thanks!
					-- Weiwei Wang


Signed-off-by: Weiwei Wang <wangww631@huawei.com>
---
 fs/ocfs2/aops.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f906a25..5b32450 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -533,10 +533,14 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,

 	inode_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));

+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
+
 	/* This figures out the size of the next contiguous block, and
 	 * our logical offset */
 	ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
 					  &contig_blocks, &ext_flags);
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+
 	if (ret) {
 		mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
 		     (unsigned long long)iblock);
@@ -557,6 +561,8 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,

 		alloc_locked = 1;

+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
+
 		/* fill hole, allocate blocks can't be larger than the size
 		 * of the hole */
 		clusters_to_alloc = ocfs2_clusters_for_bytes(inode->i_sb, len);
@@ -567,6 +573,7 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 		ret = ocfs2_extend_allocation(inode, cpos,
 				clusters_to_alloc, 0);
 		if (ret < 0) {
+			up_write(&OCFS2_I(inode)->ip_alloc_sem);
 			mlog_errno(ret);
 			goto bail;
 		}
@@ -574,11 +581,13 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 		ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
 				&contig_blocks, &ext_flags);
 		if (ret < 0) {
+			up_write(&OCFS2_I(inode)->ip_alloc_sem);
 			mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
 					(unsigned long long)iblock);
 			ret = -EIO;
 			goto bail;
 		}
+		up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	}

 	/*
@@ -833,12 +842,17 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,

 		/* zeroing out the previously allocated cluster tail
 		 * that but not zeroed */
-		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb))) {
+			down_read(&OCFS2_I(inode)->ip_alloc_sem);
 			ret = ocfs2_direct_IO_zero_extend(osb, inode, offset,
 					zero_len_tail, cluster_align_tail);
-		else
+			up_read(&OCFS2_I(inode)->ip_alloc_sem);
+		} else {
+			down_write(&OCFS2_I(inode)->ip_alloc_sem);
 			ret = ocfs2_direct_IO_extend_no_holes(osb, inode,
 					offset);
+			up_write(&OCFS2_I(inode)->ip_alloc_sem);
+		}
 		if (ret < 0) {
 			mlog_errno(ret);
 			ocfs2_inode_unlock(inode, 1);
-- 
