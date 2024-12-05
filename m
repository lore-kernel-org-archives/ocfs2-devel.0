Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734C5226EF5
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419053; cv=none; b=pxqDWcthZTsBIUiZH4AYu/2u89bL2VRxaqrUB8rlwHbbnS9p3ki8e7gj6P2SE8+NgTzO+5AlbOYOFLp2d5Mq8eMDI+kRJlc2+Gh97O6aja0oaRl4+JEO5UMixjXucqiLTLipNyejkag1tnQ73Bq/c9SzKiLOcSfqGMpXiMH1HIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419053; c=relaxed/simple;
	bh=WbZpgb0DkwTzuhnkaLq1TV9bIHxvUFhXyfXM/ATi154=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6GxoXvzWdtNwOHt2+vyo4JTS7XALw1VsJ6YUOa9M4lOGWZfRt83SsZY9LZbfERj6+ZL5N5zjUnHLOwYlHJHj8uXEKE+Ex+VQb0Vp4Z1xDciI1McMXwjzHd6AuZeM2ThV2UWEeOQ+dAOn68BT7KNY2IlXfAGL3MWPaaSkpCtjaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wE/kzu1u; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wE/kzu1u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=oakCT1/9KQ1DlvRVJ74ykpyRT/wbvBHytrGAJv8/tdw=; b=wE/kzu1u67Z9TBmJQeVnbFDdkw
	AoD1P75KcU9c4NTTC3r3VH8TJcag3eAjenOUnwrOfC62wpGPDn3h8y6JatQMbX4+L8qD3xgHbXdXt
	Wkeli8QIs7FgaasMgKIUYf0v1TP+951klHuK5GW7E5K6ifsyYJ8cVni0hO5MbAGoNE8RfBOTEqkyN
	q/R8buc63D5S2ayNJtsz/otpqcxnjo40gy1BoFheLCBNlzStZXo5dvYFDlh1FpsOtn9yqHrA+8JMz
	+dtso7YauRPjslL7KE3HLyMfSkU7tPh6+1XEJJkoLpMxbJpmV5h3YYCz3gasb8q8gnSEd4R3437Cq
	FOGHOdTg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLGL-403o;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 15/23] ocfs2: Convert ocfs2_clear_page_regions() to ocfs2_clear_folio_regions()
Date: Thu,  5 Dec 2024 17:16:43 +0000
Message-ID: <20241205171653.3179945-16-willy@infradead.org>
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

Pass in and use the folio instead of its page.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index cbc8bc6d95f3..644680ac1414 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -534,7 +534,7 @@ static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
  *
  * from == to == 0 is code for "zero the entire cluster region"
  */
-static void ocfs2_clear_page_regions(struct page *page,
+static void ocfs2_clear_folio_regions(struct folio *folio,
 				     struct ocfs2_super *osb, u32 cpos,
 				     unsigned from, unsigned to)
 {
@@ -543,7 +543,7 @@ static void ocfs2_clear_page_regions(struct page *page,
 
 	ocfs2_figure_cluster_boundaries(osb, cpos, &cluster_start, &cluster_end);
 
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_folio(folio, 0);
 
 	if (from || to) {
 		if (from > cluster_start)
@@ -554,7 +554,7 @@ static void ocfs2_clear_page_regions(struct page *page,
 		memset(kaddr + cluster_start, 0, cluster_end - cluster_start);
 	}
 
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 }
 
 /*
@@ -950,7 +950,6 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
 		struct ocfs2_write_ctxt *wc, struct folio *folio, u32 cpos,
 		loff_t user_pos, unsigned user_len, int new)
 {
-	struct page *page = &folio->page;
 	int ret;
 	unsigned int map_from = 0, map_to = 0;
 	unsigned int cluster_start, cluster_end;
@@ -1016,7 +1015,7 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
 	 * been zero'd from being read in as a hole.
 	 */
 	if (new && !folio_test_uptodate(folio))
-		ocfs2_clear_page_regions(page, OCFS2_SB(inode->i_sb),
+		ocfs2_clear_folio_regions(folio, OCFS2_SB(inode->i_sb),
 					 cpos, user_data_from, user_data_to);
 
 	flush_dcache_folio(folio);
-- 
2.45.2

