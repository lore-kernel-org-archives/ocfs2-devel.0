Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9CB400DE8;
	Thu, 28 May 2026 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989523; cv=none; b=jiWDVwrGS+AeClp2Rdxi6pjtHah6RmFv86BqtSppjzUZ/VQbcwngkt69cByiCLSPER1LhTnFZHzxAnv+8i65tLu15AOiuO0ItU2XPksJnVDxz+JCTvSjBsNMMWt+odoiokm1WrJS9juvbCMgbUd2N/yD3tCW8OjF9VUItqhYlGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989523; c=relaxed/simple;
	bh=TEiphIOSVYR2arTGi4IZuyIj28/S8bL11U/VngVgStw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYdQJdgLBIiKOoKFb1ZZrR1mFU3R6qy0IsfjIT40+3qphqNFeVyza+Z5Ui2I6OoKm56H6ypo45LKz8N7C56o1sCJ6re1d12dglR8S6JQCoNQH4GihyCBoQpjzbrKJkBBr4Z4m1tMyH+0QxFRbnpH0Axz5fJZNjeig1lnknzAQSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RkYMoZVS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RkYMoZVS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=sXTBtTfArVroZkZllqM2/LTw91XT0IgR5HT8XrWfs98=; b=RkYMoZVSui/0fOm6B/6l20QlxF
	FPgu8Hopfat83ZfPDB3iUDgOc7l93jcNP1PDvg/2yzzuTjJpFYylF9VfBNykZR8qnY/ed79WAnt2v
	VcAhXC6/Eqo/B1YVwwmt5wJUiysJp+w0vr2yWOKVlSMmLSF503plk9wgzcJCdUyTVDBXnxN0jRJoX
	WgaFJHCX4tzk5GpOx5OonnADxIYptVbJ8hcOWE7MitBKgNddvpXA/gvRqlefccQaUxuqC6pBNGnd3
	DtUDcPuDD7BNnMS70RkgFhD+86JCZ/Nr8WBM79/7OREo6cvQuE7EoI+D9K3K1Znl0KGpErLtP6tyk
	QAgK8wEg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaK-00000004aaJ-0NJ9;
	Thu, 28 May 2026 17:31:56 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2 21/34] ocfs2: Convert ocfs2_write_super_or_backup to bh_submit()
Date: Thu, 28 May 2026 18:31:34 +0100
Message-ID: <20260528173150.1093780-22-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528173150.1093780-1-willy@infradead.org>
References: <20260528173150.1093780-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call and changing the buffer refcount
by using bh_submit() instead of submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
---
 fs/ocfs2/buffer_head_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 185ff4dcba75..8e67eba70674 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -440,10 +440,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 	/* remove from dirty list before I/O. */
 	clear_buffer_dirty(bh);
 
-	get_bh(bh); /* for end_buffer_write_sync() */
-	bh->b_end_io = end_buffer_write_sync;
 	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &di->i_check);
-	submit_bh(REQ_OP_WRITE, bh);
+	bh_submit(bh, REQ_OP_WRITE, bh_end_write);
 
 	wait_on_buffer(bh);
 
-- 
2.47.3

