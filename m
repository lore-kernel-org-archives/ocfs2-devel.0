Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C30E226ED6
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419028; cv=none; b=Z+AIqpimXNg23AQRAfeRqUdu8GgGaJ2oOy9YOngEuZkCwM+YW59315wXv8OU8S9xfBF8p8LqeEG0tcfx5OrWjMspkPNHec3um2hy/J57IG+T7WMBHI17fdIFYSYAzMT+WtOx4jjQ/e5RpIgCOMtPTl0/wZaoNbJFetPK4XaM6cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419028; c=relaxed/simple;
	bh=sz/1TgSG/YFjVIblpFHI84bB/oYWk8dsdXtDiQQjyaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByPdpZzBh7OJ0bdWYXqMc/9wM9uusk9X3eDKOWUA5GqtXtGmseyWgx77hiGY0u2ARg7R8NWkWJehrRdH1gKObAhT8g13Ktv8lZ4m+VyHnxNAHMkEpntv8p1Ox6fc6MWodp0SDmLeBDQLYmqHIgnTTHFQO6KJdyO/zU59vb8tCU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IgyNPUxS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IgyNPUxS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=KblIVmxpEco2yqyBjKmuEMH7jBMf12lFTg6fcR2SQyk=; b=IgyNPUxSrJHr23SHGexJPhZUHS
	SnI8v99YPSMFXaL/oMNvtD9OT5wXPxIJBaqyrflRwsiK4Xzy6MeaCid0pbRiQUdqsqXB3Am9VlN6i
	iW8lsRRmX0nF1L9nJZIg7WHLTDLZnIucGRkpjrwxW500AXrTeNVz3l/NS8MLuTixhxzG9MXz+IZ6O
	2+z8GOP4m4EGRkDBRUY+jb6le2ZCWmFTIFGZXSOyR2rlWb36gN6vRiU5fSFxH17isnsbcWbFzeA8a
	NNMGolweXU4f2S4nO+f7EZKYNeOb5gX1fzwnKMzTd2+/M3CkdQKOVwEdNfLkDgHxiYZzAh+59TUQ1
	8Bd9r1DA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTH-0000000DLGY-2E03;
	Thu, 05 Dec 2024 17:16:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	ocfs2-devel@lists.linux.dev,
	Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH 19/23] ocfs2: Convert ocfs2_read_inline_data() to take a folio
Date: Thu,  5 Dec 2024 17:16:47 +0000
Message-ID: <20241205171653.3179945-20-willy@infradead.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241205171653.3179945-1-willy@infradead.org>
References: <20241205171653.3179945-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All callers now have a folio, so pass it in.  We can use
folio_fill_tail() instead of open-coding it.  Saves a call to
compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/alloc.c |  2 +-
 fs/ocfs2/aops.c  | 20 ++++++--------------
 fs/ocfs2/aops.h  |  2 +-
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c8d9d5e9a7fd..36b536b54a2d 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7135,7 +7135,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		 * This should populate the 1st page for us and mark
 		 * it up to date.
 		 */
-		ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
+		ret = ocfs2_read_inline_data(inode, folio, di_bh);
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f1eba968563f..80fe7a68cbcc 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -215,10 +215,9 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
 	return err;
 }
 
-int ocfs2_read_inline_data(struct inode *inode, struct page *page,
+int ocfs2_read_inline_data(struct inode *inode, struct folio *folio,
 			   struct buffer_head *di_bh)
 {
-	void *kaddr;
 	loff_t size;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -230,7 +229,7 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 
 	size = i_size_read(inode);
 
-	if (size > PAGE_SIZE ||
+	if (size > folio_size(folio) ||
 	    size > ocfs2_max_inline_data_with_xattr(inode->i_sb, di)) {
 		ocfs2_error(inode->i_sb,
 			    "Inode %llu has with inline data has bad size: %Lu\n",
@@ -239,15 +238,8 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 		return -EROFS;
 	}
 
-	kaddr = kmap_atomic(page);
-	if (size)
-		memcpy(kaddr, di->id2.i_data.id_data, size);
-	/* Clear the remaining part of the page */
-	memset(kaddr + size, 0, PAGE_SIZE - size);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr);
-
-	SetPageUptodate(page);
+	folio_fill_tail(folio, 0, di->id2.i_data.id_data, size);
+	folio_mark_uptodate(folio);
 
 	return 0;
 }
@@ -266,7 +258,7 @@ static int ocfs2_readpage_inline(struct inode *inode, struct folio *folio)
 		goto out;
 	}
 
-	ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
+	ret = ocfs2_read_inline_data(inode, folio, di_bh);
 out:
 	folio_unlock(folio);
 
@@ -1506,7 +1498,7 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 		ocfs2_set_inode_data_inline(inode, di);
 
 	if (!folio_test_uptodate(folio)) {
-		ret = ocfs2_read_inline_data(inode, &folio->page, wc->w_di_bh);
+		ret = ocfs2_read_inline_data(inode, folio, wc->w_di_bh);
 		if (ret) {
 			ocfs2_commit_trans(osb, handle);
 
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index cf8d202d9a8b..6f25066e5756 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -41,7 +41,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		struct folio **foliop, void **fsdata,
 		struct buffer_head *di_bh, struct folio *mmap_folio);
 
-int ocfs2_read_inline_data(struct inode *inode, struct page *page,
+int ocfs2_read_inline_data(struct inode *inode, struct folio *folio,
 			   struct buffer_head *di_bh);
 int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
 
-- 
2.45.2

