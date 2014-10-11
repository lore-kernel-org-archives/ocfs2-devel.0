From: WeiWei Wang <wangww631@huawei.com>
Date: Sat, 11 Oct 2014 20:29:08 +0800
Subject: [Ocfs2-devel] [PATCH 4/7 v4] ocfs2: add and remove inode in orphan
 dir in ocfs2_direct_IO
Message-ID: <54392294.4000102@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add the inode to orphan dir first, and then delete it once append
O_DIRECT finished.
This is to make sure block allocation and inode size are consistent.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 172 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4a231a1..81d95e1 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -28,6 +28,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/mpage.h>
 #include <linux/quotaops.h>
+#include <linux/blkdev.h>

 #include <cluster/masklog.h>

@@ -47,6 +48,9 @@
 #include "ocfs2_trace.h"

 #include "buffer_head_io.h"
+#include "dir.h"
+#include "namei.h"
+#include "sysfile.h"

 static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
@@ -597,6 +601,159 @@ static int ocfs2_releasepage(struct page *page, gfp_t wait)
 	return try_to_free_buffers(page);
 }

+static int ocfs2_is_overwrite(struct ocfs2_super *osb,
+		struct inode *inode , loff_t offset)
+{
+	ssize_t ret = 0;
+	u32 v_cpos = 0;
+	u32 p_cpos = 0;
+	unsigned int num_clusters = 0;
+	unsigned int ext_flags = 0;
+
+	v_cpos = ocfs2_clusters_for_bytes(osb->sb, offset);
+
+	ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos,
+			&num_clusters, &ext_flags);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN))
+		return 1;
+
+	return 0;
+}
+
+static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
+		struct iov_iter *iter,
+		loff_t offset)
+{
+	ssize_t ret = 0;
+	int orphan = 0;
+	int is_overwrite = 0;
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *di_bh = NULL;
+	size_t count = iter->count;
+	journal_t *journal = osb->journal->j_journal;
+	u32 p_cpos = 0;
+	u32 v_cpos = ocfs2_clusters_for_bytes(osb->sb, offset);
+	u32 zero_len = offset % (1 << osb->s_clustersize_bits);
+	int cluster_align = offset % (1 << osb->s_clustersize_bits) ? 0 : 1;
+	int append_write = offset >= i_size_read(inode) ? 1 : 0;
+	unsigned int num_clusters = 0;
+	unsigned int ext_flags = 0;
+
+	loff_t final_size = offset + count;
+	/*
+	 * when final_size > inode->i_size, inode->i_size will be
+	 * updated after direct write, so add the inode to orphan
+	 * dir first.
+	 */
+	if (final_size > i_size_read(inode)) {
+		ret = ocfs2_add_inode_to_orphan(osb, inode);
+		if (ret < 0)
+			goto out;
+		orphan = 1;
+	}
+
+	if (append_write) {
+		ret = ocfs2_inode_lock(inode, &di_bh, 1);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto clean_orphan;
+		}
+
+		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+			ret = ocfs2_zero_extend(inode, di_bh, offset);
+		else
+			ret = ocfs2_extend_no_holes(inode, di_bh,
+					offset, offset);
+		if (ret < 0) {
+			mlog_errno(ret);
+			ocfs2_inode_unlock(inode, 1);
+			brelse(di_bh);
+			goto clean_orphan;
+		}
+
+		is_overwrite = ocfs2_is_overwrite(osb, inode, offset);
+		if (is_overwrite < 0) {
+			mlog_errno(is_overwrite);
+			ocfs2_inode_unlock(inode, 1);
+			brelse(di_bh);
+			goto clean_orphan;
+		}
+
+		ocfs2_inode_unlock(inode, 1);
+		brelse(di_bh);
+	}
+
+	ret = blockdev_direct_IO(WRITE, iocb,
+			inode, iter, offset,
+			ocfs2_direct_IO_get_blocks);
+	if (unlikely(ret < 0)) {
+		loff_t isize = i_size_read(inode);
+
+		if (offset + count > isize) {
+			ret = ocfs2_inode_lock(inode, &di_bh, 1);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto clean_orphan;
+			}
+			if (isize == i_size_read(inode)) {
+				ret = ocfs2_truncate_file(inode, di_bh,
+						isize);
+				if (ret < 0) {
+					if (ret != -ENOSPC)
+						mlog_errno(ret);
+				}
+			}
+			ocfs2_inode_unlock(inode, 1);
+			brelse(di_bh);
+
+			ret = jbd2_journal_force_commit(journal);
+			if (ret < 0)
+				mlog_errno(ret);
+		}
+	} else if (append_write && !is_overwrite && !cluster_align) {
+		ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos,
+				&num_clusters, &ext_flags);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto clean_orphan;
+		}
+
+		BUG_ON(!p_cpos || (ext_flags & OCFS2_EXT_UNWRITTEN));
+
+		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
+				p_cpos << (osb->s_clustersize_bits - 9),
+				zero_len >> 9,
+				GFP_KERNEL);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+clean_orphan:
+	if (orphan) {
+		int update_isize = ret > 0 ? 1 : 0;
+		loff_t end = update_isize ? (offset + ret) : 0;
+
+		ret = ocfs2_del_inode_from_orphan(osb, inode,
+				update_isize, end);
+		if (ret < 0)
+			goto out;
+
+		ret = jbd2_journal_force_commit(journal);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+out:
+	return ret;
+}
+
 static ssize_t ocfs2_direct_IO(int rw,
 			       struct kiocb *iocb,
 			       struct iov_iter *iter,
@@ -604,6 +761,9 @@ static ssize_t ocfs2_direct_IO(int rw,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file)->i_mapping->host;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int full_coherency = !(osb->s_mount_opt &
+			OCFS2_MOUNT_COHERENCY_BUFFERED);

 	/*
 	 * Fallback to buffered I/O if we see an inode without
@@ -612,14 +772,20 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;

-	/* Fallback to buffered I/O if we are appending. */
-	if (i_size_read(inode) <= offset)
+	/* Fallback to buffered I/O if we are appending and
+	 * concurrent O_DIRECT writes are allowed.
+	 */
+	if (i_size_read(inode) <= offset && !full_coherency)
 		return 0;

-	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				    iter, offset,
-				    ocfs2_direct_IO_get_blocks,
-				    ocfs2_dio_end_io, NULL, 0);
+	if (rw == READ)
+		return __blockdev_direct_IO(rw, iocb, inode,
+				inode->i_sb->s_bdev,
+				iter, offset,
+				ocfs2_direct_IO_get_blocks,
+				ocfs2_dio_end_io, NULL, 0);
+	else
+		return ocfs2_direct_IO_write(iocb, iter, offset);
 }

 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
-- 
1.8.4.3
