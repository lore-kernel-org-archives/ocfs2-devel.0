Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4F634CE6;
	Tue, 19 Sep 2023 04:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=kMS4yLjT+MvyIpz+8c4RceJl7Cq4cP3Nn5r0TL01AkM=; b=Gna+Nrs1iPcm3EFwmrZCisgDxF
	l/i6DX/38hzEhDl9on1LFmpXrAhYPkJ5V68yiyuA6l9UXILvc1gxtibKrQVGRHVjtcJ7wlOPBIjF/
	RB863lpp0nbBCdecrYesQv5ZVNHxIbcU4YA93VliccoRmRKwHiwSVU/2W7GWOwSnoUv87Wf/Fu+QB
	0Pazbp+1rvyhhansi50qiEWNHRJjK+BlvES+cklfcW7GFI2NZrJn3ltjIvvYHY48plSGJXXuCfbc1
	WvU6ahflCYXK976m0N50npcMtfyQ9uXq7UW4cKM2QBUoxvrPS9TW3v+mLG7WppG4FIu6/uwVYWiQL
	CJe5pF5g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qiSi3-00FFl0-Jt; Tue, 19 Sep 2023 04:51:39 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 12/26] nilfs2: Convert nilfs_mdt_forget_block() to use a folio
Date: Tue, 19 Sep 2023 05:51:21 +0100
Message-Id: <20230919045135.3635437-13-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230919045135.3635437-1-willy@infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove a number of folio->page->folio conversions.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/mdt.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index db2260d6e44d..11b7cf4acc92 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -356,30 +356,28 @@ int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
  */
 int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
 {
-	pgoff_t index = (pgoff_t)block >>
-		(PAGE_SHIFT - inode->i_blkbits);
-	struct page *page;
-	unsigned long first_block;
+	pgoff_t index = block >> (PAGE_SHIFT - inode->i_blkbits);
+	struct folio *folio;
+	struct buffer_head *bh;
 	int ret = 0;
 	int still_dirty;
 
-	page = find_lock_page(inode->i_mapping, index);
-	if (!page)
+	folio = filemap_lock_folio(inode->i_mapping, index);
+	if (IS_ERR(folio))
 		return -ENOENT;
 
-	wait_on_page_writeback(page);
+	folio_wait_writeback(folio);
 
-	first_block = (unsigned long)index <<
-		(PAGE_SHIFT - inode->i_blkbits);
-	if (page_has_buffers(page)) {
-		struct buffer_head *bh;
-
-		bh = nilfs_page_get_nth_block(page, block - first_block);
+	bh = folio_buffers(folio);
+	if (bh) {
+		unsigned long first_block = index <<
+				(PAGE_SHIFT - inode->i_blkbits);
+		bh = get_nth_bh(bh, block - first_block);
 		nilfs_forget_buffer(bh);
 	}
-	still_dirty = PageDirty(page);
-	unlock_page(page);
-	put_page(page);
+	still_dirty = folio_test_dirty(folio);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	if (still_dirty ||
 	    invalidate_inode_pages2_range(inode->i_mapping, index, index) != 0)
-- 
2.40.1

