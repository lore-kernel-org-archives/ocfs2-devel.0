From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 15 Dec 2014 14:51:28 -0800
Subject: [Ocfs2-devel] [patch 14/15] ocfs2: do not fallback to buffer I/O
 write if fill holes
Message-ID: <548f65f0.WZA0tSrrMVKoDwnV%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Weiwei Wang <wangww631@huawei.com>
Subject: ocfs2: do not fallback to buffer I/O write if fill holes

Now append O_DIRECT write to a hole will try direct io first, then
fallback to buffered IO if fails.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   92 ++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 51 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes
+++ a/fs/ocfs2/file.c
@@ -1359,44 +1359,6 @@ out:
 	return ret;
 }
 
-/*
- * Will look for holes and unwritten extents in the range starting at
- * pos for count bytes (inclusive).
- */
-static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
-				       size_t count)
-{
-	int ret = 0;
-	unsigned int extent_flags;
-	u32 cpos, clusters, extent_len, phys_cpos;
-	struct super_block *sb = inode->i_sb;
-
-	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
-	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
-
-	while (clusters) {
-		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
-					 &extent_flags);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
-			ret = 1;
-			break;
-		}
-
-		if (extent_len > clusters)
-			extent_len = clusters;
-
-		clusters -= extent_len;
-		cpos += extent_len;
-	}
-out:
-	return ret;
-}
-
 static int ocfs2_write_remove_suid(struct inode *inode)
 {
 	int ret;
@@ -2212,18 +2174,6 @@ static int ocfs2_prepare_inode_for_write
 			break;
 		}
 
-		/*
-		 * We don't fill holes during direct io, so
-		 * check for them here. If any are found, the
-		 * caller will have to retake some cluster
-		 * locks and initiate the io as buffered.
-		 */
-		ret = ocfs2_check_range_for_holes(inode, saved_pos, count);
-		if (ret == 1) {
-			*direct_io = 0;
-			ret = 0;
-		} else if (ret < 0)
-			mlog_errno(ret);
 		break;
 	}
 
@@ -2253,6 +2203,7 @@ static ssize_t ocfs2_file_write_iter(str
 	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	struct address_space *mapping = file->f_mapping;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
@@ -2367,11 +2318,50 @@ relock:
 
 	iov_iter_truncate(from, count);
 	if (direct_io) {
+		loff_t endbyte;
+		ssize_t written_buffered;
 		written = generic_file_direct_write(iocb, from, *ppos);
-		if (written < 0) {
+		if (written < 0 || written == count) {
 			ret = written;
 			goto out_dio;
 		}
+
+		/*
+		 * direct-io write to a hole: fall through to buffered I/O
+		 * for completing the rest of the request.
+		 */
+		count -= written;
+		written_buffered = generic_perform_write(file, from, *ppos);
+		/*
+		 * If generic_file_buffered_write() returned a synchronous error
+		 * then we want to return the number of bytes which were
+		 * direct-written, or the error code if that was zero. Note
+		 * that this differs from normal direct-io semantics, which
+		 * will return -EFOO even if some bytes were written.
+		 */
+		if (written_buffered < 0) {
+			ret = written_buffered;
+			goto out;
+		}
+
+		/* We need to ensure that the page cache pages are written to
+		 * disk and invalidated to preserve the expected O_DIRECT
+		 * semantics.
+		 */
+		endbyte = *ppos + written_buffered - written - 1;
+		ret = filemap_write_and_wait_range(file->f_mapping, *ppos,
+				endbyte);
+		if (ret == 0) {
+			written = written_buffered;
+			invalidate_mapping_pages(mapping,
+					*ppos >> PAGE_CACHE_SHIFT,
+					endbyte >> PAGE_CACHE_SHIFT);
+		} else {
+			/*
+			 * We don't know how much we wrote, so just return
+			 * the number of bytes which were direct-written
+			 */
+		}
 	} else {
 		current->backing_dev_info = file->f_mapping->backing_dev_info;
 		written = generic_perform_write(file, from, *ppos);
_
