Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB23226ECA
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419027; cv=none; b=iOZDfi13vjAu8cQkxoxVEMfRTzP4qcvnT06ja+1bGmEDCRkdcp4oBDEIbVX5ptgZmR8dDOuYVcjSGUwF101FdvlCwB+q98rBwH2m0wxFgc+xjCboUPzy/HRrqDDqh5FT4s29GeaM0lETwmC8xvxD+gaGbP/tp+2pzK2+dodvRbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419027; c=relaxed/simple;
	bh=4uh3owOnSZjaoxsXk7FNl8fC0tvNlWWVruABwwaSTBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7NAlEC4of67rRmCN5jEVRVV30zSWwXtvG+ELtYGIogprT0CTkHIPVxLtQa/ZGyvTb2FAj+Y3MIMnJD6N5u/Bhrx/cJ2N7P/pNSH2k0GKT1f9J1lIhP2rdhYA+Mioa+e+Nd67NZnX3hQVcoCEdPRj/0yi/+4HIGiGWap7hP0sS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OZyqghzy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OZyqghzy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=MSdYppceXEYTjnc1aF0xWK0TT1quRWa2DyXPATPSFUs=; b=OZyqghzynm1UKAZbrZ/j7CW8xQ
	PHFlpYDR46nLS0YKoOUBwHJ2jtsQ56iVJ4QW4OBTR1s9sKmCWz2QEn4lCWkD0/PZzmlj6omRpBjME
	L+YHhnvS8sVoSK1b8NTG2VMbDIHyubmTwAeZg5RnYjdUmjHpzuTxvMTVgp8Db1C3F7AGlzqrgL6k0
	H0jtkT4gNp3CAIlO6m+Nl2JtUjk/X7JmDXQ0XEaiLOV6tSz00U+rTtHRBElH2zBQ+EAsLEfJcoKpa
	MK5GQlJFGuwpH6bCgJfGasH57Cjz9Rnja8khVob98kMbiD6ATKEzsFzzEA1U67nwGb7ZYPyRLvajR
	ofhOZTiA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLGA-22VM;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 10/23] ocfs2: Convert ocfs2_write_failure() to use a folio
Date: Thu,  5 Dec 2024 17:16:38 +0000
Message-ID: <20241205171653.3179945-11-willy@infradead.org>
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

Remove the folio->page conversion and just use the folio.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index afc20ab52b3e..8dda080743b7 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -930,20 +930,19 @@ static void ocfs2_write_failure(struct inode *inode,
 	int i;
 	unsigned from = user_pos & (PAGE_SIZE - 1),
 		to = user_pos + user_len;
-	struct page *tmppage;
 
 	if (wc->w_target_folio)
 		ocfs2_zero_new_buffers(wc->w_target_folio, from, to);
 
 	for (i = 0; i < wc->w_num_folios; i++) {
-		tmppage = &wc->w_folios[i]->page;
+		struct folio *folio = wc->w_folios[i];
 
-		if (tmppage && page_has_buffers(tmppage)) {
+		if (folio && folio_buffers(folio)) {
 			if (ocfs2_should_order_data(inode))
 				ocfs2_jbd2_inode_add_write(wc->w_handle, inode,
 							   user_pos, user_len);
 
-			block_commit_write(tmppage, from, to);
+			block_commit_write(&folio->page, from, to);
 		}
 	}
 }
-- 
2.45.2

