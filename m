From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:24 2007
Subject: [Ocfs2-devel] [PATCH 12/15] ocfs2: Read support for inline data
Message-ID: <200709192012.l8JKCHwn029357@rgmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This hooks up ocfs2_readpage() to populate a page with data from an inode
block. Direct IO reads from inline data are modified to fall back to
buffered I/O. Appropriate checks are also placed in the extent map code to
avoid reading an extent list when inline data might be stored.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/aops.c       |   80 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/extent_map.c |    6 ++++
 2 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 57fc7e3..4234d78 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -206,9 +206,70 @@ bail:
 	return err;
 }
 
+static int ocfs2_read_inline_data(struct inode *inode, struct page *page,
+				  struct buffer_head *di_bh)
+{
+	void *kaddr;
+	unsigned int size;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)) {
+		ocfs2_error(inode->i_sb, "Inode %llu lost inline data flag",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EROFS;
+	}
+
+	size = i_size_read(inode);
+
+	if (size > PAGE_CACHE_SIZE ||
+	    size > ocfs2_max_inline_data(inode->i_sb)) {
+		ocfs2_error(inode->i_sb,
+			    "Inode %llu has with inline data has bad size: %u",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno, size);
+		return -EROFS;
+	}
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	if (size)
+		memcpy(kaddr, di->id2.i_data.id_data, size);
+	/* Clear the remaining part of the page */
+	memset(kaddr + size, 0, PAGE_CACHE_SIZE - size);
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	SetPageUptodate(page);
+
+	return 0;
+}
+
+static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(!OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
+
+	ret = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, &di_bh,
+			       OCFS2_BH_CACHED, inode);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_inline_data(inode, page, di_bh);
+out:
+	unlock_page(page);
+
+	brelse(di_bh);
+	return ret;
+}
+
 static int ocfs2_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	loff_t start = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	int ret, unlock = 1;
 
@@ -222,7 +283,7 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 		goto out;
 	}
 
-	if (down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem) == 0) {
+	if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
 		ret = AOP_TRUNCATED_PAGE;
 		goto out_meta_unlock;
 	}
@@ -252,7 +313,10 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 		goto out_alloc;
 	}
 
-	ret = block_read_full_page(page, ocfs2_get_block);
+	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		ret = ocfs2_readpage_inline(inode, page);
+	else
+		ret = block_read_full_page(page, ocfs2_get_block);
 	unlock = 0;
 
 	ocfs2_data_unlock(inode, 0);
@@ -397,7 +461,9 @@ static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 		down_read(&OCFS2_I(inode)->ip_alloc_sem);
 	}
 
-	err = ocfs2_extent_map_get_blocks(inode, block, &p_blkno, NULL, NULL);
+	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL))
+		err = ocfs2_extent_map_get_blocks(inode, block, &p_blkno, NULL,
+						  NULL);
 
 	if (!INODE_JOURNAL(inode)) {
 		up_read(&OCFS2_I(inode)->ip_alloc_sem);
@@ -411,7 +477,6 @@ static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 		goto bail;
 	}
 
-
 bail:
 	status = err ? 0 : p_blkno;
 
@@ -566,6 +631,13 @@ static ssize_t ocfs2_direct_IO(int rw,
 
 	mlog_entry_void();
 
+	/*
+	 * Fallback to buffered I/O if we see an inode without
+	 * extents.
+	 */
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
 	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb))) {
 		/*
 		 * We get PR data locks even for O_DIRECT.  This
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 03c1d36..c58668a 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -387,6 +387,12 @@ int ocfs2_get_clusters(struct inode *inode, u32 v_cluster,
 	struct ocfs2_extent_rec *rec;
 	u32 coff;
 
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		ret = -ERANGE;
+		mlog_errno(ret);
+		goto out;
+	}
+
 	ret = ocfs2_extent_map_lookup(inode, v_cluster, p_cluster,
 				      num_clusters, extent_flags);
 	if (ret == 0)
-- 
1.5.0.6
