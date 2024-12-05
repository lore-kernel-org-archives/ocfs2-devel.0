Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7DB226ED3
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419027; cv=none; b=dSGDhwLVYXDEl5pQSoq2T7yEFezu+EsSwB4Thkd1l9lCQ87GWGwiLhUcOmlVDajXHeO6Ud9L5+qUcxJI6G29yIuwL0mIynYigRL4UJmDNYf92OMHkIw9duQSfZEq1nUyIQz8S7yUIw8xgNW+yLrepEFgFxRwBnFNiCOBGR6nHQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419027; c=relaxed/simple;
	bh=iseqTKMUGGF0fJcPqMbTcFfGBO8QqW/NoVRKhiEaVJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AueE3VocBTROQWyvXNAYb2CrSYQn8/nVFGFle2KR78cCeaNBTbBbxltAioGm8lDfaCm2rSkmOd2opSnCPCditc92jerTA4mzSp4/xMqXmKakBQsKEeYpWrefozFX9gN1hdPKu5q2Y21tN3a04Ex7pBbwphaHsdWCV+UjcFoyoO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PWTPYqac; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PWTPYqac"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=dMxMCc0P/c8cd0V+QxP09KCPIo99vuZeMhIz5rvBEaY=; b=PWTPYqacJekKIKIAXJmc8hi3Qj
	BQJVU/EBShK4Phxw7anMcovqNIoBJsyDDFiaNS77weSeQw/j9hipbJ/uJGr2JoPz0/UpoebjbltMv
	xGayw0q9L6y3nFUZzO5LnDaI3E9Imj91PtLwiGBvnEzvulwUaPvWEHjdJDxRKRv/CPZrtGkAsLZux
	6g3q0FbO7lr3C1AJofgXEJe1D8QWx0VOglZU8MQiwA2tQgI435Ssm0CCkSJ4X6djTftvDzhkSx3yA
	9vYz6/joTSDyNtlpqwdlsIFYJS4t18YpYnXixb/F0pqwFJtWvmqPYuXE6rSnTbuDiFg9gxNRXsdaw
	tisU7wmw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLGJ-3av3;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 14/23] ocfs2: Convert ocfs2_map_page_blocks() to ocfs2_map_folio_blocks()
Date: Thu,  5 Dec 2024 17:16:42 +0000
Message-ID: <20241205171653.3179945-15-willy@infradead.org>
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

All callers now have a folio, so pass it in instead of converting
folio->page->folio.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/alloc.c |  2 +-
 fs/ocfs2/aops.c  | 18 ++++++++----------
 fs/ocfs2/aops.h  |  2 +-
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index e95fe65b6a74..cfe9535a27f9 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6817,7 +6817,7 @@ void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
 	loff_t start_byte = folio_pos(folio) + from;
 	loff_t length = to - from;
 
-	ret = ocfs2_map_page_blocks(page, phys, inode, from, to, 0);
+	ret = ocfs2_map_folio_blocks(folio, phys, inode, from, to, 0);
 	if (ret)
 		mlog_errno(ret);
 
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 9ce8debbd282..cbc8bc6d95f3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -560,7 +560,7 @@ static void ocfs2_clear_page_regions(struct page *page,
 /*
  * Nonsparse file systems fully allocate before we get to the write
  * code. This prevents ocfs2_write() from tagging the write as an
- * allocating one, which means ocfs2_map_page_blocks() might try to
+ * allocating one, which means ocfs2_map_folio_blocks() might try to
  * read-in the blocks at the tail of our file. Avoid reading them by
  * testing i_size against each block offset.
  */
@@ -585,11 +585,10 @@ static int ocfs2_should_read_blk(struct inode *inode, struct folio *folio,
  *
  * This will also skip zeroing, which is handled externally.
  */
-int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
+int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new)
 {
-	struct folio *folio = page_folio(page);
 	int ret = 0;
 	struct buffer_head *head, *bh, *wait[2], **wait_bh = wait;
 	unsigned int block_end, block_start;
@@ -971,12 +970,11 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
 		map_to = map_from + user_len;
 
 		if (new)
-			ret = ocfs2_map_page_blocks(page, p_blkno, inode,
-						    cluster_start, cluster_end,
-						    new);
+			ret = ocfs2_map_folio_blocks(folio, p_blkno, inode,
+					cluster_start, cluster_end, new);
 		else
-			ret = ocfs2_map_page_blocks(page, p_blkno, inode,
-						    map_from, map_to, new);
+			ret = ocfs2_map_folio_blocks(folio, p_blkno, inode,
+					map_from, map_to, new);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -999,8 +997,8 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
 		map_from = cluster_start;
 		map_to = cluster_end;
 
-		ret = ocfs2_map_page_blocks(page, p_blkno, inode,
-					    cluster_start, cluster_end, new);
+		ret = ocfs2_map_folio_blocks(folio, p_blkno, inode,
+				cluster_start, cluster_end, new);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index dcf4b0dc82c4..17ca359c6051 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -13,7 +13,7 @@ handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
 							 unsigned from,
 							 unsigned to);
 
-int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
+int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new);
 
-- 
2.45.2

