Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4510B226ECC
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419026; cv=none; b=Nc7IcVcxXstQhc1qeW8TMdmwJK5SMF2WrjQzXfSyrQmOjjdROFmcB7qK3YZ6L4wxKqcsW4T75rzSFJpHDr4az59xnExoauJDqFmzfxp/RQrQnF6FY0jdtfgMgV+kGE+AKQPbWdfNosYPrt8T/WNzbmdcVTP0fvbDmb+6034XBvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419026; c=relaxed/simple;
	bh=fQvv5Sl7EZkIHkeHfZ48z5PGkR9/ySURx28UcBtDb70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFeBlYxCjrO55G7yqy4SsJb434Vw5nxoZ8IsrrJQAkPEnZJrB/HckQLl5bQQzpC/ZN27yr5raVfz8Z6Jv4T0VNap+D5W8uPSvUZmGb3RwwXB0OwRYGYcFmlEHTvGX2vl6A+rBAMYXi25rSVSNQAXoAJ2a74qppxvPKa4AdKgxC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sdnUCJQ0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sdnUCJQ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ASxegapsLTTvXMrOJXt+9JDzCb9WinP9tSqjYHXc/JU=; b=sdnUCJQ0EAQffBYp3SnUmT79wo
	9MX+V/0QzGk4T8Mel2s0vw0ZpfkFVhj/1pIn74ioxG1EWFje2ucMCe1xoWO2jQGvmoDpPATikC0k4
	vTw1IjBH8ITtdaQq7tQOC4YI/Vyg7YCBwtfCM+5685Tl0bHtw109X4sZDSagIWlvBODNGN3cCW0w7
	Sr0mBf2DSfhITjqzhRJKcCnpujn4ZVPGxAz2LdKHNO+dGRmjbco7NhtSbwvlIrPxwGUsMP1NS29lu
	w16tOZkD4+6Btvq/FB96BB2S3M1DeDnafWZHAnopDvRu7i1vbR7N1sTIkzfitWqAW+FR3OXIElyby
	LMBBs7Ig==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLGE-2p0Z;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 12/23] ocfs2: Use a folio in ocfs2_prepare_page_for_write()
Date: Thu,  5 Dec 2024 17:16:40 +0000
Message-ID: <20241205171653.3179945-13-willy@infradead.org>
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

Update to the new APIs.  Removes a few page->folio conversions.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index cc252a1170ad..9ce8debbd282 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -963,10 +963,10 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
 	/* treat the write as new if the a hole/lseek spanned across
 	 * the page boundary.
 	 */
-	new = new | ((i_size_read(inode) <= page_offset(page)) &&
-			(page_offset(page) <= user_pos));
+	new = new | ((i_size_read(inode) <= folio_pos(folio)) &&
+			(folio_pos(folio) <= user_pos));
 
-	if (page == &wc->w_target_folio->page) {
+	if (folio == wc->w_target_folio) {
 		map_from = user_pos & (PAGE_SIZE - 1);
 		map_to = map_from + user_len;
 
@@ -990,7 +990,7 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
 		}
 	} else {
 		/*
-		 * If we haven't allocated the new page yet, we
+		 * If we haven't allocated the new folio yet, we
 		 * shouldn't be writing it out without copying user
 		 * data. This is likely a math error from the caller.
 		 */
@@ -1008,20 +1008,20 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
 	}
 
 	/*
-	 * Parts of newly allocated pages need to be zero'd.
+	 * Parts of newly allocated folios need to be zero'd.
 	 *
 	 * Above, we have also rewritten 'to' and 'from' - as far as
 	 * the rest of the function is concerned, the entire cluster
-	 * range inside of a page needs to be written.
+	 * range inside of a folio needs to be written.
 	 *
-	 * We can skip this if the page is up to date - it's already
+	 * We can skip this if the folio is uptodate - it's already
 	 * been zero'd from being read in as a hole.
 	 */
-	if (new && !PageUptodate(page))
+	if (new && !folio_test_uptodate(folio))
 		ocfs2_clear_page_regions(page, OCFS2_SB(inode->i_sb),
 					 cpos, user_data_from, user_data_to);
 
-	flush_dcache_page(page);
+	flush_dcache_folio(folio);
 
 out:
 	return ret;
-- 
2.45.2

