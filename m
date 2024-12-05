Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A46226ED3
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419031; cv=none; b=orPG0Ct37naDH+wewL7L4qqG5GDoNFTv7NY4nG6cx4kedxQU27Y0pAAYMEjht40TcJb243n7LQshqAVg7ROeWsE3omHl4bUpsSVTYH5BQTioFgkj7EWv3sU0WJekEP8ahqXavNVrU5vCnRIJMN4eI4lzOE3gBSZ7Z8rKO0YPD2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419031; c=relaxed/simple;
	bh=bPhplidBwP866DB1BHiMFKxsD6egrujx2QzIL0v5txw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7wFCUB28jXjIZxDfTqwOgXHVvem1GQ33GFCwn7SAI/VMm0meKpbIuSEKNTVD9l9H7ltMdAfqYQ8mFLV2uX+eyR8n/TtXya/f+YKFdVShkViSeSWf3rCSjaF/GfhO/kD4YvxzycW4LHHq7XYSJWS1CVWtgS8emh3+jMXTRx3fdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WZXMqiHR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WZXMqiHR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ZnDPC/cUztlHqoXv6mY9VL4Zs18mgm4ZZNHtdRsRqYk=; b=WZXMqiHRKtMMf6Vt0aYcwduXxR
	Wm6npG6W+vxDVcnwwl9HQL6T4PjNRmWsqXPaxadPkzLmtfSkiuFOHYCnrhRJFKXSXdJmJl2P5KqMh
	bjoftFOMQ4zN5Y5Al3RgrF2KLDwsXyt9sxO9ox9oGm8zF3DoEhmG3g40mTAe8IZMZzABy5e5qZfLo
	3nCFEnqoeS0HbXPW9IpTpk2cnNI4rDlPdvXuTlPvMrOh78DN2RTYqEVPb5B4rvZz65JsX6ZWz8ZCM
	nYpoA6wWcRgJEjQNisyj7QltDT/zjgU1WDTyg6GlSwW/YFG2auHLHBVS1tn+5a7AuB/+PVy+1At46
	yHuUztTg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLG1-0oid;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 07/23] ocfs2: Convert ocfs2_readpage_inline() to take a folio
Date: Thu,  5 Dec 2024 17:16:35 +0000
Message-ID: <20241205171653.3179945-8-willy@infradead.org>
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

Save a couple of calls to compound_head() by using a folio throughout
this function.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index aac644a0d25d..1896a1d24173 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -252,12 +252,12 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 	return 0;
 }
 
-static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
+static int ocfs2_readpage_inline(struct inode *inode, struct folio *folio)
 {
 	int ret;
 	struct buffer_head *di_bh = NULL;
 
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!folio_test_locked(folio));
 	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
 	ret = ocfs2_read_inode_block(inode, &di_bh);
@@ -266,9 +266,9 @@ static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
 		goto out;
 	}
 
-	ret = ocfs2_read_inline_data(inode, page, di_bh);
+	ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
 out:
-	unlock_page(page);
+	folio_unlock(folio);
 
 	brelse(di_bh);
 	return ret;
@@ -322,7 +322,7 @@ static int ocfs2_read_folio(struct file *file, struct folio *folio)
 	}
 
 	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-		ret = ocfs2_readpage_inline(inode, &folio->page);
+		ret = ocfs2_readpage_inline(inode, folio);
 	else
 		ret = block_read_full_folio(folio, ocfs2_get_block);
 	unlock = 0;
-- 
2.45.2

