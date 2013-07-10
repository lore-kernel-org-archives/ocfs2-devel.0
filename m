From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 10 Jul 2013 09:03:34 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: update inode size after zeroed the hole
Message-ID: <1373418214-18661-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

fs-writeback will release the dirty pages without page lock
whose offset are over inode size, the release happens at
block_write_full_page_endio(). If not update, dirty pages
in file holes may be released before flushed to the disk,
then file holes will contain some non-zero data, this will
cause sparse file cksum error.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/file.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ff54014..d1264ef 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -756,7 +756,7 @@ out:
  * to be too fragile to do exactly what we need without us having to
  * worry about recursive locking in ->write_begin() and ->write_end(). */
 static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
-				 u64 abs_to)
+				 u64 abs_to, struct buffer_head *di_bh)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
@@ -764,6 +764,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 	handle_t *handle = NULL;
 	int ret = 0;
 	unsigned zero_from, zero_to, block_start, block_end;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	BUG_ON(abs_from >= abs_to);
 	BUG_ON(abs_to > (((u64)index + 1) << PAGE_CACHE_SHIFT));
@@ -823,8 +824,22 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 			ret = 0;
 	}
 
-	if (handle)
+	if (handle) {
+		/*
+		 * fs-writeback will release the dirty pages without page lock
+		 * whose offset are over inode size, the release happens at
+		 * block_write_full_page_endio().
+		 */
+		i_size_write(inode, abs_to);
+		inode->i_blocks = ocfs2_inode_sector_count(inode);
+		di->i_size = cpu_to_le64((u64)i_size_read(inode));
+		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
+		di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
+		di->i_mtime_nsec = di->i_ctime_nsec;
+		ocfs2_journal_dirty(handle, di_bh);
 		ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+	}
 
 out_unlock:
 	unlock_page(page);
@@ -920,7 +935,7 @@ out:
  * has made sure that the entire range needs zeroing.
  */
 static int ocfs2_zero_extend_range(struct inode *inode, u64 range_start,
-				   u64 range_end)
+				   u64 range_end, struct buffer_head *di_bh)
 {
 	int rc = 0;
 	u64 next_pos;
@@ -936,7 +951,7 @@ static int ocfs2_zero_extend_range(struct inode *inode, u64 range_start,
 		next_pos = (zero_pos & PAGE_CACHE_MASK) + PAGE_CACHE_SIZE;
 		if (next_pos > range_end)
 			next_pos = range_end;
-		rc = ocfs2_write_zero_page(inode, zero_pos, next_pos);
+		rc = ocfs2_write_zero_page(inode, zero_pos, next_pos, di_bh);
 		if (rc < 0) {
 			mlog_errno(rc);
 			break;
@@ -982,7 +997,7 @@ int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
 			range_end = zero_to_size;
 
 		ret = ocfs2_zero_extend_range(inode, range_start,
-					      range_end);
+					      range_end, di_bh);
 		if (ret) {
 			mlog_errno(ret);
 			break;
-- 
1.7.9.5
