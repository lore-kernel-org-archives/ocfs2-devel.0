Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDE532AAC5;
	Mon, 25 May 2026 17:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729587; cv=none; b=ulnoEtKDSe8EfIYnMwKeM9gp2FMa5UAAx5WJCUQHa93zGL10stM/+ZFiNYaBJFQYSMqGB36KnmO7ogrN+bjSxsjdqd9hO2pZaDuHsv+lP2V0wqJkR6eHXSz0sxkbY/FGAsXjx91gk02jwmuf985/1Cpogqf1U6/Yi/cqiQr34Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729587; c=relaxed/simple;
	bh=v140USIjGD+n/MUWkKoakXj+hC17oOV3oOWlaNAIwF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WadUPJPPh3Um26XoBlzD0UyPFs2JBgVU1H6QZ7gq/GhP4oggJK4VZpHnkMhdx8hVBt+qYXGKLi9aYGUnznV4gK8wNwXFT9PguBzy8zT9M9/4OGfIx4dGSUV245feh1KvwlnQ/S1AmJJ2wGwamPhYFaNpNyh4E17wONLe8nrEAL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rTzXh7wm; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rTzXh7wm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=edFuG1xSQtXLL5WQt19+8me8K5OhX8MR8XB3CoTRG/M=; b=rTzXh7wm/adNXjhminM9JoSv5B
	Oy9axozA7zJlgtXMQKzDY5+0PjhJrJeFPE0y93muDAb+VWwmkTztevSytqmPL1479UKVeVYGrD84O
	3vwAMayd+TLQA2ol8RYXX2rRGfihyKfFJuoqcLoIpyt1ZPcgfHUbEOvJJwjMti/nC2kMubC2wUxt2
	qYJdAO+J43xPqtmHhOq+F1JB4b5ahbVIQMdVMl+c/XiDdzimDxtJpngBNIctOh5wziPB6osglT0X4
	v07C8M7s04uyuDT5WyokT3PTUJYuTErJVXXBuHynN/J8JWzDthqgUSZrtDKY1SMIPmVmLO0ctyC7e
	CdbpYPzw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxr-0000000HOC9-28rL;
	Mon, 25 May 2026 17:19:43 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH 21/34] ocfs2: Convert ocfs2_write_super_or_backup to bh_submit()
Date: Mon, 25 May 2026 18:19:14 +0100
Message-ID: <20260525171931.4144395-22-willy@infradead.org>
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
index 4d3f03f99a8a..5894ab511b58 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -443,10 +443,9 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 	/* remove from dirty list before I/O. */
 	clear_buffer_dirty(bh);
 
-	get_bh(bh); /* for end_buffer_write_sync() */
-	bh->b_end_io = end_buffer_write_sync;
+	get_bh(bh); /* for bh_end_write() */
 	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &di->i_check);
-	submit_bh(REQ_OP_WRITE, bh);
+	bh_submit(bh, REQ_OP_WRITE, bh_end_write);
 
 	wait_on_buffer(bh);
 
-- 
2.47.3

