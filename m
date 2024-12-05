Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D41C226ED0
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419026; cv=none; b=ieQtcMA1yfa1jkapGEdAtdgYaEJgOlq7Avomgod4AuCAa/V2i2ofv5pPuYoVCcxGx7yi9qzlA2CF4Y8YrYLtU7xQAy1xdQPqLk3sXhN2Rpe+eeU6WFR1DlD/lj29Kh+VbrlmFhMmtuc18czw2bVC5UzIbL6ctBGs2R4JBfpW4b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419026; c=relaxed/simple;
	bh=DiQg3NuuAyB2fjqC6JhPRp+mTwmtiq5pRjM2vNzkIs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8ud1JglZm4tSVhUEIvmZfNRf8qrmbMbtcQjET8fbjIhze2R1CuleKbf8yrSDxl4YeB7yueC/E9Mr9OyZvpyn+LHkxMqaY7B+7dzCeM4Ea3Ywj8OCoVmfUwcWZBriV5bfjAIvaOmDaqZKd72HI3FhQvgIG0dJ8gJb+fEBQKV4DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NPIGsN0d; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NPIGsN0d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ydccpepzdYGSwuKz0r/ELU2Gl+SwBBvkmM9nlUYnk0s=; b=NPIGsN0di5QZ9M6yE5cDjSH/NN
	YHxHxEEiczirx9kMymJgOCshVnUS0oES92LwOnKVbuQHg4VQ8jLmAq2cwxyTLHZgBHq5Xz2pYQIlG
	nei9PuDkGS4BecNilk/6u+Fdg/YVi5Netq70HXV0TI66gQDjRPLvUdUsqOddNOrRloZd7hguqkdkj
	TeW9w5WoS02F73urPGqbi5259t2lQycztkxb2b5Isv+YPWgPUdJv7ZQAHuvbitbeo2WWOjc2PYYS8
	5hZmceXXBM3coo6nwprkF8motJ+fRIm5wQaWfsvDupA3L1/c4Q6BpO+7TpzSkLQ+gHO9Rv/VErdwM
	6x18xVJg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLGH-3CHM;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 13/23] ocfs2: Use a folio in ocfs2_map_and_dirty_page()
Date: Thu,  5 Dec 2024 17:16:41 +0000
Message-ID: <20241205171653.3179945-14-willy@infradead.org>
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

Convert the incoming page to a folio and use it throughout the
function.  Removes a couple of calls to compound_head().

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/alloc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 395e23920632..e95fe65b6a74 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6812,8 +6812,9 @@ void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
 			      unsigned int from, unsigned int to,
 			      struct page *page, int zero, u64 *phys)
 {
+	struct folio *folio = page_folio(page);
 	int ret, partial = 0;
-	loff_t start_byte = ((loff_t)page->index << PAGE_SHIFT) + from;
+	loff_t start_byte = folio_pos(folio) + from;
 	loff_t length = to - from;
 
 	ret = ocfs2_map_page_blocks(page, phys, inode, from, to, 0);
@@ -6821,14 +6822,14 @@ void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
 		mlog_errno(ret);
 
 	if (zero)
-		zero_user_segment(page, from, to);
+		folio_zero_segment(folio, from, to);
 
 	/*
 	 * Need to set the buffers we zero'd into uptodate
 	 * here if they aren't - ocfs2_map_page_blocks()
 	 * might've skipped some
 	 */
-	ret = walk_page_buffers(handle, page_buffers(page),
+	ret = walk_page_buffers(handle, folio_buffers(folio),
 				from, to, &partial,
 				ocfs2_zero_func);
 	if (ret < 0)
@@ -6841,9 +6842,9 @@ void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
 	}
 
 	if (!partial)
-		SetPageUptodate(page);
+		folio_mark_uptodate(folio);
 
-	flush_dcache_page(page);
+	flush_dcache_folio(folio);
 }
 
 static void ocfs2_zero_cluster_pages(struct inode *inode, loff_t start,
-- 
2.45.2

