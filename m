From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed, 29 Jan 2014 19:48:48 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: improve fsync efficiency and fix
 deadlock between aio_write and sync_file
Message-ID: <20140130034848.GE8798@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently, ocfs2_sync_file grabs i_mutex and forces the current
journal transaction to complete.  This isn't terribly efficient, since
sync_file really only needs to wait for the last transaction involving
that inode to complete, and this doesn't require i_mutex.

Therefore, implement the necessary bits to track the newest tid
associated with an inode, and teach sync_file to wait for that instead
of waiting for everything in the journal to commit.  Furthermore, only
issue the flush request to the drive if jbd2 hasn't already done so.

This also eliminates the deadlock between ocfs2_file_aio_write() and
ocfs2_sync_file().  aio_write takes i_mutex then calls
ocfs2_aiodio_wait() to wait for unaligned dio writes to finish.
However, if that dio completion involves calling fsync, then we can
get into trouble when some ocfs2_sync_file tries to take i_mutex.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/alloc.c   |    1 +
 fs/ocfs2/dir.c     |    4 ++++
 fs/ocfs2/file.c    |   36 +++++++++++++++---------------------
 fs/ocfs2/inode.c   |   28 ++++++++++++++++++++++++++++
 fs/ocfs2/inode.h   |    7 +++++++
 fs/ocfs2/journal.h |   11 +++++++++++
 fs/ocfs2/namei.c   |    4 ++++
 fs/ocfs2/super.c   |    3 +++
 8 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index dc7411f..1750bf0 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6913,6 +6913,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
 	spin_unlock(&oi->ip_lock);
 
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_dinode_new_extent_list(inode, di);
 
 	ocfs2_journal_dirty(handle, di_bh);
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 91a7e85..8b48e9b 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2957,6 +2957,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		ocfs2_init_dir_trailer(dir, dirdata_bh, i);
 	}
 
+	ocfs2_update_inode_fsync_trans(handle, dir, 1);
 	ocfs2_journal_dirty(handle, dirdata_bh);
 
 	if (ocfs2_supports_indexed_dirs(osb) && !dx_inline) {
@@ -3338,6 +3339,7 @@ do_extend:
 	} else {
 		de->rec_len = cpu_to_le16(sb->s_blocksize);
 	}
+	ocfs2_update_inode_fsync_trans(handle, dir, 1);
 	ocfs2_journal_dirty(handle, new_bh);
 
 	dir_i_size += dir->i_sb->s_blocksize;
@@ -3896,6 +3898,7 @@ out_commit:
 		dquot_free_space_nodirty(dir,
 				ocfs2_clusters_to_bytes(dir->i_sb, 1));
 
+	ocfs2_update_inode_fsync_trans(handle, dir, 1);
 	ocfs2_commit_trans(osb, handle);
 
 out:
@@ -4134,6 +4137,7 @@ static int ocfs2_expand_inline_dx_root(struct inode *dir,
 		mlog_errno(ret);
 	did_quota = 0;
 
+	ocfs2_update_inode_fsync_trans(handle, dir, 1);
 	ocfs2_journal_dirty(handle, dx_root_bh);
 
 out_commit:
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6fff128..978072e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -175,9 +175,13 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
 			   int datasync)
 {
 	int err = 0;
-	journal_t *journal;
 	struct inode *inode = file->f_mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	journal_t *journal = osb->journal->j_journal;
+	int ret;
+	tid_t commit_tid;
+	bool needs_barrier = false;
 
 	trace_ocfs2_sync_file(inode, file, file->f_path.dentry,
 			      OCFS2_I(inode)->ip_blkno,
@@ -189,29 +193,19 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
 	if (err)
 		return err;
 
-	/*
-	 * Probably don't need the i_mutex at all in here, just putting it here
-	 * to be consistent with how fsync used to be called, someone more
-	 * familiar with the fs could possibly remove it.
-	 */
-	mutex_lock(&inode->i_mutex);
-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC)) {
-		/*
-		 * We still have to flush drive's caches to get data to the
-		 * platter
-		 */
-		if (osb->s_mount_opt & OCFS2_MOUNT_BARRIER)
-			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
-		goto bail;
+	commit_tid = datasync ? oi->i_datasync_tid : oi->i_sync_tid;
+	if (journal->j_flags & JBD2_BARRIER &&
+	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
+		needs_barrier = true;
+	err = jbd2_complete_transaction(journal, commit_tid);
+	if (needs_barrier) {
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (!err)
+			err = ret;
 	}
 
-	journal = osb->journal->j_journal;
-	err = jbd2_journal_force_commit(journal);
-
-bail:
 	if (err)
 		mlog_errno(err);
-	mutex_unlock(&inode->i_mutex);
 
 	return (err < 0) ? -EIO : 0;
 }
@@ -652,7 +646,7 @@ restarted_transaction:
 			mlog_errno(status);
 		goto leave;
 	}
-
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_journal_dirty(handle, bh);
 
 	spin_lock(&OCFS2_I(inode)->ip_lock);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index f29a90f..28ab8a9 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -130,6 +130,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
+	journal_t *journal = OCFS2_SB(sb)->journal->j_journal;
 
 	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
 			       sysfile_type);
@@ -169,6 +170,32 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 		goto bail;
 	}
 
+	/*
+	 * Set transaction id's of transactions that have to be committed
+	 * to finish f[data]sync. We set them to currently running transaction
+	 * as we cannot be sure that the inode or some of its metadata isn't
+	 * part of the transaction - the inode could have been reclaimed and
+	 * now it is reread from disk.
+	 */
+	if (journal) {
+		transaction_t *transaction;
+		tid_t tid;
+		struct ocfs2_inode_info *oi = OCFS2_I(inode);
+
+		read_lock(&journal->j_state_lock);
+		if (journal->j_running_transaction)
+			transaction = journal->j_running_transaction;
+		else
+			transaction = journal->j_committing_transaction;
+		if (transaction)
+			tid = transaction->t_tid;
+		else
+			tid = journal->j_commit_sequence;
+		read_unlock(&journal->j_state_lock);
+		oi->i_sync_tid = tid;
+		oi->i_datasync_tid = tid;
+	}
+
 bail:
 	if (!IS_ERR(inode)) {
 		trace_ocfs2_iget_end(inode, 
@@ -1260,6 +1287,7 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 	fe->i_mtime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
 
 	ocfs2_journal_dirty(handle, bh);
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 leave:
 	return status;
 }
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 621fc73..b98573f 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -73,6 +73,13 @@ struct ocfs2_inode_info
 	u32				ip_dir_lock_gen;
 
 	struct ocfs2_alloc_reservation	ip_la_data_resv;
+
+	/*
+	 * Transactions that contain inode's metadata needed to complete
+	 * fsync and fdatasync, respectively.
+	 */
+	tid_t i_sync_tid;
+	tid_t i_datasync_tid;
 };
 
 /*
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 9ff4e8c..7f8cde9 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -626,4 +626,15 @@ static inline int ocfs2_begin_ordered_truncate(struct inode *inode,
 				new_size);
 }
 
+static inline void ocfs2_update_inode_fsync_trans(handle_t *handle,
+						  struct inode *inode,
+						  int datasync)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+
+	oi->i_sync_tid = handle->h_transaction->t_tid;
+	if (datasync)
+		oi->i_datasync_tid = handle->h_transaction->t_tid;
+}
+
 #endif /* OCFS2_JOURNAL_H */
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 4f791f6..08cd852 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -475,6 +475,7 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_extent_list *fel;
 	u16 feat;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	*new_fe_bh = NULL;
 
@@ -556,6 +557,9 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 			mlog_errno(status);
 	}
 
+	oi->i_sync_tid = handle->h_transaction->t_tid;
+	oi->i_datasync_tid = handle->h_transaction->t_tid;
+
 	status = 0; /* error in ocfs2_create_new_inode_locks is not
 		     * critical */
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c414929..b1ac60c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -561,6 +561,9 @@ static struct inode *ocfs2_alloc_inode(struct super_block *sb)
 	if (!oi)
 		return NULL;
 
+	oi->i_sync_tid = 0;
+	oi->i_datasync_tid = 0;
+
 	jbd2_journal_init_jbd_inode(&oi->ip_jinode, &oi->vfs_inode);
 	return &oi->vfs_inode;
 }
