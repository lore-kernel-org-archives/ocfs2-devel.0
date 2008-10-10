From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  9 Oct 2008 17:20:29 -0700
Subject: [Ocfs2-devel] [PATCH 1/6] ocfs2: Separate out sync reads from
	ocfs2_read_blocks()
In-Reply-To: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
References: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1223598034-26284-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ocfs2_read_blocks() function currently handles sync reads, cached,
reads, and sometimes cached reads.  We're going to add some
functionality to it, so first we should simplify it.  The uncached,
synchronous reads are much easer to handle as a separate function, so we
instroduce ocfs2_read_blocks_sync().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/buffer_head_io.c |   84 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/buffer_head_io.h |    2 +
 fs/ocfs2/inode.c          |    7 +++-
 fs/ocfs2/journal.c        |    5 +--
 fs/ocfs2/resize.c         |    8 ++--
 5 files changed, 96 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index f136639..ca4ab7c 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -66,7 +66,7 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 	/* remove from dirty list before I/O. */
 	clear_buffer_dirty(bh);
 
-	get_bh(bh); /* for end_buffer_write_sync() */                   
+	get_bh(bh); /* for end_buffer_write_sync() */
 	bh->b_end_io = end_buffer_write_sync;
 	submit_bh(WRITE, bh);
 
@@ -88,6 +88,88 @@ out:
 	return ret;
 }
 
+int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
+			   unsigned int nr, struct buffer_head *bhs[])
+{
+	int status = 0;
+	unsigned int i;
+	struct buffer_head *bh;
+
+	if (!nr) {
+		mlog(ML_BH_IO, "No buffers will be read!\n");
+		goto bail;
+	}
+
+	for (i = 0 ; i < nr ; i++) {
+		if (bhs[i] == NULL) {
+			bhs[i] = sb_getblk(osb->sb, block++);
+			if (bhs[i] == NULL) {
+				status = -EIO;
+				mlog_errno(status);
+				goto bail;
+			}
+		}
+		bh = bhs[i];
+
+		if (buffer_jbd(bh)) {
+			mlog(ML_ERROR,
+			     "trying to sync read a jbd "
+			     "managed bh (blocknr = %llu), skipping\n",
+			     (unsigned long long)bh->b_blocknr);
+			continue;
+		}
+
+		if (buffer_dirty(bh)) {
+			/* This should probably be a BUG, or
+			 * at least return an error. */
+			mlog(ML_ERROR,
+			     "trying to sync read a dirty "
+			     "buffer! (blocknr = %llu), skipping\n",
+			     (unsigned long long)bh->b_blocknr);
+			continue;
+		}
+
+		lock_buffer(bh);
+		if (buffer_jbd(bh)) {
+			mlog(ML_ERROR,
+			     "block %llu had the JBD bit set "
+			     "while I was in lock_buffer!",
+			     (unsigned long long)bh->b_blocknr);
+			BUG();
+		}
+
+		clear_buffer_uptodate(bh);
+		get_bh(bh); /* for end_buffer_read_sync() */
+		bh->b_end_io = end_buffer_read_sync;
+		submit_bh(READ, bh);
+	}
+
+	for (i = nr; i > 0; i--) {
+		bh = bhs[i - 1];
+
+		if (buffer_jbd(bh)) {
+			mlog(ML_ERROR,
+			     "the journal got the buffer while it was "
+			     "locked for io! (blocknr = %llu)\n",
+			     (unsigned long long)bh->b_blocknr);
+			BUG();
+		}
+
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh)) {
+			/* Status won't be cleared from here on out,
+			 * so we can safely record this and loop back
+			 * to cleanup the other buffers. */
+			status = -EIO;
+			put_bh(bh);
+			bhs[i - 1] = NULL;
+		}
+	}
+
+bail:
+	return status;
+}
+
 int ocfs2_read_blocks(struct ocfs2_super *osb, u64 block, int nr,
 		      struct buffer_head *bhs[], int flags,
 		      struct inode *inode)
diff --git a/fs/ocfs2/buffer_head_io.h b/fs/ocfs2/buffer_head_io.h
index c2e7861..71646b4 100644
--- a/fs/ocfs2/buffer_head_io.h
+++ b/fs/ocfs2/buffer_head_io.h
@@ -46,6 +46,8 @@ int ocfs2_read_blocks(struct ocfs2_super          *osb,
 		      struct buffer_head  *bhs[],
 		      int                  flags,
 		      struct inode        *inode);
+int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
+			   unsigned int nr, struct buffer_head *bhs[]);
 
 int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 				struct buffer_head *bh);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ce8ec09..ba79e6d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -448,8 +448,11 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 		}
 	}
 
-	status = ocfs2_read_block(osb, args->fi_blkno, &bh, 0,
-				  can_lock ? inode : NULL);
+	if (can_lock)
+		status = ocfs2_read_block(osb, args->fi_blkno, &bh, 0,
+					  inode);
+	else
+		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index d17d4a9..e531a98 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -902,9 +902,8 @@ static int ocfs2_force_read_journal(struct inode *inode)
 
 		/* We are reading journal data which should not
 		 * be put in the uptodate cache */
-		status = ocfs2_read_blocks(OCFS2_SB(inode->i_sb),
-					   p_blkno, p_blocks, bhs, 0,
-					   NULL);
+		status = ocfs2_read_blocks_sync(OCFS2_SB(inode->i_sb),
+						p_blkno, p_blocks, bhs);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 8166968..472d854 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -200,7 +200,7 @@ static int update_backups(struct inode * inode, u32 clusters, char *data)
 		if (cluster > clusters)
 			break;
 
-		ret = ocfs2_read_block(osb, blkno, &backup, 0, NULL);
+		ret = ocfs2_read_blocks_sync(osb, blkno, 1, &backup);
 		if (ret < 0) {
 			mlog_errno(ret);
 			break;
@@ -236,8 +236,8 @@ static void ocfs2_update_super_and_backups(struct inode *inode,
 	 * update the superblock last.
 	 * It doesn't matter if the write failed.
 	 */
-	ret = ocfs2_read_block(osb, OCFS2_SUPER_BLOCK_BLKNO,
-			       &super_bh, 0, NULL);
+	ret = ocfs2_read_blocks_sync(osb, OCFS2_SUPER_BLOCK_BLKNO, 1,
+				     &super_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -540,7 +540,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		goto out_unlock;
 	}
 
-	ret = ocfs2_read_block(osb, input->group, &group_bh, 0, NULL);
+	ret = ocfs2_read_blocks_sync(osb, input->group, 1, &group_bh);
 	if (ret < 0) {
 		mlog(ML_ERROR, "Can't read the group descriptor # %llu "
 		     "from the device.", (unsigned long long)input->group);
-- 
1.5.6.5
