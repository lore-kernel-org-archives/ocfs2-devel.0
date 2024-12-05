Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A044222579F
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419023; cv=none; b=NlFII6sHJmBv6aL6AvhG6SyvrzBi/29/qcKJPHW53LAWghcKVL5WBEA9sjw5Qcz+rBmMVwrA1XRvTFvEd86n+lHRLlC1CjW1qwnH0V783qp2LMEHFyWVJL3qsUvGLf4tFCL2sNBHeg65EJmAZOd6hyATcvruoF8LbkVaK6h8cgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419023; c=relaxed/simple;
	bh=H1yOemQFTMZ0muW/AU4827FjAk2NFjOHZy55MorHuTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaNK1KqTNztciFvMRXU9S33BeGj2hZHfGkSZEU2hVrZskG/3zOArWI1Fw1ns72EE1kL7cVnRAap919zKIlBZW89Izdpt+3CpKC6zqdawTXUmQocXkCP3G0JA46Vo3un+xQMof15Ttx/228QIWh1yB9akQ5lAtVvwOeTFi1sgq8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hEDUeKmR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hEDUeKmR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=CAYIV0lvBXBf6GuA7JjRogDKn8RDhTxg8nqbcVw6i3E=; b=hEDUeKmRbVRaq2YH2iPYdRFLsk
	5E8w7nhYu5fvabpYB+jhX3HEXgHkgciSduU/2LQmulY/Tlr9BcvDPlSj15NWmX/8fbZvusGF8R8ez
	+RBR1yDGjYdlFdAf4XzkdM1jqdWxoVeP26b2Cx8YgNOO7UkoW0PRgJn8ladCGZjDmfgs/nEIpgqX+
	+8DpkAVGcGgi+XuvuCs0w17I4MHrrqgHYWPiqJILU3EyWFAxvm0NHTWtZZtUP7fCdZHm7QxmAS0Yn
	awCMjnuWHkH+CJMOFIlsQzWQBllkC10iieZhnTHidTWVsPMEbMEOJJovhaZsqTz/UFK7cbjVHPfvd
	KRcroegA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTH-0000000DLGf-3XgO;
	Thu, 05 Dec 2024 17:16:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 22/23] ocfs2: Support large folios in ocfs2_zero_cluster_folios()
Date: Thu,  5 Dec 2024 17:16:50 +0000
Message-ID: <20241205171653.3179945-23-willy@infradead.org>
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

Remove assumptions that a folio is one page in size.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/alloc.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 36b536b54a2d..3bff9314f8e0 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6851,7 +6851,6 @@ static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
 		u64 phys, handle_t *handle)
 {
 	int i;
-	unsigned int from, to = PAGE_SIZE;
 	struct super_block *sb = inode->i_sb;
 
 	BUG_ON(!ocfs2_sparse_alloc(OCFS2_SB(sb)));
@@ -6859,21 +6858,18 @@ static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
 	if (numfolios == 0)
 		goto out;
 
-	to = PAGE_SIZE;
 	for (i = 0; i < numfolios; i++) {
 		struct folio *folio = folios[i];
+		size_t to = folio_size(folio);
+		size_t from = offset_in_folio(folio, start);
 
-		from = start & (PAGE_SIZE - 1);
-		if ((end >> PAGE_SHIFT) == folio->index)
-			to = end & (PAGE_SIZE - 1);
-
-		BUG_ON(from > PAGE_SIZE);
-		BUG_ON(to > PAGE_SIZE);
+		if (to > end - folio_pos(folio))
+			to = end - folio_pos(folio);
 
 		ocfs2_map_and_dirty_folio(inode, handle, from, to, folio, 1,
 				&phys);
 
-		start = (folio->index + 1) << PAGE_SHIFT;
+		start = folio_next_index(folio) << PAGE_SHIFT;
 	}
 out:
 	if (folios)
-- 
2.45.2

