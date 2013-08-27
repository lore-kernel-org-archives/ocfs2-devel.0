From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:04:58 -0700
Subject: [Ocfs2-devel] [patch 06/22] ocfs2: use i_size_read() to access
	i_size
Message-ID: <20130827210458.8714331C129@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: use i_size_read() to access i_size

Though ocfs2 uses inode->i_mutex to protect i_size, there are both
i_size_read/write() and direct accesses.  Clean up all direct access to
eliminate confusion.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c         |    2 +-
 fs/ocfs2/extent_map.c   |   10 +++++-----
 fs/ocfs2/ioctl.c        |    2 +-
 fs/ocfs2/journal.c      |    8 ++++----
 fs/ocfs2/move_extents.c |    2 +-
 fs/ocfs2/quota_global.c |    6 +++---
 fs/ocfs2/quota_local.c  |   12 ++++++------
 7 files changed, 21 insertions(+), 21 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/aops.c
@@ -2050,7 +2050,7 @@ int ocfs2_write_end_nolock(struct addres
 
 out_write_size:
 	pos += copied;
-	if (pos > inode->i_size) {
+	if (pos > i_size_read(inode)) {
 		i_size_write(inode, pos);
 		mark_inode_dirty(inode);
 	}
diff -puN fs/ocfs2/extent_map.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/extent_map.c
@@ -852,20 +852,20 @@ int ocfs2_seek_data_hole_offset(struct f
 
 	down_read(&OCFS2_I(inode)->ip_alloc_sem);
 
-	if (*offset >= inode->i_size) {
+	if (*offset >= i_size_read(inode)) {
 		ret = -ENXIO;
 		goto out_unlock;
 	}
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		if (whence == SEEK_HOLE)
-			*offset = inode->i_size;
+			*offset = i_size_read(inode);
 		goto out_unlock;
 	}
 
 	clen = 0;
 	cpos = *offset >> cs_bits;
-	cend = ocfs2_clusters_for_bytes(inode->i_sb, inode->i_size);
+	cend = ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode));
 
 	while (cpos < cend && !is_last) {
 		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos, &hole_size,
@@ -904,8 +904,8 @@ int ocfs2_seek_data_hole_offset(struct f
 		extlen = clen;
 		extlen <<=  cs_bits;
 
-		if ((extoff + extlen) > inode->i_size)
-			extlen = inode->i_size - extoff;
+		if ((extoff + extlen) > i_size_read(inode))
+			extlen = i_size_read(inode) - extoff;
 		extoff += extlen;
 		if (extoff > *offset)
 			*offset = extoff;
diff -puN fs/ocfs2/ioctl.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/ioctl.c
@@ -303,7 +303,7 @@ int ocfs2_info_handle_journal_size(struc
 	if (o2info_from_user(oij, req))
 		goto bail;
 
-	oij.ij_journal_size = osb->journal->j_inode->i_size;
+	oij.ij_journal_size = i_size_read(osb->journal->j_inode);
 
 	o2info_set_request_filled(&oij.ij_req);
 
diff -puN fs/ocfs2/journal.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/journal.c
@@ -836,14 +836,14 @@ int ocfs2_journal_init(struct ocfs2_jour
 	inode_lock = 1;
 	di = (struct ocfs2_dinode *)bh->b_data;
 
-	if (inode->i_size <  OCFS2_MIN_JOURNAL_SIZE) {
+	if (i_size_read(inode) <  OCFS2_MIN_JOURNAL_SIZE) {
 		mlog(ML_ERROR, "Journal file size (%lld) is too small!\n",
-		     inode->i_size);
+		     i_size_read(inode));
 		status = -EINVAL;
 		goto done;
 	}
 
-	trace_ocfs2_journal_init(inode->i_size,
+	trace_ocfs2_journal_init(i_size_read(inode),
 				 (unsigned long long)inode->i_blocks,
 				 OCFS2_I(inode)->ip_clusters);
 
@@ -1131,7 +1131,7 @@ static int ocfs2_force_read_journal(stru
 
 	memset(bhs, 0, sizeof(struct buffer_head *) * CONCURRENT_JOURNAL_FILL);
 
-	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, inode->i_size);
+	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
 	v_blkno = 0;
 	while (v_blkno < num_blocks) {
 		status = ocfs2_extent_map_get_blocks(inode, v_blkno,
diff -puN fs/ocfs2/move_extents.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/move_extents.c
@@ -845,7 +845,7 @@ static int __ocfs2_move_extents_range(st
 	struct ocfs2_move_extents *range = context->range;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if ((inode->i_size == 0) || (range->me_len == 0))
+	if ((i_size_read(inode) == 0) || (range->me_len == 0))
 		return 0;
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
diff -puN fs/ocfs2/quota_global.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/quota_global.c
--- a/fs/ocfs2/quota_global.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/quota_global.c
@@ -234,7 +234,7 @@ ssize_t ocfs2_quota_write(struct super_b
 		len = sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE - offset;
 	}
 
-	if (gqinode->i_size < off + len) {
+	if (i_size_read(gqinode) < off + len) {
 		loff_t rounded_end =
 				ocfs2_align_bytes_to_blocks(sb, off + len);
 
@@ -778,8 +778,8 @@ static int ocfs2_acquire_dquot(struct dq
 		 */
 		WARN_ON(journal_current_handle());
 		status = ocfs2_extend_no_holes(gqinode, NULL,
-			gqinode->i_size + (need_alloc << sb->s_blocksize_bits),
-			gqinode->i_size);
+			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
+			i_size_read(gqinode));
 		if (status < 0)
 			goto out_dq;
 	}
diff -puN fs/ocfs2/quota_local.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/quota_local.c
--- a/fs/ocfs2/quota_local.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/quota_local.c
@@ -982,14 +982,14 @@ static struct ocfs2_quota_chunk *ocfs2_l
 
 	/* We are protected by dqio_sem so no locking needed */
 	status = ocfs2_extend_no_holes(lqinode, NULL,
-				       lqinode->i_size + 2 * sb->s_blocksize,
-				       lqinode->i_size);
+				       i_size_read(lqinode) + 2 * sb->s_blocksize,
+				       i_size_read(lqinode));
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
 	}
 	status = ocfs2_simple_size_update(lqinode, oinfo->dqi_lqi_bh,
-					  lqinode->i_size + 2 * sb->s_blocksize);
+					  i_size_read(lqinode) + 2 * sb->s_blocksize);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
@@ -1125,14 +1125,14 @@ static struct ocfs2_quota_chunk *ocfs2_e
 
 	/* We are protected by dqio_sem so no locking needed */
 	status = ocfs2_extend_no_holes(lqinode, NULL,
-				       lqinode->i_size + sb->s_blocksize,
-				       lqinode->i_size);
+				       i_size_read(lqinode) + sb->s_blocksize,
+				       i_size_read(lqinode));
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
 	}
 	status = ocfs2_simple_size_update(lqinode, oinfo->dqi_lqi_bh,
-					  lqinode->i_size + sb->s_blocksize);
+					  i_size_read(lqinode) + sb->s_blocksize);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
_
