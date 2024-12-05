Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF4F226EEF
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419052; cv=none; b=YhBcr1eaJchWByMu0SU2tdowcDgS2Zqgia1KiwUQnG4mY2SnXT0Sjq0/U1aaxuisl6i6MN6VGqlXQnkL2wImMZUea3HpbQzlZZ0N4zyOGa+ZgcHVj3vOWa30uIc+fN1naK9usYhYJk9wzXng64e/F0O1uFG2G0+sSpZI/L7bXMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419052; c=relaxed/simple;
	bh=8xeCXFK9ke36BvmkF3A55rGNSCrXBlAPeaXfPDdNDPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cF8Aj8gKd1moiHzduAH0GoQwEF1eMy2Gdo9Yjg4ai8uLxidz3+F4JaZqEGCKzqemRM45hlUezpkakjNgQbKmll+UjQiao2N/YTLK/Lv+cLRZ5vIXp7zdyKMbx1F7NxcTon6l0JCEQE5Pz+w9w3EXbY9EGPOcfU9ReP6n/OjCZhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d4Pd7YPT; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d4Pd7YPT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=cqsl7npi+nQUFIUhi0su7fzPscqJ/FxRPxJlndPcZiE=; b=d4Pd7YPTtJtByQhR2xoQaE/RAo
	HsIfIIyOJYfdzfWDeRv8rC2NnFHHkW4/nuLHYJXFoQroQEm8Dr6kG8oybu+qky7Q87kZdCJzZW0uD
	vxI9B5j7UHoKiu9FrZANStKNrO6Ov9eCfjHpRVSaVHFhnFZ0m7So9NPnjDE2YRjmjQvb4wrGeFJSf
	W9PXVqp1xL/kRxmN5gECwh2C4Qb7P1V9kN/eHBy+pMfYIJxtyvxAZt5hrot5htHmowgjbohhiN4Ry
	a6uPU26CNKYlO1Qzgr24kBFvILifRtAuzuryjqSQHz2UkMHy46ZhZwwbNHqJYP3NLHcueHE4XyX/c
	GlLCh4XQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTF-0000000DLFq-3dXB;
	Thu, 05 Dec 2024 17:16:57 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 03/23] ocfs2: Convert w_target_page to w_target_folio
Date: Thu,  5 Dec 2024 17:16:31 +0000
Message-ID: <20241205171653.3179945-4-willy@infradead.org>
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

Pass a folio around instead of a page.  Saves a few hidden calls to
compound_head() and removes a call to kmap_atomic().

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 63 ++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index db72b3e924b3..5f7a33335385 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -731,22 +731,22 @@ struct ocfs2_write_ctxt {
 	/*
 	 * Pages involved in this write.
 	 *
-	 * w_target_page is the page being written to by the user.
+	 * w_target_folio is the folio being written to by the user.
 	 *
 	 * w_pages is an array of pages which always contains
-	 * w_target_page, and in the case of an allocating write with
+	 * w_target_folio, and in the case of an allocating write with
 	 * page_size < cluster size, it will contain zero'd and mapped
-	 * pages adjacent to w_target_page which need to be written
+	 * pages adjacent to w_target_folio which need to be written
 	 * out in so that future reads from that region will get
 	 * zero's.
 	 */
 	unsigned int			w_num_pages;
 	struct page			*w_pages[OCFS2_MAX_CTXT_PAGES];
-	struct page			*w_target_page;
+	struct folio			*w_target_folio;
 
 	/*
 	 * w_target_locked is used for page_mkwrite path indicating no unlocking
-	 * against w_target_page in ocfs2_write_end_nolock.
+	 * against w_target_folio in ocfs2_write_end_nolock.
 	 */
 	unsigned int			w_target_locked:1;
 
@@ -791,18 +791,18 @@ static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
 	/*
 	 * w_target_locked is only set to true in the page_mkwrite() case.
 	 * The intent is to allow us to lock the target page from write_begin()
-	 * to write_end(). The caller must hold a ref on w_target_page.
+	 * to write_end(). The caller must hold a ref on w_target_folio.
 	 */
 	if (wc->w_target_locked) {
-		BUG_ON(!wc->w_target_page);
+		BUG_ON(!wc->w_target_folio);
 		for (i = 0; i < wc->w_num_pages; i++) {
-			if (wc->w_target_page == wc->w_pages[i]) {
+			if (&wc->w_target_folio->page == wc->w_pages[i]) {
 				wc->w_pages[i] = NULL;
 				break;
 			}
 		}
-		mark_page_accessed(wc->w_target_page);
-		put_page(wc->w_target_page);
+		folio_mark_accessed(wc->w_target_folio);
+		folio_put(wc->w_target_folio);
 	}
 	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
 }
@@ -869,8 +869,9 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
  * and dirty so they'll be written out (in order to prevent uninitialised
  * block data from leaking). And clear the new bit.
  */
-static void ocfs2_zero_new_buffers(struct page *page, unsigned from, unsigned to)
+static void ocfs2_zero_new_buffers(struct folio *folio, unsigned from, unsigned to)
 {
+	struct page *page = &folio->page;
 	unsigned int block_start, block_end;
 	struct buffer_head *head, *bh;
 
@@ -918,8 +919,8 @@ static void ocfs2_write_failure(struct inode *inode,
 		to = user_pos + user_len;
 	struct page *tmppage;
 
-	if (wc->w_target_page)
-		ocfs2_zero_new_buffers(wc->w_target_page, from, to);
+	if (wc->w_target_folio)
+		ocfs2_zero_new_buffers(wc->w_target_folio, from, to);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
@@ -954,7 +955,7 @@ static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
 	new = new | ((i_size_read(inode) <= page_offset(page)) &&
 			(page_offset(page) <= user_pos));
 
-	if (page == wc->w_target_page) {
+	if (page == &wc->w_target_folio->page) {
 		map_from = user_pos & (PAGE_SIZE - 1);
 		map_to = map_from + user_len;
 
@@ -1097,7 +1098,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 		wait_for_stable_page(wc->w_pages[i]);
 
 		if (index == target_index)
-			wc->w_target_page = wc->w_pages[i];
+			wc->w_target_folio = page_folio(wc->w_pages[i]);
 	}
 out:
 	if (ret)
@@ -1494,7 +1495,8 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 	 * If we don't set w_num_pages then this page won't get unlocked
 	 * and freed on cleanup of the write context.
 	 */
-	wc->w_pages[0] = wc->w_target_page = page;
+	wc->w_target_folio = page_folio(page);
+	wc->w_pages[0] = page;
 	wc->w_num_pages = 1;
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
@@ -1803,7 +1805,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		 * the operation.
 		 */
 		if (type == OCFS2_WRITE_MMAP && ret == -EAGAIN) {
-			BUG_ON(wc->w_target_page);
+			BUG_ON(wc->w_target_folio);
 			ret = 0;
 			goto out_quota;
 		}
@@ -1826,7 +1828,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 
 success:
 	if (foliop)
-		*foliop = page_folio(wc->w_target_page);
+		*foliop = wc->w_target_folio;
 	*fsdata = wc;
 	return 0;
 out_quota:
@@ -1924,18 +1926,15 @@ static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
 				   struct ocfs2_dinode *di,
 				   struct ocfs2_write_ctxt *wc)
 {
-	void *kaddr;
-
 	if (unlikely(*copied < len)) {
-		if (!PageUptodate(wc->w_target_page)) {
+		if (!folio_test_uptodate(wc->w_target_folio)) {
 			*copied = 0;
 			return;
 		}
 	}
 
-	kaddr = kmap_atomic(wc->w_target_page);
-	memcpy(di->id2.i_data.id_data + pos, kaddr + pos, *copied);
-	kunmap_atomic(kaddr);
+	memcpy_from_folio(di->id2.i_data.id_data + pos, wc->w_target_folio,
+			pos, *copied);
 
 	trace_ocfs2_write_end_inline(
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -1973,15 +1972,15 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 		goto out_write_size;
 	}
 
-	if (unlikely(copied < len) && wc->w_target_page) {
+	if (unlikely(copied < len) && wc->w_target_folio) {
 		loff_t new_isize;
 
-		if (!PageUptodate(wc->w_target_page))
+		if (!folio_test_uptodate(wc->w_target_folio))
 			copied = 0;
 
 		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
-		if (new_isize > page_offset(wc->w_target_page))
-			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
+		if (new_isize > folio_pos(wc->w_target_folio))
+			ocfs2_zero_new_buffers(wc->w_target_folio, start+copied,
 					       start+len);
 		else {
 			/*
@@ -1991,12 +1990,12 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 			 * put page & buffer dirty bits into inconsistent
 			 * state.
 			 */
-			block_invalidate_folio(page_folio(wc->w_target_page),
+			block_invalidate_folio(wc->w_target_folio,
 						0, PAGE_SIZE);
 		}
 	}
-	if (wc->w_target_page)
-		flush_dcache_page(wc->w_target_page);
+	if (wc->w_target_folio)
+		flush_dcache_folio(wc->w_target_folio);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
@@ -2005,7 +2004,7 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 		if (tmppage == NULL)
 			continue;
 
-		if (tmppage == wc->w_target_page) {
+		if (tmppage == &wc->w_target_folio->page) {
 			from = wc->w_target_from;
 			to = wc->w_target_to;
 
-- 
2.45.2

