Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A20224AFB
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419046; cv=none; b=k+0yQCcGKEOO7cRM1r4QhXgLBjuJtJj5L8vxBOsCF8MlLVDLweRXmz9EjzMyij3/Pt8cNXZ9trRlCO1IAIdMWiIokfFa9vW8DwA8L9sOsEICjIjFx9eFiy5GaZzAjjrSiLqNW2wXHNV7lEYo2FrsSA5eiysYPsK67+G6eIlP3kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419046; c=relaxed/simple;
	bh=tswV19BVMIyYZNvmb+Y+lCWAP2p2euXsalogCtQprKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuoRVNc6q0fkuzHLAcvh+pVW1T9kevLLUoV5QrUMzoe5WejeuNn+JWGeP5cY3HTNrq+ggsOABzXC9J2ai5RxYwaw/2jrdlv+2sbae6yP+WXEtij7NKw1O4h1Ll3hRD50iQO2HkdHK6FgFgPK50KnTJg6SYjSCnW6fjJLi5Mb+AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SUIBUvQf; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SUIBUvQf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=vTTd32Vu3Z1fLZgXuc24Lick32tqUIHO5MQvNSIx5Cc=; b=SUIBUvQfNcSS1kiDMD1IpdlKtc
	SLmCioFg3cZ/nOBborKuY4D51nspR1FM7/BILAn+EYlwHQP8tLC4pkqEmD2OO96aulmVjbiyMdBCD
	FTg6TxhlwS3vZAr2uEwjzoSC/UYHjCjKQZA3nlfSE7spbRcEDH+aYUQe/lTW/U9SPZKESlHJkcwAp
	bKuQWGd0r2hkuofc5YujrNc6GX0bRFwBZVabDYK3vNGP7OgYv6Q/z0lfzYn3z2BJc+FjcCyPJ4nGJ
	jBWylcllUP8EXqwWNcD1wh6gwRr6dRVtHIEAJwO/BP0D2hGhYCJ3XpPDH6uqblZPut9e8taiwnuxr
	QE4lpNJw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLFx-06oy;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 05/23] ocfs2: Use a folio in ocfs2_write_begin_inline()
Date: Thu,  5 Dec 2024 17:16:33 +0000
Message-ID: <20241205171653.3179945-6-willy@infradead.org>
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

Retrieve a folio from the page cache instead of a page and use that
folio throught the function.  Saves a couple of calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index a1fad246765a..c5e9c3462b84 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1473,7 +1473,7 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 {
 	int ret;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct page *page;
+	struct folio *folio;
 	handle_t *handle;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 
@@ -1484,19 +1484,20 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 		goto out;
 	}
 
-	page = find_or_create_page(mapping, 0, GFP_NOFS);
-	if (!page) {
+	folio = __filemap_get_folio(mapping, 0,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_NOFS);
+	if (IS_ERR(folio)) {
 		ocfs2_commit_trans(osb, handle);
-		ret = -ENOMEM;
+		ret = PTR_ERR(folio);
 		mlog_errno(ret);
 		goto out;
 	}
 	/*
-	 * If we don't set w_num_pages then this page won't get unlocked
+	 * If we don't set w_num_pages then this folio won't get unlocked
 	 * and freed on cleanup of the write context.
 	 */
-	wc->w_target_folio = page_folio(page);
-	wc->w_pages[0] = page;
+	wc->w_target_folio = folio;
+	wc->w_pages[0] = &folio->page;
 	wc->w_num_pages = 1;
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
@@ -1511,8 +1512,8 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL))
 		ocfs2_set_inode_data_inline(inode, di);
 
-	if (!PageUptodate(page)) {
-		ret = ocfs2_read_inline_data(inode, page, wc->w_di_bh);
+	if (!folio_test_uptodate(folio)) {
+		ret = ocfs2_read_inline_data(inode, &folio->page, wc->w_di_bh);
 		if (ret) {
 			ocfs2_commit_trans(osb, handle);
 
-- 
2.45.2

