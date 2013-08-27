From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:04:56 -0700
Subject: [Ocfs2-devel] [patch 04/22] ocfs2: update inode size after zeroing
	the hole
Message-ID: <20130827210456.7EB3D31C1D6@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: update inode size after zeronig the hole

fs-writeback will release the dirty pages without page lock whose offset
are over inode size, the release happens at block_write_full_page_endio().
 If not update, dirty pages in file holes may be released before flushed
to the disk, then file holes will contain some non-zero data, this will
cause sparse file md5sum error.

To reproduce the bug, find a big sparse file with many holes, like vm
image file, its actual size should be bigger than available mem size to
make writeback work more frequently, tar it with -S option, then keep
untar it and check its md5sum again and again until you get a wrong
md5sum.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Younger Liu <younger.liu@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-update-inode-size-after-zeronig-the-hole fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-update-inode-size-after-zeronig-the-hole
+++ a/fs/ocfs2/file.c
@@ -718,7 +718,8 @@ leave:
  * While a write will already be ordering the data, a truncate will not.
  * Thus, we need to explicitly order the zeroed pages.
  */
-static handle_t *ocfs2_zero_start_ordered_transaction(struct inode *inode)
+static handle_t *ocfs2_zero_start_ordered_transaction(struct inode *inode,
+						struct buffer_head *di_bh)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	handle_t *handle = NULL;
@@ -735,7 +736,14 @@ static handle_t *ocfs2_zero_start_ordere
 	}
 
 	ret = ocfs2_jbd2_file_inode(handle, inode);
-	if (ret < 0)
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret)
 		mlog_errno(ret);
 
 out:
@@ -751,7 +759,7 @@ out:
  * to be too fragile to do exactly what we need without us having to
  * worry about recursive locking in ->write_begin() and ->write_end(). */
 static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
-				 u64 abs_to)
+				 u64 abs_to, struct buffer_head *di_bh)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
@@ -759,6 +767,7 @@ static int ocfs2_write_zero_page(struct
 	handle_t *handle = NULL;
 	int ret = 0;
 	unsigned zero_from, zero_to, block_start, block_end;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	BUG_ON(abs_from >= abs_to);
 	BUG_ON(abs_to > (((u64)index + 1) << PAGE_CACHE_SHIFT));
@@ -801,7 +810,8 @@ static int ocfs2_write_zero_page(struct
 		}
 
 		if (!handle) {
-			handle = ocfs2_zero_start_ordered_transaction(inode);
+			handle = ocfs2_zero_start_ordered_transaction(inode,
+								      di_bh);
 			if (IS_ERR(handle)) {
 				ret = PTR_ERR(handle);
 				handle = NULL;
@@ -818,8 +828,22 @@ static int ocfs2_write_zero_page(struct
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
@@ -915,7 +939,7 @@ out:
  * has made sure that the entire range needs zeroing.
  */
 static int ocfs2_zero_extend_range(struct inode *inode, u64 range_start,
-				   u64 range_end)
+				   u64 range_end, struct buffer_head *di_bh)
 {
 	int rc = 0;
 	u64 next_pos;
@@ -931,7 +955,7 @@ static int ocfs2_zero_extend_range(struc
 		next_pos = (zero_pos & PAGE_CACHE_MASK) + PAGE_CACHE_SIZE;
 		if (next_pos > range_end)
 			next_pos = range_end;
-		rc = ocfs2_write_zero_page(inode, zero_pos, next_pos);
+		rc = ocfs2_write_zero_page(inode, zero_pos, next_pos, di_bh);
 		if (rc < 0) {
 			mlog_errno(rc);
 			break;
@@ -977,7 +1001,7 @@ int ocfs2_zero_extend(struct inode *inod
 			range_end = zero_to_size;
 
 		ret = ocfs2_zero_extend_range(inode, range_start,
-					      range_end);
+					      range_end, di_bh);
 		if (ret) {
 			mlog_errno(ret);
 			break;
_
