Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B6C318B83;
	Mon, 25 May 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729588; cv=none; b=HiEL9A9QB9e3sFGv2zdYgCcsSsRxzUr6l/oaaRH9Vp5YX8+Zkt7zQQrSYKF7dgESjk/uA0+A2psZrln/A/XHd9qdr0/CVfN7air5VxTHifmCpgcwcSosjaDbFeJwgJAaZoXKjejIbQnsI5AKV0Gr8lNO/6Xcg9i4TSsGzXAKdEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729588; c=relaxed/simple;
	bh=TP1+1Lk/5mGaKfs6EpSZj8w3NKNZ1WfMCX+4CRVR0Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVVTyrcOyNvG6WDcYv2NskJTOWmmhlUeZS/XJenG9rinC198Ma/wmU8vpclhFP33AxKOIzH/CFCL49CF15ZTg78J9XU+UtpY2I8XqPgCQupNWKne7nVhZCq6mgLrViprxEIimheF9NWrIFCwAmrmwMDlWblpQpsRAACzprRVMAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J3eoDld1; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J3eoDld1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=SHWS88XAORHIjzvEt/MWAagagh9rTskXxOxpVG7tFNM=; b=J3eoDld1tHunBrluCfd8OQ+y/D
	G9SeMHo3NjsCLI1aq3bbFM5WAMRfFav0zboL88U0CigqUoU2QnB9063iJaxeErCDUm9agDcy3+4ka
	KRyVVqJhIPVlmuUhJ6E4HK/8FuSg9TvwdtnlRA73r1irPFroJNrIVsU1QvY2iwW0fku4GlDpPyD8a
	Yqlf7ZrckIKGy66cEKtiK8M8xOBCZYQVwO9GzHNAJGIlJWx8+H5oOlpygboxKuPDJLISlwqRBUzOc
	K6ks2nEoCnymt7rtZ07HNdL84yKiRA5bFMZNjBm5tfXtEonME0RMwNbZ78GiNj7hYXtFq1wiuEjVX
	SHGprKUg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxq-0000000HOBg-3tmK;
	Mon, 25 May 2026 17:19:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH 18/34] ocfs2: Convert ocfs2_write_block to bh_submit()
Date: Mon, 25 May 2026 18:19:11 +0100
Message-ID: <20260525171931.4144395-19-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525171931.4144395-1-willy@infradead.org>
References: <20260525171931.4144395-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call by using bh_submit() instead of
submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: ocfs2-devel@lists.linux.dev
---
 fs/ocfs2/buffer_head_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 701d27d908d4..3e42ca700db0 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -62,9 +62,8 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 	/* remove from dirty list before I/O. */
 	clear_buffer_dirty(bh);
 
-	get_bh(bh); /* for end_buffer_write_sync() */
-	bh->b_end_io = end_buffer_write_sync;
-	submit_bh(REQ_OP_WRITE, bh);
+	get_bh(bh); /* for bh_end_write() */
+	bh_submit(bh, REQ_OP_WRITE, bh_end_write);
 
 	wait_on_buffer(bh);
 
-- 
2.47.3

