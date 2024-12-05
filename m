Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A329922579D
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419026; cv=none; b=io5NyNoQrSiAhOGsfeEeOgsWscAZHHB0gWsA6BuMtM2Dvhvv/XiDfXsyE+0IEp4Gl6D0kgSuRR4IWXu+b/RXSbmWf6vwlBuzWOP0uuR2mq1RykG2uCz7C2HWMPM8wbBABW7FQYwFtqFOyRBuZFOem//VNC674iFF+klf7pPOyzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419026; c=relaxed/simple;
	bh=vIU8SOwv+D850DeH5NGDvqee10MXn1jBfQenmaOAJY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiDf6GtVdMi3eT4Ja/D0wyM9n1dInsZ74Yy0Ezirlag5ud4tO6DsEuWB49iJMO6PiY3I5xSsvF//tmGlWJ7CIanj4H7ewsgtOLopR9sz54hVn+Kh7TLpuO1CK7nBwQOuMRzG7WNCWTTX+b+b1hKTiA7sz6MZThwMrTL/rDk/HiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VFrfG9Qh; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VFrfG9Qh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=r96vd6xrwukyFRDIBh14pXq1M2Bi+IpWAVGrU2Z4o9o=; b=VFrfG9QhqYp/C96Voz2kPpQI3G
	42Z7YUlMsXoA2QrB/0nfB3UgLERK188EEbf2Sb1jeRNY7vEG7yc1ilhSFxO0b/sOMe//l0fY2hlqy
	Vz7lYIDw78zF52XNLNNZl1ndoxZr8dRtu/i94hXtFi8D2st8WamxordiACBuC0qVU5Y5dWBJCvidR
	vigUBWMvYheBjxvh50hZQgZ35PvY7/rMv7++O2utABzEqtKGGVZhJH61UFw3VV3YMez4bBqYqHOmf
	YCiAZ19KdabPL0otqMlhCk3EHxdG7gLnZxU6/m3or1tJp7XUHNSwuGmnsDzZ65VsGl5VGVLV92bUT
	dPp3QoJw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTF-0000000DLFv-3xat;
	Thu, 05 Dec 2024 17:16:57 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 04/23] ocfs2: Use a folio in ocfs2_zero_new_buffers()
Date: Thu,  5 Dec 2024 17:16:32 +0000
Message-ID: <20241205171653.3179945-5-willy@infradead.org>
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

Convert to the new APIs, saving at least one hidden call to
compound_head().

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 5f7a33335385..a1fad246765a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -869,30 +869,30 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
  * and dirty so they'll be written out (in order to prevent uninitialised
  * block data from leaking). And clear the new bit.
  */
-static void ocfs2_zero_new_buffers(struct folio *folio, unsigned from, unsigned to)
+static void ocfs2_zero_new_buffers(struct folio *folio, size_t from, size_t to)
 {
-	struct page *page = &folio->page;
 	unsigned int block_start, block_end;
 	struct buffer_head *head, *bh;
 
-	BUG_ON(!PageLocked(page));
-	if (!page_has_buffers(page))
+	BUG_ON(!folio_test_locked(folio));
+	head = folio_buffers(folio);
+	if (!head)
 		return;
 
-	bh = head = page_buffers(page);
+	bh = head;
 	block_start = 0;
 	do {
 		block_end = block_start + bh->b_size;
 
 		if (buffer_new(bh)) {
 			if (block_end > from && block_start < to) {
-				if (!PageUptodate(page)) {
+				if (!folio_test_uptodate(folio)) {
 					unsigned start, end;
 
 					start = max(from, block_start);
 					end = min(to, block_end);
 
-					zero_user_segment(page, start, end);
+					folio_zero_segment(folio, start, end);
 					set_buffer_uptodate(bh);
 				}
 
-- 
2.45.2

