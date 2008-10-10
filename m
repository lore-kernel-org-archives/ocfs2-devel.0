From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  9 Oct 2008 17:20:30 -0700
Subject: [Ocfs2-devel] [PATCH 2/6] ocfs2: Require an inode for
	ocfs2_read_block(s)().
In-Reply-To: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
References: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1223598034-26284-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now that synchronous readers are using ocfs2_read_blocks_sync(), all
callers of ocfs2_read_blocks() are passing an inode.  Use it
unconditionally.  Since it's there, we don't need to pass the
ocfs2_super either.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c          |   33 ++++++++++++++-------------------
 fs/ocfs2/aops.c           |    9 ++++-----
 fs/ocfs2/buffer_head_io.c |   35 ++++++++++++-----------------------
 fs/ocfs2/buffer_head_io.h |   18 +++++++-----------
 fs/ocfs2/dir.c            |   12 ++++++------
 fs/ocfs2/dlmglue.c        |    9 ++++-----
 fs/ocfs2/extent_map.c     |    8 ++++----
 fs/ocfs2/file.c           |   12 +++++-------
 fs/ocfs2/inode.c          |    6 ++----
 fs/ocfs2/journal.c        |    2 +-
 fs/ocfs2/localalloc.c     |    8 ++++----
 fs/ocfs2/namei.c          |    5 ++---
 fs/ocfs2/resize.c         |    4 ++--
 fs/ocfs2/slot_map.c       |    5 ++---
 fs/ocfs2/suballoc.c       |   17 ++++++++---------
 fs/ocfs2/symlink.c        |    5 ++---
 16 files changed, 79 insertions(+), 109 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 134c56d..183f08f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -384,8 +384,8 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 	}
 
 	if (fe->i_last_eb_blk) {
-		retval = ocfs2_read_block(osb, le64_to_cpu(fe->i_last_eb_blk),
-					  &eb_bh, OCFS2_BH_CACHED, inode);
+		retval = ocfs2_read_block(inode, le64_to_cpu(fe->i_last_eb_blk),
+					  &eb_bh, OCFS2_BH_CACHED);
 		if (retval < 0) {
 			mlog_errno(retval);
 			goto bail;
@@ -869,8 +869,7 @@ static int ocfs2_find_branch_target(struct ocfs2_super *osb,
 			bh = NULL;
 		}
 
-		status = ocfs2_read_block(osb, blkno, &bh, OCFS2_BH_CACHED,
-					  inode);
+		status = ocfs2_read_block(inode, blkno, &bh, OCFS2_BH_CACHED);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1245,8 +1244,7 @@ static int __ocfs2_find_path(struct inode *inode,
 
 		brelse(bh);
 		bh = NULL;
-		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno,
-				       &bh, OCFS2_BH_CACHED, inode);
+		ret = ocfs2_read_block(inode, blkno, &bh, OCFS2_BH_CACHED);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4000,9 +3998,8 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		 * ocfs2_figure_insert_type() and ocfs2_add_branch()
 		 * may want it later.
 		 */
-		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       le64_to_cpu(di->i_last_eb_blk), &bh,
-				       OCFS2_BH_CACHED, inode);
+		ret = ocfs2_read_block(inode, le64_to_cpu(di->i_last_eb_blk),
+				       &bh, OCFS2_BH_CACHED);
 		if (ret) {
 			mlog_exit(ret);
 			goto out;
@@ -4368,9 +4365,8 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 		struct ocfs2_extent_block *eb;
 		struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
-		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       le64_to_cpu(di->i_last_eb_blk),
-				       &last_eb_bh, OCFS2_BH_CACHED, inode);
+		ret = ocfs2_read_block(inode, le64_to_cpu(di->i_last_eb_blk),
+				       &last_eb_bh, OCFS2_BH_CACHED);
 		if (ret) {
 			mlog_exit(ret);
 			goto out;
@@ -4522,9 +4518,8 @@ static int ocfs2_split_tree(struct inode *inode, struct buffer_head *di_bh,
 
 	depth = path->p_tree_depth;
 	if (depth > 0) {
-		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       le64_to_cpu(di->i_last_eb_blk),
-				       &last_eb_bh, OCFS2_BH_CACHED, inode);
+		ret = ocfs2_read_block(inode, le64_to_cpu(di->i_last_eb_blk),
+				       &last_eb_bh, OCFS2_BH_CACHED);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -5188,8 +5183,8 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, &bh,
-				  OCFS2_BH_CACHED, inode);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh,
+				  OCFS2_BH_CACHED);
 	if (status < 0) {
 		iput(inode);
 		mlog_errno(status);
@@ -6575,8 +6570,8 @@ int ocfs2_prepare_truncate(struct ocfs2_super *osb,
 	ocfs2_init_dealloc_ctxt(&(*tc)->tc_dealloc);
 
 	if (fe->id2.i_list.l_tree_depth) {
-		status = ocfs2_read_block(osb, le64_to_cpu(fe->i_last_eb_blk),
-					  &last_eb_bh, OCFS2_BH_CACHED, inode);
+		status = ocfs2_read_block(inode, le64_to_cpu(fe->i_last_eb_blk),
+					  &last_eb_bh, OCFS2_BH_CACHED);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 28bb7f0..84e63ac 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -68,9 +68,8 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 		goto bail;
 	}
 
-	status = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				  OCFS2_I(inode)->ip_blkno,
-				  &bh, OCFS2_BH_CACHED, inode);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
+				  &bh, OCFS2_BH_CACHED);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -266,8 +265,8 @@ static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
-	ret = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, &di_bh,
-			       OCFS2_BH_CACHED, inode);
+	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &di_bh,
+			       OCFS2_BH_CACHED);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index ca4ab7c..718dbe5 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -170,22 +170,20 @@ bail:
 	return status;
 }
 
-int ocfs2_read_blocks(struct ocfs2_super *osb, u64 block, int nr,
-		      struct buffer_head *bhs[], int flags,
-		      struct inode *inode)
+int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
+		      struct buffer_head *bhs[], int flags)
 {
 	int status = 0;
-	struct super_block *sb;
 	int i, ignore_cache = 0;
 	struct buffer_head *bh;
 
-	mlog_entry("(block=(%llu), nr=(%d), flags=%d, inode=%p)\n",
-		   (unsigned long long)block, nr, flags, inode);
+	mlog_entry("(inode=%p, block=(%llu), nr=(%d), flags=%d)\n",
+		   inode, (unsigned long long)block, nr, flags);
 
-	BUG_ON((flags & OCFS2_BH_READAHEAD) &&
-	       (!inode || !(flags & OCFS2_BH_CACHED)));
+	BUG_ON(!inode);
+	BUG_ON((flags & OCFS2_BH_READAHEAD) && !(flags & OCFS2_BH_CACHED));
 
-	if (osb == NULL || osb->sb == NULL || bhs == NULL) {
+	if (bhs == NULL) {
 		status = -EINVAL;
 		mlog_errno(status);
 		goto bail;
@@ -204,19 +202,12 @@ int ocfs2_read_blocks(struct ocfs2_super *osb, u64 block, int nr,
 		goto bail;
 	}
 
-	sb = osb->sb;
-
-	if (flags & OCFS2_BH_CACHED && !inode)
-		flags &= ~OCFS2_BH_CACHED;
-
-	if (inode)
-		mutex_lock(&OCFS2_I(inode)->ip_io_mutex);
+	mutex_lock(&OCFS2_I(inode)->ip_io_mutex);
 	for (i = 0 ; i < nr ; i++) {
 		if (bhs[i] == NULL) {
-			bhs[i] = sb_getblk(sb, block++);
+			bhs[i] = sb_getblk(inode->i_sb, block++);
 			if (bhs[i] == NULL) {
-				if (inode)
-					mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
+				mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
 				status = -EIO;
 				mlog_errno(status);
 				goto bail;
@@ -347,11 +338,9 @@ int ocfs2_read_blocks(struct ocfs2_super *osb, u64 block, int nr,
 		/* Always set the buffer in the cache, even if it was
 		 * a forced read, or read-ahead which hasn't yet
 		 * completed. */
-		if (inode)
-			ocfs2_set_buffer_uptodate(inode, bh);
+		ocfs2_set_buffer_uptodate(inode, bh);
 	}
-	if (inode)
-		mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
+	mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
 
 	mlog(ML_BH_IO, "block=(%llu), nr=(%d), cached=%s, flags=0x%x\n", 
 	     (unsigned long long)block, nr,
diff --git a/fs/ocfs2/buffer_head_io.h b/fs/ocfs2/buffer_head_io.h
index 71646b4..fd0d774 100644
--- a/fs/ocfs2/buffer_head_io.h
+++ b/fs/ocfs2/buffer_head_io.h
@@ -31,21 +31,19 @@
 void ocfs2_end_buffer_io_sync(struct buffer_head *bh,
 			     int uptodate);
 
-static inline int ocfs2_read_block(struct ocfs2_super          *osb,
+static inline int ocfs2_read_block(struct inode	       *inode,
 				   u64                  off,
 				   struct buffer_head **bh,
-				   int                  flags,
-				   struct inode        *inode);
+				   int                  flags);
 
 int ocfs2_write_block(struct ocfs2_super          *osb,
 		      struct buffer_head  *bh,
 		      struct inode        *inode);
-int ocfs2_read_blocks(struct ocfs2_super          *osb,
+int ocfs2_read_blocks(struct inode	  *inode,
 		      u64                  block,
 		      int                  nr,
 		      struct buffer_head  *bhs[],
-		      int                  flags,
-		      struct inode        *inode);
+		      int                  flags);
 int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 			   unsigned int nr, struct buffer_head *bhs[]);
 
@@ -55,9 +53,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 #define OCFS2_BH_CACHED            1
 #define OCFS2_BH_READAHEAD         8
 
-static inline int ocfs2_read_block(struct ocfs2_super * osb, u64 off,
-				   struct buffer_head **bh, int flags,
-				   struct inode *inode)
+static inline int ocfs2_read_block(struct inode *inode, u64 off,
+				   struct buffer_head **bh, int flags)
 {
 	int status = 0;
 
@@ -67,8 +64,7 @@ static inline int ocfs2_read_block(struct ocfs2_super * osb, u64 off,
 		goto bail;
 	}
 
-	status = ocfs2_read_blocks(osb, off, 1, bh,
-				   flags, inode);
+	status = ocfs2_read_blocks(inode, off, 1, bh, flags);
 
 bail:
 	return status;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 9cce563..e2de2aa 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -188,8 +188,8 @@ static struct buffer_head *ocfs2_find_entry_id(const char *name,
 	struct ocfs2_dinode *di;
 	struct ocfs2_inline_data *data;
 
-	ret = ocfs2_read_block(OCFS2_SB(dir->i_sb), OCFS2_I(dir)->ip_blkno,
-			       &di_bh, OCFS2_BH_CACHED, dir);
+	ret = ocfs2_read_block(dir, OCFS2_I(dir)->ip_blkno, &di_bh,
+			       OCFS2_BH_CACHED);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -417,8 +417,8 @@ static inline int ocfs2_delete_entry_id(handle_t *handle,
 	struct ocfs2_dinode *di;
 	struct ocfs2_inline_data *data;
 
-	ret = ocfs2_read_block(OCFS2_SB(dir->i_sb), OCFS2_I(dir)->ip_blkno,
-			       &di_bh, OCFS2_BH_CACHED, dir);
+	ret = ocfs2_read_block(dir, OCFS2_I(dir)->ip_blkno,
+			       &di_bh, OCFS2_BH_CACHED);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -596,8 +596,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 	struct ocfs2_inline_data *data;
 	struct ocfs2_dir_entry *de;
 
-	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), OCFS2_I(inode)->ip_blkno,
-			       &di_bh, OCFS2_BH_CACHED, inode);
+	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
+			       &di_bh, OCFS2_BH_CACHED);
 	if (ret) {
 		mlog(ML_ERROR, "Unable to read inode block for dir %llu\n",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index eae3d64..3b2cd0f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2024,8 +2024,8 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 	} else {
 		/* Boo, we have to go to disk. */
 		/* read bh, cast, ocfs2_refresh_inode */
-		status = ocfs2_read_block(OCFS2_SB(inode->i_sb), oi->ip_blkno,
-					  bh, OCFS2_BH_CACHED, inode);
+		status = ocfs2_read_block(inode, oi->ip_blkno,
+					  bh, OCFS2_BH_CACHED);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail_refresh;
@@ -2086,11 +2086,10 @@ static int ocfs2_assign_bh(struct inode *inode,
 		return 0;
 	}
 
-	status = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+	status = ocfs2_read_block(inode,
 				  OCFS2_I(inode)->ip_blkno,
 				  ret_bh,
-				  OCFS2_BH_CACHED,
-				  inode);
+				  OCFS2_BH_CACHED);
 	if (status < 0)
 		mlog_errno(status);
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index c58668a..177cf48 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -335,9 +335,9 @@ static int ocfs2_figure_hole_clusters(struct inode *inode,
 		if (le64_to_cpu(eb->h_next_leaf_blk) == 0ULL)
 			goto no_more_extents;
 
-		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+		ret = ocfs2_read_block(inode,
 				       le64_to_cpu(eb->h_next_leaf_blk),
-				       &next_eb_bh, OCFS2_BH_CACHED, inode);
+				       &next_eb_bh, OCFS2_BH_CACHED);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -398,8 +398,8 @@ int ocfs2_get_clusters(struct inode *inode, u32 v_cluster,
 	if (ret == 0)
 		goto out;
 
-	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), OCFS2_I(inode)->ip_blkno,
-			       &di_bh, OCFS2_BH_CACHED, inode);
+	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
+			       &di_bh, OCFS2_BH_CACHED);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2f2217a..2b27136 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -707,8 +707,8 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	 */
 	BUG_ON(mark_unwritten && !ocfs2_sparse_alloc(osb));
 
-	status = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, &bh,
-				  OCFS2_BH_CACHED, inode);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh,
+				  OCFS2_BH_CACHED);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1290,8 +1290,7 @@ static int ocfs2_write_remove_suid(struct inode *inode)
 	struct buffer_head *bh = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-			       oi->ip_blkno, &bh, OCFS2_BH_CACHED, inode);
+	ret = ocfs2_read_block(inode, oi->ip_blkno, &bh, OCFS2_BH_CACHED);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -1317,9 +1316,8 @@ static int ocfs2_allocate_unwritten_extents(struct inode *inode,
 	struct buffer_head *di_bh = NULL;
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
-		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       OCFS2_I(inode)->ip_blkno, &di_bh,
-				       OCFS2_BH_CACHED, inode);
+		ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
+				       &di_bh, OCFS2_BH_CACHED);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ba79e6d..ed71305 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -449,8 +449,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	}
 
 	if (can_lock)
-		status = ocfs2_read_block(osb, args->fi_blkno, &bh, 0,
-					  inode);
+		status = ocfs2_read_block(inode, args->fi_blkno, &bh, 0);
 	else
 		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
 	if (status < 0) {
@@ -1147,8 +1146,7 @@ struct buffer_head *ocfs2_bread(struct inode *inode,
 		goto fail;
 	}
 
-	tmperr = ocfs2_read_block(OCFS2_SB(inode->i_sb), p_blkno, &bh,
-				  readflags, inode);
+	tmperr = ocfs2_read_block(inode, p_blkno, &bh, readflags);
 	if (tmperr < 0)
 		goto fail;
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index e531a98..6e63845 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1187,7 +1187,7 @@ static int ocfs2_read_journal_inode(struct ocfs2_super *osb,
 	}
 	SET_INODE_JOURNAL(inode);
 
-	status = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, bh, 0, inode);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, bh, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 4b15885..52d2e1f 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -139,8 +139,8 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	status = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno,
-				  &alloc_bh, 0, inode);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
+				  &alloc_bh, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -345,8 +345,8 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 
 	mutex_lock(&inode->i_mutex);
 
-	status = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno,
-				  &alloc_bh, 0, inode);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
+				  &alloc_bh, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d5d808f..dd8605e 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1780,10 +1780,9 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 
 	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
 
-	status = ocfs2_read_block(osb,
+	status = ocfs2_read_block(orphan_dir_inode,
 				  OCFS2_I(orphan_dir_inode)->ip_blkno,
-				  &orphan_dir_bh, OCFS2_BH_CACHED,
-				  orphan_dir_inode);
+				  &orphan_dir_bh, OCFS2_BH_CACHED);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 472d854..92dcd93 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -332,8 +332,8 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	lgd_blkno = ocfs2_which_cluster_group(main_bm_inode,
 					      first_new_cluster - 1);
 
-	ret = ocfs2_read_block(osb, lgd_blkno, &group_bh, OCFS2_BH_CACHED,
-			       main_bm_inode);
+	ret = ocfs2_read_block(main_bm_inode, lgd_blkno, &group_bh,
+			       OCFS2_BH_CACHED);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_unlock;
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index bb5ff89..82d986b 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -150,8 +150,7 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 	 * be !NULL.  Thus, ocfs2_read_blocks() will ignore blocknr.  If
 	 * this is not true, the read of -1 (UINT64_MAX) will fail.
 	 */
-	ret = ocfs2_read_blocks(osb, -1, si->si_blocks, si->si_bh, 0,
-				si->si_inode);
+	ret = ocfs2_read_blocks(si->si_inode, -1, si->si_blocks, si->si_bh, 0);
 	if (ret == 0) {
 		spin_lock(&osb->osb_lock);
 		ocfs2_update_slot_info(si);
@@ -404,7 +403,7 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 		     (unsigned long long)blkno);
 
 		bh = NULL;  /* Acquire a fresh bh */
-		status = ocfs2_read_block(osb, blkno, &bh, 0, si->si_inode);
+		status = ocfs2_read_block(si->si_inode, blkno, &bh, 0);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index fd74fe3..aeab126 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1170,8 +1170,8 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	struct ocfs2_group_desc *gd;
 	struct inode *alloc_inode = ac->ac_inode;
 
-	ret = ocfs2_read_block(OCFS2_SB(alloc_inode->i_sb), gd_blkno,
-			       &group_bh, OCFS2_BH_CACHED, alloc_inode);
+	ret = ocfs2_read_block(alloc_inode, gd_blkno,
+			       &group_bh, OCFS2_BH_CACHED);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -1240,9 +1240,9 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	     bits_wanted, chain,
 	     (unsigned long long)OCFS2_I(alloc_inode)->ip_blkno);
 
-	status = ocfs2_read_block(OCFS2_SB(alloc_inode->i_sb),
+	status = ocfs2_read_block(alloc_inode,
 				  le64_to_cpu(cl->cl_recs[chain].c_blkno),
-				  &group_bh, OCFS2_BH_CACHED, alloc_inode);
+				  &group_bh, OCFS2_BH_CACHED);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1271,9 +1271,9 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 		next_group = le64_to_cpu(bg->bg_next_group);
 		prev_group_bh = group_bh;
 		group_bh = NULL;
-		status = ocfs2_read_block(OCFS2_SB(alloc_inode->i_sb),
+		status = ocfs2_read_block(alloc_inode,
 					  next_group, &group_bh,
-					  OCFS2_BH_CACHED, alloc_inode);
+					  OCFS2_BH_CACHED);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1778,7 +1778,6 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 {
 	int status = 0;
 	u32 tmp_used;
-	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) alloc_bh->b_data;
 	struct ocfs2_chain_list *cl = &fe->id2.i_chain;
 	struct buffer_head *group_bh = NULL;
@@ -1797,8 +1796,8 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 	     (unsigned long long)OCFS2_I(alloc_inode)->ip_blkno, count,
 	     (unsigned long long)bg_blkno, start_bit);
 
-	status = ocfs2_read_block(osb, bg_blkno, &group_bh, OCFS2_BH_CACHED,
-				  alloc_inode);
+	status = ocfs2_read_block(alloc_inode, bg_blkno, &group_bh,
+				  OCFS2_BH_CACHED);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index ba9dbb5..f2c064d 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -83,11 +83,10 @@ static char *ocfs2_fast_symlink_getlink(struct inode *inode,
 
 	mlog_entry_void();
 
-	status = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+	status = ocfs2_read_block(inode,
 				  OCFS2_I(inode)->ip_blkno,
 				  bh,
-				  OCFS2_BH_CACHED,
-				  inode);
+				  OCFS2_BH_CACHED);
 	if (status < 0) {
 		mlog_errno(status);
 		link = ERR_PTR(status);
-- 
1.5.6.5
