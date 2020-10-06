From: Mauricio Faria de Oliveira <mfo@canonical.com>
Date: Mon,  5 Oct 2020 21:48:41 -0300
Subject: [Ocfs2-devel] [PATCH v5 4/4] ext4: data=journal: write-protect
	pages on j_submit_inode_data_buffers()
In-Reply-To: <20201006004841.600488-1-mfo@canonical.com>
References: <20201006004841.600488-1-mfo@canonical.com>
Message-ID: <20201006004841.600488-5-mfo@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>, dann frazier <dann.frazier@canonical.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

This implements journal callbacks j_submit|finish_inode_data_buffers()
with different behavior for data=journal: to write-protect pages under
commit, preventing changes to buffers writeably mapped to userspace.

If a buffer's content changes between commit's checksum calculation
and write-out to disk, it can cause journal recovery/mount failures
upon a kernel crash or power loss.

    [   27.334874] EXT4-fs: Warning: mounting with data=journal disables delayed allocation, dioread_nolock, and O_DIRECT support!
    [   27.339492] JBD2: Invalid checksum recovering data block 8705 in log
    [   27.342716] JBD2: recovery failed
    [   27.343316] EXT4-fs (loop0): error loading journal
    mount: /ext4: can't read superblock on /dev/loop0.

In j_submit_inode_data_buffers() we write-protect the inode's pages
with write_cache_pages() and redirty w/ writepage callback if needed.

In j_finish_inode_data_buffers() there is nothing do to.

And in order to use the callbacks, inodes are added to the inode list
in transaction in __ext4_journalled_writepage() and ext4_page_mkwrite().

In ext4_page_mkwrite() we must make sure that the buffers are attached
to the transaction as jbddirty with write_end_fn(), as already done in
__ext4_journalled_writepage().

Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Reported-by: Dann Frazier <dann.frazier@canonical.com>
Reported-by: kernel test robot <lkp@intel.com> # wbc.nr_to_write
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 25 +++++++++-----
 fs/ext4/super.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 101 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ac153e340a6f..af5de62c1214 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1910,6 +1910,9 @@ static int __ext4_journalled_writepage(struct page *page,
 		err = ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
 					     write_end_fn);
 	}
+	if (ret == 0)
+		ret = err;
+	err = ext4_jbd2_inode_add_write(handle, inode, 0, len);
 	if (ret == 0)
 		ret = err;
 	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
@@ -6052,10 +6055,8 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 		size = i_size_read(inode);
 		/* Page got truncated from under us? */
 		if (page->mapping != mapping || page_offset(page) > size) {
-			unlock_page(page);
 			ret = VM_FAULT_NOPAGE;
-			ext4_journal_stop(handle);
-			goto out;
+			goto out_error;
 		}
 
 		if (page->index == size >> PAGE_SHIFT)
@@ -6065,13 +6066,15 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 
 		err = __block_write_begin(page, 0, len, ext4_get_block);
 		if (!err) {
+			ret = VM_FAULT_SIGBUS;
 			if (ext4_walk_page_buffers(handle, page_buffers(page),
-					0, len, NULL, do_journal_get_write_access)) {
-				unlock_page(page);
-				ret = VM_FAULT_SIGBUS;
-				ext4_journal_stop(handle);
-				goto out;
-			}
+					0, len, NULL, do_journal_get_write_access))
+				goto out_error;
+			if (ext4_walk_page_buffers(handle, page_buffers(page),
+					0, len, NULL, write_end_fn))
+				goto out_error;
+			if (ext4_jbd2_inode_add_write(handle, inode, 0, len))
+				goto out_error;
 			ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 		} else {
 			unlock_page(page);
@@ -6086,6 +6089,10 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 	up_read(&EXT4_I(inode)->i_mmap_sem);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
+out_error:
+	unlock_page(page);
+	ext4_journal_stop(handle);
+	goto out;
 }
 
 vm_fault_t ext4_filemap_fault(struct vm_fault *vmf)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a14c1ed39aa3..a2fc62a6d3b7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -472,6 +472,89 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
 	spin_unlock(&sbi->s_md_lock);
 }
 
+/*
+ * This writepage callback for write_cache_pages()
+ * takes care of a few cases after page cleaning.
+ *
+ * write_cache_pages() already checks for dirty pages
+ * and calls clear_page_dirty_for_io(), which we want,
+ * to write protect the pages.
+ *
+ * However, we may have to redirty a page (see below.)
+ */
+static int ext4_journalled_writepage_callback(struct page *page,
+					      struct writeback_control *wbc,
+					      void *data)
+{
+	transaction_t *transaction = (transaction_t *) data;
+	struct buffer_head *bh, *head;
+	struct journal_head *jh;
+
+	bh = head = page_buffers(page);
+	do {
+		/*
+		 * We have to redirty a page in these cases:
+		 * 1) If buffer is dirty, it means the page was dirty because it
+		 * contains a buffer that needs checkpointing. So the dirty bit
+		 * needs to be preserved so that checkpointing writes the buffer
+		 * properly.
+		 * 2) If buffer is not part of the committing transaction
+		 * (we may have just accidentally come across this buffer because
+		 * inode range tracking is not exact) or if the currently running
+		 * transaction already contains this buffer as well, dirty bit
+		 * needs to be preserved so that the buffer gets writeprotected
+		 * properly on running transaction's commit.
+		 */
+		jh = bh2jh(bh);
+		if (buffer_dirty(bh) ||
+		    (jh && (jh->b_transaction != transaction ||
+			    jh->b_next_transaction))) {
+			redirty_page_for_writepage(wbc, page);
+			goto out;
+		}
+	} while ((bh = bh->b_this_page) != head);
+
+out:
+	return AOP_WRITEPAGE_ACTIVATE;
+}
+
+static int ext4_journalled_submit_inode_data_buffers(struct jbd2_inode *jinode)
+{
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
+	struct writeback_control wbc = {
+		.sync_mode =  WB_SYNC_ALL,
+		.nr_to_write = LONG_MAX,
+		.range_start = jinode->i_dirty_start,
+		.range_end = jinode->i_dirty_end,
+        };
+
+	return write_cache_pages(mapping, &wbc,
+				 ext4_journalled_writepage_callback,
+				 jinode->i_transaction);
+}
+
+static int ext4_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
+{
+	int ret;
+
+	if (ext4_should_journal_data(jinode->i_vfs_inode))
+		ret = ext4_journalled_submit_inode_data_buffers(jinode);
+	else
+		ret = jbd2_journal_submit_inode_data_buffers(jinode);
+
+	return ret;
+}
+
+static int ext4_journal_finish_inode_data_buffers(struct jbd2_inode *jinode)
+{
+	int ret = 0;
+
+	if (!ext4_should_journal_data(jinode->i_vfs_inode))
+		ret = jbd2_journal_finish_inode_data_buffers(jinode);
+
+	return ret;
+}
+
 static bool system_going_down(void)
 {
 	return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
@@ -4647,9 +4730,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
 	sbi->s_journal->j_submit_inode_data_buffers =
-		jbd2_journal_submit_inode_data_buffers;
+		ext4_journal_submit_inode_data_buffers;
 	sbi->s_journal->j_finish_inode_data_buffers =
-		jbd2_journal_finish_inode_data_buffers;
+		ext4_journal_finish_inode_data_buffers;
 
 no_journal:
 	if (!test_opt(sb, NO_MBCACHE)) {
-- 
2.17.1
