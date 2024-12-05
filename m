Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03EB22579E
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419023; cv=none; b=U1NAj1UZ04YOi8HZhSZhJ/rCB0pvTtaQxwEnpZkAXZAfCF2d+33YQXxEjlG7/zF5xUZCgjZdA5HCJLki8SLZwesJuva/O1c/5z4qZVlI3eirra8DtkxSbyj1QoDzR5KaF9m/ReS5SzOhVwKTfttuDeWWJluYEl4cF0QQStjU8+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419023; c=relaxed/simple;
	bh=K03pF7muZLmclFpyZ5HmSUYnwpW3zKL/boAmKJjUyCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAlpu0bjYzXof/PAItp6BT7h0kn/h6OL5SthxdgCCR0id8B7MYQypII4o9QlV3mV6GdBCPhI1UK+nUZxAczQbUZr8ugJY7v5gJ76Fb8SIPUTgsETBKt0/YdQDdKMA5QhRZKI4ZGjrl2vm2F9yxuk5SBj6oYd0izdzCUpidH4Uc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hDAlH0gD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hDAlH0gD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=GM5d3SLXzgiDV1eciPnvev6d2bEAOOquCnJNNKVhHV8=; b=hDAlH0gDrfghlPDqZx9ZhPnErb
	qaSGs1h0mzWcHcLiCJZoKgotpjOnA+NFgDm4dOQoB8GYLWlopYiig7Cu1n1kg6h7JNZ3rWp+wcnTD
	xD2m99xcDyoOmWrPR2/PLcXjebI7nfcAUfS1Smy8PUYAOo+dASGEzAgDeSAd7IOX/kCaCCXsRX8e1
	LRzQAPhEyrJCMYecbjHndvGo9ikTPLa1Ds4gzn7MioXZc8pvxwYJRZHVaMlghq+R3goEQjY7Yo8WF
	MSQIIqtU/7QTM//ZK9MrvdsEQb4aG637GQmQTbC6uZ3Qf3spHcHQlGvoZ2N8AY7B7reico777OvfY
	dUrS/Vfw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTH-0000000DLH4-42Ss;
	Thu, 05 Dec 2024 17:16:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 23/23] ocfs2: Support large folios in ocfs2_write_zero_page()
Date: Thu,  5 Dec 2024 17:16:51 +0000
Message-ID: <20241205171653.3179945-24-willy@infradead.org>
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

Remove assumptions that a folio is PAGE_SIZE.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 957ced628eb1..e54f2c4b5a90 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -782,11 +782,11 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 		goto out_commit_trans;
 	}
 
-	/* Get the offsets within the page that we want to zero */
-	zero_from = abs_from & (PAGE_SIZE - 1);
-	zero_to = abs_to & (PAGE_SIZE - 1);
+	/* Get the offsets within the folio that we want to zero */
+	zero_from = offset_in_folio(folio, abs_from);
+	zero_to = offset_in_folio(folio, abs_to);
 	if (!zero_to)
-		zero_to = PAGE_SIZE;
+		zero_to = folio_size(folio);
 
 	trace_ocfs2_write_zero_page(
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-- 
2.45.2

