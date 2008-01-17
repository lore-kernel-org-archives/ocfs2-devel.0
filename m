From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:00 2008
Subject: [Ocfs2-devel] [PATCH 08/30] ocfs2: Readpages support
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-9-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

Add ->readpages support to Ocfs2. This is rather trivial - all it required
is a small update to ocfs2_get_block (for mapping full extents via b_size)
and an ocfs2_readpages() function which partially mirrors ocfs2_readpage().

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/aops.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index ac8c390..2a0eaac 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -26,6 +26,7 @@
 #include <asm/byteorder.h>
 #include <linux/swap.h>
 #include <linux/pipe_fs_i.h>
+#include <linux/mpage.h>
 
 #define MLOG_MASK_PREFIX ML_FILE_IO
 #include <cluster/masklog.h>
@@ -139,7 +140,8 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
 {
 	int err = 0;
 	unsigned int ext_flags;
-	u64 p_blkno, past_eof;
+	u64 max_blocks = bh_result->b_size >> inode->i_blkbits;
+	u64 p_blkno, count, past_eof;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	mlog_entry("(0x%p, %llu, 0x%p, %d)\n", inode,
@@ -155,7 +157,7 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		goto bail;
 	}
 
-	err = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno, NULL,
+	err = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno, &count,
 					  &ext_flags);
 	if (err) {
 		mlog(ML_ERROR, "Error %d from get_blocks(0x%p, %llu, 1, "
@@ -164,6 +166,9 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		goto bail;
 	}
 
+	if (max_blocks < count)
+		count = max_blocks;
+
 	/*
 	 * ocfs2 never allocates in this function - the only time we
 	 * need to use BH_New is when we're extending i_size on a file
@@ -178,6 +183,8 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
 	if (p_blkno && !(ext_flags & OCFS2_EXT_UNWRITTEN))
 		map_bh(bh_result, inode->i_sb, p_blkno);
 
+	bh_result->b_size = count << inode->i_blkbits;
+
 	if (!ocfs2_sparse_alloc(osb)) {
 		if (p_blkno == 0) {
 			err = -EIO;
@@ -322,6 +329,62 @@ out:
 	return ret;
 }
 
+/*
+ * This is used only for read-ahead. Failures or difficult to handle
+ * siutations are safe to ignore.
+ *
+ * Right now, we don't bother with BH_Boundary - in-inode extent lists
+ * are quite large (243 extents on 4k blocks), so most inodes don't
+ * grow out to a tree. If need be, detecting boundary extents could
+ * trivially be added in a future version of ocfs2_get_block().
+ */
+static int ocfs2_readpages(struct file *filp, struct address_space *mapping,
+			   struct list_head *pages, unsigned nr_pages)
+{
+	int ret, err = -EIO;
+	struct inode *inode = mapping->host;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	loff_t start;
+	struct page *last;
+
+	/*
+	 * Use the nonblocking flag for the dlm code to avoid page
+	 * lock inversion, but don't bother with retrying.
+	 */
+	ret = ocfs2_inode_lock_full(inode, NULL, 0, OCFS2_LOCK_NONBLOCK);
+	if (ret)
+		return err;
+
+	if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
+		ocfs2_inode_unlock(inode, 0);
+		return err;
+	}
+
+	/*
+	 * Don't bother with inline-data. There isn't anything
+	 * to read-ahead in that case anyway...
+	 */
+	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		goto out_unlock;
+
+	/*
+	 * Check whether a remote node truncated this file - we just
+	 * drop out in that case as it's not worth handling here.
+	 */
+	last = list_entry(pages->prev, struct page, lru);
+	start = (loff_t)last->index << PAGE_CACHE_SHIFT;
+	if (start >= i_size_read(inode))
+		goto out_unlock;
+
+	err = mpage_readpages(mapping, pages, nr_pages, ocfs2_get_block);
+
+out_unlock:
+	up_read(&oi->ip_alloc_sem);
+	ocfs2_inode_unlock(inode, 0);
+
+	return err;
+}
+
 /* Note: Because we don't support holes, our allocation has
  * already happened (allocation writes zeros to the file data)
  * so we don't have to worry about ordered writes in
@@ -1877,6 +1940,7 @@ static int ocfs2_write_end(struct file *file, struct address_space *mapping,
 
 const struct address_space_operations ocfs2_aops = {
 	.readpage	= ocfs2_readpage,
+	.readpages	= ocfs2_readpages,
 	.writepage	= ocfs2_writepage,
 	.write_begin	= ocfs2_write_begin,
 	.write_end	= ocfs2_write_end,
-- 
1.5.3.6
