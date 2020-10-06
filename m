From: Mauricio Faria de Oliveira <mfo@canonical.com>
Date: Mon,  5 Oct 2020 21:48:38 -0300
Subject: [Ocfs2-devel] [PATCH v5 1/4] jbd2: introduce/export functions
	jbd2_journal_submit|finish_inode_data_buffers()
In-Reply-To: <20201006004841.600488-1-mfo@canonical.com>
References: <20201006004841.600488-1-mfo@canonical.com>
Message-ID: <20201006004841.600488-2-mfo@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>, dann frazier <dann.frazier@canonical.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

Export functions that implement the current behavior done
for an inode in journal_submit|finish_inode_data_buffers().

No functional change.

Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/jbd2/commit.c     | 36 ++++++++++++++++--------------------
 fs/jbd2/journal.c    |  2 ++
 include/linux/jbd2.h |  4 ++++
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 6d2da8ad0e6f..f79b86b4241f 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -187,19 +187,17 @@ static int journal_wait_on_commit_record(journal_t *journal,
  * use writepages() because with delayed allocation we may be doing
  * block allocation in writepages().
  */
-static int journal_submit_inode_data_buffers(struct address_space *mapping,
-		loff_t dirty_start, loff_t dirty_end)
+int jbd2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
 {
-	int ret;
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
 	struct writeback_control wbc = {
 		.sync_mode =  WB_SYNC_ALL,
 		.nr_to_write = mapping->nrpages * 2,
-		.range_start = dirty_start,
-		.range_end = dirty_end,
+		.range_start = jinode->i_dirty_start,
+		.range_end = jinode->i_dirty_end,
 	};
 
-	ret = generic_writepages(mapping, &wbc);
-	return ret;
+	return generic_writepages(mapping, &wbc);
 }
 
 /*
@@ -215,16 +213,11 @@ static int journal_submit_data_buffers(journal_t *journal,
 {
 	struct jbd2_inode *jinode;
 	int err, ret = 0;
-	struct address_space *mapping;
 
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
-		loff_t dirty_start = jinode->i_dirty_start;
-		loff_t dirty_end = jinode->i_dirty_end;
-
 		if (!(jinode->i_flags & JI_WRITE_DATA))
 			continue;
-		mapping = jinode->i_vfs_inode->i_mapping;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
 		/*
@@ -234,8 +227,7 @@ static int journal_submit_data_buffers(journal_t *journal,
 		 * only allocated blocks here.
 		 */
 		trace_jbd2_submit_inode_data(jinode->i_vfs_inode);
-		err = journal_submit_inode_data_buffers(mapping, dirty_start,
-				dirty_end);
+		err = jbd2_journal_submit_inode_data_buffers(jinode);
 		if (!ret)
 			ret = err;
 		spin_lock(&journal->j_list_lock);
@@ -248,6 +240,15 @@ static int journal_submit_data_buffers(journal_t *journal,
 	return ret;
 }
 
+int jbd2_journal_finish_inode_data_buffers(struct jbd2_inode *jinode)
+{
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
+
+	return filemap_fdatawait_range_keep_errors(mapping,
+						   jinode->i_dirty_start,
+						   jinode->i_dirty_end);
+}
+
 /*
  * Wait for data submitted for writeout, refile inodes to proper
  * transaction if needed.
@@ -262,16 +263,11 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
-		loff_t dirty_start = jinode->i_dirty_start;
-		loff_t dirty_end = jinode->i_dirty_end;
-
 		if (!(jinode->i_flags & JI_WAIT_DATA))
 			continue;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
-		err = filemap_fdatawait_range_keep_errors(
-				jinode->i_vfs_inode->i_mapping, dirty_start,
-				dirty_end);
+		err = jbd2_journal_finish_inode_data_buffers(jinode);
 		if (!ret)
 			ret = err;
 		spin_lock(&journal->j_list_lock);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 17fdc482f554..c0600405e7a2 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -91,6 +91,8 @@ EXPORT_SYMBOL(jbd2_journal_try_to_free_buffers);
 EXPORT_SYMBOL(jbd2_journal_force_commit);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_write);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_wait);
+EXPORT_SYMBOL(jbd2_journal_submit_inode_data_buffers);
+EXPORT_SYMBOL(jbd2_journal_finish_inode_data_buffers);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 08f904943ab2..2865a5475888 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1421,6 +1421,10 @@ extern int	   jbd2_journal_inode_ranged_write(handle_t *handle,
 extern int	   jbd2_journal_inode_ranged_wait(handle_t *handle,
 			struct jbd2_inode *inode, loff_t start_byte,
 			loff_t length);
+extern int	   jbd2_journal_submit_inode_data_buffers(
+			struct jbd2_inode *jinode);
+extern int	   jbd2_journal_finish_inode_data_buffers(
+			struct jbd2_inode *jinode);
 extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
 				struct jbd2_inode *inode, loff_t new_size);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
-- 
2.17.1
