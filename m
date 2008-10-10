From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  9 Oct 2008 17:20:31 -0700
Subject: [Ocfs2-devel] [PATCH 3/6] ocfs2: Simplify ocfs2_read_block()
In-Reply-To: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
References: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1223598034-26284-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

More than 30 callers of ocfs2_read_block() pass exactly OCFS2_BH_CACHED.
Only six pass a different flag set.  Rather than have every caller care,
let's make ocfs2_read_block() take no flags and always do a cached read.
The remaining six places can call ocfs2_read_blocks() directly.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c          |   17 ++++++++---------
 fs/ocfs2/aops.c           |    7 ++-----
 fs/ocfs2/buffer_head_io.h |    7 +++----
 fs/ocfs2/dir.c            |    9 +++------
 fs/ocfs2/dlmglue.c        |    8 ++------
 fs/ocfs2/extent_map.c     |    5 ++---
 fs/ocfs2/file.c           |    7 +++----
 fs/ocfs2/inode.c          |    4 ++--
 fs/ocfs2/journal.c        |    2 +-
 fs/ocfs2/localalloc.c     |    8 ++++----
 fs/ocfs2/namei.c          |    2 +-
 fs/ocfs2/resize.c         |    3 +--
 fs/ocfs2/slot_map.c       |    2 +-
 fs/ocfs2/suballoc.c       |   11 ++++-------
 fs/ocfs2/symlink.c        |    5 +----
 15 files changed, 38 insertions(+), 59 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 183f08f..b41bd1f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -385,7 +385,7 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 
 	if (fe->i_last_eb_blk) {
 		retval = ocfs2_read_block(inode, le64_to_cpu(fe->i_last_eb_blk),
-					  &eb_bh, OCFS2_BH_CACHED);
+					  &eb_bh);
 		if (retval < 0) {
 			mlog_errno(retval);
 			goto bail;
@@ -869,7 +869,7 @@ static int ocfs2_find_branch_target(struct ocfs2_super *osb,
 			bh = NULL;
 		}
 
-		status = ocfs2_read_block(inode, blkno, &bh, OCFS2_BH_CACHED);
+		status = ocfs2_read_block(inode, blkno, &bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1244,7 +1244,7 @@ static int __ocfs2_find_path(struct inode *inode,
 
 		brelse(bh);
 		bh = NULL;
-		ret = ocfs2_read_block(inode, blkno, &bh, OCFS2_BH_CACHED);
+		ret = ocfs2_read_block(inode, blkno, &bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3999,7 +3999,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		 * may want it later.
 		 */
 		ret = ocfs2_read_block(inode, le64_to_cpu(di->i_last_eb_blk),
-				       &bh, OCFS2_BH_CACHED);
+				       &bh);
 		if (ret) {
 			mlog_exit(ret);
 			goto out;
@@ -4366,7 +4366,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 		struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
 		ret = ocfs2_read_block(inode, le64_to_cpu(di->i_last_eb_blk),
-				       &last_eb_bh, OCFS2_BH_CACHED);
+				       &last_eb_bh);
 		if (ret) {
 			mlog_exit(ret);
 			goto out;
@@ -4519,7 +4519,7 @@ static int ocfs2_split_tree(struct inode *inode, struct buffer_head *di_bh,
 	depth = path->p_tree_depth;
 	if (depth > 0) {
 		ret = ocfs2_read_block(inode, le64_to_cpu(di->i_last_eb_blk),
-				       &last_eb_bh, OCFS2_BH_CACHED);
+				       &last_eb_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -5183,8 +5183,7 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh,
-				  OCFS2_BH_CACHED);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh);
 	if (status < 0) {
 		iput(inode);
 		mlog_errno(status);
@@ -6571,7 +6570,7 @@ int ocfs2_prepare_truncate(struct ocfs2_super *osb,
 
 	if (fe->id2.i_list.l_tree_depth) {
 		status = ocfs2_read_block(inode, le64_to_cpu(fe->i_last_eb_blk),
-					  &last_eb_bh, OCFS2_BH_CACHED);
+					  &last_eb_bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 84e63ac..addd640 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -68,8 +68,7 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 		goto bail;
 	}
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
-				  &bh, OCFS2_BH_CACHED);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -260,13 +259,11 @@ static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
 {
 	int ret;
 	struct buffer_head *di_bh = NULL;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
-	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &di_bh,
-			       OCFS2_BH_CACHED);
+	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/buffer_head_io.h b/fs/ocfs2/buffer_head_io.h
index fd0d774..a2ef9e5 100644
--- a/fs/ocfs2/buffer_head_io.h
+++ b/fs/ocfs2/buffer_head_io.h
@@ -33,8 +33,7 @@ void ocfs2_end_buffer_io_sync(struct buffer_head *bh,
 
 static inline int ocfs2_read_block(struct inode	       *inode,
 				   u64                  off,
-				   struct buffer_head **bh,
-				   int                  flags);
+				   struct buffer_head **bh);
 
 int ocfs2_write_block(struct ocfs2_super          *osb,
 		      struct buffer_head  *bh,
@@ -54,7 +53,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 #define OCFS2_BH_READAHEAD         8
 
 static inline int ocfs2_read_block(struct inode *inode, u64 off,
-				   struct buffer_head **bh, int flags)
+				   struct buffer_head **bh)
 {
 	int status = 0;
 
@@ -64,7 +63,7 @@ static inline int ocfs2_read_block(struct inode *inode, u64 off,
 		goto bail;
 	}
 
-	status = ocfs2_read_blocks(inode, off, 1, bh, flags);
+	status = ocfs2_read_blocks(inode, off, 1, bh, OCFS2_BH_CACHED);
 
 bail:
 	return status;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index e2de2aa..00d7ed8 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -188,8 +188,7 @@ static struct buffer_head *ocfs2_find_entry_id(const char *name,
 	struct ocfs2_dinode *di;
 	struct ocfs2_inline_data *data;
 
-	ret = ocfs2_read_block(dir, OCFS2_I(dir)->ip_blkno, &di_bh,
-			       OCFS2_BH_CACHED);
+	ret = ocfs2_read_block(dir, OCFS2_I(dir)->ip_blkno, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -417,8 +416,7 @@ static inline int ocfs2_delete_entry_id(handle_t *handle,
 	struct ocfs2_dinode *di;
 	struct ocfs2_inline_data *data;
 
-	ret = ocfs2_read_block(dir, OCFS2_I(dir)->ip_blkno,
-			       &di_bh, OCFS2_BH_CACHED);
+	ret = ocfs2_read_block(dir, OCFS2_I(dir)->ip_blkno, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -596,8 +594,7 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 	struct ocfs2_inline_data *data;
 	struct ocfs2_dir_entry *de;
 
-	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
-			       &di_bh, OCFS2_BH_CACHED);
+	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &di_bh);
 	if (ret) {
 		mlog(ML_ERROR, "Unable to read inode block for dir %llu\n",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 3b2cd0f..ec68442 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2024,8 +2024,7 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 	} else {
 		/* Boo, we have to go to disk. */
 		/* read bh, cast, ocfs2_refresh_inode */
-		status = ocfs2_read_block(inode, oi->ip_blkno,
-					  bh, OCFS2_BH_CACHED);
+		status = ocfs2_read_block(inode, oi->ip_blkno, bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail_refresh;
@@ -2086,10 +2085,7 @@ static int ocfs2_assign_bh(struct inode *inode,
 		return 0;
 	}
 
-	status = ocfs2_read_block(inode,
-				  OCFS2_I(inode)->ip_blkno,
-				  ret_bh,
-				  OCFS2_BH_CACHED);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, ret_bh);
 	if (status < 0)
 		mlog_errno(status);
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 177cf48..d7074d5 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -337,7 +337,7 @@ static int ocfs2_figure_hole_clusters(struct inode *inode,
 
 		ret = ocfs2_read_block(inode,
 				       le64_to_cpu(eb->h_next_leaf_blk),
-				       &next_eb_bh, OCFS2_BH_CACHED);
+				       &next_eb_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -398,8 +398,7 @@ int ocfs2_get_clusters(struct inode *inode, u32 v_cluster,
 	if (ret == 0)
 		goto out;
 
-	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
-			       &di_bh, OCFS2_BH_CACHED);
+	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2b27136..bd5ab52 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -707,8 +707,7 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	 */
 	BUG_ON(mark_unwritten && !ocfs2_sparse_alloc(osb));
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh,
-				  OCFS2_BH_CACHED);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1290,7 +1289,7 @@ static int ocfs2_write_remove_suid(struct inode *inode)
 	struct buffer_head *bh = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	ret = ocfs2_read_block(inode, oi->ip_blkno, &bh, OCFS2_BH_CACHED);
+	ret = ocfs2_read_block(inode, oi->ip_blkno, &bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -1317,7 +1316,7 @@ static int ocfs2_allocate_unwritten_extents(struct inode *inode,
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
-				       &di_bh, OCFS2_BH_CACHED);
+				       &di_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ed71305..00d8493 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -449,7 +449,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	}
 
 	if (can_lock)
-		status = ocfs2_read_block(inode, args->fi_blkno, &bh, 0);
+		status = ocfs2_read_blocks(inode, args->fi_blkno, 1, &bh, 0);
 	else
 		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
 	if (status < 0) {
@@ -1146,7 +1146,7 @@ struct buffer_head *ocfs2_bread(struct inode *inode,
 		goto fail;
 	}
 
-	tmperr = ocfs2_read_block(inode, p_blkno, &bh, readflags);
+	tmperr = ocfs2_read_blocks(inode, p_blkno, 1, &bh, readflags);
 	if (tmperr < 0)
 		goto fail;
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 6e63845..ba646ef 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1187,7 +1187,7 @@ static int ocfs2_read_journal_inode(struct ocfs2_super *osb,
 	}
 	SET_INODE_JOURNAL(inode);
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, bh, 0);
+	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1, bh, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 52d2e1f..9ac0be9 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -139,8 +139,8 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
-				  &alloc_bh, 0);
+	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1,
+				   &alloc_bh, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -345,8 +345,8 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 
 	mutex_lock(&inode->i_mutex);
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
-				  &alloc_bh, 0);
+	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1,
+				   &alloc_bh, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index dd8605e..01c4826 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1782,7 +1782,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 
 	status = ocfs2_read_block(orphan_dir_inode,
 				  OCFS2_I(orphan_dir_inode)->ip_blkno,
-				  &orphan_dir_bh, OCFS2_BH_CACHED);
+				  &orphan_dir_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 92dcd93..ffd48db 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -332,8 +332,7 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	lgd_blkno = ocfs2_which_cluster_group(main_bm_inode,
 					      first_new_cluster - 1);
 
-	ret = ocfs2_read_block(main_bm_inode, lgd_blkno, &group_bh,
-			       OCFS2_BH_CACHED);
+	ret = ocfs2_read_block(main_bm_inode, lgd_blkno, &group_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_unlock;
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 82d986b..357d3fe 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -403,7 +403,7 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 		     (unsigned long long)blkno);
 
 		bh = NULL;  /* Acquire a fresh bh */
-		status = ocfs2_read_block(si->si_inode, blkno, &bh, 0);
+		status = ocfs2_read_blocks(si->si_inode, blkno, 1, &bh, 0);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index aeab126..4aaffd8 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1170,8 +1170,7 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	struct ocfs2_group_desc *gd;
 	struct inode *alloc_inode = ac->ac_inode;
 
-	ret = ocfs2_read_block(alloc_inode, gd_blkno,
-			       &group_bh, OCFS2_BH_CACHED);
+	ret = ocfs2_read_block(alloc_inode, gd_blkno, &group_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -1242,7 +1241,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 
 	status = ocfs2_read_block(alloc_inode,
 				  le64_to_cpu(cl->cl_recs[chain].c_blkno),
-				  &group_bh, OCFS2_BH_CACHED);
+				  &group_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1272,8 +1271,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 		prev_group_bh = group_bh;
 		group_bh = NULL;
 		status = ocfs2_read_block(alloc_inode,
-					  next_group, &group_bh,
-					  OCFS2_BH_CACHED);
+					  next_group, &group_bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1796,8 +1794,7 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 	     (unsigned long long)OCFS2_I(alloc_inode)->ip_blkno, count,
 	     (unsigned long long)bg_blkno, start_bit);
 
-	status = ocfs2_read_block(alloc_inode, bg_blkno, &group_bh,
-				  OCFS2_BH_CACHED);
+	status = ocfs2_read_block(alloc_inode, bg_blkno, &group_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index f2c064d..3e48a3d 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -83,10 +83,7 @@ static char *ocfs2_fast_symlink_getlink(struct inode *inode,
 
 	mlog_entry_void();
 
-	status = ocfs2_read_block(inode,
-				  OCFS2_I(inode)->ip_blkno,
-				  bh,
-				  OCFS2_BH_CACHED);
+	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, bh);
 	if (status < 0) {
 		mlog_errno(status);
 		link = ERR_PTR(status);
-- 
1.5.6.5
