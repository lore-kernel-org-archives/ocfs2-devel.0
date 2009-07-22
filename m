From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Jul 2009 13:17:17 +0200
Subject: [Ocfs2-devel] [PATCH 3/7] ocfs2: Initialize blocks allocated to
	local quota file
In-Reply-To: <1248261441-29384-1-git-send-email-jack@suse.cz>
References: <1248261441-29384-1-git-send-email-jack@suse.cz>
Message-ID: <1248261441-29384-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we extend local quota file, we should initialize data
in newly allocated block. Firstly because on recovery we could
parse bogus data, secondly so that block checksums are properly
computed.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c |   98 ++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 83 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index b624f9b..9d2993d 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -941,7 +941,7 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 	struct ocfs2_local_disk_chunk *dchunk;
 	int status;
 	handle_t *handle;
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh = NULL, *dbh = NULL;
 	u64 p_blkno;
 
 	/* We are protected by dqio_sem so no locking needed */
@@ -965,34 +965,32 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 		mlog_errno(status);
 		goto out;
 	}
+	handle = ocfs2_start_trans(OCFS2_SB(sb), 3);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		mlog_errno(status);
+		goto out;
+	}
 
+	/* Initialize chunk header */
 	down_read(&OCFS2_I(lqinode)->ip_alloc_sem);
 	status = ocfs2_extent_map_get_blocks(lqinode, oinfo->dqi_blocks,
 					     &p_blkno, NULL, NULL);
 	up_read(&OCFS2_I(lqinode)->ip_alloc_sem);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out;
+		goto out_trans;
 	}
 	bh = sb_getblk(sb, p_blkno);
 	if (!bh) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto out;
+		goto out_trans;
 	}
-	ocfs2_set_new_buffer_uptodate(lqinode, bh);
-
 	dchunk = (struct ocfs2_local_disk_chunk *)bh->b_data;
-
-	handle = ocfs2_start_trans(OCFS2_SB(sb), 2);
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		mlog_errno(status);
-		goto out;
-	}
-
+	ocfs2_set_new_buffer_uptodate(lqinode, bh);
 	status = ocfs2_journal_access_dq(handle, lqinode, bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
+					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_trans;
@@ -1009,6 +1007,38 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 		goto out_trans;
 	}
 
+	/* Initialize new block with structures */
+	down_read(&OCFS2_I(lqinode)->ip_alloc_sem);
+	status = ocfs2_extent_map_get_blocks(lqinode, oinfo->dqi_blocks + 1,
+					     &p_blkno, NULL, NULL);
+	up_read(&OCFS2_I(lqinode)->ip_alloc_sem);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_trans;
+	}
+	dbh = sb_getblk(sb, p_blkno);
+	if (!dbh) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto out_trans;
+	}
+	ocfs2_set_new_buffer_uptodate(lqinode, dbh);
+	status = ocfs2_journal_access_dq(handle, lqinode, dbh,
+					 OCFS2_JOURNAL_ACCESS_CREATE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_trans;
+	}
+	lock_buffer(dbh);
+	memset(dbh->b_data, 0, sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE);
+	unlock_buffer(dbh);
+	status = ocfs2_journal_dirty(handle, dbh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_trans;
+	}
+
+	/* Update local quotafile info */
 	oinfo->dqi_blocks += 2;
 	oinfo->dqi_chunks++;
 	status = ocfs2_local_write_info(sb, type);
@@ -1033,6 +1063,7 @@ out_trans:
 	ocfs2_commit_trans(OCFS2_SB(sb), handle);
 out:
 	brelse(bh);
+	brelse(dbh);
 	kmem_cache_free(ocfs2_qf_chunk_cachep, chunk);
 	return ERR_PTR(status);
 }
@@ -1050,6 +1081,8 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 	struct ocfs2_local_disk_chunk *dchunk;
 	int epb = ol_quota_entries_per_block(sb);
 	unsigned int chunk_blocks;
+	struct buffer_head *bh;
+	u64 p_blkno;
 	int status;
 	handle_t *handle;
 
@@ -1077,12 +1110,46 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 		mlog_errno(status);
 		goto out;
 	}
-	handle = ocfs2_start_trans(OCFS2_SB(sb), 2);
+
+	/* Get buffer from the just added block */
+	down_read(&OCFS2_I(lqinode)->ip_alloc_sem);
+	status = ocfs2_extent_map_get_blocks(lqinode, oinfo->dqi_blocks,
+					     &p_blkno, NULL, NULL);
+	up_read(&OCFS2_I(lqinode)->ip_alloc_sem);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+	bh = sb_getblk(sb, p_blkno);
+	if (!bh) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto out;
+	}
+	ocfs2_set_new_buffer_uptodate(lqinode, bh);
+
+	handle = ocfs2_start_trans(OCFS2_SB(sb), 3);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
 		goto out;
 	}
+	/* Zero created block */
+	status = ocfs2_journal_access_dq(handle, lqinode, bh,
+				 OCFS2_JOURNAL_ACCESS_CREATE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_trans;
+	}
+	lock_buffer(bh);
+	memset(bh->b_data, 0, sb->s_blocksize);
+	unlock_buffer(bh);
+	status = ocfs2_journal_dirty(handle, bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_trans;
+	}
+	/* Update chunk header */
 	status = ocfs2_journal_access_dq(handle, lqinode, chunk->qc_headerbh,
 				 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
@@ -1099,6 +1166,7 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 		mlog_errno(status);
 		goto out_trans;
 	}
+	/* Update file header */
 	oinfo->dqi_blocks++;
 	status = ocfs2_local_write_info(sb, type);
 	if (status < 0) {
-- 
1.6.0.2
