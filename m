Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D427226EDE
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419052; cv=none; b=SPbGy8PzBuR9CuhoytmJGNe2Y/3UzSlmPtdhuVYdo2UXOSGsWet0pPem2SRoua5L9gFNYYj4rZXrrqvytyV61zscI49ebkkIa2LhFH4Kuf5S5CMidUFWJLiutxVfB3rD1ISYYfdO+xYPu+wI/wYsQOk1Mm/ngglarOMkE7slfOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419052; c=relaxed/simple;
	bh=wlv6N9lMsZJnyr5EjbhX0vGKk36/kJ+MsWhETXMfw+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuMrcRb/kvoF28BUluOazklGKz+3GSPCMF67rWRAevmHmW4lFRU9oSM5VDkEhsvPUwYDcgiG0gXifR2/qfPhhwCv06o1Xob9EHFXbgxTz0L2P0yoIAMvGF+li3OTgXOTb5hzwAgtwv3DtAz8RKiERrNFHwmEcAKtgocICYSYogg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DiCk+cr+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DiCk+cr+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=OWPYwJHsbe8+Xvq+8+JVMaQlULm41wzo2YKYKt+QVME=; b=DiCk+cr+iePLUXOb73M9ortm6o
	kFTsPt7rYyJlEv73yZdExsnNUlgQWo6sV97X7Qyn0c38SgyR8bZIxq6Lh8d+2tMbde3u2HIHqDu4E
	sUkfHhtNqRnF+j7zwNg4BGhFKnjjNp4zKdSLprLTeKMonm/syLINf4He4Y9oL1cPthRAYxY0oWyV9
	Qn0FbnXWtdO94aSTAIY6oDXNEgSIsSoq/uubSbxo3HAQZ1WbWJ54BDJhpP2Omzr1ghXmIcovksLky
	eP9OI7QRcVDlATD34NaAmqpbaUfCG6Tik8WrTB3R8MDwWrb7ev+HVQ72KgCu7hMUwnprWrW771A3b
	QRqrWT2A==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTH-0000000DLGR-0abt;
	Thu, 05 Dec 2024 17:16:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 17/23] ocfs2: Convert ocfs2_duplicate_clusters_by_page() to use a folio
Date: Thu,  5 Dec 2024 17:16:45 +0000
Message-ID: <20241205171653.3179945-18-willy@infradead.org>
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

From: Mark Tinguely <mark.tinguely@oracle.com>

Retrieve folios from the page cache, not pages, and use a folio
throughout this function.  Removes seven calls to compound_head().

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/refcounttree.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 004393b13c0a..68e0339690e9 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2902,7 +2902,6 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 	int ret = 0, partial;
 	struct super_block *sb = inode->i_sb;
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
-	struct page *page;
 	pgoff_t page_index;
 	unsigned int from, to;
 	loff_t offset, end, map_end;
@@ -2921,6 +2920,7 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 		end = i_size_read(inode);
 
 	while (offset < end) {
+		struct folio *folio;
 		page_index = offset >> PAGE_SHIFT;
 		map_end = ((loff_t)page_index + 1) << PAGE_SHIFT;
 		if (map_end > end)
@@ -2933,9 +2933,10 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 			to = map_end & (PAGE_SIZE - 1);
 
 retry:
-		page = find_or_create_page(mapping, page_index, GFP_NOFS);
-		if (!page) {
-			ret = -ENOMEM;
+		folio = __filemap_get_folio(mapping, page_index,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_NOFS);
+		if (IS_ERR(folio)) {
+			ret = PTR_ERR(folio);
 			mlog_errno(ret);
 			break;
 		}
@@ -2945,9 +2946,9 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 		 * page, so write it back.
 		 */
 		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
-			if (PageDirty(page)) {
-				unlock_page(page);
-				put_page(page);
+			if (folio_test_dirty(folio)) {
+				folio_unlock(folio);
+				folio_put(folio);
 
 				ret = filemap_write_and_wait_range(mapping,
 						offset, map_end - 1);
@@ -2955,9 +2956,7 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 			}
 		}
 
-		if (!PageUptodate(page)) {
-			struct folio *folio = page_folio(page);
-
+		if (!folio_test_uptodate(folio)) {
 			ret = block_read_full_folio(folio, ocfs2_get_block);
 			if (ret) {
 				mlog_errno(ret);
@@ -2966,8 +2965,8 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 			folio_lock(folio);
 		}
 
-		if (page_has_buffers(page)) {
-			ret = walk_page_buffers(handle, page_buffers(page),
+		if (folio_buffers(folio)) {
+			ret = walk_page_buffers(handle, folio_buffers(folio),
 						from, to, &partial,
 						ocfs2_clear_cow_buffer);
 			if (ret) {
@@ -2978,12 +2977,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 
 		ocfs2_map_and_dirty_page(inode,
 					 handle, from, to,
-					 page, 0, &new_block);
-		mark_page_accessed(page);
+					 &folio->page, 0, &new_block);
+		folio_mark_accessed(folio);
 unlock:
-		unlock_page(page);
-		put_page(page);
-		page = NULL;
+		folio_unlock(folio);
+		folio_put(folio);
 		offset = map_end;
 		if (ret)
 			break;
-- 
2.45.2

