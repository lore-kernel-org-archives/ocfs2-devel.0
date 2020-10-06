From: Mauricio Faria de Oliveira <mfo@canonical.com>
Date: Mon,  5 Oct 2020 21:48:39 -0300
Subject: [Ocfs2-devel] [PATCH v5 2/4] jbd2, ext4,
	ocfs2: introduce/use journal callbacks
	j_submit|finish_inode_data_buffers()
In-Reply-To: <20201006004841.600488-1-mfo@canonical.com>
References: <20201006004841.600488-1-mfo@canonical.com>
Message-ID: <20201006004841.600488-3-mfo@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>, dann frazier <dann.frazier@canonical.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

Introduce journal callbacks to allow different behaviors
for an inode in journal_submit|finish_inode_data_buffers().

The existing users of the current behavior (ext4, ocfs2)
are adapted to use the previously exported functions
that implement the current behavior.

Users are callers of jbd2_journal_inode_ranged_write|wait(),
which adds the inode to the transaction's inode list with
the JI_WRITE|WAIT_DATA flags. Only ext4 and ocfs2 in-tree.

Both CONFIG_EXT4_FS and CONFIG_OCSFS2_FS select CONFIG_JBD2,
which builds fs/jbd2/commit.c and journal.c that define and
export the functions, so we can call directly in ext4/ocfs2.

Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/super.c      |  4 ++++
 fs/jbd2/commit.c     | 30 ++++++++++++++++++------------
 fs/ocfs2/journal.c   |  4 ++++
 include/linux/jbd2.h | 25 ++++++++++++++++++++++++-
 4 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea425b49b345..a14c1ed39aa3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4646,6 +4646,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
 	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
+	sbi->s_journal->j_submit_inode_data_buffers =
+		jbd2_journal_submit_inode_data_buffers;
+	sbi->s_journal->j_finish_inode_data_buffers =
+		jbd2_journal_finish_inode_data_buffers;
 
 no_journal:
 	if (!test_opt(sb, NO_MBCACHE)) {
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f79b86b4241f..6252b4c50666 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -197,6 +197,12 @@ int jbd2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
 		.range_end = jinode->i_dirty_end,
 	};
 
+	/*
+	 * submit the inode data buffers. We use writepage
+	 * instead of writepages. Because writepages can do
+	 * block allocation with delalloc. We need to write
+	 * only allocated blocks here.
+	 */
 	return generic_writepages(mapping, &wbc);
 }
 
@@ -220,16 +226,13 @@ static int journal_submit_data_buffers(journal_t *journal,
 			continue;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
-		/*
-		 * submit the inode data buffers. We use writepage
-		 * instead of writepages. Because writepages can do
-		 * block allocation  with delalloc. We need to write
-		 * only allocated blocks here.
-		 */
+		/* submit the inode data buffers. */
 		trace_jbd2_submit_inode_data(jinode->i_vfs_inode);
-		err = jbd2_journal_submit_inode_data_buffers(jinode);
-		if (!ret)
-			ret = err;
+		if (journal->j_submit_inode_data_buffers) {
+			err = journal->j_submit_inode_data_buffers(jinode);
+			if (!ret)
+				ret = err;
+		}
 		spin_lock(&journal->j_list_lock);
 		J_ASSERT(jinode->i_transaction == commit_transaction);
 		jinode->i_flags &= ~JI_COMMIT_RUNNING;
@@ -267,9 +270,12 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 			continue;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
-		err = jbd2_journal_finish_inode_data_buffers(jinode);
-		if (!ret)
-			ret = err;
+		/* wait for the inode data buffers writeout. */
+		if (journal->j_finish_inode_data_buffers) {
+			err = journal->j_finish_inode_data_buffers(jinode);
+			if (!ret)
+				ret = err;
+		}
 		spin_lock(&journal->j_list_lock);
 		jinode->i_flags &= ~JI_COMMIT_RUNNING;
 		smp_mb();
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index b425f0b01dce..b9a9d69dde7e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -883,6 +883,10 @@ int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
 		  OCFS2_JOURNAL_DIRTY_FL);
 
 	journal->j_journal = j_journal;
+	journal->j_journal->j_submit_inode_data_buffers =
+		jbd2_journal_submit_inode_data_buffers;
+	journal->j_journal->j_finish_inode_data_buffers =
+		jbd2_journal_finish_inode_data_buffers;
 	journal->j_inode = inode;
 	journal->j_bh = bh;
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2865a5475888..4aaa408c0ca7 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -629,7 +629,9 @@ struct transaction_s
 	struct journal_head	*t_shadow_list;
 
 	/*
-	 * List of inodes whose data we've modified in data=ordered mode.
+	 * List of inodes associated with the transaction; e.g., ext4 uses
+	 * this to track inodes in data=ordered and data=journal mode that
+	 * need special handling on transaction commit; also used by ocfs2.
 	 * [j_list_lock]
 	 */
 	struct list_head	t_inode_list;
@@ -1111,6 +1113,27 @@ struct journal_s
 	void			(*j_commit_callback)(journal_t *,
 						     transaction_t *);
 
+	/**
+	 * @j_submit_inode_data_buffers:
+	 *
+	 * This function is called for all inodes associated with the
+	 * committing transaction marked with JI_WRITE_DATA flag
+	 * before we start to write out the transaction to the journal.
+	 */
+	int			(*j_submit_inode_data_buffers)
+					(struct jbd2_inode *);
+
+	/**
+	 * @j_finish_inode_data_buffers:
+	 *
+	 * This function is called for all inodes associated with the
+	 * committing transaction marked with JI_WAIT_DATA flag
+	 * after we have written the transaction to the journal
+	 * but before we write out the commit block.
+	 */
+	int			(*j_finish_inode_data_buffers)
+					(struct jbd2_inode *);
+
 	/*
 	 * Journal statistics
 	 */
-- 
2.17.1
