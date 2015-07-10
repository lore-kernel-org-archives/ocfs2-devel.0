From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 10 Jul 2015 19:21:03 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix several issues of append dio
Message-ID: <559FAA9F.6090903@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

1) Take rw EX lock in case of append dio.
2) Explicitly treat the error code -EIOCBQUEUED as normal.
3) Set di_bh to NULL after brelse if it may be used again later.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c | 7 ++++++-
 fs/ocfs2/file.c | 5 ++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index eb8b05d..b57f0c7 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -860,7 +860,8 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 	written = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
 				       offset, ocfs2_direct_IO_get_blocks,
 				       ocfs2_dio_end_io, NULL, 0);
-	if (unlikely(written < 0)) {
+	/* overwrite aio may return -EIOCBQUEUED, and it is not an error */
+	if ((written < 0) && (written != -EIOCBQUEUED)) {
 		loff_t i_size = i_size_read(inode);

 		if (offset + count > i_size) {
@@ -879,12 +880,14 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,

 					ocfs2_inode_unlock(inode, 1);
 					brelse(di_bh);
+					di_bh = NULL;
 					goto clean_orphan;
 				}
 			}

 			ocfs2_inode_unlock(inode, 1);
 			brelse(di_bh);
+			di_bh = NULL;

 			ret = jbd2_journal_force_commit(journal);
 			if (ret < 0)
@@ -939,10 +942,12 @@ clean_orphan:
 		if (tmp_ret < 0) {
 			ret = tmp_ret;
 			mlog_errno(ret);
+			brelse(di_bh);
 			goto out;
 		}

 		ocfs2_inode_unlock(inode, 1);
+		brelse(di_bh);

 		tmp_ret = jbd2_journal_force_commit(journal);
 		if (tmp_ret < 0) {
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 3403a54..e71c623 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2265,6 +2265,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 	int unaligned_dio = 0;
 	int dropped_dio = 0;
+	int append_write = ((iocb->ki_pos + count) >=
+			i_size_read(inode) ? 1 : 0);

 	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2284,8 +2286,9 @@ relock:
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
+	 * For append write, we must take rw EX.
 	 */
-	rw_level = (!direct_io || full_coherency);
+	rw_level = (!direct_io || full_coherency || append_write);

 	ret = ocfs2_rw_lock(inode, rw_level);
 	if (ret < 0) {
-- 
1.8.4.3
