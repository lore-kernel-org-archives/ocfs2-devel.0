Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405FF374E8;
	Mon, 16 Oct 2023 20:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AtFTdGQ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=fi8Eq6tU4+7e9/mXSea+NKjhkEdSISChyP52Lf5yEEA=; b=AtFTdGQ4o7OhxTEzHtog4nTY2s
	Czbj4V3RFqns4xEx2QtWuyeAPYvlbrv2EkTmoe+YqvgbHn7bkTxc9Dlu3UepTZ0fhwMKh5IAPpEBU
	eenTAv9RPASKjXekhb65QbKhjEfcGTIIGd9BsXSOyZOImKZY8GbaFxWj784tnAeC/9fzDTKUV5bq/
	/T+7/2eNdv7bS7256cWCmIOja+6QXmkQJR03TkzwwSpq5PJB0P8SWRwYG5Mmpn6GCmv62sYKNhGWq
	sbbiLNEdiVMVnJxQvoM6Cb9t54mQuF8YhRDyQlhDEsRG9CVSxNYfB/JRj8xEqscF41zFU9EMYO4Ib
	UPxlizag==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qsTvo-0085aW-Rw; Mon, 16 Oct 2023 20:11:16 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 03/27] mpage: Convert map_buffer_to_folio() to folio_create_empty_buffers()
Date: Mon, 16 Oct 2023 21:10:50 +0100
Message-Id: <20231016201114.1928083-4-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231016201114.1928083-1-willy@infradead.org>
References: <20231016201114.1928083-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Saves a folio->page->folio conversion.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/mpage.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index 242e213ee064..964a6efe594d 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -119,8 +119,7 @@ static void map_buffer_to_folio(struct folio *folio, struct buffer_head *bh,
 			folio_mark_uptodate(folio);
 			return;
 		}
-		create_empty_buffers(&folio->page, i_blocksize(inode), 0);
-		head = folio_buffers(folio);
+		head = folio_create_empty_buffers(folio, i_blocksize(inode), 0);
 	}
 
 	page_bh = head;
-- 
2.40.1

