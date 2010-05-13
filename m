From: Jan Kara <jack@suse.cz>
Date: Thu, 13 May 2010 21:58:00 +0200
Subject: [Ocfs2-devel] [PATCH 4/7] ocfs2: Fix quota locking
In-Reply-To: <1273780683-3638-1-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
Message-ID: <1273780683-3638-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2 had two issues with quota locking:
a) When reading dquot from global quota file, we started a transaction while
   holding dqio_mutex which is prone to deadlocks because other paths to it
   other way around
b) During ocfs2_sync_dquot we were not protected against concurrent writers
   on the same node. Because we first copy data to local buffer, a race
   could happen resulting in old data being written to global quota file and
   thus causing quota inconsistency after a crash.
c) ip_alloc_sem of quota files was acquired while a transaction is started
   in ocfs2_quota_write which can deadlock because we first get ip_alloc_sem
   and then start a transaction when extending quota files.

We fix the problem a) by pulling all necessary code to ocfs2_acquire_dquot
and ocfs2_release_dquot. Thus we no longer depend on generic dquot_acquire
to do the locking and can force proper lock ordering.

Problems b) and c) are fixed by locking i_mutex and ip_alloc_sem of
global quota file in ocfs2_lock_global_qf and removing ip_alloc_sem from
ocfs2_quota_read and ocfs2_quota_write.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota.h        |    5 +-
 fs/ocfs2/quota_global.c |  307 ++++++++++++++++++++++++++---------------------
 fs/ocfs2/quota_local.c  |   88 ++++++--------
 3 files changed, 214 insertions(+), 186 deletions(-)

diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index c762343..903ffa9 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -104,10 +104,11 @@ static inline int ocfs2_global_release_dquot(struct dquot *dquot)
 
 int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex);
 void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex);
-int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
-			   struct buffer_head **bh);
+int ocfs2_validate_quota_block(struct super_block *sb, struct buffer_head *bh);
 int ocfs2_read_quota_phys_block(struct inode *inode, u64 p_block,
 				struct buffer_head **bh);
+int ocfs2_create_local_dquot(struct dquot *dquot);
+int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot);
 
 extern const struct dquot_operations ocfs2_quota_operations;
 extern struct quota_format_type ocfs2_quota_format;
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index b571bf8..2cf080c 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -28,6 +28,41 @@
 #include "buffer_head_io.h"
 #include "quota.h"
 
+/*
+ * Locking of quotas with OCFS2 is rather complex. Here are rules that
+ * should be obeyed by all the functions:
+ * - any write of quota structure (either to local or global file) is protected
+ *   by dqio_mutex or dquot->dq_lock.
+ * - any modification of global quota file holds inode cluster lock, i_mutex,
+ *   and ip_alloc_sem of the global quota file (achieved by
+ *   ocfs2_lock_global_qf). It also has to hold qinfo_lock.
+ * - an allocation of new blocks for local quota file is protected by
+ *   its ip_alloc_sem
+ *
+ * A rough sketch of locking dependencies (lf = local file, gf = global file):
+ * Normal filesystem operation:
+ *   start_trans -> dqio_mutex -> write to lf
+ * Syncing of local and global file:
+ *   ocfs2_lock_global_qf -> start_trans -> dqio_mutex -> qinfo_lock ->
+ *     write to gf
+ *						       -> write to lf
+ * Acquire dquot for the first time:
+ *   dq_lock -> ocfs2_lock_global_qf -> qinfo_lock -> read from gf
+ *				     -> alloc space for gf
+ *				     -> start_trans -> qinfo_lock -> write to gf
+ *	     -> ip_alloc_sem of lf -> alloc space for lf
+ *	     -> write to lf
+ * Release last reference to dquot:
+ *   dq_lock -> ocfs2_lock_global_qf -> start_trans -> qinfo_lock -> write to gf
+ *	     -> write to lf
+ * Note that all the above operations also hold the inode cluster lock of lf.
+ * Recovery:
+ *   inode cluster lock of recovered lf
+ *     -> read bitmaps -> ip_alloc_sem of lf
+ *     -> ocfs2_lock_global_qf -> start_trans -> dqio_mutex -> qinfo_lock ->
+ *        write to gf
+ */
+
 static struct workqueue_struct *ocfs2_quota_wq = NULL;
 
 static void qsync_work_fn(struct work_struct *work);
@@ -92,8 +127,7 @@ struct qtree_fmt_operations ocfs2_global_ops = {
 	.is_id = ocfs2_global_is_id,
 };
 
-static int ocfs2_validate_quota_block(struct super_block *sb,
-				      struct buffer_head *bh)
+int ocfs2_validate_quota_block(struct super_block *sb, struct buffer_head *bh)
 {
 	struct ocfs2_disk_dqtrailer *dqt =
 		ocfs2_block_dqtrailer(sb->s_blocksize, bh->b_data);
@@ -111,33 +145,6 @@ static int ocfs2_validate_quota_block(struct super_block *sb,
 	return ocfs2_validate_meta_ecc(sb, bh->b_data, &dqt->dq_check);
 }
 
-int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
-			   struct buffer_head **bh)
-{
-	int rc = 0;
-	struct buffer_head *tmp = *bh;
-
-	if (i_size_read(inode) >> inode->i_sb->s_blocksize_bits <= v_block) {
-		ocfs2_error(inode->i_sb,
-			    "Quota file %llu is probably corrupted! Requested "
-			    "to read block %Lu but file has size only %Lu\n",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			    (unsigned long long)v_block,
-			    (unsigned long long)i_size_read(inode));
-		return -EIO;
-	}
-	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, 0,
-				    ocfs2_validate_quota_block);
-	if (rc)
-		mlog_errno(rc);
-
-	/* If ocfs2_read_virt_blocks() got us a new bh, pass it up. */
-	if (!rc && !*bh)
-		*bh = tmp;
-
-	return rc;
-}
-
 int ocfs2_read_quota_phys_block(struct inode *inode, u64 p_block,
 				struct buffer_head **bhp)
 {
@@ -151,27 +158,6 @@ int ocfs2_read_quota_phys_block(struct inode *inode, u64 p_block,
 	return rc;
 }
 
-static int ocfs2_get_quota_block(struct inode *inode, int block,
-				 struct buffer_head **bh)
-{
-	u64 pblock, pcount;
-	int err;
-
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-	err = ocfs2_extent_map_get_blocks(inode, block, &pblock, &pcount, NULL);
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-	if (err) {
-		mlog_errno(err);
-		return err;
-	}
-	*bh = sb_getblk(inode->i_sb, pblock);
-	if (!*bh) {
-		err = -EIO;
-		mlog_errno(err);
-	}
-	return err;
-}
-
 /* Read data from global quotafile - avoid pagecache and such because we cannot
  * afford acquiring the locks... We use quota cluster lock to serialize
  * operations. Caller is responsible for acquiring it. */
@@ -186,6 +172,7 @@ ssize_t ocfs2_quota_read(struct super_block *sb, int type, char *data,
 	int err = 0;
 	struct buffer_head *bh;
 	size_t toread, tocopy;
+	u64 pblock = 0, pcount = 0;
 
 	if (off > i_size)
 		return 0;
@@ -194,8 +181,19 @@ ssize_t ocfs2_quota_read(struct super_block *sb, int type, char *data,
 	toread = len;
 	while (toread > 0) {
 		tocopy = min_t(size_t, (sb->s_blocksize - offset), toread);
+		if (!pcount) {
+			err = ocfs2_extent_map_get_blocks(gqinode, blk, &pblock,
+							  &pcount, NULL);
+			if (err) {
+				mlog_errno(err);
+				return err;
+			}
+		} else {
+			pcount--;
+			pblock++;
+		}
 		bh = NULL;
-		err = ocfs2_read_quota_block(gqinode, blk, &bh);
+		err = ocfs2_read_quota_phys_block(gqinode, pblock, &bh);
 		if (err) {
 			mlog_errno(err);
 			return err;
@@ -223,6 +221,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 	int err = 0, new = 0, ja_type;
 	struct buffer_head *bh = NULL;
 	handle_t *handle = journal_current_handle();
+	u64 pblock, pcount;
 
 	if (!handle) {
 		mlog(ML_ERROR, "Quota write (off=%llu, len=%llu) cancelled "
@@ -235,12 +234,11 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 		len = sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE - offset;
 	}
 
-	mutex_lock_nested(&gqinode->i_mutex, I_MUTEX_QUOTA);
 	if (gqinode->i_size < off + len) {
 		loff_t rounded_end =
 				ocfs2_align_bytes_to_blocks(sb, off + len);
 
-		/* Space is already allocated in ocfs2_global_read_dquot() */
+		/* Space is already allocated in ocfs2_acquire_dquot() */
 		err = ocfs2_simple_size_update(gqinode,
 					       oinfo->dqi_gqi_bh,
 					       rounded_end);
@@ -248,13 +246,20 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 			goto out;
 		new = 1;
 	}
+	err = ocfs2_extent_map_get_blocks(gqinode, blk, &pblock, &pcount, NULL);
+	if (err) {
+		mlog_errno(err);
+		goto out;
+	}
 	/* Not rewriting whole block? */
 	if ((offset || len < sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE) &&
 	    !new) {
-		err = ocfs2_read_quota_block(gqinode, blk, &bh);
+		err = ocfs2_read_quota_phys_block(gqinode, pblock, &bh);
 		ja_type = OCFS2_JOURNAL_ACCESS_WRITE;
 	} else {
-		err = ocfs2_get_quota_block(gqinode, blk, &bh);
+		bh = sb_getblk(sb, pblock);
+		if (!bh)
+			err = -ENOMEM;
 		ja_type = OCFS2_JOURNAL_ACCESS_CREATE;
 	}
 	if (err) {
@@ -281,13 +286,11 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 		goto out;
 out:
 	if (err) {
-		mutex_unlock(&gqinode->i_mutex);
 		mlog_errno(err);
 		return err;
 	}
 	gqinode->i_version++;
 	ocfs2_mark_inode_dirty(handle, gqinode, oinfo->dqi_gqi_bh);
-	mutex_unlock(&gqinode->i_mutex);
 	return len;
 }
 
@@ -305,11 +308,23 @@ int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
 	else
 		WARN_ON(bh != oinfo->dqi_gqi_bh);
 	spin_unlock(&dq_data_lock);
+	if (ex) {
+		mutex_lock(&oinfo->dqi_gqinode->i_mutex);
+		down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
+	} else {
+		down_read(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
+	}
 	return 0;
 }
 
 void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
 {
+	if (ex) {
+		up_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
+		mutex_unlock(&oinfo->dqi_gqinode->i_mutex);
+	} else {
+		up_read(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
+	}
 	ocfs2_inode_unlock(oinfo->dqi_gqinode, ex);
 	brelse(oinfo->dqi_gqi_bh);
 	spin_lock(&dq_data_lock);
@@ -460,75 +475,6 @@ static int ocfs2_calc_global_qinit_credits(struct super_block *sb, int type)
 			OCFS2_QUOTA_BLOCK_UPDATE_CREDITS;
 }
 
-/* Read in information from global quota file and acquire a reference to it.
- * dquot_acquire() has already started the transaction and locked quota file */
-int ocfs2_global_read_dquot(struct dquot *dquot)
-{
-	int err, err2, ex = 0;
-	struct super_block *sb = dquot->dq_sb;
-	int type = dquot->dq_type;
-	struct ocfs2_mem_dqinfo *info = sb_dqinfo(sb, type)->dqi_priv;
-	struct ocfs2_super *osb = OCFS2_SB(sb);
-	struct inode *gqinode = info->dqi_gqinode;
-	int need_alloc = ocfs2_global_qinit_alloc(sb, type);
-	handle_t *handle = NULL;
-
-	err = ocfs2_qinfo_lock(info, 0);
-	if (err < 0)
-		goto out;
-	err = qtree_read_dquot(&info->dqi_gi, dquot);
-	if (err < 0)
-		goto out_qlock;
-	OCFS2_DQUOT(dquot)->dq_use_count++;
-	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
-	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
-	ocfs2_qinfo_unlock(info, 0);
-
-	if (!dquot->dq_off) {	/* No real quota entry? */
-		ex = 1;
-		/*
-		 * Add blocks to quota file before we start a transaction since
-		 * locking allocators ranks above a transaction start
-		 */
-		WARN_ON(journal_current_handle());
-		down_write(&OCFS2_I(gqinode)->ip_alloc_sem);
-		err = ocfs2_extend_no_holes(gqinode,
-			gqinode->i_size + (need_alloc << sb->s_blocksize_bits),
-			gqinode->i_size);
-		up_write(&OCFS2_I(gqinode)->ip_alloc_sem);
-		if (err < 0)
-			goto out;
-	}
-
-	handle = ocfs2_start_trans(osb,
-				   ocfs2_calc_global_qinit_credits(sb, type));
-	if (IS_ERR(handle)) {
-		err = PTR_ERR(handle);
-		goto out;
-	}
-	err = ocfs2_qinfo_lock(info, ex);
-	if (err < 0)
-		goto out_trans;
-	err = qtree_write_dquot(&info->dqi_gi, dquot);
-	if (ex && info_dirty(sb_dqinfo(dquot->dq_sb, dquot->dq_type))) {
-		err2 = __ocfs2_global_write_info(dquot->dq_sb, dquot->dq_type);
-		if (!err)
-			err = err2;
-	}
-out_qlock:
-	if (ex)
-		ocfs2_qinfo_unlock(info, 1);
-	else
-		ocfs2_qinfo_unlock(info, 0);
-out_trans:
-	if (handle)
-		ocfs2_commit_trans(osb, handle);
-out:
-	if (err < 0)
-		mlog_errno(err);
-	return err;
-}
-
 /* Sync local information about quota modifications with global quota file.
  * Caller must have started the transaction and obtained exclusive lock for
  * global quota file inode */
@@ -744,6 +690,10 @@ static int ocfs2_release_dquot(struct dquot *dquot)
 
 	mlog_entry("id=%u, type=%d", dquot->dq_id, dquot->dq_type);
 
+	mutex_lock(&dquot->dq_lock);
+	/* Check whether we are not racing with some other dqget() */
+	if (atomic_read(&dquot->dq_count) > 1)
+		goto out;
 	status = ocfs2_lock_global_qf(oinfo, 1);
 	if (status < 0)
 		goto out;
@@ -754,30 +704,113 @@ static int ocfs2_release_dquot(struct dquot *dquot)
 		mlog_errno(status);
 		goto out_ilock;
 	}
-	status = dquot_release(dquot);
+
+	status = ocfs2_global_release_dquot(dquot);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_trans;
+	}
+	status = ocfs2_local_release_dquot(handle, dquot);
+	/*
+	 * If we fail here, we cannot do much as global structure is
+	 * already released. So just complain...
+	 */
+	if (status < 0)
+		mlog_errno(status);
+	clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
+out_trans:
 	ocfs2_commit_trans(osb, handle);
 out_ilock:
 	ocfs2_unlock_global_qf(oinfo, 1);
 out:
+	mutex_unlock(&dquot->dq_lock);
 	mlog_exit(status);
 	return status;
 }
 
+/*
+ * Read global dquot structure from disk or create it if it does
+ * not exist. Also update use count of the global structure and
+ * create structure in node-local quota file.
+ */
 static int ocfs2_acquire_dquot(struct dquot *dquot)
 {
-	struct ocfs2_mem_dqinfo *oinfo =
-			sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv;
-	int status = 0;
+	int status = 0, err;
+	int ex = 0;
+	struct super_block *sb = dquot->dq_sb;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	int type = dquot->dq_type;
+	struct ocfs2_mem_dqinfo *info = sb_dqinfo(sb, type)->dqi_priv;
+	struct inode *gqinode = info->dqi_gqinode;
+	int need_alloc = ocfs2_global_qinit_alloc(sb, type);
+	handle_t *handle;
 
-	mlog_entry("id=%u, type=%d", dquot->dq_id, dquot->dq_type);
-	/* We need an exclusive lock, because we're going to update use count
-	 * and instantiate possibly new dquot structure */
-	status = ocfs2_lock_global_qf(oinfo, 1);
+	mlog_entry("id=%u, type=%d", dquot->dq_id, type);
+	mutex_lock(&dquot->dq_lock);
+	/*
+	 * We need an exclusive lock, because we're going to update use count
+	 * and instantiate possibly new dquot structure
+	 */
+	status = ocfs2_lock_global_qf(info, 1);
 	if (status < 0)
 		goto out;
-	status = dquot_acquire(dquot);
-	ocfs2_unlock_global_qf(oinfo, 1);
+	if (!test_bit(DQ_READ_B, &dquot->dq_flags)) {
+		status = ocfs2_qinfo_lock(info, 0);
+		if (status < 0)
+			goto out_dq;
+		status = qtree_read_dquot(&info->dqi_gi, dquot);
+		ocfs2_qinfo_unlock(info, 0);
+		if (status < 0)
+			goto out_dq;
+	}
+	set_bit(DQ_READ_B, &dquot->dq_flags);
+
+	OCFS2_DQUOT(dquot)->dq_use_count++;
+	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
+	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
+	if (!dquot->dq_off) {	/* No real quota entry? */
+		ex = 1;
+		/*
+		 * Add blocks to quota file before we start a transaction since
+		 * locking allocators ranks above a transaction start
+		 */
+		WARN_ON(journal_current_handle());
+		status = ocfs2_extend_no_holes(gqinode,
+			gqinode->i_size + (need_alloc << sb->s_blocksize_bits),
+			gqinode->i_size);
+		if (status < 0)
+			goto out_dq;
+	}
+
+	handle = ocfs2_start_trans(osb,
+				   ocfs2_calc_global_qinit_credits(sb, type));
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		goto out_dq;
+	}
+	status = ocfs2_qinfo_lock(info, ex);
+	if (status < 0)
+		goto out_trans;
+	status = qtree_write_dquot(&info->dqi_gi, dquot);
+	if (ex && info_dirty(sb_dqinfo(sb, type))) {
+		err = __ocfs2_global_write_info(sb, type);
+		if (!status)
+			status = err;
+	}
+	ocfs2_qinfo_unlock(info, ex);
+out_trans:
+	ocfs2_commit_trans(osb, handle);
+out_dq:
+	ocfs2_unlock_global_qf(info, 1);
+	if (status < 0)
+		goto out;
+
+	status = ocfs2_create_local_dquot(dquot);
+	if (status < 0)
+		goto out;
+	set_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out:
+	mutex_unlock(&dquot->dq_lock);
 	mlog_exit(status);
 	return status;
 }
@@ -822,7 +855,9 @@ static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
 		mlog_errno(status);
 		goto out_ilock;
 	}
+	mutex_lock(&sb_dqopt(sb)->dqio_mutex);
 	status = ocfs2_sync_dquot(dquot);
+	mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_trans;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 97f2180..5e62e44 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -22,6 +22,7 @@
 #include "dlmglue.h"
 #include "quota.h"
 #include "uptodate.h"
+#include "super.h"
 
 /* Number of local quota structures per block */
 static inline unsigned int ol_quota_entries_per_block(struct super_block *sb)
@@ -133,6 +134,39 @@ static int ocfs2_modify_bh(struct inode *inode, struct buffer_head *bh,
 	return 0;
 }
 
+/*
+ * Read quota block from a given logical offset.
+ *
+ * This function acquires ip_alloc_sem and thus it must not be called with a
+ * transaction started.
+ */
+static int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
+				  struct buffer_head **bh)
+{
+	int rc = 0;
+	struct buffer_head *tmp = *bh;
+
+	if (i_size_read(inode) >> inode->i_sb->s_blocksize_bits <= v_block) {
+		ocfs2_error(inode->i_sb,
+			    "Quota file %llu is probably corrupted! Requested "
+			    "to read block %Lu but file has size only %Lu\n",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			    (unsigned long long)v_block,
+			    (unsigned long long)i_size_read(inode));
+		return -EIO;
+	}
+	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, 0,
+				    ocfs2_validate_quota_block);
+	if (rc)
+		mlog_errno(rc);
+
+	/* If ocfs2_read_virt_blocks() got us a new bh, pass it up. */
+	if (!rc && !*bh)
+		*bh = tmp;
+
+	return rc;
+}
+
 /* Check whether we understand format of quota files */
 static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
 {
@@ -980,10 +1014,8 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 	}
 
 	/* Initialize chunk header */
-	down_read(&OCFS2_I(lqinode)->ip_alloc_sem);
 	status = ocfs2_extent_map_get_blocks(lqinode, oinfo->dqi_blocks,
 					     &p_blkno, NULL, NULL);
-	up_read(&OCFS2_I(lqinode)->ip_alloc_sem);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_trans;
@@ -1015,10 +1047,8 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 	}
 
 	/* Initialize new block with structures */
-	down_read(&OCFS2_I(lqinode)->ip_alloc_sem);
 	status = ocfs2_extent_map_get_blocks(lqinode, oinfo->dqi_blocks + 1,
 					     &p_blkno, NULL, NULL);
-	up_read(&OCFS2_I(lqinode)->ip_alloc_sem);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_trans;
@@ -1119,10 +1149,8 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 	}
 
 	/* Get buffer from the just added block */
-	down_read(&OCFS2_I(lqinode)->ip_alloc_sem);
 	status = ocfs2_extent_map_get_blocks(lqinode, oinfo->dqi_blocks,
 					     &p_blkno, NULL, NULL);
-	up_read(&OCFS2_I(lqinode)->ip_alloc_sem);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
@@ -1209,7 +1237,7 @@ static void olq_alloc_dquot(struct buffer_head *bh, void *private)
 }
 
 /* Create dquot in the local file for given id */
-static int ocfs2_create_local_dquot(struct dquot *dquot)
+int ocfs2_create_local_dquot(struct dquot *dquot)
 {
 	struct super_block *sb = dquot->dq_sb;
 	int type = dquot->dq_type;
@@ -1259,36 +1287,11 @@ out:
 	return status;
 }
 
-/* Create entry in local file for dquot, load data from the global file */
-static int ocfs2_local_read_dquot(struct dquot *dquot)
-{
-	int status;
-
-	mlog_entry("id=%u, type=%d\n", dquot->dq_id, dquot->dq_type);
-
-	status = ocfs2_global_read_dquot(dquot);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_err;
-	}
-
-	/* Now create entry in the local quota file */
-	status = ocfs2_create_local_dquot(dquot);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out_err;
-	}
-	mlog_exit(0);
-	return 0;
-out_err:
-	mlog_exit(status);
-	return status;
-}
-
-/* Release dquot structure from local quota file. ocfs2_release_dquot() has
- * already started a transaction and obtained exclusive lock for global
- * quota file. */
-static int ocfs2_local_release_dquot(struct dquot *dquot)
+/*
+ * Release dquot structure from local quota file. ocfs2_release_dquot() has
+ * already started a transaction and written all changes to global quota file
+ */
+int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot)
 {
 	int status;
 	int type = dquot->dq_type;
@@ -1296,15 +1299,6 @@ static int ocfs2_local_release_dquot(struct dquot *dquot)
 	struct super_block *sb = dquot->dq_sb;
 	struct ocfs2_local_disk_chunk *dchunk;
 	int offset;
-	handle_t *handle = journal_current_handle();
-
-	BUG_ON(!handle);
-	/* First write all local changes to global file */
-	status = ocfs2_global_release_dquot(dquot);
-	if (status < 0) {
-		mlog_errno(status);
-		goto out;
-	}
 
 	status = ocfs2_journal_access_dq(handle,
 			INODE_CACHE(sb_dqopt(sb)->files[type]),
@@ -1341,9 +1335,7 @@ static const struct quota_format_ops ocfs2_format_ops = {
 	.read_file_info		= ocfs2_local_read_info,
 	.write_file_info	= ocfs2_global_write_info,
 	.free_file_info		= ocfs2_local_free_info,
-	.read_dqblk		= ocfs2_local_read_dquot,
 	.commit_dqblk		= ocfs2_local_write_dquot,
-	.release_dqblk		= ocfs2_local_release_dquot,
 };
 
 struct quota_format_type ocfs2_quota_format = {
-- 
1.6.4.2
