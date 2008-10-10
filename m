From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  9 Oct 2008 17:20:34 -0700
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: Make cached block reads the common
	case.
In-Reply-To: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
References: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1223598034-26284-7-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_read_blocks() currently requires the CACHED flag for cached I/O.
However, that's the common case.  Let's flip it around and provide an
IGNORE_CACHE flag for the special users.  This has the added benefit of
cleaning up the code some (ignore_cache takes on its special meaning
earlier in the loop).

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/buffer_head_io.c |   19 +++++++++++--------
 fs/ocfs2/buffer_head_io.h |    4 ++--
 fs/ocfs2/dir.c            |    2 +-
 fs/ocfs2/inode.c          |    3 ++-
 fs/ocfs2/journal.c        |    3 ++-
 fs/ocfs2/localalloc.c     |    4 ++--
 fs/ocfs2/slot_map.c       |    6 ++++--
 7 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 718dbe5..7e947c6 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -181,7 +181,8 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 		   inode, (unsigned long long)block, nr, flags);
 
 	BUG_ON(!inode);
-	BUG_ON((flags & OCFS2_BH_READAHEAD) && !(flags & OCFS2_BH_CACHED));
+	BUG_ON((flags & OCFS2_BH_READAHEAD) &&
+	       (flags & OCFS2_BH_IGNORE_CACHE));
 
 	if (bhs == NULL) {
 		status = -EINVAL;
@@ -214,7 +215,7 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 			}
 		}
 		bh = bhs[i];
-		ignore_cache = 0;
+		ignore_cache = (flags & OCFS2_BH_IGNORE_CACHE);
 
 		/* There are three read-ahead cases here which we need to
 		 * be concerned with. All three assume a buffer has
@@ -240,26 +241,27 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 		 *    before our is-it-in-flight check.
 		 */
 
-		if (flags & OCFS2_BH_CACHED &&
-		    !ocfs2_buffer_uptodate(inode, bh)) {
+		if (!ignore_cache && !ocfs2_buffer_uptodate(inode, bh)) {
 			mlog(ML_UPTODATE,
 			     "bh (%llu), inode %llu not uptodate\n",
 			     (unsigned long long)bh->b_blocknr,
 			     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			/* We're using ignore_cache here to say
+			 * "go to disk" */
 			ignore_cache = 1;
 		}
 
 		/* XXX: Can we ever get this and *not* have the cached
 		 * flag set? */
 		if (buffer_jbd(bh)) {
-			if (!(flags & OCFS2_BH_CACHED) || ignore_cache)
+			if (ignore_cache)
 				mlog(ML_BH_IO, "trying to sync read a jbd "
 					       "managed bh (blocknr = %llu)\n",
 				     (unsigned long long)bh->b_blocknr);
 			continue;
 		}
 
-		if (!(flags & OCFS2_BH_CACHED) || ignore_cache) {
+		if (ignore_cache) {
 			if (buffer_dirty(bh)) {
 				/* This should probably be a BUG, or
 				 * at least return an error. */
@@ -294,7 +296,7 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 			 * previously read-ahead buffer may have
 			 * completed I/O while we were waiting for the
 			 * buffer lock. */
-			if ((flags & OCFS2_BH_CACHED)
+			if (!(flags & OCFS2_BH_IGNORE_CACHE)
 			    && !(flags & OCFS2_BH_READAHEAD)
 			    && ocfs2_buffer_uptodate(inode, bh)) {
 				unlock_buffer(bh);
@@ -344,7 +346,8 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 
 	mlog(ML_BH_IO, "block=(%llu), nr=(%d), cached=%s, flags=0x%x\n", 
 	     (unsigned long long)block, nr,
-	     (!(flags & OCFS2_BH_CACHED) || ignore_cache) ? "no" : "yes", flags);
+	     ((flags & OCFS2_BH_IGNORE_CACHE) || ignore_cache) ? "no" : "yes",
+	     flags);
 
 bail:
 
diff --git a/fs/ocfs2/buffer_head_io.h b/fs/ocfs2/buffer_head_io.h
index a2ef9e5..75e1dcb 100644
--- a/fs/ocfs2/buffer_head_io.h
+++ b/fs/ocfs2/buffer_head_io.h
@@ -49,7 +49,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 				struct buffer_head *bh);
 
-#define OCFS2_BH_CACHED            1
+#define OCFS2_BH_IGNORE_CACHE      1
 #define OCFS2_BH_READAHEAD         8
 
 static inline int ocfs2_read_block(struct inode *inode, u64 off,
@@ -63,7 +63,7 @@ static inline int ocfs2_read_block(struct inode *inode, u64 off,
 		goto bail;
 	}
 
-	status = ocfs2_read_blocks(inode, off, 1, bh, OCFS2_BH_CACHED);
+	status = ocfs2_read_blocks(inode, off, 1, bh, 0);
 
 bail:
 	return status;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 63f4839..40cd761 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -213,7 +213,7 @@ static struct buffer_head *ocfs2_bread(struct inode *inode, int block,
 	struct buffer_head *bh = NULL;
 	int tmperr;
 	u64 p_blkno;
-	int readflags = OCFS2_BH_CACHED;
+	int readflags = 0;
 
 	if (reada)
 		readflags |= OCFS2_BH_READAHEAD;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 463c52d..886d77e 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -449,7 +449,8 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	}
 
 	if (can_lock)
-		status = ocfs2_read_blocks(inode, args->fi_blkno, 1, &bh, 0);
+		status = ocfs2_read_blocks(inode, args->fi_blkno, 1, &bh,
+					   OCFS2_BH_IGNORE_CACHE);
 	else
 		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
 	if (status < 0) {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ba646ef..ed7599d 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1187,7 +1187,8 @@ static int ocfs2_read_journal_inode(struct ocfs2_super *osb,
 	}
 	SET_INODE_JOURNAL(inode);
 
-	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1, bh, 0);
+	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1, bh,
+				   OCFS2_BH_IGNORE_CACHE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 9ac0be9..3dbdcc9 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -140,7 +140,7 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 	}
 
 	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1,
-				   &alloc_bh, 0);
+				   &alloc_bh, OCFS2_BH_IGNORE_CACHE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -346,7 +346,7 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 	mutex_lock(&inode->i_mutex);
 
 	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1,
-				   &alloc_bh, 0);
+				   &alloc_bh, OCFS2_BH_IGNORE_CACHE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 357d3fe..bdda2d8 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -150,7 +150,8 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 	 * be !NULL.  Thus, ocfs2_read_blocks() will ignore blocknr.  If
 	 * this is not true, the read of -1 (UINT64_MAX) will fail.
 	 */
-	ret = ocfs2_read_blocks(si->si_inode, -1, si->si_blocks, si->si_bh, 0);
+	ret = ocfs2_read_blocks(si->si_inode, -1, si->si_blocks, si->si_bh,
+				OCFS2_BH_IGNORE_CACHE);
 	if (ret == 0) {
 		spin_lock(&osb->osb_lock);
 		ocfs2_update_slot_info(si);
@@ -403,7 +404,8 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 		     (unsigned long long)blkno);
 
 		bh = NULL;  /* Acquire a fresh bh */
-		status = ocfs2_read_blocks(si->si_inode, blkno, 1, &bh, 0);
+		status = ocfs2_read_blocks(si->si_inode, blkno, 1, &bh,
+					   OCFS2_BH_IGNORE_CACHE);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
-- 
1.5.6.5
