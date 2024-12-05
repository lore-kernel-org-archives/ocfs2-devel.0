Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602D2226EF2
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419053; cv=none; b=jFL90HSpnp41lSb6XWDlrpS6qtPyzv3ap5dmw+IaQJtXUBn47oXAC8ulRak28m6iT2h9+2I9TFhIzYZW19uWJIhxEIEe5G3mwqjun+RlEletGEICGuIlzfVLB0V3ujNyOjpsB4qXubhqev1BbzC7BPtbs6EIBWZLTn3C1ONaK84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419053; c=relaxed/simple;
	bh=HCl20eVALTjXTp/pxsVCW9c1f6nWqHUrsxFDM6U5ZPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8BGRgdZbs87J7uapEM7ftdOiZH4F1zvt8N8j7HS7kA00NQq7W8Ce0NxHa4NO8mx0Sxq/wIicAbjBk+Di1xosZ1a/o2m4FmKOGMZQRQlVnUlHussF+n9EO+nbqyAKSJ5KFZho+5yAZ05X21arDZo2ENY+/rKtF6UWOTw7q5AWe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lhPHOVA1; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lhPHOVA1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=BSqXbzYdnaJzeQ/U3q7JbAVD/yve3KYdDozgTsBb6WY=; b=lhPHOVA1rvxytxIKjVgTNqg4W5
	oA4dh6xzuA/gzFHekTaJ+kZaCP/icuCuI2FB0QMT8wYveeNIy0xpz3QMR4h3Ve7DdixaUjuS4UY2N
	GD/h33nhn4rP133BjXMEh44b49+rJcrvp7tldb2eKUBXc2ByziAvEgz0Cbb5a4HcSqvycPRTYnNSt
	hpla2o4yXSKT7gCYgMIph7oAh53kFtCZrymwJG7YSTwf/pd8Caee9nQoDrjH6mJOOeEA/vUTt5JnO
	PtS6t/2sZksWopozaJH6E10ysEBKAGie/OoD3S5rcRWQiS4Ihdhqcgt9WWNdnMbrn/IYFwOOXBwZl
	0lEpO0zg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTH-0000000DLGd-2wXk;
	Thu, 05 Dec 2024 17:16:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	ocfs2-devel@lists.linux.dev,
	Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH 21/23] ocfs2: Remove ocfs2_start_walk_page_trans() prototype
Date: Thu,  5 Dec 2024 17:16:49 +0000
Message-ID: <20241205171653.3179945-22-willy@infradead.org>
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

This function no longer exists.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 6f25066e5756..114efc9111e4 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -8,11 +8,6 @@
 
 #include <linux/fs.h>
 
-handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
-							 struct page *page,
-							 unsigned from,
-							 unsigned to);
-
 int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new);
-- 
2.45.2

