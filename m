Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5CB224AF7
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419044; cv=none; b=Nk9+R5K4n31wRruM6Wt0IOZlNbtiobA3h/SdMLlWuJ9yh4pIJI3Cxewhl1fsPJF4LHBS68vswnapVUkjA5qAxUnJB3LLOSjHw7Fn+vRG8ytwtxyphxIPvJd3CDgDAJz9sewPuQdZ6XxiGKFekCE94ytHoZpQtMLqyB9f5M9HV3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419044; c=relaxed/simple;
	bh=WBaz6KPdmpk2jjKRn7lLXx2TvE7biahP7cOfgtphZ0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H60xAvYFM1qMpyb9WlCUkwk9EU980hTbtX8hk2TYtlXbdP3pOUnZSgC1RLehD+nCpJzm7MEdHensyH0S5Gjcwkjz8jrJot+FEPhepVAVTlD7BGXTXCvPiIdQ3iPLL9ggsTAxc/9p8mr78wB2hKEgb2KEhQTX7+QCXN4PhlkffKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rmbSQGYk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rmbSQGYk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=oF4SLrOsfX9v0GcUfxvLHj47dbwxFPNZfM1Y/e8rJnA=; b=rmbSQGYkt4+Kf+yqUsdPDbrRyU
	pXj3gLtxI6F4DB7cfEah0zMPd86BAbk7xjha22xIQwkkjXPlxfk1qKLen/w1STCatnSJ9B6sp+gnA
	mzlLL6P/HOwHc+aFG99RuDq5UcMyfMdjL5i5OUZ1XoiTtLcOOLMuUzALLIKePIAfWBcyeQyjDUrGb
	4OPFZAZMNv9JAwcky8DJy7XhBX/ei38o99E6F2zHZIDx/89du0fXusLz1LyHiqNh0enmRGvt0hW9S
	GP3xdZP7R12an7UPozIz8eXF4hjvbiNxH03PExKONdfEMBrRykAqDjgwmbfJRvxZx7fXfbZ+hzgYH
	Uj13TODQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLG6-1h56;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 09/23] ocfs2: Convert w_pages to w_folios
Date: Thu,  5 Dec 2024 17:16:37 +0000
Message-ID: <20241205171653.3179945-10-willy@infradead.org>
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

Pass around an array of folios instead of an array of pages.
Removes a few calls to compound_head().

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 118 ++++++++++++++++++++++++++----------------------
 fs/ocfs2/aops.h |   1 +
 2 files changed, 65 insertions(+), 54 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 161f2dc00b00..afc20ab52b3e 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -729,19 +729,19 @@ struct ocfs2_write_ctxt {
 	unsigned int			w_large_pages;
 
 	/*
-	 * Pages involved in this write.
+	 * Folios involved in this write.
 	 *
 	 * w_target_folio is the folio being written to by the user.
 	 *
-	 * w_pages is an array of pages which always contains
+	 * w_folios is an array of folios which always contains
 	 * w_target_folio, and in the case of an allocating write with
 	 * page_size < cluster size, it will contain zero'd and mapped
 	 * pages adjacent to w_target_folio which need to be written
 	 * out in so that future reads from that region will get
 	 * zero's.
 	 */
-	unsigned int			w_num_pages;
-	struct page			*w_pages[OCFS2_MAX_CTXT_PAGES];
+	unsigned int			w_num_folios;
+	struct folio			*w_folios[OCFS2_MAX_CTXT_PAGES];
 	struct folio			*w_target_folio;
 
 	/*
@@ -771,6 +771,19 @@ struct ocfs2_write_ctxt {
 	unsigned int			w_unwritten_count;
 };
 
+void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios)
+{
+	int i;
+
+	for(i = 0; i < num_folios; i++) {
+		if (!folios[i])
+			continue;
+		folio_unlock(folios[i]);
+		folio_mark_accessed(folios[i]);
+		folio_put(folios[i]);
+	}
+}
+
 void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 {
 	int i;
@@ -784,7 +797,7 @@ void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 	}
 }
 
-static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
+static void ocfs2_unlock_folios(struct ocfs2_write_ctxt *wc)
 {
 	int i;
 
@@ -795,16 +808,16 @@ static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
 	 */
 	if (wc->w_target_locked) {
 		BUG_ON(!wc->w_target_folio);
-		for (i = 0; i < wc->w_num_pages; i++) {
-			if (&wc->w_target_folio->page == wc->w_pages[i]) {
-				wc->w_pages[i] = NULL;
+		for (i = 0; i < wc->w_num_folios; i++) {
+			if (wc->w_target_folio == wc->w_folios[i]) {
+				wc->w_folios[i] = NULL;
 				break;
 			}
 		}
 		folio_mark_accessed(wc->w_target_folio);
 		folio_put(wc->w_target_folio);
 	}
-	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
+	ocfs2_unlock_and_free_folios(wc->w_folios, wc->w_num_folios);
 }
 
 static void ocfs2_free_unwritten_list(struct inode *inode,
@@ -826,7 +839,7 @@ static void ocfs2_free_write_ctxt(struct inode *inode,
 				  struct ocfs2_write_ctxt *wc)
 {
 	ocfs2_free_unwritten_list(inode, &wc->w_unwritten_list);
-	ocfs2_unlock_pages(wc);
+	ocfs2_unlock_folios(wc);
 	brelse(wc->w_di_bh);
 	kfree(wc);
 }
@@ -922,8 +935,8 @@ static void ocfs2_write_failure(struct inode *inode,
 	if (wc->w_target_folio)
 		ocfs2_zero_new_buffers(wc->w_target_folio, from, to);
 
-	for(i = 0; i < wc->w_num_pages; i++) {
-		tmppage = wc->w_pages[i];
+	for (i = 0; i < wc->w_num_folios; i++) {
+		tmppage = &wc->w_folios[i]->page;
 
 		if (tmppage && page_has_buffers(tmppage)) {
 			if (ocfs2_should_order_data(inode))
@@ -935,12 +948,11 @@ static void ocfs2_write_failure(struct inode *inode,
 	}
 }
 
-static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
-					struct ocfs2_write_ctxt *wc,
-					struct page *page, u32 cpos,
-					loff_t user_pos, unsigned user_len,
-					int new)
+static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
+		struct ocfs2_write_ctxt *wc, struct folio *folio, u32 cpos,
+		loff_t user_pos, unsigned user_len, int new)
 {
+	struct page *page = &folio->page;
 	int ret;
 	unsigned int map_from = 0, map_to = 0;
 	unsigned int cluster_start, cluster_end;
@@ -1019,11 +1031,9 @@ static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
 /*
  * This function will only grab one clusters worth of pages.
  */
-static int ocfs2_grab_pages_for_write(struct address_space *mapping,
-				      struct ocfs2_write_ctxt *wc,
-				      u32 cpos, loff_t user_pos,
-				      unsigned user_len, int new,
-				      struct folio *mmap_folio)
+static int ocfs2_grab_folios_for_write(struct address_space *mapping,
+		struct ocfs2_write_ctxt *wc, u32 cpos, loff_t user_pos,
+		unsigned user_len, int new, struct folio *mmap_folio)
 {
 	int ret = 0, i;
 	unsigned long start, target_index, end_index, index;
@@ -1040,7 +1050,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 	 * last page of the write.
 	 */
 	if (new) {
-		wc->w_num_pages = ocfs2_pages_per_cluster(inode->i_sb);
+		wc->w_num_folios = ocfs2_pages_per_cluster(inode->i_sb);
 		start = ocfs2_align_clusters_to_page_index(inode->i_sb, cpos);
 		/*
 		 * We need the index *past* the last page we could possibly
@@ -1050,15 +1060,15 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 		last_byte = max(user_pos + user_len, i_size_read(inode));
 		BUG_ON(last_byte < 1);
 		end_index = ((last_byte - 1) >> PAGE_SHIFT) + 1;
-		if ((start + wc->w_num_pages) > end_index)
-			wc->w_num_pages = end_index - start;
+		if ((start + wc->w_num_folios) > end_index)
+			wc->w_num_folios = end_index - start;
 	} else {
-		wc->w_num_pages = 1;
+		wc->w_num_folios = 1;
 		start = target_index;
 	}
 	end_index = (user_pos + user_len - 1) >> PAGE_SHIFT;
 
-	for(i = 0; i < wc->w_num_pages; i++) {
+	for(i = 0; i < wc->w_num_folios; i++) {
 		index = start + i;
 
 		if (index >= target_index && index <= end_index &&
@@ -1079,26 +1089,27 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 			}
 
 			folio_get(mmap_folio);
-			wc->w_pages[i] = &mmap_folio->page;
+			wc->w_folios[i] = mmap_folio;
 			wc->w_target_locked = true;
 		} else if (index >= target_index && index <= end_index &&
 			   wc->w_type == OCFS2_WRITE_DIRECT) {
 			/* Direct write has no mapping page. */
-			wc->w_pages[i] = NULL;
+			wc->w_folios[i] = NULL;
 			continue;
 		} else {
-			wc->w_pages[i] = find_or_create_page(mapping, index,
-							     GFP_NOFS);
-			if (!wc->w_pages[i]) {
-				ret = -ENOMEM;
+			wc->w_folios[i] = __filemap_get_folio(mapping, index,
+					FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					GFP_NOFS);
+			if (IS_ERR(wc->w_folios[i])) {
+				ret = PTR_ERR(wc->w_folios[i]);
 				mlog_errno(ret);
 				goto out;
 			}
 		}
-		wait_for_stable_page(wc->w_pages[i]);
+		folio_wait_stable(wc->w_folios[i]);
 
 		if (index == target_index)
-			wc->w_target_folio = page_folio(wc->w_pages[i]);
+			wc->w_target_folio = wc->w_folios[i];
 	}
 out:
 	if (ret)
@@ -1182,19 +1193,18 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 	if (!should_zero)
 		p_blkno += (user_pos >> inode->i_sb->s_blocksize_bits) & (u64)(bpc - 1);
 
-	for(i = 0; i < wc->w_num_pages; i++) {
+	for (i = 0; i < wc->w_num_folios; i++) {
 		int tmpret;
 
 		/* This is the direct io target page. */
-		if (wc->w_pages[i] == NULL) {
+		if (wc->w_folios[i] == NULL) {
 			p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
 			continue;
 		}
 
-		tmpret = ocfs2_prepare_page_for_write(inode, &p_blkno, wc,
-						      wc->w_pages[i], cpos,
-						      user_pos, user_len,
-						      should_zero);
+		tmpret = ocfs2_prepare_folio_for_write(inode, &p_blkno, wc,
+				wc->w_folios[i], cpos, user_pos, user_len,
+				should_zero);
 		if (tmpret) {
 			mlog_errno(tmpret);
 			if (ret == 0)
@@ -1493,12 +1503,12 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 		goto out;
 	}
 	/*
-	 * If we don't set w_num_pages then this folio won't get unlocked
+	 * If we don't set w_num_folios then this folio won't get unlocked
 	 * and freed on cleanup of the write context.
 	 */
 	wc->w_target_folio = folio;
-	wc->w_pages[0] = &folio->page;
-	wc->w_num_pages = 1;
+	wc->w_folios[0] = folio;
+	wc->w_num_folios = 1;
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1791,18 +1801,18 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	}
 
 	/*
-	 * Fill our page array first. That way we've grabbed enough so
+	 * Fill our folio array first. That way we've grabbed enough so
 	 * that we can zero and flush if we error after adding the
 	 * extent.
 	 */
-	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
-					 cluster_of_pages, mmap_folio);
+	ret = ocfs2_grab_folios_for_write(mapping, wc, wc->w_cpos, pos, len,
+			cluster_of_pages, mmap_folio);
 	if (ret) {
 		/*
-		 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
-		 * the target page. In this case, we exit with no error and no target
-		 * page. This will trigger the caller, page_mkwrite(), to re-try
-		 * the operation.
+		 * ocfs2_grab_folios_for_write() returns -EAGAIN if it
+		 * could not lock the target folio. In this case, we exit
+		 * with no error and no target folio. This will trigger
+		 * the caller, page_mkwrite(), to re-try the operation.
 		 */
 		if (type == OCFS2_WRITE_MMAP && ret == -EAGAIN) {
 			BUG_ON(wc->w_target_folio);
@@ -1997,8 +2007,8 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 	if (wc->w_target_folio)
 		flush_dcache_folio(wc->w_target_folio);
 
-	for(i = 0; i < wc->w_num_pages; i++) {
-		tmppage = wc->w_pages[i];
+	for (i = 0; i < wc->w_num_folios; i++) {
+		tmppage = &wc->w_folios[i]->page;
 
 		/* This is the direct io target page. */
 		if (tmppage == NULL)
@@ -2059,7 +2069,7 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 	 * this lock and will ask for the page lock when flushing the data.
 	 * put it here to preserve the unlock order.
 	 */
-	ocfs2_unlock_pages(wc);
+	ocfs2_unlock_folios(wc);
 
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 1cb46072ad84..dcf4b0dc82c4 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -17,6 +17,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new);
 
+void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios);
 void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages);
 
 int walk_page_buffers(	handle_t *handle,
-- 
2.45.2

