From: Joel Becker <joel.becker@oracle.com>
Date: Wed,  7 Jul 2010 04:16:05 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: When zero extending, do it by page.
In-Reply-To: <20100703213219.GB21262@mail.oracle.com>
References: <20100703213219.GB21262@mail.oracle.com>
Message-ID: <1278501367-7710-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

ocfs2_zero_extend() does its zeroing block by block, but it calls a
function named ocfs2_write_zero_page().  Let's have
ocfs2_write_zero_page() handle the page level.  From
ocfs2_zero_extend()'s perspective, it is now page-at-a-time.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/aops.c |   30 --------------
 fs/ocfs2/file.c |  119 +++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 85 insertions(+), 64 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 3623ca2..9a5c931 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -459,36 +459,6 @@ int walk_page_buffers(	handle_t *handle,
 	return ret;
 }
 
-handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
-							 struct page *page,
-							 unsigned from,
-							 unsigned to)
-{
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	handle_t *handle;
-	int ret = 0;
-
-	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto out;
-	}
-
-	if (ocfs2_should_order_data(inode)) {
-		ret = ocfs2_jbd2_file_inode(handle, inode);
-		if (ret < 0)
-			mlog_errno(ret);
-	}
-out:
-	if (ret) {
-		if (!IS_ERR(handle))
-			ocfs2_commit_trans(osb, handle);
-		handle = ERR_PTR(ret);
-	}
-	return handle;
-}
-
 static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 {
 	sector_t status;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6a13ea6..a6e0eb6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -724,28 +724,55 @@ leave:
 	return status;
 }
 
+/*
+ * While a write will already be ordering the data, a truncate will not.
+ * Thus, we need to explicitly order the zeroed pages.
+ */
+static handle_t *ocfs2_zero_start_ordered_transaction(struct inode *inode)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	handle_t *handle = NULL;
+	int ret = 0;
+
+	if (ocfs2_should_order_data(inode))
+		goto out;
+
+	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_jbd2_file_inode(handle, inode);
+	if (ret < 0)
+		mlog_errno(ret);
+
+out:
+	if (ret) {
+		if (!IS_ERR(handle))
+			ocfs2_commit_trans(osb, handle);
+		handle = ERR_PTR(ret);
+	}
+	return handle;
+}
+
 /* Some parts of this taken from generic_cont_expand, which turned out
  * to be too fragile to do exactly what we need without us having to
  * worry about recursive locking in ->write_begin() and ->write_end(). */
-static int ocfs2_write_zero_page(struct inode *inode,
-				 u64 size)
+static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
+				 u64 abs_to)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
-	unsigned long index;
-	unsigned int offset;
+	unsigned long index = abs_from >> PAGE_CACHE_SHIFT;
 	handle_t *handle = NULL;
 	int ret;
+	unsigned zero_from, zero_to, block_start, block_end;
 
-	offset = (size & (PAGE_CACHE_SIZE-1)); /* Within page */
-	/* ugh.  in prepare/commit_write, if from==to==start of block, we
-	** skip the prepare.  make sure we never send an offset for the start
-	** of a block
-	*/
-	if ((offset & (inode->i_sb->s_blocksize - 1)) == 0) {
-		offset++;
-	}
-	index = size >> PAGE_CACHE_SHIFT;
+	BUG_ON(abs_from >= abs_to);
+	BUG_ON(abs_to > ((index + 1) << PAGE_CACHE_SHIFT));
+	BUG_ON(abs_from & (inode->i_blkbits - 1));
 
 	page = grab_cache_page(mapping, index);
 	if (!page) {
@@ -754,31 +781,52 @@ static int ocfs2_write_zero_page(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_prepare_write_nolock(inode, page, offset, offset);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out_unlock;
-	}
+	/* Get the offsets within the page that we want to zero */
+	zero_from = abs_from & (PAGE_CACHE_SIZE - 1);
+	zero_to = abs_to & (PAGE_CACHE_SIZE - 1);
+	if (!zero_to)
+		zero_to = PAGE_CACHE_SIZE;
 
-	if (ocfs2_should_order_data(inode)) {
-		handle = ocfs2_start_walk_page_trans(inode, page, offset,
-						     offset);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			handle = NULL;
+	/* We know that zero_from is block aligned */
+	for (block_start = zero_from;
+	     (block_start < PAGE_CACHE_SIZE) && (block_start < zero_to);
+	     block_start = block_end) {
+		block_end = block_start + (1 << inode->i_blkbits);
+
+		/*
+		 * block_start is block-aligned.  Bump it by one to
+		 * force ocfs2_{prepare,commit}_write() to zero the
+		 * whole block.
+		 */
+		ret = ocfs2_prepare_write_nolock(inode, page,
+						 block_start + 1,
+						 block_start + 1);
+		if (ret < 0) {
+			mlog_errno(ret);
 			goto out_unlock;
 		}
-	}
 
-	/* must not update i_size! */
-	ret = block_commit_write(page, offset, offset);
-	if (ret < 0)
-		mlog_errno(ret);
-	else
-		ret = 0;
+		if (!handle) {
+			handle = ocfs2_zero_start_ordered_transaction(inode);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				handle = NULL;
+				break;
+			}
+		}
+
+		/* must not update i_size! */
+		ret = block_commit_write(page, block_start + 1,
+					 block_start + 1);
+		if (ret < 0)
+			mlog_errno(ret);
+		else
+			ret = 0;
+	}
 
 	if (handle)
 		ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+
 out_unlock:
 	unlock_page(page);
 	page_cache_release(page);
@@ -790,18 +838,21 @@ static int ocfs2_zero_extend(struct inode *inode,
 			     u64 zero_to_size)
 {
 	int ret = 0;
-	u64 start_off;
+	u64 start_off, next_off;
 	struct super_block *sb = inode->i_sb;
 
 	start_off = ocfs2_align_bytes_to_blocks(sb, i_size_read(inode));
 	while (start_off < zero_to_size) {
-		ret = ocfs2_write_zero_page(inode, start_off);
+		next_off = (start_off & PAGE_CACHE_MASK) + PAGE_CACHE_SIZE;
+		if (next_off > zero_to_size)
+			next_off = zero_to_size;
+		ret = ocfs2_write_zero_page(inode, start_off, next_off);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
 		}
 
-		start_off += sb->s_blocksize;
+		start_off = next_off;
 
 		/*
 		 * Very large extends have the potential to lock up
-- 
1.7.1
