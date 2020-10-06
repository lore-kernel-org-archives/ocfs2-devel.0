From: Mauricio Faria de Oliveira <mfo@canonical.com>
Date: Mon,  5 Oct 2020 21:48:40 -0300
Subject: [Ocfs2-devel] [PATCH v5 3/4] ext4: data=journal: fixes for
	ext4_page_mkwrite()
In-Reply-To: <20201006004841.600488-1-mfo@canonical.com>
References: <20201006004841.600488-1-mfo@canonical.com>
Message-ID: <20201006004841.600488-4-mfo@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>, dann frazier <dann.frazier@canonical.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

These are two fixes for data journalling required by
the next patch, discovered while testing it.

First, the optimization to return early if all buffers
are mapped is not appropriate for the next patch:

The inode _must_ be added to the transaction's list in
data=journal mode (so to write-protect pages on commit)
thus we cannot return early there.

Second, once that optimization to reduce transactions
was disabled for data=journal mode, more transactions
happened, and occasionally hit this warning message:
'JBD2: Spotted dirty metadata buffer'.

Reason is, block_page_mkwrite() will set_buffer_dirty()
before do_journal_get_write_access() that is there to
prevent it. This issue was masked by the optimization.

So, on data=journal use __block_write_begin() instead.
This also requires page locking and len recalculation.
(see block_page_mkwrite() for implementation details.)

Finally, as Jan noted there is little sharing between
data=journal and other modes in ext4_page_mkwrite().

However, a prototype of ext4_journalled_page_mkwrite()
showed there still would be lots of duplicated lines
(tens of) that didn't seem worth it.

Thus this patch ends up with an ugly goto to skip all
non-data journalling code (to avoid long indentations,
but that can be changed..) in the beginning, and just
a conditional in the transaction section.

Well, we skip a common part to data journalling which
is the page truncated check, but we do it again after
ext4_journal_start() when we re-acquire the page lock
(so not to acquire the page lock twice needlessly for
data journalling.)

Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/inode.c | 51 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bf596467c234..ac153e340a6f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5977,9 +5977,17 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 	if (err)
 		goto out_ret;
 
+	/*
+	 * On data journalling we skip straight to the transaction handle:
+	 * there's no delalloc; page truncated will be checked later; the
+	 * early return w/ all buffers mapped (calculates size/len) can't
+	 * be used; and there's no dioread_nolock, so only ext4_get_block.
+	 */
+	if (ext4_should_journal_data(inode))
+		goto retry_alloc;
+
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
-	    !ext4_should_journal_data(inode) &&
 	    !ext4_nonda_switch(inode->i_sb)) {
 		do {
 			err = block_page_mkwrite(vma, vmf,
@@ -6005,6 +6013,9 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 	/*
 	 * Return if we have all the buffers mapped. This avoids the need to do
 	 * journal_start/journal_stop which can block and take a long time
+	 *
+	 * This cannot be done for data journalling, as we have to add the
+	 * inode to the transaction's list to writeprotect pages on commit.
 	 */
 	if (page_has_buffers(page)) {
 		if (!ext4_walk_page_buffers(NULL, page_buffers(page),
@@ -6029,16 +6040,42 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 		ret = VM_FAULT_SIGBUS;
 		goto out;
 	}
-	err = block_page_mkwrite(vma, vmf, get_block);
-	if (!err && ext4_should_journal_data(inode)) {
-		if (ext4_walk_page_buffers(handle, page_buffers(page), 0,
-			  PAGE_SIZE, NULL, do_journal_get_write_access)) {
+	/*
+	 * Data journalling can't use block_page_mkwrite() because it
+	 * will set_buffer_dirty() before do_journal_get_write_access()
+	 * thus might hit warning messages for dirty metadata buffers.
+	 */
+	if (!ext4_should_journal_data(inode)) {
+		err = block_page_mkwrite(vma, vmf, get_block);
+	} else {
+		lock_page(page);
+		size = i_size_read(inode);
+		/* Page got truncated from under us? */
+		if (page->mapping != mapping || page_offset(page) > size) {
 			unlock_page(page);
-			ret = VM_FAULT_SIGBUS;
+			ret = VM_FAULT_NOPAGE;
 			ext4_journal_stop(handle);
 			goto out;
 		}
-		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
+
+		if (page->index == size >> PAGE_SHIFT)
+			len = size & ~PAGE_MASK;
+		else
+			len = PAGE_SIZE;
+
+		err = __block_write_begin(page, 0, len, ext4_get_block);
+		if (!err) {
+			if (ext4_walk_page_buffers(handle, page_buffers(page),
+					0, len, NULL, do_journal_get_write_access)) {
+				unlock_page(page);
+				ret = VM_FAULT_SIGBUS;
+				ext4_journal_stop(handle);
+				goto out;
+			}
+			ext4_set_inode_state(inode, EXT4_STATE_JDATA);
+		} else {
+			unlock_page(page);
+		}
 	}
 	ext4_journal_stop(handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-- 
2.17.1
