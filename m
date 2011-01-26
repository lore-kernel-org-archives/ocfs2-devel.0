From: Darrick J. Wong <djwong@us.ibm.com>
Date: Tue, 25 Jan 2011 23:18:33 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] jbd2: Remove barrier feature conditional
	flag (or:	always issue flushes)
In-Reply-To: <20110126071200.GE32261@tux1.beaverton.ibm.com>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
Message-ID: <20110126071833.GJ27190@tux1.beaverton.ibm.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, tytso@mit.edu, shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz, snitzer@redhat.com, linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de, josef@redhat.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

As part of migrating the FLUSH/FUA knob to the block layer, remove the journal
flags and various conditionals in jbd2 that surround flush issue calls in favor
of always issuing the flush.  The block layer will handle gracefully the
situation where a FLUSH or FUA request is issued to a device that doesn't
support it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/fsync.c      |    5 ++---
 fs/ext4/super.c      |    7 -------
 fs/jbd2/checkpoint.c |    3 +--
 fs/jbd2/commit.c     |   10 +++-------
 fs/ocfs2/journal.c   |    4 ----
 include/linux/jbd2.h |    1 -
 6 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 7829b28..8c99359 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -208,12 +208,11 @@ int ext4_sync_file(struct file *file, int datasync)
 		 * the journal device.)
 		 */
 		if (ext4_should_writeback_data(inode) &&
-		    (journal->j_fs_dev != journal->j_dev) &&
-		    (journal->j_flags & JBD2_BARRIER))
+		    (journal->j_fs_dev != journal->j_dev))
 			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
 					NULL);
 		ret = jbd2_log_wait_commit(journal, commit_tid);
-	} else if (journal->j_flags & JBD2_BARRIER)
+	} else
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 	return ret;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 48ce561..7379829 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3704,10 +3704,6 @@ static void ext4_init_journal_params(struct super_block *sb, journal_t *journal)
 	journal->j_max_batch_time = sbi->s_max_batch_time;
 
 	write_lock(&journal->j_state_lock);
-	if (test_opt(sb, BARRIER))
-		journal->j_flags |= JBD2_BARRIER;
-	else
-		journal->j_flags &= ~JBD2_BARRIER;
 	if (test_opt(sb, DATA_ERR_ABORT))
 		journal->j_flags |= JBD2_ABORT_ON_SYNCDATA_ERR;
 	else
@@ -3899,9 +3895,6 @@ static int ext4_load_journal(struct super_block *sb,
 			return -EINVAL;
 	}
 
-	if (!(journal->j_flags & JBD2_BARRIER))
-		ext4_msg(sb, KERN_INFO, "barriers disabled");
-
 	if (!really_read_only && test_opt(sb, UPDATE_JOURNAL)) {
 		err = jbd2_journal_update_format(journal);
 		if (err)  {
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 6a79fd0..02eb6b9 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -540,8 +540,7 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 	 * correctness.  Fortunately jbd2_cleanup_journal_tail()
 	 * doesn't get called all that often.
 	 */
-	if ((journal->j_fs_dev != journal->j_dev) &&
-	    (journal->j_flags & JBD2_BARRIER))
+	if (journal->j_fs_dev != journal->j_dev)
 		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
 	if (!(journal->j_flags & JBD2_ABORT))
 		jbd2_journal_update_superblock(journal, 1);
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f3ad159..e90ec0d 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -134,8 +134,7 @@ static int journal_submit_commit_record(journal_t *journal,
 	set_buffer_uptodate(bh);
 	bh->b_end_io = journal_end_buffer_io_sync;
 
-	if (journal->j_flags & JBD2_BARRIER &&
-	    !JBD2_HAS_INCOMPAT_FEATURE(journal,
+	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
 				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
 		ret = submit_bh(WRITE_SYNC_PLUG | WRITE_FLUSH_FUA, bh);
 	else
@@ -686,8 +685,7 @@ start_journal_io:
 	 * the commit record
 	 */
 	if (commit_transaction->t_flushed_data_blocks &&
-	    (journal->j_fs_dev != journal->j_dev) &&
-	    (journal->j_flags & JBD2_BARRIER))
+	    (journal->j_fs_dev != journal->j_dev))
 		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
 
 	/* Done it all: now write the commit record asynchronously. */
@@ -811,10 +809,8 @@ wait_for_iobuf:
 	if (!err && !is_journal_aborted(journal))
 		err = journal_wait_on_commit_record(journal, cbh);
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
-				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
-	    journal->j_flags & JBD2_BARRIER) {
+				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
 		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL);
-	}
 
 	if (err)
 		jbd2_journal_abort(journal, err);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index faa2303..caacabe 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -758,10 +758,6 @@ void ocfs2_set_journal_params(struct ocfs2_super *osb)
 
 	write_lock(&journal->j_state_lock);
 	journal->j_commit_interval = commit_interval;
-	if (osb->s_mount_opt & OCFS2_MOUNT_BARRIER)
-		journal->j_flags |= JBD2_BARRIER;
-	else
-		journal->j_flags &= ~JBD2_BARRIER;
 	write_unlock(&journal->j_state_lock);
 }
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 27e79c2..2c420ce 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -987,7 +987,6 @@ struct journal_s
 #define JBD2_ACK_ERR	0x004	/* The errno in the sb has been acked */
 #define JBD2_FLUSHED	0x008	/* The journal superblock has been flushed */
 #define JBD2_LOADED	0x010	/* The journal superblock has been loaded */
-#define JBD2_BARRIER	0x020	/* Use IDE barriers */
 #define JBD2_ABORT_ON_SYNCDATA_ERR	0x040	/* Abort the journal on file
 						 * data write error in ordered
 						 * mode */
