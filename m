From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:50 -0800
Subject: [Ocfs2-devel] [PATCH 03/40] ocfs2: Take the inode out of the
	metadata read/write paths.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We are really passing the inode into the ocfs2_read/write_blocks()
functions to get at the metadata cache.  This commit passes the cache
directly into the metadata block functions, divorcing them from the
inode.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c          |   13 ++++---
 fs/ocfs2/buffer_head_io.c |   47 +++++++++++++------------
 fs/ocfs2/buffer_head_io.h |    8 ++--
 fs/ocfs2/dir.c            |    6 ++--
 fs/ocfs2/dlmglue.c        |    2 +-
 fs/ocfs2/extent_map.c     |    4 +-
 fs/ocfs2/inode.c          |   16 ++++++--
 fs/ocfs2/inode.h          |    5 +++
 fs/ocfs2/journal.c        |    4 +-
 fs/ocfs2/localalloc.c     |    2 +-
 fs/ocfs2/namei.c          |    5 ++-
 fs/ocfs2/quota_global.c   |    2 +-
 fs/ocfs2/resize.c         |    2 +-
 fs/ocfs2/slot_map.c       |   10 +++---
 fs/ocfs2/suballoc.c       |    4 +-
 fs/ocfs2/super.c          |    2 +-
 fs/ocfs2/uptodate.c       |   83 ++++++++++++++++++++------------------------
 fs/ocfs2/uptodate.h       |   21 +++++++----
 fs/ocfs2/xattr.c          |   23 +++++++-----
 19 files changed, 139 insertions(+), 120 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 60fe740..2ce2158 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -795,7 +795,7 @@ int ocfs2_read_extent_block(struct inode *inode, u64 eb_blkno,
 	int rc;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_block(inode, eb_blkno, &tmp,
+	rc = ocfs2_read_block(INODE_CACHE(inode), eb_blkno, &tmp,
 			      ocfs2_validate_extent_block);
 
 	/* If ocfs2_read_block() got us a new bh, pass it up. */
@@ -885,7 +885,8 @@ static int ocfs2_create_new_meta_bhs(struct ocfs2_super *osb,
 				mlog_errno(status);
 				goto bail;
 			}
-			ocfs2_set_new_buffer_uptodate(inode, bhs[i]);
+			ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode),
+						      bhs[i]);
 
 			status = ocfs2_journal_access_eb(handle, inode, bhs[i],
 							 OCFS2_JOURNAL_ACCESS_CREATE);
@@ -2404,7 +2405,7 @@ static void ocfs2_unlink_path(struct inode *inode, handle_t *handle,
 			     le16_to_cpu(el->l_next_free_rec));
 
 			ocfs2_journal_dirty(handle, bh);
-			ocfs2_remove_from_cache(inode, bh);
+			ocfs2_remove_from_cache(INODE_CACHE(inode), bh);
 			continue;
 		}
 
@@ -2417,7 +2418,7 @@ static void ocfs2_unlink_path(struct inode *inode, handle_t *handle,
 		if (ret)
 			mlog_errno(ret);
 
-		ocfs2_remove_from_cache(inode, bh);
+		ocfs2_remove_from_cache(INODE_CACHE(inode), bh);
 	}
 }
 
@@ -5820,7 +5821,7 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 		tl->tl_used = 0;
 
 		ocfs2_compute_meta_ecc(osb->sb, tl_bh->b_data, &di->i_check);
-		status = ocfs2_write_block(osb, tl_bh, tl_inode);
+		status = ocfs2_write_block(osb, tl_bh, INODE_CACHE(tl_inode));
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -6529,7 +6530,7 @@ delete:
 
 			mlog(0, "deleting this extent block.\n");
 
-			ocfs2_remove_from_cache(inode, bh);
+			ocfs2_remove_from_cache(INODE_CACHE(inode), bh);
 
 			BUG_ON(ocfs2_rec_clusters(el, &el->l_recs[0]));
 			BUG_ON(le32_to_cpu(el->l_recs[0].e_cpos));
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 15c8e6d..d43d34a 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -52,12 +52,12 @@ enum ocfs2_state_bits {
 BUFFER_FNS(NeedsValidate, needs_validate);
 
 int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
-		      struct inode *inode)
+		      struct ocfs2_caching_info *ci)
 {
 	int ret = 0;
 
-	mlog_entry("(bh->b_blocknr = %llu, inode=%p)\n",
-		   (unsigned long long)bh->b_blocknr, inode);
+	mlog_entry("(bh->b_blocknr = %llu, ci=%p)\n",
+		   (unsigned long long)bh->b_blocknr, ci);
 
 	BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO);
 	BUG_ON(buffer_jbd(bh));
@@ -70,7 +70,7 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 		goto out;
 	}
 
-	mutex_lock(&OCFS2_I(inode)->ip_io_mutex);
+	ocfs2_metadata_cache_io_lock(ci);
 
 	lock_buffer(bh);
 	set_buffer_uptodate(bh);
@@ -85,7 +85,7 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 	wait_on_buffer(bh);
 
 	if (buffer_uptodate(bh)) {
-		ocfs2_set_buffer_uptodate(inode, bh);
+		ocfs2_set_buffer_uptodate(ci, bh);
 	} else {
 		/* We don't need to remove the clustered uptodate
 		 * information for this bh as it's not marked locally
@@ -94,7 +94,7 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 		put_bh(bh);
 	}
 
-	mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
+	ocfs2_metadata_cache_io_unlock(ci);
 out:
 	mlog_exit(ret);
 	return ret;
@@ -177,7 +177,7 @@ bail:
 	return status;
 }
 
-int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
+int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		      struct buffer_head *bhs[], int flags,
 		      int (*validate)(struct super_block *sb,
 				      struct buffer_head *bh))
@@ -185,11 +185,12 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 	int status = 0;
 	int i, ignore_cache = 0;
 	struct buffer_head *bh;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 
-	mlog_entry("(inode=%p, block=(%llu), nr=(%d), flags=%d)\n",
-		   inode, (unsigned long long)block, nr, flags);
+	mlog_entry("(ci=%p, block=(%llu), nr=(%d), flags=%d)\n",
+		   ci, (unsigned long long)block, nr, flags);
 
-	BUG_ON(!inode);
+	BUG_ON(!ci);
 	BUG_ON((flags & OCFS2_BH_READAHEAD) &&
 	       (flags & OCFS2_BH_IGNORE_CACHE));
 
@@ -212,12 +213,12 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 		goto bail;
 	}
 
-	mutex_lock(&OCFS2_I(inode)->ip_io_mutex);
+	ocfs2_metadata_cache_io_lock(ci);
 	for (i = 0 ; i < nr ; i++) {
 		if (bhs[i] == NULL) {
-			bhs[i] = sb_getblk(inode->i_sb, block++);
+			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
-				mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
+				ocfs2_metadata_cache_io_unlock(ci);
 				status = -EIO;
 				mlog_errno(status);
 				goto bail;
@@ -250,11 +251,11 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 		 *    before our is-it-in-flight check.
 		 */
 
-		if (!ignore_cache && !ocfs2_buffer_uptodate(inode, bh)) {
+		if (!ignore_cache && !ocfs2_buffer_uptodate(ci, bh)) {
 			mlog(ML_UPTODATE,
-			     "bh (%llu), inode %llu not uptodate\n",
+			     "bh (%llu), owner %llu not uptodate\n",
 			     (unsigned long long)bh->b_blocknr,
-			     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			     (unsigned long long)ocfs2_metadata_cache_owner(ci));
 			/* We're using ignore_cache here to say
 			 * "go to disk" */
 			ignore_cache = 1;
@@ -283,7 +284,7 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 			 * previously submitted request than we are
 			 * done here. */
 			if ((flags & OCFS2_BH_READAHEAD)
-			    && ocfs2_buffer_read_ahead(inode, bh))
+			    && ocfs2_buffer_read_ahead(ci, bh))
 				continue;
 
 			lock_buffer(bh);
@@ -305,7 +306,7 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 			 * buffer lock. */
 			if (!(flags & OCFS2_BH_IGNORE_CACHE)
 			    && !(flags & OCFS2_BH_READAHEAD)
-			    && ocfs2_buffer_uptodate(inode, bh)) {
+			    && ocfs2_buffer_uptodate(ci, bh)) {
 				unlock_buffer(bh);
 				continue;
 			}
@@ -327,7 +328,7 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 
 		if (!(flags & OCFS2_BH_READAHEAD)) {
 			/* We know this can't have changed as we hold the
-			 * inode sem. Avoid doing any work on the bh if the
+			 * owner sem. Avoid doing any work on the bh if the
 			 * journal has it. */
 			if (!buffer_jbd(bh))
 				wait_on_buffer(bh);
@@ -351,7 +352,7 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 				 * that better not have changed */
 				BUG_ON(buffer_jbd(bh));
 				clear_buffer_needs_validate(bh);
-				status = validate(inode->i_sb, bh);
+				status = validate(sb, bh);
 				if (status) {
 					put_bh(bh);
 					bhs[i] = NULL;
@@ -363,9 +364,9 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 		/* Always set the buffer in the cache, even if it was
 		 * a forced read, or read-ahead which hasn't yet
 		 * completed. */
-		ocfs2_set_buffer_uptodate(inode, bh);
+		ocfs2_set_buffer_uptodate(ci, bh);
 	}
-	mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
+	ocfs2_metadata_cache_io_unlock(ci);
 
 	mlog(ML_BH_IO, "block=(%llu), nr=(%d), cached=%s, flags=0x%x\n", 
 	     (unsigned long long)block, nr,
@@ -399,7 +400,7 @@ static void ocfs2_check_super_or_backup(struct super_block *sb,
 
 /*
  * Write super block and backups doesn't need to collaborate with journal,
- * so we don't need to lock ip_io_mutex and inode doesn't need to bea passed
+ * so we don't need to lock ip_io_mutex and ci doesn't need to bea passed
  * into this function.
  */
 int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/buffer_head_io.h b/fs/ocfs2/buffer_head_io.h
index c75d682..b97bcc6 100644
--- a/fs/ocfs2/buffer_head_io.h
+++ b/fs/ocfs2/buffer_head_io.h
@@ -33,7 +33,7 @@ void ocfs2_end_buffer_io_sync(struct buffer_head *bh,
 
 int ocfs2_write_block(struct ocfs2_super          *osb,
 		      struct buffer_head  *bh,
-		      struct inode        *inode);
+		      struct ocfs2_caching_info   *ci);
 int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 			   unsigned int nr, struct buffer_head *bhs[]);
 
@@ -44,7 +44,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
  * be set even for a READAHEAD call, as it marks the buffer for later
  * validation.
  */
-int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
+int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		      struct buffer_head *bhs[], int flags,
 		      int (*validate)(struct super_block *sb,
 				      struct buffer_head *bh));
@@ -55,7 +55,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 #define OCFS2_BH_IGNORE_CACHE      1
 #define OCFS2_BH_READAHEAD         8
 
-static inline int ocfs2_read_block(struct inode *inode, u64 off,
+static inline int ocfs2_read_block(struct ocfs2_caching_info *ci, u64 off,
 				   struct buffer_head **bh,
 				   int (*validate)(struct super_block *sb,
 						   struct buffer_head *bh))
@@ -68,7 +68,7 @@ static inline int ocfs2_read_block(struct inode *inode, u64 off,
 		goto bail;
 	}
 
-	status = ocfs2_read_blocks(inode, off, 1, bh, 0, validate);
+	status = ocfs2_read_blocks(ci, off, 1, bh, 0, validate);
 
 bail:
 	return status;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index f2c4098..ee9d3a8 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1299,7 +1299,7 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	ocfs2_set_new_buffer_uptodate(inode, new_bh);
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
 
 	status = ocfs2_journal_access_db(handle, inode, new_bh,
 					 OCFS2_JOURNAL_ACCESS_CREATE);
@@ -1477,7 +1477,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		goto out_commit;
 	}
 
-	ocfs2_set_new_buffer_uptodate(dir, dirdata_bh);
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(dir), dirdata_bh);
 
 	ret = ocfs2_journal_access_db(handle, dir, dirdata_bh,
 				      OCFS2_JOURNAL_ACCESS_CREATE);
@@ -1769,7 +1769,7 @@ do_extend:
 		goto bail;
 	}
 
-	ocfs2_set_new_buffer_uptodate(dir, new_bh);
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(dir), new_bh);
 
 	status = ocfs2_journal_access_db(handle, dir, new_bh,
 					 OCFS2_JOURNAL_ACCESS_CREATE);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 206a237..5c48b44 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2046,7 +2046,7 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 
 	/* This will discard any caching information we might have had
 	 * for the inode metadata. */
-	ocfs2_metadata_cache_purge(inode);
+	ocfs2_metadata_cache_purge(INODE_CACHE(inode));
 
 	ocfs2_extent_map_trunc(inode, 0);
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f2bb1a0..dbd8a16 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -862,8 +862,8 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 			BUG_ON(bhs[done + i]->b_blocknr != (p_block + i));
 		}
 
-		rc = ocfs2_read_blocks(inode, p_block, count, bhs + done,
-				       flags, validate);
+		rc = ocfs2_read_blocks(INODE_CACHE(inode), p_block, count,
+				       bhs + done, flags, validate);
 		if (rc) {
 			mlog_errno(rc);
 			break;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8e764b2..fc55fcf 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -637,7 +637,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 		goto bail_commit;
 	}
 
-	ocfs2_remove_from_cache(inode, di_bh);
+	ocfs2_remove_from_cache(INODE_CACHE(inode), di_bh);
 	vfs_dq_free_inode(inode);
 
 	status = ocfs2_free_dinode(handle, inode_alloc_inode,
@@ -1063,7 +1063,7 @@ void ocfs2_clear_inode(struct inode *inode)
 	ocfs2_lock_res_free(&oi->ip_inode_lockres);
 	ocfs2_lock_res_free(&oi->ip_open_lockres);
 
-	ocfs2_metadata_cache_purge(inode);
+	ocfs2_metadata_cache_purge(INODE_CACHE(inode));
 
 	mlog_bug_on_msg(oi->ip_metadata_cache.ci_num_cached,
 			"Clear inode of %llu, inode has %u cache items\n",
@@ -1332,8 +1332,8 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
 	int rc;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1, &tmp,
-			       flags, ocfs2_validate_inode_block);
+	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
+			       1, &tmp, flags, ocfs2_validate_inode_block);
 
 	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
 	if (!rc && !*bh)
@@ -1359,6 +1359,13 @@ static u64 ocfs2_inode_cache_owner(struct ocfs2_caching_info *ci)
 	return oi->ip_blkno;
 }
 
+static struct super_block *ocfs2_inode_cache_get_super(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
+
+	return oi->vfs_inode.i_sb;
+}
+
 static void ocfs2_inode_cache_lock(struct ocfs2_caching_info *ci)
 {
 	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
@@ -1389,6 +1396,7 @@ static void ocfs2_inode_cache_io_unlock(struct ocfs2_caching_info *ci)
 
 const struct ocfs2_caching_operations ocfs2_inode_caching_ops = {
 	.co_owner		= ocfs2_inode_cache_owner,
+	.co_get_super		= ocfs2_inode_cache_get_super,
 	.co_cache_lock		= ocfs2_inode_cache_lock,
 	.co_cache_unlock	= ocfs2_inode_cache_unlock,
 	.co_io_lock		= ocfs2_inode_cache_io_lock,
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 6255a6c..5731e42 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -116,6 +116,11 @@ extern struct kmem_cache *ocfs2_inode_cache;
 extern const struct address_space_operations ocfs2_aops;
 extern const struct ocfs2_caching_operations ocfs2_inode_caching_ops;
 
+static inline struct ocfs2_caching_info *INODE_CACHE(struct inode *inode)
+{
+	return &OCFS2_I(inode)->ip_metadata_cache;
+}
+
 void ocfs2_clear_inode(struct inode *inode);
 void ocfs2_delete_inode(struct inode *inode);
 void ocfs2_drop_inode(struct inode *inode);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 57d7d25..25d1905 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -780,7 +780,7 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 		ocfs2_bump_recovery_generation(fe);
 
 	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &fe->i_check);
-	status = ocfs2_write_block(osb, bh, journal->j_inode);
+	status = ocfs2_write_block(osb, bh, INODE_CACHE(journal->j_inode));
 	if (status < 0)
 		mlog_errno(status);
 
@@ -1515,7 +1515,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 					ocfs2_get_recovery_generation(fe);
 
 	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &fe->i_check);
-	status = ocfs2_write_block(osb, bh, inode);
+	status = ocfs2_write_block(osb, bh, INODE_CACHE(inode));
 	if (status < 0)
 		mlog_errno(status);
 
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ec70cdb..62a7f92 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -478,7 +478,7 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 	ocfs2_clear_local_alloc(alloc);
 
 	ocfs2_compute_meta_ecc(osb->sb, alloc_bh->b_data, &alloc->i_check);
-	status = ocfs2_write_block(osb, alloc_bh, inode);
+	status = ocfs2_write_block(osb, alloc_bh, INODE_CACHE(inode));
 	if (status < 0)
 		mlog_errno(status);
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 084aba8..6475006 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -491,7 +491,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		mlog_errno(status);
 		goto leave;
 	}
-	ocfs2_set_new_buffer_uptodate(inode, *new_fe_bh);
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), *new_fe_bh);
 
 	status = ocfs2_journal_access_di(handle, inode, *new_fe_bh,
 					 OCFS2_JOURNAL_ACCESS_CREATE);
@@ -1508,7 +1508,8 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 			mlog_errno(status);
 			goto bail;
 		}
-		ocfs2_set_new_buffer_uptodate(inode, bhs[virtual]);
+		ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode),
+					      bhs[virtual]);
 
 		status = ocfs2_journal_access(handle, inode, bhs[virtual],
 					      OCFS2_JOURNAL_ACCESS_CREATE);
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 1ed0f7c..d36326b 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -243,7 +243,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 	flush_dcache_page(bh->b_page);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
-	ocfs2_set_buffer_uptodate(gqinode, bh);
+	ocfs2_set_buffer_uptodate(INODE_CACHE(gqinode), bh);
 	err = ocfs2_journal_access_dq(handle, gqinode, bh, ja_type);
 	if (err < 0) {
 		brelse(bh);
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 424adaa..7465f0f 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -514,7 +514,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		goto out_unlock;
 	}
 
-	ocfs2_set_new_buffer_uptodate(inode, group_bh);
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), group_bh);
 
 	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
 	if (ret) {
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 40661e7..bfbd7e9 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -150,8 +150,8 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 	 * be !NULL.  Thus, ocfs2_read_blocks() will ignore blocknr.  If
 	 * this is not true, the read of -1 (UINT64_MAX) will fail.
 	 */
-	ret = ocfs2_read_blocks(si->si_inode, -1, si->si_blocks, si->si_bh,
-				OCFS2_BH_IGNORE_CACHE, NULL);
+	ret = ocfs2_read_blocks(INODE_CACHE(si->si_inode), -1, si->si_blocks,
+				si->si_bh, OCFS2_BH_IGNORE_CACHE, NULL);
 	if (ret == 0) {
 		spin_lock(&osb->osb_lock);
 		ocfs2_update_slot_info(si);
@@ -213,7 +213,7 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
 		ocfs2_update_disk_slot_old(si, slot_num, &bh);
 	spin_unlock(&osb->osb_lock);
 
-	status = ocfs2_write_block(osb, bh, si->si_inode);
+	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
 	if (status < 0)
 		mlog_errno(status);
 
@@ -404,8 +404,8 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 		     (unsigned long long)blkno);
 
 		bh = NULL;  /* Acquire a fresh bh */
-		status = ocfs2_read_blocks(si->si_inode, blkno, 1, &bh,
-					   OCFS2_BH_IGNORE_CACHE, NULL);
+		status = ocfs2_read_blocks(INODE_CACHE(si->si_inode), blkno,
+					   1, &bh, OCFS2_BH_IGNORE_CACHE, NULL);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a696286..cd0b5c4 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -306,7 +306,7 @@ int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
 	int rc;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_block(inode, gd_blkno, &tmp,
+	rc = ocfs2_read_block(INODE_CACHE(inode), gd_blkno, &tmp,
 			      ocfs2_validate_group_descriptor);
 	if (rc)
 		goto out;
@@ -465,7 +465,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 		mlog_errno(status);
 		goto bail;
 	}
-	ocfs2_set_new_buffer_uptodate(alloc_inode, bg_bh);
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(alloc_inode), bg_bh);
 
 	status = ocfs2_block_group_fill(handle,
 					alloc_inode,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 536994d..4c6f511 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1463,7 +1463,7 @@ static void ocfs2_inode_init_once(void *data)
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
-	ocfs2_metadata_cache_init(&oi->ip_metadata_cache,
+	ocfs2_metadata_cache_init(INODE_CACHE(&oi->vfs_inode),
 				  &ocfs2_inode_caching_ops);
 
 	inode_init_once(&oi->vfs_inode);
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 226d042..1c829e4 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -75,13 +75,20 @@ struct ocfs2_meta_cache_item {
 
 static struct kmem_cache *ocfs2_uptodate_cachep = NULL;
 
-static u64 ocfs2_metadata_cache_owner(struct ocfs2_caching_info *ci)
+u64 ocfs2_metadata_cache_owner(struct ocfs2_caching_info *ci)
 {
 	BUG_ON(!ci || !ci->ci_ops);
 
 	return ci->ci_ops->co_owner(ci);
 }
 
+struct super_block *ocfs2_metadata_cache_get_super(struct ocfs2_caching_info *ci)
+{
+	BUG_ON(!ci || !ci->ci_ops);
+
+	return ci->ci_ops->co_get_super(ci);
+}
+
 static void ocfs2_metadata_cache_lock(struct ocfs2_caching_info *ci)
 {
 	BUG_ON(!ci || !ci->ci_ops);
@@ -96,14 +103,14 @@ static void ocfs2_metadata_cache_unlock(struct ocfs2_caching_info *ci)
 	ci->ci_ops->co_cache_unlock(ci);
 }
 
-static void ocfs2_metadata_cache_io_lock(struct ocfs2_caching_info *ci)
+void ocfs2_metadata_cache_io_lock(struct ocfs2_caching_info *ci)
 {
 	BUG_ON(!ci || !ci->ci_ops);
 
 	ci->ci_ops->co_io_lock(ci);
 }
 
-static void ocfs2_metadata_cache_io_unlock(struct ocfs2_caching_info *ci)
+void ocfs2_metadata_cache_io_unlock(struct ocfs2_caching_info *ci)
 {
 	BUG_ON(!ci || !ci->ci_ops);
 
@@ -149,11 +156,9 @@ static unsigned int ocfs2_purge_copied_metadata_tree(struct rb_root *root)
  * This function is a few more lines longer than necessary due to some
  * accounting done here, but I think it's worth tracking down those
  * bugs sooner -- Mark */
-void ocfs2_metadata_cache_purge(struct inode *inode)
+void ocfs2_metadata_cache_purge(struct ocfs2_caching_info *ci)
 {
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	unsigned int tree, to_purge, purged;
-	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 	struct rb_root root = RB_ROOT;
 
 	BUG_ON(!ci || !ci->ci_ops);
@@ -223,12 +228,11 @@ ocfs2_search_cache_tree(struct ocfs2_caching_info *ci,
 	return NULL;
 }
 
-static int ocfs2_buffer_cached(struct ocfs2_inode_info *oi,
+static int ocfs2_buffer_cached(struct ocfs2_caching_info *ci,
 			       struct buffer_head *bh)
 {
 	int index = -1;
 	struct ocfs2_meta_cache_item *item = NULL;
-	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
 	ocfs2_metadata_cache_lock(ci);
 
@@ -238,11 +242,9 @@ static int ocfs2_buffer_cached(struct ocfs2_inode_info *oi,
 	     !!(ci->ci_flags & OCFS2_CACHE_FL_INLINE));
 
 	if (ci->ci_flags & OCFS2_CACHE_FL_INLINE)
-		index = ocfs2_search_cache_array(&oi->ip_metadata_cache,
-						 bh->b_blocknr);
+		index = ocfs2_search_cache_array(ci, bh->b_blocknr);
 	else
-		item = ocfs2_search_cache_tree(&oi->ip_metadata_cache,
-					       bh->b_blocknr);
+		item = ocfs2_search_cache_tree(ci, bh->b_blocknr);
 
 	ocfs2_metadata_cache_unlock(ci);
 
@@ -256,7 +258,7 @@ static int ocfs2_buffer_cached(struct ocfs2_inode_info *oi,
  * 
  * This can be called under lock_buffer()
  */
-int ocfs2_buffer_uptodate(struct inode *inode,
+int ocfs2_buffer_uptodate(struct ocfs2_caching_info *ci,
 			  struct buffer_head *bh)
 {
 	/* Doesn't matter if the bh is in our cache or not -- if it's
@@ -272,17 +274,17 @@ int ocfs2_buffer_uptodate(struct inode *inode,
 
 	/* Ok, locally the buffer is marked as up to date, now search
 	 * our cache to see if we can trust that. */
-	return ocfs2_buffer_cached(OCFS2_I(inode), bh);
+	return ocfs2_buffer_cached(ci, bh);
 }
 
-/* 
+/*
  * Determine whether a buffer is currently out on a read-ahead request.
  * ci_io_sem should be held to serialize submitters with the logic here.
  */
-int ocfs2_buffer_read_ahead(struct inode *inode,
+int ocfs2_buffer_read_ahead(struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh)
 {
-	return buffer_locked(bh) && ocfs2_buffer_cached(OCFS2_I(inode), bh);
+	return buffer_locked(bh) && ocfs2_buffer_cached(ci, bh);
 }
 
 /* Requires ip_lock */
@@ -335,8 +337,7 @@ static void __ocfs2_insert_cache_tree(struct ocfs2_caching_info *ci,
 }
 
 /* co_cache_lock() must be held */
-static inline int ocfs2_insert_can_use_array(struct ocfs2_inode_info *oi,
-					     struct ocfs2_caching_info *ci)
+static inline int ocfs2_insert_can_use_array(struct ocfs2_caching_info *ci)
 {
 	return (ci->ci_flags & OCFS2_CACHE_FL_INLINE) &&
 		(ci->ci_num_cached < OCFS2_CACHE_INFO_MAX_ARRAY);
@@ -347,11 +348,10 @@ static inline int ocfs2_insert_can_use_array(struct ocfs2_inode_info *oi,
  * when to free in case of error.
  *
  * The co_cache_lock() must be held. */
-static void ocfs2_expand_cache(struct ocfs2_inode_info *oi,
+static void ocfs2_expand_cache(struct ocfs2_caching_info *ci,
 			       struct ocfs2_meta_cache_item **tree)
 {
 	int i;
-	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
 	mlog_bug_on_msg(ci->ci_num_cached != OCFS2_CACHE_INFO_MAX_ARRAY,
 			"Owner %llu, num cached = %u, should be %u\n",
@@ -383,12 +383,11 @@ static void ocfs2_expand_cache(struct ocfs2_inode_info *oi,
 
 /* Slow path function - memory allocation is necessary. See the
  * comment above ocfs2_set_buffer_uptodate for more information. */
-static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
+static void __ocfs2_set_buffer_uptodate(struct ocfs2_caching_info *ci,
 					sector_t block,
 					int expand_tree)
 {
 	int i;
-	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 	struct ocfs2_meta_cache_item *new = NULL;
 	struct ocfs2_meta_cache_item *tree[OCFS2_CACHE_INFO_MAX_ARRAY] =
 		{ NULL, };
@@ -420,7 +419,7 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
 	}
 
 	ocfs2_metadata_cache_lock(ci);
-	if (ocfs2_insert_can_use_array(oi, ci)) {
+	if (ocfs2_insert_can_use_array(ci)) {
 		mlog(0, "Someone cleared the tree underneath us\n");
 		/* Ok, items were removed from the cache in between
 		 * locks. Detect this and revert back to the fast path */
@@ -430,7 +429,7 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
 	}
 
 	if (expand_tree)
-		ocfs2_expand_cache(oi, tree);
+		ocfs2_expand_cache(ci, tree);
 
 	__ocfs2_insert_cache_tree(ci, new);
 	ocfs2_metadata_cache_unlock(ci);
@@ -468,16 +467,14 @@ out_free:
  * Readahead buffers can be passed in here before the I/O request is
  * completed.
  */
-void ocfs2_set_buffer_uptodate(struct inode *inode,
+void ocfs2_set_buffer_uptodate(struct ocfs2_caching_info *ci,
 			       struct buffer_head *bh)
 {
 	int expand;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
 	/* The block may very well exist in our cache already, so avoid
 	 * doing any more work in that case. */
-	if (ocfs2_buffer_cached(oi, bh))
+	if (ocfs2_buffer_cached(ci, bh))
 		return;
 
 	mlog(0, "Owner %llu, inserting block %llu\n",
@@ -487,7 +484,7 @@ void ocfs2_set_buffer_uptodate(struct inode *inode,
 	/* No need to recheck under spinlock - insertion is guarded by
 	 * co_io_lock() */
 	ocfs2_metadata_cache_lock(ci);
-	if (ocfs2_insert_can_use_array(oi, ci)) {
+	if (ocfs2_insert_can_use_array(ci)) {
 		/* Fast case - it's an array and there's a free
 		 * spot. */
 		ocfs2_append_cache_array(ci, bh->b_blocknr);
@@ -502,25 +499,22 @@ void ocfs2_set_buffer_uptodate(struct inode *inode,
 	}
 	ocfs2_metadata_cache_unlock(ci);
 
-	__ocfs2_set_buffer_uptodate(oi, bh->b_blocknr, expand);
+	__ocfs2_set_buffer_uptodate(ci, bh->b_blocknr, expand);
 }
 
 /* Called against a newly allocated buffer. Most likely nobody should
  * be able to read this sort of metadata while it's still being
  * allocated, but this is careful to take co_io_lock() anyway. */
-void ocfs2_set_new_buffer_uptodate(struct inode *inode,
+void ocfs2_set_new_buffer_uptodate(struct ocfs2_caching_info *ci,
 				   struct buffer_head *bh)
 {
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
-
 	/* This should definitely *not* exist in our cache */
-	BUG_ON(ocfs2_buffer_cached(oi, bh));
+	BUG_ON(ocfs2_buffer_cached(ci, bh));
 
 	set_buffer_uptodate(bh);
 
 	ocfs2_metadata_cache_io_lock(ci);
-	ocfs2_set_buffer_uptodate(inode, bh);
+	ocfs2_set_buffer_uptodate(ci, bh);
 	ocfs2_metadata_cache_io_unlock(ci);
 }
 
@@ -559,13 +553,11 @@ static void ocfs2_remove_metadata_tree(struct ocfs2_caching_info *ci,
 	ci->ci_num_cached--;
 }
 
-static void ocfs2_remove_block_from_cache(struct inode *inode,
+static void ocfs2_remove_block_from_cache(struct ocfs2_caching_info *ci,
 					  sector_t block)
 {
 	int index;
 	struct ocfs2_meta_cache_item *item = NULL;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
 	ocfs2_metadata_cache_lock(ci);
 	mlog(0, "Owner %llu, remove %llu, items = %u, array = %u\n",
@@ -593,23 +585,24 @@ static void ocfs2_remove_block_from_cache(struct inode *inode,
  * bother reverting things to an inlined array in the case of a remove
  * which moves us back under the limit.
  */
-void ocfs2_remove_from_cache(struct inode *inode,
+void ocfs2_remove_from_cache(struct ocfs2_caching_info *ci,
 			     struct buffer_head *bh)
 {
 	sector_t block = bh->b_blocknr;
 
-	ocfs2_remove_block_from_cache(inode, block);
+	ocfs2_remove_block_from_cache(ci, block);
 }
 
 /* Called when we remove xattr clusters from an inode. */
-void ocfs2_remove_xattr_clusters_from_cache(struct inode *inode,
+void ocfs2_remove_xattr_clusters_from_cache(struct ocfs2_caching_info *ci,
 					    sector_t block,
 					    u32 c_len)
 {
-	unsigned int i, b_len = ocfs2_clusters_to_blocks(inode->i_sb, 1) * c_len;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	unsigned int i, b_len = ocfs2_clusters_to_blocks(sb, 1) * c_len;
 
 	for (i = 0; i < b_len; i++, block++)
-		ocfs2_remove_block_from_cache(inode, block);
+		ocfs2_remove_block_from_cache(ci, block);
 }
 
 int __init init_ocfs2_uptodate_cache(void)
diff --git a/fs/ocfs2/uptodate.h b/fs/ocfs2/uptodate.h
index 3b33eb8..f268273 100644
--- a/fs/ocfs2/uptodate.h
+++ b/fs/ocfs2/uptodate.h
@@ -38,6 +38,8 @@ struct ocfs2_caching_operations {
 	 */
 	u64	(*co_owner)(struct ocfs2_caching_info *ci);
 
+	/* The superblock is needed during I/O. */
+	struct super_block *(*co_get_super)(struct ocfs2_caching_info *ci);
 	/*
 	 * Lock and unlock the caching data.  These will not sleep, and
 	 * should probably be spinlocks.
@@ -58,20 +60,25 @@ void exit_ocfs2_uptodate_cache(void);
 
 void ocfs2_metadata_cache_init(struct ocfs2_caching_info *ci,
 			       const struct ocfs2_caching_operations *ops);
-void ocfs2_metadata_cache_purge(struct inode *inode);
+void ocfs2_metadata_cache_purge(struct ocfs2_caching_info *ci);
 
-int ocfs2_buffer_uptodate(struct inode *inode,
+u64 ocfs2_metadata_cache_owner(struct ocfs2_caching_info *ci);
+struct super_block *ocfs2_metadata_cache_get_super(struct ocfs2_caching_info *ci);
+void ocfs2_metadata_cache_io_lock(struct ocfs2_caching_info *ci);
+void ocfs2_metadata_cache_io_unlock(struct ocfs2_caching_info *ci);
+
+int ocfs2_buffer_uptodate(struct ocfs2_caching_info *ci,
 			  struct buffer_head *bh);
-void ocfs2_set_buffer_uptodate(struct inode *inode,
+void ocfs2_set_buffer_uptodate(struct ocfs2_caching_info *ci,
 			       struct buffer_head *bh);
-void ocfs2_set_new_buffer_uptodate(struct inode *inode,
+void ocfs2_set_new_buffer_uptodate(struct ocfs2_caching_info *ci,
 				   struct buffer_head *bh);
-void ocfs2_remove_from_cache(struct inode *inode,
+void ocfs2_remove_from_cache(struct ocfs2_caching_info *ci,
 			     struct buffer_head *bh);
-void ocfs2_remove_xattr_clusters_from_cache(struct inode *inode,
+void ocfs2_remove_xattr_clusters_from_cache(struct ocfs2_caching_info *ci,
 					    sector_t block,
 					    u32 c_len);
-int ocfs2_buffer_read_ahead(struct inode *inode,
+int ocfs2_buffer_read_ahead(struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh);
 
 #endif /* OCFS2_UPTODATE_H */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 915039f..a79a6a9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -253,9 +253,9 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 			break;
 		}
 
-		if (!ocfs2_buffer_uptodate(bucket->bu_inode,
+		if (!ocfs2_buffer_uptodate(INODE_CACHE(bucket->bu_inode),
 					   bucket->bu_bhs[i]))
-			ocfs2_set_new_buffer_uptodate(bucket->bu_inode,
+			ocfs2_set_new_buffer_uptodate(INODE_CACHE(bucket->bu_inode),
 						      bucket->bu_bhs[i]);
 	}
 
@@ -270,7 +270,7 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 {
 	int rc;
 
-	rc = ocfs2_read_blocks(bucket->bu_inode, xb_blkno,
+	rc = ocfs2_read_blocks(INODE_CACHE(bucket->bu_inode), xb_blkno,
 			       bucket->bu_blocks, bucket->bu_bhs, 0,
 			       NULL);
 	if (!rc) {
@@ -394,7 +394,7 @@ static int ocfs2_read_xattr_block(struct inode *inode, u64 xb_blkno,
 	int rc;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_block(inode, xb_blkno, &tmp,
+	rc = ocfs2_read_block(INODE_CACHE(inode), xb_blkno, &tmp,
 			      ocfs2_validate_xattr_block);
 
 	/* If ocfs2_read_block() got us a new bh, pass it up. */
@@ -719,8 +719,8 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 		}
 
 		block = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
-		ocfs2_remove_xattr_clusters_from_cache(inode, block,
-						       alloc_size);
+		ocfs2_remove_xattr_clusters_from_cache(INODE_CACHE(inode),
+						       block, alloc_size);
 		cpos += alloc_size;
 		trunc_len -= alloc_size;
 	}
@@ -965,7 +965,8 @@ static int ocfs2_xattr_get_value_outside(struct inode *inode,
 		blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
 		/* Copy ocfs2_xattr_value */
 		for (i = 0; i < num_clusters * bpc; i++, blkno++) {
-			ret = ocfs2_read_block(inode, blkno, &bh, NULL);
+			ret = ocfs2_read_block(INODE_CACHE(inode), blkno,
+					       &bh, NULL);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -1202,7 +1203,8 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 		blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
 
 		for (i = 0; i < num_clusters * bpc; i++, blkno++) {
-			ret = ocfs2_read_block(inode, blkno, &bh, NULL);
+			ret = ocfs2_read_block(INODE_CACHE(inode), blkno,
+					       &bh, NULL);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -2115,7 +2117,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		}
 
 		new_bh = sb_getblk(inode->i_sb, first_blkno);
-		ocfs2_set_new_buffer_uptodate(inode, new_bh);
+		ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
 
 		ret = ocfs2_journal_access_xb(handle, inode, new_bh,
 					      OCFS2_JOURNAL_ACCESS_CREATE);
@@ -4823,7 +4825,8 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 	mlog(0, "rm xattr extent rec at %u len = %u, start from %llu\n",
 	     cpos, len, (unsigned long long)blkno);
 
-	ocfs2_remove_xattr_clusters_from_cache(inode, blkno, len);
+	ocfs2_remove_xattr_clusters_from_cache(INODE_CACHE(inode), blkno,
+					       len);
 
 	ret = ocfs2_lock_allocators(inode, &et, 0, 1, NULL, &meta_ac);
 	if (ret) {
-- 
1.5.6.5
