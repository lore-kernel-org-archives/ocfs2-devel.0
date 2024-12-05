Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35564226EC0
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419027; cv=none; b=HL94hdVA+KhniKF6uSfxExM0TodLn0pvZdckC0sLBIfU4GjHVcF8kABisb+ZN2qXH+wEwIR+lcnMdkRwWUvnlwuUb3gkhas4CQHGn3MN57Of8HBrDv5xgzxjWN4Sa9LatfeCpu+ZIQYq1dZmSfcvQRB6Jqa9Nb7FopB8YHw3wi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419027; c=relaxed/simple;
	bh=W2v4rWsDi/D2SdB5Ty8FhLHqH2YU7rifzTjjEU9FzpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STVZEXz4BBGwGi3pSxOrvOrji5P8THzDGt9go+KGKH/i1RFzQKzOJmqZ5o5QzHQEicy75c6M3BgRRWuDg3oHgt+XAAFEJzuT8tqxEGSpZvE1CyD4IkbCZ3kFuA0vInbmuVrnbZ4qiE1oejHWjhoouaSpH6ruvdPwMlcBXVEkikk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WoRS9W+9; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WoRS9W+9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=aoFBEJy3t2lnyigM9xGluV10jv+W6viEU9rPL1tW/Vs=; b=WoRS9W+9R6Ak4QN1zsjVAGB0+V
	yKF+ildHMDvckh3zicpMcBH/PgnVneVm4EDFBsLkTozjiAuiSxO3+SjizfMBIzBA5SaTw3j/sZyKD
	K7h3/rGBkpS3XCuUV9CfXeSesoZoOC6Tq13qx/p78LHZHlXavWt5k/Cb+wmQ+e1rv0ccAZ6Uhsv/n
	xcGSCsqsD3e4AnOanN44675+Atj0VvTHpUn2Y6yg/I1PimvAP80LFEG+1wNvfFw9tCMmHqzqStXtZ
	+yoMF6067PWm3qi2BAfT0yGNw+gXJIiVHHe7/P/Rs2mxp9zol/D8EmH2CTJEO+YaicpB8OYZovLI7
	4GoUF2MA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTH-0000000DLGb-2aP0;
	Thu, 05 Dec 2024 17:16:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	ocfs2-devel@lists.linux.dev,
	Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH 20/23] ocfs2: Use a folio in ocfs2_fast_symlink_read_folio()
Date: Thu,  5 Dec 2024 17:16:48 +0000
Message-ID: <20241205171653.3179945-21-willy@infradead.org>
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

Use folio_end_read() instead of SetPageUptodate() and unlock_page().
Use memcpy_to_folio() instead of open-coding a kmap_atomic() sequence.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/symlink.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index f5cf2255dc09..ad8be3300b49 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -54,13 +54,11 @@
 
 static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
 {
-	struct page *page = &folio->page;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct buffer_head *bh = NULL;
 	int status = ocfs2_read_inode_block(inode, &bh);
 	struct ocfs2_dinode *fe;
 	const char *link;
-	void *kaddr;
 	size_t len;
 
 	if (status < 0) {
@@ -72,12 +70,9 @@ static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
 	link = (char *) fe->id2.i_symlink;
 	/* will be less than a page size */
 	len = strnlen(link, ocfs2_fast_symlink_chars(inode->i_sb));
-	kaddr = kmap_atomic(page);
-	memcpy(kaddr, link, len + 1);
-	kunmap_atomic(kaddr);
-	SetPageUptodate(page);
+	memcpy_to_folio(folio, 0, link, len + 1);
 out:
-	unlock_page(page);
+	folio_end_read(folio, status == 0);
 	brelse(bh);
 	return status;
 }
-- 
2.45.2

