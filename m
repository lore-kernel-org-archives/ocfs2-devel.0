From: WeiWei Wang <wangww631@huawei.com>
Date: Tue, 23 Sep 2014 17:12:42 +0800
Subject: [Ocfs2-devel] [PATCH 4/7 v2] ocfs2: add and remove inode in orphan
 dir in ocfs2_direct_IO
Message-ID: <5421398A.6050604@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This commit add the inode to orphan first, after direct-io write is finished, remove
the inode from orphan dir. So the allocate blocks and change inode->i_size will be safe.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
---
 fs/ocfs2/aops.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 114 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4a231a1..bdb91bd 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -47,6 +47,9 @@
 #include "ocfs2_trace.h"

 #include "buffer_head_io.h"
+#include "dir.h"
+#include "namei.h"
+#include "sysfile.h"

 static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
@@ -602,8 +605,16 @@ static ssize_t ocfs2_direct_IO(int rw,
 			       struct iov_iter *iter,
 			       loff_t offset)
 {
+	ssize_t ret = 0;
+	int status = 0;
+	int orphan = 0;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file)->i_mapping->host;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *di_bh = NULL;
+	handle_t *handle = NULL;
+	size_t count = iter->count;
+	journal_t *journal = osb->journal->j_journal;

 	/*
 	 * Fallback to buffered I/O if we see an inode without
@@ -616,10 +627,109 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (i_size_read(inode) <= offset)
 		return 0;

-	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				    iter, offset,
-				    ocfs2_direct_IO_get_blocks,
-				    ocfs2_dio_end_io, NULL, 0);
+	if (rw == WRITE) {
+		loff_t final_size = offset + count;
+		/*
+		 * when final_size > inode->i_size, inode->i_size will be
+		 * updated after direct write, so add the inode to orphan
+		 * dir first.
+		 */
+		if (final_size > i_size_read(inode)) {
+			handle = ocfs2_start_trans(osb,
+					OCFS2_INODE_ADD_TO_ORPHAN_CREDITS);
+			if (IS_ERR(handle)) {
+				status = PTR_ERR(handle);
+				goto out;
+			}
+			status = ocfs2_add_inode_to_orphan(osb, handle, inode);
+			if (status < 0)
+				goto out;
+
+			orphan = 1;
+			ocfs2_commit_trans(osb, handle);
+			handle = NULL;
+		}
+	}
+
+	if (rw == READ)
+		ret = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
+					iter, offset,
+					ocfs2_direct_IO_get_blocks,
+					ocfs2_dio_end_io, NULL, 0);
+	else {
+		ret =  blockdev_direct_IO(rw, iocb, inode,
+					iter, offset,
+					ocfs2_direct_IO_get_blocks);
+
+		if (unlikely((rw & WRITE) && ret < 0)) {
+			loff_t isize = i_size_read(inode);
+
+			if (offset + count  > isize) {
+				status = ocfs2_inode_lock(inode, &di_bh, 1);
+				if (status < 0) {
+					mlog_errno(status);
+					goto out;
+				}
+				if (isize == i_size_read(inode))
+					ocfs2_truncate_file(inode, di_bh,
+							    isize);
+
+				ocfs2_inode_unlock(inode, 1);
+				brelse(di_bh);
+				di_bh = NULL;
+
+				status = jbd2_journal_force_commit(journal);
+				if (status < 0)
+					mlog_errno(status);
+			}
+		}
+	}
+
+	if (orphan) {
+		handle = ocfs2_start_trans(osb,
+					OCFS2_INODE_DEL_FROM_ORPHAN_CREDITS);
+		if (IS_ERR(handle)) {
+			status = PTR_ERR(handle);
+			goto out;
+		}
+
+		status = ocfs2_del_inode_from_orphan(osb, handle, inode);
+		if (status < 0)
+			goto out;
+
+		/* after update the inode->i_size, call
+		 * jbd2_journal_force_commit to flush the journal to disk */
+		if (ret > 0) {
+			loff_t end = offset + ret;
+
+			if (end > i_size_read(inode)) {
+				status = ocfs2_inode_lock(inode, &di_bh, 1);
+				if (status < 0) {
+					mlog_errno(status);
+					goto out;
+				}
+				status = ocfs2_set_inode_size(handle, inode,
+							      di_bh, end);
+				if (status < 0)
+					mlog_errno(status);
+				ocfs2_inode_unlock(inode, 1);
+				brelse(di_bh);
+			}
+		}
+		ocfs2_commit_trans(osb, handle);
+		handle = NULL;
+
+		status = jbd2_journal_force_commit(journal);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
+out:
+	if (status < 0)
+		ret = status;
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
+	return ret;
 }

 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
-- 1.8.4.3
