Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5261C226ECF
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419027; cv=none; b=FOgTNShXRsRJvij/09by6ClYP0FCpzcVGbfDLN1rpwnI8wXLH2/crtY9Rwct2n4lYGIp2JGZiraNRmEJY8b1R4INxFN5A8H60papVICi/VWGwArSwmC5nRkJuzMEF85QpDtY8vLTLacLPNfdspz/ryCx0cGtdx9LYcn9mxROI84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419027; c=relaxed/simple;
	bh=q97iOLYZh28Pzi/NTDtDX1YEulKdraYnePyT6i7EKDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3wrfphBR5Yl+hstU7pXiviH8o6/dXduAxbfFU9xdhjusC5scF39VAvZLnBT8G5QepQc4EJFlLzXQYKTVGrA71ImHDPiJs4Cf73kPU/wq2bJXk2P/DNelooRQvtKGgZ+XduVJb+9HmEkxcA6RVsn+Ajz9QKrSuRtFKJEsUb1F28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fH65bsQQ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fH65bsQQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=OBUKwkpBr9YZoOfwJw0seJGO9CGQYHD0wrE36thU/L4=; b=fH65bsQQAr8YCu6PU3OIQmlUku
	2TDXAM3xVu7seMImy8lAL3gLO3/TDXyRAOv5JZ8mFEhczgb6G0UEekYXw8R/s4fe/wILaFg2eLxl6
	csFUDOIGX/CqSQ/brJhtZttQyBwEqduzoQ5fCNBRUqJ0sYciiln03BC/1DmDcsh7RCBPCuDbh94rT
	nlV5SXfrrYpNW/Fl37zGjIaZlf5fhTsGmltjCScdUXbA+NqQkLUJiYdoChku9idFdMaY7vzupFGEK
	T92UGPWhaKpfClwqy7Nq2uf/Ge0V9QNqAm6Xy2wcOjQdLzvHHCkSrCjFzY3EVyoJTmdJtjofjaOB9
	j3sd6Daw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLGC-2RKO;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 11/23] ocfs2: Use a folio in ocfs2_write_end_nolock()
Date: Thu,  5 Dec 2024 17:16:39 +0000
Message-ID: <20241205171653.3179945-12-willy@infradead.org>
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

Remove an access to page->index.  Remove some PAGE_SIZE assumptions.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 8dda080743b7..cc252a1170ad 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1952,17 +1952,16 @@ static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
 	     le16_to_cpu(di->i_dyn_features));
 }
 
-int ocfs2_write_end_nolock(struct address_space *mapping,
-			   loff_t pos, unsigned len, unsigned copied, void *fsdata)
+int ocfs2_write_end_nolock(struct address_space *mapping, loff_t pos,
+		unsigned len, unsigned copied, void *fsdata)
 {
 	int i, ret;
-	unsigned from, to, start = pos & (PAGE_SIZE - 1);
+	size_t from, to, start = pos & (PAGE_SIZE - 1);
 	struct inode *inode = mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_write_ctxt *wc = fsdata;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 	handle_t *handle = wc->w_handle;
-	struct page *tmppage;
 
 	BUG_ON(!list_empty(&wc->w_unwritten_list));
 
@@ -1993,32 +1992,32 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 					       start+len);
 		else {
 			/*
-			 * When page is fully beyond new isize (data copy
-			 * failed), do not bother zeroing the page. Invalidate
+			 * When folio is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the folio. Invalidate
 			 * it instead so that writeback does not get confused
 			 * put page & buffer dirty bits into inconsistent
 			 * state.
 			 */
-			block_invalidate_folio(wc->w_target_folio,
-						0, PAGE_SIZE);
+			block_invalidate_folio(wc->w_target_folio, 0,
+					folio_size(wc->w_target_folio));
 		}
 	}
 	if (wc->w_target_folio)
 		flush_dcache_folio(wc->w_target_folio);
 
 	for (i = 0; i < wc->w_num_folios; i++) {
-		tmppage = &wc->w_folios[i]->page;
+		struct folio *folio = wc->w_folios[i];
 
-		/* This is the direct io target page. */
-		if (tmppage == NULL)
+		/* This is the direct io target folio */
+		if (folio == NULL)
 			continue;
 
-		if (tmppage == &wc->w_target_folio->page) {
+		if (folio == wc->w_target_folio) {
 			from = wc->w_target_from;
 			to = wc->w_target_to;
 
-			BUG_ON(from > PAGE_SIZE ||
-			       to > PAGE_SIZE ||
+			BUG_ON(from > folio_size(folio) ||
+			       to > folio_size(folio) ||
 			       to < from);
 		} else {
 			/*
@@ -2027,19 +2026,17 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 			 * to flush their entire range.
 			 */
 			from = 0;
-			to = PAGE_SIZE;
+			to = folio_size(folio);
 		}
 
-		if (page_has_buffers(tmppage)) {
+		if (folio_buffers(folio)) {
 			if (handle && ocfs2_should_order_data(inode)) {
-				loff_t start_byte =
-					((loff_t)tmppage->index << PAGE_SHIFT) +
-					from;
+				loff_t start_byte = folio_pos(folio) + from;
 				loff_t length = to - from;
 				ocfs2_jbd2_inode_add_write(handle, inode,
 							   start_byte, length);
 			}
-			block_commit_write(tmppage, from, to);
+			block_commit_write(&folio->page, from, to);
 		}
 	}
 
-- 
2.45.2

